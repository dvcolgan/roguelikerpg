local ecs = require('tiny')
local PhysicsManager = require('physics-manager')
local parts = require('parts')

local box2DSystems = require('systems/Box2DSystems')
local mouseDragSystems = require('systems/MouseDragSystems')

local GameState = class('GameState')

function GameState:init()
    _G.physics = PhysicsManager()
    _G.world = ecs.world()

    world:add(
        box2DSystems.RevoluteJointSystem(),
        box2DSystems.MouseJointSystem(),
        box2DSystems.RigidBodySystem(),

        mouseDragSystems.MouseDragSystem(),
        mouseDragSystems.MouseDragReleaseSystem(),

        require('systems.PartWeldingSystem')(),
        require('systems.ImageRenderingSystem')(),
        require('systems.WallSystem')(),
    nil)

    parts.Player(350, 400)
    parts.Enemy(300, 400)
    parts.Connector1x1(350, 400)
    parts.Connector1x1(350, 400)
    parts.Cannon(450, 400)
    parts.Cannon(450, 400)
    parts.Thruster(150, 400)
    parts.Thruster(150, 400)

    love.graphics.setBackgroundColor(255, 255, 255, 255)
end

function GameState:draw()
    love.graphics.clear()
    world:update(love.timer.getDelta())
end

return GameState
