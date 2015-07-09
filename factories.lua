local factories = {}
local parts = require('parts')
local joints = require('joints')

function factories.buildActor(entityData, x, y)
    local part = parts[entityData.name]()
    local parentI = nil

    part.transform.x = x + entityData.x
    part.transform.y = y + entityData.y
    part.transform.angle = entityData.angle
    print(part.transform.angle)
    for i, childEntityData in pairs(entityData.connections) do
        if childEntityData == 'parent' then
            parentI = i
        elseif childEntityData ~= nil then
            local child, childParentI = factories.buildActor(childEntityData, x, y)
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

return factories
