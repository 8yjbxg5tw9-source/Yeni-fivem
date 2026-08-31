-- ============================================================
-- vr_licenses — Konfiq
-- ============================================================

local config = {}

config.Types = {
    { id = 'driver',       label = 'Sürücülük vəsiqəsi', maxPoints = 12 },
    { id = 'weapon',       label = 'Silah lisenziyası',  maxPoints = 0 },
    { id = 'hunting',      label = 'Ovçuluq lisenziyası', maxPoints = 0 },
    { id = 'fishing',      label = 'Balıqçılıq lisenziyası', maxPoints = 0 },
    { id = 'business',     label = 'Biznes lisenziyası', maxPoints = 0 },
    { id = 'pilot',        label = 'Pilot lisenziyası',  maxPoints = 0 },
    { id = 'professional', label = 'Peşə lisenziyası',   maxPoints = 0 },
}

return config