-- ============================================================
-- vr_environment — Client: hava vizualları, sürüşkən yol
-- ============================================================

-- === Hava sinxronu ===
RegisterNetEvent('vr:environment:syncWeather', function(weatherType)
    local hash = 'CLEAR'
    if weatherType == 'RAIN' then hash = 'RAIN'
    elseif weatherType == 'THUNDER' then hash = 'THUNDER'
    elseif weatherType == 'SNOW' then hash = 'SNOW'
    elseif weatherType == 'FOGGY' then hash = 'FOGGY'
    elseif weatherType == 'CLOUDS' then hash = 'CLOUDS' end
    SetWeatherTypeOvertimePersist(hash, 15.0)
end)

-- === Qar = sürüşkən yol ===
RegisterNetEvent('vr:environment:snowSlickRoads', function()
    -- Sürüşkən yol effekti (nəqliyyat idarəsi)
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh ~= 0 then
        -- Sürüşmə çarpanı
        SetVehicleHandlingFloat(veh, 'CHandlingData', 'fTractionCurveLateral', 0.7)
    end
end)

-- === Elektrik kəsintisi vizualı ===
RegisterNetEvent('vr:environment:blackout', function(district)
    lib.notify({ title = 'Elektrik kəsintisi', description = 'Rayon qaranlıqda: ' .. district, type = 'error' })
    SetArtificialLightsState(false) -- işıqlar sönür
end)

print('[vr_environment] Client aktivdir.')
