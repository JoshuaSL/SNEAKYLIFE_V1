ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local authorizeJob = {
    ["police"] = {label = "Police"},
    ["lssd"] = {label = "Lssd"},
    ["gouvernement"] = {label = "Gouvernement"},
	["fbi"] = {label = "Federal Bureau of Investigation"}
}

Citizen.CreateThread(function()
    for k,v in pairs(authorizeJob) do
        TriggerEvent('Sneakyesx_phone:registerNumber', k, 'Alerte '..v.label, true, true)
        TriggerEvent('Sneakyesx_society:registerSociety', k, v.label, 'society_'..k, 'society_'..k, 'society_'..k, {type = 'public'})
    end
end)

RegisterServerEvent("sPolice:addLicense")
AddEventHandler("sPolice:addLicense", function(target, license)
	local _src = source
	TriggerEvent("ratelimit", _src, "sPolice:addLicense")
	if source then
		local xPlayer, tPlayer = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(target)
		if authorizeJob[xPlayer.job.name] == nil then
			banPlayerAC(xPlayer.source, {
				name = "changestateuser",
				title = "Anticheat : add license police",
				description = "Anticheat : add license police"
			})
			return 
		end
		TriggerEvent('Sneakyesx_license:addLicense', target, license, function()
			TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous avez donné le ~y~permis port d'armes~s~ à ~b~"..tPlayer.getName())
			TriggerClientEvent("esx:showNotification", tPlayer.source, "~b~"..xPlayer.getName().."~s~ vous a attribué le ~y~permis port d'armes~s~ !")
		end)
	end
end)

RegisterServerEvent("Sneaky:Message")
AddEventHandler("Sneaky:Message", function(job,msg)
	local _src = source
	TriggerEvent("ratelimit", _src, "Sneaky:Message")
	if source then
		local xPlayer, tPlayer = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(target)
		if authorizeJob[xPlayer.job.name] == nil then
			banPlayerAC(xPlayer.source, {
				name = "changestateuser",
				title = "Anticheat : message police",
				description = "Anticheat : message police"
			})
			return 
		end
		TriggerClientEvent("Sneaky:ClientMessage", -1, job, msg)
	end
end)

RegisterServerEvent('sPolice:addWeapon')
AddEventHandler('sPolice:addWeapon', function(weaponName)
	local _src = source
	TriggerEvent("ratelimit", _src, "sPolice:addWeapon")
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if authorizeJob[xPlayer.job.name] == nil then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : add weapon police",
			description = "Anticheat : add weapon police"
		})
		return 
	end
	xPlayer.addWeapon(weaponName, 250)
	if weaponName == "WEAPON_COMBATPISTOL" or weaponName == "WEAPON_SHOTGUN" or weaponName == "WEAPON_COMBATPDW" or weaponName == "WEAPON_CARBINERIFLE" then
		xPlayer.addWeaponComponent(weaponName, 'flashlight')
	end
	TriggerClientEvent('esx:showNotification', _source, "Vous avez emprunté une arme : ~b~"..ESX.GetWeaponLabel(weaponName))
end)

