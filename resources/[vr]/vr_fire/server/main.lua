-- ============================================================
-- vr_fire — Server: yanğın hadisələri, yayılma mexanikası
-- ============================================================

local config = lib.require('config.shared')

local function isFire(source)
    local player = qbx.getPlayer(source)
    if not player then return false end
    return (player.PlayerData.job and player.PlayerData.job.name == 'firefighter')
end

-- === Yanğın başlat (hadisə) ===
exports('startFire', function(source, location, fireType)
    local player = qbx.getPlayer(source)
    local reportedBy = player and player.PlayerData.citizenid or 'system'
    MySQL.insert.await('INSERT INTO vr_fires (location, fire_type, reported_by) VALUES (?, ?, ?)',
        { location, fireType, reportedBy })
    return true
end)

-- === Yanğın yayılma mexanikası (dövri) ===
CreateThread(function()
    while true do
        Wait(60 * 1000) -- hər dəqiqə
        local fires = MySQL.query.await('SELECT * FROM vr_fires WHERE contained = 0')
        for _, fire in ipairs(fires) do
            local fireInfo = config.Types[fire.fire_type]
            if fireInfo and fireInfo.spreadable then
                local newSpread = math.min(100, fire.spread + config.SpreadRate)
                MySQL.update.await('UPDATE vr_fires SET spread = ? WHERE id = ?', { newSpread, fire.id })
                -- 100%-ə çatanda bina geniş miqyaslı hadisə olur
                if newSpread >= 100 then
                    -- Bütün yanğınsöndürənlərə kritik bildiriş
                    TriggerClientEvent('vr:fire:critical', -1, { location = fire.location })
                end
            end
        end
    end
end)

-- === Yanğını söndür ===
lib.callback.register('vr:fire:extinguish', function(source, fireId)
    if not isFire(source) then return false end
    MySQL.update.await('UPDATE vr_fires SET contained = 1 WHERE id = ?', { fireId })
    return true
end)

-- === Qaz sızması hadisəsi (partlayış riski) ===
exports('gasLeak', function(source, location)
    exports('startFire')(source, location, 'gas_leak')
    -- Partlayış riski bildirişi
    TriggerClientEvent('vr:fire:gasWarning', -1, { location = location })
end)

-- === Qəza-xilasetmə çağırışı ===
exports('rescueCall', function(source, location, description)
    MySQL.insert.await('INSERT INTO vr_fires (location, fire_type, reported_by) VALUES (?, ?, ?)',
        { location, 'rescue', source })
    TriggerClientEvent('vr:fire:rescueCall', -1, { location = location, description = description })
end)

print('[vr_fire] Yanğın-Xilasetmə sistemi aktivdir.')
