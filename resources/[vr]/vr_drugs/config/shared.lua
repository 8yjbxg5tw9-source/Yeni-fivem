-- ============================================================
-- vr_drugs — Konfiq: narkotik növləri və zəncir
-- ============================================================

local config = {}

-- Narkotik növləri
config.Types = {
    { id = 'weed', label = 'Marixuana', quality = 50 },
    { id = 'coke', label = 'Kokain', quality = 30 },
    { id = 'meth', label = 'Metamfetamin', quality = 20 },
}

-- Zəncir mərhələləri
config.Stages = { 'grow', 'harvest', 'process', 'package', 'sell' }

-- Ərazi riski (yüksək risk = polis basqını şansı)
config.LocationRisk = {
    low = 10,    -- uzaq ərazi
    medium = 30, -- şəhərətrafı
    high = 60,   -- şəhər daxili
}

return config