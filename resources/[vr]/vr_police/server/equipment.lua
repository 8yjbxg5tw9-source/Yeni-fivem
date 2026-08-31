-- ============================================================
-- vr_police — Avadanlıq: breathalyzer, narkotest, radar, spike, impound
-- ============================================================

local function isPolice(source)
    local player = qbx.getPlayer(source)
    if not player then return false end
    return (player.PlayerData.job and player.PlayerData.job.name == 'police')
end

-- === Alkoqol test cihazı (breathalyzer) ===
-- Nəticə 0.00–0.40+ arası; 0.08+ = sərxoş
lib.callback.register('vr:police:breathalyzer', function(source, targetId)
    if not isPolice(source) then return nil end
    local target = qbx.getPlayer(targetId)
    if not target then return nil end
    -- Alkoqol səviyyəsi metadata-dan (istehsalda tamamlanır)
    local alcohol = target.PlayerData.metadata and target.PlayerData.metadata.alcohol or 0.0
    local result = {
        bac = alcohol,
        intoxicated = alcohol >= 0.08,
        note = alcohol >= 0.08 and 'SƏRXOŞ — qanuni hədd keçilib' or 'Qanuni hədd daxilində',
    }
    return result
end)

-- === Narkotest dəsti ===
lib.callback.register('vr:police:drugTest', function(source, targetId)
    if not isPolice(source) then return nil end
    local target = qbx.getPlayer(targetId)
    if not target then return nil end
    local drugs = target.PlayerData.metadata and target.PlayerData.metadata.drugs or {}
    local positive = {}
    for drug, active in pairs(drugs) do
        if active then positive[#positive + 1] = drug end
    end
    return { positive = positive, count = #positive }
end)

-- === Polis icazə yoxlaması (client alətləri üçün) ===
lib.callback.register('vr:police:isPolice', function(source)
    return isPolice(source)
end)

-- === Avtomobil skaneri (VIN oxu) — client plate göndərir ===
lib.callback.register('vr:police:scanVehicle', function(source, plate)
    if not isPolice(source) then return nil end
    local vehicle = MySQL.single.await('SELECT * FROM vr_vehicle_records WHERE plate = ?', { plate })
    return vehicle
end)

-- === Radar (sürət ölçmə) — ölçü CLIENT tərəfdə edilir (vr_police/client/equipment.lua) ===

-- === Impound (əksikdaş) ===
lib.callback.register('vr:police:impound', function(source, plate, reason)
    if not isPolice(source) then return false end
    MySQL.update.await('UPDATE vr_vehicle_records SET owner = NULL WHERE plate = ?', { plate })
    MySQL.insert.await('INSERT INTO vr_vehicle_events (vin, event_type, details) VALUES (?, ?, ?)',
        { plate, 'impound', reason or 'Polis tərəfindən əksikdaş' })
    return true
end)

-- === Panik düyməsi (dispatcher-ə bildiriş) — koordinatlar client-dən gəlir ===
RegisterNetEvent('vr:police:panic', function(coords)
    local src = source
    if not isPolice(src) then return end
    local player = qbx.getPlayer(src)
    -- Bütün polislərə bildiriş
    TriggerClientEvent('vr:police:panicAlert', -1, {
        officer = player.PlayerData.citizenid,
        coords = coords,
        message = 'ZABİT PANİK DÜYMƏSİNƏ BASDI!',
    })
end)

print('[vr_police] Avadanlıq sistemi aktivdir.')
