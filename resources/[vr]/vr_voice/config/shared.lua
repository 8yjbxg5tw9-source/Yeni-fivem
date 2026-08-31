-- ============================================================
-- vr_voice — Konfiq: danışıq rejimləri, radio, headset
-- ============================================================

vr = vr or {}
vr.Voice = {}

-- Danışıq həcmi rejimləri (məsafəyə görə)
vr.Voice.Ranges = {
    whisper = 1.5,   -- pıçıltı
    normal  = 8.0,   -- normal
    shout   = 15.0,  -- qışqırıq
}

-- Radio üçün məcburi əşya (headset/qulaqcıq)
vr.Voice.RadioRequiredItem = 'radio'
vr.Voice.HeadsetItem = 'headset'

-- Polis/EMS daxili dalğaları (şifrələnmiş)
vr.Voice.SecureChannels = {
    { name = 'polis_primary', label = 'Polis — Əsas Dalğa', encrypted = true, job = 'police' },
    { name = 'polis_tactical', label = 'Polis — Taktiki', encrypted = true, job = 'police' },
    { name = 'ems_primary', label = 'EMS — Əsas Dalğa', encrypted = true, job = 'ambulance' },
}

return vr
