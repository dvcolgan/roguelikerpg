local class = require('middleclass')


local GameState = class('GameState')

function GameState:initialize()
    self.doUpdate = false
    self.doRender = false
end

function GameState:create()
end

function GameState:update(dt)
end

function GameState:draw()
end

return GameState
