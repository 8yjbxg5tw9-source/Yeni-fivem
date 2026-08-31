fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vr_academy'
description '196RP — RP Akademiya (IC kampus): qaydalar, idarəetmə, ilk iş, peşə kursları'
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
    'vr_core',
    'vr_licenses',
    'vr_jobs',
}
