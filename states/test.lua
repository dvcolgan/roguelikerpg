local GameState = class('GameState')
local ecs = require('tiny')

local parts = require('parts')

function GameState:init(images)
    self.world = ecs.world(
        require('systems.ShapeRenderingSystem')(),
        require('systems.ImageRenderingSystem')(images),
        require('systems.Box2DSystem')(),

        parts.Command(300, 400),
        parts.Connector1x1(350, 400),
        parts.Connector2x1(250, 400),
        parts.Cannon(450, 400),
        parts.Thruster(150, 400)
    )
    --love.graphics.setBackgroundColor(255, 255, 255, 255)
end

function GameState:draw()
    love.graphics.clear()
    local dt = love.timer.getDelta()
    self.world:update(dt)
end

return GameState
