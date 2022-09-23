ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand("creator", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= "user" then
        local id = args[1]
        if not id then
            TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez pas saisie un ID !")
        else
            local tPlayer = ESX.GetPlayerFromId(id)
            if tPlayer then
                TriggerClientEvent("OpenCreatorMenu", id) 
            else
                TriggerClientEvent("esx:showNotification", source, "~r~L'ID saisie est incorrecte !")
            end
        end
    end
end)

local instances = {}
 
RegisterServerEvent("instancecreator:set")
AddEventHandler("instancecreator:set", function(set)
    local _src = source
	TriggerEvent("ratelimit", _src, "instancecreator:set")
    SetEntityRoutingBucket(source, source)
end)

local instances2 = {}
RegisterServerEvent("instancecreator:reset")
AddEventHandler("instancecreator:reset", function()
    local _src = source
	TriggerEvent("ratelimit", _src, "instancecreator:reset")
    local src = source
    SetEntityRoutingBucket(source, 0)
end)


RegisterNetEvent('core:CreateIdentity')
AddEventHandler('core:CreateIdentity', function(data)
    local playerSrc = source

    if (not playerSrc) then return end

    local playerSelected = ESX.GetPlayerFromId(playerSrc)
    if (not playerSelected) then return end

    MySQL.Async.execute('UPDATE users SET `firstname` = @firstname, `lastname` = @lastname, `birthday` = @birthday, `height` = @height, `sex` = @sex WHERE identifier = @identifier', {
      ['@firstname'] = data.firstname,
      ['@lastname'] = data.lastname,
      ['@birthday'] = data.birthday,
      ['@height'] = data.height,
      ['@sex'] = data.sex,
      ['@identifier'] = playerSelected.identifier
    }, function(success)
        local newIdentity = {
            firstname = data.firstname,
            lastname = data.lastname,
            birthday = data.birthday,
            sex = data.sex,
            height = data.height
        }
        UpdateIdentity(playerSelected.identifier, newIdentity)
    end)
end)