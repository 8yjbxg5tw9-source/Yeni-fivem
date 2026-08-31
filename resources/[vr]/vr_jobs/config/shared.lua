-- ============================================================
-- vr_jobs — Konfiq: başlanğıc və ixtisaslı işlər
-- ============================================================

local config = {}

-- Başlanğıc işləri (hər kəsə açıq)
config.Starter = {
    { id = 'taxi', label = 'Taksi' },
    { id = 'bus', label = 'Avtobus' },
    { id = 'courier', label = 'Kuryer' },
    { id = 'cargo', label = 'Yükdaşıma' },
    { id = 'garbage', label = 'Zibil' },
    { id = 'postal', label = 'Poçt' },
    { id = 'warehouse', label = 'Anbar' },
    { id = 'fisher', label = 'Balıqçı' },
    { id = 'farmer', label = 'Fermer' },
    { id = 'lumberjack', label = 'Meşəçi' },
    { id = 'miner', label = 'Mədənçi' },
    { id = 'construction', label = 'Tikinti' },
    { id = 'dockworker', label = 'Liman işçisi' },
}

-- İxtisaslı işlər (attestasiya/lisenziya tələb edir)
config.Skilled = {
    { id = 'mechanic', label = 'Mexanik/Tuner', requires = 'professional' },
    { id = 'doctor', label = 'Tibb', requires = 'professional' },
    { id = 'lawyer', label = 'Vəkil', requires = 'professional' },
    { id = 'journalist', label = 'Jurnalist', requires = 'professional' },
    { id = 'photographer', label = 'Fotoqraf', requires = 'professional' },
    { id = 'realtor', label = 'Əmlak agenti', requires = 'professional' },
    { id = 'security', label = 'Təhlükəsizlik', requires = 'professional' },
    { id = 'accountant', label = 'Mühasib', requires = 'professional' },
    { id = 'architect', label = 'Memar', requires = 'professional' },
    { id = 'electrician', label = 'Elektrik', requires = 'professional' },
    { id = 'telecom', label = 'Telekom texniki', requires = 'professional' },
    { id = 'chef', label = 'Aşpaz', requires = 'professional' },
    { id = 'nightclub', label = 'Gecə klubu', requires = 'professional' },
    { id = 'designer', label = 'Dizayner', requires = 'professional' },
    { id = 'race_org', label = 'Yarış təşkilatçısı', requires = 'professional' },
}

return config