-- Revive Command
RegisterCommand('revive', function(source, args, rawCommand)
    print(source)
    print(args)
    print(rawCommand)
    -- Ensure that the player issuing the command has provided an ID
    if #args < 1 then
        TriggerClientEvent('chat:addMessage', source, {
            args = { '^1SYSTEM', 'Usage: /revive [playerID]' }
        })
        return
    end

    -- Get the target player ID
    local targetId = tonumber(args[1])

    -- Ensure the target player ID is valid
    if targetId == nil or not GetPlayerName(targetId) then
        TriggerClientEvent('chat:addMessage', source, {
            args = { '^1SYSTEM', 'Invalid player ID' }
        })
        return
    end

    -- Revive the player by triggering a client event
    TriggerClientEvent('esx_ambulancejob:revive', targetId)
    TriggerClientEvent('chat:addMessage', source, {
        args = { '^2SYSTEM', 'You have revived player ' .. GetPlayerName(targetId) }
    })
end, false)
