-- ============================================================
-- vr_identity — Vətəndaşlıq Reyestri (nikah/boşanma/ölüm/vəsiyyət)
-- ============================================================

-- === Reyestr hadisəsi yazmaq ===
local function addCivilRecord(charId, recordType, details)
    MySQL.insert.await(
        'INSERT INTO vr_civil_records (char_id, record_type, details) VALUES (?, ?, ?)',
        { charId, recordType, json.encode(details) }
    )
end

exports('addCivilRecord', addCivilRecord)

-- === Nikah ===
lib.callback.register('vr:identity:marry', function(source, targetCharId)
    local player = qbx.getPlayer(source)
    if not player then return false, 'Oyuncu tapılmadı' end
    local self = MySQL.single.await('SELECT id FROM vr_characters WHERE citizenid = ? AND charid = ?',
        { player.PlayerData.citizenid, player.PlayerData.charid })
    if not self then return false, 'Personaj tapılmadı' end
    addCivilRecord(self.id, 'marriage', { partner = targetCharId })
    return true, 'Nikah reyestrdə qeydə alındı'
end)

-- === Boşanma ===
lib.callback.register('vr:identity:divorce', function(source, targetCharId)
    local player = qbx.getPlayer(source)
    if not player then return false, 'Oyuncu tapılmadı' end
    local self = MySQL.single.await('SELECT id FROM vr_characters WHERE citizenid = ? AND charid = ?',
        { player.PlayerData.citizenid, player.PlayerData.charid })
    if not self then return false, 'Personaj tapılmadı' end
    addCivilRecord(self.id, 'divorce', { partner = targetCharId })
    return true, 'Boşanma reyestrdə qeydə alındı'
end)

-- === Ölüm şəhadətnaməsi (CK və ya daimi ölüm) ===
lib.callback.register('vr:identity:registerDeath', function(source, targetCharId, cause)
    local player = qbx.getPlayer(source)
    if not player then return false end
    addCivilRecord(targetCharId, 'death', { cause = cause or 'unknown' })
    MySQL.update.await('UPDATE vr_characters SET status = ? WHERE id = ?', { 'dead', targetCharId })
    return true
end)

-- === Vəsiyyətnamə (notariatda) ===
lib.callback.register('vr:identity:registerWill', function(source, willData)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local self = MySQL.single.await('SELECT id FROM vr_characters WHERE citizenid = ? AND charid = ?',
        { player.PlayerData.citizenid, player.PlayerData.charid })
    if not self then return false end
    addCivilRecord(self.id, 'will', willData)
    return true
end)

print('[vr_identity] Vətəndaşlıq Reyestri aktivdir.')
