-- ============================================================
-- vr_criminal — Konfiq: soyğun pilləsi, reputasiya
-- ============================================================

vr = vr or {}
vr.Criminal = {}

-- Soyğun pilləsi (reputasiya xalı tələb olunur — mexaniki kilid)
vr.Criminal.HeistTiers = {
    { id = 'market', label = 'Market', minRep = 0, rewardMin = 5000, rewardMax = 15000 },
    { id = 'house', label = 'Ev', minRep = 1, rewardMin = 10000, rewardMax = 30000 },
    { id = 'warehouse', label = 'Obyekt (anbar)', minRep = 2, rewardMin = 20000, rewardMax = 60000 },
    { id = 'jewelry', label = 'Zərgərlik', minRep = 3, rewardMin = 40000, rewardMax = 120000 },
    { id = 'armored', label = 'Zirehli nəqliyyat', minRep = 4, rewardMin = 80000, rewardMax = 200000 },
    { id = 'bank_branch', label = 'Filial bank', minRep = 5, rewardMin = 150000, rewardMax = 400000 },
    { id = 'central_bank', label = 'Mərkəzi Bank', minRep = 6, rewardMin = 500000, rewardMax = 1500000 },
    { id = 'casino', label = 'Kazino', minRep = 7, rewardMin = 400000, rewardMax = 1200000 },
    { id = 'island', label = 'Ada əməliyyatı', minRep = 8, rewardMin = 1000000, rewardMax = 3000000 },
}

-- Minigame çətinlikləri
vr.Criminal.Minigames = {
    lockpick = { type = 'skill', difficulty = 1 },
    hack = { type = 'hack', difficulty = 2 },
    thermite = { type = 'thermite', difficulty = 3 },
}

return vr
