-- ============================================================
-- vr_prison — Client: həbsxana UI (iş, parole)
-- ============================================================

-- === Emalatxana/mətbəx işi ===
exports('doWork', function()
    local success = lib.callback.await('vr:prison:work', false)
    if success then
        lib.notify({ title = 'Emalatxana', description = 'İşlədiniz — cəza müddəti azaldı.', type = 'success' })
    end
end)

-- === Şərti azadlıq müraciəti ===
exports('requestParole', function()
    local success, msg = lib.callback.await('vr:prison:requestParole', false)
    lib.notify({ title = 'Şərti Azadlıq', description = msg or (success and 'Müraciət qəbul edildi' or 'Rədd edildi'), type = success and 'success' or 'error' })
end)

print('[vr_prison] Client aktivdir.')
