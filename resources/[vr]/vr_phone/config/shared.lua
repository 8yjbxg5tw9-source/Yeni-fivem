-- ============================================================
-- vr_phone — Konfiq: tətbiq siyahısı
-- ============================================================

vr = vr or {}
vr.Phone = {}

-- Telefon tətbiqləri (hamısı azərbaycanca)
vr.Phone.Apps = {
    { id = 'phone',      label = 'Telefon',   icon = 'fa-phone' },
    { id = 'messages',   label = 'Mesajlar',  icon = 'fa-comment' },
    { id = 'contacts',   label = 'Kontaktlar', icon = 'fa-address-book' },
    { id = 'camera',     label = 'Kamera',    icon = 'fa-camera' },
    { id = 'gallery',    label = 'Qalereya',  icon = 'fa-images' },
    { id = 'notes',      label = 'Notlar',    icon = 'fa-sticky-note' },
    { id = 'kvatter',    label = 'Kvatter',   icon = 'fa-feather' },     -- sosial media
    { id = 'darkweb',    label = 'Qaranlıq Şəbəkə', icon = 'fa-user-secret' },
    { id = 'taxi',       label = 'Taksi',     icon = 'fa-taxi' },
    { id = 'race',       label = 'Yeraltı Yarış', icon = 'fa-flag-checkered' },
    { id = 'government', label = 'Dövlət',    icon = 'fa-landmark' },     -- vergi, elanlar
    { id = 'jobs',       label = 'İş Axtarışı', icon = 'fa-briefcase' },
    { id = 'bank',       label = 'Bank',      icon = 'fa-university' },
    { id = 'news',       label = 'Xəbərlər',  icon = 'fa-newspaper' },
    { id = 'weather',    label = 'Hava Proqnozu', icon = 'fa-cloud-sun' },
    { id = 'guide',      label = 'Bələdçi',   icon = 'fa-compass' },      -- yeni oyunçular
}

return vr
