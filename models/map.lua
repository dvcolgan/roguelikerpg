local class = require('middleclass')
local G = require('constants')


local Map = class('Map')


function Map:initialize(engine)
    self.engine = engine

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


function findNextUnusedUpperLeftSquare(squares)
    local topleft = squares[1]
    for i, square in ipairs(squares) do
        if square.col < topleft.col or square.row < topleft.row then
            topleft = square
        end
    end
    return topleft
end

function getUnconsideredTile(col, row, unconsideredTiles)
    for i, tile in ipairs(unconsideredTiles) do
        if tile.col == col and tile.row == row then
            return i, tile
        end
    end
    return nil
end

function findMapBoxes(collision)
    local boxes = {}
    local unconsideredTiles = {}

    -- Convert the collision array into a list of
    -- coordinates for all tiles that are collidable
    for row = 1, G.ROOM_HEIGHT do
        for col = 1, G.ROOM_HEIGHT do
            local index = (row-1) * G.ROOM_WIDTH + col
            local value = collision[index]
            if value == 1 then
                table.insert(unconsideredTiles, {
                    col = col,
                    row = row,
                    value = value,
                })
                print(col, row)
            end
        end
    end

    debug.debug()

    local timesThrough = 0
    while next(unconsideredTiles) do
        print('times through', timesThrough)
        timesThrough = timesThrough + 1
        local box = {}
        local direction = 'right'

        local startTile = findNextUnusedUpperLeftSquare(unconsideredTiles)
        
        local rightmostCol = startTile.col
        local bottommostRow = startTile.row
        local bumpedRight = false
        local bumpedDown = false

        while (not bumpedRight) or (not bumpedDown) do
            print('bumped right', bumpedRight)
            print('bumped down', bumpedDown)
            if direction == 'right' then
                print('going right')
                -- Iterate over each tile on the edge of the current box
                local newTiles = {}
                for row = startTile.row, bottommostRow do
                    local unconsideredIndex, tile = getUnconsideredTile(rightmostCol, row, unconsideredTiles)
                    -- If this tile is not used in another box already, add it to the row tentatively
                    if tile ~= nil and tile.value == 1 then
                        local index = (row-1) * G.ROOM_WIDTH + rightmostCol
                        local value = collision[index]
                        newTiles[unconsideredIndex] = tile
                    else
                        -- otherwise we have hit this wall, break and don't do anything
                        bumpedRight = true
                        newTiles = nil
                        break
                    end
                end
                if newTiles == nil then break end
                -- Put the new tiles into the box, and remove them from the rest
                -- to be considered
                for unconsideredIndex, tile in ipairs(newTiles) do
                    table.insert(box, tile)
                    unconsideredTiles[unconsideredIndex] = nil
                end
                if not bumpedDown then direction = 'down' end
            elseif direction == 'down' then
                print('going down')
                -- Iterate over each tile on the edge of the current box
                local newTiles = {}
                for col = startTile.col, rightmostCol do
                    local unconsideredIndex, tile = getUnconsideredTile(col, bottommostRow, unconsideredTiles)
                    -- If this tile is not used in another box already, add it to the row tentatively
                    if tile ~= nil and tile.value == 1 then
                        local index = (bottommostRow-1) * G.ROOM_WIDTH + col
                        local value = collision[index]
                        newTiles[unconsideredIndex] = tile
                    else
                        -- otherwise we have hit this wall, break and don't do anything
                        bumpedDown = true
                        newTiles = nil
                        break
                    end
                end
                if newTiles == nil then break end
                -- Put the new tiles into the box, and remove them from the rest
                -- to be considered
                for unconsideredIndex, tile in ipairs(newTiles) do
                    table.insert(box, tile)
                    unconsideredTiles[unconsideredIndex] = nil
                end
                if not bumpedRight then direction = 'right' end
            end
        end
        table.insert(boxes, box)
    end

    return boxes
end

function Map:onRoomNeeded(key)
    local roomData = self.rooms[key]
    self.layers = roomData.layers
    roomData.script(self.engine)
    local boxes = findMapBoxes(roomData.collision)
    for i, box in ipairs(boxes) do
        print(i, box)
    end
end

function Map:tileAt(col, row, layer)
    local layerData = self.layers[layer]
    if layerData then
        local index = (row-1) * G.ROOM_WIDTH + col return layerData[index]
    end
    return nil
end

return Map
