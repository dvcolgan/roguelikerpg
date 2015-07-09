local enemies = require('scenarios/prisonship/enemies')
local parts = require('parts')
local joints = require('joints')


--local player = {
--  angle = 0.10290420055389,
--  connections = { {
--      angle = -0.064944572746754,
--      connections = { nil, "parent" },
--      name = "Connector1x1",
--      x = 534.50286865234,
--      y = 272.77520751953
--    }, {
--      angle = -0.16678665578365,
--      connections = { "parent",
--        [3] = {
--          angle = 0.097708784043789,
--          connections = { nil, {
--              angle = -0.069732829928398,
--              connections = { "parent" },
--              name = "Connector1x1",
--              x = 670.93988037109,
--              y = 227.32678222656
--            }, nil, "parent" },
--          name = "Connector1x1",
--          x = 626.21643066406,
--          y = 227.16485595703
--        }
--      },
--      name = "Connector1x1",
--      x = 626.71923828125,
--      y = 272.53088378906
--    } },
--  name = "Player",
--  x = 581.33288574219,
--  y = 273.74761962891
--}


function buildEntity(entityData)
    local part = parts[entityData.name]()
    local parentI = nil

    part.transform.x = entityData.x
    part.transform.y = entityData.y
    part.transform.angle = entityData.angle
    print(part.transform.angle)
    world:addEntity(partransform)
    for i, childEntityData in pairs(entityData.connections) do
        if childEntityData == 'parent' then
            parentI = i
        elseif childEntityData ~= nil then
            local child, childParentI = buildEntity(childEntityData)
            local connection = joints.Connection(
                part.mountPoints[i],
                child.mountPoints[childParentI]
            )
            part.mountPoints[i].connection = connection
            child.mountPoints[childParentI].connection = connection
        end
    end
    return part, parentI
end

buildEntity(enemies.scout)
