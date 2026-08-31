-- ============================================================
-- vr_status — Konfiq
-- ============================================================

vr = vr or {}
vr.Status = {}

vr.Status.Defaults = {
    hunger = 100,    -- aclıq
    thirst = 100,    -- susuzluq
    stress = 0,      -- stress
    fatigue = 0,     -- yorğunluq
}

-- Azalma sürətləri (dəqiqədə xal)
vr.Status.DrainPerMinute = {
    hunger = 0.3,
    thirst = 0.4,
    stress = 0.1,
    fatigue = 0.2,
}

-- Kritik həddlər (vizual siqnallar üçün)
vr.Status.Critical = {
    hunger = 20,
    thirst = 20,
    stress = 80,
    fatigue = 80,
}

return vr
