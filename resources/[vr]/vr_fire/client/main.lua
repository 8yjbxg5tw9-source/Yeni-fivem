-- ============================================================
-- vr_fire — Client: yanğın vizualları və bildirişlər
-- ============================================================

-- === Kritik yanğın bildirişi ===
RegisterNetEvent('vr:fire:critical', function(data)
    lib.notify({ title = 'KRİTİK YANĞIN', description = 'Geniş miqyaslı yanğın: ' .. data.location, type = 'error' })
end)

-- === Qaz sızması xəbərdarlığı ===
RegisterNetEvent('vr:fire:gasWarning', function(data)
    lib.notify({ title = 'QAZ SIZMASI', description = 'Partlayış riski: ' .. data.location .. ' — ərazini boşaldın!', type = 'error' })
end)

-- === Qəza-xilasetmə çağırışı ===
RegisterNetEvent('vr:fire:rescueCall', function(data)
    lib.notify({ title = 'Xilasetmə çağırışı', description = data.description .. ' — ' .. data.location, type = 'inform' })
end)

print('[vr_fire] Client aktivdir.')
