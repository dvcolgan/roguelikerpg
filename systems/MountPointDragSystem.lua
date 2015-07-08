local ecs = require('tiny')
local G = require('constants')
local vector = require('vector')
local MountPointDragSystem = ecs.processingSystem(class('MountPointDragSystem'))
local joints = require('joints')

function MountPointDragSystem:init()
    self.mouseDown = false
    self.dragged = nil
    self.filter = ecs.requireAll('uuid', 'isMountPoint')
end

function MountPointDragSystem:preProcess(dt)
    if not self.mouseDown and love.mouse.isDown('l') then
        self.mouseDown = true
        local closest self:pinClosestMountPoint()

    elseif self.mouseDown and not love.mouse.isDown('l') then
        self.mouseDown = false
        world:removeEntity(self.dragged)
        self.dragged.dragging = nil
        self:weldToNearbyParts()
        world:addEntity(self.dragged)
        self.dragged = nil
    end
end

function MountPointDragSystem:pinClosestMountPoint()
    local closestMountPoint = nil
    local closestDist = nil
    local mouseX, mouseY = love.mouse.getPosition()

    for i, mountPoint in ipairs(self.entities) do
        local mountX, mountY = mountPoint:getWorldPosition()
        local dist = vector.dist(
            mountX, mountY, mouseX, mouseY
        )
        if closestDist == nil or dist < closestDist then
            closestMountPoint = mountPoint
            closestDist = dist
        end
    end

    if closestMountPoint then
        self.dragged = closestMountPoint
        world:removeEntity(self.dragged)
        self.dragged.dragging = true
        world:addEntity(self.dragged)
    end
end

function MountPointDragSystem:weldToNearbyParts()
        local mountX, mountY = self.dragged:getWorldPosition()

    for i, mountPoint in ipairs(self.entities) do
        if mountPoint ~= self.dragged then
            local otherMountX, otherMountY = mountPoint:getWorldPosition()
            local dist = vector.dist(
                mountX, mountY, otherMountX, otherMountY
            )
            if dist < G.CONNECTION_RADIUS then
                world:addEntity(joints.Connection(self.dragged, mountPoint))
            end
        end
    end

end

return MountPointDragSystem
