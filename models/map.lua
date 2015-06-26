local class = require('middleclass')
local G = require('constants')


local Map = class('Map')

function Map:initialize(engine)
    self.engine = engine
    self.quads = {}
    
    self.worldTemplate = require('scenarios/prisonship/world')
    self.roomTemplates = require('scenarios/prisonship/rooms')
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

function Map:chooseRandomRoom(roomType)
    local roomsOfType = self.roomTemplates[roomType]
    local index = math.random(#roomsOfType)
    return roomsOfType[index], index
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
                    roomType = 'deck'
                    floor[key], index = self:chooseRandomRoom(roomType)
                    floor[key].index = index
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

function Map:collidableAt(col, row)
    local index = (row-1) * G.ROOM_WIDTH + col
    return self.currentRoom.collision[index]
end

function Map:onChangeTile(col, row, layer, tile)
    local index = (row-1) * G.ROOM_WIDTH + col
    self.currentRoom.layers[layer][index] = tile
end
function Map:onChangeCollision(col, row, collidable)
    local index = (row-1) * G.ROOM_WIDTH + col
    self.currentRoom.collision[index] = collidable
end

function Map:onCreateNewRoom()
    local newRoom = {
        layers = {
            {
                1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
            }
        },
        collision = {
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        },
        enemies = {},
        items = {},
        script = function(engine) end,
    }

    local key = tostring(self.currentCol) .. 'x' .. tostring(self.currentRow)
    self.thisRunsRooms[self.currentFloor][key] = newRoom
    table.insert(self.roomTemplates.deck, newRoom)
    newRoom.index = #self.roomTemplates.deck

    self.engine:trigger('roomChange', 0, 0, 0)
end

function Map:onSaveRoomTemplates()
    local file, err = io.open(
        'scenarios/prisonship/rooms.lua', 'wb'
    )
    if err then return err end

    file:write('return {\n')

    for roomType, rooms in pairs(self.roomTemplates) do
        file:write('    ' .. roomType .. ' = {\n')
        for i, room in ipairs(rooms) do
            file:write('        {\n')

            file:write('            layers = {\n')
            for i, layer in ipairs(room.layers) do
                file:write('                {\n')
                local num = 0
                for i, tile in ipairs(layer) do
                    file:write(tostring(tile) .. ', ')
                    num = num + 1
                    if num % G.ROOM_WIDTH == 0 then file:write('\n') end
                end
                file:write('                },\n')
            end
            file:write('            },\n')

            file:write('            collision = {\n')
            local num = 0
            for i, tile in ipairs(room.collision) do
                file:write(tostring(tile) .. ', ')
                num = num + 1
                if num % G.ROOM_WIDTH == 0 then file:write('\n') end
            end
            file:write('            },\n')

            file:write('            enemies = {\n')
            for i, enemy in ipairs(room.enemies) do
                file:write("                {key = '" .. enemy.key .. "', col = " .. tostring(enemy.col) .. ", row = " .. tostring(enemy.row) .. "},\n")
            end
            file:write('            },\n')

            file:write('            items = {},\n')
            file:write('            script = function(engine) end,\n')

            file:write('        },\n')
        end
        file:write('    },\n')
    end

    file:write('}\n')
end

return Map
