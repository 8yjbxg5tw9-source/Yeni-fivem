-- ============================================================
-- vr_police — Client: avadanlıq UI (breathalyzer, narkotest, radar)
-- ============================================================

-- === Breathalyzer UI ===
exports('useBreathalyzer', function(targetId)
    local result = lib.callback.await('vr:police:breathalyzer', false, targetId)
    if not result then return end
    lib.notify({
        title = 'Alkoqol Testi',
        description = ('BAC: %.2f — %s'):format(result.bac, result.note),
        type = result.intoxicated and 'error' or 'success',
    })
end)

-- === Narkotest UI ===
exports('useDrugTest', function(targetId)
    local result = lib.callback.await('vr:police:drugTest', false, targetId)
    if not result then return end
    local desc = result.count > 0 and ('MÜSBƏT: ' .. table.concat(result.positive, ', ')) or 'MƏNFİ'
    lib.notify({ title = 'Narkotest', description = desc, type = result.count > 0 and 'error' or 'success' })
end)

-- === Radar UI ===
exports('useRadar', function(targetId)
    local result = lib.callback.await('vr:police:radar', false, targetId)
    if not result then
        lib.notify({ title = 'Radar', description = 'Hədəf nəqliyyatda deyil', type = 'error' })
        return
    end
    lib.notify({ title = 'Radar', description = ('Sürət: %d km/h'):format(result.speed), type = 'inform' })
end)

-- === MDT açılışı (sadə input UI) ===
exports('openMDT', function()
    local input = lib.inputDialog('MDT — Axtarış', {
        { type = 'input', label = 'VRN və ya VIN', required = true },
    })
    if not input then return end
    local query = input[1]
    if query:match('^VR%-') then
        local person = lib.callback.await('vr:police:lookupPerson', false, query)
        if person then
            lib.notify({ title = 'MDT — Şəxs', description = ('%s | Kredit: %s'):format(person.name, tostring(person.credit_score)), type = 'inform' })
        end
    else
        local vehicle = lib.callback.await('vr:police:lookupVehicle', false, query)
        if vehicle then
            lib.notify({ title = 'MDT — Nəqliyyat', description = ('VIN: %s'):format(vehicle.vehicle.vin), type = 'inform' })
        end
    end
end)
