-- ============================================================
-- vr_ems — Server: yaralar, müalicə, reanimasiya, asılılıq
-- ============================================================

local config = lib.require('config.shared')

local function isEMS(source)
    local player = qbx.getPlayer(source)
    if not player then return false end
    return (player.PlayerData.job and player.PlayerData.job.name == 'ambulance')
end

-- === Yara qeyd et (zərər alanda) ===
exports('registerInjury', function(source, injuryType, severity)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local char = exports.vr_identity:getCharBySource(source)
    if not char then return false end
    MySQL.insert.await('INSERT INTO vr_injuries (char_id, injury_type, severity, bleeding) VALUES (?, ?, ?, ?)',
        { char.id, injuryType, severity or 1, config.Injuries[injuryType] and config.Injuries[injuryType].bleeding and 1 or 0 })
    return true
end)

-- === Yaraları oxu (EMS üçün) ===
lib.callback.register('vr:ems:getInjuries', function(source, targetCharId)
    if not isEMS(source) then return {} end
    return MySQL.query.await('SELECT * FROM vr_injuries WHERE char_id = ? AND treated = 0', { targetCharId })
end)

-- === Müalicə ===
lib.callback.register('vr:ems:treat', function(source, injuryId, procedure)
    if not isEMS(source) then return false end
    MySQL.update.await('UPDATE vr_injuries SET treated = 1, treated_by = ? WHERE id = ?', { 'ems', injuryId })
    return true
end)

-- === Ağır yaralar daimi iz buraxa bilər ===
lib.callback.register('vr:ems:markScar', function(source, injuryId)
    if not isEMS(source) then return false end
    MySQL.update.await('UPDATE vr_injuries SET permanent_scar = 1 WHERE id = ?', { injuryId })
    return true
end)

-- === Reanimasiya pəncərəsi ===
lib.callback.register('vr:ems:canRevive', function(source, targetCharId)
    if not isEMS(source) then return false end
    local death = MySQL.single.await(
        'SELECT * FROM vr_deaths WHERE char_id = ? AND revivable = 1 AND revived = 0 ORDER BY id DESC LIMIT 1',
        { targetCharId }
    )
    if not death then return false end
    local elapsed = os.time() - (death.death_time and os.time() or os.time())
    -- sadələşdirilmiş; real istehsalda death_time timestamp ilə
    return elapsed <= config.ReviveWindow
end)

-- === Ölüm qeyd et ===
exports('registerDeath', function(source, cause)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local char = exports.vr_identity:getCharBySource(source)
    if not char then return false end
    MySQL.insert.await('INSERT INTO vr_deaths (char_id, cause) VALUES (?, ?)', { char.id, cause or 'unknown' })
    return true
end)

-- === Asılılıq mexanikası ===
exports('addAddiction', function(source, substance, level)
    local char = exports.vr_identity:getCharBySource(source)
    if not char then return false end
    local existing = MySQL.single.await('SELECT * FROM vr_addictions WHERE char_id = ? AND substance = ?', { char.id, substance })
    if existing then
        MySQL.update.await('UPDATE vr_addictions SET level = level + ? WHERE id = ?', { level or 1, existing.id })
    else
        MySQL.insert.await('INSERT INTO vr_addictions (char_id, substance, level) VALUES (?, ?, ?)', { char.id, substance, level or 1 })
    end
    return true
end)

-- === Reabilitasiya ===
lib.callback.register('vr:ems:startRehab', function(source, targetCharId)
    if not isEMS(source) then return false end
    MySQL.update.await('UPDATE vr_addictions SET rehab_status = ? WHERE char_id = ?', { 'in_progress', targetCharId })
    return true
end)

print('[vr_ems] Tibbi sistem aktivdir.')
