fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vr_core'
description '196RP — Velmora Respublikası: Əsas paylaşılan kod və konfiq'
author '196RP Development'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config/shared.lua',
    'locales/az.lua',
}

server_scripts {
    'server/main.lua',
}

client_scripts {
    'client/main.lua',
}

dependencies {
    'ox_lib',
    'qbx_core',
}

-- Lokallaşdırma (100% az)
-- ox_lib locale faylları burada istifadə olunur
