local util = require('util')
local G = require('constants')

local Asset = require('models/asset')
local Bullet = require('models/bullet')
local Dialog = require('models/dialog')
local Editor = require('models/editor')
local Enemy = require('models/enemy')
local Flag = require('models/flag')
local Gear = require('models/gear')
local Inventory = require('models/inventory')
local Item = require('models/item')
local Key = require('models/key')
local Map = require('models/map')
local NPC = require('models/npc')
local Physics = require('models/physics')
local Player = require('models/player')


local Engine = require('engine')


local GameState = {}

function GameState:onUpdate(dtInSec)
    local playerPhysics = Physics:get(Player.player.uuid)

    Player:syncLastCoordinates(playerPhysics)

    for enemyUuid, enemy in pairs(Enemy.enemies) do
        local enemyPhysics = Physics:get(enemyUuid)
        if enemyPhysics then
            local bulletSpec = Enemy:tryFire(
                dtInSec,
                enemyUuid,
                enemyPhysics,
                playerPhysics
            )
            if bulletSpec then
                local bullet = Bullet:fire(bulletSpec)
                Physics:buildAndFireBullet(bullet)
            end
        end
    end
    Physics:movePlayer(
        dtInSec,
        Player.player,
        playerPhysics,
        Key.states
    )
    Physics:simulate(dtInSec)
end

function GameState:onPhysicsPostSolve(a, b, coll)
    if a:isDestroyed() or b:isDestroyed() then
        return
    end
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
        local gears = Gear:spawn(
            enemyPhysics.body:getX(),
            enemyPhysics.body:getY(),
            5
        )
        for i, gear in ipairs(gears) do 
            Physics:buildGear(gear)
        end
        Enemy:remove(enemyUuid)
        Physics:remove(enemyUuid)

    elseif bulletUuid  then
        Bullet:remove(bulletUuid)
        Physics:remove(bulletUuid)

    elseif gearUuid and playerUuid then
        -- player hit gear
        Gear:remove(gearUuid)
        Physics:remove(gearUuid)
        Player:collectGears(1)
    end
end

function GameState:onMouseDown(mouseX, mouseY, button)
    if button == 'l' then
        local bulletSpec = Player:createBullet(
            Physics:get(Player.player.uuid),
            mouseX,
            mouseY
        )
        local bullet = Bullet:fire(bulletSpec)
        Physics:buildAndFireBullet(bullet)
    end
end

function GameState:onKeyDown(key)
    Key:keyDown(key)
end

function GameState:onKeyUp(key)
    Key:keyUp(key)
end

function GameState:onRoomChange(dCol, dRow, dFloor)
    Bullet:clear()
    Dialog:reset()
    Enemy:clear()
    Gear:clear()
    Physics:clear()

    -- Set up the nonphysics data for this room
    Map:transitionBy(dCol, dRow, dFloor, Engine)
    Enemy:buildEnemies(Map.currentRoom.enemies)

    -- Based on that build the physics objects
    Physics:buildRoom(Map.currentRoom.collision)
    Physics:buildEnemies(Enemy.enemies)
    Physics:buildPlayer(Player.player, Map)
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
    --self:drawEditor()
    --self:drawInventory()

    -- Check if offscreen
    local offscreen, dx, dy = Physics:checkIfOffscreen(Player.player.uuid)
    if offscreen then
        Engine:trigger('roomChange', dx, dy, 0)
    end
end

function GameState:drawGears()
    local gearImage = Asset.images.gear
    for uuid, gear in pairs(Gear.gears) do
        local gearPhysics = Physics:get(uuid)
        if gearPhysics then
            love.graphics.draw(
                gearImage,
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

function GameState:drawNPCs()
    for uuid, npc in pairs(NPC.npcs) do
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
    for uuid, enemy in pairs(Enemy.enemies) do
        local enemyPhysics = Physics:get(uuid)
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

function GameState:drawCrosshairs()
    local image = Asset.images.crosshairs
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(
        Asset.images.crosshairs,
        love.mouse.getX() - image:getWidth() / 2,
        love.mouse.getY() - image:getHeight() / 2
    )
end

function GameState:drawHUD()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(
        'Gears: ' .. tostring(Player.player.gears),
        20, 20
    )
end

function GameState:drawDialog()
    local boxWidth = 150*3
    local boxHeight = 60*3

    local boxX = love.graphics.getWidth() - boxWidth - 20
    local boxY = 20

    if Dialog.show then
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
            Dialog.speaker .. ': ' .. Dialog.text,
            boxX + 20, boxY + 20,
            boxWidth - 40
        )
    end
end

function GameState:drawPlayer()
    local playerPhysics = Physics:get(Player.player.uuid)
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
    for uuid, bullet in pairs(Bullet.bullets) do
        local bulletPhysics = Physics:get(uuid)
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
    local tilesheet = Asset.images.tilesheet

    love.graphics.setColor(255, 255, 255, 255)
    if Map.currentRoom then
        for layer = 1, #Map.currentRoom.layers do
            for row = 1, G.ROOM_HEIGHT do
                for col = 1, G.ROOM_WIDTH do
                    local tile = Map:tileAt(col, row, layer)
                    if tile ~= nil then
                        if tile > 0 then
                            love.graphics.draw(
                                tilesheet,
                                Map.quads[tile],
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
    for i, vertexGroup in ipairs(Physics.vertexGroups) do
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
    local editor = Engine.models.editor
    local map = Engine.models.map
    if editor.editing then
        -- Draw the solid parts of the map if we are editing the collision layer
        if editor.selectedLayer == 0 then

            local collision = Engine.models.map.currentRoom.collision

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
                Engine.images.tilesheetSmall,
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
    love.graphics.setLineWidth(2)

    local rooms = Map.thisRunsRooms[Map.currentFloor]
    if rooms then
        for row = 1, G.ROOM_HEIGHT do
            for col = 1, G.ROOM_WIDTH do
                local key = tostring(col) .. 'x' .. tostring(row)

                local drawX = mapX + col * (roomWidth + padding)
                local drawY = mapY + row * (roomHeight + padding)
                local room = rooms[key]

                if room then
                    if col == Map.currentCol and row == Map.currentRow then
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

love.graphics.setBackgroundColor(255, 255, 255)
love.graphics.setNewFont(18)
love.mouse.setVisible(false)

Physics.world:setCallbacks(nil, nil, nil, function(a, b, coll)
    Engine:trigger('physicsPostSolve', a, b, coll)
end)

Map:parseTileset(Asset.images.tilesheet)
Map:generateThisRunsRooms()
Engine:trigger('roomChange', 0, 0, 0)

return GameState
