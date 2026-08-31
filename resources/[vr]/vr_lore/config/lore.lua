-- ============================================================
-- vr_lore — Velmora Lore Konfiqi
-- Bütün xəritə markerləri, UI və mətnlər bu adlardan istifadə edir.
-- 100% xəyalidir — real ölkə/qurum adı YOXDUR.
-- ============================================================

vr = vr or {}
vr.Lore = {}

vr.Lore.State = {
    name = 'Velmora Respublikası',
    motto = 'Birlik, Əmək, Gələcək',
    capital = 'Asterra',
    emergency = '196',
}

vr.Lore.Cities = {
    { name = 'Asterra', type = 'capital' },
    { name = 'Novera',  type = 'port' },
    { name = 'Dornel',  type = 'industrial' },
    { name = 'Elvar',   type = 'agricultural' },
    { name = 'Karden',  type = 'mining' },
}

-- Dövlət qurumları (IC adlar)
vr.Lore.Government = {
    police = 'Velmora Polis İdarəsi',
    ems = 'Təcili Tibbi Xidmət',
    fire = 'Yanğın-Xilasetmə Xidməti',
    court = 'Velmora Məhkəmə Sistemi',
    municipality = 'Asterra Bələdiyyəsi',
    bank = 'Velmora Respublikası Mərkəzi Bankı',
    notary = 'Dövlət Notariat Xidməti',
    news = 'Dövlət Xəbər Xidməti',
}

-- Telefon operatorları (xəyali)
vr.Lore.Telecom = {
    'Velkom',
    'AsterTel',
    'NoveraMobile',
}

-- Sosial media platforması (Twatter analoqu)
vr.Lore.SocialMedia = {
    name = 'Kvatter',
}

return vr
