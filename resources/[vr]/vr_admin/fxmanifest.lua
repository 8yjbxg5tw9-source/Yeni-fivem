fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vr_admin'
description '196RP — Admin alətləri + audit log'
author '196RP Development'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config/shared.lua',
}

server_scripts {
    'server/audit.lua',
    'server/main.lua',
    'server/tools.lua',
}

client_scripts {
    'client/main.lua',
}

dependencies {
    'vr_core',
    'vr_identity',
}
