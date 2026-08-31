-- ============================================================
-- vr_drugs — Server: narkotik zənciri
-- yetişdirmə → toplama → emal → qablaşdırma → satış
-- ============================================================

local config = lib.require('config.shared')

-- === Yetişdirməyə başla ===
lib.callback.register('vr:drugs:grow', function(source, drugType, locationRisk)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local drug
    for _, d in ipairs(config.Types) do
        if d.id == drugType then drug = d break end
    end
    if not drug then return false, 'Narkotik növü tapılmadı' end

    -- Ərazi riski (polis basqını şansı)
    local risk = config.LocationRisk[locationRisk] or config.LocationRisk.medium
    local busted = math.random(1, 100) <= risk
    if busted then
        MySQL.insert.await('INSERT INTO vr_mdt_records (record_type, title, body) VALUES (?, ?, ?)',
            { 'report', 'Narkotik yetişdirmə', ('Növ: %s'):format(drug.label) })
        return false, 'Ərazi riski: polis basqını!'
    end

    MySQL.insert.await('INSERT INTO vr_drug_operations (citizenid, drug, stage, quality, location_risk) VALUES (?, ?, ?, ?, ?)',
        { player.PlayerData.citizenid, drugType, 'grow', drug.quality, risk })
    return true
end)

-- === Toplama (harvest) ===
lib.callback.register('vr:drugs:harvest', function(source, operationId)
    local player = qbx.getPlayer(source)
    if not player then return false end
    MySQL.update.await('UPDATE vr_drug_operations SET stage = ?, quantity = quantity + 10 WHERE id = ? AND citizenid = ?',
        { 'harvest', operationId, player.PlayerData.citizenid })
    return true
end)

-- === Emal (process) ===
lib.callback.register('vr:drugs:process', function(source, operationId)
    local player = qbx.getPlayer(source)
    if not player then return false end
    MySQL.update.await('UPDATE vr_drug_operations SET stage = ?, quality = quality * 1.2 WHERE id = ? AND citizenid = ?',
        { 'process', operationId, player.PlayerData.citizenid })
    return true
end)

-- === Qablaşdırma (package) ===
lib.callback.register('vr:drugs:package', function(source, operationId)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local op = MySQL.single.await('SELECT * FROM vr_drug_operations WHERE id = ?', { operationId })
    if not op then return false end
    MySQL.update.await('UPDATE vr_drug_operations SET stage = ? WHERE id = ?', { 'package', operationId })

    -- Qablaşdırılmış məhsul inventara
    local itemName = ('%s_package'):format(op.drug)
    local metadata = { quality = op.quality, producedAt = os.time() }
    exports.vr_items:addItemWithMetadata(source, itemName, op.quantity, metadata)
    return true
end)

-- === Satış ===
lib.callback.register('vr:drugs:sell', function(source, operationId, quantity)
    local player = qbx.getPlayer(source)
    if not player then return false end
    quantity = math.floor(tonumber(quantity) or 0)
    if quantity <= 0 then return false end

    local op = MySQL.single.await('SELECT * FROM vr_drug_operations WHERE id = ? AND citizenid = ?',
        { operationId, player.PlayerData.citizenid })
    if not op or op.quantity < quantity then return false, 'Kifayət qədər məhsul yoxdur' end

    -- Qiymət: keyfiyyətə görə (daha yaxşı keyfiyyət = daha çox pul)
    local pricePerUnit = math.floor(100 + op.quality * 2)
    local revenue = pricePerUnit * quantity

    player.Functions.AddMoney('cash', revenue, 'narkotik-satis')
    MySQL.update.await('UPDATE vr_drug_operations SET quantity = quantity - ?, stage = ? WHERE id = ?',
        { quantity, 'sell', operationId })

    -- Alıcıda asılılıq effekti (vr_ems ilə)
    -- (real istehsalda alıcı tərəfi burada idarə olunur)
    return true, revenue
end)

-- === Asılılıq effekti (istifadə) ===
lib.callback.register('vr:drugs:consume', function(source, drugType)
    local player = qbx.getPlayer(source)
    if not player then return false end
    -- Asılılıq səviyyəsini artır
    exports.vr_ems:addAddiction(source, drugType, 1)
    return true
end)

print('[vr_drugs] Narkotik sistemi aktivdir.')
