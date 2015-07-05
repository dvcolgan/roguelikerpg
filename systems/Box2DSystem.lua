local ecs = require('tiny')
local util = require('util')

local Box2DSystem = ecs.processingSystem(class 'Box2DSystem')

function Box2DSystem:init()
    self.objects = {}
    self.physics = love.physics.newWorld(0, 0, true)
    self.filter = ecs.requireAll('uuid', 'physics', 'position', 'shape')
    self:buildWalls()
end

function Box2DSystem:onAdd(entity)
    local object = {}
    object.body = love.physics.newBody(
        self.physics,
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

    self.objects[entity.uuid] = object
end

function Box2DSystem:onRemove(entity)
    local object = self.objects[entity.uuid]
    object.body:destroy()
    self.objects[entity.uuid] = nil
end

function Box2DSystem:buildWalls()
    local uuid = util.uuid()
    local wall = {}
    local roomWidth = love.graphics.getWidth()
    local roomHeight = love.graphics.getHeight()
    for i, template in ipairs({
        {x = roomWidth / 2, y = -10, width = roomWidth, height = 20},
        {x = roomWidth / 2, y = roomHeight + 10, width = roomWidth, height = 20},
        {x = -10, y = roomHeight / 2, width = 20, height = roomHeight},
        {x = roomWidth + 10, y = roomHeight / 2, width = 10, height = roomHeight},
    }) do
        wall.body = love.physics.newBody(self.physics, template.x, template.y)
        wall.shape = love.physics.newRectangleShape(template.width, template.height)
        wall.fixture = love.physics.newFixture(wall.body, wall.shape)
        self.objects[uuid] = wall
    end
end

function Box2DSystem:preProcess(dt)
    self.physics:update(dt)
end

function Box2DSystem:process(entity, dt)
    local object = self.objects[entity.uuid]
    entity.position.x = object.body:getX()
    entity.position.y = object.body:getY()
end

return Box2DSystem
