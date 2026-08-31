-- ============================================================
-- vr_pets — Konfiq
-- ============================================================

vr = vr or {}
vr.Pets = {}

vr.Pets.Species = { 'dog', 'cat' }

-- Aclıq/sağlamlıq azalma sürəti (saatda)
vr.Pets.DecayPerHour = 3

-- Baytar klinikası müalicə haqqı
vr.Pets.VetCost = 2000

return vr
