-- ============================================================
-- vr_property — Konfiq: əmlak pillələri
-- ============================================================

vr = vr or {}
vr.Property = {}

-- Yaşayış pillələri
vr.Property.Tiers = {
    { id = 'motel', label = 'Motel otağı', minPrice = 5000 },
    { id = 'apartment', label = 'Mənzil', minPrice = 50000 },
    { id = 'house', label = 'Ev', minPrice = 200000 },
    { id = 'villa', label = 'Villa', minPrice = 800000 },
}

-- Kommunal növləri
vr.Property.Utilities = { 'electricity', 'water', 'gas' }

return vr
