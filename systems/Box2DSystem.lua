local ecs = require('tiny')
local util = require('util')
local vector = require('vector')
local G = require('constants')
local debugWorldDraw = require('physics-debugdraw')

local Box2DSystem = ecs.processingSystem(class 'Box2DSystem')

function Box2DSystem:init()
    self.objects = {}
    self.mouseJoint = nil
    self.mouseDown = false
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

    if entity.connections then
        object.connections = {}

        for i, conTemplate in ipairs(entity.connections) do
            local connection = {}
            connection.shape = love.physics.newCircleShape(G.CONNECTION_RADIUS)
            connection.fixture = love.physics.newFixture(object.body, connection.shape, 1)
        end
    end

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

function Box2DSystem:releaseMouseJoint()
    if self.mouseJoint then
        self.mouseJoint:destroy()
        self.mouseJoint = nil
    end
end

function Box2DSystem:pinClosestConnection()
    local closestObject = nil
    local closestDist = nil
    local connectionIdx = nil
    local mouseX, mouseY = love.mouse.getPosition()
    local closestConnectionX = nil
    local closestConnectionY = nil

    for uuid, object in pairs(self.objects) do
        local entity = object.fixture:getUserData()
        if entity then
            if entity.connections and entity.shape and entity.position then
                for i, connection in ipairs(entity.connections) do
                    local width = entity.shape.width or entity.shape.radius * 2
                    local height = entity.shape.height or entity.shape.radius * 2

                    local connectionX, connectionY = object.body:getWorldPoint(
                        width * connection[1] - width / 2,
                        height * connection[2] - height / 2
                    )

                    local dist = vector.dist(
                        connectionX, connectionY, mouseX, mouseY
                    )
                    if closestDist == nil or dist < closestDist then
                        closestObject = object
                        closestDist = dist
                        connectionIdx = i
                        closestConnectionX = connectionX
                        closestConnectionY = connectionY
                    end
                end
            end
        end
    end

    if closestObject then
        self.mouseJoint = love.physics.newMouseJoint(
            closestObject.body, closestConnectionX, closestConnectionY
        )
    end
end

function Box2DSystem:preProcess(dt)
    if not self.mouseDown and love.mouse.isDown('l') then
        self.mouseDown = true
        self:pinClosestConnection()

    elseif self.mouseDown and not love.mouse.isDown('l') then
        self.mouseDown = false
        self:releaseMouseJoint()
    end

    if self.mouseJoint then
        self.mouseJoint:setTarget(love.mouse.getPosition())
    end
    self.physics:update(dt)
end

function Box2DSystem:process(entity, dt)
    local object = self.objects[entity.uuid]
    entity.position.x = object.body:getX()
    entity.position.y = object.body:getY()
    entity.position.angle = object.body:getAngle()
end

function Box2DSystem:postProcess(dt)
    love.graphics.setColor(255, 255, 255)
    debugWorldDraw(self.physics, 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

return Box2DSystem
