-- ============================================================
-- vr_criminal — Liman qaçaqmalçılığı (gömrük yoxlaması ilə sinxron)
-- ============================================================

-- === Konteyner qaçaqmalçılığı ===
lib.callback.register('vr:criminal:smuggle', function(source, containerId, itemType)
    local player = qbx.getPlayer(source)
    if not player then return false end

    -- Gömrük yoxlaması riski (təsadüfi)
    local customsCheck = math.random(1, 100) <= 30 -- 30% yoxlama şansı
    if customsCheck then
        -- Yoxlama aşkarlandı → polis/gömrük xəbərdar
        MySQL.insert.await('INSERT INTO vr_mdt_records (record_type, title, body) VALUES (?, ?, ?)',
            { 'report', 'Qaçaqmalçılıq şübhəsi', ('Konteyner: %s | Əşya: %s'):format(containerId, itemType) })
        exports.vr_admin:audit('smuggle_caught', source, containerId, itemType)
        return false, 'Gömrük yoxlaması əməliyyatı aşkarladı!'
    end

    -- Uğurlu qaçaqmalçılıq
    exports.ox_inventory:AddItem(source, itemType, 1)
    return true, 'Konteyner uğurla boşaldıldı'
end)

-- === Qaçaq mal idxalı (gömrük rüsumundan yayınma) ===
lib.callback.register('vr:criminal:smuggleImport', function(source, itemType, quantity)
    local player = qbx.getPlayer(source)
    if not player then return false end
    quantity = math.floor(tonumber(quantity) or 0)
    if quantity <= 0 then return false end

    -- Gömrük rüsumundan yayınma riski
    local caught = math.random(1, 100) <= 20 -- 20% risk
    if caught then
        return false, 'Gömrük rüsumu ödəmədiyiniz aşkarlandı — cərimə + əşya müsadirəsi'
    end

    exports.ox_inventory:AddItem(source, itemType, quantity)
    return true
end)

print('[vr_criminal] Qaçaqmalçılıq sistemi aktivdir.')
