ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
ESX.RegisterServerCallback("pGarage:GetOwnVehicle", function(source, callback)
    local xPlayer = ESX.GetPlayerFromId(source)
    local idd = xPlayer.identifier
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner', {
        ["@owner"] = idd
    }, function(result)
        callback(result)
    end)
end)

RegisterServerEvent("pGarare:RenameVeh")
AddEventHandler("pGarare:RenameVeh", function(plt, lbl)
    local _src = source
    TriggerEvent("ratelimit", _src, "pGarare:RenameVeh")
	MySQL.Sync.execute("UPDATE owned_vehicles SET label =@label WHERE plate=@plate",{['@label'] = lbl , ['@plate'] = plt})
end)

RegisterNetEvent("pGarage:RequestSpawn")
AddEventHandler("pGarage:RequestSpawn", function(plt, pos, hdg)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local idd = xPlayer.identifier

    MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @owner AND parked = 1 AND plate = @plate",
    {['@owner'] = idd, ['@plate'] = plt},
    function(vehicle)
        if vehicle[1] ~= nil then
            MySQL.Async.execute("UPDATE owned_vehicles SET parked = 0 WHERE owner = @owner AND plate = @plate", {['@owner'] = idd,['@plate'] = plt},
            function(data)
                TriggerClientEvent("pGarage:SpawnVeh", source, vehicle[1], pos, hdg)
            end)
        end
    end)
end)

RegisterNetEvent("pGarage:UpdateParkedStatus")
AddEventHandler("pGarage:UpdateParkedStatus", function(plt, prc)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local idd = xPlayer.identifier

    if prc ~= nil then

        if xPlayer.getAccount('cash').money >= prc then
            xPlayer.removeAccountMoney('cash', prc)
            SendLogs(3066993,"Garage - Rappelle véhicule","**"..GetPlayerName(source).."** vient de payer ***"..prc.."$ ***\n **License** : "..xPlayer.identifier,"https://canary.discord.com/api/webhooks/841150999283367967/5nd2Kn0behHg293urbWN77RmzkVWLOm92XybEPISPhuLKBzbNM3XaleykM5gbRLWeEMD")
            MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @owner AND parked = 0 AND plate = @plate",
            {['@owner'] = idd, ['@plate'] = plt},
            function(vehicle)
                if vehicle[1] ~= nil then
                    MySQL.Async.execute("UPDATE owned_vehicles SET parked = 1 WHERE owner = @owner AND plate = @plate", {['@owner'] = idd,['@plate'] = plt})
                end
            end)
        else
            TriggerClientEvent("RageUI:Popup", source, {message="~b~Fonds insuffisant"})
        end
    else
        MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @owner AND parked = 0 AND plate = @plate",
        {['@owner'] = idd, ['@plate'] = plt},
        function(vehicle)
            if vehicle[1] ~= nil then
                MySQL.Async.execute("UPDATE owned_vehicles SET parked = 1 WHERE owner = @owner AND plate = @plate", {['@owner'] = idd,['@plate'] = plt})
            end
        end)
    end
end)

ESX.RegisterServerCallback('pGarage:StockVehicle',function(source,cb, vehicleProps)
	local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local idd = xPlayer.identifier
	
	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @owner AND parked = 0 AND plate = @plate",
    {['@plate'] = vehicleProps.plate, ['@owner'] = idd}, 
    function(result)
		if result[1] ~= nil then
            MySQL.Async.execute("UPDATE owned_vehicles SET props =@props WHERE plate=@plate",{
                ['@props'] = json.encode(vehicleProps),
                ['@plate'] = vehicleProps.plate
            }, function(rowsChanged)
                cb(true)
            end)
		else
			cb(false)
		end
	end)
end)

ESX.RegisterServerCallback('pGarage:GetAllPlate', function (source, cb, plate)
    MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    }, function (result)
        cb(result[1] ~= nil)
    end)
end)

RegisterNetEvent("pGarage:Givecar")
AddEventHandler("pGarage:Givecar", function(trgt, label, veh, plt, prps, parked)
    if trgt then

        local xPly = ESX.GetPlayerFromId(trgt)

        MySQL.Async.execute('INSERT INTO owned_vehicles (owner,plate,model,parked,props) VALUES(@owner,@plate,@model,@parked,@props)',
        {
            ['@owner'] = xPly.identifier,
            ['@plate'] = plt,
            ['@model'] = veh,
            ['@label'] = label,
            ['@parked'] = parked,
            ['@props'] = json.encode(prps),

        })

        TriggerClientEvent("esx:showNotification", xPly.source, "Vous avez reçu un(e) ~b~"..veh.."~s~ ["..plt.."] !")

        RconPrint("^2["..GetCurrentResourceName().."] ^0: ^3New vehicle has registered^0 "..plt.."\n")

    end

end)

RegisterNetEvent("pGarage:Givecarhimself")
AddEventHandler("pGarage:Givecarhimself", function(label, veh, plt, prps, parked)
    if source then

        print("Request ID : ^3"..source.."^0")

        local xPly = ESX.GetPlayerFromId(source)

        MySQL.Async.execute('INSERT INTO owned_vehicles (owner,plate,model,parked,props) VALUES(@owner,@plate,@model,@parked,@props)',
        {
            ['@owner'] = xPly.identifier,
            ['@plate'] = plt,
            ['@model'] = veh,
            ['@label'] = label,
            ['@parked'] = parked,
            ['@props'] = json.encode(prps),

        })

        TriggerClientEvent("esx:showNotification", xPly.source, "Vous avez reçu un(e) ~b~"..veh.."~s~ ["..plt.."] !")

        RconPrint("^2["..GetCurrentResourceName().."] ^0: ^3New vehicle has registered^0 "..plt.."\n")

    end

end)

RegisterNetEvent("pGarage:UpdateVehicleOwner")
AddEventHandler("pGarage:UpdateVehicleOwner", function(plt, actualowner, newowner)
    local xTarget = ESX.GetPlayerFromId(actualowner)
    local xTargetnew = ESX.GetPlayerFromId(newowner)

    MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate AND owner = @owner', {
        ["@owner"] = xTarget.identifier,
        ["@plate"] = plt
    }, function(result)
        if result ~= nil then
            MySQL.Async.execute('UPDATE owned_vehicles SET owner = @owner where plate = @plate',
            {
                ["@owner"] = xTargetnew.identifier,
                ["@plate"] = plt
            })
        end
    end)

end)

RegisterNetEvent("pGarage:UpdateVehicleProps")
AddEventHandler("pGarage:UpdateVehicleProps", function(plt, prps)
    MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
        ["@plate"] = plt
    }, function(result)
        if result ~= nil then
            MySQL.Async.execute('UPDATE owned_vehicles SET props = @props where plate = @plate',
            {
                ["@props"] = prps,
                ["@plate"] = plt
            })
        end
    end)

end)

RegisterNetEvent("pGarage:UpdateVehiclePlate")
AddEventHandler("pGarage:UpdateVehiclePlate", function(plt, newplate)
    MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
        ["@plate"] = plt
    }, function(result)
        if result ~= nil then
            MySQL.Async.execute('UPDATE owned_vehicles SET plate = @plate where plate ='..plt,
            {
                ["@plate"] = newplate
            })
        end
    end)

end)