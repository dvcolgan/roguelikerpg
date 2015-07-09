local ecs = require('tiny')


local RevoluteJointSystem = ecs.processingSystem(class('RevoluteJointSystem'))

function RevoluteJointSystem:init()
    self.filter = ecs.requireAll('uuid', 'mountPoint1', 'mountPoint2')
end

function RevoluteJointSystem:onAdd(connection)
    local object1 = physics.objects[connection.mountPoint1.part.uuid]
    local object2 = physics.objects[connection.mountPoint2.part.uuid]

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
    physics.joints[connection.uuid] = joint
end

function RevoluteJointSystem:onRemove(connection)
    local joint = physics.joints[connection.uuid]
    joint:destroy()
    physics.joints[connection.uuid] = nil
end

---------------

local MouseJointSystem = ecs.processingSystem(class('MouseJointSystem'))

function MouseJointSystem:init()
    self.filter = ecs.requireAll('uuid', 'dragged', 'dragging')
end

function MouseJointSystem:onAdd(dragging)
    local object = physics.objects[dragging.dragged.part.uuid]
    local mountX, mountY = dragging.dragged:getWorldCoordinates()
    physics.mouseJoint = love.physics.newMouseJoint(object.body, mountX, mountY)
    physics.mouseJoint:setUserData(dragging)
end

function MouseJointSystem:onRemove(dragging)
    physics.mouseJoint:destroy()
    physics.mouseJoint = nil
    world:removeEntity(dragging)
end

function MouseJointSystem:process(dragging, dt)
    physics.mouseJoint:setTarget(love.mouse.getPosition())
end

---------------

local RigidBodySystem = ecs.processingSystem(class('RigidBodySystem'))

function RigidBodySystem:init()
    self.filter = ecs.requireAll('uuid', 'physics', 'transform', 'shape')
end

function RigidBodySystem:onAdd(entity)
    local object = {}
    object.body = love.physics.newBody(
        physics.world,
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

    physics.objects[entity.uuid] = object
end

function RigidBodySystem:onRemove(entity)
    local object = physics.objects[entity.uuid]
    object.body:destroy()
    physics.objects[entity.uuid] = nil
end

function RigidBodySystem:preProcess(dt)
    physics.world:update(dt)
end

function RigidBodySystem:process(entity, dt)
    local object = physics.objects[entity.uuid]
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
