-- ============================================================
-- vr_admin — Server: admin komandaları
-- Bütün əməliyyatlar icazə yoxlaması + audit log ilə
-- ============================================================

-- === WARN ===
lib.addCommand('warn', {
    help = 'Oyunçuya xəbərdarlıq ver (OOC)',
    params = {
        { name = 'id', type = 'playerId', help = 'Oyunçu ID' },
        { name = 'reason', type = 'string', help = 'Səbəb' },
    },
    restricted = 'admin',
}, function(source, args, raw)
    if not exports.vr_admin:hasPermission(source, 'warn') then
        return lib.notify(source, { title = 'İcazə', description = 'Bu əməliyyat üçün icazəniz yoxdur.', type = 'error' })
    end
    local target = args.id
    local reason = table.concat(args, ' ', 2)
    exports.vr_admin:audit('warn', source, target, reason)
    -- İntizam arxivinə yaz
    local tPlayer = qbx.getPlayer(target)
    if tPlayer then
        MySQL.insert.await('INSERT INTO vr_punishments (citizenid, type, reason, staff) VALUES (?, ?, ?, ?)',
            { tPlayer.PlayerData.citizenid, 'warn', reason, 'staff' })
    end
    lib.notify(target, { title = 'Xəbərdarlıq', description = reason, type = 'error' })
end)

-- === KICK ===
lib.addCommand('kick', {
    help = 'Oyunçunu serverdən çıxar',
    params = {
        { name = 'id', type = 'playerId' },
        { name = 'reason', type = 'string' },
    },
    restricted = 'admin',
}, function(source, args)
    if not exports.vr_admin:hasPermission(source, 'kick') then return end
    local reason = table.concat(args, ' ', 2)
    exports.vr_admin:audit('kick', source, args.id, reason)
    DropPlayer(args.id, reason)
end)

-- === BAN ===
lib.addCommand('ban', {
    help = 'Oyunçunu banla',
    params = {
        { name = 'id', type = 'playerId' },
        { name = 'days', type = 'number', help = 'Gün sayı (0 = daimi)' },
        { name = 'reason', type = 'string' },
    },
    restricted = 'admin',
}, function(source, args)
    local permanent = (args.days or 0) <= 0
    if permanent and not exports.vr_admin:hasPermission(source, 'permban') then
        return lib.notify(source, { title = 'İcazə', description = 'Permaban üçün icazəniz yoxdur.', type = 'error' })
    end
    if not permanent and not exports.vr_admin:hasPermission(source, 'tempban') then return end
    local reason = args.reason or 'Qayda pozuntusu'
    exports.vr_admin:audit(permanent and 'permban' or 'tempban', source, args.id, reason)

    local tPlayer = qbx.getPlayer(args.id)
    if tPlayer then
        MySQL.insert.await('INSERT INTO vr_punishments (citizenid, type, reason, staff, duration) VALUES (?, ?, ?, ?, ?)',
            { tPlayer.PlayerData.citizenid, permanent and 'permban' or 'tempban', reason, 'staff', args.days })
        DropPlayer(args.id, 'Banlandınız: ' .. reason)
    end
end)

-- === TELEPORT ===
lib.addCommand('tp', {
    help = 'Oyunçuya teleport ol',
    params = { { name = 'id', type = 'playerId' } },
    restricted = 'admin',
}, function(source, args)
    if not exports.vr_admin:hasPermission(source, 'teleport') then return end
    exports.vr_admin:audit('teleport', source, args.id, nil)
    local target = GetPlayerPed(args.id)
    local coords = GetEntityCoords(target)
    SetEntityCoords(GetPlayerPed(source), coords.x, coords.y, coords.z)
end)

-- === GIVE MONEY (xüsusi icazə + audit) ===
lib.addCommand('givemoney', {
    help = 'Pul ver (YALNIZ xüsusi icazə + ictimai audit)',
    params = {
        { name = 'id', type = 'playerId' },
        { name = 'amount', type = 'number' },
        { name = 'reason', type = 'string' },
    },
    restricted = 'admin',
}, function(source, args)
    if not exports.vr_admin:hasPermission(source, 'give_money') then
        return lib.notify(source, { title = 'QADAĞAN', description = 'Pul yaratma yalnız xüsusi icazə ilə mümkündür.', type = 'error' })
    end
    local amount = math.floor(tonumber(args.amount) or 0)
    if amount <= 0 then return end
    exports.vr_admin:audit('give_money', source, args.id, { amount = amount, reason = args.reason })
    local tPlayer = qbx.getPlayer(args.id)
    if tPlayer then
        tPlayer.Functions.AddMoney('bank', amount, 'admin-give')
    end
end)

-- === Hava / vaxt idarəsi ===
lib.addCommand('weather', {
    help = 'Havanı dəyiş',
    params = { { name = 'type', type = 'string' } },
    restricted = 'admin',
}, function(source, args)
    if not exports.vr_admin:hasPermission(source, 'weather_time') then return end
    exports.vr_admin:audit('weather', source, nil, args.type)
    TriggerEvent('vr:weather:set', args.type)
end)

lib.addCommand('time', {
    help = 'Vaxtı dəyiş',
    params = { { name = 'hour', type = 'number' } },
    restricted = 'admin',
}, function(source, args)
    if not exports.vr_admin:hasPermission(source, 'weather_time') then return end
    exports.vr_admin:audit('time', source, nil, args.hour)
    TriggerEvent('vr:weather:setTime', args.hour)
end)

print('[vr_admin] Admin komandaları yükləndi.')
