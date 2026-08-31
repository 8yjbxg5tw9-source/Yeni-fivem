-- ============================================================
-- vr_voice — Client: danışıq rejimləri, radio, səs filtri
-- ============================================================

local config = lib.require('config.shared')

local currentRange = 'normal'
local inVehicle = false

-- === Danışıq rejimini dəyiş (pıçıltı/normal/qışqırıq) ===
local function setVoiceRange(range)
    currentRange = range
    local distance = config.Ranges[range] or config.Ranges.normal
    -- pma-voice səs həcmini təyin edir
    exports['pma-voice']:setVoiceRange(distance)
    lib.notify({ title = 'Səs', description = 'Rejim: ' .. range, type = 'inform' })
end

-- === Keybinds (yenidən təyin oluna bilən) ===
lib.addKeybind({
    name = 'vr_voice_whisper',
    description = 'Pıçıltı rejimi',
    defaultKey = 'H',
    onPressed = function() setVoiceRange('whisper') end,
})
lib.addKeybind({
    name = 'vr_voice_normal',
    description = 'Normal rejim',
    defaultKey = 'J',
    onPressed = function() setVoiceRange('normal') end,
})
lib.addKeybind({
    name = 'vr_voice_shout',
    description = 'Qışqırıq rejimi',
    defaultKey = 'K',
    onPressed = function() setVoiceRange('shout') end,
})

-- === Avtomobil içi səs filtri (içəridən kənara səs zəif eşidilir) ===
CreateThread(function()
    while true do
        Wait(500)
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        local nowInVehicle = veh ~= 0
        if nowInVehicle ~= inVehicle then
            inVehicle = nowInVehicle
            -- pma-voice avtomobil filtri (muffle)
            exports['pma-voice']:setMuffleState(inVehicle)
            if inVehicle then
                exports['pma-voice']:setVoiceRange(config.Ranges[currentRange] * 0.6) -- içəridə zəif
            else
                exports['pma-voice']:setVoiceRange(config.Ranges[currentRange])
            end
        end
    end
end)

-- === Radio açma cəhdi (headset məcburi) ===
exports('joinRadio', function(channel)
    local hasEquip = lib.callback.await('vr:voice:hasRadioEquipment', false)
    if not hasEquip then
        lib.notify({ title = 'Radio', description = 'Radio üçün radio + qulaqcıq (headset) lazımdır.', type = 'error' })
        return false
    end
    exports['pma-voice']:setRadioChannel(channel)
    return true
end)

-- Şifrəli kanala qoşulma
exports('joinSecureChannel', function(channelName)
    local allowed = lib.callback.await('vr:voice:canJoinSecure', false, channelName)
    if not allowed then
        lib.notify({ title = 'Radio', description = 'Bu dalğa şifrəlidir və icazəniz yoxdur.', type = 'error' })
        return false
    end
    exports['pma-voice']:setRadioChannel(channelName)
    return true
end)
