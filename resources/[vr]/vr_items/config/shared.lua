-- ============================================================
-- vr_items — Konfiq: metadata sahələri
-- ============================================================

local config = {}

-- Hər əşyaya tətbiq olunan metadata sahələri
config.MetadataFields = {
    quality = { type = 'number', min = 0, max = 100, default = 100 },   -- keyfiyyət %
    serial = { type = 'string', default = '' },                          -- seriya №
    owner = { type = 'string', default = '' },                           -- kimə məxsusdur
    durability = { type = 'number', min = 0, max = 100, default = 100 }, -- istifadə müddəti
    producedAt = { type = 'number', default = 0 },                       -- istehsal zamanı (unix)
}

return config