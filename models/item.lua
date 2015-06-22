local class = require('middleclass')


local Item = class('Item')

function Item:initialize(engine)
    self.engine = engine
    self.items = {}

    -- TODO this code is duplicated in map
    roomFileNames = love.filesystem.getDirectoryItems('levels/test')
    for i, roomFileName in ipairs(roomFileNames) do
        if not string.find(roomFileName, '%.swp$') then
            _, _, roomName = string.find(roomFileName, '_(.-).lua')
            requirePath = 'levels/test/' .. string.gsub(roomFileName, '.lua', '')
            self.rooms[roomName] = require(requirePath)
        end
    end
end

return Item

