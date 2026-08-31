-- ============================================================
-- vr_vehicles — Server: VIN, texniki baxış, sığorta, aşınma
-- ============================================================

local config = lib.require('config.shared')

-- === Nəqliyyat qeydiyyatı (VIN təyin) ===
exports('registerVehicle', function(source, plate, model, vin)
    local player = qbx.getPlayer(source)
    if not player then return false end
    vin = vin or ('VIN-%s'):format(math.random(100000000, 999999999))
    MySQL.insert.await('INSERT INTO vr_vehicle_records (plate, vin, model, owner) VALUES (?, ?, ?, ?)',
        { plate, vin, model, player.PlayerData.citizenid })
    MySQL.insert.await('INSERT INTO vr_vehicle_events (vin, event_type, details) VALUES (?, ?, ?)',
        { vin, 'registration', 'İlk qeydiyyat' })
    return true, vin
end)

-- === VIN tarixçəsi ===
lib.callback.register('vr:vehicles:getHistory', function(source, vin)
    return MySQL.query.await('SELECT * FROM vr_vehicle_events WHERE vin = ? ORDER BY created_at DESC', { vin })
end)

-- === Sahib dəyişməsi ===
lib.callback.register('vr:vehicles:transferOwnership', function(source, vin, newOwner)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local vehicle = MySQL.single.await('SELECT * FROM vr_vehicle_records WHERE vin = ?', { vin })
    if not vehicle then return false end
    if vehicle.owner ~= player.PlayerData.citizenid then return false, 'Yalnız sahib sata bilər' end

    MySQL.update.await('UPDATE vr_vehicle_records SET owner = ? WHERE vin = ?', { newOwner, vin })
    MySQL.insert.await('INSERT INTO vr_vehicle_events (vin, event_type, details) VALUES (?, ?, ?)',
        { vin, 'ownership', 'Sahib dəyişdi' })
    return true
end)

-- === Total-loss (qəza nəticəsində) ===
exports('markTotalLoss', function(vin)
    MySQL.update.await('UPDATE vr_vehicle_records SET total_loss = 1 WHERE vin = ?', { vin })
    MySQL.insert.await('INSERT INTO vr_vehicle_events (vin, event_type, details) VALUES (?, ?, ?)',
        { vin, 'accident', 'Total-loss elan edildi' })
    return true
end)

-- === Qəza qeydi ===
exports('recordAccident', function(vin, details)
    MySQL.insert.await('INSERT INTO vr_vehicle_events (vin, event_type, details) VALUES (?, ?, ?)',
        { vin, 'accident', details })
    return true
end)

-- === Aşınma artır (sürülən km-ə görə) ===
exports('addWear', function(vin, km)
    local vehicle = MySQL.single.await('SELECT * FROM vr_vehicle_records WHERE vin = ?', { vin })
    if not vehicle then return false end
    local newMileage = vehicle.mileage + km
    local newCondition = math.max(0, vehicle.condition - (km * config.WearPerKm))
    MySQL.update.await('UPDATE vr_vehicle_records SET mileage = ?, `condition` = ? WHERE vin = ?',
        { newMileage, newCondition, vin })
    return true
end)

-- === Texniki baxış ===
lib.callback.register('vr:vehicles:inspect', function(source, vin)
    local vehicle = MySQL.single.await('SELECT * FROM vr_vehicle_records WHERE vin = ?', { vin })
    if not vehicle then return false end
    MySQL.insert.await('INSERT INTO vr_vehicle_events (vin, event_type, details) VALUES (?, ?, ?)',
        { vin, 'inspection', 'Texniki baxış keçirildi' })
    return true, vehicle.condition
end)

-- === Sığorta yoxlaması ===
exports('hasInsurance', function(vin)
    local vehicle = MySQL.single.await('SELECT * FROM vr_vehicle_records WHERE vin = ?', { vin })
    return vehicle and vehicle.insurance ~= nil
end)

-- === Sığorta al ===
lib.callback.register('vr:vehicles:buyInsurance', function(source, vin, insuranceType)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local vehicle = MySQL.single.await('SELECT * FROM vr_vehicle_records WHERE vin = ?', { vin })
    if not vehicle then return false end
    if vehicle.owner ~= player.PlayerData.citizenid then return false end

    MySQL.update.await('UPDATE vr_vehicle_records SET insurance = ? WHERE vin = ?', { insuranceType, vin })
    MySQL.insert.await('INSERT INTO vr_vehicle_events (vin, event_type, details) VALUES (?, ?, ?)',
        { vin, 'registration', ('Sığorta: ' .. insuranceType) })
    return true
end)

print('[vr_vehicles] Nəqliyyat sistemi aktivdir.')
