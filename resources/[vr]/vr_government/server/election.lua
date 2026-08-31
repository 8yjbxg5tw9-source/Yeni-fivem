-- ============================================================
-- vr_government — Seçki və Referendum
-- ============================================================

-- === Seçki/referendum yarat ===
lib.callback.register('vr:government:createElection', function(source, title, electionType, endAt)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local job = player.PlayerData.job and player.PlayerData.job.name or ''
    if job ~= 'election' and not exports.vr_admin:hasPermission(source, 'give_money') then
        return false, 'Yalnız Seçki Komissiyası seçki aça bilər'
    end
    MySQL.insert.await('INSERT INTO vr_elections (title, type, status, end_at) VALUES (?, ?, ?, ?)',
        { title, electionType, 'active', endAt })
    return true
end)

-- === Səs ver ===
lib.callback.register('vr:government:vote', function(source, electionId, choice)
    local player = qbx.getPlayer(source)
    if not player then return false, 'Oyuncu tapılmadı' end

    -- Seçki hüququ yalnız tam vətəndaşlıqda
    local level = exports.vr_whitelist:getLevel(player.PlayerData.citizenid)
    if level == 'temporary' then return false, 'Müvəqqəti vətəndaşlar səs verə bilməz' end

    -- Təkrar səs yoxlaması (UNIQUE constraint)
    local ok = pcall(MySQL.insert.await,
        'INSERT INTO vr_votes (election_id, citizenid, choice) VALUES (?, ?, ?)',
        { electionId, player.PlayerData.citizenid, choice })
    if not ok then return false, 'Artıq səs vermisiniz' end
    return true
end)

-- === Nəticələr ===
lib.callback.register('vr:government:getResults', function(source, electionId)
    local results = MySQL.query.await(
        'SELECT choice, COUNT(*) as count FROM vr_votes WHERE election_id = ? GROUP BY choice',
        { electionId }
    )
    return results
end)

print('[vr_government] Seçki sistemi aktivdir.')
