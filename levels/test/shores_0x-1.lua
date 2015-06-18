return {
    layers = {
        {
            164, 164, 164, 164, 164, 164, 164, 164, 164, 164, 164, 164, 164, 164, 164,
            164, 164, 164, 164, 164, 164, 164, 164, 164, 164, 164, 164, 164, 164, 164,
            161, 162, 162, 162, 162, 162, 162, 162, 162, 162, 162, 162, 162, 162, 163,
            178, 178, 178, 178, 178, 81, 82, 82, 82, 83, 178, 178, 178, 178, 178,
            178, 178, 178, 178, 178, 97, 98, 98, 98, 99, 178, 178, 178, 178, 178,
            178, 178, 178, 178, 178, 97, 98, 98, 98, 99, 178, 178, 178, 178, 178,
            178, 178, 178, 178, 178, 113, 130, 98, 129, 115, 178, 178, 178, 178, 178,
            178, 178, 178, 178, 178, 178, 97, 98, 99, 178, 178, 178, 178, 178, 178,
            178, 178, 178, 178, 178, 178, 97, 98, 99, 178, 178, 178, 178, 178, 178
        }
    },
    collision = {
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    },

    script = function()
        if self.isFirstTime() then
            self.engine.trigger('takeAwayControls')
            self.engine.trigger('addNPC', { name='girl', x=50, y=50, dialog='*cry*' })
            self.engine.trigger('addNPC', { name='guy', x=100, y=50 })
            self.delay(100)
            self.npcSay('guy', 'I don\'t want you anymore.')
            self.delay(100)
            self.npcSay('girl', '*cry*')
            self.delay(100)
            self.npcWalk('guy', { speed=100, x=100, y=500, })
            self.engine.trigger('sayNPC', 'guy', 'What do you want? Go away')
            self.npcWalk('guy', { speed=100, x=100, y=500, })
            self.engine.trigger('removeNPC', 'guy')
            self.engine.trigger('sayNPC', 'girl', 'I am become sad.')
            self.engine.trigger('giveBackControls')
        else
            self.addNPC({ name='girl', x=50, y=50, dialog='Please go get my boyfriend back.', })

            if self.listenForEvent({ name='giveitem', item='guy', who='girl', }) then
                self.engine.trigger('addNPC', { name='guy', x=100, y=50, })
                self.engine.trigger('sayNPC', 'girl', 'yay kiss')
            end
        end
    end
}
