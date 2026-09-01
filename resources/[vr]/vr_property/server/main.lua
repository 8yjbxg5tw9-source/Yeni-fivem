-- ============================================================
-- vr_property — Server: alqı-satqı, kirayə, ipoteka, kommunal
-- ============================================================

local config = lib.require('config.shared')

-- === Əmlak al ===
lib.callback.register('vr:property:buy', function(source, propertyId)
    local player = qbx.getPlayer(source)
    if not player then return false end

    local property = MySQL.single.await('SELECT * FROM vr_properties WHERE property_id = ?', { propertyId })
    if not property then return false end
    if property.owner then return false, 'Əmlak artıq satılıb' end

    local bank = exports.vr_banking:getBalance(player.PlayerData.citizenid)
    if bank < property.price then return false, 'Kifayət qədər pul yoxdur' end

    exports.vr_banking:removeBankMoney(player.PlayerData.citizenid, property.price, 'emlak-alis')
    MySQL.update.await('UPDATE vr_properties SET owner = ?, status = ? WHERE property_id = ?',
        { player.PlayerData.citizenid, 'owned', propertyId })
    return true
end)

-- === İpoteka (kredit ilə alış) ===
lib.callback.register('vr:property:buyMortgage', function(source, propertyId, downPayment)
    local player = qbx.getPlayer(source)
    if not player then return false end
    downPayment = math.floor(tonumber(downPayment) or 0)
    if downPayment <= 0 then return false end

    local property = MySQL.single.await('SELECT * FROM vr_properties WHERE property_id = ?', { propertyId })
    if not property or property.owner then return false end

    local bank = exports.vr_banking:getBalance(player.PlayerData.citizenid)
    if bank < downPayment then return false, 'İlkin ödəniş üçün pul yoxdur' end

    local mortgage = property.price - downPayment
    exports.vr_banking:removeBankMoney(player.PlayerData.citizenid, downPayment, 'ipoteka-ilk-odenis')
    MySQL.update.await('UPDATE vr_properties SET owner = ?, mortgage = ?, mortgage_remaining = ?, status = ? WHERE property_id = ?',
        { player.PlayerData.citizenid, mortgage, mortgage, 'mortgaged', propertyId })
    return true
end)

-- === İpoteka ödənişi ===
lib.callback.register('vr:property:payMortgage', function(source, propertyId, amount)
    local player = qbx.getPlayer(source)
    if not player then return false end
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return false end

    local property = MySQL.single.await('SELECT * FROM vr_properties WHERE property_id = ?', { propertyId })
    if not property or property.owner ~= player.PlayerData.citizenid then return false end

    local bank = exports.vr_banking:getBalance(player.PlayerData.citizenid)
    if bank < amount then return false end
    exports.vr_banking:removeBankMoney(player.PlayerData.citizenid, amount, 'ipoteka-odenis')

    local remaining = math.max(0, property.mortgage_remaining - amount)
    local status = remaining == 0 and 'owned' or 'mortgaged'
    MySQL.update.await('UPDATE vr_properties SET mortgage_remaining = ?, status = ? WHERE property_id = ?',
        { remaining, status, propertyId })
    return true
end)

-- === Kirayə müqaviləsi ===
lib.callback.register('vr:property:rent', function(source, propertyId, tenantCitizenid, rentAmount)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local property = MySQL.single.await('SELECT * FROM vr_properties WHERE property_id = ?', { propertyId })
    if not property or property.owner ~= player.PlayerData.citizenid then return false end

    MySQL.update.await('UPDATE vr_properties SET rented_to = ? WHERE property_id = ?', { tenantCitizenid, propertyId })

    -- Müqavilə qeyd et (notariat ilə — icra qüvvəsi)
    TriggerEvent('vr:property:rented', propertyId, tenantCitizenid, rentAmount)
    return true
end)

-- === Kommunal faktura yaratma (dövri) ===
CreateThread(function()
    while true do
        Wait(24 * 60 * 60 * 1000) -- hər gün
        local properties = MySQL.query.await("SELECT * FROM vr_properties WHERE owner IS NOT NULL")
        for _, prop in ipairs(properties) do
            for _, utility in ipairs(config.Utilities) do
                local amount = math.random(50, 500) -- kommunal məbləği
                MySQL.insert.await('INSERT INTO vr_utilities (property_id, utility, amount, period) VALUES (?, ?, ?, ?)',
                    { prop.property_id, utility, amount, os.date('%Y-%m-%d') })
            end
        end
    end
end)

-- === Kommunal ödənilməsə → kəsilmə mexanikası ===
CreateThread(function()
    while true do
        Wait(48 * 60 * 60 * 1000) -- hər 2 gün
        -- 3 dövrdür ödənilməyən fakturalar → kəsmə
        local unpaid = MySQL.query.await(
            'SELECT property_id, COUNT(*) as unpaid_count FROM vr_utilities WHERE paid = 0 GROUP BY property_id HAVING unpaid_count >= 3'
        )
        for _, row in ipairs(unpaid) do
            -- Kəsmə hadisəsi (elektrik/su/qaz bağlanır)
            TriggerEvent('vr:property:utilityCut', row.property_id)
        end
    end
end)

print('[vr_property] Əmlak sistemi aktivdir.')
