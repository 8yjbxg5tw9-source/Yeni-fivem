-- ============================================================
-- vr_environment — Elektrik şəbəkəsi
-- stansiya sabotajı → rayon qaranlıq (kriminal + xilasetmə RP)
-- ============================================================

-- === Rayonu enerjisiz qoy (sabotaj) ===
exports('sabotageGrid', function(source, district)
    MySQL.update.await('INSERT INTO vr_powergrid (district, powered, sabotage_level) VALUES (?, 0, 1) ON DUPLICATE KEY UPDATE powered = 0, sabotage_level = sabotage_level + 1',
        { district })

    -- Polis və yanğınsöndürənlərə bildiriş
    TriggerClientEvent('vr:fire:critical', -1, { location = 'Elektrik stansiyası: ' .. district })
    MySQL.insert.await('INSERT INTO vr_mdt_records (record_type, title, body) VALUES (?, ?, ?)',
        { 'report', 'Elektrik sabotajı', ('Rayon: %s'):format(district) })
    return true
end)

-- === Rayonu bərpa et (xilasetmə) ===
lib.callback.register('vr:environment:restoreGrid', function(source, district)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local job = player.PlayerData.job and player.PlayerData.job.name or ''
    if job ~= 'firefighter' and job ~= 'electrician' then return false, 'Yalnız texniki/xilasetmə bərpa edə bilər' end

    MySQL.update.await('UPDATE vr_powergrid SET powered = 1, sabotage_level = 0 WHERE district = ?', { district })
    return true
end)

-- === Rayon statusu ===
lib.callback.register('vr:environment:getGridStatus', function(source)
    return MySQL.query.await('SELECT * FROM vr_powergrid')
end)

-- === Su/kanalizasiya və yolların baxımı (bələdiyyə büdcəsindən) ===
lib.callback.register('vr:environment:maintenance', function(source, category, amount)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local job = player.PlayerData.job and player.PlayerData.job.name or ''
    if job ~= 'municipality' then return false end

    -- Bələdiyyə büdcəsindən xərc
    MySQL.update.await('UPDATE vr_budget SET spent = spent + ? WHERE category = ?', { amount, 'municipality' })
    return true
end)

print('[vr_environment] Elektrik şəbəkəsi sistemi aktivdir.')
