local ecs = require('tiny')
local beholder = require('beholder')
local G = require('constants')

local EntityDeleteSystem = ecs.processingSystem(class('EntityDeleteSystem'))

function EntityDeleteSystem:init()
    self.filter = ecs.requireAll('isPart', 'isCommand')
    beholder.observe('mouseDown', function(button)
        if button == 'r' then
            print('delete thing under cursor')
        end
    end)
end

---------------

local EntitySaverSystem = ecs.processingSystem(class('EntitySaverSystem'))

function EntitySaverSystem:init()
    self.filter = ecs.requireAll('isPart', 'isCommand')
    beholder.observe('keyDown', function(key)
        if key == 's' then

            local unhandledParts = {}
            local handledParts = {}

            function savePart(part)
                print(part.name)
                handledParts[part] = true
                local partData = {
                    name = part.name,
                    x = part.position.x,
                    y = part.position.y,
                    angle = part.position.angle,
                    connections = {}
                }
                for i, mountPoint in ipairs(part.mountPoints) do
                    if mountPoint.connection then
                        local part1 = mountPoint.connection.mountPoint1.part
                        local part2 = mountPoint.connection.mountPoint2.part
                        local nextPart = nil
                        if part1 ~= part then
                            nextPart = part1
                        elseif part2 ~= part then
                            nextPart = part2
                        end

                        if nextPart then
                            if not handledParts[nextPart] then
                                partData.connections[i] = savePart(nextPart)
                            else
                                partData.connections[i] = 'parent'
                            end
                        end
                    end
                end
                return partData
            end

            for i, command in ipairs(self.entities) do
                local entityData = savePart(command)

                print(table.inspect(entityData))

                break
            end
        end
    end)
end


--{
--    name = 'player',
--    connections = {
--        [1] = {
--            name = 'connector1x1',
--            connections = {
--                [3] = {
--                    name = 'thruster',
--                },
--                [4] = {
--                    name = 'cannon',
--                }
--            },
--        },
--        [2] = {
--            name = 'connector1x1',
--            connections = {
--                [3] = {
--                    name = 'thruster',
--                },
--                [4] = {
--                    name = 'cannon',
--                }
--            },
--        },
--    }
--}

---------------

local G = require('constants')
local parts = require('parts')
local beholder = require('beholder')

local PartSpawnerSystem = ecs.processingSystem(class('PartSpawnerSystem'))

function PartSpawnerSystem:init()

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

function PartSpawnerSystem:preProcess(dt)
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

function PartSpawnerSystem:drawPartLabel(image, number)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(image, 6, 6 + (number - 1) * (G.TILE_SIZE - 8))
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print(number, 1, 3 + (number - 1) * (G.TILE_SIZE - 8))
end

return {
    EntityDeleteSystem = EntityDeleteSystem,
    EntitySaverSystem = EntitySaverSystem,
    PartSpawnerSystem = PartSpawnerSystem,
}
