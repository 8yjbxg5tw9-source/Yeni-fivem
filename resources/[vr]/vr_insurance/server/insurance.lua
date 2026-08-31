-- ============================================================
-- vr_insurance — Sığorta şirkəti (oyunçu biznesi ola bilər)
-- ============================================================

local config = lib.require('config.shared')

-- === Sığorta polisi al ===
lib.callback.register('vr:insurance:buyPolicy', function(source, insuranceType)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local info = config.Types[insuranceType]
    if not info then return false, 'Sığorta növü tapılmadı' end

    local bank = player.PlayerData.money.bank or 0
    if bank < info.premium then return false, 'Kifayət qədər pul yoxdur' end

    player.Functions.RemoveMoney('bank', info.premium, 'sigorta-' .. insuranceType)
    -- Polis metadata kimi saxlanır (real istehsalda tamamlanır)
    return true
end)

-- === İddia aç (hadisə baş verdi) ===
lib.callback.register('vr:insurance:fileClaim', function(source, insuranceType, details)
    local player = qbx.getPlayer(source)
    if not player then return false end
    -- İddia araşdırması (saxtakarlıq aşkarlanması üçün)
    MySQL.insert.await('INSERT INTO vr_audit_log (staff, action, target, detail) VALUES (?, ?, ?, ?)',
        { 'insurance', 'claim', player.PlayerData.citizenid, json.encode(details) })
    return true, 'İddia qeydə alındı — araşdırılacaq'
end)

-- === Sığorta saxtakarlığı aşkarlanması ===
-- Çox qısa müddətdə çoxlu iddia → flag
exports('detectFraud', function(citizenid)
    local claims = MySQL.scalar.await(
        "SELECT COUNT(*) FROM vr_audit_log WHERE staff = 'insurance' AND action = 'claim' AND target = ? AND created_at > NOW() - INTERVAL 7 DAY",
        { citizenid }
    )
    return (claims or 0) >= 3 -- 7 gündə 3+ iddia = şübhəli
end)

print('[vr_insurance] Sığorta sistemi aktivdir.')
