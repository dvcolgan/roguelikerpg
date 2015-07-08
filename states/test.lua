local GameState = class('GameState')
local ecs = require('tiny')
local PhysicsManager = require('physics-manager')

local parts = require('parts')

function GameState:init()
    _G.physics = PhysicsManager()
    _G.world = ecs.world()

    world:add(
        require('systems.ShapeRenderingSystem')(),
        require('systems.ImageRenderingSystem')(),
        require('systems.WallSystem')(),
        require('systems.MouseJointSystem')(),
        require('systems.PositionSystem')(),
        require('systems.ConnectionSystem')(),
        require('systems.MountPointDragSystem')(),

        parts.Command(300, 400),
        parts.Command(400, 400),
        parts.Command(500, 400)
        --parts.Connector1x1(350, 400),
        --parts.Connector2x1(250, 400),
        --parts.Cannon(450, 400),
        --parts.Thruster(150, 400)
    )

    love.graphics.setBackgroundColor(255, 255, 255, 255)
end

function GameState:draw()
    love.graphics.clear()
    local dt = love.timer.getDelta()
    world:update(dt)
end

return GameState
