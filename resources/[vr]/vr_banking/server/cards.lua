-- ============================================================
-- vr_banking — Debet kartı, KYC, kart dublikatı fırıldağı
-- ============================================================

-- === Debet kartı ver ===
lib.callback.register('vr:banking:issueCard', function(source, pin)
    local player = qbx.getPlayer(source)
    if not player then return false end

    local account = exports.vr_banking:getAccount(player.PlayerData.citizenid)
    if not account then return false end

    -- PIN hash-lənir (real istehsalda bcrypt)
    local pinHash = ('PIN:%s'):format(pin)
    local cardNo = ('CAR-%s'):format(math.random(1000000000000000, 9999999999999999))

    MySQL.insert.await('INSERT INTO vr_debit_cards (account_id, card_no, pin) VALUES (?, ?, ?)',
        { account.id, cardNo, pinHash })
    return true, cardNo
end)

-- === Kartla ödəniş ===
lib.callback.register('vr:banking:cardPayment', function(source, cardNo, pin, amount)
    local player = qbx.getPlayer(source)
    if not player then return false end
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return false end

    local card = MySQL.single.await('SELECT * FROM vr_debit_cards WHERE card_no = ? AND active = 1', { cardNo })
    if not card then return false, 'Kart tapılmadı və ya bloklanıb' end

    -- PIN yoxlaması
    if card.pin ~= ('PIN:' .. pin) then return false, 'Yanlış PIN' end

    -- Kart dublikatı fırıldağı aşkarlanması
    if card.duplicate_flag then
        return false, 'Şübhəli kart — fırıldaq araşdırması başladıldı'
    end

    -- Hesabdan ödəniş
    local account = MySQL.single.await('SELECT * FROM vr_accounts WHERE id = ?', { card.account_id })
    if not account or account.balance < amount then return false, 'Kifayət qədər balans yoxdur' end

    MySQL.update.await('UPDATE vr_accounts SET balance = balance - ? WHERE id = ?', { amount, account.id })
    MySQL.insert.await('INSERT INTO vr_transactions (account_id, type, amount, note) VALUES (?, ?, ?, ?)',
        { account.id, 'card_payment', -amount, 'Debet kartı ödənişi' })
    return true
end)

-- === Kart dublikatı fırıldağı aşkarlanması ===
exports('flagDuplicateCard', function(cardNo)
    MySQL.update.await('UPDATE vr_debit_cards SET duplicate_flag = 1 WHERE card_no = ?', { cardNo })
    return true
end)

-- === KYC statusu ===
lib.callback.register('vr:banking:kycStatus', function(source)
    local player = qbx.getPlayer(source)
    if not player then return nil end
    local char = exports.vr_identity:getCharBySource(source)
    if not char then return nil end
    local profile = MySQL.single.await('SELECT kyc_status, credit_score FROM vr_profile WHERE char_id = ?', { char.id })
    return profile
end)

-- === KYC təsdiqi (böyük köçürmələr üçün) ===
exports('isKYCVerified', function(source)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local char = exports.vr_identity:getCharBySource(source)
    if not char then return false end
    local profile = MySQL.single.await('SELECT kyc_status FROM vr_profile WHERE char_id = ?', { char.id })
    return profile and profile.kyc_status == 'verified'
end)

print('[vr_banking] Debet kart və KYC sistemi aktivdir.')
