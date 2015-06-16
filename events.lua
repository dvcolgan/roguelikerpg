local engine = require('engine')


return engine.createEvents({
    'keyDown',
    'keyUp',
    'update',
    'stateChange',
})
