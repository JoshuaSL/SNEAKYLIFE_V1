TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
	MySQL.Async.execute('DELETE FROM open_car WHERE NB = @NB', {
		['@NB'] = 2
	})
end)

ESX.RegisterServerCallback('Sneakyesx_vehiclelock:getVehiclesnokey', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM open_car WHERE owner = @owner', {
		['@owner'] = xPlayer.identifier
	}, function(result2)
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner', {
			['@owner'] = xPlayer.identifier
		}, function(result)
			local vehicles = {}

			for i = 1, #result, 1 do
				local found
				local vehicleData = json.decode(result[i].props)
				local vehiclePlate = result[i].plate
				local vehicleModel = result[i].model
				local vehicleDonated = result[i].donated

				for j = 1, #result2, 1 do
					if result2[j].plate == result[i].plate then
						found = true
					end
				end

				if not found then
					table.insert(vehicles,{data = vehicleData, plate = vehiclePlate, donated = vehicleDonated, model = vehicleModel})
				end
			end

			cb(vehicles)
		end)
	end)
end)

ESX.RegisterServerCallback('Sneakyesx_vehiclelock:mykey', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM open_car WHERE owner = @owner AND plate = @plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = plate
	}, function(result)
		local found = false
		if result[1] then
			found = true
		else
			found = false
		end
		cb(found)
	end)
end)

ESX.RegisterServerCallback('Sneakyesx_vehiclelock:allkey', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM open_car WHERE owner = @owner', {
		['@owner'] = xPlayer.identifier
	}, function(result)
		local keys = {}

		for i = 1, #result, 1 do
			table.insert(keys, {
				plate = result[i].plate,
				NB = result[i].NB
			})
		end

		cb(keys)
	end)
end)

RegisterServerEvent('Sneakyesx_vehiclelock:deletekeyjobs')
AddEventHandler('Sneakyesx_vehiclelock:deletekeyjobs', function(target, plate)
	local _src = source
	TriggerEvent("ratelimit", _src, "Sneakyesx_vehiclelock:deletekeyjobs")
	local _source = source
	local xPlayer

	if target ~= 'no' then
		xPlayer = ESX.GetPlayerFromId(target)
	else
		xPlayer = ESX.GetPlayerFromId(_source)
	end

	MySQL.Async.execute('DELETE FROM open_car WHERE owner = @owner AND plate = @plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = plate
	}, function(rowsChanged)
		if rowsChanged > 0 then
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez rendu les clés du véhicule de fonction")
		end
	end)
end)

RegisterServerEvent('Sneakyesx_vehiclelock:givekey')
AddEventHandler('Sneakyesx_vehiclelock:givekey', function(target, plate)
	local _src = source
	TriggerEvent("ratelimit", _src, "Sneakyesx_vehiclelock:givekey")
	local _source = source
	local xPlayer

	if target ~= 'no' then
		xPlayer = ESX.GetPlayerFromId(target)
	else
		xPlayer = ESX.GetPlayerFromId(_source)
	end

	MySQL.Async.execute('INSERT INTO open_car (owner, plate, NB) VALUES (@owner, @plate, @NB)', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = plate,
		['@NB'] = 2
	}, function()
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez reçu un double de clés")
	end)
end)

RegisterServerEvent('Sneakyesx_vehiclelock:registerkey')
AddEventHandler('Sneakyesx_vehiclelock:registerkey', function(plate, donated, target)
	local _src = source
	TriggerEvent("ratelimit", _src, "Sneakyesx_vehiclelock:registerkey")
	local _source = source
	local xPlayer

	if target ~= 'no' then
		xPlayer = ESX.GetPlayerFromId(target)
	else
		xPlayer = ESX.GetPlayerFromId(_source)
	end

	MySQL.Async.execute('INSERT INTO open_car (owner, plate, NB, donated) VALUES (@owner, @plate, @NB, @donated)', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = plate,
		['@NB'] = 1,
		['@donated'] = donated
	}, function()
		TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Vous venez d'obtenir une nouvelle paire de clé.")
		
	end)
end)
Newkeys = {}
RegisterServerEvent('Sneakyesx_vehiclelock:changeowner')
AddEventHandler('Sneakyesx_vehiclelock:changeowner', function(target, plate, vehicleProps)
	local _src = source
	TriggerEvent("ratelimit", _src, "Sneakyesx_vehiclelock:changeowner")
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayerTarget = ESX.GetPlayerFromId(target)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = plate
	}, function(result)
		if result then
			if result[1].props ~= nil then
				local props = json.decode(result[1].props)
				if props.model == vehicleProps.model and result[1].plate == plate then
					MySQL.Async.execute('UPDATE owned_vehicles SET owner = @target WHERE owner = @owner AND plate = @plate', {
						['@owner'] = xPlayer.identifier,
						['@target'] = xPlayerTarget.identifier,
						['@plate'] = plate
					}, function()
						MySQL.Async.execute('DELETE FROM open_car WHERE owner = @owner AND plate = @plate', {
							['@owner'] = xPlayer.identifier,
							['@plate'] = plate
						}, function()
							MySQL.Async.execute('INSERT INTO open_car (owner, plate, NB) VALUES (@owner, @plate, @NB)', {
								['@owner'] = xPlayerTarget.identifier,
								['@plate'] = plate,
								['@NB'] = 1
							}, function()
								TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez donné votre paire de clé")
								TriggerClientEvent('esx:showNotification', xPlayerTarget.source, "Vous avez reçu une nouvelle paire de clé")
							end)
						end)
					end)
				end
			end
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Le véhicule le plus proche ne vous appartient pas !")
		end
	end)
end)