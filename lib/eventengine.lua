local class = require('middleclass')


local Engine = class('Engine')

function Engine:initialize()
    self.callbacks = {}
    self.queue = {}
    self.states = {}
    self.models = {}
end

function Engine:addModels(modelClasses)
    for name, modelClass in pairs(modelClasses) do
        self.models[name] = modelClass:new(models)
    end
end

function Engine:pump()
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

        for model in ipairs(self.models) do
            if model[callbackName] then
                model[callbackName](arg1, arg2, arg3, arg4, arg5)
            end
        end
    end
end

function Engine:trigger(...)
    table.insert(self.queue, ...)
end

function Engine:update(dt)
    self.trigger('update', dt)
    self:pump()

    for i, state in ipairs(self.states) do
        state:update(dt)
    end
end

function Engine:draw()
    for i, state in ipairs(self.states) do
        state:draw()
    end
end

return Engine
