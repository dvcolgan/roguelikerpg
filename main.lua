local game = {
    images = nil,
    state = nil,
}

_G.assets = {
    images = {}
}

function love.load()
    assets.images = {
        editorBackground = love.graphics.newImage('assets/editor-background.png'),
        gear = love.graphics.newImage('assets/gear.png'),
        crosshairs = love.graphics.newImage('assets/crosshairs.png'),
        tilesheet = love.graphics.newImage('assets/tilesheet.png'),
        tilesheetSmall = love.graphics.newImage('assets/tilesheet-small.png'),
        player = love.graphics.newImage('assets/player.png'),
        enemy = love.graphics.newImage('assets/enemy.png'),
        connector1x1 = love.graphics.newImage('assets/connector-1x1.png'),
        connector2x1 = love.graphics.newImage('assets/connector-2x1.png'),
        cannon = love.graphics.newImage('assets/cannon.png'),
        thruster = love.graphics.newImage('assets/thruster.png'),
    }
    assets.images.editorBackground:setWrap('repeat', 'repeat')
    assets.images.editorBackgroundQuad = love.graphics.newQuad(
        0, 0,
        love.graphics.getWidth(),
        love.graphics.getHeight(),
        assets.images.editorBackground:getWidth(),
        assets.images.editorBackground:getHeight()
    )
    game.state = require('states/entity-editor'):new()
end

function love.draw()
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print(love.timer.getFPS(), love.graphics.getWidth() - 30, 10)
    if game.state then
        game.state.ecs:update(love.timer.getDelta())
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    else
        if game.state then
            if key == ' ' then key = 'space' end
            if key == ',' then key = 'comma' end
            game.state.ecs:trigger('keyDown', key)
        end
    end
end

function love.keyreleased(key)
    if game.state then
        if key == ' ' then key = 'space' end
        if key == ',' then key = 'comma' end
        game.state.ecs:trigger('keyUp', key)
    end
end

function love.mousepressed(x, y, button)
    if game.state then
        game.state.ecs:trigger('mouseDown', x, y, button)
    end
end

function love.mousereleased(x, y, button)
    if game.state then
        game.state.ecs:trigger('mouseUp', x, y, button)
    end
end

function love.mousemoved(x, y, dx, dy)
    if game.state then
        game.state.ecs:trigger('mouseMove', x, y, dx, dy)
    end
end
