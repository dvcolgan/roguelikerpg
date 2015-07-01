local util = require('util')


local Bullet = {}

Bullet.bullets = {}

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

function Bullet:isBullet(uuid)
    return self.bullets[uuid] ~= nil
end

function Bullet:onBulletCollided(uuid)
    if self.bullets[uuid] then
        self.bullets[uuid] = nil
        self.engine:trigger('bulletRemove', uuid)
    end
end

function Bullet:onUpdate(dtInSec)
    for uuid, bullet in pairs(self.bullets) do
        bullet.timeout = bullet.timeout - dtInSec
        if bullet.timeout <= 0 then
            self:remove(uuid)
            self.engine:trigger('bulletRemove', uuid)
        end
    end
end

function Bullet:remove(uuid)
    self.bullets[uuid] = nil
end

function Bullet:clear()
    self.bullets = {}
end

return Bullet
