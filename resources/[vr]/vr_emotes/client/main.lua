-- ============================================================
-- vr_emotes — Client: emote oynatma və menyu
-- ============================================================

local config = lib.require('config.shared')

local function playEmote(emote)
    local ped = PlayerPedId()
    lib.requestAnimDict(emote.dict)
    TaskPlayAnim(ped, emote.dict, emote.anim, 8.0, -8.0, -1, 0, 0, false, false, false)
end

exports('playEmote', playEmote)

-- Emote menyusu (yenidən təyin oluna bilən düymə ilə açılır)
local function openEmoteMenu()
    local options = {}
    for _, e in ipairs(config.List) do
        options[#options + 1] = {
            title = e.label,
            onSelect = function() playEmote(e) end,
        }
    end
    options[#options + 1] = {
        title = 'Emote dayandır',
        onSelect = function() ClearPedTasks(PlayerPedId()) end,
    }
    lib.registerContext({ id = 'vr_emotes', title = 'Emote-lar', options = options })
    lib.showContext('vr_emotes')
end

lib.addKeybind({
    name = 'vr_emotes_menu',
    description = 'Emote menyusu',
    defaultKey = 'B',
    onPressed = openEmoteMenu,
})
