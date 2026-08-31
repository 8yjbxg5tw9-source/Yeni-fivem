-- ============================================================
-- vr_whitelist — Konfiq
-- ============================================================

vr = vr or {}
vr.Whitelist = {}

-- Sınaq müddəti (gün)
vr.Whitelist.TrialDays = 14

-- Səviyyə sırası (aşağıdan yuxarı)
vr.Whitelist.LevelOrder = { temporary = 1, citizen = 2, trusted = 3, veteran = 4 }

return vr
