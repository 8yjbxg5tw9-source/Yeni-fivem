fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vr_mail'
description '196RP — Poçt: məktub/bağlama, poçt fırıldağı riski'
author '196RP Development'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
}

server_scripts {
    'server/main.lua',
}

dependencies {
    'vr_core',
    'vr_items',
}
