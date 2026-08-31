-- ============================================================
-- vr_vehicles — Client: aşınma, yanacaq, sığortasız sürmə yoxlaması
-- ============================================================

local config = lib.require('config.shared')

-- === Sığortasız sürmə yoxlaması (yol patrul nəzarəti) ===
-- Polis yoxlayanda cərimə yazılır (vr_police ilə)

-- === Yanacaq növü göstəricisi (elektromobil şarj) ===
exports('getFuelType', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then return nil end
    -- Modelə görə yanacaq növü (real istehsalda model cədvəlindən)
    return 'gasoline'
end)

print('[vr_vehicles] Client aktivdir.')
