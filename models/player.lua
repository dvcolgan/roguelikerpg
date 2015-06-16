local class = require('middleclass')


local Player = class('Player')

function Player:initialize(engine)
    self.engine = engine
    self.x = 0
    self.y = 0
    self.direction = 'left'
    self.speed = 200
end

function onUpdate(dt)
    speed = dt * self.speed
    states = self.engine.models.key.states
    if states.left or states.a then
        self.player.x = self.player.x - speed
    end
    if states.right or states.e then
        self.player.x = self.player.x + speed
    end
    if states.up or states.comma then
        self.player.y = self.player.y - speed
    end
    if states.down or states.o then
        self.player.y = self.player.y + speed
    end
end

function onKeyDown(key)
    if key == 'space' then
        engine.fire(self)
    end
end

return Player
