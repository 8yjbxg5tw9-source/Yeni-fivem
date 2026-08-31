-- ============================================================
-- vr_jobs — Server: iş qeydiyyatı, attestasiya
-- ============================================================

local config = lib.require('config.shared')

-- === İşə daxil ol ===
lib.callback.register('vr:jobs:join', function(source, jobId)
    local player = qbx.getPlayer(source)
    if not player then return false end

    -- İxtisaslı işdirmi? (attestasiya tələbi)
    for _, job in ipairs(config.Skilled) do
        if job.id == jobId then
            local hasLic = exports.vr_licenses:hasLicense(source, job.requires)
            if not hasLic then return false, 'Bu iş üçün attestasiya/lisenziya tələb olunur' end
            break
        end
    end

    MySQL.update.await(
        'INSERT INTO vr_jobs (citizenid, job, certified) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE job = VALUES(job)',
        { player.PlayerData.citizenid, jobId, 1 })
    return true
end)

-- === Attestasiya (sanitar kitabça, vəkil imtahanı, jurnalist akkreditasiyası) ===
lib.callback.register('vr:jobs:certify', function(source, jobId)
    local player = qbx.getPlayer(source)
    if not player then return false end

    -- Attestasiya haqqı (peşə mərkəzi kursları)
    local certCost = 5000
    local bank = player.PlayerData.money.bank or 0
    if bank < certCost then return false, 'Attestasiya üçün pul yoxdur' end

    player.Functions.RemoveMoney('bank', certCost, 'attestasiya')

    -- Peşə lisenziyası ver
    exports.vr_licenses:giveLicense(source, 'professional', nil)
    MySQL.update.await('UPDATE vr_jobs SET certified = 1 WHERE citizenid = ? AND job = ?',
        { player.PlayerData.citizenid, jobId })
    return true
end)

-- === Peşə zənciri yoxlaması (restoran fermersiz işləmir) ===
exports('checkSupplyChain', function(companyType)
    return exports.vr_companies:hasSupply(companyType, 'ingredient')
end)

print('[vr_jobs] Mülki işlər sistemi aktivdir.')
