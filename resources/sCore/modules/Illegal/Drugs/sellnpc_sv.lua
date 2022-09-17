local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local drugsList = {
    ["weed_pooch"] = true,
    ["coke_pooch"] = true,
    ["meth_pooch"] = true
}

RegisterServerEvent("Drugs:Sell", function(itemName)
    local playerSrc = source
    if (not playerSrc) then return end

    local playerSelected = ESX.GetPlayerFromId(playerSrc)
    if (not playerSelected) then return end

    if (not drugsList[itemName]) then return end

    if (playerSelected.getInventoryItem(itemName).count < 1) then return end

    if playerSelected.getInventoryItem(itemName).count >= 1 then 
        if itemName == "weed_pooch" then
            random = math.random(55, 90)
        elseif itemName == "meth_pooch" then
            random = math.random(90, 110)
        elseif itemName == "coke_pooch" then
            random = math.random(90, 110)
        end
        playerSelected.removeInventoryItem(itemName, 1)
        playerSelected.addAccountMoney("cash", random)
        playerSelected.showNotification("Vous avez vendu votre ~b~"..ESX.GetItemLabel(itemName).."~s~ pour "..random.."~g~$~s~.")
    end
end)