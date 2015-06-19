local class = require('middleclass')
local G = require('constants')
local _ = require('moses')


local Physics = class('Physics')

function Physics:initialize(engine)
    self.engine = engine

    love.physics.setMeter(G.TILE_SIZE)
    self.world = love.physics.newWorld(0, 0, true)

    local roomWidth = love.graphics.getWidth()
    local roomHeight = love.graphics.getHeight()
    local topWall = {}
    local bottomWall = {}
    local leftWall = {}
    local rightWall = {}

    topWall.body = love.physics.newBody(self.world, roomWidth/2, 0)
    bottomWall.body = love.physics.newBody(self.world, roomWidth/2, roomHeight)
    leftWall.body = love.physics.newBody(self.world, 0, roomHeight/2)
    rightWall.body = love.physics.newBody(self.world, roomWidth, roomHeight/2)

    topWall.shape = love.physics.newBody(self.world, roomWidth/2, 0)
    bottomWall.shape = love.physics.newBody(self.world, roomWidth/2, roomHeight)
    leftWall.shape = love.physics.newBody(self.world, 0, roomHeight/2)
    rightWall.shape = love.physics.newBody(self.world, roomWidth, roomHeight/2)

    objects.ground.shape = love.physics.newRectangleShape(650, 50) --make a rectangle with a width of 650 and a height of 50
    objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape) --attach shape to body

end


--function Physics:
    
    while unconsideredTiles is not empty do
        local box = {}
        for unconsideredTile in unconsideredTiles do
            if unconsideredTile == 1 then
                
            end
        end

    end

end
