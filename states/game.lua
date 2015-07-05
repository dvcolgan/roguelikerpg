local util = require('util')
local vector = require('vector')
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

    for enemyUuid, enemy in pairs(Enemy.currentEnemySet) do
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

    -- Check if offscreen
    local offscreen, dx, dy = Physics:checkIfOffscreen(Player.player.uuid)
    if offscreen then
        Engine:trigger('roomChange', dx, dy, 0)
    end
end

function GameState:onPhysicsPostSolve(a, b, coll)
    if a:isDestroyed() or b:isDestroyed() then
        -- Note, why does this have to be here?  IS THERE BUG?
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
        Gear:remove(gearUuid)
        Physics:remove(gearUuid)
        Player:collectGears(1)
    end
end

function GameState:onMouseDown(mouseX, mouseY, button)
    if button == 'l' then
        local playerPhysics = Physics:get(Player.player.uuid)

        local bulletX = playerPhysics.body:getX()
        local bulletY = playerPhysics.body:getY()

        local bulletAngle  = math.atan2(mouseY - bulletY, mouseX - bulletX)

        for i, itemKey in ipairs(Player.player.items) do
            local itemStats = Item.itemTemplates[itemKey]

            local bullet = Bullet:build({
                startX = bulletX,
                startY = bulletY,
                angle = bulletAngle + math.random() * math.pi / 8 - math.pi / 16,
                force = itemStats.power,
                size = itemStats.size,
                category = G.COLLISION.PLAYER_BULLET,
            })
            Physics:buildBullet(bullet)
        end
    end
end

function GameState:onKeyDown(key)
    Key:keyDown(key)

    if key == 'space' then
        --[[
        --find the players location in the room
        --find the nearest item
        --if the nearest item is close enough
        --remove the item from the floor
        --add the item to the players' inventory
        --]]
        local playerPhysics = Physics:get(Player.player.uuid)
        local item = Item:pickUp(
            playerPhysics.body:getX(),
            playerPhysics.body:getY()
        )
        if item then
            Player:addItem(item.key)
            Item:remove(item.uuid)
        end
    end
end

function GameState:onKeyUp(key)
    Key:keyUp(key)
end

function GameState:onRoomChange(dCol, dRow, dFloor)
    local playerPhysics = Physics:get(Player.player.uuid)
    if playerPhysics then
        playerPhysics.body:setLinearVelocity(0, 0)
    end

    local key = Map:transitionBy(dCol, dRow, dFloor, Engine)
    Physics:activateRoom(key)
    Physics:positionPlayerOnRoomEnter(
        key,
        Player.player,
        Physics:get(Player.player.uuid),
        Map
    )
    Enemy:activateRoom(key)
    Item:activateRoom(key)
end

function GameState:draw()
    love.graphics.clear()
    self:drawTileMap()
    self:drawItemsOnGround()
    self:drawGears()
    self:drawPlayer()
    self:drawNPCs()
    self:drawEnemies()
    self:drawBullets()
    self:drawHealthBars()
    self:drawCrosshairs()
    self:drawHUD()
    self:drawDialog()
    self:drawMinimap()
    --self:drawEditor()
    --self:drawInventory()
end

function GameState:drawGears()
    love.graphics.setColor(255, 255, 255, 255)
    local gearImage = Asset.images.gear
    for uuid, gear in pairs(Gear.currentGearSet) do
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
    for uuid, enemy in pairs(Enemy.currentEnemySet) do
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

function HSV(h, s, v)
    if s <= 0 then return v,v,v end
    h, s, v = h/256*6, s/255, v/255
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0,0,0
    if h < 1     then r,g,b = c,x,0
    elseif h < 2 then r,g,b = x,c,0
    elseif h < 3 then r,g,b = 0,c,x
    elseif h < 4 then r,g,b = 0,x,c
    elseif h < 5 then r,g,b = x,0,c
    else              r,g,b = c,0,x
    end return (r+m)*255,(g+m)*255,(b+m)*255
end

function GameState:drawHealthBars()
    for uuid, enemy in pairs(Enemy.currentEnemySet) do
        local enemyPhysics = Physics:get(uuid)
        if enemyPhysics then
            drawHealthBar(enemy, enemyPhysics)
        end
    end
    drawHealthBar(Player.player, Physics:get(Player.player.uuid))
end

