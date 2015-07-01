local Key = {}

Key.states = {
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

function Key:keyDown(key)
    self.states[key] = true
end

function Key:keyUp(key)
    self.states[key] = false
end

return Key
