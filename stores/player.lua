local engine = require('engine')
local keyStore = require('stores/key')


function createPlayer()
    return {
        x=0,
        y=0,
    }
end


return engine.createStore({
    init = function(self)
        self.player = createPlayer()
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
