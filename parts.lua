local util = require('util')

local Square = class('Square')
function Square:init(x, y, width, height)
    self.uuid = util.uuid()
    self.position = {
        x = x,
        y = y,
    }
    self.shape = {
        kind = 'rectangle',
        width = width,
        height = height,
    }
    self.color = {
        red = 255,
        green = 0,
        blue = 0,
        alpha = 255,
    }
    self.physics = true
end

local Circle = class('Circle')
function Circle:init(x, y, radius)
    self.uuid = util.uuid()
    self.position = {
        x = x,
        y = y,
    }
    self.shape = {
        kind = 'circle',
        radius = radius,
    }
    self.color = {
        red = 0,
        green = 255,
        blue = 0,
        alpha = 255,
    }
    self.physics = true
end

local Command = class('Command')
function Command:init(x, y)
    self.uuid = util.uuid()
    self.position = {
        x = x,
        y = y,
    }
    self.shape = {
        kind = 'circle',
        radius = 21,
    }
    self.physics = true
    self.connections = {
        {x = 0, y = 0.5}, -- left
        {x = 1, y = 0.5}, -- right
        {x = 0.5, y = 0}, -- top
        {x = 0.5, y = 1}, -- bottom
    }
    self.image = 'command'
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
        {x = 0, y = 0.5}, -- left
        {x = 1, y = 0.5}, -- right
        {x = 0.5, y = 0}, -- top
        {x = 0.5, y = 1}, -- bottom
    }
    self.image = 'connector1x1'
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
        {x = 0, y = 0.5}, -- left
        {x = 1, y = 0.5}, -- right
        {x = 0.5, y = 0}, -- top
        {x = 0.5, y = 1}, -- bottom
    }
    self.image = 'connector2x1'
end

local Cannon = class('Cannon')
function Cannon:init(x, y)
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
    self.image = 'cannon'
end

local Thruster = class('Thruster')
function Thruster:init(x, y)
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
    self.image = 'thruster'
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
