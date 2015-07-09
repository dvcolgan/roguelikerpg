local util = require('util')

local Dragging = class('Dragging')
function Dragging:init(dragged)
    self.uuid = util.uuid()
    self.dragged = dragged
    self.dragging = true
    world:addEntity(self)
end

local Connection = class('Connection')
function Connection:init(mountPoint1, mountPoint2)
    self.uuid = util.uuid()
    self.mountPoint1 = mountPoint1
    self.mountPoint2 = mountPoint2
    world:addEntity(self)
end

return {
    Dragging = Dragging,
    Connection = Connection,
}
