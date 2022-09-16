ESX = nil

TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("sFuel:requestToAddFuel")
AddEventHandler("sFuel:requestToAddFuel", function(vehicleFuel, chooseLitre)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    local price = FuelServices.defaultPrice*chooseLitre
    if xPlayer.getAccount('cash').money > price then
        local total = (vehicleFuel+chooseLitre)
        if total > 100.0 then return TriggerClientEvent("Sneakyesx:showNotification", source, "~r~Le véhicule a déjà assez d'essence !") end
        xPlayer.removeAccountMoney('cash', price)
        TriggerClientEvent("sFuel:animatedPlayer", source, chooseLitre)
        TriggerClientEvent("sFuel:addFuelToVehicle", source, chooseLitre)
    else
        TriggerClientEvent("Sneakyesx:showNotification", source, "~r~Vous n'avez pas assez d'argent !")
    end
end)

RegisterServerEvent("sFuel:requestToAddFuelFull")
AddEventHandler("sFuel:requestToAddFuelFull", function(vehicleFuel)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local total =  (100.0 - vehicleFuel)
    local price = FuelServices.defaultPrice*total
    if xPlayer.getAccount('cash').money > price then
        xPlayer.removeAccountMoney('cash', price)
        TriggerClientEvent("sFuel:animatedPlayer", source, total)
        TriggerClientEvent("sFuel:addFuelToVehicle", source, total)
    else
        TriggerClientEvent("Sneakyesx:showNotification", source, "~r~Vous n'avez pas assez d'argent !")
    end
end)
