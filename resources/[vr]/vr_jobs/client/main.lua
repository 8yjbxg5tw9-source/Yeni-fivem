-- ============================================================
-- vr_jobs — Client: iş menyusu
-- ============================================================

local config = lib.require('config.shared')

-- === İş seçimi menyusu ===
exports('openJobMenu', function()
    local options = {}

    options[#options + 1] = { title = '— Başlanğıc işləri —', disabled = true }
    for _, job in ipairs(config.Starter) do
        options[#options + 1] = {
            title = job.label,
            onSelect = function()
                lib.callback.await('vr:jobs:join', false, job.id)
            end,
        }
    end

    options[#options + 1] = { title = '— İxtisaslı işlər —', disabled = true }
    for _, job in ipairs(config.Skilled) do
        options[#options + 1] = {
            title = job.label .. ' (attestasiya)',
            onSelect = function()
                lib.callback.await('vr:jobs:join', false, job.id)
            end,
        }
    end

    lib.registerContext({ id = 'vr_jobs', title = 'İş Seçimi', options = options })
    lib.showContext('vr_jobs')
end)

print('[vr_jobs] Client aktivdir.')
