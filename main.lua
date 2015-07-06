local game = {
    images = nil,
    state = nil,
}

function love.load()
    game.images = {
        gear = love.graphics.newImage('assets/gear.png'),
        crosshairs = love.graphics.newImage('assets/crosshairs.png'),
        tilesheet = love.graphics.newImage('assets/tilesheet.png'),
        tilesheetSmall = love.graphics.newImage('assets/tilesheet-small.png'),
        command = love.graphics.newImage('assets/command.png'),
        connector1x1 = love.graphics.newImage('assets/connector-1x1.png'),
        connector2x1 = love.graphics.newImage('assets/connector-2x1.png'),
        cannon = love.graphics.newImage('assets/cannon.png'),
        thruster = love.graphics.newImage('assets/thruster.png'),
    }
    game.state = require('states/test')(game.images)
end

function love.draw()
    if game.state.draw then game.state:draw() end
end

function love.update(dt)
    if game.state.update then game.state:update(dt) end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    else
        if key == ' ' then key = 'space' end
        if key == ',' then key = 'comma' end
        --Engine:trigger('keyDown', key)
    end
end

function love.keyreleased(key)
    if key == ' ' then key = 'space' end
    if key == ',' then key = 'comma' end
    --Engine:trigger('keyUp', key)
end

function love.mousepressed(x, y, button)
    --Engine:trigger('mouseDown', x, y, button)
end

function love.mousereleased(x, y, button)
    --Engine:trigger('mouseUp', x, y, button)
end

function love.mousemoved(x, y, dx, dy)
    --Engine:trigger('mouseMove', x, y, dx, dy)
end
