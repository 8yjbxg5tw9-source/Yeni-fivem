fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vr_property'
description '196RP — Əmlak: alqı-satqı, kirayə, ipoteka, mebel, kommunal'
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

dependencies {
    'vr_core',
    'vr_economy',
    'vr_banking',
}
