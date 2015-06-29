local class = require('middleclass')
local util = require('util')


local Gear = class('Gear')

function Gear:initialize(engine)
    self.engine = engine
    self.gears = {}
end

function Gear:onSpawnGear(x, y, amount)
    for i = 1, amount do
        local uuid = util.uuid()
        local gear = {
            x = x,
            y = y,
        }
        self.gears[uuid] = gear
        self.engine:trigger('gearDropped', uuid, gear)
    end
end

function Gear:onCollectGear(uuid)
    self.gears[uuid] = nil
    self.engine:trigger('gearRemove', uuid)
end

function Gear:isGear(uuid)
    return self.gears[uuid] ~= nil
end

function Gear:onRoomChange()
    self.bullets = {}
end

return Gear
