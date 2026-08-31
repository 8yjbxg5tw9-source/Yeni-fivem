-- ============================================================
-- vr_government — Vergi-Gömrük və Bələdiyyə
-- ============================================================

-- === Vergi ödəmə ===
lib.callback.register('vr:government:payTax', function(source, taxType, amount)
    local player = qbx.getPlayer(source)
    if not player then return false end
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return false end

    local bank = player.PlayerData.money.bank or 0
    if bank < amount then return false, 'Bankda kifayət qədər pul yoxdur' end

    player.Functions.RemoveMoney('bank', amount, 'vergi-' .. taxType)

    -- Xəzinəyə axır
    MySQL.insert.await('INSERT INTO vr_treasury (tax_type, amount) VALUES (?, ?)', { taxType, amount })
    return true
end)

-- === Gömrük rüsumu (idxal maşınları üçün) ===
lib.callback.register('vr:government:payCustoms', function(source, amount, vehicleVin)
    local player = qbx.getPlayer(source)
    if not player then return false end
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return false end
    local bank = player.PlayerData.money.bank or 0
    if bank < amount then return false end

    player.Functions.RemoveMoney('bank', amount, 'gomruk-rusumu')
    MySQL.insert.await('INSERT INTO vr_treasury (tax_type, amount) VALUES (?, ?)', { 'import', amount })
    MySQL.insert.await('INSERT INTO vr_vehicle_events (vin, event_type, details) VALUES (?, ?, ?)',
        { vehicleVin, 'registration', 'Gömrük rüsumu ödənildi' })
    return true
end)

-- === Bələdiyyə xidmətləri (kommunal) ===
lib.callback.register('vr:government:payUtility', function(source, propertyId, utility)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local bill = MySQL.single.await('SELECT * FROM vr_utilities WHERE property_id = ? AND utility = ? AND paid = 0 ORDER BY id LIMIT 1',
        { propertyId, utility })
    if not bill then return false, 'Ödənilməmiş faktura yoxdur' end
    local bank = player.PlayerData.money.bank or 0
    if bank < bill.amount then return false, 'Kifayət qədər pul yoxdur' end
    player.Functions.RemoveMoney('bank', bill.amount, 'kommunal-' .. utility)
    MySQL.update.await('UPDATE vr_utilities SET paid = 1 WHERE id = ?', { bill.id })
    return true
end)

print('[vr_government] Vergi-Gömrük və Bələdiyyə aktivdir.')
