-- ============================================================
-- vr_pets — Server: ev heyvanları idarəetməsi
-- ============================================================

local config = lib.require('config.shared')

-- === Heyvan al ===
lib.callback.register('vr:pets:adopt', function(source, petName, species)
    local player = qbx.getPlayer(source)
    if not player then return false end
    MySQL.insert.await('INSERT INTO vr_pets (owner, name, species) VALUES (?, ?, ?)',
        { player.PlayerData.citizenid, petName, species })
    return true
end)

-- === Heyvan yemlə ===
lib.callback.register('vr:pets:feed', function(source, petId)
    local player = qbx.getPlayer(source)
    if not player then return false end
    MySQL.update.await('UPDATE vr_pets SET hunger = LEAST(100, hunger + 30) WHERE id = ? AND owner = ?',
        { petId, player.PlayerData.citizenid })
    return true
end)

-- === Baytar müalicəsi ===
lib.callback.register('vr:pets:vet', function(source, petId)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local bank = exports.vr_banking:getBalance(player.PlayerData.citizenid)
    if bank < config.VetCost then return false, 'Kifayət qədər pul yoxdur' end
    exports.vr_banking:removeBankMoney(player.PlayerData.citizenid, config.VetCost, 'baytar')
    MySQL.update.await('UPDATE vr_pets SET health = 100 WHERE id = ?', { petId })
    return true
end)

-- === Heyvanlarım ===
lib.callback.register('vr:pets:getMine', function(source)
    local player = qbx.getPlayer(source)
    if not player then return {} end
    return MySQL.query.await('SELECT * FROM vr_pets WHERE owner = ?', { player.PlayerData.citizenid })
end)

-- === Aclıq/sağlamlıq azalması (dövri) ===
CreateThread(function()
    while true do
        Wait(60 * 60 * 1000) -- hər saat
        MySQL.update.await('UPDATE vr_pets SET hunger = GREATEST(0, hunger - ?), health = GREATEST(0, health - ?) WHERE hunger > 0',
            { config.DecayPerHour, config.DecayPerHour * 0.5 })
    end
end)

print('[vr_pets] Ev heyvanları sistemi aktivdir.')
