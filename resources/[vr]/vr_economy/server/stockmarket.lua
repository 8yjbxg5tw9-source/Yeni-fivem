-- ============================================================
-- vr_economy — Velmora Birjası
-- səhmlər real əməliyyatlarla dalğalanır, dividend, çökmə
-- ============================================================

-- === Səhm siyahısı (şirkət qeydiyyatı ilə sinxron) ===
lib.callback.register('vr:economy:getStocks', function(source)
    return MySQL.query.await('SELECT * FROM vr_stocks')
end)

-- === Şirkəti birjaya çıxar (IPO) ===
exports('listCompany', function(source, companyId, symbol, initialPrice, totalShares)
    MySQL.insert.await('INSERT INTO vr_stocks (symbol, company_id, price, total_shares) VALUES (?, ?, ?, ?)',
        { symbol, companyId, initialPrice, totalShares })
    return true
end)

-- === Səhm al ===
lib.callback.register('vr:economy:buyShares', function(source, symbol, quantity)
    local player = qbx.getPlayer(source)
    if not player then return false, 'Oyuncu tapılmadı' end
    quantity = math.floor(tonumber(quantity) or 0)
    if quantity <= 0 then return false, 'Miqdar müsbət olmalıdır' end

    local stock = MySQL.single.await('SELECT * FROM vr_stocks WHERE symbol = ?', { symbol })
    if not stock then return false, 'Səhm tapılmadı' end

    local cost = math.floor(stock.price * quantity)
    if not exports.vr_banking:removeBankMoney(player.PlayerData.citizenid, cost, 'birja-alis') then
        return false, 'Kifayət qədər pul yoxdur'
    end

    -- Portfelə əlavə
    local holding = MySQL.single.await('SELECT * FROM vr_stock_holdings WHERE citizenid = ? AND symbol = ?',
        { player.PlayerData.citizenid, symbol })
    if holding then
        MySQL.update.await('UPDATE vr_stock_holdings SET shares = shares + ? WHERE id = ?', { quantity, holding.id })
    else
        MySQL.insert.await('INSERT INTO vr_stock_holdings (citizenid, symbol, shares) VALUES (?, ?, ?)',
            { player.PlayerData.citizenid, symbol, quantity })
    end

    -- Tələb artdıqca qiymət yüksəlir (real əməliyyatlarla dalğalanma)
    MySQL.update.await('UPDATE vr_stocks SET price = price * 1.01 WHERE symbol = ?', { symbol })
    return true, 'Səhm alındı'
end)

-- === Səhm sat ===
lib.callback.register('vr:economy:sellShares', function(source, symbol, quantity)
    local player = qbx.getPlayer(source)
    if not player then return false end
    quantity = math.floor(tonumber(quantity) or 0)
    if quantity <= 0 then return false end

    local holding = MySQL.single.await('SELECT * FROM vr_stock_holdings WHERE citizenid = ? AND symbol = ?',
        { player.PlayerData.citizenid, symbol })
    if not holding or holding.shares < quantity then return false, 'Kifayət qədər səhminiz yoxdur' end

    local stock = MySQL.single.await('SELECT * FROM vr_stocks WHERE symbol = ?', { symbol })
    local proceeds = math.floor(stock.price * quantity)

    MySQL.update.await('UPDATE vr_stock_holdings SET shares = shares - ? WHERE id = ?', { quantity, holding.id })
    exports.vr_banking:addBankMoney(player.PlayerData.citizenid, proceeds, 'birja-satis')

    -- Təklif artdıqca qiymət düşür
    MySQL.update.await('UPDATE vr_stocks SET price = price * 0.99 WHERE symbol = ?', { symbol })
    return true, 'Səhm satıldı'
end)

-- === Dividend ödənişi (dövri) ===
local function payDividends()
    local stocks = MySQL.query.await('SELECT * FROM vr_stocks WHERE company_id IS NOT NULL')
    for _, stock in ipairs(stocks) do
        local dividend = math.floor(stock.price * 0.02) -- 2% dividend
        if dividend > 0 then
            local holders = MySQL.query.await('SELECT * FROM vr_stock_holdings WHERE symbol = ?', { stock.symbol })
            for _, h in ipairs(holders) do
                local payout = math.floor(dividend * h.shares)
                if payout > 0 then
                    -- Hesaba köçür (vr_banking ilə)
                    TriggerEvent('vr:economy:dividend', h.citizenid, payout, stock.symbol)
                end
            end
        end
    end
end

-- Dividend ödənişini qəbul et (pay sahibinin bankına köçür — vr_accounts)
RegisterNetEvent('vr:economy:dividend', function(citizenid, amount, symbol)
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return end
    exports.vr_banking:addBankMoney(citizenid, amount, 'birja-dividend-' .. tostring(symbol))
end)

-- Dividendləri dövri ödə (hər 24 saat)
CreateThread(function()
    while true do
        Wait(24 * 60 * 60 * 1000)
        payDividends()
    end
end)

-- === Çökmə mexanikası (birja təsadüfi volatillik) ===
CreateThread(function()
    while true do
        Wait(60 * 60 * 1000) -- hər saat
        local stocks = MySQL.query.await('SELECT * FROM vr_stocks')
        for _, stock in ipairs(stocks) do
            local change = (math.random() - 0.5) * 0.04 -- ±2% volatillik
            MySQL.update.await('UPDATE vr_stocks SET price = GREATEST(1, price * (1 + ?)) WHERE id = ?', { change, stock.id })
        end
    end
end)

print('[vr_economy] Velmora Birjası aktivdir.')
