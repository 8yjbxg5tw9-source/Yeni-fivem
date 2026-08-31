fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vr_crafting'
description '196RP — Crafting: mebel, qida, alət, paltar; resayklinq iqtisadiyyatı'
author '196RP Development'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config/shared.lua',
}

server_scripts {
    'server/main.lua',
    'server/recycling.lua',
}

client_scripts {
    'client/main.lua',
}

dependencies {
    'vr_core',
    'vr_items',
    'ox_inventory',
}
