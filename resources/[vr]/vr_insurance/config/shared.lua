-- ============================================================
-- vr_insurance — Konfiq
-- ============================================================

local config = {}

-- Sığorta növləri və mükafatları
config.Types = {
    auto = { label = 'Avto sığorta', premium = 2000 },
    health = { label = 'Tibb sığorta', premium = 1500 },
    property = { label = 'Əmlak sığorta', premium = 3000 },
}

-- Lotereya
config.Lottery = {
    ticketPrice = 100,
    drawIntervalHours = 168, -- həftəlik (7 gün)
    jackpotStart = 100000,
}

return config