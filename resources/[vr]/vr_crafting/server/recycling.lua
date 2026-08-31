-- ============================================================
-- vr_crafting — Resayklinq iqtisadiyyatı (zibil → məmulat)
-- ============================================================

local config = lib.require('config.shared')

-- === Resayklinq et ===
lib.callback.register('vr:crafting:recycle', function(source, inputItem)
    local player = qbx.getPlayer(source)
    if not player then return false end

    local mapping
    for _, m in ipairs(config.Recycling) do
        if m.input == inputItem then mapping = m break end
    end
    if not mapping then return false, 'Bu əşya resayklinq oluna bilməz' end

    local has = exports.ox_inventory:GetItem(source, inputItem, {}, false)
    if not has or has.count < mapping.ratio then
        return false, ('Resayklinq üçün ən azı %d ədəd lazımdır'):format(mapping.ratio)
    end

    exports.ox_inventory:RemoveItem(source, inputItem, mapping.ratio)
    exports.ox_inventory:AddItem(source, mapping.output, 1)

    -- Qeyd (iqtisadiyyat izləmə)
    MySQL.insert.await('INSERT INTO vr_recycling (citizenid, item, material_out, amount) VALUES (?, ?, ?, ?)',
        { player.PlayerData.citizenid, inputItem, mapping.output, mapping.ratio })

    return true, ('%d x %s → 1 x %s'):format(mapping.ratio, inputItem, mapping.output)
end)

print('[vr_crafting] Resayklinq sistemi aktivdir.')
