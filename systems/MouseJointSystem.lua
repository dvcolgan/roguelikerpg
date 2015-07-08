local ecs = require('tiny')
local MouseJointSystem = ecs.processingSystem(class('MouseJointSystem'))

function MouseJointSystem:init()
    self.filter = ecs.requireAll('uuid', 'isMountPoint', 'dragging')
end

function MouseJointSystem:onAdd(mountPoint)
    local object = physics.objects[mountPoint.part.uuid]
    local mountX, mountY = mountPoint:getWorldPosition()
    physics.mouseJoint = love.physics.newMouseJoint(object.body, mountX, mountY)
    physics.mouseJoint:setUserData(mountPoint)
end

function MouseJointSystem:onRemove(mountPoint)
    physics.mouseJoint:destroy()
    physics.mouseJoint = nil
end

function MouseJointSystem:preProcess(dt)
    if physics.mouseJoint then
        physics.mouseJoint:setTarget(love.mouse.getPosition())
    end
end

return MouseJointSystem
