ESX = nil
TriggerEvent("Sneakyesx:getSharedObject", function(niceESX) ESX = niceESX end)

-- Farming

local Allow = {
    Items = {
        ["weed_graine"] = {count = 1},
        ["weed_fertiligene"] = {count = 1},
        ["weed"] = {count = 1},
        ["weed_pooch"] = {count = 1},
        ["coca_feuille"] = {count = 1},
        ["coca_acide"] = {count = 1},
        ["coke"] = {count = 1},
        ["coke_pooch"] = {count = 1},
        ["meth_lode"] = {count = 1},
        ["meth_phosphore"] = {count = 1},
        ["meth"] = {count = 1},
        ["meth_pooch"] = {count = 1}
    }
}

ESX.RegisterServerCallback('sDrugs:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local count = xPlayer.getInventoryItem(item).count
	cb(count)
end)

ESX.RegisterServerCallback("sDrugs:getWeightItem", function(source, cb, item, count)
    if source then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            if (xPlayer.getWeight()+(xPlayer.getInventoryItem(item).weight*count)) >= ESX.GetConfig().MaxWeight then 
                cb(false)
            else
                cb(true)
            end 
        end  
    end    
end)

RegisterNetEvent("sDrugs:addItem")
AddEventHandler("sDrugs:addItem", function(itemName)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        --if xPlayer.job2.name == "unemployed2" then return end
        if Allow.Items[itemName] == nil then return end
        if xPlayer.canCarryItem(itemName, Allow.Items[itemName].count) then
            xPlayer.addInventoryItem(itemName, Allow.Items[itemName].count)
            TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "Vous avez récolté ~b~x"..Allow.Items[itemName].count.." "..ESX.GetItemLabel(itemName).."~s~ !")
        else
            TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "~r~Vous n'avez pas assez de place sur vous !")
        end
    end
end)

RegisterNetEvent("sDrugs:transformItem")
AddEventHandler("sDrugs:transformItem", function(lastItem, itemName)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        --if xPlayer.job2.name == "unemployed2" then return end
        if Allow.Items[lastItem[1]] == nil then return end
        if Allow.Items[lastItem[2]] == nil then return end
        if Allow.Items[itemName] == nil then return end
        xPlayer.removeInventoryItem(lastItem[1], Allow.Items[lastItem[1]].count)
        xPlayer.removeInventoryItem(lastItem[2], Allow.Items[lastItem[2]].count)
        xPlayer.addInventoryItem(itemName, Allow.Items[itemName].count)
        TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "Vous avez transformé ~b~x"..Allow.Items[lastItem[1]].count.." "..ESX.GetItemLabel(lastItem[1]).."~s~ et ~b~x"..Allow.Items[lastItem[2]].count.." "..ESX.GetItemLabel(lastItem[2]).."~s~ !")
    end
end)

RegisterNetEvent("sDrugs:pochonItem")
AddEventHandler("sDrugs:pochonItem", function(lastItem, itemName)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        --if xPlayer.job2.name == "unemployed2" then return end
        if Allow.Items[lastItem] == nil then return end
        if Allow.Items[itemName] == nil then return end
        xPlayer.removeInventoryItem(lastItem, Allow.Items[lastItem].count)
        xPlayer.addInventoryItem(itemName, Allow.Items[itemName].count)
        TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "Vous mis en pochon ~b~x"..Allow.Items[lastItem].count.." "..ESX.GetItemLabel(lastItem).."~s~ !")
    end
end)

RegisterServerEvent("sDrugs:Removeitem")
AddEventHandler("sDrugs:Removeitem",function()
    local _src = source
    local itemRemove = "weed"
    local countRemove = 2
    local count = 1
    local itemName = "weed_pooch"
    TriggerEvent("ratelimit", _src, "sDrugs:Removeitem")
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.canCarryItem(itemName, count) then
        xPlayer.removeInventoryItem(itemRemove, countRemove)
        xPlayer.addInventoryItem(itemName, count)
        TriggerClientEvent('Sneakyesx:showNotification', xPlayer.source, "Vous avez transformer ~b~x"..countRemove.." "..ESX.GetItemLabel(itemRemove).."~s~.")
    else
        TriggerClientEvent('Sneakyesx:showNotification', xPlayer.source, "~r~Vous n'avez pas assez de place.")
    end
end)