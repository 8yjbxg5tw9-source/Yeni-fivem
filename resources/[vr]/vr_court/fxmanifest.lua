fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vr_court'
description '196RP — Məhkəmə: işlər, docket, 3 instansiya, münsiflər, transkript'
author '196RP Development'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config/shared.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

client_scripts {
    'client/main.lua',
}

dependencies {
    'vr_core',
    'vr_identity',
    'vr_licenses',
}
