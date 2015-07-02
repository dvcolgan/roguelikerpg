local util = require('util')


local Bullet = {}

Bullet.bulletSets = {}
Bullet.currentBulletSet = {}

function Bullet:initializeRoom(key)
    self.bulletSets[key] = {}
end

function Bullet:activateRoom(key)
    self.currentBulletSet = self.bulletSets[key]
end

function Bullet:remove(uuid)
    self.currentBulletSet[uuid] = nil
end

function Bullet:isBullet(uuid)
    return self.currentBulletSet[uuid] ~= nil
end

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
    self.currentBulletSet[bullet.uuid] = bullet
    return bullet
end

function Bullet:checkTimeout(dtInSec)
    for uuid, bullet in pairs(self.currentBulletSet) do
        bullet.timeout = bullet.timeout - dtInSec
        if bullet.timeout <= 0 then
            self:remove(uuid)
            self.engine:trigger('bulletRemove', uuid)
        end
    end
end

return Bullet
