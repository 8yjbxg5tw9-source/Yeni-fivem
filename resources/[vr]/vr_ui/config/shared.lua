-- ============================================================
-- vr_ui — Konfiq: əlçatanlıq və HUD
-- ============================================================

vr = vr or {}
vr.UI = {}

-- Immersive rejim: crosshair yox, minimal HUD
vr.UI.Immersive = {
    crosshair = false,   -- crosshair yox
    minimalHUD = true,   -- minimal HUD
    visualDamage = true, -- zərərlər vizual siqnallarla
}

-- Əlçatanlıq rejimləri
vr.UI.Accessibility = {
    colorblind = false,   -- rəngkor rejimi
    largeFont = false,    -- böyük şrift rejimi
    textRP = false,       -- səs altı mətn RP dəstəyi (mute/tekst RP)
}

return vr
