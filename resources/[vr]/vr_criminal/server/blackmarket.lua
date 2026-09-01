-- ============================================================
-- vr_criminal — Qara bazar (dinamik qiymət və risk)
-- ============================================================

-- === Qara bazar qiymətini oxu ===
lib.callback.register('vr:criminal:getBlackmarket', function(source)
    return MySQL.query.await('SELECT * FROM vr_blackmarket')
end)

-- === Qara bazardan al ===
lib.callback.register('vr:criminal:buyBlackmarket', function(source, itemId)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local item = MySQL.single.await('SELECT * FROM vr_blackmarket WHERE id = ?', { itemId })
    if not item or item.stock <= 0 then return false, 'Stok yoxdur' end

    local bank = exports.vr_banking:getBalance(player.PlayerData.citizenid)
    if bank < item.price then return false, 'Kifayət qədər pul yoxdur' end
    exports.vr_banking:removeBankMoney(player.PlayerData.citizenid, item.price, 'qara-bazar')

    MySQL.update.await('UPDATE vr_blackmarket SET stock = stock - 1 WHERE id = ?', { itemId })

    -- Risk artır (hər alışda)
    MySQL.update.await('UPDATE vr_blackmarket SET risk = risk + 1 WHERE id = ?', { itemId })

    -- Əşyanı ver
    exports.ox_inventory:AddItem(source, item.item, 1)
    return true
end)

-- === Polis əməliyyatı uğurlu → qiymətlər/risk avtomatik dəyişir ===
exports('policeRaid', function(itemId)
    MySQL.update.await('UPDATE vr_blackmarket SET price = price * 1.5, risk = risk + 10, stock = GREATEST(0, stock - 5) WHERE id = ?',
        { itemId })
    return true
end)

-- === Risk səviyyəsinə görə satıcıya xəbərdarlıq ===
exports('getRisk', function(itemId)
    local item = MySQL.single.await('SELECT risk FROM vr_blackmarket WHERE id = ?', { itemId })
    return item and item.risk or 0
end)

print('[vr_criminal] Qara bazar sistemi aktivdir.')
