local class = require('middleclass')
local G = require('constants')


local MarchingSquares = class('MarchingSquares')

function MarchingSquares:initialize(collision)
    self.collision = collision
    self.unconsideredTiles = {}
    self.areas = {}
    self.boxes = {}
    self.vertexGroups = {}

    -- Convert the collision array into a list of
    -- coordinates for all tiles that are collidable
    local i = 1
    for row = 1, G.ROOM_HEIGHT do
        for col = 1, G.ROOM_WIDTH do
            local index = (row-1) * G.ROOM_WIDTH + col
            local value = self.collision[index]
            if value == 1 then
                self.unconsideredTiles[i] = {
                    index = i,
                    col = col,
                    row = row,
                    value = value,
                }
                i = i + 1
            end
        end
    end

end

function MarchingSquares:findMapAreas()
    while next(self.unconsideredTiles) do
        local area = self:findNextArea()
        table.insert(self.areas, area)
    end
    return self.areas
end

function MarchingSquares:findMapBoxes()
    self:findMapAreas()
    for i, area in ipairs(self.areas) do
        local topLeft = nil
        local topRight = nil
        local bottomLeft = nil
        local bottomRight = nil
        for j, square in ipairs(area) do
            if topLeft == nil then topLeft = square end
            if topRight == nil then topRight = square end
            if bottomLeft == nil then bottomLeft = square end
            if bottomRight == nil then bottomRight = square end

            if square.col < topLeft.col then topLeft = square end
            if square.col < bottomLeft.col then bottomLeft = square end
            if square.col > topRight.col then topRight = square end
            if square.col > bottomRight.col then bottomRight = square end

            if square.row < topLeft.row then topLeft = square end
            if square.row < topRight.row then topRight = square end
            if square.row > bottomLeft.row then bottomLeft = square end
            if square.row > bottomRight.row then bottomRight = square end
        end
        table.insert(self.boxes, {
            topLeft = topLeft,
            topRight = topRight,
            bottomLeft = bottomLeft,
            bottomRight = bottomRight,
        })
    end
    return self.boxes
end

function MarchingSquares:findMapBoxVertexGroups()
    self:findMapBoxes()
    for i, box in ipairs(self.boxes) do
        local vertexGroup = {}
        vertexGroup.topLeft = {
            x = (box.topLeft.col-1) * G.TILE_SIZE,
            y = (box.topLeft.row-1) * G.TILE_SIZE,
        }
        vertexGroup.topRight = {
            x = (box.topRight.col-1) * G.TILE_SIZE + G.TILE_SIZE,
            y = (box.topRight.row-1) * G.TILE_SIZE,
        }
        vertexGroup.bottomLeft = {
            x = (box.bottomLeft.col-1) * G.TILE_SIZE,
            y = (box.bottomLeft.row-1) * G.TILE_SIZE + G.TILE_SIZE,
        }
        vertexGroup.bottomRight = {
            x = (box.bottomRight.col-1) * G.TILE_SIZE + G.TILE_SIZE,
            y = (box.bottomRight.row-1) * G.TILE_SIZE + G.TILE_SIZE,
        }
        vertexGroup.color = {
            r = math.random(255),
            g = math.random(255),
            b = math.random(255),
        }
        table.insert(self.vertexGroups, vertexGroup)
    end
    return self.vertexGroups
end

function MarchingSquares:printUnconsideredTiles()
    print('--------------------------------')
    for i, square in pairs(self.unconsideredTiles) do
        print(i, square.col, square.row, square.value)
    end
    print('--------------------------------')
end

function MarchingSquares:findNextArea()
    local area = {}

    local direction = 'right'
    local bumpedRight = false
    local bumpedDown = false
    local topleft = self:findNextUnusedUpperLeftSquare()
    local startCol = topleft.col
    local startRow = topleft.row
    local rightmostCol = startCol
    local bottommostRow = startRow

    table.insert(area, topleft)
    self.unconsideredTiles[topleft.index] = nil
    --self:printUnconsideredTiles()

    while true do
        if bumpedRight and bumpedDown then
            break
        end
        if direction == 'right' then
           -- Iterate over each tile on the edge of the current area
            local newTiles = {}
            local consideredCol = rightmostCol + 1
            for row = startRow, bottommostRow do
                local unconsideredIndex, tile = self:getUnconsideredTile(consideredCol, row)
                -- If this tile is not used in another area already, add it to the row tentatively
                if tile ~= nil and tile.value == 1 then
                    local index = (row-1) * G.ROOM_WIDTH + consideredCol
                    newTiles[unconsideredIndex] = tile
                else
                    -- otherwise we have hit this wall, break and don't do anything
                    bumpedRight = true
                    direction = 'down'
                    newTiles = nil
                    break
                end
            end
            if newTiles ~= nil then
                -- Put the new tiles into the area, and remove them from the rest
                -- to be considered
                for unconsideredIndex, tile in pairs(newTiles) do
                    table.insert(area, tile)
                    self.unconsideredTiles[unconsideredIndex] = nil
                end
                rightmostCol = rightmostCol + 1
                if not bumpedDown then direction = 'down' end
            end
        elseif direction == 'down' then
            -- Iterate over each tile on the edge of the current area
            local newTiles = {}
            local consideredRow = bottommostRow + 1
            for col = startCol, rightmostCol do
                local unconsideredIndex, tile = self:getUnconsideredTile(col, consideredRow)
                -- If this tile is not used in another area already, add it to the row tentatively
                if tile ~= nil and tile.value == 1 then
                    local index = (consideredRow-1) * G.ROOM_WIDTH + col
                    newTiles[unconsideredIndex] = tile
                else
                    -- otherwise we have hit this wall, break and don't do anything
                    bumpedDown = true
                    direction = 'right'
                    newTiles = nil
                    break
                end
            end
            if newTiles ~= nil then
                -- Put the new tiles into the area, and remove them from the rest
                -- to be considered
                for unconsideredIndex, tile in pairs(newTiles) do
                    table.insert(area, tile)
                    self.unconsideredTiles[unconsideredIndex] = nil
                end
                bottommostRow = bottommostRow + 1
                if not bumpedRight then direction = 'right' end
            end
        end
    end
    return area
end

function MarchingSquares:findNextUnusedUpperLeftSquare()
    local topleft = self.unconsideredTiles[next(self.unconsideredTiles)]
    for i, square in pairs(self.unconsideredTiles) do
        if square.col < topleft.col or square.row < topleft.row then
            topleft = square
        end
    end
    return topleft
end

function MarchingSquares:getUnconsideredTile(col, row)
    for i, tile in pairs(self.unconsideredTiles) do
        if tile.col == col and tile.row == row then
            return i, tile
        end
    end
    return nil
end

return MarchingSquares
