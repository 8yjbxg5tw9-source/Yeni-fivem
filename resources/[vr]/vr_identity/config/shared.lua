-- ============================================================
-- vr_identity — Paylaşılan Konfiq
-- ============================================================

local config = {}

-- Plastik cərrahiyyə (görünüş dəyişmə) haqqı
config.PlasticSurgery = {
    cost = 15000,           -- S₺
    cooldownMinutes = 60,   -- iki əməliyyat arası min. müddət
}

-- Qan qrupları
config.BloodTypes = { 'O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-' }

-- Doğum bölgələri (VRN ilk 2 rəqəm kodu)
config.Birthplaces = {
    { code = '01', label = 'Asterra' },
    { code = '02', label = 'Novera' },
    { code = '03', label = 'Dornel' },
    { code = '04', label = 'Elvar' },
    { code = '05', label = 'Karden' },
    { code = '06', label = 'Xaric' },
}

return config