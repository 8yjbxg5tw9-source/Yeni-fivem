-- ============================================================
-- vr_phone — Client: xüsusi tətbiq hərəkətləri (taksi, yarış, hava)
-- ============================================================

-- === Taksi çağırışı ===
RegisterNUICallback('callTaxi', function(data, cb)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    -- Taksi dispetçerinə çağırış (iş sistemi ilə inteqrasiya Addım 6/7-də)
    TriggerServerEvent('vr:taxi:request', coords)
    cb(true)
end)

-- === Yeraltı yarış qeydiyyatı ===
RegisterNUICallback('joinRace', function(data, cb)
    TriggerServerEvent('vr:race:register', data.raceId)
    cb(true)
end)

-- === Hava proqnozu (serverdən) ===
RegisterNUICallback('getWeather', function(_, cb)
    cb(lib.callback.await('vr:phone:getWeather', false))
end)