function drawHealthBar(object, physics)
    local drawX = physics.body:getX() - G.HEALTH_BAR_WIDTH / 2
    local drawY = physics.body:getY() - G.HEALTH_BAR_WIDTH / 2

    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.rectangle('fill',
        drawX, drawY,
        G.HEALTH_BAR_WIDTH,
        G.HEALTH_BAR_HEIGHT
    )
    local healthPercent = object.health / object.maxHealth
    local r, g, b = HSV(85 * healthPercent, 255, 255)
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle('fill',
        drawX, drawY,
        G.HEALTH_BAR_WIDTH * healthPercent,
        G.HEALTH_BAR_HEIGHT
    )
end

function lerp(a,b,t) return (1-t)*a + t*b end

function calculateSpread(startX, startY, endX, endY)
end

function GameState:drawCrosshairs()
    local image = Asset.images.crosshairs
    local playerPhysics = Physics:get(Player.player.uuid)
    local startX = playerPhysics.body:getX()
    local startY = playerPhysics.body:getY()
    local mouseX = love.mouse.getX()
    local mouseY = love.mouse.getY()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(
        Asset.images.crosshairs,
         mouseX - image:getWidth() / 2,
         mouseY - image:getHeight() / 2
    )

    local bulletAngle  = math.deg(math.atan2(mouseY - startY, mouseX - startX))
    local dist = vector.dist(startX, startY, mouseX, mouseY)

    local angleFactor = dist / 600
    if angleFactor > 1 then angleFactor = 1 end
    local angle = lerp(80, 0, angleFactor)

    print(angleFactor)

    local leftAngle = bulletAngle - angle
    local rightAngle = bulletAngle + angle
    --print(leftAngle, rightAngle)

    -- at dist == 0, spread = 160
    -- at dist == infinity, spread = 0

    love.graphics.line(
        startX,
        startY,
        startX + dist * math.cos(math.rad(leftAngle)),
        startY + dist * math.sin(math.rad(leftAngle))
    )
    love.graphics.line(
        startX,
        startY,
        startX + dist * math.cos(math.rad(rightAngle)),
        startY + dist * math.sin(math.rad(rightAngle))
    )
end

function GameState:drawHUD()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print('Gears: ' .. tostring(Player.player.gears), 20, 20)
    love.graphics.print('Inventory:', 20, 36)
    for i, item in ipairs(Player.player.items) do
        love.graphics.print(
            item,
            20, 36 + i * 36
        )
    end
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
    for uuid, bullet in pairs(Bullet.currentBulletSet) do
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

function GameState:drawItemsOnGround()
    for uuid, item in pairs(Item.currentItemSet) do
        love.graphics.setColor(0, 0, 255, 255)
        love.graphics.rectangle(
            'fill',
            item.x - G.ITEM_ON_FLOOR_SIZE / 2,
            item.y - G.ITEM_ON_FLOOR_SIZE / 2,
            G.ITEM_ON_FLOOR_SIZE, G.ITEM_ON_FLOOR_SIZE
        )
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

    local rooms = Map.thisRunsRoomTemplates
    if rooms then
        for row = 1, G.ROOM_HEIGHT do
            for col = 1, G.ROOM_WIDTH do
                local key = tostring(col) .. 'x' .. tostring(row) .. 'x3'

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

function physicsPostSolve(a, b, coll)
    Engine:trigger('physicsPostSolve', a, b, coll)
end

love.graphics.setBackgroundColor(255, 255, 255)
love.graphics.setNewFont(18)
love.mouse.setVisible(false)
Map:parseTileset(Asset.images.tilesheet)

for key, roomTemplate in pairs(Map:generateThisRunsRooms()) do
    Bullet:initializeRoom(key)
    Enemy:initializeRoom(key)
    Physics:initializeRoom(key)
    Item:initializeRoom(key)

    Physics.worlds[key]:setCallbacks(nil, nil, nil, physicsPostSolve)

    Physics:buildRoom(key, roomTemplate.collision)

    for i, enemyData in ipairs(roomTemplate.enemies) do
        local enemy = Enemy:build(key, enemyData)
        Physics:buildEnemy(key, enemy)
    end
    for i, itemData in ipairs(roomTemplate.items) do
        Item:spawn(key, itemData)
    end

    Physics:buildPlayer(key, Player.player)
end
Map:activateRoom(5, 3, 3)
Engine:trigger('roomChange', 0, 0, 0)

return GameState
