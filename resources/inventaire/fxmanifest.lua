fx_version 'adamant'
games { 'rdr3', 'gta5' }

ui_page 'html/ui.html'

client_scripts {
  "client/*.lua",
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server/*.lua',
}

files {
  'html/ui.html',
  'html/css/ui.css',
  'html/css/jquery-ui.css',
  'html/js/inventory.js',
  'html/js/config.js',
  'html/locales/fr.js',
  'html/img/*.png',
  'html/img/items/*.png',
}

exports {
	"GetStateInventory",
  "GetFastWeaponsChasse",
  "ResetWeaponSlots"
}