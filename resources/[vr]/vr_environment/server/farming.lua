-- ============================================================
-- vr_environment — Fermerlik dərinliyi
-- mövsüm, torpaq keyfiyyəti, suvarma, heyvandarlıq, xəstəlik riski
-- ============================================================

local config = lib.require('config.shared')

-- === Əkin ===
lib.callback.register('vr:environment:plant', function(source, plotId, cropId)
    local player = qbx.getPlayer(source)
    if not player then return false end

    local crop
    for _, c in ipairs(config.Crops) do
        if c.id == cropId then crop = c break end
    end
    if not crop then return false, 'Məhsul tapılmadı' end

    MySQL.insert.await('INSERT INTO vr_farm_plots (owner, plot_id, crop, planted_at) VALUES (?, ?, ?, NOW())',
        { player.PlayerData.citizenid, plotId, cropId })

    -- Yetişmə müddəti (günlər)
    local readyAt = os.date('%Y-%m-%d %H:%M:%S', os.time() + (crop.growDays * 86400))
    MySQL.update.await('UPDATE vr_farm_plots SET ready_at = ? WHERE plot_id = ?', { readyAt, plotId })
    return true
end)

-- === Suvarma ===
lib.callback.register('vr:environment:irrigate', function(source, plotId)
    local player = qbx.getPlayer(source)
    if not player then return false end
    MySQL.update.await('UPDATE vr_farm_plots SET irrigation = irrigation + 20 WHERE plot_id = ? AND owner = ?',
        { plotId, player.PlayerData.citizenid })
    return true
end)

-- === Məhsul toplama (yield) ===
lib.callback.register('vr:environment:harvest', function(source, plotId)
    local player = qbx.getPlayer(source)
    if not player then return false end

    local plot = MySQL.single.await('SELECT * FROM vr_farm_plots WHERE plot_id = ? AND owner = ?',
        { plotId, player.PlayerData.citizenid })
    if not plot then return false, 'Sahə tapılmadı' end
    if plot.disease then return false, 'Məhsul xəstəliyə tutulub!' end
    if not plot.ready_at or os.time() < os.time(plot.ready_at) then return false, 'Məhsul hələ hazır deyil' end

    -- Məhsuldarlıq: mövsüm + torpaq keyfiyyəti + suvarma
    local season = exports.vr_environment:getSeason() or 'summer'
    local seasonInfo
    for _, s in ipairs(config.Seasons) do
        if s.id == season then seasonInfo = s break end
    end
    local multiplier = (seasonInfo and seasonInfo.yieldMultiplier or 1.0)
    local soilFactor = (plot.soil_quality / 100) * 0.5 + 0.5
    local waterFactor = plot.irrigation >= 50 and 1.2 or 0.8
    local yield = math.floor(10 * multiplier * soilFactor * waterFactor)

    -- Əkinçilik məhsulu inventara
    exports.ox_inventory:AddItem(source, plot.crop, yield)

    MySQL.update.await('UPDATE vr_farm_plots SET crop = NULL, planted_at = NULL, ready_at = NULL, irrigation = 0 WHERE plot_id = ?',
        { plotId })
    return true, yield
end)

-- === Xəstəlik riski (dövri) ===
CreateThread(function()
    while true do
        Wait(60 * 60 * 1000) -- hər saat
        -- Təsadüfi sahələrdə xəstəlik
        MySQL.update.await('UPDATE vr_farm_plots SET disease = 1 WHERE RAND() < 0.01 AND crop IS NOT NULL')
    end
end)

-- === Heyvandarlıq ===
lib.callback.register('vr:environment:buyAnimal', function(source, animalId)
    local player = qbx.getPlayer(source)
    if not player then return false end
    MySQL.insert.await('INSERT INTO vr_livestock (owner, animal, fed_at) VALUES (?, ?, NOW())',
        { player.PlayerData.citizenid, animalId })
    return true
end)

-- === Heyvan yemlə ===
lib.callback.register('vr:environment:feedAnimal', function(source, livestockId)
    local player = qbx.getPlayer(source)
    if not player then return false end
    MySQL.update.await('UPDATE vr_livestock SET fed_at = NOW(), health = LEAST(100, health + 10) WHERE id = ? AND owner = ?',
        { livestockId, player.PlayerData.citizenid })
    return true
end)

-- === Məhsul topla (süd/yun/yumurta) ===
lib.callback.register('vr:environment:collectAnimalProduce', function(source, livestockId)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local animal = MySQL.single.await('SELECT * FROM vr_livestock WHERE id = ? AND owner = ?', { livestockId, player.PlayerData.citizenid })
    if not animal then return false end

    local info
    for _, a in ipairs(config.Animals) do
        if a.id == animal.animal then info = a break end
    end
    if not info then return false end

    exports.ox_inventory:AddItem(source, info.produce, 1)
    MySQL.update.await('UPDATE vr_livestock SET produce_ready = 0 WHERE id = ?', { livestockId })
    return true
end)

-- === Heyvan sağlamlığı azalması (yemlənməsə) ===
CreateThread(function()
    while true do
        Wait(60 * 60 * 1000)
        MySQL.update.await('UPDATE vr_livestock SET health = GREATEST(0, health - 5) WHERE fed_at < NOW() - INTERVAL 24 HOUR')
    end
end)

print('[vr_environment] Fermerlik sistemi aktivdir.')
