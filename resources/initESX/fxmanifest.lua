fx_version('bodacious')
game('gta5')


ui_page('html/ui.html')

files({
	'html/ui.html',
	'html/css/app.css',
	'html/scripts/app.js'
})


client_scripts {
	'@sFramework/locale.lua',
	"client/classes/*.lua",
	"client/*.lua",
}

server_scripts {
	'@sFramework/server/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'server/classes/*.lua',
	'server/*.lua',
}

dependency('sFramework')







