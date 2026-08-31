-- ============================================================
-- vr_politics — Vəzifəli şəxslərin əmlak bəyannaməsi
-- lüks əmlak reyestri (jurnalistlər baxa bilər)
-- ============================================================

-- === Bəyannamə təqdim et ===
lib.callback.register('vr:politics:submitDeclaration', function(source, declaration, luxury)
    local player = qbx.getPlayer(source)
    if not player then return false end
    MySQL.insert.await('INSERT INTO vr_asset_declarations (citizenid, declaration, luxury) VALUES (?, ?, ?)',
        { player.PlayerData.citizenid, json.encode(declaration), luxury and 1 or 0 })
    return true
end)

-- === Lüks əmlak reyestri (jurnalistlər üçün ictimai) ===
lib.callback.register('vr:politics:getLuxuryRegistry', function(source)
    local player = qbx.getPlayer(source)
    if not player then return {} end
    local job = player.PlayerData.job and player.PlayerData.job.name or ''
    if job ~= 'journalist' and job ~= 'news' then return {} end
    return MySQL.query.await('SELECT citizenid, declaration, submitted_at FROM vr_asset_declarations WHERE luxury = 1')
end)

print('[vr_politics] Əmlak bəyannaməsi sistemi aktivdir.')
