local class = require('middleclass')


local Engine = class('Engine')

function Engine:initialize()
    self.callbacks = {}
    self.queue = {}
    self.delayedQueue = {}
    self.states = {}
    self.models = {}
    self.images = {}
end

function Engine:addImage(name, texture)
    self.images[name] = texture
end

function Engine:addModels(modelClasses)
    for name, modelClass in pairs(modelClasses) do
        self.models[name] = modelClass:new(self)
    end
end

function Engine:addStates(stateClasses)
    for name, stateClass in pairs(stateClasses) do
        local state = stateClass:new(self)
        state:create()
        self.states[name] = state
    end
end

function Engine:setState(stateName, changes)
    local state = self.states[stateName]
    if changes.doUpdate ~= nil then
        state.doUpdate = changes.doUpdate
    end
    if changes.doDraw ~= nil then
        state.doDraw = changes.doDraw
    end
end

function Engine:pump(dt)
    for key, delayedEvent in pairs(self.delayedQueue) do
        delayedEvent.remaining = delayedEvent.remaining - dt
        if delayedEvent.remaining <= 0 then
            table.insert(self.queue, delayedEvent.event)
            self.delayedQueue[key] = nil
        end
    end
    local queue = self.queue
    self.queue = {}

    local nextState = nil

    for i, event in ipairs(queue) do
        local eventName = event[1]
        local callbackName = 'on' .. eventName:sub(1,1):upper()..eventName:sub(2)
        local arg1 = event[2]
        local arg2 = event[3]
        local arg3 = event[4]
        local arg4 = event[5]
        local arg5 = event[6]

        if eventName == '' then
            nextState = arg1
        end

        for name, model in pairs(self.models) do
            if model[callbackName] then
                model[callbackName](model, arg1, arg2, arg3, arg4, arg5)
            end
        end
    end
end

function Engine:trigger(eventName,
        arg1, arg2, arg3, arg4, arg5)
    table.insert(self.queue, {
        eventName,
        arg1, arg2, arg3, arg4, arg5
    })
end
function Engine:triggerAfter(delay, eventName,
        arg1, arg2, arg3, arg4, arg5)
    table.insert(self.delayedQueue, {
        remaining = delay,
        event = {
            eventName,
            arg1, arg2, arg3, arg4, arg5
        }
    })
end

function Engine:update(dt)
    self:trigger('update', dt)
    self:pump(dt)

    for name, state in pairs(self.states) do
        if state.doUpdate then
            state:update(dt)
        end
    end
end

function Engine:draw()
    for name, state in pairs(self.states) do
        if state.doDraw then
            state:draw()
        end
    end
end

function Engine:save()

end

return Engine
