-- ============================================================
-- vr_banking — Konfiq
-- ============================================================

local config = {}

config.InterestRate = 0.05      -- illik əmanət faizi (5%)
config.MaxTransfer = 1000000    -- tək köçürmə limiti (S₺)
config.LargeTransferNotify = 100000 -- böyük köçürmə bildiriş həddi

return config