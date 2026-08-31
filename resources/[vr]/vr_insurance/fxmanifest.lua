fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vr_insurance'
description '196RP — Sığorta şirkəti və dövlət lotereyası'
author '196RP Development'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config/shared.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/insurance.lua',
    'server/lottery.lua',
}

dependencies {
    'vr_core',
    'vr_economy',
}
