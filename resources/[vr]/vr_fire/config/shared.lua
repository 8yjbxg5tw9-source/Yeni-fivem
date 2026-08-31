-- ============================================================
-- vr_fire — Konfiq
-- ============================================================

vr = vr or {}
vr.Fire = {}

-- Yanğın yayılma sürəti (dəqiqədə %)
vr.Fire.SpreadRate = 10

-- Yanğın növləri
vr.Fire.Types = {
    building = { label = 'Bina yanğını', spreadable = true },
    vehicle = { label = 'Avtomobil yanğını', spreadable = false },
    gas_leak = { label = 'Qaz sızması', spreadable = true, explosive = true },
}

return vr
