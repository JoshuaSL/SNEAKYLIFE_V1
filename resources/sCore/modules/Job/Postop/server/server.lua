ESX = nil

TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)

-- KadirProptect

playerIsService = {}


RegisterServerEvent("kPostOp:service")
AddEventHandler("kPostOp:service", function(cb)
	local _src = source
	TriggerEvent("ratelimit", _src, "kPostOp:service")
	local player = ESX.GetPlayerFromId(source)
	if cb then
		playerIsService[source] = true
		TriggerClientEvent("Sneakyesx:showNotification", player.source, "Vous venez de ~b~prendre~s~ votre ~g~service~s~ ! N'oublier pas d'allez prendre votre tenue !")
	else
		playerIsService[source] = false
		TriggerClientEvent("Sneakyesx:showNotification", player.source, "Vous venez de ~b~quitter~s~ votre ~r~service~s~ !")
	end
end)

ESX.RegisterServerCallback('kPostOp:checkService', function(source, cb)
	if playerIsService[source] then
		cb(false)
	else
		cb(true)
	end
end)

-- Register events

RegisterServerEvent('esx_deliveries:returnSafe:server')
RegisterServerEvent('esx_deliveries:finishDelivery:server')
RegisterServerEvent('esx_deliveries:removeSafeMoney:server')
RegisterServerEvent('esx_deliveries:getPlayerJob:server')

-- Return safe deposit event

AddEventHandler('esx_deliveries:returnSafe:server', function(deliveryType, safeReturn)
	local _src = source
	TriggerEvent("ratelimit", _src, "esx_deliveries:returnSafe:server")
	local xPlayer = ESX.GetPlayerFromId(source)
	if safeReturn then
		local SafeMoney = 250
		for k, v in pairs(Config.Safe) do
			if k == deliveryType then
				SafeMoney = v
				break
			end
		end
		xPlayer.addAccountMoney("bank", SafeMoney)
		xPlayer.showNotification("Le dépôt de garantie revient maintenant sur votre compte bancaire")
	else
		xPlayer.showNotification("Mission ~r~échoué~w~, votre dépôt de garantie à été ~r~retenue~w~.")
	end
end)

-- Finish delivery mission event

AddEventHandler('esx_deliveries:finishDelivery:server', function(deliveryType)
	local _src = source
	TriggerEvent("ratelimit", _src, "esx_deliveries:finishDelivery:server")
    local xPlayer = ESX.GetPlayerFromId(source)
	local deliveryMoney = 800
	for k, v in pairs(Config.Rewards) do
		if k == deliveryType then
			deliveryMoney = v
			break
		end
	end
	xPlayer.addAccountMoney("cash", deliveryMoney)
	xPlayer.showNotification("Mission réussie, vous recevez ~g~"..deliveryMoney.."$~s~ !")
end)


AddEventHandler('esx_deliveries:removeSafeMoney:server', function(deliveryType)
	local _src = source
	TriggerEvent("ratelimit", _src, "esx_deliveries:removeSafeMoney:server")
    local xPlayer = ESX.GetPlayerFromId(source)
	local SafeMoney = 4000
	for k, v in pairs(Config.Safe) do
		if k == deliveryType then
			SafeMoney = v
			break
		end
	end
	local PlayerMoney = xPlayer.getAccount('bank').money
	if PlayerMoney >= SafeMoney then
		xPlayer.removeAccountMoney("bank", SafeMoney)
		xPlayer.showNotification("~y~Post ~s~OP~n~- Le dépôt de garantie à été retiré de votre compte bancaire")
		xPlayer.showNotification("~y~Post ~s~OP~n~- Merci de rendre le véhicule pour récupérer votre caution")
		TriggerClientEvent('esx_deliveries:startJob:client', source, deliveryType)
	else
		xPlayer.showNotification("~r~Votre compte courant n'a pas assez d'argent")
	end
end)

AddEventHandler('esx_deliveries:getPlayerJob:server', function()
	local _src = source
	TriggerEvent("ratelimit", _src, "esx_deliveries:getPlayerJob:server")
    local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_deliveries:setPlayerJob:client', source, xPlayer.job.name)
end)
