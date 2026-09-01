-- ============================================================
-- vr_environment — Dinamik hava sistemi
-- fırtına limanı bağlayır, qar yolu sürüşkən edir, quraqlıq məhsulu azaldır
-- ============================================================

local currentWeather = 'CLEAR'
local currentSeason = 'summer'

-- === Hava dəyiş ===
local function setWeather(weatherType)
    currentWeather = weatherType
    TriggerClientEvent('vr:environment:syncWeather', -1, weatherType)
    TriggerEvent('vr:weather:set', weatherType)

    -- Fırtına effektləri
    if weatherType == 'THUNDER' then
        -- Liman bağlanır → idxal bahalaşır
        TriggerEvent('vr:weather:storm')
    elseif weatherType == 'SNOW' then
        -- Yollar sürüşkən (client-də idarə olunur)
        TriggerEvent('vr:weather:snow')
    elseif weatherType == 'CLEAR' and currentSeason == 'summer' then
        -- Quraqlıq riski (uzun müddət yağışsız)
        TriggerEvent('vr:weather:drought')
    end
end
exports('setWeather', setWeather)

-- === Fəsil dəyiş ===
exports('setSeason', function(season)
    currentSeason = season
end)

-- === Hazırkı fəsil ===
exports('getSeason', function() return currentSeason end)

-- === Təsadüfi hava dövrü ===
CreateThread(function()
    local weathers = { 'CLEAR', 'CLOUDS', 'RAIN', 'CLEAR', 'CLOUDS', 'THUNDER' }
    while true do
        Wait(30 * 60 * 1000) -- hər 30 dəqiqə
        local w = weathers[math.random(1, #weathers)]
        setWeather(w)
    end
end)

-- === Hazırkı hava ===
exports('getWeather', function() return currentWeather end)

print('[vr_environment] Dinamik hava sistemi aktivdir.')
