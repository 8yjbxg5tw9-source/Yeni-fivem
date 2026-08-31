-- ============================================================
-- vr_licenses — Client: lisenziyaları göstərmək
-- ============================================================

exports('showLicenses', function()
    local licenses = lib.callback.await('vr:licenses:getMine', false)
    local options = {}
    for _, lic in ipairs(licenses) do
        options[#options + 1] = {
            title = lic.type,
            description = ('Status: %s | Xal: %s'):format(lic.status, lic.points or 0),
        }
    end
    if #options == 0 then
        options[1] = { title = 'Heç bir lisenziya yoxdur', description = 'Lisenziyalarınız burada görünür' }
    end
    lib.registerContext({ id = 'vr_licenses_menu', title = 'Lisenziyalarım', menu = 'vr_licenses_menu', options = options })
    lib.showContext('vr_licenses_menu')
end)
