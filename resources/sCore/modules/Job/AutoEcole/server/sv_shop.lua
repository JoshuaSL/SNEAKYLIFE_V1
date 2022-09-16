ESX = nil

TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('Dmv:buy', function(source, cb, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getAccount('cash').money >= price then
		xPlayer.removeAccountMoney('cash', price)
		SendLogs(47103,"Auto école - Achat","**"..GetPlayerName(source).."** vient d'acheter pour ***"..price.."$ ***\n **License** : "..xPlayer.identifier,"https://canary.discord.com/api/webhooks/841153050017660988/NLa5I4NYYMGRrz84Hb-I0qpmNkDS-ZSt2TJ07eV4-HE49R5krkQkMYoKDUhPUX8C40yd")
		cb(true)
	else
		cb(false)
	end
end)

RegisterNetEvent('Sneakyesx_dmvschool:addLicense')
AddEventHandler('Sneakyesx_dmvschool:addLicense', function(kakakdakkfakdafkjiajdi, license)
	local xPlayer = ESX.GetPlayerFromId(source)
	if #(GetEntityCoords(GetPlayerPed(xPlayer.source))-kakakdakkfakdafkjiajdi) > 5.0 then
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : give de license",
			description = "Anticheat : give de license"
		})
		return
	end
	TriggerEvent('Sneakyesx_license:addLicense', xPlayer.source, license, function()
		TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "+1 ~b~"..license.."~s~ !")
	end)
end)