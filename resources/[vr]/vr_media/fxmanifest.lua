fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vr_media'
description '196RP — Media: TV canlı efir, radiostansiyalar + DJ, məlumat sızması, reklam lövhələri'
author '196RP Development'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config/shared.lua',
}

server_scripts {
    'server/broadcast.lua',
    'server/radio.lua',
    'server/leaks.lua',
    'server/billboards.lua',
}

client_scripts {
    'client/main.lua',
}

dependencies {
    'vr_core',
    'vr_phone',
}
