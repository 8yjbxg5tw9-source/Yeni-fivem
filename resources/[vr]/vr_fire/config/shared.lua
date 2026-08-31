-- ============================================================
-- vr_fire — Konfiq
-- ============================================================

local config = {}

-- Yanğın yayılma sürəti (dəqiqədə %)
config.SpreadRate = 10

-- Yanğın növləri
config.Types = {
    building = { label = 'Bina yanğını', spreadable = true },
    vehicle = { label = 'Avtomobil yanğını', spreadable = false },
    gas_leak = { label = 'Qaz sızması', spreadable = true, explosive = true },
}

return config