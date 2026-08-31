fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vr_identity'
description '196RP — Personaj, VRN, şəxsi profil, barber/tatu/plastik cərrahiyyə'
author '196RP Development'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config/shared.lua',
}

server_scripts {
    'server/main.lua',
    'server/civil.lua',
}

client_scripts {
    'client/main.lua',
}

dependencies {
    'vr_core',
}
