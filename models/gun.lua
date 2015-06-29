local class = require('middleclass')
local G = require('constants')


local Gun = class('Gun')

function Gun:initialize(engine)
end

function Gun:onKeyDown(key)
    if key == 'space' then
        local bulletPhysics = self:buildBullet()
        local playerPhysics = self.engine.models.physics.objects.player
        if playerPhysics then
            
            self.engine:trigger('fire', {
                damage = self.damage,
                x = playerPhysics.body:getX(),
                y = playerPhysics.body:getY(),
                category = G.COLLISION.PLAYER_BULLET,
            })
        end

        function Physics:onBulletFired(uuid, bullet)
            if not self.objects.bullets then return end

            function Gun:buildBullet()
                local bulletPhysics = {}
                bulletPhysics.body = love.physics.newBody(self.world, bullet.x, bullet.y, 'dynamic')
                bulletPhysics.body:setX(bullet.x)
                bulletPhysics.body:setY(bullet.y)
                bulletPhysics.shape = love.physics.newCircleShape(bullet.damage)
                bulletPhysics.fixture = love.physics.newFixture(bulletPhysics.body, bulletPhysics.shape, 1)
                bulletPhysics.fixture:setRestitution(0.3)
                bulletPhysics.fixture:setCategory(bullet.category)
                if bullet.category == G.COLLISION.PLAYER_BULLET then
                    bulletPhysics.fixture:setMask(G.COLLISION.ENEMY_BULLET)
                else
                    bulletPhysics.fixture:setMask(G.COLLISION.PLAYER_BULLET, G.COLLISION.ENEMY_BULLET)
                end
                local force = 2000
                bulletPhysics.body:applyForce(
                bullet.dx * force,
                bullet.dy * force
                )
                self.objects.bullets[uuid] = bulletPhysics
            end

function Bullet:onFire(bulletSpec)
    local uuid = util.uuid()
    local bulletPhysics = 
    self.bullets[uuid] = {
        x = bulletSpec.x,
        y = bulletSpec.y,
        dx = bulletSpec.dx,
        dy = bulletSpec.dy,
        timeout = 3,
        damage = bulletSpec.damage,
        category = bulletSpec.category,
    }
end

        
    end
end

return Gun
