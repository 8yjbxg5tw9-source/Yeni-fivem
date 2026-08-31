-- ============================================================
-- vr_admin — Konfiq: staff səviyyələri və səlahiyyət matrisi
-- ============================================================

local config = {}

-- Səviyyə nömrələri (yüksək = çox səlahiyyət)
config.Ranks = {
    helper = 1,
    moderator = 2,
    admin = 3,
    senior = 4,
    head = 5,
    founder = 6,
}

-- Hər əməliyyat üçün minimum səviyyə
config.Permissions = {
    warn = 2,
    kick = 2,
    tempban = 3,
    permban = 4,
    teleport = 3,
    spectate = 3,
    noclip = 3,
    weather_time = 3,
    give_money = 5,   -- yalnız xüsusi icazə (head+)
    give_item = 5,
    restart = 4,
}

return config