-- ============================================================
-- vr_phone — Sosial media (Kvatter) server tərəfi
-- ============================================================

-- === Post paylaş ===
lib.callback.register('vr:phone:postKvatter', function(source, body, image)
    local player = qbx.getPlayer(source)
    if not player then return false end
    if #body > 280 then return false, 'Maksimum 280 simvol' end
    MySQL.insert.await('INSERT INTO vr_social_posts (author, body, image) VALUES (?, ?, ?)',
        { player.PlayerData.citizenid, body, image })
    return true
end)

-- === Postları oxu (timeline) ===
lib.callback.register('vr:phone:getKvatter', function(source)
    return MySQL.query.await('SELECT * FROM vr_social_posts ORDER BY id DESC LIMIT 50')
end)

-- === Bəyən ===
lib.callback.register('vr:phone:likeKvatter', function(source, postId)
    MySQL.update.await('UPDATE vr_social_posts SET likes = likes + 1 WHERE id = ?', { postId })
    return true
end)

-- === Dark web (yalnız kriminal istifadəçilər üçün UI; server yalnız qeydiyyat aparır) ===
lib.callback.register('vr:phone:darkwebAccess', function(source)
    -- Sadə giriş; real qara bazar inteqrasiyası Addım 8-də
    return true
end)

print('[vr_phone] Kvatter sosial media aktivdir.')
