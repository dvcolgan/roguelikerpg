local vector = require('lib/vector')
local joints = require('joints')

local MouseDragSystem = class('MouseDragSystem')

function MouseDragSystem:initialize()
    self.components = {'uuid', 'draggable'}
end

function MouseDragSystem:onMouseDown(x, y, button)
    if button == 'l' then
        local closest = nil
        local closestDist = nil
        local mouseX, mouseY = love.mouse.getPosition()

        for uuid, draggable in pairs(self.entities) do
            local draggableX, draggableY = draggable:getWorldCoordinates()
            local dist = vector.dist(
                draggableX,
                draggableY,
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
end

---------------

local MouseDragReleaseSystem = class('MouseDragReleaseSystem')

function MouseDragReleaseSystem:initialize()
    self.components = {'uuid', 'dragging'}
end

function MouseDragReleaseSystem:onMouseUp(x, y, button)
    if button == 'l' then
        for uuid, dragging in pairs(self.entities) do
            world:removeEntity(dragging)
        end
    end
end

return {
    MouseDragSystem = MouseDragSystem,
    MouseDragReleaseSystem = MouseDragReleaseSystem,
}
