local ecs = require('tiny')
local parts = require('parts')
local beholder = require('beholder')

local EditorPartSpawnerSystem = ecs.processingSystem(class 'EditorPartSpawnerSystem')

function EditorPartSpawnerSystem:init()
    self.filter = ecs.requireAll('position', 'image')

    beholder.observe('keyDown', function(key)
        local spawnX, spawnY = love.mouse.getPosition()
        local partClass = nil
        if key == '1' then partClass = parts.Player end
        if key == '2' then partClass = parts.Enemy end
        if key == '3' then partClass = parts.Connector1x1 end
        if key == '4' then partClass = parts.Connector2x1 end
        if key == '5' then partClass = parts.Cannon end
        if key == '6' then partClass = parts.Thruster end
        if partClass then partClass(spawnX, spawnY) end
    end)
end

return EditorPartSpawnerSystem
