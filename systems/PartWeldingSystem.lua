local ecs = require('lib/tiny')
local vector = require('lib/vector')
local joints = require('joints')
local G = require('constants')

local PartWeldingSystem = ecs.processingSystem(class('PartWeldingSystem'))

function PartWeldingSystem:init()
    self.filter = ecs.requireAny('uuid', 'dragging', 'isMountPoint')
end

function PartWeldingSystem:onRemove(dragging)
    if dragging.dragging then 
        local mountX, mountY = dragging.dragged:getWorldCoordinates()

        for i, entity in ipairs(self.entities) do
            if entity.isMountPoint and entity ~= dragging.dragged then
                local mountPoint = entity
                if mountPoint ~= dragging then
                    local otherMountX, otherMountY = mountPoint:getWorldCoordinates()

                    local dist = vector.dist(
                        mountX, mountY, otherMountX, otherMountY
                    )
                    if dist < G.CONNECTION_RADIUS then
                        local connection = joints.Connection(dragging.dragged, mountPoint)
                        dragging.dragged.connection = connection
                        mountPoint.connection = connection
                    end
                end
            end
        end
    end
end

return PartWeldingSystem
