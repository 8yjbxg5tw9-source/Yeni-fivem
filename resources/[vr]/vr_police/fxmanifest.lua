fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vr_police'
description '196RP — Polis: MDT, sübut, ballistika, radar, breathalyzer, impound'
author '196RP Development'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config/shared.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/mdt.lua',
    'server/evidence.lua',
    'server/equipment.lua',
}

client_scripts {
    'client/main.lua',
    'client/equipment.lua',
}

dependencies {
    'vr_core',
    'vr_identity',
    'vr_licenses',
    'vr_vehicles',
}
