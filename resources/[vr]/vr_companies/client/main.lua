-- ============================================================
-- vr_companies — Client: şirkət UI (sadə)
-- ============================================================

-- === Şirkət məlumatını göstər ===
exports('showCompany', function(companyId)
    local info = lib.callback.await('vr:companies:getInfo', false, companyId)
    if not info then return end
    lib.notify({
        title = info.company.name,
        description = ('İşçi sayı: %d | Stok əşyası: %d'):format(#info.employees, #info.stock),
        type = 'inform',
    })
end)

print('[vr_companies] Client aktivdir.')
