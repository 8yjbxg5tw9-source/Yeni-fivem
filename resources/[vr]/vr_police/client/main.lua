-- ============================================================
-- vr_police — Client: polis alətləri, panik düyməsi, radar
-- ============================================================

-- === Panik düyməsi ===
lib.addKeybind({
    name = 'vr_police_panic',
    description = 'Panik düyməsi (polis)',
    defaultKey = 'F6',
    onPressed = function()
        TriggerServerEvent('vr:police:panic')
    end,
})

-- === Panik bildirişi ===
RegisterNetEvent('vr:police:panicAlert', function(data)
    lib.notify({ title = 'PANİK!', description = data.message .. ' Məkan: ' .. tostring(data.coords), type = 'error' })
    -- Xəritəyə işarə
    local blip = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
    SetBlipSprite(blip, 487)
    SetBlipColour(blip, 1)
    SetBlipFlashes(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('PANİK — ' .. data.officer)
    EndTextCommandSetBlipName(blip)
    SetTimeout(30000, function() RemoveBlip(blip) end)
end)

-- === Spike strip (yol maneəsi) ===
exports('deploySpikeStrip', function(coords)
    local spike = CreateObject(GetHashKey('p_spike_01'), coords.x, coords.y, coords.z - 1.0, true, true, false)
    PlaceObjectOnGroundProperly(spike)
    FreezeEntityPosition(spike, true)
    return spike
end)

-- === Undercover (saxta ID, səyyar göstəricilər) ===
local undercover = false
exports('toggleUndercover', function()
    undercover = not undercover
    lib.notify({ title = 'Undercover', description = undercover and 'Undercover rejimi AÇIQ' or 'Undercover rejimi BAĞLI', type = 'inform' })
    return undercover
end)

print('[vr_police] Client aktivdir.')
