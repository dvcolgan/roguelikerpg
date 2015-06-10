local Engine = {}


function startsWith(str, start)
   return string.sub(str, 1, str.len(start)) == start
end


function Engine.new()
    local engine = {}
    engine.events = {}
    engine.stores = {}
    engine.callbacks = {}

    function engine.createStore(fns)
        for key, value in pairs(fns) do
            -- Register functions in the spec as listeners if they start with 'on'
            if type(value) == 'function' and startsWith(key, 'on') then
                -- Extract the action name from the function name:
                -- onCreateTodo -> createTodo
                local actionName = string.lower(string.sub(key, 3, 3)) .. string.sub(key, 4)

                if engine.callbacks[actionName] == nil then
                    engine.callbacks[actionName] = {}
                end
                table.insert(engine.callbacks[actionName], function(...)
                    value(fns, ...)
                end)
            end
        end

        -- Call the constructor if present
        if fns.init then
            fns:init()
        end

        return fns
    end

    function engine.createEvents(events)
        for i, action in ipairs(events) do
            engine.events[action] = function(...)
                local callbacks = engine.callbacks[action]
                if callbacks then
                    for j, callback in ipairs(callbacks) do
                        callback(...)
                    end
                end
            end
        end
        return engine.events
    end

    return engine
end

return Engine
