-- ============================================================
-- vr_prison — Konfiq
-- ============================================================

local config = {}

-- İşlə cəza azalması (emalatxana/mətbəx işi)
config.WorkReduction = 5 -- hər iş saatına 5 dəqiqə azalma

-- Şərti azadlıq (parole)
config.ParoleEligibility = 0.6 -- cəzanın 60%-i çəkildikdən sonra

-- Girov (bail) həddləri
config.Bail = {
    min = 5000,
    max = 500000,
}

return config