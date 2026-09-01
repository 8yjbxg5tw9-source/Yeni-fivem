-- ============================================================
-- vr_environment — Mədən (partlayış təhlükəsizliyi, əridilmə, qaçaq hasilat)
-- ============================================================

local config = lib.require('config.shared')

-- === Filiz çıxar ===
lib.callback.register('vr:environment:mine', function(source, mineralId)
    local player = qbx.getPlayer(source)
    if not player then return false end

    local mineral
    for _, m in ipairs(config.Minerals) do
        if m.id == mineralId then mineral = m break end
    end
    if not mineral then return false, 'Mineral tapılmadı' end

    -- Partlayış təhlükəsizliyi riski
    local accident = math.random(1, 100) <= 5 -- 5% qəza riski
    if accident then
        exports.vr_ems:registerInjury(source, 'trauma', 3)
        return false, 'MADƏN QƏZASI! Yaralandınız'
    end

    exports.ox_inventory:AddItem(source, mineral.id .. '_ore', math.random(1, 3))
    return true
end)

-- === Əridilmə zavodu ===
lib.callback.register('vr:environment:smelt', function(source, mineralId, quantity)
    local player = qbx.getPlayer(source)
    if not player then return false end
    quantity = math.floor(tonumber(quantity) or 0)
    if quantity <= 0 then return false end

    local mineral
    for _, m in ipairs(config.Minerals) do
        if m.id == mineralId then mineral = m break end
    end
    if not mineral then return false end

    local has = exports.ox_inventory:GetItem(source, mineralId .. '_ore', {}, false)
    if not has or has.count < quantity then return false, 'Kifayət qədər filiz yoxdur' end

    exports.ox_inventory:RemoveItem(source, mineralId .. '_ore', quantity)
    exports.ox_inventory:AddItem(source, mineral.smeltTo, quantity)
    return true
end)

-- === Qaçaq hasilat (paralel xətt, risksiz lisenziya) ===
lib.callback.register('vr:environment:illegalMining', function(source, mineralId)
    local player = qbx.getPlayer(source)
    if not player then return false end

    -- mineralId server config-də təsdiqlənməlidir (client uydurma ID göndərə bilməz)
    local mineral
    for _, m in ipairs(config.Minerals) do
        if m.id == mineralId then mineral = m break end
    end
    if not mineral then return false, 'Mədən tapılmadı' end

    -- Yüksək aşkarlanma riski
    local caught = math.random(1, 100) <= 40
    if caught then
        local char = exports.vr_identity:getCharBySource(source)
        if char then
            MySQL.insert.await('INSERT INTO vr_fines (char_id, reason, amount) VALUES (?, ?, ?)',
                { char.id, 'Qaçaq hasilat', 20000 })
        end
        return false, 'Qaçaq hasilat aşkarlandı — cərimə!'
    end

    exports.ox_inventory:AddItem(source, mineralId .. '_ore', math.random(2, 5))
    return true
end)

print('[vr_environment] Mədən sistemi aktivdir.')
