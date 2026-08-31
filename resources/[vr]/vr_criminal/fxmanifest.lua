fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vr_criminal'
description '196RP — Kriminal: dəstələr, soyğun pilləsi, qara bazar, qaçaqmalçılıq, pul yuma'
author '196RP Development'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config/shared.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/gangs.lua',
    'server/heists.lua',
    'server/blackmarket.lua',
    'server/moneylaundering.lua',
    'server/smuggling.lua',
    'server/weaponcraft.lua',
    'server/fakedocs.lua',
    'server/cartheft.lua',
    'server/cybercrime.lua',
}

client_scripts {
    'client/main.lua',
}

dependencies {
    'vr_core',
    'vr_economy',
    'vr_vehicles',
    'vr_items',
    'vr_police',
}
