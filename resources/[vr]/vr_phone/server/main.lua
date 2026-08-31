-- ============================================================
-- vr_phone — Server: zəng, SMS, kontakt, notlar
-- ============================================================

-- === Telefon nömrəsi təyin et (personaj üçün) ===
lib.callback.register('vr:phone:getNumber', function(source)
    local player = qbx.getPlayer(source)
    if not player then return nil end
    local char = exports.vr_identity:getCharBySource(source)
    if not char then return nil end
    if not char.phone then
        -- Nömrə təyin et: +42 (6-9) XXX-XXXX
        char.phone = ('+42 (7) %03d-%04d'):format(math.random(100, 999), math.random(1000, 9999))
        MySQL.update.await('UPDATE vr_characters SET phone = ? WHERE id = ?', { char.phone, char.id })
    end
    return char.phone
end)

-- === Zəng (basit simulyasiya; real pma-voice zəng axını Addım 5-də tamamlanır) ===
lib.callback.register('vr:phone:call', function(source, targetNumber)
    local player = qbx.getPlayer(source)
    if not player then return false end
    -- Hədəf oyunçunu nömrə ilə tap
    local target = MySQL.single.await('SELECT id FROM vr_characters WHERE phone = ?', { targetNumber })
    if not target then return false, 'Nömrə tapılmadı' end
    return true, 'Zəng edilir…'
end)

-- === SMS göndər ===
lib.callback.register('vr:phone:sendMessage', function(source, toNumber, body)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local char = exports.vr_identity:getCharBySource(source)
    if not char or not char.phone then return false end
    if #body > 500 then return false end
    MySQL.insert.await('INSERT INTO vr_messages (`from`, `to`, body) VALUES (?, ?, ?)',
        { char.phone, toNumber, body })
    return true
end)

-- === SMS-ləri oxu ===
lib.callback.register('vr:phone:getMessages', function(source)
    local char = exports.vr_identity:getCharBySource(source)
    if not char or not char.phone then return {} end
    return MySQL.query.await('SELECT * FROM vr_messages WHERE `to` = ? ORDER BY id DESC LIMIT 50', { char.phone })
end)

-- === Kontaktlar ===
lib.callback.register('vr:phone:getContacts', function(source)
    local char = exports.vr_identity:getCharBySource(source)
    if not char or not char.phone then return {} end
    return MySQL.query.await('SELECT * FROM vr_contacts WHERE owner = ?', { char.phone })
end)

lib.callback.register('vr:phone:addContact', function(source, name, number)
    local char = exports.vr_identity:getCharBySource(source)
    if not char or not char.phone then return false end
    MySQL.insert.await('INSERT INTO vr_contacts (owner, name, number) VALUES (?, ?, ?)', { char.phone, name, number })
    return true
end)

print('[vr_phone] 196RP — Telefon server tərəfi aktivdir.')
