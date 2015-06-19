local class = require('middleclass')


local NPC = class('NPC')

function NPC:initialize(engine)
    self.engine = engine
    self.npcs = {}
end

function NPC:onAddNPC(npcData)
    self.npcs[npcData.key] = {
        key = npcData.key,
        name = npcData.name,
        x = npcData.x,
        y = npcData.y,
        dialog = npcData.dialog,
    }
end

function NPC:onRemoveNPC(key)
    self.npcs[key] = nil
end

function NPC:onRoomChange()
    self.npcs = {}
end

return NPC
