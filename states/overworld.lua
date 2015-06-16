local playerStore = require('stores/player')


function drawPlayer(player)
    love.graphics.rectangle(
        'fill',
        player.x, player.y,
        32, 32
    )
end


return function()
    love.graphics.setColor(0, 255, 0, 255)
    drawPlayer(playerStore.player)
end
