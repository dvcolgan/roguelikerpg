local G = require('constants')
local MarchingSquares = require('marchingsquares')
local vector = require('vector')
local util = require('util')


local Physics = {}
Physics.vertexGroupSets = {}
love.physics.setMeter(G.TILE_SIZE)
Physics.worlds = {}
Physics.objectSets = {}

Physics.currentWorld = nil
Physics.currentObjects = {}
Physics.currentVertexGroups = {}

Physics.paused = false


function Physics:activateRoom(key)
    Physics.currentWorld = Physics.worlds[key]
    Physics.currentObjects = Physics.objectSets[key]
    Physics.currentVertexGroups = Physics.vertexGroupSets[key]
end

function Physics:initializeRoom(key)
    Physics.worlds[key] = love.physics.newWorld(0, 0, true)
    Physics.objectSets[key] = {}
    Physics.vertexGroupSets[key] = {}
end

function Physics:buildRoom(key, mapCollision)
    local objects = self.objectSets[key]
    local world = self.worlds[key]
    self.vertexGroupSets[key] = MarchingSquares:new(mapCollision):findMapBoxVertexGroups()
    local vertexGroups = self.vertexGroupSets[key]

    for i, vertexGroup in ipairs(vertexGroups) do
        local object = {}
        local centerX = (vertexGroup.topLeft.x + vertexGroup.topRight.x) / 2
        local centerY = (vertexGroup.topLeft.y + vertexGroup.bottomLeft.y) / 2
        local width = vertexGroup.topRight.x - vertexGroup.topLeft.x
        local height = vertexGroup.bottomLeft.y - vertexGroup.topLeft.y
 
        local uuid = util.uuid()
        object.body = love.physics.newBody(world, centerX, centerY)
        object.shape = love.physics.newRectangleShape(width, height)
        object.fixture = love.physics.newFixture(object.body, object.shape)
        object.fixture:setCategory(G.COLLISION.WALL)
        object.fixture:setUserData(uuid)
        objects[uuid] = object
    end
end

function Physics:buildEnemy(key, enemy)
    local objects = self.objectSets[key]
    local world = self.worlds[key]

    local enemyPhysics = {}
    enemyPhysics.body = love.physics.newBody(world, enemy.x, enemy.y, 'dynamic')
    enemyPhysics.body:setLinearDamping(10)
    enemyPhysics.body:setX(enemy.x)
    enemyPhysics.body:setY(enemy.y)
    enemyPhysics.shape = love.physics.newCircleShape(enemy.radius)
    enemyPhysics.fixture = love.physics.newFixture(enemyPhysics.body, enemyPhysics.shape, 1)
    enemyPhysics.fixture:setCategory(G.COLLISION.ENEMY)
    enemyPhysics.fixture:setMask(G.COLLISION.ENEMY, G.COLLISION.ENEMY_BULLET)
    enemyPhysics.fixture:setRestitution(0.2)
    enemyPhysics.fixture:setUserData(enemy.uuid)
    objects[enemy.uuid] = enemyPhysics
end

function Physics:buildPlayer(key, player)
    local objects = self.objectSets[key]
    local world = self.worlds[key]

    local playerPhysics = {}
    playerPhysics.body = love.physics.newBody(world, 0, 0, 'dynamic')
    playerPhysics.body:setLinearDamping(10)

    playerPhysics.shape = love.physics.newCircleShape(24)
    playerPhysics.fixture = love.physics.newFixture(playerPhysics.body, playerPhysics.shape, 1)
    playerPhysics.fixture:setRestitution(0.2)
    playerPhysics.fixture:setCategory(G.COLLISION.PLAYER)
    playerPhysics.fixture:setMask(G.COLLISION.PLAYER, G.COLLISION.PLAYER_BULLET)
    playerPhysics.fixture:setUserData(player.uuid)
    objects[player.uuid] = playerPhysics
end

function Physics:positionPlayerOnRoomEnter(key, player, playerPhysics, map)
    if map.currentRow < map.lastRow then
        -- went up
        playerPhysics.body:setX(player.lastX)
        playerPhysics.body:setY(G.ROOM_HEIGHT * G.TILE_SIZE - 1)
    elseif map.currentRow > map.lastRow then
        -- went down
        playerPhysics.body:setX(player.lastX)
        playerPhysics.body:setY(0)
    elseif map.currentCol < map.lastCol then
        -- went left
        playerPhysics.body:setX(G.ROOM_WIDTH * G.TILE_SIZE - 1)
        playerPhysics.body:setY(player.lastY)
    elseif map.currentCol > map.lastCol then
        -- went right
        playerPhysics.body:setX(0)
        playerPhysics.body:setY(player.lastY)
    else
        -- just started the game, place in center of room
        playerPhysics.body:setX(G.ROOM_WIDTH * G.TILE_SIZE / 2)
        playerPhysics.body:setY(G.ROOM_HEIGHT * G.TILE_SIZE / 2)
    end
