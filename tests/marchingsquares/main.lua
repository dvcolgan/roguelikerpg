package.path = '../../?.lua;' .. package.path
io.stdout:setvbuf("no")

local MarchingSquares = require('lib/marchingsquares')
local collision = {
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1,
    1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1,
    1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1,
    1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1,
    1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1,
    1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1,
    1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1,
}

function love.load()
    local squares = MarchingSquares:new(collision)
    assert(#squares.unconsideredTiles == 70, 'incorrect number of squares')
    --local areas = squares:findMapAreas()
    --for i, area in ipairs(areas) do
    --    print('------------------')
    --    for i, square in ipairs(area) do
    --        print(i, square.col, square.row, square.value)
    --    end
    --    print('------------------')
    --end

    local vertexGroups = squares:findMapBoxVertexGroups()
    for i, vertexGroup in ipairs(vertexGroups) do
        print('------------------')
        print(
            vertexGroup.topLeft.x,     vertexGroup.topLeft.y,
            vertexGroup.topRight.x,    vertexGroup.topRight.y,
            vertexGroup.bottomLeft.x,  vertexGroup.bottomLeft.y,
            vertexGroup.bottomRight.x, vertexGroup.bottomRight.y
        )
        print('------------------')
    end



    love.event.quit()
end
