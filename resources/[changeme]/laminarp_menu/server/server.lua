-- Command to open the admin menu
ESX = exports["es_extended"]:getSharedObject()

-- Command to open the admin menu
RegisterCommand('openadmin', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer and (xPlayer.group == 'admin' or xPlayer.group == 'superadmin') then
        -- Get all online players
        local players = ESX.GetPlayers()
        local playerList = {}

        for i=1, #players, 1 do
            local player = ESX.GetPlayerFromId(players[i])
            table.insert(playerList, {
                id = player.source,
                name = player.getName()
            })
        end

        -- Send player list to the client
        TriggerClientEvent('admin:openMenu', source, playerList)
    else
        TriggerClientEvent('chatMessage', source, "Admin", {255, 0, 0}, "You don't have permission to use this command!")
    end
end, false)

-- Handle reviving a player
RegisterNetEvent('admin:revivePlayer')
AddEventHandler('admin:revivePlayer', function(targetId)
    local targetPlayer = ESX.GetPlayerFromId(targetId)
    
    if targetPlayer then
        TriggerClientEvent('admin:revive', targetPlayer.source)
        TriggerClientEvent('chatMessage', targetPlayer.source, "Admin", {0, 255, 0}, "You have been revived by an admin.")
    else
        TriggerClientEvent('chatMessage', source, "Admin", {255, 0, 0}, "Player not found!")
    end
end)


-- Open admin menu
RegisterNetEvent('admin:openMenu')
AddEventHandler('admin:openMenu', function()
    TriggerClientEvent('admin:openMenu', source) -- Event name matches with client.lua
end)

-- Handle teleporting admin to player
RegisterNetEvent('admin:gotoPlayer')
AddEventHandler('admin:gotoPlayer', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    -- Example: teleport the admin to the first player found (adjust logic)
    local targetPlayer = GetRandomPlayer()  -- You can implement your own logic here

    if targetPlayer then
        TriggerClientEvent('admin:teleport', source, targetPlayer.coords)
    else
        TriggerClientEvent('chatMessage', source, "Admin", {255, 0, 0}, "No players found!")
    end
end)

-- Event for jailing a player
RegisterNetEvent('admin:jailPlayer')
AddEventHandler('admin:jailPlayer', function(targetId, jailTime)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local targetPlayer = ESX.GetPlayerFromId(targetId)

    if targetPlayer then
        -- Insert into the database and get remaining jail time
        MySQL.Async.execute('INSERT INTO jails (identifier, name, admin, reason, release_time) VALUES (@identifier, @name, @admin, @reason, FROM_UNIXTIME(@release_time))', {
            ['@identifier'] = targetPlayer.identifier,
            ['@name'] = targetPlayer.name,
            ['@admin'] = xPlayer.name,
            ['@reason'] = 'Jailed by admin',
            ['@release_time'] = os.time() + jailTime
        }, function(rowsChanged)
            -- This will only run once the database insert completes
            if rowsChanged > 0 then
                print("laminarp_menu: triggering event of jail_time")

                -- Trigger the jail event
                -- TriggerClientEvent('admin:jail', targetPlayer.source, jailTime)
                -- After inserting the jail record and calculating remaining jail time
                local remainingTime = os.time() + jailTime -- Or however you calculate it
                TriggerClientEvent('jail_time:showCountdown', targetPlayer.source, remainingTime)

            else
                print("laminarp_menu: triggering event of jail_time")
                local remainingTime = os.time() + jailTime -- Or however you calculate it
                TriggerClientEvent('jail_time:showCountdown', targetPlayer.source, remainingTime)
                TriggerClientEvent('chatMessage', source, "Admin", {255, 0, 0}, "Failed to jail player!")
            end
        end)
    else
        TriggerClientEvent('chatMessage', source, "Admin", {255, 0, 0}, "Player not found!")
    end
end)



-- Handle releasing the player
RegisterNetEvent('admin:releasePlayer')
AddEventHandler('admin:releasePlayer', function()
    -- Logic to move the player out of jail
    -- For example, teleport them to a location outside of jail
    local releaseLocation = { x = 200.0, y = 200.0, z = 200.0 } -- Adjust as needed
    SetEntityCoords(GetPlayerPed(-1), releaseLocation.x, releaseLocation.y, releaseLocation.z, false, false, false, true)
    TriggerEvent('chat:addMessage', { args = { "You have been released from jail!" } })
end)

-- Handle banning a player
RegisterNetEvent('admin:banPlayer')
AddEventHandler('admin:banPlayer', function()
    local source = source
    local targetPlayer = GetRandomPlayer()  -- Adjust logic as necessary

    if targetPlayer then
        DropPlayer(targetPlayer.source, 'You have been banned by an admin.')
    else
        TriggerClientEvent('chatMessage', source, "Admin", {255, 0, 0}, "No players found!")
    end
end)

-- Example for moveTo (you can adjust this as needed)
RegisterNetEvent('admin:moveTo')
AddEventHandler('admin:moveTo', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    -- Example: Move the player to a specific location
    TriggerClientEvent('admin:teleport', source, vector3(200.0, 300.0, 50.0))  -- Example coords
end)


RegisterCommand("getWaypointCoords", function()
    local blip = GetFirstBlipInfoId(8) -- 8 is the blip type for a waypoint
    if DoesBlipExist(blip) then
        local coords = GetBlipInfoIdCoord(blip)
        print(("Waypoint coordinates: x: %s, y: %s, z: %s"):format(coords.x, coords.y, coords.z))
        -- You can use the coords for navigation or other purposes here
    else
        print("No waypoint set.")
    end
end, false)

-- TPM2
ESX.RegisterServerCallback("esx_marker:fetchUserRank", function(source, cb)
    local player = ESX.GetPlayerFromId(source)

    if player ~= nil then
        local playerGroup = player.getGroup()

        if playerGroup ~= nil then 
            cb(playerGroup)
        else
            cb("user")
        end
    else
        cb("user")
    end
end)