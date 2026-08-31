-- ============================================================
-- vr_criminal — Silah emalı (qara bazar)
-- ============================================================

-- === Silah istehsal et (qanunsuz) ===
lib.callback.register('vr:criminal:craftWeapon', function(source, weaponType)
    local player = qbx.getPlayer(source)
    if not player then return false end

    -- İngredient tələbi (metal + parts)
    local hasMetal = exports.ox_inventory:GetItem(source, 'metal', {}, false)
    local hasParts = exports.ox_inventory:GetItem(source, 'weapon_parts', {}, false)
    if not hasMetal or hasMetal.count < 3 then return false, '3x metal lazımdır' end
    if not hasParts or hasParts.count < 2 then return false, '2x silah hissəsi lazımdır' end

    exports.ox_inventory:RemoveItem(source, 'metal', 3)
    exports.ox_inventory:RemoveItem(source, 'weapon_parts', 2)

    -- Seriya №-li qanunsuz silah
    local serial = exports.vr_items:generateSerial('BLK')
    exports.vr_items:addItemWithMetadata(source, weaponType, 1, { serial = serial, quality = 70 })

    -- Ballistik bazaya QEYDİYYATSIZ silah kimi düşmür (qanunsuz)
    return true, ('Qanunsuz silah hazırlandı: %s'):format(serial)
end)

print('[vr_criminal] Silah emalı sistemi aktivdir.')
