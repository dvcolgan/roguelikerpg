local ecs = require('tiny')
local G = require('constants')
local parts = require('parts')
local beholder = require('beholder')

local EditorPartSpawnerSystem = ecs.processingSystem(class('EditorPartSpawnerSystem'))

function EditorPartSpawnerSystem:init()

    beholder.observe('keyDown', function(key)
        local spawnX, spawnY = love.mouse.getPosition()
        local partClass = nil
        if key == '1' then partClass = parts.Player end
        if key == '2' then partClass = parts.Enemy end
        if key == '3' then partClass = parts.Connector1x1 end
        if key == '4' then partClass = parts.Cannon end
        if key == '5' then partClass = parts.Thruster end
        if partClass then partClass(spawnX, spawnY) end
    end)
end

function EditorPartSpawnerSystem:preProcess(dt)
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.rectangle(
        'fill',
        0, 0,
        G.TILE_SIZE,
        love.graphics.getHeight()
    )
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.rectangle(
        'fill',
        0, 0,
        G.TILE_SIZE - 4,
        love.graphics.getHeight()
    )

    self:drawPartLabel(assets.images.player, 1)
    self:drawPartLabel(assets.images.enemy, 2)
    self:drawPartLabel(assets.images.connector1x1, 3)
    self:drawPartLabel(assets.images.cannon, 4)
    self:drawPartLabel(assets.images.thruster, 5)
end

function EditorPartSpawnerSystem:drawPartLabel(image, number)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(image, 6, 6 + (number - 1) * (G.TILE_SIZE - 8))
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print(number, 1, 3 + (number - 1) * (G.TILE_SIZE - 8))
end
return EditorPartSpawnerSystem
