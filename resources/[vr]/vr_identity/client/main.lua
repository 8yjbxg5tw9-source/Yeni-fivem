-- ============================================================
-- vr_identity — Client: barber, tatu, plastik cərrahiyyə
-- ============================================================

local config = lib.require('config.shared')

-- === Barber (saç-saqqal) ===
-- qbx_skin-in öz UI-ını açır; yalnız barber nöqtəsində (target vasitəsilə)
exports('openBarber', function()
    TriggerEvent('qbx_skin:client:openSkin') -- barber konteksti qbx_skin-də tənzimlənir
end)

-- === Tatu ===
exports('openTattoo', function()
    TriggerEvent('qbx_skin:client:openTattoo')
end)

-- === Plastik cərrahiyyə (xəstəxanada görünüş dəyişmə RP) ===
local lastSurgery = 0

local function canSurgery()
    if (os.time() - lastSurgery) < (config.PlasticSurgery.cooldownMinutes * 60) then
        lib.notify({ title = 'Plastik Cərrahiyyə', description = 'Əməliyyatlar arası gözləmə müddəti bitməyib.', type = 'error' })
        return false
    end
    return true
end

exports('openPlasticSurgery', function()
    if not canSurgery() then return end
    local input = lib.inputDialog('Plastik Cərrahiyyə', {
        { type = 'checkbox', label = 'Əməliyyat haqqını ödəyirəm: ' .. config.PlasticSurgery.cost .. ' S₺', checked = true, required = true },
    })
    if not input then return end
    local success = lib.callback.await('vr:identity:paySurgery', false)
    if success then
        lastSurgery = os.time()
        TriggerEvent('qbx_skin:client:openSkin') -- tam görünüş dəyişmə
    end
end)
