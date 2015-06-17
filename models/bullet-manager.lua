local class = require('middleclass')
local _ = require('moses')


local BulletManager = class('BulletManager')


function BulletManager:initialize(engine)
    self.engine = engine
    self.bullets = {}
end

function BulletManager:onFire(entity, direction)
    local dx = entity.dx
    local dy = entity.dy
    local speed = 4
    -- TODO Make me work better
    if direction == 'left' then dx = dx - speed end
    if direction == 'right' then dx = dx + speed end
    if direction == 'up' then dy = dy - speed end
    if direction == 'down' then dy = dy + speed end
    if direction == 'left' or direction == 'right' then
        if dx ~= 0 then dx = dx * 3 end
    end
    if direction == 'up' or direction == 'down' then
        if dy ~= 0 then dy = dy * 3 end
    end
    table.insert(self.bullets, {
        x=entity.x,
        y=entity.y,
        dx=dx,
        dy=dy,
        timeout=3,
    })
end

function BulletManager:onUpdate(dt)
    local toDelete = {}
    for i, bullet in ipairs(self.bullets) do
        bullet.x = bullet.x + bullet.dx
        bullet.y = bullet.y + bullet.dy
        bullet.timeout = bullet.timeout - dt
    end

    self.bullets = _.filter(
        self.bullets,
        function(i, bullet)
            return bullet.timeout > 0
        end
    )
end

return BulletManager
