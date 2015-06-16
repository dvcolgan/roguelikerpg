local class = require('middleclass')


local Key = class('Key')

function Key:initialize(engine)
    self.engine = engine
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
end

function Key:onKeyDown(key)
    self.states[key] = true
end

function Key:onKeyUp(key)
    self.states[key] = false
end

return Key
