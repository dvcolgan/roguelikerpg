local stores = require('stores')
local actions = require('actions')


function drawPlayer(player)
    love.graphics.rectangle(
        'fill',
        player.x, player.y,
        32, 32
    )
end


function love.draw()
    drawPlayer(stores.player.player)
end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    else
        actions.keyDown(key)
    end
end


function love.keyreleased(key)
    actions.keyUp(key)
end


function love.update(dt)
    actions.update(dt)
end
