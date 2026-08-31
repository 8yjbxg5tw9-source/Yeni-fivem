-- ============================================================
-- vr_core — Server əsas
-- 196RP — Velmora Respublikası
-- ============================================================

local config = lib.require('config.shared')

-- === Paylaşılan state exportu ===
exports('getState', function()
    return config.State
end)

exports('getRegions', function()
    return config.Regions
end)

exports('getHolidays', function()
    return config.Holidays
end)

-- === Vətəndaşlıq səviyyəsini oxumaq ===
-- (vr_whitelist resource-u bu cədvəli doldurur)
local function getCitizenship(citizenid)
    local result = MySQL.single.await('SELECT level FROM vr_citizenship WHERE citizenid = ?', { citizenid })
    return result and result.level or 'temporary'
end

exports('getCitizenship', getCitizenship)

lib.callback.register('vr:core:getCitizenship', function(source)
    local player = qbx.getPlayer(source)
    if not player then return nil end
    return getCitizenship(player.PlayerData.citizenid)
end)

-- === Yoxlama helperləri ===
local function isAllowed(source, level)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local citizenship = getCitizenship(player.PlayerData.citizenid)
    local order = { temporary = 1, citizen = 2, trusted = 3, veteran = 4 }
    return (order[citizenship] or 1) >= (order[level] or 1)
end

exports('isAllowed', isAllowed)

print('[vr_core] 196RP — Velmora Respublikası core-u yükləndi. Dil: az')
