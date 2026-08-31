-- ============================================================
-- vr_police — Konfiq: bölmələr, cərimələr, sübut keyfiyyəti
-- ============================================================

local config = {}

-- Polis bölmələri
config.Departments = {
    { id = 'city',      label = 'Şəhər Polisi' },
    { id = 'patrol',    label = 'Yol Patrul' },
    { id = 'investigation', label = 'Araşdırmalar Bürosu' },
    { id = 'swat',      label = 'Xüsusi Əməliyyat' },
    { id = 'border',    label = 'Sərhəd-Liman Mühafizəsi' },
    { id = 'penitentiary', label = 'Penitensiar' },
    { id = 'internal',  label = 'Daxili Nəzarət' },
}

-- Sürücülük cərimələri (S₺)
config.Fines = {
    speeding = 1500,
    redlight = 2000,
    illegal_parking = 1000,
    no_license = 3000,
    reckless = 4000,
    drunk_driving = 15000,
}

-- Sübut keyfiyyəti zamanla necə düşür (%/gün)
config.EvidenceDecay = 5.0 -- hər gün 5% keyfiyyət itkisi

return config