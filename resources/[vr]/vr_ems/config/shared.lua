-- ============================================================
-- vr_ems — Konfiq: yara növləri, prosedurlar
-- ============================================================

vr = vr or {}
vr.EMS = {}

-- Yara növləri və müalicə prosedurları
vr.EMS.Injuries = {
    gunshot = { label = 'Güllə yarası', severity = 4, bleeding = true, procedure = 'Cərrahi müdaxilə' },
    cut = { label = 'Kəsik', severity = 2, bleeding = true, procedure = 'Tikiş' },
    burn = { label = 'Yanıq', severity = 3, bleeding = false, procedure = 'Yanıq sarğısı' },
    trauma = { label = 'Travma', severity = 3, bleeding = true, procedure = 'Stabilləşdirmə' },
}

-- Qan itkisi timeri (saniyə)
vr.EMS.BleedInterval = 30

-- Reanimasiya pəncərəsi (saniyə)
vr.EMS.ReviveWindow = 300 -- 5 dəqiqə

-- Qan qrupları uyğunluğu (donor -> alıcı)
vr.EMS.BloodCompatibility = {
    ['O-'] = { 'O-', 'O+', 'A-', 'A+', 'B-', 'B+', 'AB-', 'AB+' },
    ['O+'] = { 'O+', 'A+', 'B+', 'AB+' },
    ['A-'] = { 'A-', 'A+', 'AB-', 'AB+' },
    ['A+'] = { 'A+', 'AB+' },
    ['B-'] = { 'B-', 'B+', 'AB-', 'AB+' },
    ['B+'] = { 'B+', 'AB+' },
    ['AB-'] = { 'AB-', 'AB+' },
    ['AB+'] = { 'AB+' },
}

return vr
