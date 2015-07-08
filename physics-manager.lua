local PhysicsManager = class('PhysicsManager')

function PhysicsManager:init()
    self.world = love.physics.newWorld(0, 0, true)
    self.objects = {}
    self.joints = {}
    self.mouseJoint = nil
end

return PhysicsManager