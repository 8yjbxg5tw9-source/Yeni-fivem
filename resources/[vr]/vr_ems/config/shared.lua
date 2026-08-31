-- ============================================================
-- vr_ems — Konfiq: yara növləri, prosedurlar
-- ============================================================

local config = {}

-- Yara növləri və müalicə prosedurları
config.Injuries = {
    gunshot = { label = 'Güllə yarası', severity = 4, bleeding = true, procedure = 'Cərrahi müdaxilə' },
    cut = { label = 'Kəsik', severity = 2, bleeding = true, procedure = 'Tikiş' },
    burn = { label = 'Yanıq', severity = 3, bleeding = false, procedure = 'Yanıq sarğısı' },
    trauma = { label = 'Travma', severity = 3, bleeding = true, procedure = 'Stabilləşdirmə' },
}

-- Qan itkisi timeri (saniyə)
config.BleedInterval = 30

-- Reanimasiya pəncərəsi (saniyə)
config.ReviveWindow = 300 -- 5 dəqiqə

-- Qan qrupları uyğunluğu (donor -> alıcı)
config.BloodCompatibility = {
    ['O-'] = { 'O-', 'O+', 'A-', 'A+', 'B-', 'B+', 'AB-', 'AB+' },
    ['O+'] = { 'O+', 'A+', 'B+', 'AB+' },
    ['A-'] = { 'A-', 'A+', 'AB-', 'AB+' },
    ['A+'] = { 'A+', 'AB+' },
    ['B-'] = { 'B-', 'B+', 'AB-', 'AB+' },
    ['B+'] = { 'B+', 'AB+' },
    ['AB-'] = { 'AB-', 'AB+' },
    ['AB+'] = { 'AB+' },
}

return config