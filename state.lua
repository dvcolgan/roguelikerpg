local engine = require('engine')
local events = require('events')


return engine.createStore({
    init = function(self)
        self.current = 'title'
    end,

    onKeyDown = function(self, key)
        if key == 'space' then
            self.current = 'overworld'
            events.stateChange(self.current)
        end
    end
})
