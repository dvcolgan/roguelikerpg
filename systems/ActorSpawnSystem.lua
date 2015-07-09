local ecs = require('tiny')

local ActorSpawnSystem = ecs.processingSystem(class('ActorSpawnSystem'))

function ActorSpawnSystem:init()
    self.filter = ecs.requireAll()

    beholder.observe('

end
