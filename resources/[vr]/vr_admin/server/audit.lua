-- ============================================================
-- vr_admin — Audit Log Sistemi
-- Bütün admin əməliyyatları DB-yə və Discord webhook-a yazılır.
-- ============================================================

local config = lib.require('config.shared')
local webhook = GetConvar('discord_webhook', '')

-- === Staff səviyyəsini oxu ===
local function getRank(source)
    local player = qbx.getPlayer(source)
    if not player then return 0 end
    local row = MySQL.single.await('SELECT rank FROM vr_staff WHERE citizenid = ?',
        { player.PlayerData.citizenid })
    if not row then return 0 end
    return (config.Ranks[row.rank] or 0)
end

exports('getRank', getRank)

-- === İcazə yoxlaması ===
local function hasPermission(source, action)
    local rank = getRank(source)
    local required = config.Permissions[action] or 6
    return rank >= required
end

exports('hasPermission', hasPermission)

-- === Audit log yazmaq ===
---@param action string
---@param staffSource any
---@param target any
---@param detail any
local function audit(action, staffSource, target, detail)
    local player = qbx.getPlayer(staffSource)
    local staffName = player and player.PlayerData.citizenid or 'system'
    local targetStr = tostring(target or '')
    local detailStr = detail and json.encode(detail) or nil

    -- DB-yə yaz
    MySQL.insert.await('INSERT INTO vr_audit_log (staff, action, target, detail) VALUES (?, ?, ?, ?)',
        { staffName, action, targetStr, detailStr })

    -- Discord webhook (bütün əməliyyatlar #audit-log kanalına)
    if webhook ~= '' then
        local embed = {
            { title = 'Audit: ' .. action, description = ('**Staff:** %s\n**Hədəf:** %s\n**Detal:** %s'):format(staffName, targetStr, detailStr or '-'), color = 0xD9A441 }
        }
        PerformHttpRequest(webhook, function() end, 'POST', json.encode({ embeds = embed }), { ['Content-Type'] = 'application/json' })
    end
end

exports('audit', audit)

-- İctimai audit (icma üçün oxuna bilər)
lib.callback.register('vr:admin:getPublicAudit', function(source)
    -- Yalnız pul/əşya əməliyyatları ictimaidir
    local rows = MySQL.query.await(
        "SELECT staff, action, target, detail, created_at FROM vr_audit_log WHERE action IN ('give_money','give_item') ORDER BY id DESC LIMIT 50"
    )
    return rows
end)

print('[vr_admin] Audit log sistemi aktivdir.')
