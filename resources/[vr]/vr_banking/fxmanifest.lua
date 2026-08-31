fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vr_banking'
description '196RP — Bank: hesablar, köçürmə, əmanət faizi, kredit'
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
    'vr_identity',
}
