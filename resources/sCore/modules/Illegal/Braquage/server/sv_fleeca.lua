Fleeca = Fleeca or {}

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Fleeca.BanksRobbed = {}

RegisterServerEvent('cFleeca:OpenDoor')
AddEventHandler('cFleeca:OpenDoor', function(getObjdoor, doorpos)
    local _src = source
    TriggerEvent("ratelimit", _src, "cFleeca:OpenDoor")
    TriggerClientEvent("cFleeca:OpenDoor", -1, getObjdoor, doorpos)
end)

RegisterServerEvent('cFleeca:CloseDoor')
AddEventHandler('cFleeca:CloseDoor', function(getObjdoor, doorpos)
    local _src = source
    TriggerEvent("ratelimit", _src, "cFleeca:CloseDoor")
    TriggerClientEvent("cFleeca:CloseDoor", -1, getObjdoor, doorpos)
end)

RegisterServerEvent('cFleeca:SetCooldown')
AddEventHandler('cFleeca:SetCooldown', function(id)
    local _src = source
    TriggerEvent("ratelimit", _src, "cFleeca:SetCooldown")
    Fleeca.BanksRobbed[id]= os.time()
end)

RegisterServerEvent("cFleeca:GetCoolDown")
AddEventHandler("cFleeca:GetCoolDown", function(id)
    local _src = source
    TriggerEvent("ratelimit", _src, "cFleeca:GetCoolDown")
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
    if Fleeca.BanksRobbed[id] then 
        if (os.time() - Fleeca.CoolDown) > Fleeca.BanksRobbed[id] then 
            xPlayer.removeInventoryItem("id_card_f", 1)
            TriggerClientEvent("cFleeca:BinginDrill", _source)
        else
            TriggerClientEvent("esx:showNotification", _source, "Cette banque a déjà été braqué.")
        end
    else
        xPlayer.removeInventoryItem("id_card_f", 1)
        TriggerClientEvent("cFleeca:BinginDrill", _source)
    end
end)

RegisterServerEvent('cFleeca:GiveMoney')
AddEventHandler('cFleeca:GiveMoney', function(money)
    local _src = source
    TriggerEvent("ratelimit", _src, "cFleeca:GiveMoney")
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addAccountMoney('cash', money)
end)

ESX.RegisterUsableItem("id_card_f", function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
    local Players = ESX.GetPlayers()
	local copsOnDuty = 0

    for i = 1, #Players do
        local xPlayer = ESX.GetPlayerFromId(Players[i])
        if xPlayer.job.name == "police" or xPlayer.job.name == "lssd" then
            copsOnDuty = copsOnDuty + 1
        end
    end

    if copsOnDuty >= Fleeca.RequiredCops then 
        TriggerClientEvent("cFleeca:StartDrill", xPlayer.source)
    else
        TriggerClientEvent("esx:showNotification", _source, "La Brinks viens de passer, il n'y a plus d'argent.")
    end
end)