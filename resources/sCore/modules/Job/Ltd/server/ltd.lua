ESX = nil
TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)

local LTD = {
    Entreprise = false,
    allowItems = {
        ["chocolate"] = {price = 13},
        ["water"] = {price = 12},
        ["phone"] = {price = 250},
    },
    allowJobs = {
      ["ltd_sud"] = {
        Announce = {
            ["open"] = {
                title = "LTD Sud",
                subtitle = "~b~Information~s~",
                message = "Nous sommes actuellement ~g~ouverts~s~, venez nous rendre ~b~visite~s~ au sud !",
                banner = "CHAR_LTD"
            },
            ["close"] = {
                title = "LTD Sud",
                subtitle = "~b~Information~s~",
                message = "Nous sommes actuellement ~r~fermés~s~, venez nous ~o~voir plus tard~s~ dans le sud !",
                banner = "CHAR_LTD"
            }
        }
      },  
      ["ltd_nord"] = {
        Announce = {
            ["open"] = {
                title = "LTD Nord",
                subtitle = "~b~Information~s~",
                message = "Nous sommes actuellement ~g~ouverts~s~, venez nous rendre ~b~visite~s~ au nord !",
                banner = "CHAR_LTD"
            },
            ["close"] = {
                title = "LTD Nord",
                subtitle = "~b~Information~s~",
                message = "Nous sommes actuellement ~r~fermés~s~, venez nous ~o~voir plus tard~s~ dans le nord !",
                banner = "CHAR_LTD"
            }
        }
      }  
    },
    onService = {}
}

local function notifToEmployes(message, job)
    if LTD.allowJobs[job] == nil then return end

    local players = ESX.GetPlayers()
    for i = 1, #players do
        local id = players[i]
        local xPlayer = ESX.GetPlayerFromId(id)
        if xPlayer.job.name == job then
            if LTD.onService[xPlayer.source] == nil then return end
            TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, message)
        end
    end
end

local function ltdAnnounce(job, type)
    if LTD.allowJobs[job] == nil then return end
    local infosAnnounce = LTD.allowJobs[job].Announce[type]
    TriggerClientEvent("Sneakyesx:showAdvancedNotification", -1, infosAnnounce.title, infosAnnounce.subtitle, infosAnnounce.message, infosAnnounce.banner, 1)
end

RegisterServerEvent("sLtd:sendAnnounce")
AddEventHandler("sLtd:sendAnnounce", function(type)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if LTD.allowJobs[xPlayer.job.name] == nil then return end

    ltdAnnounce(xPlayer.job.name, type)
end)

local function checkThePlayerLtd()
    local result = nil;
    local jobName = nil;

    for k,v in pairs(LTD.onService) do
        if result == nil then result = {} end
        result[k] = v
        jobName = v.job
    end

    if result then
        LTD.Entreprise = true
    else
        LTD.Entreprise = false
    end

    TriggerClientEvent("sLtd:updateState", -1, LTD.Entreprise)
end

RegisterServerEvent("sLtd:requestLoad")
AddEventHandler("sLtd:requestLoad", function()
    local source = source
    TriggerClientEvent("sLtd:updateState", source, LTD.Entreprise)
end)

RegisterServerEvent("sLtd:StateService")
AddEventHandler("sLtd:StateService", function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if LTD.allowJobs[xPlayer.job.name] == nil then return end
    
    if LTD.onService[source] then
        notifToEmployes("~b~"..GetIdentityPlayer(xPlayer.identifier).."~s~ à ~r~quitté~s~ son ~o~service~s~ !", LTD.onService[source].job)
        LTD.onService[source] = nil;
        checkThePlayerLtd()
    else
        LTD.onService[source] = {job = xPlayer.job.name}
        notifToEmployes("~b~"..GetIdentityPlayer(xPlayer.identifier).."~s~ à ~g~pris~s~ son ~o~service~s~ !", LTD.onService[source].job)
        checkThePlayerLtd()
    end
end)

RegisterServerEvent("sLtd:buyItem")
AddEventHandler("sLtd:buyItem", function(itemName)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    --[[ if LTD.Entreprise ~= false then
        banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : buy item ltd",
			description = "Anticheat : buy item ltd"
		})
		return 
    end ]]
    if LTD.allowItems[itemName] == nil then
        banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : buy item ltd",
			description = "Anticheat : buy item ltd"
		})
		return  
    end

    local infosItem = LTD.allowItems[itemName]

    if (xPlayer.getWeight()+(xPlayer.getInventoryItem(itemName).weight*1)) > ESX.GetConfig().MaxWeight then 
        return 
        TriggerClientEvent("Sneakyesx:showNotification", source, "~r~Vous n'avez pas assez de place sur vous !") 
    end        

    if xPlayer.getAccount('cash').money > infosItem.price then
        xPlayer.removeAccountMoney('cash', infosItem.price)
        xPlayer.addInventoryItem(itemName, 1)
        TriggerClientEvent("Sneakyesx:showNotification", source, "Vous avez acheté ~b~x1 "..ESX.GetItemLabel(itemName).."~s~ pour "..infosItem.price.."~g~$~s~ !")
    elseif xPlayer.getAccount('bank').money > infosItem.price then
        xPlayer.removeAccountMoney('bank', infosItem.price)
        xPlayer.addInventoryItem(itemName, 1)
        TriggerClientEvent("Sneakyesx:showNotification", source, "Vous avez acheté ~b~x1 "..ESX.GetItemLabel(itemName).."~s~ pour "..infosItem.price.."~g~$~s~ !")
    else
        return TriggerClientEvent("Sneakyesx:showNotification", source, "~r~Vous n'avez pas assez d'argent !")
    end
end)

CreateThread(function()
    while true do
        checkThePlayerLtd()
        Wait(60*1000)
    end
end)

AddEventHandler("playerDropped", function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if LTD.onService[source] then
        notifToEmployes("~b~"..GetIdentityPlayer(xPlayer.identifier).."~s~ à ~r~quitté~s~ son ~o~service~s~ !", LTD.onService[source].job)
        LTD.onService[source] = nil;
        checkThePlayerLtd()
    end
end)