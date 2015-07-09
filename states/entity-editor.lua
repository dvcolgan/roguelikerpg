local GameState = class('GameState')
local ecs = require('lib/tiny')
local PhysicsManager = require('physics-manager')

local parts = require('parts')

local box2DSystems = require('systems/Box2DSystems')
local mouseDragSystems = require('systems/MouseDragSystems')
local editorSystems = require('systems/EditorSystems')

local factories = require('factories')
local enemies = require('scenarios/prisonship/enemies')

function GameState:init()
    _G.physics = PhysicsManager()
    _G.world = ecs.world()

    world:add(
        box2DSystems.RigidBodySystem(),
        box2DSystems.RevoluteJointSystem(),
        box2DSystems.MouseJointSystem(),

        mouseDragSystems.MouseDragSystem(),
        mouseDragSystems.MouseDragReleaseSystem(),

        require('systems.PartWeldingSystem')(),
        require('systems.ImageRenderingSystem')(),
        require('systems.WallSystem')(),

        editorSystems.EntityDeleteSystem(),
        editorSystems.EntitySaverSystem(),
        editorSystems.PartSpawnerSystem(),

    nil)

    love.graphics.setBackgroundColor(255, 255, 255, 255)
end

function GameState:draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(
        assets.images.editorBackground,
        assets.images.editorBackgroundQuad,
        0, 0
    )
    world:update(love.timer.getDelta())
end

return GameState

