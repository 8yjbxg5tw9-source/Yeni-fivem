fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vr_companies'
description '196RP — Şirkətlər: işçi, maaş, müqavilə, stok, səhm, reyestr'
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
    'vr_economy',
    'vr_banking',
    'vr_licenses',
}
