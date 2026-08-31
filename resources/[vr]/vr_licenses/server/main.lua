-- ============================================================
-- vr_licenses — Server: lisenziya idarəetməsi
-- ============================================================

local config = lib.require('config.shared')

local function getCharId(source)
    local player = qbx.getPlayer(source)
    if not player then return nil end
    local row = MySQL.single.await('SELECT id FROM vr_characters WHERE citizenid = ? AND charid = ?',
        { player.PlayerData.citizenid, player.PlayerData.charid })
    return row and row.id
end

-- === Lisenziya ver ===
exports('giveLicense', function(source, licenseType, expiresAt)
    local charId = getCharId(source)
    if not charId then return false end
    MySQL.insert.await('INSERT INTO vr_licenses (char_id, type, status, expires_at) VALUES (?, ?, ?, ?)',
        { charId, licenseType, 'active', expiresAt })
    return true
end)

-- === Lisenziya statusunu yoxla ===
exports('hasLicense', function(source, licenseType)
    local charId = getCharId(source)
    if not charId then return false end
    local lic = MySQL.single.await(
        'SELECT * FROM vr_licenses WHERE char_id = ? AND type = ? AND status = ?',
        { charId, licenseType, 'active' }
    )
    return lic ~= nil
end)

-- === Lisenziya dayandır / ləğv et ===
exports('revokeLicense', function(source, licenseType)
    local charId = getCharId(source)
    if not charId then return false end
    MySQL.update.await('UPDATE vr_licenses SET status = ? WHERE char_id = ? AND type = ?',
        { 'revoked', charId, licenseType })
    return true
end)

-- === Sürücülük xalları (cərimə sistemi) ===
exports('addLicensePoints', function(source, points)
    local charId = getCharId(source)
    if not charId then return false end
    local lic = MySQL.single.await('SELECT * FROM vr_licenses WHERE char_id = ? AND type = ?', { charId, 'driver' })
    if not lic then return false end
    local newPoints = (lic.points or 0) + points
    local status = 'active'
    if newPoints >= 12 then status = 'suspended' end -- 12 xal = dayandırma
    MySQL.update.await('UPDATE vr_licenses SET points = ?, status = ? WHERE id = ?', { newPoints, status, lic.id })
    return true
end)

-- === Lisenziyaları siyahıla (UI) ===
lib.callback.register('vr:licenses:getMine', function(source)
    local charId = getCharId(source)
    if not charId then return {} end
    local list = MySQL.query.await('SELECT * FROM vr_licenses WHERE char_id = ?', { charId })
    return list
end)

-- === Polis lisenziya yoxlaması (səhnədə) ===
lib.callback.register('vr:licenses:check', function(source, targetVRN, licenseType)
    local player = qbx.getPlayer(source)
    if not player then return nil end
    local job = player.PlayerData.job and player.PlayerData.job.name or ''
    if job ~= 'police' then return nil end -- yalnız polis yoxlaya bilər
    local target = exports.vr_identity:getCharByVRN(targetVRN)
    if not target then return nil end
    local lic = MySQL.single.await('SELECT * FROM vr_licenses WHERE char_id = ? AND type = ?',
        { target.id, licenseType })
    return lic
end)

print('[vr_licenses] 196RP — Lisenziya sistemi aktivdir.')
