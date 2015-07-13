local util = require('util')
local vector = require('lib/vector')

local MountPoint = class('MountPoint')
function MountPoint:initialize(part, x, y)
    self.draggable = true
    self.isMountPoint = true
    self.part = part
    self.offset = {
        x = x,
        y = y,
    }
    self.connection = nil
end

function MountPoint:getWorldCoordinates()
    local rotatedX, rotatedY = vector.rotate(
        self.part.transform.angle,
        self.offset.x,
        self.offset.y
    )
    return self.part.transform.x + rotatedX, self.part.transform.y + rotatedY
end

local Player = class('Player')
function Player:initialize(x, y)
    self.transform = {
        x = x,
        y = y,
        angle = 0,
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
    self.isCommand = true
end

local Enemy = class('Enemy')
function Enemy:initialize(x, y)
    self.transform = {
        x = x,
        y = y,
        angle = 0,
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
    self.isCommand = true
end

local Connector1x1 = class('Connector1x1')
function Connector1x1:initialize(x, y)
    self.transform = {
        x = x,
        y = y,
        angle = 0,
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
end

local Connector2x1 = class('Connector2x1')
function Connector2x1:initialize(x, y)
    self.transform = {
        x = x,
        y = y,
        angle = 0,
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
end

local Cannon = class('Cannon')
function Cannon:initialize(x, y)
    self.transform = {
        x = x,
        y = y,
        angle = 0,
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
end

local Thruster = class('Thruster')
function Thruster:initialize(x, y)
    self.transform = {
        x = x,
        y = y,
        angle = 0,
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
end

return {
    Player = Player,
    Enemy = Enemy,
    Connector1x1 = Connector1x1,
    Connector2x1 = Connector2x1,
    Cannon = Cannon,
    Thruster = Thruster,
}
