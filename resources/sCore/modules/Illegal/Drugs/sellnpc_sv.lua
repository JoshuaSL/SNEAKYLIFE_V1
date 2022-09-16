local ESX = nil

TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)

local drugsList = {
    ["weed_pooch"] = true,
    ["coke_pooch"] = true,
    ["meth_pooch"] = true
}

RegisterNetEvent("neo:trytoStart")
AddEventHandler("neo:trytoStart", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local canSell, tbl = false, {}
    for k, v in pairs(drugsList) do  
        if xPlayer.getInventoryItem(k).count > 0  then
            canSell = true
            table.insert(tbl, {[k] = xPlayer.getInventoryItem(k).count})
        end 
    end   
    if canSell then
        TriggerClientEvent('neo:askToStart', xPlayer.source, tbl)
    else
        TriggerClientEvent('Sneakyesx:showNotification', xPlayer.source, "~r~Vous n'avez pas de drogue sur vous.")
        TriggerClientEvent("SneakyLife:StopSellDrugs", source)
    end 
end) 

RegisterNetEvent("neo:sellDrugs")
AddEventHandler("neo:sellDrugs", function(item, price, Neo)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if Neo[item].prices[2] >= price and Neo[item].prices[1] <= price and Neo ~= nil then 
        TriggerClientEvent('neo:restartFarming', xPlayer.source)
        TriggerClientEvent("Sneakyesx:showNotification", source, "Vous avez vendu ~b~<C>"..ESX.GetItemLabel(item).."~s~</C> pour ~g~<C>"..price.."$</C>~s~.")
        xPlayer.removeInventoryItem(item, 1)
        xPlayer.addAccountMoney('cash', price) 
    else 
        DropPlayer(source, "Tentative de give")
    end  
end)
  


ESX.RegisterServerCallback('neo:checkCops', function(source, cb)
    local cops = 0
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' or xPlayer.job.name == 'lssd' then
            cops = cops + 1
        end
    end 
    if cops >= 3 then
        cb(true) 
    else
        cb(false)
    end
end)