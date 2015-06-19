local class = require('middleclass')
local G = require('constants')


local Map = class('Map')


function Map:initialize(engine)
    self.rooms = {}
    roomFileNames = love.filesystem.getDirectoryItems('levels/test')
    for i, roomFileName in ipairs(roomFileNames) do
        if not string.find(roomFileName, '%.swp$') then
            _, _, roomName = string.find(roomFileName, '_(.-).lua')
            requirePath = 'levels/test/' .. string.gsub(roomFileName, '.lua', '')
            self.rooms[roomName] = require(requirePath)
        end
    end
    self.roomX = 0
    self.roomY = 0

    self.engine = engine
    self.layers = {}

    -- Parse the tileset into quads
    self.quads = {}
    local tilesheet = engine.images.tilesheet
    local tilesheetWidth = tilesheet:getWidth()
    local tilesheetHeight = tilesheet:getHeight()
    local tilesWide = math.floor(tilesheetWidth / G.TILE_SIZE)
    local tilesHigh = math.floor(tilesheetHeight / G.TILE_SIZE)

    -- Make quads for the map
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

function Map:onRoomChange(dx, dy)
    self.roomX = self.roomX + dx
    self.roomY = self.roomY + dy
    local key = tostring(self.roomX) .. 'x' .. tostring(self.roomY)
    if self.rooms[key] then
        self.engine:trigger('roomNeeded', key)
    end
end

function Map:onRoomNeeded(key)
    local roomData = self.rooms[key]
    self.layers = roomData.layers
    roomData.script(self.engine)
end

function Map:tileAt(col, row, layer)
    local layerData = self.layers[layer]
    if layerData then
        local index = (row-1) * G.ROOM_WIDTH + col return layerData[index]
    end
    return nil
end

return Map
