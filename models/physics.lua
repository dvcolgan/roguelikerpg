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
    for i, object in ipairs(self.objects) do
        object:destroy()
    end
    self.objects = {}
end

function Physics:onRoomLoaded()
    local collision = self.engine.models.map.collision
    self:clearObjects()
    self.vertexGroups = MarchingSquares:new(collision):findMapBoxVertexGroups()

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

    local playerPhysics = {}
    local player = self.engine.models.player
    playerPhysics.body = love.physics.newBody(self.world, player.x, player.y, 'dynamic')
    playerPhysics.body:setLinearDamping(10)
    playerPhysics.shape = love.physics.newCircleShape(24)
    playerPhysics.fixture = love.physics.newFixture(playerPhysics.body, playerPhysics.shape, 1)
    playerPhysics.fixture:setRestitution(0.2)
    self.objects.player = playerPhysics
end

function Physics:onUpdate(dt)
    self.world:update(dt)

    local player = self.engine.models.player
    if player.frozen then
        return
    end

    local playerPhysics = self.objects.player
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
end

return Physics
