-- ============================================================
-- vr_identity — Server: VRN, profil, barber/tatu/plastik cərrahiyyə
-- ============================================================

local config = lib.require('config.shared')

-- === VRN yaradılması ===
-- Format: VR-######### (VR + 9 rəqəm: 2 bölgə kodu + 6 sıra + 1 checksum)
local function generateVRN(birthplaceCode)
    local seq = math.random(100000, 999999)
    local body = birthplaceCode .. seq
    local sum = 0
    for i = 1, #body do
        sum = sum + tonumber(body:sub(i, i))
    end
    local check = sum % 10
    return 'VR-' .. body .. check
end

exports('generateVRN', generateVRN)

-- Personaj yüklənəndə (qbx) VRN təyin et — real qbx event adı: QBCore:Server:PlayerLoaded
AddEventHandler('QBCore:Server:PlayerLoaded', function(player)
    local citizenid = player.PlayerData.citizenid
    local charid = player.PlayerData.cid
    local exists = MySQL.scalar.await(
        'SELECT id FROM vr_characters WHERE citizenid = ? AND charid = ?',
        { citizenid, charid }
    )
    if exists then return end

    local firstName = player.PlayerData.charinfo.firstname or 'Vətəndaş'
    local lastName = player.PlayerData.charinfo.lastname or ''
    -- qbx gender rəqəm olaraq gəlir (0 = male, 1 = female); DB VARCHAR gözləyir
    local gender = (player.PlayerData.charinfo.gender == 1) and 'female' or 'male'
    local vrn = generateVRN('01')

    MySQL.insert.await(
        'INSERT INTO vr_characters (citizenid, charid, vrn, firstname, lastname, birthdate, birthplace, gender, bloodtype, phone) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        {
            citizenid, charid, vrn, firstName, lastName,
            os.date('%Y-%m-%d'), 'Asterra',
            gender,
            'O+', nil
        }
    )
    MySQL.insert.await(
        'INSERT INTO vr_profile (char_id, credit_score) VALUES (?, ?)',
        { (MySQL.scalar.await('SELECT id FROM vr_characters WHERE vrn = ?', { vrn })), 500 }
    )
end)

-- === Şəxsi profili oxumaq (aidiyyətli qurumlar üçün) ===
lib.callback.register('vr:identity:getProfile', function(source, targetCharId)
    local player = qbx.getPlayer(source)
    if not player then return nil end
    -- Yalnız aidiyyətli qurum (polis/EMS/məhkəmə) baxa bilər — sadə icazə nümunəsi
    local job = player.PlayerData.job and player.PlayerData.job.name or ''
    local allowed = { police = true, ambulance = true, judge = true, lawyer = true }
    if not allowed[job] then return nil end
    local profile = MySQL.single.await(
        'SELECT p.*, c.vrn, c.firstname, c.lastname FROM vr_profile p JOIN vr_characters c ON c.id = p.char_id WHERE p.char_id = ?',
        { targetCharId }
    )
    return profile
end)

-- === Kredit reytinqi (KYC) ===
exports('getCreditScore', function(charId)
    local result = MySQL.single.await('SELECT credit_score FROM vr_profile WHERE char_id = ?', { charId })
    return result and result.credit_score or 500
end)

-- === VRN ilə personaj tap ===
exports('getCharByVRN', function(vrn)
    return MySQL.single.await('SELECT * FROM vr_characters WHERE vrn = ?', { vrn })
end)

exports('getCharBySource', function(source)
    local player = qbx.getPlayer(source)
    if not player then return nil end
    return MySQL.single.await(
        'SELECT * FROM vr_characters WHERE citizenid = ? AND charid = ?',
        { player.PlayerData.citizenid, player.PlayerData.cid }
    )
end)

-- === Plastik cərrahiyyə ödənişi (server-side yoxlanır) ===
lib.callback.register('vr:identity:paySurgery', function(source)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local money = player.PlayerData.money.bank or 0
    if money < config.PlasticSurgery.cost then
        lib.notify(source, { title = 'Plastik Cərrahiyyə', description = 'Kifayət qədər pul yoxdur.', type = 'error' })
        return false
    end
    player.Functions.RemoveMoney('bank', config.PlasticSurgery.cost, 'plastik-cerrahiyye')
    return true
end)

print('[vr_identity] 196RP — Personaj və VRN sistemi aktivdir.')
