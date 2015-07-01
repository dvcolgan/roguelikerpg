math.randomseed(os.time())

local Engine = require('engine')

function love.load()
    local GameState = require('states/game')
    Engine:setState(GameState)
end

function love.draw()
    Engine:draw()
end

function love.update(dtInSec)
    Engine:update(dtInSec)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    else
        if key == ' ' then key = 'space' end
        if key == ',' then key = 'comma' end
        Engine:trigger('keyDown', key)
    end
end

function love.keyreleased(key)
    if key == ' ' then key = 'space' end
    if key == ',' then key = 'comma' end
    Engine:trigger('keyUp', key)
end

function love.mousepressed(x, y, button)
    Engine:trigger('mouseDown', x, y, button)
end

function love.mousereleased(x, y, button)
    Engine:trigger('mouseUp', x, y, button)
end

function love.mousemoved(x, y, dx, dy)
    Engine:trigger('mouseMove', x, y, dx, dy)
end
