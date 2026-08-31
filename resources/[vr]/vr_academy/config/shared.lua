-- ============================================================
-- vr_academy — Konfiq: kurslar
-- ============================================================

local config = {}

-- RP Akademiya kursları (Peşə Mərkəzləri)
config.Courses = {
    { id = 'basics', label = 'RP Əsasları', cost = 0, givesCert = false },
    { id = 'driving', label = 'İdarəetmə Kursu', cost = 2000, givesCert = false },
    { id = 'first_job', label = 'İlk İş Bələdçisi', cost = 0, givesCert = false },
    { id = 'chef', label = 'Aşbazlıq Kursu', cost = 5000, givesCert = true },
    { id = 'mechanic', label = 'Mexanika Kursu', cost = 5000, givesCert = true },
}

return config