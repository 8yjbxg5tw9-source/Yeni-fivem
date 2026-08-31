-- ============================================================
-- vr_phone — Client: telefon açılışı, NUI ilə əlaqə
-- ============================================================

local phoneOpen = false

-- Telefonu aç/bağla
local function togglePhone()
    phoneOpen = not phoneOpen
    SetNuiFocus(phoneOpen, phoneOpen)
    SendNUIMessage({ action = 'setVisible', visible = phoneOpen })
end

exports('togglePhone', togglePhone)

-- Keybind (yenidən təyin oluna bilər)
lib.addKeybind({
    name = 'vr_phone_open',
    description = 'Telefonu aç/bağla',
    defaultKey = 'M',
    onPressed = function() togglePhone() end,
})

-- NUI-dan gələn sorğuları serverə ötür
RegisterNUICallback('getNumber', function(_, cb)
    cb(lib.callback.await('vr:phone:getNumber', false))
end)

RegisterNUICallback('sendMessage', function(data, cb)
    cb(lib.callback.await('vr:phone:sendMessage', false, data.to, data.body))
end)

RegisterNUICallback('getMessages', function(_, cb)
    cb(lib.callback.await('vr:phone:getMessages', false))
end)

RegisterNUICallback('getContacts', function(_, cb)
    cb(lib.callback.await('vr:phone:getContacts', false))
end)

RegisterNUICallback('addContact', function(data, cb)
    cb(lib.callback.await('vr:phone:addContact', false, data.name, data.number))
end)

RegisterNUICallback('postKvatter', function(data, cb)
    cb(lib.callback.await('vr:phone:postKvatter', false, data.body, data.image))
end)

RegisterNUICallback('getKvatter', function(_, cb)
    cb(lib.callback.await('vr:phone:getKvatter', false))
end)

RegisterNUICallback('getNews', function(_, cb)
    cb(lib.callback.await('vr:phone:getNews', false))
end)

RegisterNUICallback('getBalance', function(_, cb)
    cb(lib.callback.await('vr:banking:getBalance', false))
end)

RegisterNUICallback('close', function(_, cb)
    phoneOpen = false
    SetNuiFocus(false, false)
    cb(true)
end)

-- Escape ilə bağla
CreateThread(function()
    while true do
        Wait(0)
        if phoneOpen and IsControlJustPressed(0, 322) then -- ESC
            togglePhone()
        end
    end
end)
