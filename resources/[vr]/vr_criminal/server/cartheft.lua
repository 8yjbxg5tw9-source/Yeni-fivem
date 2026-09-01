-- ============================================================
-- vr_criminal — Avto oğurluq: chop + boosting + VIN dəyişdirmə
-- ============================================================

-- === Avto oğurla ===
lib.callback.register('vr:criminal:stealVehicle', function(source, plate, vin)
    local player = qbx.getPlayer(source)
    if not player then return false end

    -- Qara bazar hot item qeydi
    exports.vr_items:markHotItem(source, 'stolen_vehicle', vin, 120) -- 2 saat istilik

    MySQL.insert.await('INSERT INTO vr_cartheft (citizenid, vin, action) VALUES (?, ?, ?)',
        { player.PlayerData.citizenid, vin, 'steal' })

    -- Polisə bildiriş (avtomatik)
    MySQL.insert.await('INSERT INTO vr_mdt_records (record_type, title, body) VALUES (?, ?, ?)',
        { 'bolo', 'Oğurlanmış avtomobil', ('VIN: %s'):format(vin) })
    return true
end)

-- === Chop (hissələrə ayır) ===
lib.callback.register('vr:criminal:chopVehicle', function(source, vin)
    local player = qbx.getPlayer(source)
    if not player then return false end

    MySQL.insert.await('INSERT INTO vr_cartheft (citizenid, vin, action) VALUES (?, ?, ?)',
        { player.PlayerData.citizenid, vin, 'chop' })

    -- Hissələr əldə et
    exports.ox_inventory:AddItem(source, 'vehicle_parts', math.random(3, 6))
    return true
end)

-- === Boosting (sifarişli oğurluq) — reward SERVER tərəfdə müəyyən olunur ===
lib.callback.register('vr:criminal:boostVehicle', function(source, vin)
    local player = qbx.getPlayer(source)
    if not player then return false end

    MySQL.insert.await('INSERT INTO vr_cartheft (citizenid, vin, action) VALUES (?, ?, ?)',
        { player.PlayerData.citizenid, vin, 'boost' })

    -- Mükafat client-dən GƏLMİR — server random təyin edir (təhlükəsizlik)
    local reward = math.random(3000, 8000)
    player.Functions.AddMoney('cash', reward, 'boosting')
    return true, reward
end)

-- === VIN dəyişdirmə (qanunsuz) ===
lib.callback.register('vr:criminal:changeVIN', function(source, oldVin, newVin)
    local player = qbx.getPlayer(source)
    if not player then return false end

    MySQL.insert.await('INSERT INTO vr_cartheft (citizenid, vin, action) VALUES (?, ?, ?)',
        { player.PlayerData.citizenid, newVin, 'vin_change' })

    MySQL.update.await('UPDATE vr_vehicle_records SET vin = ? WHERE vin = ?', { newVin, oldVin })
    MySQL.insert.await('INSERT INTO vr_vehicle_events (vin, event_type, details) VALUES (?, ?, ?)',
        { newVin, 'registration', 'VIN dəyişdirildi (qanunsuz)' })
    return true
end)

print('[vr_criminal] Avto oğurluq sistemi aktivdir.')
