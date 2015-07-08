local ecs = require('tiny')

local ConnectionSystem = ecs.processingSystem(class('ConnectionSystem'))

function ConnectionSystem:init()
    self.filter = ecs.requireAll('uuid', 'mountPoint1', 'mountPoint2')
end

function ConnectionSystem:onAdd(connection)
    print(connection)
    local object1 = physics.objects[connection.mountPoint1.part.uuid]
    local object2 = physics.objects[connection.mountPoint2.part.uuid]

    -- Two problems: it should use the positions of
    -- the nubbins and not the mouse, and it should
    -- move the objects so they are precisely the
    -- right distance from each other
    -- also we need to make sure there isn't already a
    -- connection here
    local mouseX, mouseY = love.mouse.getPosition()
    local joint = love.physics.newRevoluteJoint(
        object1.body,
        object2.body,
        mouseX, mouseY,
        true
    )
    physics.joints[connection.uuid] = joint
end

function ConnectionSystem:onRemove(connection)
    local joint = physics.joints[connection.uuid]
    joint:destroy()
    physics.joints[connection.uuid] = nil
end

function ConnectionSystem:process(connection, dt)
    love.graphics.setColor(255, 0, 0, 255)
    local mountX, mountY = connection.mountPoint1:getWorldPosition()
    love.graphics.circle('fill', mountX, mountY, 6, 8)
end

return ConnectionSystem