RegisterServerEvent('sPolice:removeWeapons')
AddEventHandler('sPolice:removeWeapons', function()
	local _src = source
	TriggerEvent("ratelimit", _src, "sPolice:removeWeapons")
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if authorizeJob[xPlayer.job.name] == nil then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : remove weapon police",
			description = "Anticheat : remove weapon police"
		})
		return 
	end
	local lamp = "flashlight"
	local lampweapon = xPlayer.getWeapon('WEAPON_FLASHLIGHT')
	local matraque = xPlayer.getWeapon('WEAPON_NIGHTSTICK')
	local tazer = xPlayer.getWeapon('WEAPON_STUNGUN')
	local combatpistol = xPlayer.getWeapon('WEAPON_COMBATPISTOL')
	local shotgun = xPlayer.getWeapon('WEAPON_PUMPSHOTGUN')
	local combatpdw = xPlayer.getWeapon('WEAPON_COMBATPDW')
	local carabinerifle = xPlayer.getWeapon('WEAPON_CARBINERIFLE')
	if lampweapon then
		xPlayer.removeWeapon('WEAPON_FLASHLIGHT')
		TriggerClientEvent('esx:showNotification', _source, "Vous avez rendu une arme : ~b~"..ESX.GetWeaponLabel('WEAPON_FLASHLIGHT'))
	end
	if matraque then
		xPlayer.removeWeapon('WEAPON_NIGHTSTICK')
		TriggerClientEvent('esx:showNotification', _source, "Vous avez rendu une arme : ~b~"..ESX.GetWeaponLabel('WEAPON_NIGHTSTICK'))
	end
	if tazer then
		xPlayer.removeWeapon('WEAPON_STUNGUN')
		TriggerClientEvent('esx:showNotification', _source, "Vous avez rendu une arme : ~b~"..ESX.GetWeaponLabel('WEAPON_STUNGUN'))
	end
	if combatpistol then
		xPlayer.removeWeapon('WEAPON_COMBATPISTOL')
		if xPlayer.hasWeaponComponent("WEAPON_COMBATPISTOL", lamp) then
			xPlayer.removeWeaponComponent('WEAPON_COMBATPISTOL', lamp)
		end
		TriggerClientEvent('esx:showNotification', _source, "Vous avez rendu une arme : ~b~"..ESX.GetWeaponLabel('WEAPON_COMBATPISTOL'))
	end
	if shotgun then
		xPlayer.removeWeapon('WEAPON_PUMPSHOTGUN')
		if xPlayer.hasWeaponComponent("WEAPON_PUMPSHOTGUN", lamp) then
			xPlayer.removeWeaponComponent('WEAPON_PUMPSHOTGUN', lamp)
		end
		TriggerClientEvent('esx:showNotification', _source, "Vous avez rendu une arme : ~b~"..ESX.GetWeaponLabel('WEAPON_PUMPSHOTGUN'))
	end
	if combatpdw then
		xPlayer.removeWeapon("WEAPON_COMBATPDW")
		if xPlayer.hasWeaponComponent("WEAPON_COMBATPDW", lamp) then
			xPlayer.removeWeaponComponent('WEAPON_COMBATPDW', lamp)
		end
		TriggerClientEvent('esx:showNotification', _source, "Vous avez rendu une arme : ~b~"..ESX.GetWeaponLabel('WEAPON_COMBATPDW'))
	end
	if carabinerifle then
		xPlayer.removeWeapon('WEAPON_CARBINERIFLE')
		if xPlayer.hasWeaponComponent("WEAPON_CARBINERIFLE", lamp) then
			xPlayer.removeWeaponComponent('WEAPON_CARBINERIFLE', lamp)
		end
		TriggerClientEvent('esx:showNotification', _source, "Vous avez rendu une arme : ~b~"..ESX.GetWeaponLabel('WEAPON_CARBINERIFLE'))
	end
end)
RegisterServerEvent('sPolice:addHerse')
AddEventHandler('sPolice:addHerse', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	if authorizeJob[xPlayer.job.name] == nil then print("Le joueur : "..GetPlayerName(xPlayer.source).." vient de se faire détecter") return DropPlayer(xPlayer.source, tokenMessage) end
	if xPlayer.getInventoryItem("spike").count < 1 then
		xPlayer.addInventoryItem("spike", 1)
		TriggerClientEvent('esx:showNotification', source, "Vous venez de récuperer une ~b~herse~s~.")
	else
		TriggerClientEvent('esx:showNotification', source, "~r~Vous ne pouvez prendre deux herses sur vous.")
	end
end)

ESX.RegisterServerCallback('sPolice:getBilling', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local tPlayer = ESX.GetPlayerFromId(target)
	if authorizeJob[xPlayer.job.name] == nil then print("Le joueur : "..GetPlayerName(xPlayer.source).." vient de se faire détecter") return DropPlayer(xPlayer.source, tokenMessage) end

	MySQL.Async.fetchAll("SELECT * FROM billing WHERE identifier = @identifier", {
		['@identifier'] = tPlayer.identifier
	}, function(result)
		cb(result)
	end)
end)

