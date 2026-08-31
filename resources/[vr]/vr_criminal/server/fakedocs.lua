-- ============================================================
-- vr_criminal — Saxta sənəd və saxta valyuta
-- ============================================================

-- === Saxta sənəd istehsalı ===
lib.callback.register('vr:criminal:fakeDocument', function(source, docType)
    local player = qbx.getPlayer(source)
    if not player then return false end

    -- İngredient: kağız + mürəkkəb
    local hasPaper = exports.ox_inventory:GetItem(source, 'paper', {}, false)
    local hasInk = exports.ox_inventory:GetItem(source, 'ink', {}, false)
    if not hasPaper or not hasInk then return false, 'Kağız və mürəkkəb lazımdır' end

    exports.ox_inventory:RemoveItem(source, 'paper', 1)
    exports.ox_inventory:RemoveItem(source, 'ink', 1)

    -- Saxta sənəd (quality aşağı — polis yoxlamasında aşkarlanır)
    exports.vr_items:addItemWithMetadata(source, 'fake_' .. docType, 1, { quality = 40 })
    return true, 'Saxta sənəd hazırlandı'
end)

-- === Saxta valyuta ===
lib.callback.register('vr:criminal:counterfeitMoney', function(source, amount)
    local player = qbx.getPlayer(source)
    if not player then return false end
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return false end

    -- Saxta valyuta "hot item" — istifadə riski yüksək
    local serial = exports.vr_items:generateSerial('CFT')
    exports.vr_items:addItemWithMetadata(source, 'counterfeit_cash', 1, {
        serial = serial,
        quality = 30, -- aşağı keyfiyyət = aşkarlanma riski
    })

    -- Anomaliya flag
    MySQL.insert.await('INSERT INTO vr_economy_flags (citizenid, reason, data) VALUES (?, ?, ?)',
        { player.PlayerData.citizenid, 'counterfeit', tostring(amount) })
    return true
end)

print('[vr_criminal] Saxta sənəd/valyuta sistemi aktivdir.')
