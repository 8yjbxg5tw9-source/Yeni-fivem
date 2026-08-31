-- ============================================================
-- vr_media — TV canlı efir (live overlay)
-- ============================================================

local liveBroadcast = nil -- { channel, title, by }

-- === Canlı efir başlat ===
lib.callback.register('vr:media:startBroadcast', function(source, channel, title)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local job = player.PlayerData.job and player.PlayerData.job.name or ''
    if job ~= 'news' and job ~= 'media' then return false, 'Yalnız media mətbuatı efir aça bilər' end

    liveBroadcast = { channel = channel, title = title, by = player.PlayerData.citizenid }
    -- Bütün oyunçulara overlay göstər
    TriggerClientEvent('vr:media:showBroadcast', -1, liveBroadcast)
    return true
end)

-- === Efir bitir ===
lib.callback.register('vr:media:stopBroadcast', function(source)
    liveBroadcast = nil
    TriggerClientEvent('vr:media:hideBroadcast', -1)
    return true
end)

-- === Hazırkı efir ===
exports('getBroadcast', function() return liveBroadcast end)

print('[vr_media] TV efir sistemi aktivdir.')
