local class = require('middleclass')
local util = require('util')
local G = require('constants')


local Enemy = class('Enemy')

function Enemy:initialize(engine)
    self.engine = engine
    self.enemies = {}
    self.enemyTemplates = require('scenarios/prisonship/enemies')
end

function Enemy:onRoomChange()
    self.enemies = {}
end

function Enemy:onMapLoaded()
    for i, enemy in ipairs(self.engine.models.map.enemies) do
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
    local enemiesPhysics = self.engine.models.physics.objects.enemies
    if enemiesPhysics then
        for uuid, enemy in pairs(self.enemies) do
            local enemyPhysics = enemiesPhysics[uuid]
            enemy.shotTime = enemy.shotTime + dtInSec
            if enemy.shotTime >= enemy.fireRate then
                self.engine:trigger('fire', {
                    damage = enemy.damage,
                    x = enemyPhysics.body:getX(),
                    y = enemyPhysics.body:getY(),
                    category = G.COLLISION.ENEMY_BULLET,
                })
                enemy.shotTime = 0
            end
        end
    end
end

return Enemy

