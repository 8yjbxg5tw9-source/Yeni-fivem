-- ============================================================
-- vr_core — Paylaşılan Konfiq
-- 196RP — Velmora Respublikası
-- ============================================================

local config = {}

-- === DÖVLƏT (Lore) ===
config.State = {
    name = 'Velmora Respublikası',
    capital = 'Asterra',
    currency = 'Solen',
    currencySymbol = 'S₺',
    emergencyNumber = '196',
    countryCode = '+42',
}

-- === ŞƏHƏRLƏR / BÖLGƏLƏR ===
config.Regions = {
    { id = 'asterra', label = 'Asterra', plateLetter = 'A', regionCode = '01' },
    { id = 'novera',  label = 'Novera',  plateLetter = 'N', regionCode = '02' },
    { id = 'dornel',  label = 'Dornel',  plateLetter = 'D', regionCode = '03' },
    { id = 'elvar',   label = 'Elvar',   plateLetter = 'E', regionCode = '04' },
    { id = 'karden',  label = 'Karden',  plateLetter = 'K', regionCode = '05' },
}

-- === VƏTƏNDAŞLIQ SƏVİYYƏLƏRİ ===
config.Citizenship = {
    { level = 'temporary', label = 'Müvəqqəti Vətəndaş' },
    { level = 'citizen',   label = 'Vətəndaş' },
    { level = 'trusted',   label = 'Etibarlı' },
    { level = 'veteran',   label = 'Veteran' },
}

-- === LİSENZİYALAR ===
config.Licenses = {
    'driver', 'weapon', 'hunting', 'fishing', 'business', 'pilot', 'professional',
}

-- === BAYRAM TƏQVİMİ (milli təqvim) ===
config.Holidays = {
    { day = 14, month = 3,  label = 'Birlik Günü' },
    { day = 3,  month = 5,  label = 'Respublika Günü' },
}

-- === MƏHDUDİYYƏTLƏR ===
config.Limits = {
    maxCharacters = 3,        -- maksimum aktiv personaj
    maxTransfer = 1000000,    -- tək köçürmə limiti (S₺)
    trialDays = 14,           -- müvəqqəti vətəndaşlıq sınaq müddəti
}

-- === İQTİSADİYYAT ===
config.Economy = {
    bankInterestRate = 0.05,      -- əmanət faizi (5%)
    incomeTaxRate = 0.10,         -- gəlir vergisi (10%)
    salesTaxRate = 0.05,          -- satış vergisi (5%)
    propertyTaxRate = 0.02,       -- əmlak vergisi (2%)
}

return config