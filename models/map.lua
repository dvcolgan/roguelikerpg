local class = require('middleclass')
local G = require('constants')


local Map = class('Map')

function Map:initialize(engine)
    self.engine = engine
    self.quads = {}
    
    self.worldTemplate = require('scenarios/prisonship/world')
    self.roomTemplates = {}
    self.thisRunsRooms = {}

    self.currentRoom = {
        layers = {},
        collision = {},
        enemies = {},
        items = {},
    }

    self.currentCol = self.worldTemplate.start.col
    self.currentRow = self.worldTemplate.start.row
    self.currentFloor = self.worldTemplate.start.floor
    self.lastCol = self.col
    self.lastRow = self.row
    self.lastFloor = self.floor

    self:parseTileset()
    self:loadRoomTemplates()
    self:generateThisRunsRooms()
end

function Map:parseTileset()
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

function Map:loadRoomTemplates()
    self.roomTemplates = {}

    for char, roomType in pairs(self.worldTemplate.roomTypes) do
        local roomsForType = {}

        roomFileNames = love.filesystem.getDirectoryItems('scenarios/prisonship/rooms/' .. roomType)
        for i, roomFileName in ipairs(roomFileNames) do
            if not string.find(roomFileName, '%.swp$') then
                _, _, roomName = string.find(roomFileName, '(.*).lua')
                requirePath = 'scenarios/prisonship/rooms/' .. roomType .. '/' .. roomName
                table.insert(roomsForType, require(requirePath))
            end
        end
        self.roomTemplates[roomType] = roomsForType
    end
end

function Map:chooseRandomRoom(roomType)
    local roomsOfType = self.roomTemplates[roomType]
    return roomsOfType[math.random(#roomsOfType)]
end

function Map:generateThisRunsRooms()
    self.thisRunsRooms = {}
    for which, floorTemplate in pairs(self.worldTemplate.floors) do
        local floor = {}
        local i = 1
        for row = 1, self.worldTemplate.floorHeight do
            for col = 1, self.worldTemplate.floorWidth do
                local key = tostring(col) .. 'x' .. tostring(row)
                local char = floorTemplate.rooms[i]
                local roomType = self.worldTemplate.roomTypes[char]
                if roomType ~= nil then
                    floor[key] = self:chooseRandomRoom(roomType)
                end
                i = i + 1
            end
        end
        self.thisRunsRooms[which] = floor
    end
end

function Map:onRoomChange(dCol, dRow, dFloor)
    self.lastCol = self.currentCol
    self.lastRow = self.currentRow
    self.lastFloor = self.currentFloor
    self.currentCol = self.currentCol + dCol
    self.currentRow = self.currentRow + dRow
    local key = tostring(self.currentCol) .. 'x' .. tostring(self.currentRow)
    if self.thisRunsRooms[self.currentFloor][key] then
        self.engine:trigger('roomNeeded', self.currentFloor, key)
    end
end


function Map:onRoomNeeded(floor, key)
    print(floor, key)
    local roomData = self.thisRunsRooms[floor][key]
    self.currentRoom.layers = roomData.layers
    self.currentRoom.collision = roomData.collision
    self.currentRoom.enemies = roomData.enemies
    self.currentRoom.items = roomData.items
    roomData.script(self.engine)
    self.engine:trigger('mapLoaded')
end

function Map:tileAt(col, row, layer)
    local layerData = self.currentRoom.layers[layer]
    if layerData then
        local index = (row-1) * G.ROOM_WIDTH + col
        return layerData[index]
    end
    return nil
end

function Map:onChangeTile(col, row, layer, tile)
    local index = (row-1) * G.ROOM_WIDTH + col
    self.currentRoom.layers[layer][index] = tile
end

return Map
