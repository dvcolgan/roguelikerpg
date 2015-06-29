local class = require('middleclass')
local util = require('util')
local G = require('constants')
local vector = require('vector')


local Enemy = class('Enemy')

function Enemy:initialize(engine)
    self.engine = engine
    self.enemies = {}
    self.enemyTemplates = require('scenarios/prisonship/enemies')
end

function Enemy:onRoomChange()
    self.enemies = {}
end

function Enemy:isEnemy(uuid)
    return self.enemies[uuid] ~= nil
end

function Enemy:onEnemyHit(uuid)
    if self.enemies[uuid] then
        self.enemies[uuid] = nil
        self.engine:trigger('enemyRemove', uuid)
    end
end


function Enemy:onMapLoaded()
    for i, enemy in ipairs(self.engine.models.map.currentRoom.enemies) do
        local enemyTemplate = self.enemyTemplates[enemy.key]
        local uuid = util.uuid()
        self.enemies[uuid] = {
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
    -- TODO allow specifying events to wait on before doing
    -- something that would allow doing this cascade of
    -- events in one tick
    self.engine:trigger('enemiesLoaded')
end


function Enemy:onUpdate(dtInSec)
    local player = self.engine.models.player
    local playerPhysics = self.engine.models.physics.objects[player.uuid]

    for uuid, enemy in pairs(self.enemies) do
        local enemyPhysics = self.engine.models.physics.objects[uuid]
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

            self.engine:trigger('fire', {
                damage = enemy.damage,
                x = startX,
                y = startY,
                angle = angle,
                category = G.COLLISION.ENEMY_BULLET,
            })
            enemy.shotTime = 0
        end
    end
end

return Enemy

