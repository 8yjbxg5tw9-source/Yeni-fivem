-- ============================================================
-- vr_property — Konfiq: əmlak pillələri
-- ============================================================

local config = {}

-- Yaşayış pillələri
config.Tiers = {
    { id = 'motel', label = 'Motel otağı', minPrice = 5000 },
    { id = 'apartment', label = 'Mənzil', minPrice = 50000 },
    { id = 'house', label = 'Ev', minPrice = 200000 },
    { id = 'villa', label = 'Villa', minPrice = 800000 },
}

-- Kommunal növləri
config.Utilities = { 'electricity', 'water', 'gas' }

return config