-- ============================================================
-- vr_admin — Əlavə alətlər: fingerprint ban, restart planlayıcısı, resmon
-- ============================================================

-- === Ban-fingerprint analitikası (cihaz əsaslı) ===
lib.callback.register('vr:admin:recordFingerprint', function(source, fingerprint)
    local player = qbx.getPlayer(source)
    if not player then return false end
    MySQL.insert.await('INSERT INTO vr_ban_fingerprints (citizenid, fingerprint) VALUES (?, ?)',
        { player.PlayerData.citizenid, fingerprint })
    return true
end)

-- === Fingerprint ilə ban-müqavimət yoxlaması ===
exports('isFingerprintBanned', function(fingerprint)
    local row = MySQL.single.await('SELECT * FROM vr_ban_fingerprints WHERE fingerprint = ? AND banned = 1', { fingerprint })
    return row ~= nil
end)

-- === Fingerprint-i banla (alt hesabla geri dönmənin qarşısı) ===
lib.callback.register('vr:admin:banFingerprint', function(source, fingerprint)
    if not exports.vr_admin:hasPermission(source, 'permban') then return false end
    MySQL.update.await('UPDATE vr_ban_fingerprints SET banned = 1 WHERE fingerprint = ?', { fingerprint })
    exports.vr_admin:audit('fingerprint_ban', source, fingerprint, nil)
    return true
end)

-- === Restart planlaşdır ===
lib.callback.register('vr:admin:scheduleRestart', function(source, minutes, reason)
    if not exports.vr_admin:hasPermission(source, 'restart') then return false end
    local scheduledAt = os.date('%Y-%m-%d %H:%M:%S', os.time() + (minutes * 60))
    MySQL.insert.await('INSERT INTO vr_restart_schedule (scheduled_at, reason) VALUES (?, ?)', { scheduledAt, reason })
    exports.vr_admin:audit('restart_scheduled', source, minutes, reason)

    -- Geri sayım + restart
    local remaining = minutes * 60
    while remaining > 0 do
        Wait(1000)
        remaining = remaining - 1
        if remaining == 300 then TriggerClientEvent('chat:addMessage', -1, { args = { 'SERVER', 'Server 5 dəqiqəyə restart olacaq!' } })
        elseif remaining == 60 then TriggerClientEvent('chat:addMessage', -1, { args = { 'SERVER', 'Server 1 dəqiqəyə restart olacaq!' } })
        elseif remaining == 0 then
            TriggerEvent('txAdmin:events:scheduledRestart', { reason = reason or 'Planlı restart' })
        end
    end
    return true
end)

-- === Resurs monitorinqi (resmon məlumatı) ===
lib.callback.register('vr:admin:getResourceUsage', function(source)
    if not exports.vr_admin:hasPermission(source, 'give_money') then return {} end
    -- Real resmon məlumatı txAdmin/GetResourceMetrics ilə alınır
    -- Burada struktur nümunəsi qaytarılır
    return {
        { resource = 'vr_core', cpu = 0.02, memory = 4.5 },
        { resource = 'vr_police', cpu = 0.15, memory = 12.0 },
    }
end)

print('[vr_admin] Əlavə alətlər aktivdir.')
