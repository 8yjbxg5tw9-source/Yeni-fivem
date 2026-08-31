-- ============================================================
-- vr_prison — Konfiq
-- ============================================================

vr = vr or {}
vr.Prison = {}

-- İşlə cəza azalması (emalatxana/mətbəx işi)
vr.Prison.WorkReduction = 5 -- hər iş saatına 5 dəqiqə azalma

-- Şərti azadlıq (parole)
vr.Prison.ParoleEligibility = 0.6 -- cəzanın 60%-i çəkildikdən sonra

-- Girov (bail) həddləri
vr.Prison.Bail = {
    min = 5000,
    max = 500000,
}

return vr
