fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vr_ui'
description '196RP — HUD, ölüm ekranı, əlçatanlıq (rəngkor/böyük şrift)'
author '196RP Development'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config/shared.lua',
}

server_scripts {
    'server/main.lua',
}

client_scripts {
    'client/accessibility.lua',
    'client/hud.lua',
}

dependencies {
    'vr_core',
    'vr_status',
}
