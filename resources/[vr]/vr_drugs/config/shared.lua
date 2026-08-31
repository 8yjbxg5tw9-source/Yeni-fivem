-- ============================================================
-- vr_drugs — Konfiq: narkotik növləri və zəncir
-- ============================================================

vr = vr or {}
vr.Drugs = {}

-- Narkotik növləri
vr.Drugs.Types = {
    { id = 'weed', label = 'Marixuana', quality = 50 },
    { id = 'coke', label = 'Kokain', quality = 30 },
    { id = 'meth', label = 'Metamfetamin', quality = 20 },
}

-- Zəncir mərhələləri
vr.Drugs.Stages = { 'grow', 'harvest', 'process', 'package', 'sell' }

-- Ərazi riski (yüksək risk = polis basqını şansı)
vr.Drugs.LocationRisk = {
    low = 10,    -- uzaq ərazi
    medium = 30, -- şəhərətrafı
    high = 60,   -- şəhər daxili
}

return vr
