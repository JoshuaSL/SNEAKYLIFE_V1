ESX = nil
TriggerEvent("Sneakyesx:getSharedObject", function(niceESX) ESX = niceESX end)

RegisterServerEvent("sStore:buyItem")
AddEventHandler("sStore:buyItem", function(ijfaodjafj, itemPrice, itemName)
    local _src = source
	TriggerEvent("ratelimit", _src, "sStore:buyItem")
    if source then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            if #(GetEntityCoords(GetPlayerPed(source))-ijfaodjafj) > 5.0 then
                banPlayerAC(xPlayer.source, {
                    name = "changestateuser",
                    title = "Anticheat : give d'item",
                    description = "Anticheat : give d'item"
                })
                return 
            end
            if itemName ~= "weapon_golfclub" then
                if (xPlayer.getWeight()+(xPlayer.getInventoryItem(itemName).weight*1)) > ESX.GetConfig().MaxWeight then 
                    return 
                    TriggerClientEvent("Sneakyesx:showNotification", source, "~r~Vous n'avez pas assez de place sur vous !") 
                end    
            end    
            if xPlayer.getAccount("cash").money >= itemPrice then
                if itemName == "weapon_golfclub" then
                    xPlayer.addWeapon('WEAPON_GOLFCLUB', 1)
                    xPlayer.removeAccountMoney("cash", itemPrice)
                    TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "Vous avez bien acheté ~b~1x "..ESX.GetItemLabel(itemName).."~s~ pour "..itemPrice.."~g~$~s~ !")
                elseif itemName == "pelle" or itemName == "casserole" then
                    local Pelle = xPlayer.getInventoryItem('pelle').count
                    local Casserole = xPlayer.getInventoryItem('casserole').count
                    if Pelle ~= 0 then
                        TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "~r~Vous avez déjà cette objet sur vous.")
                    else
                        xPlayer.removeAccountMoney("cash", itemPrice)
                        xPlayer.addInventoryItem(itemName, 1)
                        TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "Vous avez bien acheté ~b~1x "..ESX.GetItemLabel(itemName).."~s~ pour "..itemPrice.."~g~$~s~ !")
                        return
                    end
                    if Casserole ~= 0 then
                        TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "~r~Vous avez déjà cette objet sur vous.")
                    else
                        xPlayer.removeAccountMoney("cash", itemPrice)
                        xPlayer.addInventoryItem(itemName, 1)
                        TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "Vous avez bien acheté ~b~1x "..ESX.GetItemLabel(itemName).."~s~ pour "..itemPrice.."~g~$~s~ !")
                        return
                    end
                else
                    xPlayer.addInventoryItem(itemName, 1)
                    xPlayer.removeAccountMoney("cash", itemPrice)
                    TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "Vous avez bien acheté ~b~1x "..ESX.GetItemLabel(itemName).."~s~ pour "..itemPrice.."~g~$~s~ !")
                end
            else
                return
                TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "~r~Vous n'avez pas assez d'argent !")
            end
        end
    end
end)