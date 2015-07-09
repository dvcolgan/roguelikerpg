local ecs = require('tiny')
local vector = require('vector')
local joints = require('joints')
local G = require('constants')

local PartWeldingSystem = ecs.processingSystem(class('PartWeldingSystem'))

function PartWeldingSystem:init()
    self.filter = ecs.requireAny('uuid', 'dragging', 'isMountPoint')
end

function PartWeldingSystem:onRemove(dragging)
    if dragging.dragging then 
        local mountX = dragging.dragged.transform.x
        local mountY = dragging.dragged.transform.y

        for i, entity in ipairs(self.entities) do
            if entity.isMountPoint and entity ~= dragging.dragged then
                local mountPoint = entity
                if mountPoint ~= dragging then
                    local otherMountX = mountPoint.transform.x
                    local otherMountY = mountPoint.transform.y

                    local dist = vector.dist(
                        mountX, mountY, otherMountX, otherMountY
                    )
                    if dist < G.CONNECTION_RADIUS then
                        joints.Connection(dragging.dragged, mountPoint)
                    end
                end
            end
        end
    end
end

return PartWeldingSystem
