-- ============================================================
-- vr_court — Client: docket UI, transkript göstərmə
-- ============================================================

-- === Docket göstər ===
exports('showDocket', function()
    local cases = lib.callback.await('vr:court:getDocket', false)
    local options = {}
    for _, c in ipairs(cases) do
        options[#options + 1] = {
            title = c.case_no .. ' — ' .. c.type,
            description = ('Status: %s | İnstansiya: %s'):format(c.status, c.instance),
        }
    end
    if #options == 0 then options[1] = { title = 'İclas yoxdur', description = 'Docket boşdur' } end
    lib.registerContext({ id = 'vr_court_docket', title = 'Məhkəmə Docket-i', options = options })
    lib.showContext('vr_court_docket')
end)

print('[vr_court] Client aktivdir.')
