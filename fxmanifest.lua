fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'Lithe Enanched Drug System'
description 'Advanced Drug System'
author 'Andree / Lithe HUB'
version 'Beta'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
}

files {
    'assets/*.png',
}

client_scripts {
    'config.lua',
    'client/*.lua',
}

server_scripts {
    'config.lua',
    'server/*.lua',
}


dependency {
	'ox_lib',
	'es_extended',
}