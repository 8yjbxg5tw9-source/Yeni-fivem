fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vr_environment'
description '196RP — Təbiət/istehsal: dinamik hava, fermerlik, meşəçilik, mədən, elektrik şəbəkəsi'
author '196RP Development'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config/shared.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/weather.lua',
    'server/farming.lua',
    'server/forestry.lua',
    'server/mining.lua',
    'server/powergrid.lua',
}

client_scripts {
    'client/main.lua',
}

dependencies {
    'vr_core',
    'vr_items',
}
