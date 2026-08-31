-- ============================================================
-- vr_emotes — Konfiq: emote siyahısı (azərbaycanca etiketlər)
-- ============================================================

vr = vr or {}
vr.Emotes = {}

-- Emote siyahısı (dict, anim, ad)
vr.Emotes.List = {
    { label = 'Salamlaşma', dict = 'gestures@m@standing@casual', anim = 'gesture_hello' },
    { label = 'Əl sıxma', dict = 'mp_common', anim = 'givetake1_a' },
    { label = 'Oturma', dict = 'anim@amb@business@bgen@bgen_no_work', anim = 'sit_phone_phoneputdown_idle_nowork' },
    { label = 'Yatma', dict = 'amb@world_human_sunbathe@female@back@base', anim = 'base' },
    { label = 'Rəqs', dict = 'anim@mp_player_intcelebrationmale@uncle_disco', anim = 'uncle_disco' },
    { label = 'Əl qaldır', dict = 'missminuteman_1ig_2', anim = 'handsup_base' },
    { label = 'Gülüş', dict = 'anim@arena@celeb@flat@solo@no_props', anim = 'angry_clap_b' },
    { label = 'Ağlama', dict = 'anim@mp_player_intcelebrationfemale@air_shagging', anim = 'air_shagging' },
}

return vr
