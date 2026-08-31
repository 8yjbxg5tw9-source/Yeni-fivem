fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vr_items'
description '196RP — Əşya metadata: keyfiyyət, seriya №, mülkiyyət izi, durability'
author '196RP Development'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config/shared.lua',
}

server_scripts {
    'server/main.lua',
}

dependencies {
    'vr_core',
    'ox_inventory',
}
