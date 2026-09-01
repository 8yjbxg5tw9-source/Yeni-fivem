-- ============================================================
-- vr_academy — Server: kurslara yazılma və tamamlama
-- ============================================================

local config = lib.require('config.shared')

-- === Kursa yazıl ===
lib.callback.register('vr:academy:enroll', function(source, courseId)
    local player = qbx.getPlayer(source)
    if not player then return false end

    local course
    for _, c in ipairs(config.Courses) do
        if c.id == courseId then course = c break end
    end
    if not course then return false, 'Kurs tapılmadı' end

    if course.cost > 0 then
        local bank = player.PlayerData.money.bank or 0
        if bank < course.cost then return false, 'Kifayət qədər pul yoxdur' end
        player.Functions.RemoveMoney('bank', course.cost, 'akademiya-kurs')
    end

    MySQL.insert.await('INSERT INTO vr_academy (citizenid, course) VALUES (?, ?)',
        { player.PlayerData.citizenid, courseId })
    return true, ('%s kursuna yazıldınız'):format(course.label)
end)

-- === Kursu tamamla (mentor təsdiqi ilə) ===
lib.callback.register('vr:academy:complete', function(source, courseId)
    local player = qbx.getPlayer(source)
    if not player then return false end

    local course
    for _, c in ipairs(config.Courses) do
        if c.id == courseId then course = c break end
    end
    if not course then return false end

    -- Yalnız kursa yazılmış oyunçu tamamlaya bilər (pulsuz lisenziya istismarının qarşısı)
    local enrollment = MySQL.single.await('SELECT * FROM vr_academy WHERE citizenid = ? AND course = ?',
        { player.PlayerData.citizenid, courseId })
    if not enrollment then return false, 'Bu kursa yazılmamısınız' end
    if enrollment.completed == 1 then return false, 'Kurs artıq tamamlanıb' end

    MySQL.update.await('UPDATE vr_academy SET completed = 1 WHERE citizenid = ? AND course = ?',
        { player.PlayerData.citizenid, courseId })

    -- Sertifikat verən kurslarda peşə lisenziyası
    if course.givesCert then
        exports.vr_licenses:giveLicense(source, 'professional', nil)
    end
    return true
end)

-- === Kurslarım ===
lib.callback.register('vr:academy:getMine', function(source)
    local player = qbx.getPlayer(source)
    if not player then return {} end
    return MySQL.query.await('SELECT * FROM vr_academy WHERE citizenid = ?', { player.PlayerData.citizenid })
end)

print('[vr_academy] RP Akademiya sistemi aktivdir.')