RegisterNetEvent('sPolice:confiscatePlayerItem')
AddEventHandler('sPolice:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if authorizeJob[sourceXPlayer.job.name] == nil then 
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : confiscate weapon",
			description = "Anticheat : confiscate weapon"
		})
		return
	end
	
	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)
		if targetItem.count > 0 and targetItem.count <= amount then
			if sourceXPlayer.canCarryItem(itemName, sourceItem.count) then
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem   (itemName, amount)
				sourceXPlayer.showNotification('Vous avez confisqué ~y~'..amount..'~s~ ~b~'..sourceItem.label..'~s~')
				targetXPlayer.showNotification('~y~'..sourceItem.label..'~s~ ~b~'..amount..'~s~ vous à été confisqué')
			else
				sourceXPlayer.showNotification("Debug 1")
			end
		end
	elseif itemType == 'item_account' then
		local targetAccount = targetXPlayer.getAccount(itemName)
		if targetAccount.money >= amount then
			targetXPlayer.removeAccountMoney(itemName, amount)
			sourceXPlayer.addAccountMoney   (itemName, amount)

			sourceXPlayer.showNotification('Vous avez confisqué ~g~$'..itemName..'~s~ ('..amount..')')
			targetXPlayer.showNotification('~g~$'..itemName..'~s~ ('..amount..') vous à été confisqué')
		end
	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end
		if targetXPlayer.hasWeapon(itemName) then
			targetXPlayer.removeWeapon(itemName, amount)
			sourceXPlayer.addWeapon(itemName, amount)
			sourceXPlayer.showNotification('Vous avez confisqué ~b~'..ESX.GetWeaponLabel(itemName)..'~s~ avec ~y~'..amount..'~s~ munitions')
			targetXPlayer.showNotification('Votre ~b~'..ESX.GetWeaponLabel(itemName)..'~s~ avec ~y~'..amount..'~s~ munitions vous à été confisqué')
		end
	end
end)

-- Intéractions
RegisterServerEvent('sPolice:requestarrest')
AddEventHandler('sPolice:requestarrest', function(targetid, playerheading, playerCoords,  playerlocation)
	local _src = source
	TriggerEvent("ratelimit", _src, "sPolice:requestarrest")
	_source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if authorizeJob[xPlayer.job.name] == nil then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : request arrest",
			description = "Anticheat : request arrest"
		})
		return 
	end
	TriggerClientEvent('sPolice:getarrested', targetid, playerheading, playerCoords, playerlocation)
	TriggerClientEvent('sPolice:doarrested', _source)
end)

RegisterServerEvent('sPolice:requestrelease')
AddEventHandler('sPolice:requestrelease', function(targetid, playerheading, playerCoords,  playerlocation)
	local _src = source
	TriggerEvent("ratelimit", _src, "sPolice:requestrelease")
	_source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if authorizeJob[xPlayer.job.name] == nil then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : request release",
			description = "Anticheat : request release"
		})
		return  
	end
	TriggerClientEvent('sPolice:getuncuffed', targetid, playerheading, playerCoords, playerlocation)
	TriggerClientEvent('sPolice:douncuffing', _source)
end)

RegisterServerEvent('sPolice:handcuff')
AddEventHandler('sPolice:handcuff', function(target)
	local _src = source
	TriggerEvent("ratelimit", _src, "sPolice:handcuff")
	local xPlayer = ESX.GetPlayerFromId(source)
	if authorizeJob[xPlayer.job.name] == nil then 
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : request handcuff",
			description = "Anticheat : request handcuff"
		})
		return
	end
	if xPlayer.job.name == 'police' then
		TriggerClientEvent('sPolice:handcuff', target)
	else
		TriggerClientEvent('sPolice:handcuff', target)
	end
end)

