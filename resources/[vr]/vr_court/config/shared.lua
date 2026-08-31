-- ============================================================
-- vr_court — Konfiq: instansiyalar, rollar
-- ============================================================

vr = vr or {}
vr.Court = {}

-- Məhkəmə instansiyaları
vr.Court.Instances = {
    { id = 'lower', label = 'Aşağı Məhkəmə' },
    { id = 'appeal', label = 'Apellyasiya Məhkəməsi' },
    { id = 'supreme', label = 'Ali Məhkəmə' },
}

-- İş növləri
vr.Court.CaseTypes = {
    { id = 'criminal', label = 'Cinayət' },
    { id = 'civil', label = 'Mülki' },
    { id = 'administrative', label = 'İnzibati' },
}

-- Məhkəmə rolları
vr.Court.Roles = { 'judge', 'prosecutor', 'defense', 'public_defender' }

return vr
