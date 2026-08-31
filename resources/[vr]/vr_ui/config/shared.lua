-- ============================================================
-- vr_ui — Konfiq: əlçatanlıq və HUD
-- ============================================================

local config = {}

-- Immersive rejim: crosshair yox, minimal HUD
config.Immersive = {
    crosshair = false,   -- crosshair yox
    minimalHUD = true,   -- minimal HUD
    visualDamage = true, -- zərərlər vizual siqnallarla
}

-- Əlçatanlıq rejimləri
config.Accessibility = {
    colorblind = false,   -- rəngkor rejimi
    largeFont = false,    -- böyük şrift rejimi
    textRP = false,       -- səs altı mətn RP dəstəyi (mute/tekst RP)
}

return config