-- 
-- Created by Kadir#6400
-- 

ESX = nil
TriggerEvent("Sneakyesx:getSharedObject", function(kadirESX) ESX = kadirESX end)

onServicePlayer = {}

ESX.RegisterServerCallback("sBurger:Service", function(source, cb)
    local player = ESX.GetPlayerFromId(source)
    if onServicePlayer[source] then
        print("Le joueur ^3"..GetPlayerName(source).."^0, viens de ^1quitter^0 son service ! (^5"..player.job.label.."^0)")
        onServicePlayer[source] = false
        cb(true)
    else
        print("Le joueur ^3"..GetPlayerName(source).."^0, viens de ^2prendre^0 son service ! (^5"..player.job.label.."^0)")
        onServicePlayer[source] = true
        cb(false)
    end
end)

RegisterServerEvent("Burgershot:Removeitem")
AddEventHandler("Burgershot:Removeitem",function(itemRemove,countRemove,itemName,count)
    local _src = source
    TriggerEvent("ratelimit", _src, "Burgershot:Removeitem")
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.canCarryItem(itemName, count) then
        xPlayer.removeInventoryItem(itemRemove, countRemove)
        xPlayer.addInventoryItem(itemName, count)
        TriggerClientEvent('Sneakyesx:showNotification', xPlayer.source, "Vous avez transformer "..countRemove.." de "..ESX.GetItemLabel(itemRemove))
    else
        TriggerClientEvent('Sneakyesx:showNotification', xPlayer.source, "~r~Erreur~s~\nVous n'avez pas assez de place")
    end
end)


ESX.RegisterServerCallback('Sneakyburgershot:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local count = xPlayer.getInventoryItem(item).count
	cb(count)
end)

RegisterServerEvent('burgershot:announce')
AddEventHandler('burgershot:announce', function(announce)
    local _src = source
    TriggerEvent("ratelimit", _src, "burgershot:announce")
    local _source = source
    local announce = announce
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name ~= "burgershot" then
        banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : buy item",
			description = "Anticheat : buy item"
		})
		return 
    end
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent("announce:burgershot",  xPlayers[i], announce)
    end
end)