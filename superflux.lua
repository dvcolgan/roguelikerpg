local Superflux = {}


function startsWith(str, start)
   return string.sub(str, 1, str.len(start)) == start
end


function Superflux.new()
    local flux = {}
    flux.actions = {}
    flux.stores = {}
    flux.callbacks = {}

    function flux.createStore(fns)
        for key, value in pairs(fns) do
            -- Register functions in the spec as listeners if they start with 'on'
            if type(value) == 'function' and startsWith(key, 'on') then
                -- Extract the action name from the function name:
                -- onCreateTodo -> createTodo
                local actionName = string.lower(string.sub(key, 3, 3)) .. string.sub(key, 4)

                if flux.callbacks[actionName] == nil then
                    flux.callbacks[actionName] = {}
                end
                table.insert(flux.callbacks[actionName], function(...)
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

    function flux.createActions(actions)
        for i, action in ipairs(actions) do
            flux.actions[action] = function(...)
                local callbacks = flux.callbacks[action]
                if callbacks then
                    for j, callback in ipairs(callbacks) do
                        callback(...)
                    end
                end
            end
        end
        return flux.actions
    end

    return flux
end

return Superflux
