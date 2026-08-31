-- ============================================================
-- vr_core — Client əsas
-- 196RP — Velmora Respublikası
-- ============================================================

-- Lokallaşdırılmış mətn üçün yer
-- (vr_ui resource-u HUD/statusları buradan çəkir)

local function notify(text, type)
    lib.notify({ title = '196RP', description = text, type = type or 'inform' })
end

exports('notify', notify)

-- Nümunə: açılış mesajı
AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        notify('Velmora Respublikasına xoş gəlmisiniz!', 'success')
    end
end)
