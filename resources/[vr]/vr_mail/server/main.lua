-- ============================================================
-- vr_mail — Server: poçt sistemi + fırıldaq riski
-- ============================================================

-- === Məktub göndər ===
lib.callback.register('vr:mail:sendLetter', function(source, to, content)
    local player = qbx.getPlayer(source)
    if not player then return false end
    MySQL.insert.await('INSERT INTO vr_mail (`from`, `to`, type, content) VALUES (?, ?, ?, ?)',
        { player.PlayerData.citizenid, to, 'letter', content })
    return true
end)

-- === Bağlama göndər (əşya ilə) ===
lib.callback.register('vr:mail:sendParcel', function(source, to, itemName)
    local player = qbx.getPlayer(source)
    if not player then return false end
    -- Əşyanı inventardan çıxar, bağlamaya qoy
    local has = exports.ox_inventory:GetItem(source, itemName, {}, false)
    if not has then return false, 'Əşya inventarınızda yoxdur' end
    exports.ox_inventory:RemoveItem(source, itemName, 1)

    -- Poçt fırıldağı riski (bağlama itə bilər)
    local lost = math.random(1, 100) <= 10 -- 10% itki riski
    if lost then
        return false, 'Bağlama poçtda itdi (fırıldaq şübhəsi)!'
    end

    MySQL.insert.await('INSERT INTO vr_mail (`from`, `to`, type, item) VALUES (?, ?, ?, ?)',
        { player.PlayerData.citizenid, to, 'parcel', itemName })
    return true
end)

-- === Poçtu al ===
lib.callback.register('vr:mail:collect', function(source)
    local player = qbx.getPlayer(source)
    if not player then return {} end
    local mail = MySQL.query.await('SELECT * FROM vr_mail WHERE `to` = ? AND delivered = 0', { player.PlayerData.citizenid })

    -- Bağlamaları inventara qaytar
    for _, m in ipairs(mail) do
        if m.type == 'parcel' and m.item then
            exports.ox_inventory:AddItem(source, m.item, 1)
        end
    end
    MySQL.update.await('UPDATE vr_mail SET delivered = 1 WHERE `to` = ? AND delivered = 0', { player.PlayerData.citizenid })
    return mail
end)

print('[vr_mail] Poçt sistemi aktivdir.')
