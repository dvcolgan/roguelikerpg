local class = require('middleclass')
local GameState = require('lib/state')
local G = require('constants')


local OverworldState = class('OverworldState', GameState)


function love.graphics.roundrect(mode, x, y, width, height, xround, yround)
	local points = {}
	local precision = (xround + yround) * .1
	local tI, hP = table.insert, .5*math.pi
	if xround > width*.5 then xround = width*.5 end
	if yround > height*.5 then yround = height*.5 end
	local X1, Y1, X2, Y2 = x + xround, y + yround, x + width - xround, y + height - yround
	local sin, cos = math.sin, math.cos
	for i = 0, precision do
		local a = (i/precision-1)*hP
		tI(points, X2 + xround*cos(a))
		tI(points, Y1 + yround*sin(a))
	end
	for i = 0, precision do
		local a = (i/precision)*hP
		tI(points, X2 + xround*cos(a))
		tI(points, Y2 + yround*sin(a))
	end
	for i = 0, precision do
		local a = (i/precision+1)*hP
		tI(points, X1 + xround*cos(a))
		tI(points, Y2 + yround*sin(a))
	end
	for i = 0, precision do
		local a = (i/precision+2)*hP
		tI(points, X1 + xround*cos(a))
		tI(points, Y1 + yround*sin(a))
	end
	love.graphics.polygon(mode, unpack(points))
end

function OverworldState:create()
    love.graphics.setBackgroundColor(255, 255, 255)
    love.graphics.setNewFont(18)
    self.engine:trigger('roomChange', 0, 0)
end

function OverworldState:draw()
    love.graphics.clear()
    self:drawTileMap()
    self:drawPlayer()
    self:drawNPCs()
    self:drawEnemies()
    self:drawBullets()
    self:drawDialog()
    self:drawMinimap()
    self:drawEditor()
    --self:drawInventory()
end

function OverworldState:drawNPCs()
    for key, npc in pairs(self.engine.models.npc.npcs) do
        love.graphics.setColor(0, 0, 255, 255)
        love.graphics.rectangle(
            'fill',
            npc.x,
            npc.y,
            48, 48
        )
    end
end

function OverworldState:drawEnemies()
    local enemies = self.engine.models.physics.objects.enemies
    if enemies then
        for _, enemy in pairs(enemies) do
            love.graphics.setColor(255, 0, 0, 255)
            love.graphics.circle(
                'fill',
                enemy.body:getX(),
                enemy.body:getY(),
                enemy.shape:getRadius(),
                16
            )
        end
    end
end

function OverworldState:drawDialog()
    local boxWidth = 150*3
    local boxHeight = 60*3

    local boxX = love.graphics.getWidth() - boxWidth - 20
    local boxY = 20

    local dialog = self.engine.models.dialog
    if dialog.show then
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.roundrect(
            'fill', boxX, boxY,
            boxWidth, boxHeight,
            15, 15
        )
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.roundrect(
            'fill', boxX + 4, boxY + 4,
            boxWidth - 8, boxHeight - 8,
            10, 10
        )
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.roundrect(
            'fill', boxX + 8, boxY + 8,
            boxWidth - 16, boxHeight - 16,
            10, 10
        )
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.printf(
            dialog.speaker .. ': ' .. dialog.text,
            boxX + 20, boxY + 20,
            boxWidth - 40
        )
    end
end

function OverworldState:drawPlayer()
    local player = self.engine.models.physics.objects.player
    if player then
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.circle(
            'fill',
            player.body:getX(),
            player.body:getY(),
            player.shape:getRadius(),
            16
        )
    end
end

function OverworldState:drawBullets()
    local bullets = self.engine.models.physics.objects.bullets
    if bullets then
        for uuid, bullet in pairs(bullets) do
            love.graphics.setColor(50, 50, 50, 255)
            love.graphics.circle(
                'fill',
                bullet.body:getX(),
                bullet.body:getY(),
                bullet.shape:getRadius(),
                16
            )
        end
    end
end

function OverworldState:drawTileMap()
    local player = self.engine.models.player
    local tilesheet = self.engine.images.tilesheet
    local map = self.engine.models.map

    love.graphics.setColor(255, 255, 255, 255)
    for layer = 1, #map.currentRoom.layers do
        for row = 1, G.ROOM_HEIGHT do
            for col = 1, G.ROOM_WIDTH do
                local tile = map:tileAt(col, row, layer)
                if tile ~= nil then
                    if tile > 0 then
                        love.graphics.draw(
                            tilesheet,
                            map.quads[tile],
                            math.floor((col-1) * G.TILE_SIZE),
                            math.floor((row-1) * G.TILE_SIZE)
                        ) 
                    end
                end
            end
        end
    end
end

