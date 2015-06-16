local Engine = require('lib/eventengine')


function love.load()
    engine = Engine:new()
    engine:addModels({
        Player=require('models/player'),
        Key=require('models/key'),
        BulletManager=require('models/bullet-manager'),
    })
end


function love.draw()
    engine:draw()
end


function love.update(dt)
    engine:pump()
    titleState.update(dt, titleState.vm)
end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    else
        if key == ' ' then key = 'space' end
        if key == ',' then key = 'comma' end
        events.keyDown(key)
    end
end


function love.keyreleased(key)
    if key == ' ' then key = 'space' end
    if key == ',' then key = 'comma' end
    events.keyUp(key)
end
