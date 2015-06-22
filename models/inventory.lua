local class = require('middleclass')


local Inventory = class('Inventory')

function Inventory:initialize(engine)
    self.engine = engine
    self.inventory = {}
end

return Inventory
