-- ============================================================
-- vr_ems — Qan bankı: qan qrupları, transfuziya, donor RP
-- ============================================================

local config = lib.require('config.shared')

local function isEMS(source)
    local player = qbx.getPlayer(source)
    if not player then return false end
    return (player.PlayerData.job and player.PlayerData.job.name == 'ambulance')
end

-- === Donor qeydi (qan bankını doldurur) ===
lib.callback.register('vr:ems:donateBlood', function(source, units)
    if not isEMS(source) then return false end
    local player = qbx.getPlayer(source)
    local char = exports.vr_identity:getCharBySource(source)
    if not char then return false end
    local bloodType = char.bloodtype or 'O+'
    units = math.min(math.floor(tonumber(units) or 1), 2) -- max 2 vahid

    MySQL.insert.await('INSERT INTO vr_donations (char_id, blood_type, units) VALUES (?, ?, ?)',
        { char.id, bloodType, units })

    -- Qan bankını artır
    MySQL.update.await('INSERT INTO vr_bloodbank (blood_type, units) VALUES (?, ?) ON DUPLICATE KEY UPDATE units = units + VALUES(units)',
        { bloodType, units })
    return true
end)

-- === Qan bankı statusu ===
lib.callback.register('vr:ems:getBloodBank', function(source)
    return MySQL.query.await('SELECT * FROM vr_bloodbank')
end)

-- === Transfuziya (uyğun qrup yoxlaması) ===
lib.callback.register('vr:ems:transfuse', function(source, targetCharId, bloodType)
    if not isEMS(source) then return false, 'İcazə yoxdur' end
    local target = MySQL.single.await('SELECT * FROM vr_characters WHERE id = ?', { targetCharId })
    if not target then return false, 'Xəstə tapılmadı' end

    local patientBlood = target.bloodtype or 'O+'
    local compatible = config.BloodCompatibility[bloodType] or {}
    local ok = false
    for _, b in ipairs(compatible) do
        if b == patientBlood then ok = true break end
    end
    if not ok then return false, 'Qan qrupu uyğun deyil — transfuziya təhlükəlidir!' end

    -- Bankdan azalt
    local bank = MySQL.single.await('SELECT * FROM vr_bloodbank WHERE blood_type = ?', { bloodType })
    if not bank or bank.units < 1 then return false, 'Qan bankında bu qrupdan vahid yoxdur' end
    MySQL.update.await('UPDATE vr_bloodbank SET units = units - 1 WHERE blood_type = ?', { bloodType })

    return true, 'Transfuziya uğurla tamamlandı'
end)
