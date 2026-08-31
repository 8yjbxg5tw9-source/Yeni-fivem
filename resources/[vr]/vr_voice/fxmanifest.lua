fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vr_voice'
description '196RP — Səs sistemi: pıçıltı/normal/qışqırıq, radio, səs filtri, headset'
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
    'client/main.lua',
}

dependencies {
    'pma-voice',
    'vr_core',
    'vr_items',
}
