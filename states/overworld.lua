local class = require('middleclass')
local GameState = require('lib/state')
local G = require('constants')


local OverworldState = class('OverworldState', GameState)

function OverworldState:create()
end

function OverworldState:draw()
    self:drawTileMap()
    self:drawPlayer()
    self:drawBullets()
end

function OverworldState:drawPlayer()
    local player = self.engine.models.player
    local camera = self.engine.models.camera
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.rectangle(
        'fill',
        player.x - camera.scroll.x,
        player.y - camera.scroll.y,
        32, 32
    )
end

function OverworldState:drawBullets()
    local bulletManager = self.engine.models.bulletManager
    local camera = self.engine.models.camera
    love.graphics.setColor(255, 0, 0, 255)
    for i, bullet in ipairs(bulletManager.bullets) do
        love.graphics.rectangle(
            'fill',
            bullet.x - camera.scroll.x,
            bullet.y - camera.scroll.y,
            8, 8
        )
    end
end

function OverworldState:drawTileMap()
    local player = self.engine.models.player
    local camera = self.engine.models.camera
    local tilesheet = self.engine.images.tilesheet
    local map = self.engine.models.map

    love.graphics.setColor(255, 255, 255, 255)
    local bounds = camera:getOnScreenTileBounds()
    for row = bounds.rowMin, bounds.rowMax do
        for col = bounds.colMin, bounds.colMax do
            local tile = map:tileAt(col, row)
            if tile ~= nil then
                love.graphics.draw(
                    tilesheet,
                    map.quads[tile],
                    math.floor(col * G.TILE_SIZE - camera.scroll.x),
                    math.floor(row * G.TILE_SIZE - camera.scroll.y)
                )
            end
        end
    end
end

return OverworldState
