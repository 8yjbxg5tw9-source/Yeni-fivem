-- ============================================================
-- vr_politics — Mitinq icazələri və aksiya protokolları
-- ============================================================

-- === Mitinq icazəsi müraciəti ===
lib.callback.register('vr:politics:requestRally', function(source, location, datetime)
    local player = qbx.getPlayer(source)
    if not player then return false end
    MySQL.insert.await('INSERT INTO vr_rally_permits (organizer, location, datetime) VALUES (?, ?, ?)',
        { player.PlayerData.citizenid, location, datetime })
    return true, 'Mitinq müraciəti göndərildi'
end)

-- === İcazəni təsdiqlə/redd et (bələdiyyə) ===
lib.callback.register('vr:politics:reviewRally', function(source, permitId, approve)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local job = player.PlayerData.job and player.PlayerData.job.name or ''
    if job ~= 'municipality' then return false, 'Yalnız bələdiyyə baxa bilər' end

    local status = approve and 'approved' or 'denied'
    MySQL.update.await('UPDATE vr_rally_permits SET status = ?, approved_by = ? WHERE id = ?',
        { status, player.PlayerData.citizenid, permitId })
    return true
end)

-- === Referendum yarat (Seçki Komissiyası) ===
lib.callback.register('vr:politics:createReferendum', function(source, title)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local job = player.PlayerData.job and player.PlayerData.job.name or ''
    if job ~= 'election' then return false end
    MySQL.insert.await('INSERT INTO vr_elections (title, type, status) VALUES (?, ?, ?)', { title, 'referendum', 'active' })
    return true
end)

print('[vr_politics] Mitinq və referendum sistemi aktivdir.')
