local class = require('middleclass')


local Player = class('Player')

function Player:initialize(engine)
    self.engine = engine
    self.x = 0
    self.y = 0
    self.direction = 'left'
    self.speed = 200
end

function Player:onUpdate(dt)
    speed = dt * self.speed
    states = self.engine.models.key.states
    if states.left or states.a then
        self.x = self.x - speed
    end
    if states.right or states.e then
        self.x = self.x + speed
    end
    if states.up or states.comma then
        self.y = self.y - speed
    end
    if states.down or states.o then
        self.y = self.y + speed
    end
end

function Player:onKeyDown(key)
    if key == 'space' then
        --engine.fire(self)
    end
end

return Player
