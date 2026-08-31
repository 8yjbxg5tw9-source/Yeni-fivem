-- ============================================================
-- vr_ems — Client: yaralanma vizual siqnalları, EMS alətləri
-- ============================================================

local config = lib.require('config.shared')

-- === Qan itkisi timeri (vizual) ===
RegisterNetEvent('vr:ems:bleeding', function()
    CreateThread(function()
        while true do
            Wait(config.BleedInterval * 1000)
            -- Ekran qırmızılığı + zəiflik
            local ped = PlayerPedId()
            SetPedMotionBlur(ped, true)
            SetPlayerHealthRechargeMultiplier(PlayerId(), 0.2)
            lib.notify({ title = 'Qan itkisi', description = 'Qanaxma davam edir — təcili tibbi yardım çağırın!', type = 'error' })
        end
    end)
end)

-- === Ağır yara (topallama, ekran solğunluğu) ===
RegisterNetEvent('vr:ems:severeInjury', function(injuryType)
    local info = config.Injuries[injuryType]
    if not info then return end
    lib.notify({ title = 'Yaralanma', description = info.label .. ' — ' .. info.procedure .. ' tələb olunur', type = 'error' })
    -- Topallama effekti
    SetPedToRagdoll(PlayerPedId(), 2000, 2000, 0, false, false, false)
end)

-- === Reanimasiya ekranı ===
RegisterNetEvent('vr:ems:reviveScreen', function()
    lib.notify({ title = 'Reanimasiya', description = 'Reanimasiya pəncərəsindəsiniz — EMS gəlir', type = 'inform' })
end)

print('[vr_ems] Client aktivdir.')
