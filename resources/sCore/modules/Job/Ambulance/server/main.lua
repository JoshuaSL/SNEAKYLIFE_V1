TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('Sneakyesx_phone:registerNumber', 'ambulance', 'Alerte Ambulance', true, true)
TriggerEvent('Sneakyesx_society:registerSociety', 'ambulance', 'ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})


RegisterServerEvent('Sneakyesx_ambulancejob:revive')
AddEventHandler('Sneakyesx_ambulancejob:revive', function(target)
    TriggerEvent("ratelimit", source, "Sneakyesx_ambulancejob:revive")
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'ambulance' then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : revive",
			description = "Anticheat : revive"
		})
		return
	end
	if target == -1 then
		return
	end
	local sourcePed = GetPlayerPed(source)
	local targetPed = GetPlayerPed(target)

	if #(GetEntityCoords(sourcePed) - GetEntityCoords(targetPed)) < 3.0 and GetEntityHealth(targetPed) <= 0.0 then
		TriggerClientEvent('SneakyLife:RevivePlayer', target)
	end
end)

RegisterServerEvent('Sneakyesx_ambulancejob:heal')
AddEventHandler('Sneakyesx_ambulancejob:heal', function(target, type)
	local _src = source
    TriggerEvent("ratelimit", _src, "Sneakyesx_ambulancejob:heal")
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "ambulance" then
		if target ~= -1 then
			TriggerClientEvent('Sneakyesx_ambulancejob:heal', target, type)
		end
	end
end)

TriggerEvent('Sneakyesx_society:registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})

ESX.RegisterServerCallback('Sneakyesx_ambulancejob:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local count = xPlayer.getInventoryItem(item).count
	cb(count)
end)

RegisterServerEvent('Sneakyesx_ambulancejob:removeItem')
AddEventHandler('Sneakyesx_ambulancejob:removeItem', function(item)
	local _src = source
    TriggerEvent("ratelimit", _src, "Sneakyesx_ambulancejob:removeItem")
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' and (item == 'medikit' or item == 'bandage') then
		xPlayer.removeInventoryItem(item, 1)
	end
end)

RestockItems = {
	{label = "Prendre medikit", rightlabel = {('medikit')}, value = 'medikit'},
	{label = "Prendre bandage", rightlabel = {('bandage')}, value = 'bandage'},
	{label = "Prendre perfusion", rightlabel = {('perfusion')}, value = 'perfusion'},
	{label = "Prendre fauteuil roulant", rightlabel = {('wheelchair')}, value = 'wheelchair'},
	{label = "Prendre lit", rightlabel = {('bed')}, value = 'bed'},
}

RegisterServerEvent('Sneakyesx_ambulancejob:giveItem')
AddEventHandler('Sneakyesx_ambulancejob:giveItem', function(itemName)
	local _src = source
    TriggerEvent("ratelimit", _src, "Sneakyesx_ambulancejob:giveItem")
	local xPlayer = ESX.GetPlayerFromId(source)
	local itemAvailable = false

	for i = 1, #RestockItems, 1 do
		if RestockItems[i].value == itemName then
			itemAvailable = true
		end
	end

	if itemAvailable and xPlayer.job.name == 'ambulance' then
		if xPlayer.canCarryItem(itemName, 1) then
			xPlayer.addInventoryItem(itemName, 1)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, 'vous en portez déjà assez sur vous.')
		end
	end
end)

ESX.RegisterUsableItem('medikit', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('medikit', 1)

	TriggerClientEvent('Sneakyesx_ambulancejob:heal', xPlayer.source, 'big')
	TriggerClientEvent('esx:showNotification', xPlayer.source, 'vous avez utilisé 1x kit de soin')
end)

ESX.RegisterUsableItem('bandage', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('bandage', 1)

	TriggerClientEvent('Sneakyesx_ambulancejob:heal', xPlayer.source, 'small')
	TriggerClientEvent('esx:showNotification', xPlayer.source, 'vous avez utilisé 1x bandage')
end)
RegisterNetEvent("sComa:RequestDeadStatut")
AddEventHandler('sComa:RequestDeadStatut', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchScalar("SELECT dead FROM users WHERE identifier = @identifier", { 
        ['@identifier'] = xPlayer.identifier,
        },function(result)
		print(result)
        if result == 1 then
            TriggerClientEvent('SneakyLife:RequestDeath', xPlayer.source)
        end
    end)
end)

RegisterServerEvent('Sneaky:DeadPlayer')
AddEventHandler('Sneaky:DeadPlayer', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute('UPDATE users SET dead = @dead WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier,
		['@dead'] = 1
	})
end)

