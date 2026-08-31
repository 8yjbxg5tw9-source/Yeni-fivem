-- ============================================================
-- vr_politics — Dövlət satınalmaları tenderləri (korrupsiya risk-zonası)
-- ============================================================

-- === Tender aç ===
lib.callback.register('vr:politics:createTender', function(source, title, budget, deadline)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local job = player.PlayerData.job and player.PlayerData.job.name or ''
    local allowed = { government = true, municipality = true, transport = true }
    if not allowed[job] then return false, 'Yalnız dövlət qurumu tender aça bilər' end

    MySQL.insert.await('INSERT INTO vr_tenders (title, agency, budget, deadline) VALUES (?, ?, ?, ?)',
        { title, job, budget, deadline })
    return true
end)

-- === Tenderə təklif ver ===
lib.callback.register('vr:politics:bidTender', function(source, tenderId, amount)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local tender = MySQL.single.await('SELECT * FROM vr_tenders WHERE id = ? AND status = ?', { tenderId, 'open' })
    if not tender then return false, 'Tender açıq deyil' end

    MySQL.insert.await('INSERT INTO vr_tender_bids (tender_id, bidder, amount) VALUES (?, ?, ?)',
        { tenderId, player.PlayerData.citizenid, amount })
    return true
end)

-- === Tenderi bağla (Daxili Nəzarət izləyir) ===
lib.callback.register('vr:politics:awardTender', function(source, tenderId, winnerBidId)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local job = player.PlayerData.job and player.PlayerData.job.name or ''
    if job ~= 'internal' and job ~= 'government' then return false, 'Yalnız Daxili Nəzarət/qurum təsdiqləyə bilər' end

    local bid = MySQL.single.await('SELECT * FROM vr_tender_bids WHERE id = ?', { winnerBidId })
    if not bid then return false end

    MySQL.update.await('UPDATE vr_tenders SET status = ?, winner = ? WHERE id = ?', { 'awarded', bid.bidder, tenderId })

    -- Korrupsiya risk-zonası: audit log
    exports.vr_admin:audit('tender_awarded', source, tenderId, { winner = bid.bidder, amount = bid.amount })
    return true
end)

print('[vr_politics] Tender sistemi aktivdir.')
