fx_version('bodacious')
game('gta5')

dependency('sFramework')

server_scripts {
	'@sFramework/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'server/main.lua'
}

--client_script('@korioz/lib.lua')
client_scripts {
	'@sCore/Anticheat/shared/config.lua',
	'@sCore/Anticheat/client/checkResource.lua',
	
	'@sFramework/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'client/main.lua'
}







