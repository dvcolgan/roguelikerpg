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
    frozen = false,
    damage = 10,
    gears = 0,

    health = 100,
    maxHealth = 100,
    items = {
        'pinCannon',
    },
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

return Player
