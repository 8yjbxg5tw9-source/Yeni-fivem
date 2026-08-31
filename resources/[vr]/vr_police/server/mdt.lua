-- ============================================================
-- vr_police — MDT (Mobile Data Terminal)
-- şəxs/VIN/arama axtarışı, BOLO, protokollar, insident hesabatları
-- ============================================================

local function isPolice(source)
    local player = qbx.getPlayer(source)
    if not player then return false end
    return (player.PlayerData.job and player.PlayerData.job.name == 'police')
end

-- === Şəxs axtarışı (VRN ilə) ===
lib.callback.register('vr:police:lookupPerson', function(source, vrn)
    if not isPolice(source) then return nil end
    local char = exports.vr_identity:getCharByVRN(vrn)
    if not char then return nil, 'Şəxs tapılmadı' end
    -- Lisenziyalar + cərimələr + cinayət keçmişi
    local licenses = MySQL.query.await('SELECT * FROM vr_licenses WHERE char_id = ?', { char.id })
    local fines = MySQL.query.await('SELECT * FROM vr_fines WHERE char_id = ?', { char.id })
    local profile = MySQL.single.await('SELECT * FROM vr_profile WHERE char_id = ?', { char.id })
    return {
        vrn = char.vrn,
        name = ('%s %s'):format(char.firstname, char.lastname),
        licenses = licenses,
        fines = fines,
        credit_score = profile and profile.credit_score or nil,
    }
end)

-- === VIN axtarışı ===
lib.callback.register('vr:police:lookupVehicle', function(source, vin)
    if not isPolice(source) then return nil end
    local vehicle = MySQL.single.await('SELECT * FROM vr_vehicle_records WHERE vin = ?', { vin })
    if not vehicle then return nil, 'Nəqliyyat tapılmadı' end
    local events = MySQL.query.await('SELECT * FROM vr_vehicle_events WHERE vin = ? ORDER BY created_at DESC', { vin })
    return { vehicle = vehicle, history = events }
end)

-- === Axtarış qərarı (arama) — mexaniki kilid ===
lib.callback.register('vr:police:createWarrant', function(source, targetCharId, reason)
    if not isPolice(source) then return false end
    MySQL.insert.await('INSERT INTO vr_mdt_records (char_id, record_type, title, body, officer) VALUES (?, ?, ?, ?, ?)',
        { targetCharId, 'warrant', 'Axtarış qərarı', reason, 'officer' })
    return true
end)

-- === Axtarış qərarı yoxlaması (anbar/otaq açmadan əvvəl) ===
lib.callback.register('vr:police:hasWarrant', function(source, targetCharId)
    if not isPolice(source) then return false end
    local warrant = MySQL.single.await(
        "SELECT * FROM vr_mdt_records WHERE char_id = ? AND record_type = 'warrant' AND status = 'open'",
        { targetCharId }
    )
    return warrant ~= nil
end)

-- === BOLO yarat ===
lib.callback.register('vr:police:createBOLO', function(source, title, body)
    if not isPolice(source) then return false end
    MySQL.insert.await('INSERT INTO vr_mdt_records (record_type, title, body, officer) VALUES (?, ?, ?, ?)',
        { 'bolo', title, body, 'officer' })
    return true
end)

-- === BOLO siyahısı ===
lib.callback.register('vr:police:getBOLOs', function(source)
    if not isPolice(source) then return {} end
    return MySQL.query.await("SELECT * FROM vr_mdt_records WHERE record_type = 'bolo' AND status = 'open' ORDER BY id DESC")
end)

-- === İnsident hesabatı ===
lib.callback.register('vr:police:createReport', function(source, title, body)
    if not isPolice(source) then return false end
    MySQL.insert.await('INSERT INTO vr_mdt_records (record_type, title, body, officer) VALUES (?, ?, ?, ?)',
        { 'report', title, body, 'officer' })
    return true
end)

-- === Cərimə yaz ===
lib.callback.register('vr:police:issueFine', function(source, targetCharId, reason, amount)
    if not isPolice(source) then return false end
    MySQL.insert.await('INSERT INTO vr_fines (char_id, officer, reason, amount) VALUES (?, ?, ?, ?)',
        { targetCharId, 'officer', reason, amount })
    return true
end)

print('[vr_police] MDT sistemi aktivdir.')
