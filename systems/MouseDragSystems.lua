local ecs = require('tiny')
local vector = require('vector')
local joints = require('joints')
local beholder = require('beholder')

local MouseDragSystem = ecs.processingSystem(class('MouseDragSystem'))

function MouseDragSystem:init()
    self.filter = ecs.requireAll('uuid', 'draggable')

    beholder.observe('mouseDown', function(x, y, button)
        if button == 'l' then
            local closest = nil
            local closestDist = nil
            local mouseX, mouseY = love.mouse.getPosition()

            for i, draggable in ipairs(self.entities) do
                local dist = vector.dist(
                    draggable.transform.x,
                    draggable.transform.y,
                    mouseX, mouseY
                )
                if closestDist == nil or dist < closestDist then
                    closest = draggable
                    closestDist = dist
                end
            end
            if closest then
                world:addEntity(joints.Dragging(closest))
            end
        end
    end)
end

---------------

local MouseDragReleaseSystem = ecs.processingSystem(class('MouseDragReleaseSystem'))

function MouseDragReleaseSystem:init()
    self.filter = ecs.requireAll('uuid', 'dragging')

    beholder.observe('mouseUp', function(x, y, button)
        if button == 'l' then
            for i, dragging in ipairs(self.entities) do
                world:removeEntity(dragging)
            end
        end
    end)
end

return {
    MouseDragSystem = MouseDragSystem,
    MouseDragReleaseSystem = MouseDragReleaseSystem,
}
