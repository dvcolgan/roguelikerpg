local playerStore = require('stores/player')
local stateStore = require('stores/state')
local events = require('events')


views = {
    title = require('views/title'),
    overworld = require('views/overworld'),
}


function love.draw()
    views[stateStore.current]()
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


function love.update(dt)
    events.update(dt)
end
