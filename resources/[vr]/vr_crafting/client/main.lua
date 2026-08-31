-- ============================================================
-- vr_crafting — Client: crafting menyusu
-- ============================================================

local config = lib.require('config.shared')

-- === Crafting menyusu ===
exports('openCrafting', function()
    local recipes = lib.callback.await('vr:crafting:getRecipes', false)
    local options = {}
    for _, r in ipairs(recipes) do
        local ing = {}
        for _, i in ipairs(r.ingredients) do
            ing[#ing + 1] = ('%s x%d'):format(i.item, i.amount)
        end
        options[#options + 1] = {
            title = r.name,
            description = ('İngredientlər: %s | Vaxt: %ds'):format(table.concat(ing, ', '), r.time),
            onSelect = function()
                if lib.progressBar({ duration = r.time * 1000, label = r.name .. ' hazırlanır…', canCancel = true }) then
                    local ok, msg = lib.callback.await('vr:crafting:craft', false, r.name)
                    lib.notify({ title = 'Crafting', description = msg, type = ok and 'success' or 'error' })
                end
            end,
        }
    end
    if #options == 0 then options[1] = { title = 'Resept yoxdur' } end
    lib.registerContext({ id = 'vr_crafting', title = 'Crafting', options = options })
    lib.showContext('vr_crafting')
end)

print('[vr_crafting] Client aktivdir.')