end


function Physics:buildAndFireBullet(bullet)
    local bulletPhysics = {}
    bulletPhysics.body = love.physics.newBody(self.currentWorld, bullet.x, bullet.y, 'dynamic')
    bulletPhysics.body:setX(bullet.x)
    bulletPhysics.body:setY(bullet.y)
    bulletPhysics.shape = love.physics.newCircleShape(bullet.damage)
    bulletPhysics.fixture = love.physics.newFixture(bulletPhysics.body, bulletPhysics.shape, 1)
    bulletPhysics.fixture:setRestitution(0.3)
    bulletPhysics.fixture:setCategory(bullet.category)
    bulletPhysics.fixture:setUserData(bullet.uuid)
    if bullet.category == G.COLLISION.PLAYER_BULLET then
        bulletPhysics.fixture:setMask(G.COLLISION.ENEMY_BULLET)
    else
        bulletPhysics.fixture:setMask(G.COLLISION.PLAYER_BULLET, G.COLLISION.ENEMY_BULLET)
    end
    local force = 2000
    local fx = force * math.cos(bullet.angle)
    local fy = force * math.sin(bullet.angle)
    bulletPhysics.body:applyForce(fx, fy)
    self.currentObjects[bullet.uuid] = bulletPhysics
end

function Physics:buildGear(gear)
    local gearPhysics = {}
    gearPhysics.body = love.physics.newBody(self.currentWorld, gear.x, gear.y, 'dynamic')
    gearPhysics.body:setX(gear.x)
    gearPhysics.body:setY(gear.y)
    gearPhysics.shape = love.physics.newCircleShape(G.GEAR_SIZE / 2)
    gearPhysics.fixture = love.physics.newFixture(gearPhysics.body, gearPhysics.shape, 1)
    gearPhysics.fixture:setRestitution(0.3)
    gearPhysics.fixture:setCategory(G.COLLISION.GEAR)
    gearPhysics.fixture:setUserData(gear.uuid)
    gearPhysics.fixture:setMask(
        G.COLLISION.ENEMY,
        G.COLLISION.PLAYER_BULLET,
        G.COLLISION.ENEMY_BULLET
    )
    local force = 500
    local fx = math.random(force * 2) - force
    local fy = math.random(force * 2) - force
    gearPhysics.body:applyForce(fx, fy)
    self.currentObjects[gear.uuid] = gearPhysics
end

function Physics:get(uuid)
    return self.currentObjects[uuid]
end

function Physics:remove(uuid)
    if self.currentObjects[uuid] then
        self.currentObjects[uuid].body:destroy()
        self.currentObjects[uuid] = nil
    end
end

function Physics:simulate(dtInSec)
    if self.paused then return end

    if self.currentWorld then
        self.currentWorld:update(dtInSec)
    end
end

function Physics:movePlayer(dtInSec, player, playerPhysics, states)
    local moveLeft = states.a
    local moveRight = states.e or states.d
    local moveUp = states.comma or states.w
    local moveDown = states.o or states.s

    local fx = 0
    local fy = 0
    if moveLeft then fx = fx - player.acceleration end
    if moveRight then fx = fx + player.acceleration end
    if moveUp then fy = fy - player.acceleration end
    if moveDown then fy = fy + player.acceleration end
    fx, fy = vector.normalize(fx, fy)
    fx, fy = vector.mul(player.acceleration, fx, fy)

    playerPhysics.body:applyForce(fx, fy)
end

function Physics:checkIfOffscreen(uuid)
    local object = self.currentObjects[uuid]
    if object then
        if object.body:getX() >= G.ROOM_WIDTH * G.TILE_SIZE then
            return true, 1, 0
        elseif object.body:getX() < 0 then
            return true, -1, 0
        elseif object.body:getY() >= G.ROOM_HEIGHT * G.TILE_SIZE then
            return true, 0, 1
        elseif object.body:getY() < 0 then
            return true, 0, -1
        end
    end
    return false
end

function Physics:pause()
    self.paused = true
end

function Physics:resume()
    self.paused = false
end

return Physics
