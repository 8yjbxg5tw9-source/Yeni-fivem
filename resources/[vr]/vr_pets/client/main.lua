-- ============================================================
-- vr_pets — Client: heyvan UI
-- ============================================================

-- === Heyvanları göstər ===
exports('showPets', function()
    local pets = lib.callback.await('vr:pets:getMine', false)
    local options = {}
    for _, p in ipairs(pets) do
        options[#options + 1] = {
            title = p.name .. ' (' .. p.species .. ')',
            description = ('Aclıq: %.0f | Sağlamlıq: %.0f'):format(p.hunger, p.health),
        }
    end
    if #options == 0 then options[1] = { title = 'Heyvanınız yoxdur', description = 'Baytarlıqdan heyvan alın' } end
    lib.registerContext({ id = 'vr_pets', title = 'Ev Heyvanlarım', options = options })
    lib.showContext('vr_pets')
end)

print('[vr_pets] Client aktivdir.')
