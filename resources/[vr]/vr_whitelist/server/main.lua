-- ============================================================
-- vr_whitelist — Server: giriş yoxlaması və səviyyə idarəsi
-- ============================================================

local config = lib.require('config.shared')

-- === Oyunçu qoşulanda whitelist yoxlaması ===
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local src = source
    deferrals.defer()
    deferrals.update('Velmora Respublikası — Vətəndaşlıq yoxlanılır…')
    Wait(100)

    local identifiers = GetPlayerIdentifiers(src)
    local citizenid
    for _, id in ipairs(identifiers) do
        if id:sub(1, 7) == 'license' then
            citizenid = id
            break
        end
    end

    local row = MySQL.single.await('SELECT * FROM vr_citizenship WHERE citizenid = ?', { citizenid })

    if not row then
        deferrals.done('Whitelist tələb olunur. Müraciət üçün Discord-a qoşulun.')
        return
    end

    -- Sınaq müddəti bitib?
    if row.level == 'temporary' and row.trial_until then
        local trialUntil = row.trial_until
        if os.time() > os.time({ year = trialUntil:match('(%d+)-%d+-%d+'), month = trialUntil:match('%d+-(%d+)-%d+'), day = trialUntil:match('%d+-%d+-(%d+)') }) then
            deferrals.done('Sınaq müddətiniz bitib. Staff ilə əlaqə saxlayın.')
            return
        end
    end

    deferrals.done()
end)

-- === Səviyyəni oxu (digər resurslar üçün export) ===
exports('getLevel', function(citizenid)
    local row = MySQL.single.await('SELECT level FROM vr_citizenship WHERE citizenid = ?', { citizenid })
    return row and row.level or 'temporary'
end)

-- === Səviyyə təyin et (staff) ===
lib.callback.register('vr:whitelist:setLevel', function(source, targetCitizenid, level)
    if not exports.vr_admin:hasPermission(source, 'give_money') then return false end -- yüksək icazə
    MySQL.update.await('UPDATE vr_citizenship SET level = ? WHERE citizenid = ?', { level, targetCitizenid })
    exports.vr_admin:audit('citizenship_change', source, targetCitizenid, level)
    return true
end)

-- === Mentor təyin et ===
lib.callback.register('vr:whitelist:setMentor', function(source, targetCitizenid, mentorCitizenid)
    if not exports.vr_admin:hasPermission(source, 'give_money') then return false end
    MySQL.update.await('UPDATE vr_citizenship SET mentor_id = ? WHERE citizenid = ?', { mentorCitizenid, targetCitizenid })
    return true
end)

print('[vr_whitelist] 196RP — Whitelist girişi aktivdir.')
