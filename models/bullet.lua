local class = require('middleclass')
local _ = require('moses')
local util = require('util')


local Bullet = class('Bullet')

function Bullet:initialize(engine)
    self.engine = engine
    self.bullets = {}
end

function Bullet:onFire(bulletSpec)
    local uuid = util.uuid()
    local bullet = {
        x = bulletSpec.x,
        y = bulletSpec.y,
        angle = bulletSpec.angle,
        timeout = 3,
        damage = bulletSpec.damage,
        category = bulletSpec.category,
    }
    self.bullets[uuid] = bullet
    self.engine:trigger('bulletFired', uuid, bullet)
end

function Bullet:onUpdate(dtInSec)
    for uuid, bullet in pairs(self.bullets) do
        bullet.timeout = bullet.timeout - dtInSec
        if bullet.timeout <= 0 then
            self.bullets[uuid] = nil
            self.engine:trigger('bulletTimeout', uuid)
        end
    end
end

function Bullet:onRoomChange(dx, dy)
    self.bullets = {}
end

return Bullet
