-- ============================================================
-- vr_identity — Paylaşılan Konfiq
-- ============================================================

vr = vr or {}
vr.Identity = {}

-- Plastik cərrahiyyə (görünüş dəyişmə) haqqı
vr.Identity.PlasticSurgery = {
    cost = 15000,           -- S₺
    cooldownMinutes = 60,   -- iki əməliyyat arası min. müddət
}

-- Qan qrupları
vr.Identity.BloodTypes = { 'O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-' }

-- Doğum bölgələri (VRN ilk 2 rəqəm kodu)
vr.Identity.Birthplaces = {
    { code = '01', label = 'Asterra' },
    { code = '02', label = 'Novera' },
    { code = '03', label = 'Dornel' },
    { code = '04', label = 'Elvar' },
    { code = '05', label = 'Karden' },
    { code = '06', label = 'Xaric' },
}

return vr
