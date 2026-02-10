fx_version 'bodacious'
game 'gta5'
lua54 'yes'
author 'PixelPrecision'

version '1.0.0'

description 'Adjust Animation'

server_scripts {
    'config.lua',
    'server.lua' -- NEW: Add server script
}

client_scripts {
    'config.lua',
    'client.lua'
}

shared_scripts {
    '@ox_lib/init.lua'
}

ui_page 'index.html'

files {
    'index.html'
}
