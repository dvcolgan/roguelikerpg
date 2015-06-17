local class = require('middleclass')
local G = require('constants')
local testMap = require('levels/test')


local Map = class('Map')

function Map:initialize(engine)
    self.engine = engine
    self.quads = {}
    self.tiles = testMap.layers[1].data
    self.width = testMap.width
    self.height = testMap.height

    local tilesheet = engine.images.tilesheet
    local tilesheetWidth = tilesheet:getWidth()
    local tilesheetHeight = tilesheet:getHeight()
    local tilesWide = math.floor(tilesheetWidth / G.TILE_SIZE)
    local tilesHigh = math.floor(tilesheetHeight / G.TILE_SIZE)

    local i = 1
    for y = 0, tilesHigh - 1 do
        for x = 0, tilesWide - 1 do
            self.quads[i] = love.graphics.newQuad(
                x * G.TILE_SIZE,
                y * G.TILE_SIZE,
                G.TILE_SIZE,
                G.TILE_SIZE,
                tilesheetWidth,
                tilesheetHeight
            )
            i = i + 1
        end
    end
end

function Map:tileAt(col, row)
    local index = row * self.width + col
    local tile = self.tiles[index]
    return tile
end

return Map
