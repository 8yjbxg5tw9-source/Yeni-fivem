fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vr_phone'
description '196RP — Telefon və tətbiqlər (az): zəng/SMS, Kvatter, bank, xəbər, hava, bələdçi'
author '196RP Development'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config/shared.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/social.lua',
    'server/news.lua',
}

client_scripts {
    'client/main.lua',
    'client/apps.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'locales/*.json',
}

dependencies {
    'vr_core',
    'vr_banking',
    'vr_economy',
}
