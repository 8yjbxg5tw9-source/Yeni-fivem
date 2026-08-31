-- ============================================================
-- vr_criminal — Kibercinayət (bank serverinə sızma ssenariləri)
-- ============================================================

-- === Hədəfə hücum (minigame) ===
lib.callback.register('vr:criminal:cyberAttack', function(source, targetId)
    local player = qbx.getPlayer(source)
    if not player then return false end

    local target = MySQL.single.await('SELECT * FROM vr_cyber_targets WHERE id = ?', { targetId })
    if not target then return false, 'Hədəf tapılmadı' end

    -- Hədəf çətinliyinə görə minigame (client tərəfdə oynanır)
    local success = math.random(1, 100) <= (60 - (target.difficulty * 10))
    if not success then
        -- Uğursuzluq → iz qalır → polis xəbərdar
        MySQL.insert.await('INSERT INTO vr_mdt_records (record_type, title, body) VALUES (?, ?, ?)',
            { 'report', 'Kiber hücum cəhdi', target.name })
        return false, 'Sızma uğursuz — iz buraxdınız!'
    end

    -- Uğurlu → qənimət
    player.Functions.AddMoney('bank', target.reward, 'kibercinayet')
    MySQL.update.await('UPDATE vr_cyber_targets SET last_hit = NOW() WHERE id = ?', { targetId })

    -- Anomaliya flag
    MySQL.insert.await('INSERT INTO vr_economy_flags (citizenid, reason, data) VALUES (?, ?, ?)',
        { player.PlayerData.citizenid, 'cyber_attack', target.name })
    return true, target.reward
end)

-- === Kiber hədəfləri siyahıla ===
lib.callback.register('vr:criminal:getCyberTargets', function(source)
    return MySQL.query.await('SELECT * FROM vr_cyber_targets')
end)

print('[vr_criminal] Kibercinayət sistemi aktivdir.')
