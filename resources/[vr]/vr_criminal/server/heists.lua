-- ============================================================
-- vr_criminal — Soyğun sistemi (pilləli, reputasiya kilidi, minigame)
-- ============================================================

local config = lib.require('config.shared')

-- === Soyğuna başla ===
lib.callback.register('vr:criminal:startHeist', function(source, tierId, gangId)
    local player = qbx.getPlayer(source)
    if not player then return false, 'Oyuncu tapılmadı' end

    -- Pilləni tap
    local tier
    for _, t in ipairs(config.HeistTiers) do
        if t.id == tierId then tier = t break end
    end
    if not tier then return false, 'Soyğun pilləsi tapılmadı' end

    -- Reputasiya kilidi (əvvəlki pillə tələb olunur)
    local gang = MySQL.single.await('SELECT * FROM vr_gangs WHERE id = ?', { gangId })
    if not gang then return false, 'Dəstə tapılmadı' end
    if gang.reputation < tier.minRep then
        return false, ('Bu soyğun üçün ən azı %d reputasiya xalı lazımdır'):format(tier.minRep)
    end

    -- Hazırlıq RP-si: avadanlıq yoxlaması (lockpick/hack/termit)
    local hasEquipment = exports.ox_inventory:GetItem(source, 'lockpick', {}, false) ~= nil
    if not hasEquipment then
        return false, 'Soyğun üçün avadanlıq (lockpick) lazımdır'
    end

    -- Uğur şansı (minigame nəticəsi ilə — client tərəfdə oynanır)
    local reward = math.random(tier.rewardMin, tier.rewardMax)
    return true, reward
end)

-- === Soyğun uğurlu → reputasiya + qənimət ===
lib.callback.register('vr:criminal:completeHeist', function(source, tierId, gangId)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local tier
    for _, t in ipairs(config.HeistTiers) do
        if t.id == tierId then tier = t break end
    end
    if not tier then return false end

    local reward = math.random(tier.rewardMin, tier.rewardMax)

    -- Qənimət: "hot items" (istilik müddəti — dərhal satıla bilmir)
    exports.vr_items:markHotItem(source, 'cash_bag', tostring(os.time()), 60) -- 60 dəq istilik

    -- Reputasiya artır
    exports.vr_criminal:addReputation(gangId, 1)

    -- İqtisadi anomaliya detektoru üçün qeyd
    exports.vr_admin:audit('heist_success', source, tierId, reward)

    return true, reward
end)

-- === Soyğun uğursuz (polis xəbərdar) ===
lib.callback.register('vr:criminal:failHeist', function(source, tierId)
    -- Polisə avtomatik bildiriş (MDT insident)
    MySQL.insert.await('INSERT INTO vr_mdt_records (record_type, title, body) VALUES (?, ?, ?)',
        { 'report', 'Soyğun cəhdi', ('Soyğun cəhdi: %s'):format(tierId) })
    TriggerClientEvent('vr:police:panicAlert', -1, {
        officer = 'DISPATCHER',
        coords = { x = 0, y = 0, z = 0 },
        message = 'SOYĞUN CƏHDİ AŞKARLANDI: ' .. tierId,
    })
    return true
end)

print('[vr_criminal] Soyğun sistemi aktivdir.')
