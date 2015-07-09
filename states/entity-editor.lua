local GameState = class('GameState')
local ecs = require('tiny')
local PhysicsManager = require('physics-manager')

local parts = require('parts')

function GameState:init()
    _G.physics = PhysicsManager()
    _G.world = ecs.world()

    world:add(
        require('systems.ImageRenderingSystem')(),
        require('systems.WallSystem')(),
        require('systems.MouseJointSystem')(),
        require('systems.PositionSystem')(),
        require('systems.MountPointDragSystem')(),
        require('systems.EditorPartSpawnerSystem')(),
        require('systems.EditorEntitySaverSystem')(),
        require('systems.ConnectionSystem')()
    )

    local prefabs = require('prefabs')
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

