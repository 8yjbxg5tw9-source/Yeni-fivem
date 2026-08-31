-- ============================================================
-- vr_voice — Server: radio stansiyaları, şifrəli tezliklər
-- ============================================================

local config = lib.require('config.shared')

-- === Aktiv radio tezlikləri (alqı-satqı üçün) ===
local radioChannels = {}

-- === Frekans alqı-satqısı ===
-- Oyunçu radio frekansı "alır" (qara bazar / mağazadan)
exports('purchaseFrequency', function(source, freq)
    local player = qbx.getPlayer(source)
    if not player then return false end
    radioChannels[freq] = radioChannels[freq] or {}
    radioChannels[freq][player.PlayerData.citizenid] = true
    return true
end)

-- === Headset yoxlaması (radio üçün məcburi) ===
local function hasRadioEquipment(source)
    local hasRadio = exports.ox_inventory:GetItem(source, config.RadioRequiredItem, {}, false)
    local hasHeadset = exports.ox_inventory:GetItem(source, config.HeadsetItem, {}, false)
    return (hasRadio ~= nil) and (hasHeadset ~= nil)
end
exports('hasRadioEquipment', hasRadioEquipment)

-- === Şifrəli tezliyə giriş (yalnız aidiyyətli iş) ===
local function canJoinSecureChannel(source, channelName)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local job = player.PlayerData.job and player.PlayerData.job.name or ''
    for _, ch in ipairs(config.SecureChannels) do
        if ch.name == channelName then
            return ch.job == job -- yalnız öz işinin dalğasına girə bilər
        end
    end
    return false
end
exports('canJoinSecureChannel', canJoinSecureChannel)

lib.callback.register('vr:voice:hasRadioEquipment', function(source)
    return hasRadioEquipment(source)
end)

lib.callback.register('vr:voice:canJoinSecure', function(source, channelName)
    return canJoinSecureChannel(source, channelName)
end)

print('[vr_voice] 196RP — Səs sistemi server tərəfi aktivdir.')