RegisterServerEvent('Sneaky:StopDeadPlayer')
AddEventHandler('Sneaky:StopDeadPlayer', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute('UPDATE users SET dead = @dead WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier,
		['@dead'] = 0
	})
end)

RegisterServerEvent('Ems:DemandeRdv')
AddEventHandler('Ems:DemandeRdv', function(ginfo)
	local _src = source
    TriggerEvent("ratelimit", _src, "Ems:DemandeRdv")
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'ambulance' then
			TriggerClientEvent('Ems:Rdv', xPlayers[i],ginfo)
		end
	end
end)

ESX.RegisterServerCallback("EMS:PlayerIsDead", function(source, cb, ply)
	local idd = ESX.GetPlayerFromId(ply).identifier

	MySQL.Async.fetchScalar('SELECT dead FROM users WHERE identifier = @identifier', {
		['@identifier'] = idd
	}, function(dead)
		if dead == 1 then
			cb(true)
		elseif dead == 0 then
			cb(false)
		end
	end)
end)

RegisterCommand("revive", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "user" then return TriggerClientEvent("esx:showNotification", xPlayer.source, "~r~Vous n'avez pas accès à cette commande !") end 
    if args[1] ~= nil then
            TriggerClientEvent('SneakyLife:RevivePlayerStaff', tonumber(args[1]))
        else
            TriggerClientEvent('SneakyLife:RevivePlayerStaff', source)
        end
		TriggerEvent('esx:restoreLoadout')
end, false)

RegisterServerEvent('EMS:RevivePLayer')
AddEventHandler('EMS:RevivePLayer', function(trg)
	local _src = source
    TriggerEvent("ratelimit", _src, "EMS:RevivePLayer")
	if trg ~= -1 then
		TriggerClientEvent('SneakyLife:RevivePlayer', trg)
	end
end)

RegisterNetEvent('Sneakyesx_ambulancejob:payrevive')
AddEventHandler('Sneakyesx_ambulancejob:payrevive', function(money)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeAccountMoney('cash', money)
	TriggerEvent('Sneakyesx_addonaccount:getSharedAccount', "society_ambulance", function(account)
		account.addMoney(money)
	end)
end)

ESX.RegisterUsableItem('wheelchair', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem("wheelchair", 1)
	TriggerClientEvent('sCore:useChair', _source)
end)

ESX.RegisterUsableItem('bed', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem("bed", 1)
	TriggerClientEvent('sCore:useBed', _source)
end)

RegisterNetEvent('sCore:wheelchair')
AddEventHandler('sCore:wheelchair', function(item_name)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name ~= "ambulance" then
		banPlayerAC(xPlayer.source, {
			name = "createentity",
			title = "Give d'item : ("..item_name..")",
			description = "Give d'item : ("..item_name..")"
		})
	else
		if item_name ~= "wheelchair" then
			banPlayerAC(xPlayer.source, {
				name = "createentity",
				title = "Give d'item : ("..item_name..")",
				description = "Give d'item : ("..item_name..")"
			})
		else
			if xPlayer.canCarryItem("wheelchair", 1) then
				local itemchair = xPlayer.getInventoryItem("wheelchair").count
				if itemchair == 0 then
					xPlayer.addInventoryItem("wheelchair", 1)
				end
			else
				TriggerClientEvent("esx:showNotification",source,"~r~Vous ne pouvez pas prendre ça sur vous.")
			end
		end	
	end
end)

RegisterNetEvent('sCore:bedSystem')
AddEventHandler('sCore:bedSystem', function(item_name)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name ~= "ambulance" then
		banPlayerAC(xPlayer.source, {
			name = "createentity",
			title = "Give d'item : ("..item_name..")",
			description = "Give d'item : ("..item_name..")"
		})
	else
		if item_name ~= "bed" then
			banPlayerAC(xPlayer.source, {
				name = "createentity",
				title = "Give d'item : ("..item_name..")",
				description = "Give d'item : ("..item_name..")"
			})
		else
			if xPlayer.canCarryItem("bed", 1) then
				local itemchair = xPlayer.getInventoryItem("bed").count
				if itemchair == 0 then
					xPlayer.addInventoryItem("bed", 1)
				end
			else
				TriggerClientEvent("esx:showNotification",source,"~r~Vous ne pouvez pas prendre ça sur vous.")
			end
		end	
	end
end)

ESX.RegisterServerCallback('sComa:CheckAmbulance', function(source, cb)
    local ambulance = 0
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'ambulance' then
            ambulance = ambulance + 1
        end
    end
    if ambulance < 5 then
        cb(true)
    else
        cb(false)
    end
end)