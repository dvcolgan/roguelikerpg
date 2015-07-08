local ecs = require('tiny')
local WallSystem = ecs.processingSystem(class('WallSystem'))

function WallSystem:init()
    self.walls = {}

    local roomWidth = love.graphics.getWidth()
    local roomHeight = love.graphics.getHeight()
    for i, template in ipairs({
        {x = roomWidth / 2, y = -10, width = roomWidth, height = 20},
        {x = roomWidth / 2, y = roomHeight + 10, width = roomWidth, height = 20},
        {x = -10, y = roomHeight / 2, width = 20, height = roomHeight},
        {x = roomWidth + 10, y = roomHeight / 2, width = 10, height = roomHeight},
    }) do
        local wall = {}
        wall.body = love.physics.newBody(physics.world, template.x, template.y)
        wall.shape = love.physics.newRectangleShape(template.width, template.height)
        wall.fixture = love.physics.newFixture(wall.body, wall.shape)
        table.insert(self.walls, wall)
    end
end

return WallSystem
