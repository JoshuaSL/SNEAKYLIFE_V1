fx_version 'adamant'
games { 'gta5' }

this_is_a_map 'yes'

client_scripts {
  'config.lua',
  "client/*.lua",
}

server_scripts {
  "@mysql-async/lib/MySQL.lua",
  'config.lua',
  "server/*.lua",
}

ui_page 'ui/ui.html'
files {
  'ui/ui.html',
  'ui/css/app.css',
  "ui/input.css",
  'ui/web.js',
}