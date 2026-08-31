fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vr_emotes'
description '196RP — Emote/animasiya paketi (az)'
author '196RP Development'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config/shared.lua',
}

client_scripts {
    'client/main.lua',
}

dependencies {
    'vr_core',
    'ox_lib',
}
