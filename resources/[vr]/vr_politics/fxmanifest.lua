fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vr_politics'
description '196RP — Siyasi: parlament, referendum, mitinq, impichment, tender, bəyannamə'
author '196RP Development'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config/shared.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/parliament.lua',
    'server/rally.lua',
    'server/impeachment.lua',
    'server/tenders.lua',
    'server/declarations.lua',
}

dependencies {
    'vr_core',
    'vr_government',
    'vr_economy',
}
