local Engine = require('lib/eventengine')

function love.load()
    engine = Engine:new()
    engine:addImage('tilesheet', love.graphics.newImage('assets/tilesheet-test.png'))
    local background = love.graphics.newImage('assets/squared_metal.png')
    background:setWrap('repeat', 'repeat')
    engine:addImage('background', background)
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
