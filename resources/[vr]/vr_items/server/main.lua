-- ============================================================
-- vr_items — Server: əşya metadata helperləri
-- ox_inventory metadata-si ilə inteqrasiya
-- ============================================================

local config = lib.require('config.shared')

-- === Seriya № yarat (istehsal zamanı) ===
local function generateSerial(prefix)
    prefix = prefix or 'VR'
    return ('%s-%s'):format(prefix, math.random(100000000, 999999999))
end
exports('generateSerial', generateSerial)

-- === Əşyaya metadata əlavə et ===
---@param source any oyunçu
---@param itemName string əşya adı
---@param metadata table metadata cədvəli
exports('addItemWithMetadata', function(source, itemName, amount, metadata)
    local player = qbx.getPlayer(source)
    if not player then return false end
    metadata = metadata or {}
    metadata.serial = metadata.serial or generateSerial(itemName:sub(1, 2):upper())
    metadata.owner = metadata.owner or player.PlayerData.citizenid
    metadata.quality = metadata.quality or 100
    metadata.durability = metadata.durability or 100
    metadata.producedAt = metadata.producedAt or os.time()
    return exports.ox_inventory:AddItem(source, itemName, amount, metadata)
end)

-- === Durability-ni azalt (istifadə zamanı) ===
exports('decreaseDurability', function(source, itemName, slot, amount)
    amount = amount or 10
    local item = exports.ox_inventory:GetItem(source, itemName, nil, true)
    if not item then return false end
    local metadata = item.metadata or {}
    local durability = math.max(0, (metadata.durability or 100) - amount)
    metadata.durability = durability
    if item.slot then
        exports.ox_inventory:SetMetadata(source, item.slot, metadata)
    end
    return durability > 0
end)

-- === Oğurluq əşyasını "hot item" kimi qeyd et ===
exports('markHotItem', function(source, itemName, serial, cooldownMinutes)
    MySQL.insert.await(
        'INSERT INTO vr_hot_items (item, serial, stolen_by, cool_down_at) VALUES (?, ?, ?, ?)',
        { itemName, serial, source, os.date('%Y-%m-%d %H:%M:%S', os.time() + (cooldownMinutes * 60)) }
    )
    return true
end)

-- === Əşya "istilik" müddətini yoxla (satış zamanı) ===
exports('isHot', function(itemName, serial)
    local row = MySQL.single.await(
        'SELECT * FROM vr_hot_items WHERE item = ? AND serial = ? AND sold = 0 AND cool_down_at > NOW()',
        { itemName, serial }
    )
    return row ~= nil
end)

print('[vr_items] 196RP — Əşya metadata sistemi aktivdir.')
