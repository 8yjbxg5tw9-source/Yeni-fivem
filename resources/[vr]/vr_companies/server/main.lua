-- ============================================================
-- vr_companies — Server: şirkət idarəetməsi
-- ============================================================

local config = lib.require('config.shared')

-- === Şirkət yarat ===
lib.callback.register('vr:companies:create', function(source, name, companyType)
    local player = qbx.getPlayer(source)
    if not player then return false, 'Oyuncu tapılmadı' end

    -- Biznes lisenziyası tələbi (Vətəndaş+ səviyyə)
    local level = exports.vr_whitelist:getLevel(player.PlayerData.citizenid)
    if level == 'temporary' then return false, 'Müvəqqəti vətəndaşlar şirkət aça bilməz' end

    local registryNo = ('REG-%s'):format(math.random(100000, 999999))
    MySQL.insert.await('INSERT INTO vr_companies (name, type, owner, registry_no) VALUES (?, ?, ?, ?)',
        { name, companyType, player.PlayerData.citizenid, registryNo })

    -- Reyestr kitabına yaz
    local companyId = MySQL.scalar.await('SELECT id FROM vr_companies WHERE registry_no = ?', { registryNo })
    MySQL.insert.await('INSERT INTO vr_company_registry (company_id, entry_type, details) VALUES (?, ?, ?)',
        { companyId, 'founded', 'Şirkət təsis edildi' })
    return true, registryNo
end)

-- === İşçi götür ===
lib.callback.register('vr:companies:hire', function(source, companyId, targetCitizenid, role, salary)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local company = MySQL.single.await('SELECT * FROM vr_companies WHERE id = ?', { companyId })
    if not company then return false end
    if company.owner ~= player.PlayerData.citizenid then return false, 'Yalnız sahib işçi götürə bilər' end

    MySQL.insert.await('INSERT INTO vr_company_employees (company_id, citizenid, role, salary) VALUES (?, ?, ?, ?)',
        { companyId, targetCitizenid, role or 'employee', salary or 0 })
    return true
end)

-- === Maaş ödəmə (bütün işçilərə) ===
exports('payCompanySalaries', function(companyId)
    local employees = MySQL.query.await('SELECT * FROM vr_company_employees WHERE company_id = ?', { companyId })
    for _, emp in ipairs(employees) do
        if emp.salary and emp.salary > 0 then
            -- Bank hesabına köçür (vr_banking — DB əsaslı, offline dəstəkli)
            exports.vr_banking:addBankMoney(emp.citizenid, emp.salary, 'şirkət-maaş-' .. tostring(companyId))
        end
    end
    return true
end)

-- === Stok idarəetməsi ===
lib.callback.register('vr:companies:addStock', function(source, companyId, item, amount)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local company = MySQL.single.await('SELECT * FROM vr_companies WHERE id = ?', { companyId })
    if not company or company.owner ~= player.PlayerData.citizenid then return false end

    MySQL.update.await(
        'INSERT INTO vr_company_stock (company_id, item, amount) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE amount = amount + VALUES(amount)',
        { companyId, item, amount })
    return true
end)

-- === Peşə zənciri yoxlaması (KİLİDLİ təchizat) ===
exports('hasSupply', function(companyType, item)
    local chain = config.SupplyChains[companyType]
    if not chain then return true end -- zəncirsiz şirkət azaddır
    -- Təchizatçının stoku var?
    local stock = MySQL.single.await(
        'SELECT SUM(s.amount) as total FROM vr_company_stock s JOIN vr_companies c ON c.id = s.company_id WHERE c.type = ? AND s.item = ?',
        { chain.needs, chain.item }
    )
    return (stock and stock.total and stock.total > 0) or false
end)

-- === Səhm satışı (şirkət sahibi) ===
lib.callback.register('vr:companies:sellShares', function(source, companyId, symbol, shares, price)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local company = MySQL.single.await('SELECT * FROM vr_companies WHERE id = ?', { companyId })
    if not company or company.owner ~= player.PlayerData.citizenid then return false end

    exports.vr_economy:listCompany(source, companyId, symbol, price, shares)
    MySQL.insert.await('INSERT INTO vr_company_registry (company_id, entry_type, details) VALUES (?, ?, ?)',
        { companyId, 'stock_sale', ('Səhm satışı: %s (%s ədəd)'):format(symbol, shares) })
    return true
end)

-- === Şirkət məlumatı ===
lib.callback.register('vr:companies:getInfo', function(source, companyId)
    local company = MySQL.single.await('SELECT * FROM vr_companies WHERE id = ?', { companyId })
    if not company then return nil end
    local employees = MySQL.query.await('SELECT * FROM vr_company_employees WHERE company_id = ?', { companyId })
    local stock = MySQL.query.await('SELECT * FROM vr_company_stock WHERE company_id = ?', { companyId })
    return { company = company, employees = employees, stock = stock }
end)

print('[vr_companies] Şirkət sistemi aktivdir.')
