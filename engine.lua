local Engine = {}

Engine.callbacks = {}
Engine.queue = {}
Engine.delayedQueue = {}
Engine.state = {}


function Engine:setState(state)
    self.state = state
end

function Engine:pump(dtInSec)
    for key, delayedEvent in pairs(self.delayedQueue) do
        delayedEvent.remaining = delayedEvent.remaining - dtInSec
        if delayedEvent.remaining <= 0 then
            table.insert(self.queue, delayedEvent.event)
            self.delayedQueue[key] = nil
        end
    end
    local queue = self.queue
    self.queue = {}

    for i, event in ipairs(queue) do
        local eventName = event[1]
        local callbackName = 'on' .. eventName:sub(1,1):upper()..eventName:sub(2)
        local arg1 = event[2]
        local arg2 = event[3]
        local arg3 = event[4]
        local arg4 = event[5]
        local arg5 = event[6]

        if self.state[callbackName] then
            self.state[callbackName](self.state, arg1, arg2, arg3, arg4, arg5)
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

function Engine:update(dtInSec)
    self:trigger('update', dtInSec)
    self:pump(dtInSec)

    if self.state.onUpdate then
        self.state:onUpdate(dtInSec)
    end
end

function Engine:draw()
    if self.state.draw then
        self.state:draw()
    end
end

return Engine
