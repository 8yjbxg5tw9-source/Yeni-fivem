-- ============================================================
-- vr_environment — Konfiq
-- ============================================================

vr = vr or {}
vr.Environment = {}

-- Fəsillər (əkinçilik məhsuldarlığına təsir)
vr.Environment.Seasons = {
    { id = 'spring', label = 'Yaz', yieldMultiplier = 1.1 },
    { id = 'summer', label = 'Yay', yieldMultiplier = 1.0 },
    { id = 'autumn', label = 'Payız', yieldMultiplier = 1.2 },
    { id = 'winter', label = 'Qış', yieldMultiplier = 0.6 },
}

-- Məhsullar (yetişmə müddəti günlə)
vr.Environment.Crops = {
    { id = 'wheat', label = 'Buğda', growDays = 3, waterNeeded = 50 },
    { id = 'corn', label = 'Qarğıdalı', growDays = 4, waterNeeded = 40 },
    { id = 'tomato', label = 'Pomidor', growDays = 2, waterNeeded = 30 },
}

-- Heyvandarlıq
vr.Environment.Animals = {
    { id = 'cow', label = 'İnək', produce = 'milk' },
    { id = 'sheep', label = 'Qoyun', produce = 'wool' },
    { id = 'chicken', label = 'Toyuq', produce = 'egg' },
}

-- Qorunan meşə zonaları (ekoloji RP)
vr.Environment.ProtectedZones = { 'elvar_forest', 'karden_reserve' }

-- Minerallar (mədən)
vr.Environment.Minerals = {
    { id = 'iron', label = 'Dəmir filizi', smeltTo = 'metal' },
    { id = 'copper', label = 'Mis filizi', smeltTo = 'copper' },
    { id = 'gold', label = 'Qızıl filizi', smeltTo = 'gold' },
}

return vr
