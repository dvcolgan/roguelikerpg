local class = require('middleclass')
local GameState = require('lib/state')
local G = require('constants')


local OverworldState = class('OverworldState', GameState)

function OverworldState:create()
    self.engine:trigger('roomChange', 0, 0)
end

function OverworldState:draw()
    self:drawTileMap()
    self:drawPlayer()
    self:drawNPCs()
    self:drawBullets()
    self:drawDialog()
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

function OverworldState:drawDialog()
    local boxWidth = 150*3
    local boxHeight = 60*3
    local dialog = self.engine.models.dialog
    if dialog.show then
        love.graphics.setColor(0, 0, 255, 255)
        love.graphics.rectangle('fill',
            love.graphics.getWidth() - boxWidth - 20,
            20,
            boxWidth,
            boxHeight
        )
    end
end

function OverworldState:drawPlayer()
    local player = self.engine.models.player
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.rectangle(
        'fill',
        player.x,
        player.y,
        48, 48
    )
end

function OverworldState:drawBullets()
    local bulletManager = self.engine.models.bulletManager
    love.graphics.setColor(255, 0, 0, 255)
    for i, bullet in ipairs(bulletManager.bullets) do
        love.graphics.rectangle(
            'fill',
            bullet.x,
            bullet.y,
            8, 8
        )
    end
end

function OverworldState:drawTileMap()
    local player = self.engine.models.player
    local tilesheet = self.engine.images.tilesheet
    local map = self.engine.models.map

    love.graphics.setColor(255, 255, 255, 255)
    for layer = 1, #map.layers do
        for row = 1, G.ROOM_HEIGHT do
            for col = 1, G.ROOM_WIDTH do
                local tile = map:tileAt(col, row, layer)
                if tile ~= nil then
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

return OverworldState
