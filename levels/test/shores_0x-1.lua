local G = require('constants')

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
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1,
    },

    script = function(engine)
        engine:trigger('addNPC', {
            key = 'girl',
            name = 'Girl',
            x = 7 * G.TILE_SIZE,
            y = 5 * G.TILE_SIZE,
            dialog = 'Please go get my boyfriend back.',
        })
        engine:trigger('sayNPC', 'girl')
        --[[
        if isFirstTime() then
            engine:trigger('takeAwayControls')
            engine:trigger('addNPC', { name='girl', x=50, y=50, dialog='*cry*' })
            engine:trigger('addNPC', { name='guy', x=100, y=50 })
            delay(100)
            engine:trigger('sayNPC', 'guy', 'I don\'t want you anymore.')
            delay(100)
            npcSay('girl', '*cry*')
            delay(100)
            npcWalk('guy', { speed=100, x=100, y=500, })
            engine:trigger('sayNPC', 'guy', 'What do you want? Go away')
            npcWalk('guy', { speed=100, x=100, y=500, })
            engine:trigger('removeNPC', 'guy')
            engine:trigger('sayNPC', 'girl', 'I am become sad.')
            engine:trigger('giveBackControls')
        else
            addNPC({ name='girl', x=50, y=50, dialog='Please go get my boyfriend back.', })

            if listenForEvent({ name='giveitem', item='guy', who='girl', }) then
                engine:trigger('addNPC', { name='guy', x=100, y=50, })
                engine:trigger('sayNPC', 'girl', 'yay kiss')
            end
        end
        ]]--
    end
}
