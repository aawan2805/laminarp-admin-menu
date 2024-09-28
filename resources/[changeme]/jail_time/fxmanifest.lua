fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'Jail Countdown Feature'
version '1.0.0'

files {
    'html/jailedCountdown.html',
    'html/style.css',
    'html/jailedCountDown.js'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
}

ui_page 'html/jailedCountdown.html'

client_script 'client.lua'
server_script 'server.lua'
