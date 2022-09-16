-- 
-- Created by Kadir#6400
-- 

ESX = nil
TriggerEvent("Sneakyesx:getSharedObject", function(kadirESX) ESX = kadirESX end)

local playerChasse = {}

ESX.RegisterServerCallback("sChasse:check", function(source, cb, lastPos)
    if #(GetEntityCoords(GetPlayerPed(source))-lastPos) > 1.5 then  
        banPlayerAC(xPlayer.source, {
            name = "changestateuser",
            title = "Anticheat : start chasse",
            description = "Anticheat : start chasse"
        })
        return
    end
    if playerChasse[source] then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent("sChasse:start")
AddEventHandler("sChasse:start", function(lastPos, chasse)
    local _src = source
	TriggerEvent("ratelimit", _src, "sChasse:start")
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if #(GetEntityCoords(GetPlayerPed(source))-lastPos) > 1.5 then
            banPlayerAC(xPlayer.source, {
                name = "changestateuser",
                title = "Anticheat : tentative d'utilisation de trigger",
                description = "Anticheat : tentative d'utilisation de trigger"
            })
            return
        end
        playerChasse[source] = true
        itemName = string.upper("WEAPON_MUSKET")

        if xPlayer.hasWeapon(itemName) then
            TriggerClientEvent("Sneakyesx:showNotification",source,"Vous ne pouvez pas prendre deux fois la même ~r~arme~s~.")
        else
            xPlayer.addWeapon("WEAPON_MUSKET", 150)
        end
        SendLogs(1752220,"Chasse - Start","**"..GetPlayerName(source).."** vient de commencer à chasser \n **License** : "..xPlayer.identifier,"https://canary.discord.com/api/webhooks/851722676808843264/BnLeuj8XbFjHSAFtrYfeve9CQwyG92N3e4wKaqbgOetM4q5MvkefJUZXZKZ0pCS5V6ti")
        TriggerClientEvent("sChasse:returnStart", source, chasse)
    end
end)

RegisterServerEvent("sChasse:stop")
AddEventHandler("sChasse:stop", function(message, lastPos, chasse)
    local _src = source
	TriggerEvent("ratelimit", _src, "sChasse:stop")
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if playerChasse[source] then
            xPlayer.removeWeapon("WEAPON_MUSKET", 150)
            playerChasse[source] = false
            TriggerClientEvent("sChasse:returnStop", source, chasse, message)
            SendLogs(1752220,"Chasse - Stop","**"..GetPlayerName(source).."** vient d'arrêter la chasse \n **License** : "..xPlayer.identifier,"https://canary.discord.com/api/webhooks/851722676808843264/BnLeuj8XbFjHSAFtrYfeve9CQwyG92N3e4wKaqbgOetM4q5MvkefJUZXZKZ0pCS5V6ti")
        end
    end
end)

AddEventHandler('playerDropped', function()
	local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        xPlayer.removeWeapon("WEAPON_MUSKET", 150)
    end
end)

RegisterServerEvent("sChasse:addItem")
AddEventHandler("sChasse:addItem", function(itemName, count)
    local _src = source
    TriggerEvent("ratelimit", _src, "sChasse:addItem")
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if playerChasse[source] then
            if xPlayer.canCarryItem(itemName, tonumber(count)) then
                TriggerClientEvent("Sneakyesx:showNotification", source, "Bien, vous avez gagné ~b~x"..count.." "..ESX.GetItemLabel(itemName).."~s~ !")
                SendLogs(1752220,"Chasse - Ajout","**"..GetPlayerName(source).."** vient de gagner "..count.."x "..ESX.GetItemLabel(itemName).." \n **License** : "..xPlayer.identifier,"https://canary.discord.com/api/webhooks/851722676808843264/BnLeuj8XbFjHSAFtrYfeve9CQwyG92N3e4wKaqbgOetM4q5MvkefJUZXZKZ0pCS5V6ti")
                xPlayer.addInventoryItem(itemName, tonumber(count))
            else
                TriggerClientEvent("Sneakyesx:showNotification", source, "Vous n'avez pas assez de place sur vous pour récupérer la viande")
            end
        else
            banPlayerAC(xPlayer.source, {
                name = "changestateuser",
                title = "Anticheat : tentative d'utilisation de trigger",
                description = "Anticheat : tentative d'utilisation de trigger"
            })
            return
        end
    end
end)