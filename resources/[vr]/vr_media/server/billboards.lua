-- ============================================================
-- vr_media — Reklam lövhələri icarəsi
-- ============================================================

local config = lib.require('config.shared')

-- === Lövhə icarəyə götür ===
lib.callback.register('vr:media:rentBillboard', function(source, location, content, days)
    local player = qbx.getPlayer(source)
    if not player then return false end
    days = math.floor(tonumber(days) or 1)
    if days < 1 or days > 30 then return false, 'İcarə 1-30 gün olmalıdır' end

    local cost = config.BillboardRate * days
    local bank = exports.vr_banking:getBalance(player.PlayerData.citizenid)
    if bank < cost then return false, 'Kifayət qədər pul yoxdur' end

    exports.vr_banking:removeBankMoney(player.PlayerData.citizenid, cost, 'reklam-lovhesi')

    local expires = os.date('%Y-%m-%d %H:%M:%S', os.time() + (days * 86400))
    MySQL.insert.await('INSERT INTO vr_billboards (location, renter, content, expires_at) VALUES (?, ?, ?, ?)',
        { location, player.PlayerData.citizenid, content, expires })

    -- Reklamı oyunçulara göstər
    TriggerClientEvent('vr:media:showBillboard', -1, { location = location, content = content })
    return true
end)

-- === Aktiv reklamlar ===
lib.callback.register('vr:media:getBillboards', function(source)
    return MySQL.query.await('SELECT * FROM vr_billboards WHERE expires_at > NOW()')
end)

print('[vr_media] Reklam lövhələri sistemi aktivdir.')
