fx_version('bodacious')
game('gta5')

server_scripts({
	'@mysql-async/lib/MySQL.lua',

	'locale.lua',
	'locales/fr.lua',

	'config.lua',
	'config.weapons.lua',

	'server/common.lua',
	'server/classes/groups.lua',
	'server/classes/player.lua',
	'server/functions.lua',
	'server/paycheck.lua',
	'server/main.lua',
	'server/commands.lua',
	'server/async.lua',
	'common/modules/math.lua',
	'common/modules/table.lua',
	'common/functions.lua'
})

client_scripts({
	'locale.lua',
	'locales/fr.lua',

	'config.lua',
	'config.weapons.lua',
	'client/common.lua',
	'client/entityiter.lua',
	'client/functions.lua',
	'client/wrapper.lua',
	'client/main.lua',

	'client/modules/death.lua',
	'client/modules/scaleform.lua',
	'client/modules/streaming.lua',

	'common/modules/math.lua',
	'common/modules/table.lua',
	'common/functions.lua'
})

ui_page "ui/index.html"
files {
	"ui/index.html",
	"ui/assets/test.png",
	"ui/assets/hunger.svg",
	"ui/assets/thirst.svg",
	"ui/assets/inventory.svg",
	"ui/assets/battery.svg",
	"ui/assets/reseau.svg",
	"ui/fonts/fonts/Circular-Bold.ttf",
	"ui/fonts/fonts/Circular-Bold.ttf",
	"ui/fonts/fonts/Circular-Regular.ttf",
	"ui/script.js",
	"ui/style.css",
	"ui/debounce.min.js",
	'ui/img/bank.png',
	'ui/img/dirtymoney.png',
	'ui/img/money.png',
}


-- Client Scripts
client_scripts {
    'client.lua',
}

server_exports {
	"onSavedPlayer"
}

dependencies({
	'mysql-async'
})







