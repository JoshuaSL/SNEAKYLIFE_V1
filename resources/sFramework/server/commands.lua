-- COMMAND HANDLER --
AddEventHandler('chatMessage', function(source, author, message)
	if (message):find(Config.CommandPrefix) ~= 1 then
		return
	end

	local commandArgs = ESX.StringSplit(((message):sub((Config.CommandPrefix):len() + 1)), ' ')
	local commandName = (table.remove(commandArgs, 1)):lower()
	local command = ESX.Commands[commandName]

	if command then
		CancelEvent()
		local xPlayer = ESX.GetPlayerFromId(source)

		if command.group ~= nil then
			if ESX.Groups[xPlayer.getGroup()]:canTarget(ESX.Groups[command.group]) then
				if (command.arguments > -1) and (command.arguments ~= #commandArgs) then
					TriggerEvent("esx:incorrectAmountOfArguments", source, command.arguments, #commandArgs)
				else
					command.callback(source, commandArgs, xPlayer)
				end
			else
				ESX.ChatMessage(source, 'Permissions Insuffisantes !')
			end
		else
			if (command.arguments > -1) and (command.arguments ~= #commandArgs) then
				TriggerEvent("esx:incorrectAmountOfArguments", source, command.arguments, #commandArgs)
			else
				command.callback(source, commandArgs, xPlayer)
			end
		end
	end
end)

function ESX.AddCommand(command, callback, suggestion, arguments)
	ESX.Commands[command] = {}
	ESX.Commands[command].group = nil
	ESX.Commands[command].callback = callback
	ESX.Commands[command].arguments = arguments or -1

	if type(suggestion) == 'table' then
		if type(suggestion.params) ~= 'table' then
			suggestion.params = {}
		end

		if type(suggestion.help) ~= 'string' then
			suggestion.help = ''
		end

		table.insert(ESX.CommandsSuggestions, {name = ('%s%s'):format(Config.CommandPrefix, command), help = suggestion.help, params = suggestion.params})
	end
end

function ESX.AddGroupCommand(command, group, callback, suggestion, arguments)
	ESX.Commands[command] = {}
	ESX.Commands[command].group = group
	ESX.Commands[command].callback = callback
	ESX.Commands[command].arguments = arguments or -1

	if type(suggestion) == 'table' then
		if type(suggestion.params) ~= 'table' then
			suggestion.params = {}
		end

		if type(suggestion.help) ~= 'string' then
			suggestion.help = ''
		end

		table.insert(ESX.CommandsSuggestions, {name = ('%s%s'):format(Config.CommandPrefix, command), help = suggestion.help, params = suggestion.params})
	end
end

-- SCRIPT --
ESX.AddGroupCommand('devinfo', '_dev', function(source, args, user)
	ESX.ChatMessage(source, "^2[^5SneakyLife^7]^0 Groups: ^2 " .. (ESX.Table.SizeOf(ESX.Groups) - 1))
	ESX.ChatMessage(source, "^2[^5SneakyLife^7]^0 Commands loaded: ^2 " .. (ESX.Table.SizeOf(ESX.Commands) - 1))
end)

ESX.AddGroupCommand('pos', '_dev', function(source, args, user)
	local x, y, z = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
	
	if x and y and z then
		TriggerClientEvent('esx:teleport', source, vector3(x, y, z))
	else
		ESX.ChatMessage(source, "Invalid coordinates!")
	end
end, {help = "Teleport to coordinates", params = {
	{name = "x", help = "X coords"},
	{name = "y", help = "Y coords"},
	{name = "z", help = "Z coords"}
}})

ESX.AddGroupCommand('setjob', 'superadmin', function(source, args, user)
	if tonumber(args[1]) and args[2] and tonumber(args[3]) then
		local xPlayer = ESX.GetPlayerFromId(args[1])

		if xPlayer then
			if ESX.DoesJobExist(args[2], args[3]) then
				xPlayer.setJob(args[2], args[3])
			else
				ESX.ChatMessage(source, 'That job does not exist.')
			end
		else
			ESX.ChatMessage(source, 'Player not online.')
		end
	else
		ESX.ChatMessage(source, 'Invalid usage.')
	end
end, {help = 'Assigner un job', params = {
	{name = "playerId", help = 'Identification du joueur'},
	{name = "job", help = 'Le travail que vous souhaitez assigner'},
	{name = "grade_id", help = 'Le grade'}
}})

ESX.AddGroupCommand('setjob2', 'superadmin', function(source, args, user)
	if tonumber(args[1]) and args[2] and tonumber(args[3]) then
		local xPlayer = ESX.GetPlayerFromId(args[1])

		if xPlayer then
			if ESX.DoesJobExist(args[2], args[3]) then
				xPlayer.setJob2(args[2], args[3])
			else
				ESX.ChatMessage(source, 'That job does not exist.')
			end
		else
			ESX.ChatMessage(source, 'Player not online.')
		end
	else
		ESX.ChatMessage(source, 'Invalid usage.')
	end
end, {help = 'Assigner un job', params = {
	{name = "playerId", help = 'Identification du joueur'},
	{name = "job2", help = 'Le travail que vous souhaitez assigner'},
	{name = "grade_id", help = 'Le grade'}
}})

ESX.AddGroupCommand('car', 'superadmin', function(source, args, user)
	TriggerClientEvent('esx:spawnVehicle', source, args[1])
end, {help = 'Spawn un véhicule', params = {
	{name = "car", help = 'Nom de la voiture'}
}})

ESX.AddGroupCommand('dv', 'admin', function(source, args, user)
	TriggerClientEvent('esx:deleteVehicle', source, args[1])
end, {help = 'supprimer le véhicule', params = {
	{name = 'radius', help = 'Optional, delete every vehicle within the specified radius'}
}})

ESX.AddGroupCommand('giveitem', 'superadmin', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(args[1])

	if xPlayer then
		local item = args[2]
		local count = tonumber(args[3])

		if count then
			if ESX.Items[item] then
				xPlayer.addInventoryItem(item, count)
			else
				xPlayer.showNotification('~r~Erreur~s~\nItem invalide')
			end
		else
			xPlayer.showNotification(_U('invalid_amount'))
		end
	else
		ESX.ChatMessage(source, 'Player not online.')
	end
end, {help = 'Donner un item', params = {
	{name = "playerId", help = 'Identification du joueur'},
	{name = "item", help = "Item"},
	{name = "amount", help = 'quantité'}
}})

ESX.AddGroupCommand('giveweapon', 'superadmin', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(args[1])

	if xPlayer then
		local weaponName = args[2] or 'unknown'

		if ESX.GetWeapon(weaponName) then
			if xPlayer.hasWeapon(weaponName) then
				ESX.ChatMessage(source, 'Player already has that weapon.')
			else
				xPlayer.addWeapon(weaponName, tonumber(args[3]))
				ESX.SavePlayer(xPlayer, function(cb) end)
			end
		else
			ESX.ChatMessage(source, 'Invalid weapon.')
		end
	else
		ESX.ChatMessage(source, 'Player not online.')
	end
end, {help = 'Donner l\'arme', params = {
	{name = "playerId", help = 'Identification du joueur'},
	{name = "weaponName", help = 'Arme'},
	{name = "ammo", help = 'nombre de munitions'}
}})

ESX.AddGroupCommand('giveweaponcomponent', 'superadmin', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(args[1])

	if xPlayer then
		local weaponName = args[2] or 'unknown'

		if ESX.GetWeapon(weaponName) then
			if xPlayer.hasWeapon(weaponName) then
				local component = ESX.GetWeaponComponent(weaponName, args[3] or 'unknown')

				if component then
					if xPlayer.hasWeaponComponent(weaponName, args[3]) then
						ESX.ChatMessage(source, 'Player already has that weapon component.')
					else
						xPlayer.addWeaponComponent(weaponName, args[3])
					end
				else
					ESX.ChatMessage(source, 'Invalid weapon component.')
				end
			else
				ESX.ChatMessage(source, 'Player does not have that weapon.')
			end
		else
			ESX.ChatMessage(source, 'Invalid weapon.')
		end
	else
		ESX.ChatMessage(source, 'Player not online.')
	end
end, {help = 'Give weapon component', params = {
	{name = 'playerId', help = 'Identification du joueur'},
	{name = 'weaponName', help = "Arme"},
	{name = 'componentName', help = 'weapon component'}
}})

ESX.AddGroupCommand('chatclear', 'admin', function(source, args, user)
	TriggerEvent("ratelimit", source, "chatclear")
	TriggerClientEvent('chat:clear', -1)
end, {help = 'Supprime le chat pour tout le monde'})

ESX.AddGroupCommand('clearinventory', 'superadmin', function(source, args, user)
	local xPlayer

	if args[1] then
		xPlayer = ESX.GetPlayerFromId(args[1])
	else
		xPlayer = ESX.GetPlayerFromId(source)
	end

	if xPlayer then
		for i = 1, #xPlayer.inventory, 1 do
			if xPlayer.inventory[i].count > 0 then
				xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
			end
		end
	else
		ESX.ChatMessage(source, 'Player not online.')
	end
end, {help = 'Effacer tout les items de l\'inventaire', params = {
	{name = "playerId", help = 'Spécifiez un playerid ou laissez vide pour vous-même'}
}})

ESX.AddGroupCommand('clearloadout', 'superadmin', function(source, args, user)
	local xPlayer

	if args[1] then
		xPlayer = ESX.GetPlayerFromId(args[1])
	else
		xPlayer = ESX.GetPlayerFromId(source)
	end

	if xPlayer then
		for i = #xPlayer.loadout, 1, -1 do
			xPlayer.removeWeapon(xPlayer.loadout[i].name)
		end
	else
		ESX.ChatMessage(source, 'Player not online.')
	end
end, {help = 'Retirer toutes les armes de l\'équipement', params = {
	{name = "playerId", help = 'Spécifiez un playerid ou laissez vide pour vous-même'}
}})

RegisterCommand("refreshjobs", function(source)
	if source ~= 0 then return end
	ESX.Jobs = {}
	MySQL.Async.fetchAll('SELECT * FROM jobs', {}, function(result)
		for i = 1, #result do
			ESX.Jobs[result[i].name] = result[i]
			ESX.Jobs[result[i].name].grades = {}
		end
	
		MySQL.Async.fetchAll('SELECT * FROM job_grades', {}, function(result2)
			for i = 1, #result2 do
				if ESX.Jobs[result2[i].job_name] then
					ESX.Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
				else
					print(('[^3WARNING^7] Invalid job "%s" from table job_grades ignored'):format(result2[i].job_name))
				end
			end
		
			for k, v in pairs(ESX.Jobs) do
				if ESX.Table.SizeOf(v.grades) == 0 then
					ESX.Jobs[v.name] = nil
					print(('[^3WARNING^7] Ignoring job "%s" due to missing job grades'):format(v.name))
				end
			end
		end)
	end)
end)