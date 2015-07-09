local factories = {}
local parts = require('parts')
local joints = require('joints')

function factories.buildActor(entityData)
    local part = parts[entityData.name]()
    local parentI = nil

    part.transform.x = entityData.x
    part.transform.y = entityData.y
    part.transform.angle = entityData.angle
    print(part.transform.angle)
    for i, childEntityData in pairs(entityData.connections) do
        if childEntityData == 'parent' then
            parentI = i
        elseif childEntityData ~= nil then
            local child, childParentI = factories.buildActor(childEntityData)
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
