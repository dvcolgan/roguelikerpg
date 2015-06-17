local class = require('middleclass')


local Map = class('Map')

function Map:initialize(engine)
    self.engine = engine
    self.x = 0
    self.y = 0
    self.width = love.graphics.getWidth()
    self.height = love.graphics.getHeight()

    self.scroll = {
        x = self.x,
        y = self.y,
    }
end

