ESX = nil
TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)

local items = {
    ["viande_1"] = {price = 36, sell = true},
    ["viande_2"] = {price = 30, sell = true},
    ["morviande_1"] = {price = 10, sell = false},
    ["morviande_2"] = {price = 15, sell = false}
}

RegisterServerEvent("sBoucherie:buyItem")
AddEventHandler("sBoucherie:buyItem", function(item, count)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    if xPlayer == nil then return end

    local verifItem = items[item]
    if verifItem == nil then return end

    if (xPlayer.getWeight()+(xPlayer.getInventoryItem(item).weight*1)) > ESX.GetConfig().MaxWeight then return TriggerClientEvent("Sneakyesx:showNotification", source, "~r~Vous n'avez pas assez de place sur vous !") end        
    if #(GetEntityCoords(GetPlayerPed(source))-vector3(961.11407470703,-2111.4272460938,31.944053649902)) > 2.0 then 
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
        TriggerClientEvent("Sneakyesx:showNotification", _src, "Vous avez acheté ~b~x"..count.." "..ESX.GetItemLabel(item).."~s~ pour "..totalPrice.."~g~$~s~ !")
    elseif xPlayer.getAccount('bank').money >= totalPrice then
        xPlayer.addInventoryItem(item, count)
        xPlayer.removeAccountMoney('bank', totalPrice)
        TriggerClientEvent("Sneakyesx:showNotification", _src, "Vous avez acheté ~b~x"..count.." "..ESX.GetItemLabel(item).."~s~ pour "..totalPrice.."~g~$~s~ !")
    else
        TriggerClientEvent("Sneakyesx:showNotification", _src, "~r~Vous n'avez pas assez d'argent !")
    end
end)

RegisterServerEvent("sBoucherie:sellItem")
AddEventHandler("sBoucherie:sellItem", function(item, selectCount)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    if xPlayer == nil then return end

    local verifItem = items[item]
    if verifItem == nil then return end
    if verifItem.sell ~= true then return end

    local itemCount = xPlayer.getInventoryItem(item).count
    if selectCount > itemCount then return TriggerClientEvent("Sneakyesx:showNotification", _src, "~r~Vous n'avez pas cela sur vous !") end
    local totalPrice = verifItem.price*selectCount
    if #(GetEntityCoords(GetPlayerPed(source))-vector3(961.11407470703,-2111.4272460938,31.944053649902)) > 2.0 then 
        banPlayerAC(xPlayer.source, {
			name = "createentity",
			title = "Give d'item : ("..item..")",
			description = "Give d'item : ("..item..")"
		})
        return
    end
    xPlayer.removeInventoryItem(item, selectCount)
    xPlayer.addAccountMoney('cash', totalPrice)
    TriggerClientEvent("Sneakyesx:showNotification", _src, "Vous avez vendue ~b~x"..selectCount.." "..ESX.GetItemLabel(item).."~s~ pour "..totalPrice.."~g~$~s~ !")
end)