ESX = exports['es_extended']:getSharedObject()

-- Event to get jail time
RegisterNetEvent('jail_time:getTime')
AddEventHandler('jail_time:getTime', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        local result = MySQL.Sync.fetchAll('SELECT release_time FROM jails WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        })

        if result[1] then
            local remainingTime = result[1].release_time - os.time()
            if remainingTime > 0 then
                TriggerClientEvent('jail_time:showCountdown', source, remainingTime)
            else
                TriggerClientEvent('jail_time:clearCountdown', source)
            end
        end
    end
end)

