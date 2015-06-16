local class = require('middleclass')


local BulletManager = class('BulletManager')


function BulletManager:initialize(engine)
    self.engine = engine
    self.bullets = {}
end

function BulletManager:onFire(entity)
    table.insert(self.bullets, {
        x=entity.x,
        y=entity.y,
        dx=1,
        dy=0,
    })
end

function BulletManager:onUpdate(dt)
    for i, bullet in ipairs(self.bullets) do
        bullet.x = bullet.x + bullet.dx
        bullet.y = bullet.y + bullet.dy
    end
end

return BulletManager
