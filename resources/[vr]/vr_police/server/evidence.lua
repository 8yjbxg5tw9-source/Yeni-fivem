-- ============================================================
-- vr_police — Sübut sistemi
-- barmaq izi, DNT, giliz analizi, qan izi, bodycam, kamera
-- ============================================================

local config = lib.require('config.shared')

local function isPolice(source)
    local player = qbx.getPlayer(source)
    if not player then return false end
    return (player.PlayerData.job and player.PlayerData.job.name == 'police')
end

-- === Sübut toplama ===
lib.callback.register('vr:police:collectEvidence', function(source, evidenceType, targetCharId, data)
    if not isPolice(source) then return false end
    MySQL.insert.await(
        'INSERT INTO vr_evidence (evidence_type, char_id, data, quality) VALUES (?, ?, ?, ?)',
        { evidenceType, targetCharId, json.encode(data or {}), 100.00 }
    )
    return true
end)

-- === Sübut analizi (keyfiyyət zamanla düşür) ===
lib.callback.register('vr:police:analyzeEvidence', function(source, evidenceId)
    if not isPolice(source) then return nil end
    local evidence = MySQL.single.await('SELECT * FROM vr_evidence WHERE id = ?', { evidenceId })
    if not evidence then return nil, 'Sübut tapılmadı' end

    -- Zamanla keyfiyyət itkisi
    local collectedAt = evidence.collected_at
    local days = (os.time() - os.time({ year = 2020, month = 1, day = 1 })) / 86400 -- təxmini; real istehsalda düzəldilir
    -- Sadələşdirilmiş: keyfiyyət DB-dən oxunur, gündəlik decay ayrı loopda
    local quality = evidence.quality or 100

    return {
        id = evidence.id,
        type = evidence.evidence_type,
        char_id = evidence.char_id,
        data = json.decode(evidence.data or '{}'),
        quality = quality,
    }
end)

-- === Gündəlik keyfiyyət itkisi (sübutlar müddətli saxlanılır) ===
CreateThread(function()
    while true do
        Wait(24 * 60 * 60 * 1000)
        MySQL.update.await(
            'UPDATE vr_evidence SET quality = GREATEST(0, quality - ?) WHERE quality > 0',
            { config.EvidenceDecay }
        )
    end
end)

-- === Bədən kamerası (açılıb-bağlanan) ===
local bodycamActive = {}
exports('setBodycam', function(source, active)
    bodycamActive[source] = active and true or false
    return true
end)

exports('isBodycamActive', function(source)
    return bodycamActive[source] == true
end)

-- === Ballistika qeydi (giliz izi) ===
lib.callback.register('vr:police:registerBallistics', function(source, weaponSerial, ownerCharId)
    if not isPolice(source) then return false end
    MySQL.insert.await('INSERT INTO vr_ballistics (weapon_serial, owner_char_id, registered) VALUES (?, ?, ?)',
        { weaponSerial, ownerCharId, 1 })
    return true
end)

-- === Giliz analizi (cinayət yerindən) ===
lib.callback.register('vr:police:matchBallistics', function(source, shellMark)
    if not isPolice(source) then return nil end
    -- Ballistik bazada uyğunluq axtar
    local match = MySQL.single.await('SELECT * FROM vr_ballistics WHERE weapon_serial = ?', { shellMark })
    return match
end)

print('[vr_police] Sübut sistemi aktivdir.')
