local ECSEngine = class('ECSEngine')

function ECSEngine:init()
    self.eventQueue = {}
    self.delayedEventQueue = {}
    self.eventCallbacks = {}

    self.entitiesToAdd = {}
    self.entitiesToRemove = {}
    self.entities = {}
    self.systems = {}
end

function ECSEngine:genUuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

function ECSEngine:trigger(...)
    table.insert(self.events, ...)
end

function ECSEngine:addEntity(entity)
    local uuid = self:genUuid()
    self.entitiesToAdd[uuid] = entity
    return uuid
end

function ECSEngine:removeEntity(uuid)
    table.insert(self.entitiesToRemove, uuid)
end

function ECSEngine:addSystem(system)
    table.insert(self.systems, system)
    for key, value in pairs(system) do
        -- Register functions in the system as listeners if they start with 'on'
        if type(value) == 'function' and startsWith(key, 'on') then
            -- Extract the action name from the function name:
            -- onCreateTodo -> createTodo
            local actionName = string.lower(string.sub(key, 3, 3)) .. string.sub(key, 4)

            if self.callbacks[actionName] == nil then
                self.callbacks[actionName] = {}
            end
            table.insert(self.callbacks[actionName], function(...)
                value(system, ...)
            end)
        end
    end
end

function ECSEngine:entityHasComponents(entity, components)
    for i, component in ipairs(components) do
        if entity[component] == nil then
            return false
        end
    end
    return true
end

function Engine:pump(dt)
    for key, delayedEvent in pairs(self.delayedEventQueue) do
        delayedEvent.remaining = delayedEvent.remaining - dt
        if delayedEvent.remaining <= 0 then
            table.insert(self.eventQueue, delayedEvent.event)
            self.delayedEventQueue[key] = nil
        end
    end
    local eventQueue = self.eventQueue
    self.eventQueue = {}

    for i, event in ipairs(eventQueue) do
        local eventName = event[1]
        local callbackName = 'on' .. eventName:sub(1,1):upper()..eventName:sub(2)
        local arg1 = event[2]
        local arg2 = event[3]
        local arg3 = event[4]
        local arg4 = event[5]
        local arg5 = event[6]

        for _, callback in ipairs(self.callbacks) do
            callback(arg1, arg2, arg3, arg4, arg5)
        end
    end
end

function ECSEngine:manageEntities()
    if #self.entitiesToAdd == 0 and #self.entitiesToRemove == 0 then
        return
    end

    -- Remove entities
    for i, uuid in ipairs(self.entitiesToRemove) do
        for _, system in pairs(self.systems) do
            if system.entities[uuid] then
                if self.system.onRemove then self.system:onRemove(uuid, entity) end
                system.entities[uuid] = nil
            end
        end
        self.entities[uuid] = nil
    end
    self.entitiesToRemove = {}

    -- Add entities
    for uuid, entity in pairs(self.entitiesToAdd) do
        if self.entities[uuid] == nil then
            self.entities[uuid] = entity
            for _, system in pairs(self.systems) do
                if self:entityHasComponents(entity, system.components) then
                    system.entities[uuid] = entity
                    if system.onAdd then system:onAdd(uuid, entity) end
                end
            end
        end
    end
    self.entitiesToAdd = {}
end

function ECSEngine:update(dt)
    self:processEvents()
    self:manageEntities()

    for i, system in ipairs(self.systems) do
        if system.preProcess then system:preProcess(dt) end
        if system.process then
            for uuid, entity in pairs(self.entities) do
                system:process(uuid, entity, dt)
            end
        end
        if system.postProcess then system:postProcess(dt) end
    end
end


return ECSEngine
