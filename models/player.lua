local class = require('middleclass')
local G = require('constants')


local Player = class('Player')

function Player:initialize(engine)
    self.engine = engine
    self.x = love.graphics.getWidth() / 2
    self.y = love.graphics.getHeight() / 2
    self.dx = 0
    self.dy = 0
    self.direction = 'left'
    self.acceleration = 1000
    self.drag = 30
    self.maxSpeed = 3
    self.frozen = false
end

function Player:onTakeAwayControls()
    self.frozen = true
end

function Player:onGiveBackControls()
    self.frozen = false
end

function Player:serialize()
    return { x = player.x, y = player.y }
end
function Player:deserialize(player)
    self.x = player.x
    self.y = player.y
end

return Player
