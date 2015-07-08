local util = require('util')

local MouseJoint = class('MouseJoint')
function MouseJoint:init(mountPoint1)
    self.uuid = util.uuid()
    self.mountPoint1 = mountPoint1
    self.mountPoint2 = 'mouse'
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
    MouseJoint = MouseJoint,
    Connection = Connection,
}
