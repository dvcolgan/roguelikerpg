local class = require('middleclass')
local GameState = require('lib/state')


local TitleState = class('TitleState', GameState)

function TitleState:create()
    self.speed=300
    self.x=0
    self.y=0
    self.dx=1
    self.dy=1
end

function TitleState:update(dt)
    self.x = self.x + self.speed * dt * self.dx
    self.y = self.y + self.speed * dt * self.dy
    local width = love.window.getWidth()
    local height = love.window.getHeight()

    if self.x > width then
        self.x = width - 1
        self.dx = -self.dx
    end
    if self.y > height then
        self.y = height - 1
        self.dy = -self.dy
    end
    if self.x < 0 then
        self.x = 1
        self.dx = -self.dx
    end
    if self.y < 0 then
        self.y = 1
        self.dy = -self.dy
    end

    if self.engine.models.key.states.space then
        self.engine:setState('title', {doUpdate=false, doDraw=false})
        self.engine:setState('overworld', {doUpdate=true, doDraw=true})
    end
end

function TitleState:draw()
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('This is the Title Screen', self.x, self.y)
end

return TitleState
