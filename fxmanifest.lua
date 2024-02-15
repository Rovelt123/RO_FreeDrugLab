fx_version 'cerulean'
game 'gta5'
author 'Rovelt'
description "Rovelt's lab script!"

this_is_a_map 'yes'

shared_scripts {
    'Config.lua',
    '@ox_lib/init.lua'
}

client_scripts{
    'Client/*.lua',
}

escrow_ignore {
    'Config.lua',
    'Server/Shared.lua',
    'Client/Shared.lua',
    'labs.sql'
}

server_scripts{
    'Server/*.lua',
    '@oxmysql/lib/MySQL.lua',
}



lua54 'yes'