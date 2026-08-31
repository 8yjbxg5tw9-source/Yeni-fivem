-- ============================================================
-- vr_referral — Server: referral kodu yarat və istifadə et
-- ============================================================

-- === Referral kodu yarat ===
lib.callback.register('vr:referral:createCode', function(source)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local code = ('VR-%s'):format(math.random(100000, 999999))
    MySQL.insert.await('INSERT INTO vr_referrals (referrer, code) VALUES (?, ?)',
        { player.PlayerData.citizenid, code })
    return true, code
end)

-- === Referral kodunu istifadə et ===
lib.callback.register('vr:referral:useCode', function(source, code)
    local player = qbx.getPlayer(source)
    if not player then return false end

    local ref = MySQL.single.await('SELECT * FROM vr_referrals WHERE code = ? AND used_by IS NULL', { code })
    if not ref then return false, 'Kod etibarsızdır və ya istifadə olunub' end
    if ref.referrer == player.PlayerData.citizenid then return false, 'Öz kodunuzu istifadə edə bilməzsiniz' end

    MySQL.update.await('UPDATE vr_referrals SET used_by = ? WHERE id = ?', { player.PlayerData.citizenid, ref.id })

    -- Mükafat: dəvət edənə IC kosmetik/bonus
    exports.vr_admin:audit('referral_used', source, ref.referrer, code)
    return true, 'Referral kodu qəbul edildi — dəvət edənə mükafat verildi'
end)

print('[vr_referral] Referral sistemi aktivdir.')
