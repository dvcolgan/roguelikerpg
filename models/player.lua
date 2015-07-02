local G = require('constants')
local util = require('util')


local Player = {}

Player.player = {
    uuid = util.uuid(),
    lastX = 0,
    lastY = 0,
    direction = 'left',
    acceleration = 1000,
    drag = 30,
    maxSpeed = 3,
    frozen = false,
    damage = 10,
    gears = 0,

    health = 100,
    maxHealth = 100,
    items = {},
}

function Player:pause()
    self.player.frozen = true
end

function Player:resume()
    self.player.frozen = false
end

function Player:addItem(key)
    table.insert(self.player.items, key)
end

function Player:syncLastCoordinates(playerPhysics)
    if playerPhysics then
        self.player.lastX = playerPhysics.body:getX()
        self.player.lastY = playerPhysics.body:getY()
    end
end

function Player:isPlayer(uuid)
    return self.player.uuid == uuid
end

function Player:collectGears(number)
    self.player.gears = self.player.gears + number
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
            damage = self.player.damage,
            x = playerX,
            y = playerY,
            angle = angle,
            category = G.COLLISION.PLAYER_BULLET,
        }
    end
end

return Player
