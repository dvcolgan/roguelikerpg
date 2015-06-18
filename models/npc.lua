local class = require('middleclass')


local NPC = class('NPC')

function NPC:initialize(engine)
    self.engine = engine
    self.npcs = {}
end

function NPC:onAddNPC(name, npcData)
    self.npcs[name] = {
        x = npcData.x,
        y = npcData.y,
        dialog = npcData.dialog,
    }
end

function NPC:onRemoveNPC(name)
    self.npcs[name] = nil
end

function NPC:onSayNPC(name, words)
end

return NPC
