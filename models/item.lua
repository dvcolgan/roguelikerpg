local class = require('middleclass')
local items = require('scenarios/prisonship/items')


local Item = class('Item')

function Item:initialize(engine)
    self.engine = engine
    self.items = items
end

return Item

