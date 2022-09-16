Config = {}
Config.Locale = 'fr'

Config.DefaultGroup = 'user'
Config.DefaultLevel = '0'
Config.CommandPrefix = '/'
Config.DefaultPosition = vector3(-883.16778564453,-432.07543945313,39.599884033203)

Config.Accounts = {
	['cash'] = {
		label = _U('cash'),
		starting = 2000,
		priority = 1
	},
	['dirtycash'] = {
		label = _U('dirtycash'),
		starting = 0,
		priority = 2
	},
	['bank'] = {
		label = _U('bank'),
		starting = 0,
		priority = 3
	},
	['chip'] = {
		label = 'Jetons Casino',
		starting = 0,
		priority = 4
	}
}

Config.EnableSocietyPayouts = true
Config.PaycheckInterval = 60 * 60 * 1000
Config.MaxWeight = 45