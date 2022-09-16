ESX = nil

TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('Sneakyesx_phone:registerNumber', 'harmony', "Harmony and Repair's", true, true)
TriggerEvent('Sneakyesx_society:registerSociety', 'harmony', 'harmony', 'society_harmony', 'society_harmony', 'society_harmony', {type = 'public'})

RegisterServerEvent('Sneakyharmony:giveItem')
AddEventHandler('Sneakyharmony:giveItem', function(itemName,price)
	local _src = source
	TriggerEvent("ratelimit", _src, "Sneakyharmony:giveItem")
	local xPlayer = ESX.GetPlayerFromId(source)
	if #(GetEntityCoords(GetPlayerPed(xPlayer.source))-vector3(1169.3200683594,2644.6003417969,37.809589385986)) > 1.5 then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : give d'item",
			description = "Anticheat : give d'item"
		})
		return 
	end
	if xPlayer.getAccount('cash').money >= price then
		if xPlayer.canCarryItem(itemName, 1) then
			xPlayer.addInventoryItem(itemName, 1)
			xPlayer.removeAccountMoney('cash', price)
			TriggerClientEvent('Sneakyesx:showNotification', xPlayer.source, "+1 ~b~"..ESX.GetItemLabel(itemName))
		else
			TriggerClientEvent('Sneakyesx:showNotification', xPlayer.source, "Vous avez déjà ~b~1x Kit de réparation~s~ !")
		end
	else
		TriggerClientEvent('Sneakyesx:showNotification', xPlayer.source, "~r~Vous n'avez pas assez d'argent !")
	end
end)

RegisterServerEvent('harmony:addAnnounce')
AddEventHandler('harmony:addAnnounce', function(announce)
	local _src = source
	TriggerEvent("ratelimit", _src, "harmony:addAnnounce")
    local _source = source
    local announce = announce
    local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name ~= "harmony" then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : annonce",
			description = "Anticheat : annonce"
		})
		return  
	end
    TriggerClientEvent("harmony:targetAnnounce",  -1, announce)
end)