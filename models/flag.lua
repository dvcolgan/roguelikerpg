local class = require('middleclass')


local Flag = class('Flag')

function Flag:initialize()
    self.flags = {}
end

function Flag:onFlagSet(name, value)
    self.flags[name] = value
end

function Flag:serialize()
    return self.flags
end

function Flag:deserialize(flags)
    return self.flags = flags
end
