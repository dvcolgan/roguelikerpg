local class = require('middleclass')
local G = require('constants')


local Player = class('Player')

function Player:initialize(engine)
    self.engine = engine
    self.x = 0
    self.y = 0
    self.dx = 0
    self.dy = 0
    self.direction = 'left'
    self.acceleration = 30
    self.drag = 30
    self.maxSpeed = 3
end

function Player:onUpdate(dt)
    local acc = self.acceleration * dt
    local drag = self.drag * dt
    states = self.engine.models.key.states

    local moveLeft = states.a
    local moveRight = states.e
    local moveUp = states.comma
    local moveDown = states.o

    -- Do acceleration
    if moveLeft then
        self.dx = self.dx - acc
    end
    if moveRight then
        self.dx = self.dx + acc
    end
    if moveUp then
        self.dy = self.dy - acc
    end
    if moveDown then
        self.dy = self.dy + acc
    end

    -- Apply drag
    if (not moveLeft) and (not moveRight) then
        if self.dx > 0 then
            self.dx = self.dx - drag
            if self.dx < 0 then self.dx = 0 end
        end
        if self.dx < 0 then
            self.dx = self.dx + drag
            if self.dx > 0 then self.dx = 0 end
        end
    end
    if (not moveDown) and (not moveUp) then
        if self.dy > 0 then
            self.dy = self.dy - drag
            if self.dy < 0 then self.dy = 0 end
        end
        if self.dy < 0 then
            self.dy = self.dy + drag
            if self.dy > 0 then self.dy = 0 end
        end
    end

    -- Cap speed
    if self.dx > self.maxSpeed then self.dx = self.maxSpeed end
    if self.dx < -self.maxSpeed then self.dx = -self.maxSpeed end
    if self.dy > self.maxSpeed then self.dy = self.maxSpeed end
    if self.dy < -self.maxSpeed then self.dy = -self.maxSpeed end

    -- Apply speed
    self.x = self.x + self.dx
    self.y = self.y + self.dy

    -- Check if offscreen
    if self.x > G.ROOM_WIDTH * G.TILE_SIZE then
        self.engine:trigger('roomChange', 1, 0)
        self.x = 0
    end
    if self.x < 0 then
        self.engine:trigger('roomChange', -1, 0)
        self.x = G.ROOM_WIDTH * G.TILE_SIZE - 1
    end
    if self.y > G.ROOM_HEIGHT * G.TILE_SIZE then
        self.engine:trigger('roomChange', 0, 1)
        self.y = 0
    end
    if self.y < 0 then
        self.engine:trigger('roomChange', 0, -1)
        self.y = G.ROOM_HEIGHT * G.TILE_SIZE - 1
    end
end

function Player:onKeyDown(key)
    if (key == 'left' or
            key == 'right' or
            key == 'up' or
            key == 'down') then
        engine:trigger('fire', self, key)
    end
end

return Player
