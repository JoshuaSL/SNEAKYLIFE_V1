ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local Vehicles = nil
local societylabel = ""
RegisterServerEvent('sCustom:buyModHarmony')
AddEventHandler('sCustom:buyModHarmony', function(price)
	local _src = source
	TriggerEvent("ratelimit", _src, "sCustom:buyModHarmony")
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	price = tonumber(price)
	if xPlayer.job.name ~= "harmony" then
		exports.sCore:banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : customisation de véhicule",
			description = "Anticheat : customisation de véhicule"
		})
		return 
	end
	local societyAccount = nil
	TriggerEvent('Sneakyesx_addonaccount:getSharedAccount', "society_harmony", function(account)
		societyAccount = account
	end)
	if price < societyAccount.money then
		TriggerClientEvent('sCustom:installMod', _source)
		TriggerClientEvent('esx:showNotification', _source, 'Vous venez de payer '..price.."~g~$ pour customiser ce véhicule")
		societyAccount.removeMoney(price)
		exports.sCore:SendLogs(1752220,"Harmony Customisation",""..GetPlayerName(source).." vient de payer "..price.." \n License : "..xPlayer.identifier,"https://discord.com/api/webhooks/878557266800943144/t2PlYltKcY20EP8X97z0WLAUIwSjkknEhVA4OSh1-DugR6pU1XcoKMhIJqQEuePri7cT")
	else
		TriggerClientEvent('sCustom:cancelInstallMod', _source)
		TriggerClientEvent('esx:showNotification', _source, '~r~Vous n\'avez pas assez d\'argent!')
	end
end)

RegisterServerEvent('sCustom:refreshOwnedVehicle')
AddEventHandler('sCustom:refreshOwnedVehicle', function(myCar)
	local _src = source
	TriggerEvent("ratelimit", _src, "sCustom:refreshOwnedVehicle")
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE @plate = plate', {
        ['@plate'] = myCar.plate
    }, function(result)
        if result[1] then
            local props = json.decode(result[1].props)

            if props.model == myCar.model then

                MySQL.Async.execute('UPDATE `owned_vehicles` SET `props` = @props WHERE `plate` = @plate',
                    {
                        ['@plate'] = myCar.plate,
                        ['@props'] = json.encode(myCar)
                    })

            else
				print(('sCustom: %s a tenté de mettre à niveau un véhicule dont le modèle n\'était pas assorti !'):format(xPlayer.identifier))
			end
        end
    end)
end)

ESX.RegisterServerCallback('sCustom:getVehiclesPrices', function(source, cb)
	if Vehicles == nil then
		MySQL.Async.fetchAll('SELECT * FROM vehicles', {}, function(result)
			local vehicles = {}

			for i=1, #result, 1 do
				table.insert(vehicles, {
					model = result[i].model,
					price = result[i].price
				})
			end

			Vehicles = vehicles
			cb(Vehicles)
		end)
	else
		cb(Vehicles)
	end
end)