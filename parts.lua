local util = require('util')

local Command = class('Command')
function Command:init(x, y)
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
    self.connections = {
        {0, 0.5}, -- left
        {1, 0.5}, -- right
        {0.5, 0}, -- top
        {0.5, 1}, -- bottom
    }
    self.image = 'command'
    self.isPart = true
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
    self.connections = {
        {0, 0.5}, -- left
        {1, 0.5}, -- right
        {0.5, 0}, -- top
        {0.5, 1}, -- bottom
    }
    self.image = 'connector1x1'
    self.isPart = true
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
    self.connections = {
        {0, 0.5}, -- left
        {1, 0.5}, -- right
        {0.23, 0}, -- top
        {0.23, 1}, -- bottom
        {0.77, 0}, -- top
        {0.77, 1}, -- bottom
    }
    self.image = 'connector2x1'
    self.isPart = true
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
    self.physics = true
    self.image = 'cannon'
    self.isPart = true
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
    self.physics = true
    self.image = 'thruster'
    self.isPart = true
end

return {
    Square = Square,
    Circle = Circle,
    Command = Command,
    Connector1x1 = Connector1x1,
    Connector2x1 = Connector2x1,
    Cannon = Cannon,
    Thruster = Thruster,
}
