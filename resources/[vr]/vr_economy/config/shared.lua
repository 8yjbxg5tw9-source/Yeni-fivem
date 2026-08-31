-- ============================================================
-- vr_economy — Konfiq: büdcə kateqoriyaları, vergi dərəcələri
-- ============================================================

local config = {}

-- Dövlət büdcəsi kateqoriyaları (maaş fondu)
config.BudgetCategories = {
    police = { label = 'Polis', baseAllocation = 100000 },
    ems = { label = 'Təcili Tibbi Xidmət', baseAllocation = 60000 },
    fire = { label = 'Yanğın-Xilasetmə', baseAllocation = 40000 },
    municipality = { label = 'Bələdiyyə', baseAllocation = 50000 },
    transport = { label = 'Nəqliyyat', baseAllocation = 30000 },
    other = { label = 'Digər', baseAllocation = 20000 },
}

-- Vergi dərəcələri
config.TaxRates = {
    income = 0.10,     -- gəlir vergisi 10%
    sales = 0.05,      -- satış vergisi 5%
    property = 0.02,   -- əmlak vergisi 2%
    import = 0.15,     -- idxal rüsumu 15%
}

-- Maaş fondunun büdcəyə bağlılığı
-- Vergi gəliri base-dən aşağı düşərsə, maaşlar mütənasib kəsilir
config.SalaryThreshold = 0.7 -- 70%-dən aşağı vergi = maaş kəsintisi

return config