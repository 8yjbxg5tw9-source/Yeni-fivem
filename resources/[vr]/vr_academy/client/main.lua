-- ============================================================
-- vr_academy — Client: kurs menyusu
-- ============================================================

local config = lib.require('config.shared')

-- === Akademiya menyusu ===
exports('openAcademy', function()
    local options = {}
    for _, c in ipairs(config.Courses) do
        options[#options + 1] = {
            title = c.label,
            description = c.cost > 0 and ('Haqq: %d S₺'):format(c.cost) or 'Pulsuz',
            onSelect = function()
                local ok, msg = lib.callback.await('vr:academy:enroll', false, c.id)
                lib.notify({ title = 'RP Akademiya', description = msg, type = ok and 'success' or 'error' })
            end,
        }
    end
    lib.registerContext({ id = 'vr_academy', title = 'RP Akademiya — Peşə Mərkəzi', options = options })
    lib.showContext('vr_academy')
end)

print('[vr_academy] Client aktivdir.')
