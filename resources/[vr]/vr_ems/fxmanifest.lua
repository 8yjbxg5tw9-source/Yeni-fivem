fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vr_ems'
description '196RP — Təcili Tibbi Xidmət: yaralar, qan bankı, asılılıq, reanimasiya'
author '196RP Development'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config/shared.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/blood.lua',
}

client_scripts {
    'client/main.lua',
}

dependencies {
    'vr_core',
    'vr_identity',
}
