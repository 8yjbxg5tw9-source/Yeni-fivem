-- ============================================================
-- vr_status — Server: statusların saxlanması
-- ============================================================

-- Statuslar client tərəfində hesablanır və dövri olaraq serverə yazılır.
-- Bu, qbx metadata mexanizmi ilə saxlanılır (istehsalda tamamlanır).

-- === Statusları oxu (digər resurslar üçün) ===
lib.callback.register('vr:status:get', function(source)
    local player = qbx.getPlayer(source)
    if not player then return nil end
    local metadata = player.PlayerData.metadata or {}
    return metadata.vr_status or {}
end)

-- === Statusları yaz ===
lib.callback.register('vr:status:set', function(source, status, value)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local meta = player.PlayerData.metadata or {}
    meta.vr_status = meta.vr_status or {}
    meta.vr_status[status] = math.max(0, math.min(100, tonumber(value) or 0))
    player.Functions.SetMetaData('vr_status', meta.vr_status)
    return true
end)

-- === Client-dən dövri sinxron ===
RegisterNetEvent('vr:status:sync', function(statusKey, value)
    local src = source
    local player = qbx.getPlayer(src)
    if not player then return end
    local meta = player.PlayerData.metadata or {}
    meta.vr_status = meta.vr_status or {}
    meta.vr_status[statusKey] = math.max(0, math.min(100, tonumber(value) or 0))
    player.Functions.SetMetaData('vr_status', meta.vr_status)
end)

print('[vr_status] 196RP — Status sistemi aktivdir.')
