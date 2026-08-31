-- ============================================================
-- vr_media — Radiostansiyalar və DJ
-- ============================================================

-- === Radiostansiya yarat ===
lib.callback.register('vr:media:createStation', function(source, name, frequency, genre)
    local player = qbx.getPlayer(source)
    if not player then return false end
    MySQL.insert.await('INSERT INTO vr_radio_stations (name, frequency, genre) VALUES (?, ?, ?)',
        { name, frequency, genre })
    return true
end)

-- === DJ kimi canlı yayıma gir ===
lib.callback.register('vr:media:djLive', function(source, stationId)
    local player = qbx.getPlayer(source)
    if not player then return false end
    MySQL.update.await('UPDATE vr_radio_stations SET live = 1, dj = ? WHERE id = ?',
        { player.PlayerData.citizenid, stationId })
    return true
end)

-- === Radiostansiya siyahısı ===
lib.callback.register('vr:media:getStations', function(source)
    return MySQL.query.await('SELECT * FROM vr_radio_stations')
end)

-- === Frekansı aç (dinləyici) ===
lib.callback.register('vr:media:tuneStation', function(source, frequency)
    local station = MySQL.single.await('SELECT * FROM vr_radio_stations WHERE frequency = ?', { frequency })
    if not station then return false, 'Bu frekansda stansiya yoxdur' end
    return true, station.name
end)

print('[vr_media] Radio sistemi aktivdir.')
