local ecs = require('tiny')
local beholder = require('beholder')

local EditorEntityDeleteSystem = ecs.processingSystem(class('EditorEntityDeleteSystem'))

function EditorEntityDeleteSystem:init()
    self.filter = ecs.requireAll('isPart', 'isCommand')
    beholder.observe('mouseDown', function(button)
        if button == 'r' then
            print('delete thing under cursor')
        end
    end)
end

return EditorEntityDeleteSystem

