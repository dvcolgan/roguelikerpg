math.randomseed(os.time())

local Engine = require('lib/eventengine')

function love.load()
    engine = Engine:new()
    engine:addImage('tilesheet', love.graphics.newImage('assets/tilesheet.png'))
    engine:addImage('tilesheetSmall', love.graphics.newImage('assets/tilesheet-small.png'))
    engine:addModels({
        player = require('models/player'),
        key = require('models/key'),
        bullet = require('models/bullet'),
        map = require('models/map'),
        npc = require('models/npc'),
        dialog = require('models/dialog'),
        physics = require('models/physics'),
        flag = require('models/flag'),
        enemy = require('models/enemy'),
        editor = require('models/editor'),
    })
    engine:addStates({
        --title=require('states/title'),
        overworld=require('states/overworld'),
    })
    engine:setState('overworld', {doUpdate=true, doDraw=true})
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
