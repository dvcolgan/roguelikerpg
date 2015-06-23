local class = require('middleclass')
local G = require('constants')


local Map = class('Map')


function Map:initialize(engine)
    self.engine = engine
    self.roomTemplates = {}
    self.rooms = {}
    self.enemies = {}
    self.items = {}

    -- TODO this code is duplicated in item
    roomFileNames = love.filesystem.getDirectoryItems('scenarios/prisonship/rooms')
    for i, roomFileName in ipairs(roomFileNames) do
        if not string.find(roomFileName, '%.swp$') then
            _, _, roomName = string.find(roomFileName, '(.*).lua')
            requirePath = 'scenarios/prisonship/rooms/' .. string.gsub(roomFileName, '.lua', '')
            self.roomTemplates[roomName] = require(requirePath)
        end
    end
    for name, room in pairs(self.roomTemplates) do
        print(name, room)
    end

    self.rooms = {
        ['0x0'] = self.roomTemplates.deck1
    }

    self.roomX = 0
    self.roomY = 0
    self.lastRoomX = 0
    self.lastRoomY = 0

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
    self.lastRoomX = self.roomX
    self.lastRoomY = self.roomY
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
    self.collision = roomData.collision
    self.enemies = roomData.enemies
    self.items = roomData.items
    roomData.script(self.engine)
    self.engine:trigger('mapLoaded')
end

function Map:tileAt(col, row, layer)
    local layerData = self.layers[layer]
    if layerData then
        local index = (row-1) * G.ROOM_WIDTH + col return layerData[index]
    end
    return nil
end

return Map
