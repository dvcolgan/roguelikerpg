local util = require('util')

local MountPoint = class('MountPoint')
function MountPoint:init(part, x, y)
    self.uuid = util.uuid()
    self.isMountPoint = true
    self.part = part
    self.position = {
        x = x,
        y = y,
    }
    world:addEntity(self)
end

function MountPoint:getWorldPosition()
    local object = physics.objects[self.part.uuid]
    return object.body:getWorldPoint(self.position.x, self.position.y)
end

local Player = class('Player')
function Player:init(x, y)
    self.uuid = util.uuid()
    self.position = {
        x = x,
        y = y,
    }
    self.angle = 0
    self.shape = {
        kind = 'circle',
        radius = 21,
    }
    self.physics = true
    self.mountPoints = {
        MountPoint(self, -24, 0), -- left
        MountPoint(self, 24, 0), -- right
        MountPoint(self, 0, -24), -- top
        MountPoint(self, 0, 24), -- bottom
    }
    self.image = 'player'
    self.isPart = true

    self.selected = true
    world:addEntity(self)
end

local Enemy = class('Enemy')
function Enemy:init(x, y)
    self.uuid = util.uuid()
    self.position = {
        x = x,
        y = y,
    }
    self.angle = 0
    self.shape = {
        kind = 'circle',
        radius = 21,
    }
    self.physics = true
    self.mountPoints = {
        MountPoint(self, -24, 0), -- left
        MountPoint(self, 24, 0), -- right
        MountPoint(self, 0, -24), -- top
        MountPoint(self, 0, 24), -- bottom
    }
    self.image = 'enemy'
    self.isPart = true

    self.selected = true
    world:addEntity(self)
end

local Connector1x1 = class('Connector1x1')
function Connector1x1:init(x, y)
    self.uuid = util.uuid()
    self.position = {
        x = x,
        y = y,
    }
    self.shape = {
        kind = 'rectangle',
        width = 40,
        height = 40,
    }
    self.physics = true
    self.mountPoints = {
        MountPoint(self, -24, 0), -- left
        MountPoint(self, 24, 0), -- right
        MountPoint(self, 0, -24), -- top
        MountPoint(self, 0, 24), -- bottom
    }
    self.image = 'connector1x1'
    self.isPart = true
    world:addEntity(self)
end

local Connector2x1 = class('Connector2x1')
function Connector2x1:init(x, y)
    self.uuid = util.uuid()
    self.position = {
        x = x,
        y = y,
    }
    self.shape = {
        kind = 'rectangle',
        width = 88,
        height = 40,
    }
    self.physics = true
    self.mountPoints = {
        MountPoint(self, -44, 0), -- left
        MountPoint(self, 44, 0), -- right
        MountPoint(self, -11, 0), -- top
        MountPoint(self, 0.23, -22), -- bottom
        MountPoint(self, 0.77, 0), -- top
        MountPoint(self, 0.77, 1), -- bottom
    }
    self.image = 'connector2x1'
    self.isPart = true
    world:addEntity(self)
end

local Cannon = class('Cannon')
function Cannon:init(x, y)
    self.uuid = util.uuid()
    self.position = {
        x = x,
        y = y,
    }
    self.shape = {
        kind = 'rectangle',
        width = 40,
        height = 40,
    }
    self.mountPoints = {
        MountPoint(self, -24, 0), -- left
    }
    self.physics = true
    self.image = 'cannon'
    self.isPart = true
    world:addEntity(self)
end

local Thruster = class('Thruster')
function Thruster:init(x, y)
    self.uuid = util.uuid()
    self.position = {
        x = x,
        y = y,
    }
    self.shape = {
        kind = 'circle',
        radius = 24,
    }
    self.mountPoints = {
        MountPoint(self, -24, 0), -- left
    }
    self.physics = true
    self.image = 'thruster'
    self.isPart = true
    world:addEntity(self)
end

return {
    Square = Square,
    Circle = Circle,
    Player = Player,
    Enemy = Enemy,
    Connector1x1 = Connector1x1,
    Connector2x1 = Connector2x1,
    Cannon = Cannon,
    Thruster = Thruster,
}
