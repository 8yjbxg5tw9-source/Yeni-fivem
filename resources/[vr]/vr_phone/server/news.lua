-- ============================================================
-- vr_phone — Xəbərlər (Dövlət Xəbər Xidməti + oyunçu qəzetləri)
-- ============================================================

-- === Xəbər dərc et (jurnalist akkreditasiyası ilə) ===
lib.callback.register('vr:phone:publishNews', function(source, title, body, official)
    local player = qbx.getPlayer(source)
    if not player then return false end
    if #title > 120 or #body > 2000 then return false end

    local job = player.PlayerData.job and player.PlayerData.job.name or ''
    if official and job ~= 'news' then
        return false, 'Rəsmi elan yalnız Dövlət Xəbər Xidməti tərəfindən dərc olunur'
    end

    MySQL.insert.await('INSERT INTO vr_news (outlet, title, body, author, official) VALUES (?, ?, ?, ?, ?)',
        { official and 'Dövlət Xəbər Xidməti' or 'Müstəqil Qəzet', title, body, player.PlayerData.citizenid, official and 1 or 0 })
    return true
end)

-- === Xəbərləri oxu ===
lib.callback.register('vr:phone:getNews', function(source)
    return MySQL.query.await('SELECT * FROM vr_news ORDER BY published_at DESC LIMIT 50')
end)

-- === Hava proqnozu (dinamik hava sistemi ilə sinxron) ===
local currentWeather = 'CLEAR'

RegisterNetEvent('vr:weather:set', function(weatherType)
    currentWeather = weatherType or 'CLEAR'
end)

lib.callback.register('vr:phone:getWeather', function(source)
    local weatherNames = {
        CLEAR = 'Açıq', CLOUDS = 'Buludlu', RAIN = 'Yağışlı',
        THUNDER = 'Fırtınalı', SNOW = 'Qarlı', FOGGY = 'Dumanlı',
    }
    return {
        weather = weatherNames[currentWeather] or currentWeather,
        forecast = 'Sabah: ' .. (weatherNames.CLOUDS or 'Buludlu'),
    }
end)

print('[vr_phone] Xəbər sistemi aktivdir.')
