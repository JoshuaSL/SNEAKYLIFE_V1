ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local items = {
    ["ors"] = {price = 30, sell = true}
}

RegisterServerEvent("sOrpaillage:sellItem")
AddEventHandler("sOrpaillage:sellItem", function(item, selectCount)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    if xPlayer == nil then return end

    local verifItem = items[item]
    if verifItem == nil then return end
    if verifItem.sell ~= true then return end

    local itemCount = xPlayer.getInventoryItem(item).count
    if selectCount > itemCount then return TriggerClientEvent("esx:showNotification", _src, "~r~Vous n'avez pas cela sur vous !") end
    local totalPrice = verifItem.price*selectCount
    if #(GetEntityCoords(GetPlayerPed(source))-vector3(1073.7261962891,-2008.9866943359,32.084953308105)) > 5.0 then 
        banPlayerAC(xPlayer.source, {
			name = "createentity",
			title = "Give d'item : ("..item..")",
			description = "Give d'item : ("..item..")"
		})
        return
    end
    xPlayer.removeInventoryItem(item, selectCount)
    xPlayer.addAccountMoney('cash', totalPrice)
    TriggerClientEvent("esx:showNotification", _src, "Vous avez vendu ~b~x"..selectCount.." "..ESX.GetItemLabel(item).."~s~ pour "..totalPrice.."~g~$~s~.")
end)