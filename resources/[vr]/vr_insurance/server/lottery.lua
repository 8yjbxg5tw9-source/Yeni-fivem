-- ============================================================
-- vr_insurance — Dövlət Lotereyası (həftəlik tiraj — pul sink + IC mövzu)
-- ============================================================

local config = lib.require('config.shared')

local jackpot = config.Lottery.jackpotStart
local tickets = {} -- { citizenid, number }

-- === Bilet al ===
lib.callback.register('vr:lottery:buyTicket', function(source)
    local player = qbx.getPlayer(source)
    if not player then return false end
    local bank = exports.vr_banking:getBalance(player.PlayerData.citizenid)
    if bank < config.Lottery.ticketPrice then return false, 'Kifayət qədər pul yoxdur' end

    exports.vr_banking:removeBankMoney(player.PlayerData.citizenid, config.Lottery.ticketPrice, 'lotereya-bilet')

    -- Biletin 50%-i cekpota əlavə olunur (pul sink)
    jackpot = jackpot + math.floor(config.Lottery.ticketPrice / 2)

    local number = math.random(100000, 999999)
    tickets[#tickets + 1] = { citizenid = player.PlayerData.citizenid, number = number }
    return true, number
end)

-- === Həftəlik tiraj ===
local function draw()
    if #tickets == 0 then
        -- Cekpot növbəti həftəyə keçir
        TriggerEvent('vr:lottery:rolled', nil, jackpot)
        return
    end
    local winner = tickets[math.random(1, #tickets)]
    -- Qalibə cekpot
    TriggerEvent('vr:lottery:winner', winner.citizenid, jackpot)
    -- Cekpot sıfırlanır
    jackpot = config.Lottery.jackpotStart
    tickets = {}
end

CreateThread(function()
    while true do
        Wait(config.Lottery.drawIntervalHours * 60 * 60 * 1000)
        draw()
    end
end)

-- === Cekpot balansı ===
lib.callback.register('vr:lottery:getJackpot', function(source)
    return jackpot
end)

print('[vr_insurance] Dövlət lotereyası aktivdir.')
