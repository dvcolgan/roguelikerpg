math.randomseed(os.time())

local Engine = require('lib/eventengine')

function love.load()
    engine = Engine:new()
    engine:addStates(require('states/game'))
end

function love.draw()
    engine:draw()
end

function love.update(dtInSec)
    engine:update(dtInSec)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    else
        if key == ' ' then key = 'space' end
        if key == ',' then key = 'comma' end
        engine:trigger('keyDown', key)
    end
end

function love.keyreleased(key)
    if key == ' ' then key = 'space' end
    if key == ',' then key = 'comma' end
    engine:trigger('keyUp', key)
end

function love.mousepressed(x, y, button)
    engine:trigger('mouseDown', x, y, button)
end

function love.mousereleased(x, y, button)
    engine:trigger('mouseUp', x, y, button)
end

function love.mousemoved(x, y, dx, dy)
    engine:trigger('mouseMove', x, y, dx, dy)
end
