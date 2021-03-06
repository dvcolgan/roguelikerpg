local util = require('util')
local G = require('constants')
local vector = require('vector')
local _ = require('moses')


local Enemy = {}
Enemy.enemySets = {}
Enemy.currentEnemySet = nil

Enemy.enemyTemplates = require('scenarios/prisonship/enemies')

function Enemy:initializeRoom(key)
    self.enemySets[key] = {}
end

function Enemy:activateRoom(key)
    self.currentEnemySet = self.enemySets[key]
end

function Enemy:remove(uuid)
    self.currentEnemySet[uuid] = nil
end

function Enemy:isEnemy(uuid)
    return self.currentEnemySet[uuid] ~= nil
end

function Enemy:build(key, enemyData)
    local enemies = self.enemySets[key]
    local enemyTemplate = self.enemyTemplates[enemyData.key]
    local enemy = {
        uuid = util.uuid(),
        x = enemyData.col * G.TILE_SIZE + G.TILE_SIZE / 2,
        y = enemyData.row * G.TILE_SIZE + G.TILE_SIZE / 2,
        radius = enemyTemplate.radius,
        maxHealth = enemyTemplate.health,
        health = enemyTemplate.health,
        name = enemyTemplate.name,
        gears = enemyTemplate.gears,
        shotTime = 0,
        items = _.clone(enemyTemplate.items),
    }
    enemies[enemy.uuid] = enemy
    return enemy
end

function Enemy:tryFire(dtInSec, uuid, enemyPhysics, playerPhysics)
    local enemy = self.currentEnemySet[uuid]
    if enemy then
        enemy.health = enemy.health - dtInSec
        do return end
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
