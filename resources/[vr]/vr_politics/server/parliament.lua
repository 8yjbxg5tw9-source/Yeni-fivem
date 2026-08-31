-- ============================================================
-- vr_politics — Parlament və qanunlar
-- qəbul edilən qanunlar real mexaniki təsir göstərir
-- ============================================================

local config = lib.require('config.shared')

-- === Qanun təklif et ===
lib.callback.register('vr:politics:proposeLaw', function(source, title, body, effectId)
    local player = qbx.getPlayer(source)
    if not player then return false end
    MySQL.insert.await('INSERT INTO vr_laws (title, body, effect, status) VALUES (?, ?, ?, ?)',
        { title, body, effectId, 'proposed' })
    return true
end)

-- === Qanunu qəbul et (Parlament səsverməsi) ===
lib.callback.register('vr:politics:passLaw', function(source, lawId)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local job = player.PlayerData.job and player.PlayerData.job.name or ''
    if job ~= 'government' and job ~= 'politician' then return false, 'Yalnız Parlament üzvü qəbul edə bilər' end

    MySQL.update.await('UPDATE vr_laws SET status = ?, passed_at = NOW() WHERE id = ?', { 'passed', lawId })

    -- Qanunun mexaniki təsiri
    local law = MySQL.single.await('SELECT * FROM vr_laws WHERE id = ?', { lawId })
    if law and law.effect and config.LawEffects[law.effect] then
        TriggerEvent('vr:politics:lawEffect', law.effect)
    end
    return true
end)

-- === Qanun təsiri (aktiv cərimələr və s.) ===
RegisterNetEvent('vr:politics:lawEffect', function(effectId)
    local effect = config.LawEffects[effectId]
    if not effect then return end
    -- Mexaniki tətbiq: məs. tonirovka qadağası → cərimə cədvəlinə əlavə
    MySQL.update.await('INSERT INTO vr_config (`key`, `value`) VALUES (?, ?) ON DUPLICATE KEY UPDATE value = VALUES(value)',
        { 'active_law_' .. effectId, json.encode(effect) })
end)

-- === Qanunları oxu ===
lib.callback.register('vr:politics:getLaws', function(source)
    return MySQL.query.await('SELECT * FROM vr_laws ORDER BY id DESC')
end)

print('[vr_politics] Parlament sistemi aktivdir.')
