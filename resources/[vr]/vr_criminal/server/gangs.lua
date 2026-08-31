-- ============================================================
-- vr_criminal — Dəstələr: iyerarxiya, turf, reputasiya, anbar
-- ============================================================

-- === Dəstə yarat ===
lib.callback.register('vr:criminal:createGang', function(source, gangName)
    local player = qbx.getPlayer(source)
    if not player then return false end
    MySQL.insert.await('INSERT INTO vr_gangs (name, leader) VALUES (?, ?)',
        { gangName, player.PlayerData.citizenid })
    return true
end)

-- === Dəstəyə üzv qoş ===
lib.callback.register('vr:criminal:joinGang', function(source, gangId)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local exists = MySQL.single.await('SELECT * FROM vr_gang_members WHERE gang_id = ? AND citizenid = ?',
        { gangId, player.PlayerData.citizenid })
    if exists then return false, 'Artıq dəstədəsiniz' end
    MySQL.insert.await('INSERT INTO vr_gang_members (gang_id, citizenid) VALUES (?, ?)',
        { gangId, player.PlayerData.citizenid })
    return true
end)

-- === Rütbə təyin et (lider) ===
lib.callback.register('vr:criminal:setRank', function(source, gangId, targetCitizenid, rank)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local gang = MySQL.single.await('SELECT * FROM vr_gangs WHERE id = ?', { gangId })
    if not gang or gang.leader ~= player.PlayerData.citizenid then return false, 'Yalnız lider rütbə təyin edə bilər' end
    MySQL.update.await('UPDATE vr_gang_members SET rank = ? WHERE gang_id = ? AND citizenid = ?',
        { rank, gangId, targetCitizenid })
    return true
end)

-- === Reputasiya artır (uğurlu soyğun) ===
exports('addReputation', function(gangId, amount)
    MySQL.update.await('UPDATE vr_gangs SET reputation = reputation + ? WHERE id = ?', { amount or 1, gangId })
    return true
end)

-- === Reputasiya oxu (soyğun kilidi üçün) ===
exports('getReputation', function(gangId)
    local gang = MySQL.single.await('SELECT reputation FROM vr_gangs WHERE id = ?', { gangId })
    return gang and gang.reputation or 0
end)

-- === Turf (grafitti xəritəsi) ===
lib.callback.register('vr:criminal:claimTurf', function(source, gangId, turfZone)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local gang = MySQL.single.await('SELECT * FROM vr_gangs WHERE id = ?', { gangId })
    if not gang then return false end

    local turf = json.decode(gang.turf or '{}')
    turf[turfZone] = { claimedAt = os.time(), by = player.PlayerData.citizenid }
    MySQL.update.await('UPDATE vr_gangs SET turf = ? WHERE id = ?', { json.encode(turf), gangId })
    return true
end)

-- === Turf xəritəsini oxu ===
lib.callback.register('vr:criminal:getTurfMap', function(source)
    local gangs = MySQL.query.await('SELECT id, name, turf FROM vr_gangs')
    local map = {}
    for _, g in ipairs(gangs) do
        map[g.name] = json.decode(g.turf or '{}')
    end
    return map
end)

print('[vr_criminal] Dəstə sistemi aktivdir.')
