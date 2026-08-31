-- ============================================================
-- vr_government — Notariat (müqavilələr, icra qüvvəsi)
-- ============================================================

-- === Müqavilə tərtib et (notariat təsdiqi) ===
lib.callback.register('vr:government:createContract', function(source, contractType, parties, terms)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local job = player.PlayerData.job and player.PlayerData.job.name or ''
    if job ~= 'notary' then return false, 'Yalnız notarius müqavilə tərtib edə bilər' end

    local contractNo = ('CNT-%s'):format(math.random(100000, 999999))
    MySQL.insert.await('INSERT INTO vr_contracts (contract_no, type, parties, terms, notary) VALUES (?, ?, ?, ?, ?)',
        { contractNo, contractType, json.encode(parties), json.encode(terms), player.PlayerData.citizenid })
    return true, contractNo
end)

-- === Müqaviləni yoxla (məhkəmə icra qüvvəsi) ===
lib.callback.register('vr:government:verifyContract', function(source, contractNo)
    local contract = MySQL.single.await('SELECT * FROM vr_contracts WHERE contract_no = ?', { contractNo })
    if not contract then return nil, 'Müqavilə tapılmadı' end
    -- Notarial müqavilələr məhkəmədə birbaşa icra sənədi sayılır
    return {
        contract_no = contract.contract_no,
        type = contract.type,
        parties = json.decode(contract.parties),
        terms = json.decode(contract.terms),
        enforceable = true, -- notariat təsdiqi = icra qüvvəsi
    }
end)

-- === Vəsiyyətnamə (notariat) ===
lib.callback.register('vr:government:registerWill', function(source, willData)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local job = player.PlayerData.job and player.PlayerData.job.name or ''
    if job ~= 'notary' then return false end
    -- vr_identity reyestrinə vəsiyyət yaz
    local char = exports.vr_identity:getCharBySource(source)
    if not char then return false end
    exports.vr_identity:addCivilRecord(char.id, 'will', willData)
    return true
end)

print('[vr_government] Notariat sistemi aktivdir.')
