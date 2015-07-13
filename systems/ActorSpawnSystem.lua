local ecs = require('tiny')

local ActorSpawnSystem = ecs.processingSystem(class('ActorSpawnSystem'))

function ActorSpawnSystem:initialize()
    self.filter = ecs.requireAll()

    beholder.observe('

end
