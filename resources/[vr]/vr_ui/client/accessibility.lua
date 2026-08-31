-- ============================================================
-- vr_ui — Əlçatanlıq: rəngkor rejimi, böyük şrift
-- ============================================================

local settings = {
    colorblind = false,
    largeFont = false,
}

-- === Rəngkor rejimi (rəng palitrasını dəyişir) ===
local function applyColorblind(enabled)
    if enabled then
        -- Deuteranopia (qırmızı-yaşıl) üçün palitra
        SetResourceKvp('vr_ui_colorblind', 'true')
        lib.notify({ title = 'Əlçatanlıq', description = 'Rəngkor rejimi aktivdir.', type = 'inform' })
    else
        SetResourceKvp('vr_ui_colorblind', 'false')
    end
end

-- === Böyük şrift rejimi (NUI font ölçüsü) ===
local function applyLargeFont(enabled)
    SetResourceKvp('vr_ui_largefont', tostring(enabled))
    SendNUIMessage({ action = 'setFontScale', scale = enabled and 1.25 or 1.0 })
    lib.notify({ title = 'Əlçatanlıq', description = enabled and 'Böyük şrift aktivdir.' or 'Normal şrift bərpa edildi.', type = 'inform' })
end

-- === Menyu ===
lib.addKeybind({
    name = 'vr_accessibility',
    description = 'Əlçatanlıq menyusu',
    defaultKey = 'F8',
    onPressed = function()
        local options = {
            {
                title = settings.colorblind and 'Rəngkor rejimi: AÇIQ' or 'Rəngkor rejimi: BAĞLI',
                onSelect = function()
                    settings.colorblind = not settings.colorblind
                    applyColorblind(settings.colorblind)
                end,
            },
            {
                title = settings.largeFont and 'Böyük şrift: AÇIQ' or 'Böyük şrift: BAĞLI',
                onSelect = function()
                    settings.largeFont = not settings.largeFont
                    applyLargeFont(settings.largeFont)
                end,
            },
        }
        lib.registerContext({ id = 'vr_accessibility', title = 'Əlçatanlıq', options = options })
        lib.showContext('vr_accessibility')
    end,
})

-- Yüklənmədə qaynaqlanmış dəyərləri bərpa et
CreateThread(function()
    settings.colorblind = GetResourceKvpString('vr_ui_colorblind') == 'true'
    settings.largeFont = GetResourceKvpString('vr_ui_largefont') == 'true'
end)
