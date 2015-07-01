local util = require('util')


local Gear = {}
Gear.gears = {}

function Gear:spawn(x, y, amount)
    for i = 1, amount do
        local uuid = util.uuid()
        local gear = {
            uuid = uuid,
            x = x,
            y = y,
        }
        self.gears[uuid] = gear
        return gear
    end
end

function Gear:remove(uuid)
    self.gears[uuid] = nil
end

function Gear:isGear(uuid)
    return self.gears[uuid] ~= nil
end

function Gear:clear()
    self.gears = {}
end

return Gear
