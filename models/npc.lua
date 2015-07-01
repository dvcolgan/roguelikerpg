local NPC = {}

NPC.npcs = {}

function NPC:onAddNPC(npcData)
    self.npcs[npcData.key] = {
        key = npcData.key,
        name = npcData.name,
        x = npcData.x,
        y = npcData.y,
        dialog = npcData.dialog,
        tween = nil,
    }
end

function NPC:onRemoveNPC(key)
    self.npcs[key] = nil
end

function NPC:onWalkNPC(key, args)
    local npc = self.npcs[key]
    args.startX = npc.x
    args.startY = npc.y
    args.elapsedTime = 0
    npc.tween = args
end

function NPC:onRoomChange()
    self.npcs = {}
end

function NPC:onUpdate(dtInSec)
    for key, npc in pairs(self.npcs) do
        if npc.tween then
            npc.tween.elapsedTime = npc.tween.elapsedTime + dtInSec
            npc.x = npc.tween.startX + (npc.tween.x - npc.tween.startX) * (npc.tween.elapsedTime / npc.tween.duration)
            npc.y = npc.tween.startY + (npc.tween.y - npc.tween.startY) * (npc.tween.elapsedTime / npc.tween.duration)
            if npc.tween.elapsedTime >= npc.tween.duration then
                npc.x = npc.tween.x
                npc.y = npc.tween.y
                npc.tween = nil
            end
        end
    end
end

return NPC
