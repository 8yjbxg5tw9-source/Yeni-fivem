-- ============================================================
-- vr_banking — Konfiq
-- ============================================================

vr = vr or {}
vr.Banking = {}

vr.Banking.InterestRate = 0.05      -- illik əmanət faizi (5%)
vr.Banking.MaxTransfer = 1000000    -- tək köçürmə limiti (S₺)
vr.Banking.LargeTransferNotify = 100000 -- böyük köçürmə bildiriş həddi

return vr
