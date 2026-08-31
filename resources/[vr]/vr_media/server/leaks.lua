-- ============================================================
-- vr_media — Məlumat sızması (leak) mexanikası
-- ============================================================

-- === Sızıntı dərc et (jurnalistlərə) ===
lib.callback.register('vr:media:publishLeak', function(source, title, body, targetOrg)
    local player = qbx.getPlayer(source)
    if not player then return false end

    -- Anonimlik (leaker adı saxlanmır, yalnız citizenid hash kimi)
    MySQL.insert.await('INSERT INTO vr_leaks (leaker, title, body, target_org) VALUES (?, ?, ?, ?)',
        { player.PlayerData.citizenid, title, body, targetOrg })

    -- Jurnalistlərə bildiriş (mətbuat kartı olanlar)
    TriggerClientEvent('vr:media:newLeak', -1, { title = title, targetOrg = targetOrg })
    return true
end)

-- === Sızıntıları oxu (yalnız jurnalistlər) ===
lib.callback.register('vr:media:getLeaks', function(source)
    local player = qbx.getPlayer(source)
    if not player then return {} end
    local job = player.PlayerData.job and player.PlayerData.job.name or ''
    if job ~= 'journalist' and job ~= 'news' then return {} end
    return MySQL.query.await('SELECT id, title, body, target_org, published_at FROM vr_leaks ORDER BY published_at DESC LIMIT 20')
end)

print('[vr_media] Məlumat sızması sistemi aktivdir.')
