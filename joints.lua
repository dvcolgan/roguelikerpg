local util = require('util')

local Dragging = class('Dragging')
function Dragging:initialize(dragged)
    self.dragged = dragged
    self.dragging = true
end

local Connection = class('Connection')
function Connection:initialize(mountPoint1, mountPoint2)
    self.mountPoint1 = mountPoint1
    self.mountPoint2 = mountPoint2
end

return {
    Dragging = Dragging,
    Connection = Connection,
}
