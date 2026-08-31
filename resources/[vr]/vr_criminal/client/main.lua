-- ============================================================
-- vr_criminal — Client: minigame-lər (lockpick, hack, termit)
-- ============================================================

local config = lib.require('config.shared')

-- === Lockpick minigame (skill) ===
exports('lockpick', function(difficulty)
    local success = lib.skillCheck({ difficulty = { difficulty or 1, 5 } })
    return success
end)

-- === Hack minigame ===
exports('hack', function(difficulty)
    -- ox_lib skillCheck-in hack variantı (real istehsalda ox_lib hacking modulu)
    local success = lib.skillCheck({ difficulty = { difficulty or 2, 5 } })
    return success
end)

-- === Termit minigame ===
exports('thermite', function(difficulty)
    local success = lib.skillCheck({ difficulty = { difficulty or 3, 5 } })
    return success
end)

-- === Soyğun minigame ardıcıllığı ===
exports('runHeistMinigame', function(tierId)
    local tier
    for _, t in ipairs(config.HeistTiers) do
        if t.id == tierId then tier = t break end
    end
    if not tier then return false end

    -- Pilləyə görə minigame çətinliyi
    local diff = tier.minRep + 1
    local success = lib.skillCheck({ difficulty = { diff, 10 } })
    return success
end)

print('[vr_criminal] Client aktivdir.')