function OverworldState:drawVertexGroups()
    local vertexGroups = self.engine.models.physics.vertexGroups

    for i, vertexGroup in ipairs(vertexGroups) do
        love.graphics.setColor(
            vertexGroup.color.r,
            vertexGroup.color.g,
            vertexGroup.color.b,
            255
        )
        love.graphics.rectangle(
            'fill',
            vertexGroup.topLeft.x,
            vertexGroup.topLeft.y,
            vertexGroup.topRight.x - vertexGroup.topLeft.x,
            vertexGroup.bottomLeft.y - vertexGroup.topLeft.y,
            48, 48
        )
    end
end

function OverworldState:drawInventory()
    local boxWidth = love.graphics.getWidth() - 40
    local boxHeight = love.graphics.getHeight() + 20

    local boxX = 20
    local boxY = 20

    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.roundrect(
        'fill', boxX, boxY,
        boxWidth, boxHeight,
        15, 15
    )
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.roundrect(
        'fill', boxX + 4, boxY + 4,
        boxWidth - 8, boxHeight - 8,
        10, 10
    )
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.roundrect(
        'fill', boxX + 8, boxY + 8,
        boxWidth - 16, boxHeight - 16,
        10, 10
    )
end

function OverworldState:drawEditor()
    local editor = self.engine.models.editor
    local map = self.engine.models.map
    if editor.editing then
        -- Draw the solid parts of the map if we are editing the collision layer
        if editor.selectedLayer == 0 then

            local collision = self.engine.models.map.currentRoom.collision

            for row = 1, G.ROOM_HEIGHT do
                for col = 1, G.ROOM_WIDTH do
                    local collidable = map:collidableAt(col, row)
                    if collidable == 1 then
                        love.graphics.setColor(200, 0, 0, 200)
                        love.graphics.rectangle(
                            'fill',
                            math.floor((col-1) * G.TILE_SIZE),
                            math.floor((row-1) * G.TILE_SIZE),
                            G.TILE_SIZE, G.TILE_SIZE
                        )
                        love.graphics.setColor(255, 0, 0, 200)
                        love.graphics.rectangle(
                            'fill',
                            math.floor((col-1) * G.TILE_SIZE) + 3,
                            math.floor((row-1) * G.TILE_SIZE) + 3,
                            G.TILE_SIZE - 6, G.TILE_SIZE - 6
                        )
                    end
                end
            end
        end

        love.graphics.setColor(255, 255, 255, 255)

        -- Draw tile selection overlay
        if editor.showTiles then
            love.graphics.clear()
            love.graphics.draw(
                self.engine.images.tilesheetSmall,
                0, 0
            )
        end

        local cursorX, cursorY, tileSize
        if editor.showTiles then
            tileSize = G.EDITOR_TILE_SIZE
            cursorX = (editor.hoveredTilesheetTile.col - 1) * tileSize
            cursorY = (editor.hoveredTilesheetTile.row - 1) * tileSize
        else
            tileSize = G.TILE_SIZE
            cursorX = (editor.hoveredRoomTile.col - 1) * tileSize
            cursorY = (editor.hoveredRoomTile.row - 1) * tileSize
        end

        -- Draw cursor
        love.graphics.setLineWidth(6)
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.rectangle(
            'line',
            cursorX, cursorY,
            tileSize, tileSize
        )
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle(
            'line',
            cursorX, cursorY,
            tileSize, tileSize
        )

        -- Draw message in the upper left
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.print('Editing', 20, 20)
        local message = 'Layer ' .. tostring(editor.selectedLayer)
        if editor.selectedLayer == 0 then
            message = 'Layer Collision'
        end
        love.graphics.print(message, 20, 50)
    end
end

function OverworldState:drawMinimap()
    local mapX = 4
    local mapY = 4
    local roomWidth = 30
    local roomHeight = 18
    local padding = 4
    local map = self.engine.models.map
    love.graphics.setLineWidth(2)

    local rooms = map.thisRunsRooms[map.currentFloor]
    if rooms then
        for row = 1, G.ROOM_HEIGHT do
            for col = 1, G.ROOM_WIDTH do
                local key = tostring(col) .. 'x' .. tostring(row)

                local drawX = mapX + col * (roomWidth + padding)
                local drawY = mapY + row * (roomHeight + padding)
                local room = rooms[key]

                if room then
                    if col == map.currentCol and row == map.currentRow then
                        love.graphics.setColor(0, 0, 0, 255)
                        love.graphics.rectangle(
                            'fill',
                            drawX, drawY,
                            roomWidth, roomHeight
                        )
                    end

                    love.graphics.setColor(255, 255, 255, 255)
                    love.graphics.print(
                        tostring(room.index),
                        drawX + 10, drawY - 2
                    )
                    
                    love.graphics.rectangle(
                        'line',
                        drawX, drawY,
                        roomWidth, roomHeight
                    )
                end
            end
        end
    end
end

return OverworldState
