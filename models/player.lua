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

function Player:pause()
    self.frozen = true
end

function Player:resume()
    self.frozen = false
end

function Player:syncLastCoordinates(playerPhysics)
    if playerPhysics then
        self.lastX = playerPhysics.body:getX()
        self.lastY = playerPhysics.body:getY()
    end
end

function Player:isPlayer(uuid)
    return self.uuid == uuid
end

function Player:collectGears(number)
    self.gears = self.gears + number
end

function Player:createBullet(playerPhysics, targetX, targetY)
    if playerPhysics then
        local playerX = playerPhysics.body:getX()
        local playerY = playerPhysics.body:getY()
        local angle = math.atan2(
            targetY - playerY,
            targetX - playerX
        )

        return {
            damage = self.damage,
            x = playerX,
            y = playerY,
            angle = angle,
            category = G.COLLISION.PLAYER_BULLET,
        }
    end
end

return Player
