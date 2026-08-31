-- ============================================================
-- vr_media — Client: TV overlay, reklam, leak bildirişi
-- ============================================================

-- === TV canlı efir overlay ===
RegisterNetEvent('vr:media:showBroadcast', function(data)
    lib.notify({ title = 'CANLI EFİR: ' .. data.channel, description = data.title, type = 'inform', duration = 10000 })
    -- Overlay (real istehsalda NUI ilə tam ekran overlay)
end)

RegisterNetEvent('vr:media:hideBroadcast', function()
    -- Overlay bağlanır
end)

-- === Reklam lövhəsi ===
RegisterNetEvent('vr:media:showBillboard', function(data)
    lib.notify({ title = 'Reklam', description = data.content, type = 'inform', duration = 8000 })
end)

-- === Yeni sızıntı bildirişi ===
RegisterNetEvent('vr:media:newLeak', function(data)
    lib.notify({ title = 'MƏLUMAT SIZMASI', description = ('%s (%s)'):format(data.title, data.targetOrg or 'naməlum'), type = 'error' })
end)

print('[vr_media] Client aktivdir.')
