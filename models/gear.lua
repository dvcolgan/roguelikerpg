local util = require('util')


local Gear = {}
Gear.gearSets = {}
Gear.currentGearSet = {}

function Gear:spawn(x, y, amount)
    local newGears = {}
    for i = 1, amount do
        local uuid = util.uuid()
        local gear = {
            uuid = uuid,
            x = x,
            y = y,
        }
        self.currentGearSet[uuid] = gear
        table.insert(newGears, gear)
    end
    return newGears
end

function Gear:remove(uuid)
    self.currentGearSet[uuid] = nil
end

function Gear:isGear(uuid)
    return self.currentGearSet[uuid] ~= nil
end

return Gear
