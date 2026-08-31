fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vr_prison'
description '196RP — Həbsxana: içəri iqtisadiyyat, parole, bail, konvoy'
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
    'vr_police',
    'vr_court',
}
