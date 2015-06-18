function onShoresRoomEnter()
    if self.isFirstTime() then
        self.takeAwayControls()
        self.addNPC({ name='girl', x=50, y=50, dialog='*cry*', })
        self.addNPC({ name='guy', x=100, y=50, })
        self.delay(100)
        self.npcSay('guy', 'I don\'t want you anymore.')
        self.delay(100)
        self.npcSay('girl', '*cry*')
        self.delay(100)
        self.npcWalk('guy', { speed=100, x=100, y=500, })
        self.npcSay('guy', 'What do you want? Go away')
        self.npcWalk('guy', { speed=100, x=100, y=500, })
        self.removeNPC('guy')
        self.npcSay('girl', 'I am become sad.')
        self.giveBackControl()
    else
        self.addNPC({ name='girl', x=50, y=50, dialog='Please go get my boyfriend back.', })

        if self.listenForEvent({ name='giveitem', item='guy', who='girl', }) then
            self.addNPC({ name='guy', x=100, y=50, })
            self.npcSay('girl', 'yay kiss')
        end
    end
end
