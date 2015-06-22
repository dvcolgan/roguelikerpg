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
        local flags = engine.models.flag.flags
        --engine:trigger('addNPC', {
        --    key = 'girl',
        --    name = 'Girl',
        --    x = 7 * G.TILE_SIZE,
        --    y = 5 * G.TILE_SIZE,
        --    dialog = 'Please go get my boyfriend back.',
        --})
        --engine:trigger('sayNPC', 'girl')
        --if isFirstTime() then

        if not flags.seenGirlCutscene then
            engine:triggerAfter(0, 'takeAwayControls')
            engine:triggerAfter(0, 'addNPC', { key = 'girl', name = 'Girl', x = 7 * G.TILE_SIZE, y = 5 * G.TILE_SIZE, dialog = '*cry*' })
            engine:triggerAfter(0, 'addNPC', { key = 'guy', name = 'Guy', x = 8 * G.TILE_SIZE, y = 5 * G.TILE_SIZE, dialog = '*hrmph*' })
            engine:triggerAfter(1, 'sayNPC', 'guy', 'I don\'t want you anymore.')
            engine:triggerAfter(2, 'sayNPC', 'girl', '*cry*')
            engine:triggerAfter(3, 'clearDialog')
            engine:triggerAfter(3, 'walkNPC', 'guy', { duration = 1, x = 7 * G.TILE_SIZE, y = 7 * G.TILE_SIZE })
            engine:triggerAfter(4, 'sayNPC', 'guy', 'What do you want? Go away')
            engine:triggerAfter(5, 'clearDialog')
            engine:triggerAfter(5, 'walkNPC', 'guy', { duration = 1, x = 7 * G.TILE_SIZE, y = 10 * G.TILE_SIZE })
            engine:triggerAfter(6, 'removeNPC', 'guy')
            engine:triggerAfter(6, 'sayNPC', 'girl', 'I am become sad.')
            engine:triggerAfter(7, 'clearDialog')
            engine:triggerAfter(7, 'giveBackControls')
            engine:trigger('flagSet', 'seenGirlCutscene', true)
        else
            engine:triggerAfter(0, 'addNPC', { key = 'girl', name = 'Girl', x = 7 * G.TILE_SIZE, y = 5 * G.TILE_SIZE, dialog = 'Please go get my boyfriend back.' })
        end

        --else
        --    addNPC({ name='girl', x=50, y=50, dialog='Please go get my boyfriend back.', })

        --    if listenForEvent({ name='giveitem', item='guy', who='girl', }) then
        --        engine:trigger('addNPC', { name='guy', x=100, y=50, })
        --        engine:trigger('sayNPC', 'girl', 'yay kiss')
        --    end
        --end
    end
}
