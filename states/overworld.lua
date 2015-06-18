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
    self:drawBullets()
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
