local class = require('middleclass')


local GameState = class('GameState')

function GameState:initialize(engine)
    self.engine = engine
    self.doUpdate = false
    self.doDraw = false
end

function GameState:create()
end

function GameState:update(dt)
end

function GameState:draw()
end

return GameState
