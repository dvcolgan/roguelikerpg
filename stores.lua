local flux = require('flux')


function createPlayer()
    return {
        x=0,
        y=0,
    }
end


stores = {
    keys = flux.createStore({
        init = function(self)
            self.states = {
                a=false,
                o=false,
                e=false,
                comma=false,
                left=false,
                right=false,
                up=false,
                down=false,
            }
        end,
        onKeyDown = function(self, key)
            self.states[key] = true
        end,
        onKeyUp = function(self, key)
            self.states[key] = false
        end,
    }),

    player = flux.createStore({
        init = function(self)
            self.player = createPlayer()
        end,

        onUpdate = function(self, dt)
            speed = dt * 200
            if stores.keys.states.left then
                self.player.x = self.player.x - speed
            end
            if stores.keys.states.right then
                self.player.x = self.player.x + speed
            end
            if stores.keys.states.up then
                self.player.y = self.player.y - speed
            end
            if stores.keys.states.down then
                self.player.y = self.player.y + speed
            end
        end,
    }),
}

return stores
