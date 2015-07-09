local ecs = require('lib/tiny')
local PhysicsManager = require('physics-manager')
local parts = require('parts')

local box2DSystems = require('systems/Box2DSystems')
local mouseDragSystems = require('systems/MouseDragSystems')
local enemies = require('scenarios/prisonship/enemies')
local factories = require('factories')

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


    factories.buildActor(enemies.scout, 400, 300)
    factories.buildActor(enemies.drone, 200, 100)

    love.graphics.setBackgroundColor(255, 255, 255, 255)
end

function GameState:draw()
    love.graphics.clear()
    world:update(love.timer.getDelta())
end

return GameState

