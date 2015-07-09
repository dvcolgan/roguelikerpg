local ecs = require('tiny')
local beholder = require('beholder')

local EditorEntitySaverSystem = ecs.processingSystem(class('EditorEntitySaverSystem'))

function EditorEntitySaverSystem:init()
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

return EditorEntitySaverSystem
