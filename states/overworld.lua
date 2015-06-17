local class = require('middleclass')
local GameState = require('lib/state')


local OverworldState = class('OverworldState', GameState)

function OverworldState:create()
end

function OverworldState:draw()
    local player = self.engine.models.player
    local camera = self.engine.models.camera
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.rectangle(
        'fill',
        player.x - camera.scroll.x,
        player.y - camera.scroll.y,
        32, 32
    )
    love.graphics.setColor(255, 255, 0, 255)
    love.graphics.rectangle(
        'fill',
        32 - camera.scroll.x,
        32 - camera.scroll.y,
        32, 32
    )
end

return OverworldState
