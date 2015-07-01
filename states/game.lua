local class = require('middleclass')
local util = require('util')
local GameState = require('lib/state')
local G = require('constants')

local Bullet = require('models/bullet')
local Dialog = require('models/dialog')
local Enemy = require('models/enemy')
local Player = require('models/player')
local Gear = require('models/gear')
local Physics = require('models/physics')
local Asset = require('models/asset')


local GameState = class('GameState', GameState)

function GameState:create()
    love.graphics.setBackgroundColor(255, 255, 255)
    love.graphics.setNewFont(18)
    self.engine:trigger('roomChange', 0, 0)
    love.mouse.setVisible(false)
    Physics.world:setCallbacks(nil, nil, nil, self.physicsPostSolve)
end

function GameState:update(dtInSec)
    Player:syncLastCoordinates()
    Enemy:update(dtInSec)
    Physics:update(dtInSec)
end

function GameState:physicsPostSolve(a, b, coll)
    local uuidA = a:getUserData()
    local uuidB = b:getUserData()
    local enemyUuid = nil
    local playerUuid = nil
    local gearUuid = nil
    local bulletUuid = nil

    -- Determine the nature of the collision participants
    if Bullet:isBullet(uuidA) then bulletUuid = uuidA end
    if Bullet:isBullet(uuidB) then bulletUuid = uuidB end
    if Enemy:isEnemy(uuidA) then enemyUuid = uuidA end
    if Enemy:isEnemy(uuidB) then enemyUuid = uuidB end
    if Gear:isGear(uuidA) then gearUuid = uuidA end
    if Gear:isGear(uuidB) then gearUuid = uuidB end
    if Player:isPlayer(uuidA) then playerUuid = uuidA end
    if Player:isPlayer(uuidB) then playerUuid = uuidB end

    if bulletUuid and enemyUuid then
        -- bullet hit enemy
        local enemyPhysics = Physics:get(enemyUuid)
        local gear = Gear:spawn(
            enemyPhysics.body:getX(),
            enemyPhysics.body:getY(),
            5
        )
        Physics:buildGear(gear)
        Enemy:remove(enemyUuid)
        Physics:remove(enemyUuid)

    elseif bulletUuid  then
        -- bullet hit wall
        self.engine:trigger('bulletCollided', uuidA)

    elseif gearUuid and playerUuid then
        -- player hit gear
        self.engine:trigger('collectGear', uuidA)
        Gear:remove(gearUuid)
        Physics:remove(gearUuid)
        Player:collectGears(1)
    end
end

function GameState:onMouseDown(mouseX, mouseY, button)
    if button == 'l' then
        local bullet = Player:createBullet(
            Physics:get(Player.player.uuid),
            mouseX,
            mouseY
        )
        local Bullet:fire(bullet)
    end
end

function GameState:onRoomChange(dx, dy)
    Bullet:clear()
    Dialog:reset()
    Enemy:clear()
    Gear:clear()
    Physics:clear()
    Map:transitionBy(dx, dy)
    Physics:buildRoom(Map.currentRoom.enemies)
    Physics:buildEnemies(Enemy.enemies)
    Physics:buildPlayer(Player.player)
end

function GameState:draw()
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

    -- Check if offscreen
    local offscreen, dx, dy = Physics:checkIfOffscreen(Player.player.uuid)
    if offscreen then
        self.engine:trigger('roomChange', dx, dy)
    end
end

function GameState:drawGears()
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

function GameState:drawNPCs()
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

function GameState:drawEnemies()
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

function GameState:drawCrosshairs()
    local image = self.engine.images.crosshairs
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(
        image,
        love.mouse.getX() - image:getWidth() / 2,
        love.mouse.getY() - image:getHeight() / 2
    )
end

function GameState:drawHUD()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(
        'Gears: ' .. tostring(self.engine.models.player.gears),
        20, 20
    )
end

function GameState:drawDialog()
    local boxWidth = 150*3
    local boxHeight = 60*3

    local boxX = love.graphics.getWidth() - boxWidth - 20
    local boxY = 20

    local dialog = self.engine.models.dialog
    if dialog.show then
        love.graphics.setColor(0, 0, 0, 255)
        util.roundrect(
            'fill', boxX, boxY,
            boxWidth, boxHeight,
            15, 15
        )
        love.graphics.setColor(255, 255, 255, 255)
        util.roundrect(
            'fill', boxX + 4, boxY + 4,
            boxWidth - 8, boxHeight - 8,
            10, 10
        )
        love.graphics.setColor(0, 0, 0, 255)
        util.roundrect(
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

function GameState:drawPlayer()
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

function GameState:drawBullets()
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

function GameState:drawTileMap()
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

function GameState:drawVertexGroups()
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

function GameState:drawInventory()
    local boxWidth = love.graphics.getWidth() - 40
    local boxHeight = love.graphics.getHeight() + 20

    local boxX = 20
    local boxY = 20

    love.graphics.setColor(0, 0, 0, 255)
    util.roundrect(
        'fill', boxX, boxY,
        boxWidth, boxHeight,
        15, 15
    )
    love.graphics.setColor(255, 255, 255, 255)
    util.roundrect(
        'fill', boxX + 4, boxY + 4,
        boxWidth - 8, boxHeight - 8,
        10, 10
    )
    love.graphics.setColor(0, 0, 0, 255)
    util.roundrect(
        'fill', boxX + 8, boxY + 8,
        boxWidth - 16, boxHeight - 16,
        10, 10
    )
end

function GameState:drawEditor()
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

function GameState:drawMinimap()
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

return GameState
