local class = require('middleclass')
local G = require('constants')


local MarchingSquares = class('MarchingSquares')

function MarchingSquares:initialize(collision)
    self.collision = collision
    self.unconsideredTiles = {}
    self.boxes = {}

    -- Convert the collision array into a list of
    -- coordinates for all tiles that are collidable
    for row = 1, G.ROOM_HEIGHT do
        for col = 1, G.ROOM_WIDTH do
            local index = (row-1) * G.ROOM_WIDTH + col
            local value = self.collision[index]
            if value == 1 then
                table.insert(self.unconsideredTiles, {
                    col = col,
                    row = row,
                    value = value,
                })
            end
        end
    end

end

function MarchingSquares:printUnconsideredTiles()
    for i, square in ipairs(self.unconsideredTiles) do
        print(i, square.col, square.row, square.value)
    end
end

function MarchingSquares:findNextBox()
    local box = {}

    self:printUnconsideredTiles()
    local direction = 'right'
    local bumpedRight = false
    local bumpedDown = false
    local startCol, startRow = self:findNextUnusedUpperLeftSquare()
    local rightmostCol = startCol
    local bottommostRow = startRow

    while (not bumpedRight) or (not bumpedDown) do
        print('bumped right', bumpedRight)
        print('bumped down', bumpedDown)
        if direction == 'right' then
            print('going right')
            -- Iterate over each tile on the edge of the current box
            local newTiles = {}
            for row = startRow, bottommostRow do
                local unconsideredIndex, tile = self:getUnconsideredTile(rightmostCol, row)
                -- If this tile is not used in another box already, add it to the row tentatively
                if tile ~= nil and tile.value == 1 then
                    local index = (row-1) * G.ROOM_WIDTH + rightmostCol
                    local value = self.collision[index]
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
                self.unconsideredTiles[unconsideredIndex] = nil
            end
            if not bumpedDown then direction = 'down' end
        elseif direction == 'down' then
            print('going down')
            -- Iterate over each tile on the edge of the current box
            local newTiles = {}
            for col = startCol, rightmostCol do
                local unconsideredIndex, tile = self:getUnconsideredTile(col, bottommostRow)
                -- If this tile is not used in another box already, add it to the row tentatively
                if tile ~= nil and tile.value == 1 then
                    local index = (bottommostRow-1) * G.ROOM_WIDTH + col
                    local value = self.collision[index]
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
                self.unconsideredTiles[unconsideredIndex] = nil
            end
            if not bumpedRight then direction = 'right' end
        end
    end
    return box
end

function MarchingSquares:findMapBoxes()
    local timesThrough = 0
    while next(self.unconsideredTiles) do
        local box = self:findNextBox()
        table.insert(self.boxes, box)
        print('times through', timesThrough)
        timesThrough = timesThrough + 1
    end
    return boxes
end

function MarchingSquares:findNextUnusedUpperLeftSquare()
    print('-----')
    print('unconsidered values')
    for i, val in pairs(self.unconsideredTiles) do
        print(i, val)
    end
    local topleft = self.unconsideredTiles[1]
    print('topleft', topleft)
    print('-----')
    for i, square in ipairs(self.unconsideredTiles) do
        if square.col < topleft.col or square.row < topleft.row then
            topleft = square
        end
    end
    return topleft.col, topleft.row
end

function MarchingSquares:getUnconsideredTile(col, row)
    for i, tile in ipairs(self.unconsideredTiles) do
        if tile.col == col and tile.row == row then
            return i, tile
        end
    end
    return nil
end

return MarchingSquares
