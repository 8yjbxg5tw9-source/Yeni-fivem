-- ============================================================
-- vr_environment — Meşəçilik (lisenziya + qorunan zonalar)
-- ============================================================

local config = lib.require('config.shared')

-- === Ağac kəsimi ===
lib.callback.register('vr:environment:chopTree', function(source, zone)
    local player = qbx.getPlayer(source)
    if not player then return false end

    -- Lisenziya tələbi
    local hasLicense = exports.vr_licenses:hasLicense(source, 'hunting') -- ov/mesəçilik lisenziyası
    if not hasLicense then return false, 'Meşəçilik lisenziyası tələb olunur' end

    -- Qorunan zona yoxlaması (ekoloji RP)
    for _, pz in ipairs(config.ProtectedZones) do
        if zone == pz then
            -- Qorunan zonada kəsim = cərimə + flag
            MySQL.insert.await('INSERT INTO vr_fines (char_id, reason, amount) VALUES (?, ?, ?)',
                { (exports.vr_identity:getCharBySource(source)).id, 'Qorunan zonada ağac kəsimi', 10000 })
            return false, 'QORUNAN ZONA! Cərimə tətbiq olundu (10 000 S₺)'
        end
    end

    exports.ox_inventory:AddItem(source, 'wood', math.random(2, 4))
    return true
end)

print('[vr_environment] Meşəçilik sistemi aktivdir.')
