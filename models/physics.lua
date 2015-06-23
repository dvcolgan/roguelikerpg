local class = require('middleclass')
local G = require('constants')
local MarchingSquares = require('lib/marchingsquares')


local Physics = class('Physics')

function Physics:initialize(engine)
    self.engine = engine
    self.vertexGroups = {}

    love.physics.setMeter(G.TILE_SIZE)
    self.world = love.physics.newWorld(0, 0, true)
    self.objects = {}
end


function Physics:clearObjects()
    if self.objects.map then
        for i, object in pairs(self.objects.map) do
            object.body:destroy()
        end
    end
    if self.objects.enemies then
        for uuid, enemy in pairs(self.objects.enemies) do
            enemy.body:destroy()
        end
    end
    if self.objects.bullets then
        for uuid, bullet in pairs(self.objects.bullets) do
            bullet.body:destroy()
        end
    end
    if self.objects.player then
        self.objects.player.body:destroy()
    end
    self.objects = {}
end

function Physics:onEnemiesLoaded()
    local map = self.engine.models.map
    self.vertexGroups = MarchingSquares:new(map.collision):findMapBoxVertexGroups()

    self.objects.map = {}
    for i, vertexGroup in ipairs(self.vertexGroups) do
        local object = {}
        local centerX = (vertexGroup.topLeft.x + vertexGroup.topRight.x) / 2
        local centerY = (vertexGroup.topLeft.y + vertexGroup.bottomLeft.y) / 2
        local width = vertexGroup.topRight.x - vertexGroup.topLeft.x
        local height = vertexGroup.bottomLeft.y - vertexGroup.topLeft.y
 
        object.body = love.physics.newBody(self.world, centerX, centerY)
        object.shape = love.physics.newRectangleShape(width, height)
        object.fixture = love.physics.newFixture(object.body, object.shape)
        table.insert(self.objects.map, object)
    end

    local enemiesPhysics = {}
    local enemies = self.engine.models.enemy.enemies
    for uuid, enemy in pairs(enemies) do
        local enemyPhysics = {}
        enemyPhysics.body = love.physics.newBody(self.world, enemy.x, enemy.y, 'dynamic')
        enemyPhysics.body:setLinearDamping(10)
        enemyPhysics.body:setX(enemy.x)
        enemyPhysics.body:setY(enemy.y)
        enemyPhysics.shape = love.physics.newCircleShape(enemy.radius)
        enemyPhysics.fixture = love.physics.newFixture(enemyPhysics.body, enemyPhysics.shape, 1)
        enemyPhysics.fixture:setCategory(G.COLLISION.ENEMY)
        enemyPhysics.fixture:setMask(G.COLLISION.ENEMY, G.COLLISION.ENEMY_BULLET)
        enemyPhysics.fixture:setRestitution(0.2)
        enemiesPhysics[uuid] = enemyPhysics
    end
    self.objects.enemies = enemiesPhysics

    local playerPhysics = {}
    local player = self.engine.models.player
    playerPhysics.body = love.physics.newBody(self.world, player.x, player.y, 'dynamic')
    playerPhysics.body:setLinearDamping(10)

    if map.roomY < map.lastRoomY then
        -- went up
        playerPhysics.body:setX(player.lastX)
        playerPhysics.body:setY(G.ROOM_HEIGHT * G.TILE_SIZE - 1)
    elseif map.roomY > map.lastRoomY then
        -- went down
        playerPhysics.body:setX(player.lastX)
        playerPhysics.body:setY(0)
    elseif map.roomX < map.lastRoomX then
        -- went left
        playerPhysics.body:setX(G.ROOM_WIDTH * G.TILE_SIZE - 1)
        playerPhysics.body:setY(player.lastY)
    elseif map.roomX > map.lastRoomX then
        -- went right
        playerPhysics.body:setX(0)
        playerPhysics.body:setY(player.lastY)
    else
        -- just started the game, place in center of room
        playerPhysics.body:setX(G.ROOM_WIDTH * G.TILE_SIZE / 2)
        playerPhysics.body:setY(G.ROOM_HEIGHT * G.TILE_SIZE / 2)
    end

    playerPhysics.shape = love.physics.newCircleShape(24)
    playerPhysics.fixture = love.physics.newFixture(playerPhysics.body, playerPhysics.shape, 1)
    playerPhysics.fixture:setRestitution(0.2)
    playerPhysics.fixture:setCategory(G.COLLISION.PLAYER)
    playerPhysics.fixture:setMask(G.COLLISION.PLAYER, G.COLLISION.PLAYER_BULLET)
    self.objects.player = playerPhysics

    self.objects.bullets = {}
end

function Physics:onBulletFired(uuid, bullet)
    local bulletPhysics = {}
    bulletPhysics.body = love.physics.newBody(self.world, bullet.x, bullet.y, 'dynamic')
    bulletPhysics.body:setX(bullet.x)
    bulletPhysics.body:setY(bullet.y)
    bulletPhysics.shape = love.physics.newCircleShape(bullet.damage)
    bulletPhysics.fixture = love.physics.newFixture(bulletPhysics.body, bulletPhysics.shape, 1)
    bulletPhysics.fixture:setRestitution(0.3)
    bulletPhysics.fixture:setCategory(bullet.category)
    bulletPhysics.fixture:setMask(bullet.category)
    local force = 2000
    bulletPhysics.body:applyForce(math.random(force * 2) - force, math.random(force * 2) - force)
    self.objects.bullets[uuid] = bulletPhysics
end

function Physics:onBulletTimeout(uuid)
    self.objects.bullets[uuid].body:destroy()
    self.objects.bullets[uuid] = nil
end

function Physics:onUpdate(dtInSec)
    self.world:update(dtInSec)

    local player = self.engine.models.player
    if player.frozen then
        return
    end

    local playerPhysics = self.objects.player
    if playerPhysics == nil then return end
    states = self.engine.models.key.states

    local moveLeft = states.a
    local moveRight = states.e or states.d
    local moveUp = states.comma or states.w
    local moveDown = states.o or states.s

    -- Do acceleration
    if moveLeft then
        playerPhysics.body:applyForce(-player.acceleration, 0)
    end
    if moveRight then
        playerPhysics.body:applyForce(player.acceleration, 0)
    end
    if moveUp then
        playerPhysics.body:applyForce(0, -player.acceleration)
    end
    if moveDown then
        playerPhysics.body:applyForce(0, player.acceleration)
    end

    -- Check if offscreen
    if playerPhysics.body:getX() >= G.ROOM_WIDTH * G.TILE_SIZE then
        self.engine:trigger('roomChange', 1, 0)
        self:clearObjects()
    elseif playerPhysics.body:getX() < 0 then
        self.engine:trigger('roomChange', -1, 0)
        self:clearObjects()
    elseif playerPhysics.body:getY() >= G.ROOM_HEIGHT * G.TILE_SIZE then
        self.engine:trigger('roomChange', 0, 1)
        self:clearObjects()
    elseif playerPhysics.body:getY() < 0 then
        self.engine:trigger('roomChange', 0, -1)
        self:clearObjects()
    end
end

return Physics
