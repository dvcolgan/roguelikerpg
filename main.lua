local playerStore = require('stores/player')
local events = require('events')


function drawPlayer(player)
    love.graphics.rectangle(
        'fill',
        player.x, player.y,
        32, 32
    )
end


function love.draw()
    drawPlayer(playerStore.player)
end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    else
        events.keyDown(key)
    end
end


function love.keyreleased(key)
    events.keyUp(key)
end


function love.update(dt)
    events.update(dt)
end
