fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vr_whitelist'
description '196RP — Whitelist girişi və vətəndaşlıq səviyyələri'
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
    'vr_identity',
}
