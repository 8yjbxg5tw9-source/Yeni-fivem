-- ============================================================
-- vr_economy — Dövlət Büdcəsi və Xəzinə
-- vergilər xəzinəyə axır → maaşlar fondan ödənilir
-- ============================================================

local config = lib.require('config.shared')

-- === Büdcəni işə sal (ilk açılışda) ===
local function ensureBudget()
    for key, cat in pairs(config.BudgetCategories) do
        local existing = MySQL.single.await('SELECT * FROM vr_budget WHERE category = ?', { key })
        if not existing then
            MySQL.insert.await('INSERT INTO vr_budget (category, allocation) VALUES (?, ?)', { key, cat.baseAllocation })
        end
    end
end
ensureBudget()

-- === Büdcəni oxu ===
lib.callback.register('vr:economy:getBudget', function(source)
    return MySQL.query.await('SELECT * FROM vr_budget')
end)

-- === Büdcəyə vəsait ayır (Parlament / yüksək icazə) ===
lib.callback.register('vr:economy:allocateBudget', function(source, category, amount)
    if not exports.vr_admin:hasPermission(source, 'give_money') then return false end
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return false end
    MySQL.update.await('UPDATE vr_budget SET allocation = allocation + ? WHERE category = ?', { amount, category })
    exports.vr_admin:audit('budget_allocate', source, category, amount)
    return true
end)

-- === Xəzinə balansı (vergi yığımı) ===
exports('getTreasuryBalance', function()
    local rows = MySQL.query.await('SELECT SUM(amount) as total FROM vr_treasury')
    return rows[1] and rows[1].total or 0
end)

lib.callback.register('vr:economy:getTreasury', function(source)
    return exports.vr_economy:getTreasuryBalance()
end)

-- === Maaş fondu hesablanması (vergi gəlirinə bağlı) ===
-- Həftəlik işləyir: vergi base-dən aşağıdırsa maaşlar mütənasib kəsilir
local function paySalaries()
    local totalTax = MySQL.scalar.await('SELECT SUM(amount) FROM vr_treasury') or 0
    local baseTotal = 0
    for _, cat in pairs(config.BudgetCategories) do
        baseTotal = baseTotal + cat.baseAllocation
    end

    local ratio = 1.0
    if baseTotal > 0 and totalTax < (baseTotal * config.SalaryThreshold) then
        ratio = totalTax / baseTotal -- maaşlar vergi gəlirinə görə azalır
        ratio = math.max(0.3, ratio) -- amma heç vaxt 30%-dən aşağı düşmür
    end

    for key, cat in pairs(config.BudgetCategories) do
        local allocation = MySQL.scalar.await('SELECT allocation FROM vr_budget WHERE category = ?', { key }) or cat.baseAllocation
        local payout = math.floor(allocation * ratio)
        MySQL.update.await('UPDATE vr_budget SET spent = spent + ? WHERE category = ?', { payout, key })
        -- Burada həmin kateqoriyadakı işçilərə maaş ödənir (vr_companies ilə)
        TriggerEvent('vr:economy:salaryPaid', key, payout, ratio)
    end
    return ratio
end

-- Həftəlik maaş dövrü (real istehsalda cron ilə)
CreateThread(function()
    while true do
        Wait(7 * 24 * 60 * 60 * 1000)
        paySalaries()
    end
end)

exports('paySalaries', paySalaries)

print('[vr_economy] Dövlət büdcəsi aktivdir.')
