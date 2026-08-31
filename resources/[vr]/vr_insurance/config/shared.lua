-- ============================================================
-- vr_insurance — Konfiq
-- ============================================================

vr = vr or {}
vr.Insurance = {}

-- Sığorta növləri və mükafatları
vr.Insurance.Types = {
    auto = { label = 'Avto sığorta', premium = 2000 },
    health = { label = 'Tibb sığorta', premium = 1500 },
    property = { label = 'Əmlak sığorta', premium = 3000 },
}

-- Lotereya
vr.Insurance.Lottery = {
    ticketPrice = 100,
    drawIntervalHours = 168, -- həftəlik (7 gün)
    jackpotStart = 100000,
}

return vr
