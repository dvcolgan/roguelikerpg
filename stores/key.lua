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
        }
    end,

    onKeyDown = function(self, key)
        if key == ',' then key = 'comma' end
        self.states[key] = true
    end,

    onKeyUp = function(self, key)
        if key == ',' then key = 'comma' end
        self.states[key] = false
    end,
})
