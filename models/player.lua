local class = require('middleclass')
local G = require('constants')
local vector = require('vector')
local util = require('util')


local Player = class('Player')

function Player:initialize(engine)
    self.engine = engine
    self.uuid = util.uuid()
    self.lastX = 0
    self.lastY = 0
    self.direction = 'left'
    self.acceleration = 2000
    self.drag = 30
    self.maxSpeed = 3
    self.frozen = false
    self.damage = 10
    self.gears = 0
end

function Player:onTakeAwayControls()
    self.frozen = true
end

function Player:onGiveBackControls()
    self.frozen = false
end

function Player:onUpdate(dtInSec)
    local playerPhysics = self.engine.models.physics.objects[self.uuid]
    if playerPhysics then
        self.lastX = playerPhysics.body:getX()
        self.lastY = playerPhysics.body:getY()
    end
end

function Player:isPlayer(uuid)
    return self.uuid == uuid
end

function Player:onCollectGear(uuid)
    self.gears = self.gears + 1
end

function Player:onMouseDown(mouseX, mouseY, button)
    if button == 'l' then
        local playerPhysics = self.engine.models.physics.objects[self.uuid]
        if playerPhysics then
            local playerX = playerPhysics.body:getX()
            local playerY = playerPhysics.body:getY()
            local angle = math.atan2(
                mouseY - playerY,
                mouseX - playerX
            )

            self.engine:trigger('fire', {
                damage = self.damage,
                x = playerX,
                y = playerY,
                angle = angle,
                category = G.COLLISION.PLAYER_BULLET,
            })
        end
    end
end

return Player
