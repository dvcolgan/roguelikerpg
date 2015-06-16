local engine = require('engine')


return engine.createStore({
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
            space=false,
        }
    end,

    onKeyDown = function(self, key)
        self.states[key] = true
    end,

    onKeyUp = function(self, key)
        self.states[key] = false
    end,
})
