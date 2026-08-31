fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'vr_government'
description '196RP — Dövlət: bələdiyyə, vergi-gömrük, seçki, notariat, tender'
author '196RP Development'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config/shared.lua',
}

server_scripts {
    'server/tax.lua',
    'server/election.lua',
    'server/notary.lua',
}

dependencies {
    'vr_core',
    'vr_economy',
    'vr_companies',
}
