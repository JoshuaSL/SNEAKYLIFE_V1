ESX = nil
TriggerEvent("Sneakyesx:getSharedObject", function(kadirESX) ESX = kadirESX end)

onServicePlayer = {}

ESX.RegisterServerCallback("sPizza:Service", function(source, cb)
    local player = ESX.GetPlayerFromId(source)
    if onServicePlayer[source] then
        onServicePlayer[source] = false
        cb(true)
    else
        onServicePlayer[source] = true
        cb(false)
    end
end)

RegisterServerEvent("Pizza:Removeitem")
AddEventHandler("Pizza:Removeitem",function(itemRemove,countRemove,itemName,count)
    local _src = source
	TriggerEvent("ratelimit", _src, "Pizza:Removeitem")
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.canCarryItem(itemName, count) then
        xPlayer.removeInventoryItem(itemRemove, countRemove)
        xPlayer.addInventoryItem(itemName, count)
        TriggerClientEvent('Sneakyesx:showNotification', xPlayer.source, "Vous avez transformer "..countRemove.." de "..ESX.GetItemLabel(itemRemove))
    else
        TriggerClientEvent('Sneakyesx:showNotification', xPlayer.source, "~r~Erreur~s~\nVous n'avez pas assez de place")
    end
end)


ESX.RegisterServerCallback('Sneakypizza:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local count = xPlayer.getInventoryItem(item).count
	cb(count)
end)

RegisterServerEvent('pizza:announce')
AddEventHandler('pizza:announce', function(announce)
    local _src = source
	TriggerEvent("ratelimit", _src, "pizza:announce")
    local _source = source
    local announce = announce
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name ~= "pizza" then
        banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : annonce pizza",
			description = "Anticheat : annonce pizza"
		})
		return  
    end
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent("announce:pizza",  xPlayers[i], announce)
    end
end)