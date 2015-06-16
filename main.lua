local Engine = require('lib/eventengine')


function love.load()
    engine = Engine:new()
    engine:addModels({
        player=require('models/player'),
        key=require('models/key'),
        bulletManager=require('models/bullet-manager'),
    })
    engine:addStates({
        title=require('states/title'),
    })
end


function love.draw()
    engine:draw()
end


function love.update(dt)
    engine:update(dt)
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
