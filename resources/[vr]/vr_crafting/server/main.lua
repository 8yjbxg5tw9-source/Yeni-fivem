-- ============================================================
-- vr_crafting — Server: crafting icrası
-- ============================================================

local config = lib.require('config.shared')

-- === Reseptləri oxu ===
lib.callback.register('vr:crafting:getRecipes', function(source)
    return config.Recipes
end)

-- === Craft et ===
lib.callback.register('vr:crafting:craft', function(source, recipeName)
    local player = qbx.getPlayer(source)
    if not player then return false, 'Oyuncu tapılmadı' end

    local recipe
    for _, r in ipairs(config.Recipes) do
        if r.name == recipeName then recipe = r break end
    end
    if not recipe then return false, 'Resept tapılmadı' end

    -- Peşə tələbi (dizayner/aşpaz)
    if recipe.job then
        local job = player.PlayerData.job and player.PlayerData.job.name or ''
        if job ~= recipe.job then return false, ('Bu resept üçün %s peşəsi lazımdır'):format(recipe.job) end
    end

    -- İngredient yoxlaması
    for _, ing in ipairs(recipe.ingredients) do
        local has = exports.ox_inventory:GetItem(source, ing.item, {}, false)
        if not has or has.count < ing.amount then
            return false, ('Çatışmayan ingredient: %s (x%d)'):format(ing.item, ing.amount)
        end
    end

    -- İngredientləri çıxar
    for _, ing in ipairs(recipe.ingredients) do
        exports.ox_inventory:RemoveItem(source, ing.item, ing.amount)
    end

    -- Məhsulu ver (metadata ilə)
    exports.vr_items:addItemWithMetadata(source, recipe.result, recipe.amount, nil)
    return true, ('%s hazırlandı (x%d)'):format(recipe.result, recipe.amount)
end)

print('[vr_crafting] Crafting sistemi aktivdir.')
