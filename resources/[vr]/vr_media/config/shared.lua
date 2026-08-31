-- ============================================================
-- vr_media — Konfiq
-- ============================================================

vr = vr or {}
vr.Media = {}

-- TV kanalları
vr.Media.TVChannels = {
    { id = 'vrn1', label = 'VRN 1 (Dövlət)' },
    { id = 'news24', label = 'Xəbər 24' },
    { id = 'sports', label = 'İdman TV' },
}

-- Reklam lövhələri icarə qiyməti (S₺/gün)
vr.Media.BillboardRate = 500

return vr
