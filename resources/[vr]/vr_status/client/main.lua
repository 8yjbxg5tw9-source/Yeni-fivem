-- ============================================================
-- vr_status — Client: status hesablanması və vizual siqnallar
-- ============================================================

local config = lib.require('config.shared')

local status = {}
for k, v in pairs(config.Defaults) do
    status[k] = v
end

-- === Statusları azalt (dövri) ===
CreateThread(function()
    while true do
        Wait(60 * 1000) -- hər dəqiqə
        for key, rate in pairs(config.DrainPerMinute) do
            status[key] = math.max(0, status[key] - rate)
        end
        -- Serverə sinxron
        for k, v in pairs(status) do
            TriggerServerEvent('vr:status:sync', k, v)
        end
    end
end)

-- === Vizual siqnallar (immersive: crosshair yox, minimal HUD) ===
CreateThread(function()
    while true do
        Wait(3000)
        local player = PlayerPedId()

        -- Susuzluq kritik → ekran solğunluğu
        if status.thirst < config.Critical.thirst then
            SetPedMotionBlur(player, true)
        else
            SetPedMotionBlur(player, false)
        end

        -- Aclıq kritik → zəif yürüş
        if status.hunger < config.Critical.hunger then
            SetPlayerSprint(PlayerId(), false)
        else
            SetPlayerSprint(PlayerId(), true)
        end

        -- Yorğunluq kritik → topallama
        if status.fatigue > config.Critical.fatigue then
            SetPlayerHealthRechargeMultiplier(PlayerId(), 0.5)
        else
            SetPlayerHealthRechargeMultiplier(PlayerId(), 1.0)
        end

        -- Stress kritik → ekran titrəməsi
        if status.stress > config.Critical.stress then
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.3)
        end
    end
end)

-- === Yemək/içmək (inventardan istifadə) ===
exports('consume', function(itemName)
    -- İstifadə olunan əşyaya görə statusu artır
    if itemName == 'water' or itemName == 'soda' then
        status.thirst = math.min(100, status.thirst + 40)
    elseif itemName == 'food' or itemName == 'bread' then
        status.hunger = math.min(100, status.hunger + 40)
    end
end)

-- === Status dəyərini oxu (UI üçün) ===
exports('getStatus', function()
    return status
end)
