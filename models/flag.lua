local Flag = {}

Flag.flags = {}

function Flag:onFlagSet(name, value)
    self.flags[name] = value
end

function Flag:serialize()
    return self.flags
end

function Flag:deserialize(flags)
    self.flags = flags
end

return Flag
