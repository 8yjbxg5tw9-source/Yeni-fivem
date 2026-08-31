-- ============================================================
-- vr_companies — Konfiq: şirkət növləri, peşə zəncirləri
-- ============================================================

vr = vr or {}
vr.Companies = {}

-- Şirkət növləri
vr.Companies.Types = {
    { id = 'restaurant', label = 'Restoran' },
    { id = 'dealership', label = 'Avtosalon' },
    { id = 'logistics', label = 'Servis/Logistika' },
    { id = 'clothing', label = 'Geyim' },
    { id = 'nightclub', label = 'Gecə Klubu' },
    { id = 'security', label = 'Təhlükəsizlik' },
    { id = 'media', label = 'Media' },
    { id = 'farm', label = 'Ferma' },
    { id = 'mine', label = 'Mədən' },
    { id = 'estate', label = 'Əmlak' },
    { id = 'clinic', label = 'Klinika' },
    { id = 'law', label = 'Hüquq Bürosu' },
}

-- Peşə zəncirləri (KİLİDLİ — bir peşə digərindən asılıdır)
vr.Companies.SupplyChains = {
    restaurant = { needs = 'farm', item = 'ingredient' },          -- restoran fermersiz işləmir
    dealership = { needs = 'logistics', item = 'vehicle_part' },    -- avtosalon logistikasız premium satmır
    mechanic = { needs = 'logistics', item = 'premium_part' },      -- mexanik liman tədarükü olmadan tuning edə bilmir
}

return vr
