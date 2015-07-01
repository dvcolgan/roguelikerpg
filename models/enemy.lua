local util = require('util')
local G = require('constants')
local vector = require('vector')


local Enemy = {}
Enemy.enemySets = {}
Enemy.currentEnemySet = nil

Enemy.enemyTemplates = require('scenarios/prisonship/enemies')

function Enemy:remove(uuid)
    self.currentEnemySet[uuid] = nil
end

function Enemy:isEnemy(uuid)
    return self.currentEnemySet[uuid] ~= nil
end

function Enemy:onEnemyHit(uuid)
    if self.currentEnemySet[uuid] then

        self.engine:trigger(
            'spawnGear',
            enemyPhysics.body:getX(),
            enemyPhysics.body:getY(),
            5
        )

        self:remove(uuid)
        self.engine:trigger('enemyRemove', uuid)
    end
end

function Enemy:initializeRoom(key)
    self.enemyPhysics[key] = {}
end

function Enemy:build(key, enemyTemplate)
    local enemies = self.enemySets[key]
    local uuid = util.uuid()
    self.enemies[uuid] = {
        uuid = uuid,
        x = enemy.col * G.TILE_SIZE + G.TILE_SIZE / 2,
        y = enemy.row * G.TILE_SIZE + G.TILE_SIZE / 2,
        radius = enemyTemplate.radius,
        hp = enemyTemplate.hp,
        name = enemyTemplate.name,
        fireRate = enemyTemplate.fireRate,
        damage = enemyTemplate.damage,
        shotTime = 0,
    }
end

function Enemy:tryFire(dtInSec, uuid, enemyPhysics, playerPhysics)
    local enemy = self.enemies[uuid]
    if enemy then
        enemy.shotTime = enemy.shotTime + dtInSec
        if enemy.shotTime >= enemy.fireRate then
            local targetX = playerPhysics.body:getX()
            local targetY = playerPhysics.body:getY()
            local startX = enemyPhysics.body:getX()
            local startY = enemyPhysics.body:getY()

            local angle = math.atan2(
                targetY - startY,
                targetX - startX
            )
            enemy.shotTime = 0

            return {
                damage = enemy.damage,
                x = startX,
                y = startY,
                angle = angle,
                category = G.COLLISION.ENEMY_BULLET,
            }
        end
    end
end

return Enemy
