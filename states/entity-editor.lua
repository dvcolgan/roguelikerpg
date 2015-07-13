local ECSEngine = require('ecs')
local PhysicsManager = require('physics-manager')

local parts = require('parts')

local box2DSystems = require('systems/Box2DSystems')
local mouseDragSystems = require('systems/MouseDragSystems')
local editorSystems = require('systems/EditorSystems')

local factories = require('factories')
local enemies = require('scenarios/prisonship/enemies')

local GameState = class('GameState')
function GameState:initialize()
    self.physics = PhysicsManager:new()
    print(self.physics)
    self.ecs = ECSEngine:new()

    self.ecs:addSystem(box2DSystems.RigidBodySystem:new(self.physics))
    self.ecs:addSystem(box2DSystems.RevoluteJointSystem:new(self.physics))
    self.ecs:addSystem(box2DSystems.MouseJointSystem:new(self.physics))
    self.ecs:addSystem(require('systems.WallSystem'):new(self.physics))

    self.ecs:addSystem(mouseDragSystems.MouseDragSystem:new())
    self.ecs:addSystem(mouseDragSystems.MouseDragReleaseSystem:new())

    self.ecs:addSystem(require('systems.PartWeldingSystem'):new())
    self.ecs:addSystem(require('systems.ImageRenderingSystem'):new())

    self.ecs:addSystem(editorSystems.EntityDeleteSystem:new())
    self.ecs:addSystem(editorSystems.EntitySaverSystem:new())
    self.ecs:addSystem(editorSystems.PartSpawnerSystem:new())

    love.graphics.setBackgroundColor(255, 255, 255, 255)

    factories.buildActor(enemies.scout, 450, 300)
    factories.buildActor(enemies.drone, 300, 300)
end

return GameState

