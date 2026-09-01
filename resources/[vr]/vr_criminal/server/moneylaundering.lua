-- ============================================================
-- vr_criminal — Pul yuma, saxta invoys, sığorta saxtakarlığı
-- ============================================================

-- === Pul yuma (şirkət üzərindən) ===
lib.callback.register('vr:criminal:launderMoney', function(source, companyId, amount)
    local player = qbx.getPlayer(source)
    if not player then return false end
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return false end

    -- Şirkət sahibi olmalıdır
    local company = MySQL.single.await('SELECT * FROM vr_companies WHERE id = ?', { companyId })
    if not company or company.owner ~= player.PlayerData.citizenid then
        return false, 'Yalnız şirkət sahibi pul yuya bilər'
    end

    -- Balans yoxlaması (client-in uydurduğu məbləği istifadə edə bilməz)
    local cash = player.PlayerData.money.cash or 0
    if cash < amount then return false, 'Kifayət qədər nağd pul yoxdur' end

    -- Pul yuma haqqı (%20 komissiya)
    local commission = math.floor(amount * 0.20)
    local cleaned = amount - commission

    -- Əvvəlcə nağd pul çıxarılır, sonra təmizlənmiş məbləğ banka keçir
    player.Functions.RemoveMoney('cash', amount, 'pul-yuma')
    exports.vr_banking:addBankMoney(player.PlayerData.citizenid, cleaned, 'pul-yuma')
    MySQL.insert.await('INSERT INTO vr_company_registry (company_id, entry_type, details) VALUES (?, ?, ?)',
        { companyId, 'audit', ('Pul yuma əməliyyatı: %d S₺'):format(amount) })

    -- Anomaliya detektoru üçün flag
    MySQL.insert.await('INSERT INTO vr_economy_flags (citizenid, reason, data) VALUES (?, ?, ?)',
        { player.PlayerData.citizenid, 'money_laundering', tostring(amount) })

    return true, cleaned
end)

-- === Saxta invoys (vergi saxtakarlığı) ===
lib.callback.register('vr:criminal:fakeInvoice', function(source, companyId, amount)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local company = MySQL.single.await('SELECT * FROM vr_companies WHERE id = ?', { companyId })
    if not company or company.owner ~= player.PlayerData.citizenid then return false end

    MySQL.insert.await('INSERT INTO vr_company_registry (company_id, entry_type, details) VALUES (?, ?, ?)',
        { companyId, 'audit', ('SAXTA INVOS: %d S₺'):format(amount) })

    -- Daxili Nəzarət/vergi flag
    MySQL.insert.await('INSERT INTO vr_economy_flags (citizenid, reason, data) VALUES (?, ?, ?)',
        { player.PlayerData.citizenid, 'fake_invoice', tostring(amount) })
    return true
end)

-- === Sığorta saxtakarlığı ===
lib.callback.register('vr:criminal:insuranceFraud', function(source, insuranceType, amount)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local isFraud = exports.vr_insurance:detectFraud(player.PlayerData.citizenid)
    if isFraud then
        return false, 'Şübhəli fəaliyyət aşkarlandı — iddia araşdırılır'
    end
    MySQL.insert.await('INSERT INTO vr_economy_flags (citizenid, reason, data) VALUES (?, ?, ?)',
        { player.PlayerData.citizenid, 'insurance_fraud', tostring(amount) })
    return true
end)

print('[vr_criminal] Pul yuma və saxtakarlıq sistemi aktivdir.')
