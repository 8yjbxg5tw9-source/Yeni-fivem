-- ============================================================
-- vr_economy — Dinamik Qiymətlər və İnflyasiya Monitorinqi
-- ============================================================

-- === Əşya qiymətini oxu (dinamik) ===
exports('getPrice', function(item)
    local row = MySQL.single.await('SELECT price FROM vr_prices WHERE item = ?', { item })
    return row and row.price or nil
end)

-- === Qiymət təyin et (təchizat-tələb) ===
exports('setPrice', function(item, price)
    MySQL.update.await('INSERT INTO vr_prices (item, price) VALUES (?, ?) ON DUPLICATE KEY UPDATE price = VALUES(price)',
        { item, price })
    return true
end)

-- === Yanacaq qiyməti (dinamik, liman/idxal ilə bağlı) ===
lib.callback.register('vr:economy:getFuelPrice', function(source)
    local fuel = MySQL.single.await("SELECT price FROM vr_prices WHERE item = 'fuel'")
    return fuel and fuel.price or 5.0 -- standart S₺/litr
end)

-- === Fırtına limanı bağlayır → idxal bahalaşır ===
RegisterNetEvent('vr:weather:storm', function()
    -- İdxal mallarının qiymətlərini artır
    MySQL.update.await("UPDATE vr_prices SET price = price * 1.3 WHERE item IN ('import_food','import_medicine','import_parts')")
end)

-- === İnflyasiya monitorinqi (7 günlük) ===
local function logInflation()
    local rows = MySQL.query.await('SELECT AVG(price) as avg_price FROM vr_prices')
    local avg = rows[1] and rows[1].avg_price or 0
    MySQL.insert.await('INSERT INTO vr_inflation_log (day, avg_price_index) VALUES (?, ?)',
        { os.date('%Y-%m-%d'), avg })
end

-- Hər 24 saatda qeyd et
CreateThread(function()
    while true do
        Wait(24 * 60 * 60 * 1000)
        logInflation()
    end
end)

-- === İnflyasiya hesabatı (admin dashboard / veb) ===
lib.callback.register('vr:economy:getInflation', function(source)
    return MySQL.query.await('SELECT * FROM vr_inflation_log ORDER BY day DESC LIMIT 7')
end)

print('[vr_economy] Dinamik qiymətlər və inflyasiya monitorinqi aktivdir.')
