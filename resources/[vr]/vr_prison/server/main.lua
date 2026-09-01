-- ============================================================
-- vr_prison — Server: həbs, içəri iqtisadiyyat, parole, bail, konvoy
-- ============================================================

local config = lib.require('config.shared')

-- === Həbs et (polisdən) ===
exports('incarcerate', function(source, charId, sentenceMinutes)
    MySQL.insert.await('INSERT INTO vr_prisoners (char_id, sentence_minutes, status) VALUES (?, ?, ?)',
        { charId, sentenceMinutes, 'incarcerated' })
    return true
end)

-- === Cəza vaxtı (dövri azalma) ===
CreateThread(function()
    while true do
        Wait(60 * 1000) -- hər dəqiqə
        local prisoners = MySQL.query.await("SELECT * FROM vr_prisoners WHERE status = 'incarcerated'")
        for _, p in ipairs(prisoners) do
            local served = p.served_minutes + 1
            local status = p.status
            if served >= p.sentence_minutes then
                status = 'released'
            end
            MySQL.update.await('UPDATE vr_prisoners SET served_minutes = ?, status = ? WHERE id = ?',
                { served, status, p.id })
        end
    end
end)

-- === Emalatxana/mətbəx işi → cəza azalması ===
lib.callback.register('vr:prison:work', function(source)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local char = exports.vr_identity:getCharBySource(source)
    if not char then return false end
    local prisoner = MySQL.single.await(
        "SELECT * FROM vr_prisoners WHERE char_id = ? AND status = 'incarcerated'", { char.id })
    if not prisoner then return false, 'Həbsdə deyilsiniz' end

    -- İş işləmək cəzanı azaldır
    MySQL.update.await('UPDATE vr_prisoners SET sentence_minutes = GREATEST(0, sentence_minutes - ?), work_credit = work_credit + 1 WHERE id = ?',
        { config.WorkReduction, prisoner.id })
    return true
end)

-- === Şərti azadlıq (parole) ===
lib.callback.register('vr:prison:requestParole', function(source)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local char = exports.vr_identity:getCharBySource(source)
    if not char then return false end
    local prisoner = MySQL.single.await(
        "SELECT * FROM vr_prisoners WHERE char_id = ? AND status = 'incarcerated'", { char.id })
    if not prisoner then return false end

    local servedRatio = prisoner.served_minutes / prisoner.sentence_minutes
    if servedRatio < config.ParoleEligibility then
        return false, 'Şərti azadlıq üçün cəzanın 60%-i çəkilməlidir'
    end

    MySQL.update.await("UPDATE vr_prisoners SET status = 'paroled', parole_eligible = 1 WHERE id = ?", { prisoner.id })
    return true, 'Şərti azadlıq verildi'
end)

-- === Şərti azadlıq pozuntusu → avtomatik geri qaytarılma ===
exports('violateParole', function(charId)
    MySQL.update.await("UPDATE vr_prisoners SET status = 'incarcerated' WHERE char_id = ? AND status = 'paroled'",
        { charId })
    return true
end)

-- === Girov (bail) ===
lib.callback.register('vr:prison:postBail', function(source, prisonerId, amount)
    local player = qbx.getPlayer(source)
    if not player then return false end
    amount = math.floor(tonumber(amount) or 0)
    if amount < config.Bail.min or amount > config.Bail.max then
        return false, 'Girov məbləği hədd xaricindədir'
    end
    local bank = exports.vr_banking:getBalance(player.PlayerData.citizenid)
    if bank < amount then return false, 'Kifayət qədər pul yoxdur' end

    exports.vr_banking:removeBankMoney(player.PlayerData.citizenid, amount, 'girov')
    MySQL.update.await('UPDATE vr_prisoners SET status = ?, bail = ? WHERE id = ?',
        { 'released', amount, prisonerId })
    return true
end)

-- === Konvoy əməliyyatı ===
lib.callback.register('vr:prison:createConvoy', function(source, prisonerId, fromLoc, toLoc)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local job = player.PlayerData.job and player.PlayerData.job.name or ''
    if job ~= 'police' then return false end

    MySQL.insert.await('INSERT INTO vr_convoys (prisoner_id, from_loc, to_loc, status) VALUES (?, ?, ?, ?)',
        { prisonerId, fromLoc, toLoc, 'planned' })
    return true
end)

print('[vr_prison] Həbsxana sistemi aktivdir.')
