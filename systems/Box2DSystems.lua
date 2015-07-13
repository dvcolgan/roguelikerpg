local ecs = require('lib/tiny')


local RevoluteJointSystem = class('RevoluteJointSystem')

function RevoluteJointSystem:initialize(physics)
    self.components = {'uuid', 'mountPoint1', 'mountPoint2'}
    self.physics = physics
end

function RevoluteJointSystem:onAdd(connection)
    local object1 = self.physics.objects[connection.mountPoint1.part.uuid]
    local object2 = self.physics.objects[connection.mountPoint2.part.uuid]

    -- Two problems: it should use the positions of
    -- the nubbins and not the mouse, and it should
    -- move the objects so they are precisely the
    -- right distance from each other
    -- also we need to make sure there isn't already a
    -- connection here
    local jointX, jointY = connection.mountPoint1:getWorldCoordinates()
    local joint = love.physics.newRevoluteJoint(
        object1.body,
        object2.body,
        jointX, jointY,
        true
    )
    self.physics.joints[connection.uuid] = joint
end

function RevoluteJointSystem:onRemove(connection)
    local joint = self.physics.joints[connection.uuid]
    joint:destroy()
    self.physics.joints[connection.uuid] = nil
end

---------------

local MouseJointSystem = class('MouseJointSystem')

function MouseJointSystem:initialize(physics)
    self.components = {'uuid', 'dragged', 'dragging'}
    self.physics = physics
end

function MouseJointSystem:onAdd(dragging)
    local object = self.physics.objects[dragging.dragged.part.uuid]
    local mountX, mountY = dragging.dragged:getWorldCoordinates()
    self.physics.mouseJoint = love.physics.newMouseJoint(object.body, mountX, mountY)
    self.physics.mouseJoint:setUserData(dragging)
end

function MouseJointSystem:onRemove(dragging)
    self.physics.mouseJoint:destroy()
    self.physics.mouseJoint = nil
    world:removeEntity(dragging)
end

function MouseJointSystem:process(dragging, dt)
    self.physics.mouseJoint:setTarget(love.mouse.getPosition())
end

---------------

local RigidBodySystem = class('RigidBodySystem')

function RigidBodySystem:initialize(physics)
    self.components = {'uuid', 'physics', 'transform', 'shape'}
    self.physics = physics
end

function RigidBodySystem:onAdd(entity)
    local object = {}
    object.body = love.physics.newBody(
        self.physics.world,
        entity.transform.x,
        entity.transform.y,
        'dynamic'
    )
    object.body:setAngle(entity.transform.angle)
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

    self.physics.objects[entity.uuid] = object
end

function RigidBodySystem:onRemove(entity)
    local object = self.physics.objects[entity.uuid]
    object.body:destroy()
    self.physics.objects[entity.uuid] = nil
end

function RigidBodySystem:preProcess(dt)
    self.physics.world:update(dt)
end

function RigidBodySystem:process(entity, dt)
    local object = self.physics.objects[entity.uuid]
    entity.transform.x = object.body:getX()
    entity.transform.y = object.body:getY()
    entity.transform.angle = object.body:getAngle()

    love.graphics.setColor(255, 0, 0, 255)
    for i, mountPoint in ipairs(entity.mountPoints) do
        local x, y = mountPoint:getWorldCoordinates()
        love.graphics.circle(
            'fill',
            x, y, 4, 10
        )
    end
end

---------------

return {
    RevoluteJointSystem = RevoluteJointSystem,
    MouseJointSystem = MouseJointSystem,
    RigidBodySystem = RigidBodySystem,
}
