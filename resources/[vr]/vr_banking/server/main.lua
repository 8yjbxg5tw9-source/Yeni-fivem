-- ============================================================
-- vr_banking — Server: hesab, köçürmə, depozit, faiz
-- Secure Your Events: bütün əməliyyatlar server-side yoxlanılır
-- ============================================================

local config = lib.require('config.shared')

-- === Hesab nömrəsi yarat (Velmora IBAN analoqu) ===
local function generateAccountNo()
    return 'VL' .. math.random(10 ^ 11, 10 ^ 12 - 1)
end

-- === Oyunçunun hesabını tap/yarat ===
local function getAccount(citizenid)
    local account = MySQL.single.await('SELECT * FROM vr_accounts WHERE owner = ? AND type = ?', { citizenid, 'personal' })
    if not account then
        local accountNo = generateAccountNo()
        MySQL.insert.await('INSERT INTO vr_accounts (type, owner, account_no) VALUES (?, ?, ?)',
            { 'personal', citizenid, accountNo })
        account = MySQL.single.await('SELECT * FROM vr_accounts WHERE account_no = ?', { accountNo })
    end
    return account
end

exports('getAccount', getAccount)

-- === Balansı oxu ===
exports('getBalance', function(citizenid)
    local account = getAccount(citizenid)
    return account and account.balance or 0
end)

-- === Balans callback (bank app üçün) ===
lib.callback.register('vr:banking:getBalance', function(source)
    local player = qbx.getPlayer(source)
    if not player then return nil end
    return getBalance(player.PlayerData.citizenid)
end)

-- === Köçürmə (server-side yoxlama) ===
lib.callback.register('vr:banking:transfer', function(source, target, amount, note)
    local player = qbx.getPlayer(source)
    if not player then return false, 'Oyuncu tapılmadı' end
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return false, 'Məbləğ müsbət olmalıdır' end
    if amount > config.MaxTransfer then return false, 'Məbləğ limitdən yüksəkdir' end
    if target == nil then return false, 'Hədəf hesab tapılmadı' end

    local from = getAccount(player.PlayerData.citizenid)
    if from.balance < amount then return false, 'Kifayət qədər pul yoxdur' end

    local to = MySQL.single.await('SELECT * FROM vr_accounts WHERE account_no = ?', { target })
    if not to then return false, 'Hədəf hesab tapılmadı' end

    -- Debitor
    MySQL.update.await('UPDATE vr_accounts SET balance = balance - ? WHERE id = ?', { amount, from.id })
    MySQL.insert.await('INSERT INTO vr_transactions (account_id, type, amount, counterparty, note) VALUES (?, ?, ?, ?, ?)',
        { from.id, 'transfer', -amount, to.account_no, note })

    -- Kreditor
    MySQL.update.await('UPDATE vr_accounts SET balance = balance + ? WHERE id = ?', { amount, to.id })
    MySQL.insert.await('INSERT INTO vr_transactions (account_id, type, amount, counterparty, note) VALUES (?, ?, ?, ?, ?)',
        { to.id, 'transfer', amount, from.account_no, note })

    -- Böyük köçürmə bildirişi (anti-metagaming)
    if amount >= config.LargeTransferNotify then
        exports.vr_admin:audit('bank_large_transfer', source, target, amount)
    end

    return true, 'Köçürmə uğurla tamamlandı'
end)

-- === Depozit / Çıxarma (cash <-> bank) ===
lib.callback.register('vr:banking:deposit', function(source, amount)
    local player = qbx.getPlayer(source)
    if not player then return false end
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return false end
    local cash = player.PlayerData.money.cash or 0
    if cash < amount then return false end
    player.Functions.RemoveMoney('cash', amount, 'bank-depozit')
    player.Functions.AddMoney('bank', amount, 'bank-depozit')
    return true
end)

lib.callback.register('vr:banking:withdraw', function(source, amount)
    local player = qbx.getPlayer(source)
    if not player then return false end
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return false end
    local bank = player.PlayerData.money.bank or 0
    if bank < amount then return false end
    player.Functions.RemoveMoney('bank', amount, 'bank-çıxarış')
    player.Functions.AddMoney('cash', amount, 'bank-çıxarış')
    return true
end)

-- === Əmanət faizi (periodik) ===
-- Sadə dövri hesablama: hər server restartına əsasən simulyasiya
-- İstehsalda cron/loop ilə (məs. gündəlik) işlədilir
local function applyInterest()
    local accounts = MySQL.query.await('SELECT * FROM vr_accounts WHERE balance > 0')
    for _, acc in ipairs(accounts) do
        local interest = math.floor(acc.balance * (config.InterestRate / 365))
        if interest > 0 then
            MySQL.update.await('UPDATE vr_accounts SET balance = balance + ? WHERE id = ?', { interest, acc.id })
            MySQL.insert.await('INSERT INTO vr_transactions (account_id, type, amount, note) VALUES (?, ?, ?, ?)',
                { acc.id, 'interest', interest, 'günlük əmanət faizi' })
        end
    end
end

-- Nümunə: hər 24 saatda faiz (real dəyər istehsalda tənzimlənir)
CreateThread(function()
    while true do
        Wait(24 * 60 * 60 * 1000)
        applyInterest()
    end
end)

print('[vr_banking] 196RP — Bank sistemi aktivdir.')
