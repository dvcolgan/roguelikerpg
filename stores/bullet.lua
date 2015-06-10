local engine = require('engine')


return engine.createStore({
    init = function(self)
        self.bullets = {}
    end,

    onFire = function(self)
    end
})
