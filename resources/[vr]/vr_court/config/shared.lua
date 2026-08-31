-- ============================================================
-- vr_court — Konfiq: instansiyalar, rollar
-- ============================================================

local config = {}

-- Məhkəmə instansiyaları
config.Instances = {
    { id = 'lower', label = 'Aşağı Məhkəmə' },
    { id = 'appeal', label = 'Apellyasiya Məhkəməsi' },
    { id = 'supreme', label = 'Ali Məhkəmə' },
}

-- İş növləri
config.CaseTypes = {
    { id = 'criminal', label = 'Cinayət' },
    { id = 'civil', label = 'Mülki' },
    { id = 'administrative', label = 'İnzibati' },
}

-- Məhkəmə rolları
config.Roles = { 'judge', 'prosecutor', 'defense', 'public_defender' }

return config