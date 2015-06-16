local titleState = require('states/title')


function love.draw()
    titleState.draw(titleState.vm)
end


function love.update(dt)
    titleState.update(dt, titleState.vm)
end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end
