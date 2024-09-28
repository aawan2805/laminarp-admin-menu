-- Event to show the countdown
RegisterNetEvent('jail_time:showCountdown')
AddEventHandler('jail_time:showCountdown', function(remainingTime)
    print("jail_time: Triggered", remainingTime)

    -- Ensure remainingTime is passed correctly
    if remainingTime then
        SendNUIMessage({ action = 'openJailCountdown', timeLeft = remainingTime })
        SetNuiFocus(true, true)

        -- Optional: Start the countdown in a separate thread
        Citizen.CreateThread(function()
            while remainingTime > 0 do
                Citizen.Wait(1000)  -- Wait for a second
                remainingTime = remainingTime - 1
                SendNUIMessage({ action = 'updateCountdown', timeLeft = remainingTime })
            end
            TriggerEvent('jail:clearCountdown')  -- Clear countdown when done
        end)
    end
end)

RegisterNetEvent('jail:clearCountdown')
AddEventHandler('jail:clearCountdown', function()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'closeJailCountdown' })
end)