RegisterServerEvent('sPolice:handcuff2')
AddEventHandler('sPolice:handcuff2', function(target)
	local _src = source
	TriggerEvent("ratelimit", _src, "sPolice:handcuff2")
	local xPlayer = ESX.GetPlayerFromId(source)
	if authorizeJob[xPlayer.job.name] == nil then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : request handcuff2",
			description = "Anticheat : request handcuff2"
		})
		return 
	end

	TriggerClientEvent('sPolice:handcuff2', target)

end)

RegisterServerEvent('sPolice:drag')
AddEventHandler('sPolice:drag', function(target)
	local _src = source
	TriggerEvent("ratelimit", _src, "sPolice:drag")
	local xPlayer = ESX.GetPlayerFromId(source)
	if authorizeJob[xPlayer.job.name] == nil then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : request drag",
			description = "Anticheat : request drag"
		})
		return 
	end

	TriggerClientEvent('sPolice:drag', target, source)
end)

RegisterServerEvent('sPolice:putInVehicle')
AddEventHandler('sPolice:putInVehicle', function(target)
	local _src = source
	TriggerEvent("ratelimit", _src, "sPolice:putInVehicle")
	local xPlayer = ESX.GetPlayerFromId(source)
	if authorizeJob[xPlayer.job.name] == nil then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : put in vehicle",
			description = "Anticheat : put in vehicle"
		})
		return  
	end

	TriggerClientEvent('sPolice:putInVehicle', target)
end)

RegisterServerEvent('sPolice:OutVehicle')
AddEventHandler('sPolice:OutVehicle', function(target)
	local _src = source
	TriggerEvent("ratelimit", _src, "sPolice:OutVehicle")
	local xPlayer = ESX.GetPlayerFromId(source)
	if authorizeJob[xPlayer.job.name] == nil then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : out in vehicle",
			description = "Anticheat : out in vehicle"
		})
		return 
	end

	TriggerClientEvent('sPolice:OutVehicle', target)
end)

ESX.RegisterServerCallback('sPolice:getPlayerInformation', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)
	if authorizeJob[xPlayer.job.name] == nil then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : search information",
			description = "Anticheat : search information"
		})
		return 
	end
	MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
		['@identifier'] = xTarget.identifier
	}, function(result)
		local data = {
			name = GetPlayerName(target),
			inventory = xTarget.inventory,
			accounts = xTarget.accounts,
			weapons = xTarget.loadout,
			firstname = result[1]['firstname'],
			lastname = result[1]['lastname'],
			sex = result[1]['sex'],
			birthday = result[1]['birthday'],
			number = result[1]['phone_number'],
			height = result[1]['height'],
			travail = result[1]['job'],
		}
		cb(data)
	end)
end)

ESX.RegisterServerCallback("sPolice:getLicenses", function(source, cb, target)
	TriggerEvent('Sneakyesx_license:getLicenses', target, function(licenses)
		cb(licenses)
	end)
end)

ESX.RegisterServerCallback('sPolice:getVehicleInfos', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE @plate = plate', {
		['@plate'] = plate
	}, function(result)
		local retrivedInfo = {
			plate = plate
		}
		if result[1] then
			MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)
				retrivedInfo.owner = result2[1].firstname .. ' ' .. result2[1].lastname
				cb(retrivedInfo)
			end)
		else
			cb(retrivedInfo)
		end
	end)
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('Sneakyesx_phone:removeNumber', 'police')
	end
end)

-- Renfort
RegisterServerEvent('sPolice:renfortPolice')
AddEventHandler('sPolice:renfortPolice', function(coords, raison)
	local _src = source
	TriggerEvent("ratelimit", _src, "sPolice:renfortPolice")
	local _source = source
	local _raison = raison
	local xPlayer = ESX.GetPlayerFromId(_source)
	if authorizeJob[xPlayer.job.name] == nil then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : renfort police",
			description = "Anticheat : renfort police"
		})
		return 
	end
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'lssd' or thePlayer.job.name == 'police' or thePlayer.job.name == "fbi" then
			local label = thePlayer.job.label
			TriggerClientEvent('renfortpolice:setBlip', xPlayers[i], label, coords, _raison)
		end
	end
end)