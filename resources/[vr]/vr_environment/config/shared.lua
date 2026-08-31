-- ============================================================
-- vr_environment — Konfiq
-- ============================================================

local config = {}

-- Fəsillər (əkinçilik məhsuldarlığına təsir)
config.Seasons = {
    { id = 'spring', label = 'Yaz', yieldMultiplier = 1.1 },
    { id = 'summer', label = 'Yay', yieldMultiplier = 1.0 },
    { id = 'autumn', label = 'Payız', yieldMultiplier = 1.2 },
    { id = 'winter', label = 'Qış', yieldMultiplier = 0.6 },
}

-- Məhsullar (yetişmə müddəti günlə)
config.Crops = {
    { id = 'wheat', label = 'Buğda', growDays = 3, waterNeeded = 50 },
    { id = 'corn', label = 'Qarğıdalı', growDays = 4, waterNeeded = 40 },
    { id = 'tomato', label = 'Pomidor', growDays = 2, waterNeeded = 30 },
}

-- Heyvandarlıq
config.Animals = {
    { id = 'cow', label = 'İnək', produce = 'milk' },
    { id = 'sheep', label = 'Qoyun', produce = 'wool' },
    { id = 'chicken', label = 'Toyuq', produce = 'egg' },
}

-- Qorunan meşə zonaları (ekoloji RP)
config.ProtectedZones = { 'elvar_forest', 'karden_reserve' }

-- Minerallar (mədən)
config.Minerals = {
    { id = 'iron', label = 'Dəmir filizi', smeltTo = 'metal' },
    { id = 'copper', label = 'Mis filizi', smeltTo = 'copper' },
    { id = 'gold', label = 'Qızıl filizi', smeltTo = 'gold' },
}

return config