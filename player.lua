local Player = {}


function Player.new(x, y)
    self.x = x
    self.y = y
end

engine.createEntity

    init = function(self)
        self.x = 0
        self.y = 0
    end,

    onUpdate = function(self, dt)
        speed = dt * 200
        states = keyStore.states
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
    end,
})
