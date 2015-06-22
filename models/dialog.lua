local class = require('middleclass')
local G = require('constants')


local Dialog = class('Dialog')

function Dialog:initialize(engine)
    self.engine = engine
    self.show = false
    self.text = ''
    self.speaker = ''
end

function Dialog:onSayNPC(key, words)
    local npc = self.engine.models.npc.npcs[key]
    self.speaker = npc.name
    if words == nil then
        self.text = npc.dialog
    else
        self.text = words
    end
    self.show = true
end

function Dialog:onClearDialog()
    self:reset()
end

function Dialog:reset()
    self.show = false
    self.text = ''
    self.speaker = ''
end

function Dialog:onRoomChange()
    self:reset()
end

return Dialog
