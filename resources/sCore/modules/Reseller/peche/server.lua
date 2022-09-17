ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local items = {
    ["fish"] = {price = 34, sell = true},
    ["mor_fish"] = {price = 20, sell = false},
    ["whitefish"] = {price = 45, sell = true},
    ["redfish"] = {price = 27, sell = true},
    ["fishd"] = {price = 39, sell = true},
    ["carpecuir"] = {price = 65, sell = true},
    ["pompom"] = {price = 27, sell = true},
}

RegisterServerEvent("sPeche:buyItem")
AddEventHandler("sPeche:buyItem", function(item, count)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    if xPlayer == nil then return end

    local verifItem = items[item]
    if verifItem == nil then return end

    if (xPlayer.getWeight()+(xPlayer.getInventoryItem(item).weight*1)) > ESX.GetConfig().MaxWeight then return TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez pas assez de place sur vous !") end        
    if #(GetEntityCoords(GetPlayerPed(source))-vector3(-95.687286376953,-2767.841796875,6.0821242332458)) > 2.0 then 
        banPlayerAC(xPlayer.source, {
			name = "createentity",
			title = "Give d'item : ("..item..")",
			description = "Give d'item : ("..item..")"
		})
        return
    end
    local totalPrice = verifItem.price*count
    if xPlayer.getAccount('cash').money >= totalPrice then
        xPlayer.addInventoryItem(item, count)
        xPlayer.removeAccountMoney('cash', totalPrice)
        TriggerClientEvent("esx:showNotification", _src, "Vous avez acheté ~b~x"..count.." "..ESX.GetItemLabel(item).."~s~ pour "..totalPrice.."~g~$~s~ !")
    elseif xPlayer.getAccount('bank').money >= totalPrice then
        xPlayer.addInventoryItem(item, count)
        xPlayer.removeAccountMoney('bank', totalPrice)
        TriggerClientEvent("esx:showNotification", _src, "Vous avez acheté ~b~x"..count.." "..ESX.GetItemLabel(item).."~s~ pour "..totalPrice.."~g~$~s~ !")
    else
        TriggerClientEvent("esx:showNotification", _src, "~r~Vous n'avez pas assez d'argent !")
    end
end)

RegisterServerEvent("sPeche:sellItem")
AddEventHandler("sPeche:sellItem", function(item, selectCount)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    if xPlayer == nil then return end

    local verifItem = items[item]
    if verifItem == nil then return end
    if verifItem.sell ~= true then return end

    local itemCount = xPlayer.getInventoryItem(item).count
    if selectCount > itemCount then return TriggerClientEvent("esx:showNotification", _src, "~r~Vous n'avez pas cela sur vous !") end
    local totalPrice = verifItem.price*selectCount
    if #(GetEntityCoords(GetPlayerPed(source))-vector3(-95.687286376953,-2767.841796875,6.0821242332458)) > 2.0 then 
        banPlayerAC(xPlayer.source, {
			name = "createentity",
			title = "Give d'item : ("..item..")",
			description = "Give d'item : ("..item..")"
		})
        return
    end
    xPlayer.removeInventoryItem(item, selectCount)
    xPlayer.addAccountMoney('cash', totalPrice)
    TriggerClientEvent("esx:showNotification", _src, "Vous avez vendue ~b~x"..selectCount.." "..ESX.GetItemLabel(item).."~s~ pour "..totalPrice.."~g~$~s~ !")
end)