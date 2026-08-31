-- ============================================================
-- vr_admin — Client: spectate, noclip (yalnız icazəli staff)
-- ============================================================

local spectating = false
local noclipping = false

-- Spectate (müşahidə)
RegisterNetEvent('vr:admin:spectate', function(targetId)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetId))
    spectating = true
    local myPed = PlayerPedId()
    FreezeEntityPosition(myPed, true)
    SetEntityVisible(myPed, false, false)

    while spectating do
        Wait(0)
        local coords = GetEntityCoords(targetPed)
        SetFocusPosAndVel(coords.x, coords.y, coords.z, 0, 0, 0)
        NetworkOverrideClockTime(0, 0, 0)
    end

    SetEntityVisible(myPed, true, false)
    FreezeEntityPosition(myPed, false)
    ClearFocus()
end)

RegisterNetEvent('vr:admin:stopSpectate', function()
    spectating = false
end)

-- Noclip
RegisterNetEvent('vr:admin:noclip', function()
    noclipping = not noclipping
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, noclipping)
    SetEntityVisible(ped, not noclipping, false)
    SetEntityInvincible(ped, noclipping)

    while noclipping do
        Wait(0)
        local speed = IsControlPressed(0, 21) and 8.0 or 2.0
        local coords = GetEntityCoords(ped)
        local heading = GetEntityHeading(ped)
        local forward = GetEntityForwardVector(ped)
        local right = GetEntityRightVector(ped)

        if IsControlPressed(0, 32) then -- W
            coords = coords + forward * speed
        end
        if IsControlPressed(0, 33) then -- S
            coords = coords - forward * speed
        end
        if IsControlPressed(0, 34) then -- A
            coords = coords - right * speed
        end
        if IsControlPressed(0, 35) then -- D
            coords = coords + right * speed
        end
        SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
        SetEntityHeading(ped, heading)
    end
end)
