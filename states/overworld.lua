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
    love.mouse.setVisible(false)
end

function OverworldState:draw()
    love.graphics.clear()
    self:drawTileMap()
    self:drawGears()
    self:drawPlayer()
    self:drawNPCs()
    self:drawEnemies()
    self:drawBullets()
    self:drawCrosshairs()
    self:drawHUD()
    self:drawDialog()
    self:drawMinimap()
    self:drawEditor()
    --self:drawInventory()
end

function OverworldState:drawGears()
    local gears = self.engine.models.gear.gears
    local sprite = self.engine.images.gear
    if gears then
        for uuid, gear in pairs(gears) do
            local gearPhysics = self.engine.models.physics.objects[uuid]
            if gearPhysics then
                love.graphics.draw(sprite,
                    gearPhysics.body:getX(),
                    gearPhysics.body:getY(),
                    gearPhysics.body:getAngle(),
                    1, 1,
                    G.GEAR_SIZE / 2,
                    G.GEAR_SIZE / 2
                )
            end
        end
    end
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
    local enemies = self.engine.models.enemy.enemies
    if enemies then
        for uuid, enemy in pairs(enemies) do
            local enemyPhysics = self.engine.models.physics.objects[uuid]
            if enemyPhysics then
                love.graphics.setColor(255, 0, 0, 255)
                love.graphics.circle(
                    'fill',
                    enemyPhysics.body:getX(),
                    enemyPhysics.body:getY(),
                    enemyPhysics.shape:getRadius(),
                    16
                )
            end
        end
    end
end

function OverworldState:drawCrosshairs()
    local image = self.engine.images.crosshairs
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(
        image,
        love.mouse.getX() - image:getWidth() / 2,
        love.mouse.getY() - image:getHeight() / 2
    )
end

function OverworldState:drawHUD()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(
        'Gears: ' .. tostring(self.engine.models.player.gears),
        20, 20
    )
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
    local player = self.engine.models.player
    local playerPhysics = self.engine.models.physics.objects[player.uuid]
    if playerPhysics then
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.circle(
            'fill',
            playerPhysics.body:getX(),
            playerPhysics.body:getY(),
            playerPhysics.shape:getRadius(),
            16
        )
    end
end

function OverworldState:drawBullets()
    local bullets = self.engine.models.bullet.bullets
    local objects = self.engine.models.physics.objects
    for uuid, bullet in pairs(bullets) do
        local bulletPhysics = objects[uuid]
        if bulletPhysics then
            love.graphics.setColor(50, 50, 50, 255)
            love.graphics.circle(
                'fill',
                bulletPhysics.body:getX(),
                bulletPhysics.body:getY(),
                bulletPhysics.shape:getRadius(),
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
    if map.currentRoom then
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
