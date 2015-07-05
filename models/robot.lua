local Robot = {}
Robot.robots = {}


components =
    rectanglecollision
        uuid
        width
        height

    circlecollision
        uuid
        radius

    anchor
        uuid
        x
        y

    image
        uuid
        asset key

    position
        uuid
        x
        y
        
    connector
        uuid
        location

    joint
        uuid
        connection1
        connection2

    weapon
        uuid
        location
        direction
        bullet type

    mass
        uuid
        amount

    thrust
        uuid
        location
        direction
        force

    value
        amount


local partTemplates = {
    command = {
        collision = {
            type = 'circle',
            radius = 21,
        },
        anchor = {
            x = 0.5, y = 0.5,
        },
        connectors = {
            {x = 23, y = 0,},
            {x = 23, y = 47,},
            {x = 0, y = 23,},
            {x = 47, y = 23,},
        }
    },
    connector1x1 = {
        collision = {
            type = 'rectangle',
            width = 40,
            height = 40,
        },
        anchor = {
            x = 0.5, y = 0.5,
        },
        connectors = {
            {x = 23, y = 0,},
            {x = 23, y = 47,},
            {x = 0, y = 23,},
            {x = 47, y = 23,},
        }
    },
    connector2x1 = {
        collision = {
            type = 'rectangle',
            width = 88,
            height = 40,
        },
        anchor = {
            x = 0.5, y = 0.5,
        },
        connectors = {
            {x = 0, y = 23,},
            {x = 23, y = 0,},
            {x = 23, y = 47,},

            {x = 71, y = 0,},
            {x = 71, y = 47,},
            {x = 95, y = 23,},
        }
    },
    cannon = {
        collision = {
            uuid = nil,
            type = 'rectangle',
            width = 40,
            height = 40,
        },
        anchor = {
            uuid = nil,
            x = 0.5, y = 0.5,
        },
        connectors = {
            {x = 0, y = 23,},
        }
    },
}

local enemies = {
    parts = {
        'command',
        'connector1x1',
        'connector1x1',
        'cannon',
        'cannon',
        'thruster',
        'thruster',
    },
    connections = {
        {part1 = 1, connection1 = 3, part2 = 2, connection2 = 4}
        {part1 = 1, connection1 = 3},
        ...
    }
}
























function Robot:createCommand()
    local command = {}
    command.image = Asset.images.command
    command.body = love.physics.newBody(world, x, y)
    command.shape = love.physics.newCircleShape(21)
    command.fixture = love.physics.newFixture(
        command.body,
        command.shape, 1
    )
    return command
end

function Robot:createPart(template)
    local part = {}
    part.image = Asset.images[template.imageName]
    part.body = love.physics.newBody(world, x, y)
    part.shape = love.physics.newCircleShape(21)
    part.fixture = love.physics.newFixture(
        part.body,
        part.shape, 1
    )
    return command
end

