ESX               = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local listJob = {
    "carshop",
    "motoshop"
}

Citizen.CreateThread(function()
    for i=1, #listJob, 1 do
        TriggerEvent('esx_society:registerSociety', listJob[i], listJob[i], 'society_'..listJob[i], 'society_'..listJob[i], 'society_'..listJob[i], {type = 'public'})
    end
end)

RegisterServerEvent("sCardealer:announce")
AddEventHandler("sCardealer:announce", function(Job, Title, Subtitle, Banner, Type)
    local _src = source
	TriggerEvent("ratelimit", _src, "sCardealer:announce")
    if _src then
        local xPlayer = ESX.GetPlayerFromId(_src)
        local labeljob = nil
        if Job == "carshop" then 
            labeljob = "Concessionnaire voiture"
        elseif Job == "motoshop" then
            labeljob = "Concessionnaire moto"
        end
        if xPlayer.job.name ~= Job or xPlayer.job.name == "unemployed" then return print("Detect player "..GetPlayerName(_src).." announce !") end
        if Type == "open" then
            TriggerClientEvent(
                "esx:showAdvancedNotification",
                -1,
                Title,
                Subtitle,
                "- "..labeljob.." ~g~Ouvert~s~~n~- Horaire : ~g~Maintenant",
                Banner
            )
        elseif Type == "close" then
            TriggerClientEvent(
                "esx:showAdvancedNotification",
                -1,
                Title,
                Subtitle,
                "- "..labeljob.." ~r~Fermé~s~~n~- Horaire : ~g~Maintenant",
                Banner
            )
        elseif Type == "reduc" then
            TriggerClientEvent(
                "esx:showAdvancedNotification",
                -1,
                Title,
                Subtitle,
                "- Remise disponible : ~b~10%~s~~n~- Durée : ~g~1h00",
                Banner
            )
        end
    end
end)

RegisterNetEvent('sCardealer:addVehicule')
AddEventHandler('sCardealer:addVehicule', function(Job, label, vehicle, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name ~= Job or xPlayer.job.name == "unemployed" then return print("Detect player "..GetPlayerName(_src).." add vehicle !") end
    TriggerEvent('Sneakyesx_addonaccount:getSharedAccount', "society_"..Job, function(Society)
        local SocietyMoney = Society.money
        if SocietyMoney >= price then
            MySQL.Async.execute('INSERT INTO cardealer_vehicles (name, price, job) VALUES (@name, @price, @job)', {
                ['@name'] = vehicle,
                ['@price'] = price,
                ['@job'] = Job,
                print('Achat effectué par '..xPlayer.getName()..' : '..label..' pour '..price..'$')
            }, function(rowsChanged)
            end)
            Society.removeMoney(price)
            exports.sCore:SendLogs(1752220,"Achat de véhicule",""..GetPlayerName(source).." vient d'acheter le véhicule : **"..label.."** ***"..vehicle.."*** au prix de (**"..price.."**) avec le métier : ***"..Job.."*** \n License de la source : "..xPlayer.identifier,"https://discord.com/api/webhooks/878557086487838731/clngHrSKSOmHK-7oMpBKq40LWDUx0BNdEW67bL4F4q91rxK3P3wJ88PP1C6RYf4eJAI1")
            TriggerClientEvent('esx:showNotification', source, "Vous avez acheter un(e) ~b~"..label.."~s~ pour ~g~"..price.."$ ~s~!")    
        else
            TriggerClientEvent('esx:showNotification', source, "~r~L'entreprise n'a pas assez d'argent")
        end
    end)
end)


RegisterServerEvent('sCardealer:sellVehicle')
AddEventHandler('sCardealer:sellVehicle', function(Job, vehicle)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
	TriggerEvent("ratelimit", _src, "sCardealer:sellVehicle")
    if source then
        if xPlayer.job.name ~= Job or xPlayer.job.name == "unemployed" then return print("Detect player "..GetPlayerName(_src).." sell vehicle !") end
        MySQL.Async.fetchAll('SELECT * FROM cardealer_vehicles WHERE name = @name AND job = @job', {
            ['@name'] = vehicle,
            ['@job'] = Job
        }, function(result)
            local id = result[1].id 
            print(id)
            MySQL.Async.execute('DELETE FROM cardealer_vehicles WHERE id = @id', {
                ['@id'] = id
            })
        end)
    end
    exports.sCore:SendLogs(1752220,"Vente de véhicule",""..GetPlayerName(source).." vient de vendre le véhicule : ***"..vehicle.."*** avec le métier : ***"..Job.."*** \n License de la source : "..xPlayer.identifier,"https://discord.com/api/webhooks/878557086487838731/clngHrSKSOmHK-7oMpBKq40LWDUx0BNdEW67bL4F4q91rxK3P3wJ88PP1C6RYf4eJAI1")
end)

ESX.RegisterServerCallback('sCardealer:getVehicles', function(source, cb)
    if source then
        local xPlayer = ESX.GetPlayerFromId(source)
        MySQL.Async.fetchAll('SELECT * FROM cardealer_vehicles WHERE `job` = @job ORDER BY id', { ["@job"] = xPlayer.job.name }, function(result)
            cb(result)
        end)
    end
end)

ESX.RegisterServerCallback('sCardealer:isPlateTaken', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		cb(result[1] ~= nil)
	end)
end)

