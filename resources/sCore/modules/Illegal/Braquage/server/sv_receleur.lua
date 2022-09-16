ESX = nil

TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('Sneakyreceleur:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local count = xPlayer.getInventoryItem(item).count
	cb(count)
end)

RegisterServerEvent("Receleur:SellItem")
AddEventHandler("Receleur:SellItem",function(itemRemove,countRemove,itemRemoveLabel,zone)
    local _src = source
    TriggerEvent("ratelimit", _src, "Receleur:SellItem")
    local money = 0
    if zone == 1 then
        money = 7500
    elseif zone == 2 then
        money = 85000
    elseif zone == 3 then
        money = 7500
    elseif zone == 4 then
        money = 100000
    end
    local xPlayer = ESX.GetPlayerFromId(source)
    if #(GetEntityCoords(GetPlayerPed(xPlayer.source))-vector3(1712.4272460938,4790.740234375,41.988807678223)) > 1.5 then
        banPlayerAC(xPlayer.source, {
            name = "changestateuser",
            title = "Anticheat : give d'item",
            description = "Anticheat : give d'item"
        })
        return
    end
    xPlayer.removeInventoryItem(itemRemove, countRemove)
    xPlayer.addAccountMoney('dirtycash',money)
    TriggerClientEvent('Sneakyesx:showNotification', xPlayer.source, "Vous avez vendu "..countRemove.." de "..itemRemoveLabel)
end)

RegisterServerEvent('Sneakyreceleur:buyItem')
AddEventHandler('Sneakyreceleur:buyItem', function(itemName, amount,zone)
    local _src = source
    TriggerEvent("ratelimit", _src, "Sneakyreceleur:buyItem")
	if zone == 1 then
        money = 350
    elseif zone == 2 then
        money = 550
    elseif zone == 3 then
        money = 15000
    elseif zone == 4 then
        money = 1000
    end
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    if #(GetEntityCoords(GetPlayerPed(xPlayer.source))-vector3(1712.4272460938,4790.740234375,41.988807678223)) > 1.5 then 
        banPlayerAC(xPlayer.source, {
            name = "changestateuser",
            title = "Anticheat : give d'item",
            description = "Anticheat : give d'item"
        })
        return
    end
	amount = ESX.Math.Round(amount)

	if amount < 0 then
		print('esx_shops: ' .. xPlayer.identifier .. ' attempted to exploit the shop!')
		return
	end

	if xPlayer.getAccount('cash').money >= money then
		if xPlayer.canCarryItem(itemName, amount) then
			xPlayer.removeAccountMoney('cash', money)
			xPlayer.addInventoryItem(itemName, amount)
			TriggerClientEvent('Sneakyesx:showNotification', source, "Vous avez acheté ~b~<C>"..ESX.GetItemLabel(itemName).."<C> ~s~ pour <C>"..money.."~s~~g~$~s~<C>.")
		else
			TriggerClientEvent('Sneakyesx:showNotification', source, "Vous n'avez plus de place sur vous")
		end
	else
		TriggerClientEvent('Sneakyesx:showNotification', source, "Vous n'avez pas assez d'argent")
	end
end)