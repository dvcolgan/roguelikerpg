local class = require('middleclass')


local Camera = class('Camera')

function Camera:initialize(engine)
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

function Camera:resize(width, height)
    self.width = width
    self.height = height
end

function Camera:scrollTo(x, y)
    self.scroll.x = x
    self.scroll.y = y
end

function Camera:getOnScreenTileBounds()
    return {
        xMin=math.floor(self.scroll.x / self.tileSize),
        yMin=math.floor(self.scroll.y / self.tileSize),
        xMax=math.ceil((self.scroll.x + self.width) / self.tileSize) - 1,
        yMax=math.ceil((self.scroll.y + self.height) / self.tileSize) - 1,
    }
end

function Camera:getOnScreenSectorBounds()
    return {
        xMin=math.floor(self.scroll.x / (self.tileSize * G.SECTOR_SIZE)),
        yMin=math.floor(self.scroll.y / (self.tileSize * G.SECTOR_SIZE)),
        xMax=math.ceil((self.scroll.x + self.width) / (self.tileSize * G.SECTOR_SIZE)) - 1,
        yMax=math.ceil((self.scroll.y + self.height) / (self.tileSize * G.SECTOR_SIZE)) - 1,
    }
end

function Camera:worldToScreenX(x)
    return x - self.scroll.x
end

function Camera:worldToScreenY(y)
    return y - self.scroll.y
end

function Camera:onUpdate(dt)
    local player = self.engine.models.player
    self:centerOnXY(player.x, player.y)
end


function Camera:centerOnXY(x, y)
    self.scroll.x = x - math.floor(self.width/2)
    self.scroll.y = y - math.floor(self.height/2)
end

return Camera
