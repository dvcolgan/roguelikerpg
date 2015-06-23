local class = require('middleclass')
local G = require('constants')


local Player = class('Player')

function Player:initialize(engine)
    self.engine = engine
    self.lastX = 0
    self.lastY = 0
    self.direction = 'left'
    self.acceleration = 2000
    self.drag = 30
    self.maxSpeed = 3
    self.frozen = false
    self.damage = 5
end

function Player:onTakeAwayControls()
    self.frozen = true
end

function Player:onGiveBackControls()
    self.frozen = false
end

function Player:onUpdate(dtInSec)
    local playerPhysics = self.engine.models.physics.objects.player
    if playerPhysics then
        self.lastX = playerPhysics.body:getX()
        self.lastY = playerPhysics.body:getY()
    end
end

function Player:onKeyDown(key)
    if key == 'space' then
        local playerPhysics = self.engine.models.physics.objects.player
        if playerPhysics then
            self.engine:trigger('fire', {
                damage = self.damage,
                x = playerPhysics.body:getX(),
                y = playerPhysics.body:getY(),
                category = G.COLLISION.PLAYER_BULLET,
            })
        end
    end
end

return Player
