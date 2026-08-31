-- ============================================================
-- vr_crafting — Konfiq: reseptlər və resayklinq
-- ============================================================

local config = {}

-- Qanuni crafting reseptləri
config.Recipes = {
    -- Qida (aşpaz)
    { name = 'çörək', category = 'food', result = 'bread', amount = 1, ingredients = { { item = 'flour', amount = 2 }, { item = 'water', amount = 1 } }, job = 'chef', time = 5 },
    { name = 'yemək boşqabı', category = 'food', result = 'meal', amount = 1, ingredients = { { item = 'ingredient', amount = 3 }, { item = 'spice', amount = 1 } }, job = 'chef', time = 8 },
    -- Alətlər
    { name = 'alət dəsti', category = 'tools', result = 'toolkit', amount = 1, ingredients = { { item = 'metal', amount = 4 }, { item = 'wood', amount = 2 } }, time = 10 },
    { name = 'təmir dəsti', category = 'tools', result = 'repairkit', amount = 1, ingredients = { { item = 'metal', amount = 2 }, { item = 'cloth', amount = 1 } }, time = 6 },
    -- Mebel (dizayner)
    { name = 'stul', category = 'furniture', result = 'chair', amount = 1, ingredients = { { item = 'wood', amount = 4 } }, job = 'designer', time = 7 },
    { name = 'masa', category = 'furniture', result = 'table', amount = 1, ingredients = { { item = 'wood', amount = 6 }, { item = 'metal', amount = 2 } }, job = 'designer', time = 12 },
    -- Paltar (dizayner)
    { name = 'köynək', category = 'clothing', result = 'shirt', amount = 1, ingredients = { { item = 'cloth', amount = 3 }, { item = 'dye', amount = 1 } }, job = 'designer', time = 8 },
    { name = 'şalvar', category = 'clothing', result = 'pants', amount = 1, ingredients = { { item = 'cloth', amount = 4 } }, job = 'designer', time = 8 },
}

-- Resayklinq xəritəsi (zibil → məmulat)
config.Recycling = {
    { input = 'scrap_metal', output = 'metal', ratio = 2 },   -- 2 zibil = 1 metal
    { input = 'old_cloth', output = 'cloth', ratio = 2 },
    { input = 'broken_wood', output = 'wood', ratio = 2 },
    { input = 'plastic_waste', output = 'plastic', ratio = 3 },
    { input = 'glass_waste', output = 'glass', ratio = 3 },
}

return config