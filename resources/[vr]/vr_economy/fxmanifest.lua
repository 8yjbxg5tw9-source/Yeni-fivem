fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vr_economy'
description '196RP — İqtisadiyyat: dövlət büdcəsi, xəzinə, birja, dinamik qiymətlər, inflyasiya'
author '196RP Development'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config/shared.lua',
}

server_scripts {
    'server/budget.lua',
    'server/stockmarket.lua',
    'server/prices.lua',
}

dependencies {
    'vr_core',
    'vr_banking',
}
