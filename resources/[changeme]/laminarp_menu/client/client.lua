-- Handle opening the admin menu
RegisterNetEvent('admin:openMenu')
AddEventHandler('admin:openMenu', function(playerList)
    print("Opening admin menu with player list")

    -- Send the list of players to the NUI
    SendNUIMessage({
        action = 'openAdminMenu',
        players = playerList
    })

    -- Set NUI focus
    SetNuiFocus(true, true)
end)

-- Register the command to execute actions based on player selection
RegisterNUICallback('gotoPlayer', function(data, cb)
    TriggerServerEvent('admin:gotoPlayer', data.playerId)
    cb('ok')
end)

-- JAIL USER
RegisterNUICallback('jailPlayer', function(data, cb)
    TriggerServerEvent('admin:jailPlayer', data.playerId, data.jailTime)  -- You can pass jailTime from UI
    cb('ok')
end)

-- Handle teleporting to a specified location
RegisterNetEvent('admin:teleportJail')
AddEventHandler('admin:teleportJail', function(location)
    SetEntityCoords(GetPlayerPed(-1), location.x, location.y, location.z, false, false, false, true)
end)

RegisterNUICallback('banPlayer', function(data, cb)
    TriggerServerEvent('admin:banPlayer', data.playerId, data.reason)  -- Pass ban reason from UI
    cb('ok')
end)

-- Revive handling
RegisterNetEvent('admin:revive')
AddEventHandler('admin:revive', function()
    local playerPed = GetPlayerPed(-1)
    SetEntityHealth(playerPed, 200)
    
    -- Optionally reposition player
    local pos = GetEntityCoords(playerPed)
    SetEntityCoords(playerPed, pos.x, pos.y, pos.z + 1, false, false, false, true)
end)

RegisterNUICallback('revivePlayer', function(data, cb)
    TriggerServerEvent('admin:revivePlayer', data.playerId)
    cb('ok')
end)


RegisterNUICallback('closeMenu', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)



-- TPM
RegisterCommand("tpm", function(source)
    TeleportToWaypoint()
end)

TeleportToWaypoint = function()
    ESX.TriggerServerCallback("esx_marker:fetchUserRank", function(playerRank)
        if playerRank == "admin" or playerRank == "superadmin" or playerRank == "mod" then
            local WaypointHandle = GetFirstBlipInfoId(8)

            if DoesBlipExist(WaypointHandle) then
                local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

                for height = 1, 1000 do
                    SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                    local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

                    if foundGround then
                        SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                        break
                    end

                    Citizen.Wait(5)
                end

                ESX.ShowNotification("Teleported.")
            else
                ESX.ShowNotification("Please place your waypoint.")
            end
        else
            ESX.ShowNotification("You do not have rights to do this.")
        end
    end)
end