fx_version 'cerulean'
game 'gta5'

author 'YourName'
description 'ESX Admin Menu'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/server.lua'
}

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

ui_page 'html/index.html'

dependencies {
    'es_extended',
    'jail_time'  -- Add this to ensure proper loading order
}
