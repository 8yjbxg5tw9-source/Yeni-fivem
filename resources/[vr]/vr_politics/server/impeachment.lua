-- ============================================================
-- vr_politics — İmpichment mexanizmi
-- ============================================================

-- === İmpichment işi aç ===
lib.callback.register('vr:politics:fileImpeachment', function(source, official, charge)
    local player = qbx.getPlayer(source)
    if not player then return false end
    MySQL.insert.await('INSERT INTO vr_impeachments (official, charge, filed_by) VALUES (?, ?, ?)',
        { official, charge, player.PlayerData.citizenid })
    return true
end)

-- === Səs ver (Parlament üzvləri) ===
lib.callback.register('vr:politics:voteImpeachment', function(source, impeachmentId, vote)
    local player = qbx.getPlayer(source)
    if not player then return false end
    if vote then
        MySQL.update.await('UPDATE vr_impeachments SET votes_for = votes_for + 1 WHERE id = ?', { impeachmentId })
    else
        MySQL.update.await('UPDATE vr_impeachments SET votes_against = votes_against + 1 WHERE id = ?', { impeachmentId })
    end
    return true
end)

-- === Nəticəni yekunlaşdır ===
lib.callback.register('vr:politics:concludeImpeachment', function(source, impeachmentId)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local imp = MySQL.single.await('SELECT * FROM vr_impeachments WHERE id = ?', { impeachmentId })
    if not imp then return false end

    local status = imp.votes_for > imp.votes_against and 'removed' or 'acquitted'
    MySQL.update.await('UPDATE vr_impeachments SET status = ? WHERE id = ?', { status, impeachmentId })
    return true, status
end)

print('[vr_politics] İmpichment sistemi aktivdir.')
