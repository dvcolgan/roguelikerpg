local util = require('util')


local Bullet = {}

Bullet.bullets = {}

function Bullet:fire(bulletSpec)
    local bullet = {
        uuid = util.uuid(),
        x = bulletSpec.x,
        y = bulletSpec.y,
        angle = bulletSpec.angle,
        timeout = 3,
        damage = bulletSpec.damage,
        category = bulletSpec.category,
    }
    self.bullets[bullet.uuid] = bullet
    return bullet
end

function Bullet:isBullet(uuid)
    return self.bullets[uuid] ~= nil
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
