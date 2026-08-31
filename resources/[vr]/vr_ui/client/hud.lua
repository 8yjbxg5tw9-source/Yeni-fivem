-- ============================================================
-- vr_ui — HUD: minimal, immersive (crosshair yox)
-- ============================================================

local config = lib.require('config.shared')

-- === Immersive rejim tətbiqi ===
CreateThread(function()
    while true do
        Wait(1000)
        -- Crosshair yox (immersive)
        if config.Immersive.crosshair == false then
            -- GTA crosshair-ini gizlətmək üçün UI elementləri
            HideHudComponentThisFrame(1)  -- WANTED_STARS
            HideHudComponentThisFrame(2)  -- WEAPON_ICON
            HideHudComponentThisFrame(4)  -- CASH
        end
        -- Minimal HUD
        if config.Immersive.minimalHUD then
            DisplayRadar(false)
        end
    end
end)

-- === Ölüm ekranı (azərbaycanca) ===
RegisterNetEvent('vr:ui:deathScreen', function()
    SendNUIMessage({ action = 'showDeath' })
    -- NLR mesajı
    lib.notify({ title = 'Ölüm', description = 'Yeni Həyat (NLR) qaydası tətbiq olunur. Hadisəni xatırlamırsınız.', type = 'error' })
end)
