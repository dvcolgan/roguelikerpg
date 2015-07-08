local ecs = require('tiny')
local util = require('util')
local vector = require('vector')
local G = require('constants')
local debugWorldDraw = require('physics-debugdraw')

local PositionSystem = ecs.processingSystem(class('PositionSystem'))

function PositionSystem:init()
    self.filter = ecs.requireAll('uuid', 'physics', 'position', 'shape')
end

function PositionSystem:onAdd(entity)
    local object = {}
    object.body = love.physics.newBody(
        physics.world,
        entity.position.x,
        entity.position.y,
        'dynamic'
    )
    object.body:setLinearDamping(10)
    if entity.shape.kind == 'rectangle' then
        object.shape = love.physics.newRectangleShape(
            entity.shape.width,
            entity.shape.height
        )
    elseif entity.shape.kind == 'circle' then
        object.shape = love.physics.newCircleShape(
            entity.shape.radius
        )
    end
    object.fixture = love.physics.newFixture(object.body, object.shape, 1)
    object.fixture:setRestitution(0.2)
    object.fixture:setUserData(entity)

    --if entity.connections then
    --    object.connections = {}

    --    for i, conTemplate in ipairs(entity.connections) do
    --        local connection = {}
    --        local width = entity.shape.width or entity.shape.radius * 2
    --        local height = entity.shape.height or entity.shape.radius * 2
    --        local offsetX = width * conTemplate[1] - width / 2
    --        local offsetY = height * conTemplate[2] - height / 2
    --        connection.shape = love.physics.newCircleShape(offsetX, offsetY, G.CONNECTION_RADIUS)
    --        connection.fixture = love.physics.newFixture(object.body, connection.shape, 1)
    --        connection.fixture:setSensor(true)
    --        table.insert(object.connections, connection)
    --    end
    --end

    physics.objects[entity.uuid] = object
end

function PositionSystem:onRemove(entity)
    local object = physics.objects[entity.uuid]
    object.body:destroy()
    physics.objects[entity.uuid] = nil
end

function PositionSystem:preProcess(dt)
    physics.world:update(dt)
end

function PositionSystem:process(entity, dt)
    local object = physics.objects[entity.uuid]
    entity.position.x = object.body:getX()
    entity.position.y = object.body:getY()
    entity.position.angle = object.body:getAngle()
end

function PositionSystem:postProcess(dt)
    love.graphics.setColor(255, 255, 255)
    --debugWorldDraw(physics.world, 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

return PositionSystem
