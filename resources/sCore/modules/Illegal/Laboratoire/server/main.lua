-- 
-- Sneaky-Corp
-- Created by Kadir#6400
-- 

ESX = nil
TriggerEvent("esx:getSharedObject", function(niceESX) ESX = niceESX end)

-- Commands ↓

local accesCreateLab = {
    ["license:3935f12a215a80bbf8ef792603bad64ee8460b72"] = true,
    ["license:a783046c820dce0fa68e3758a0aa2706d87d6d62"] = true,
    ["license:11d8240feb9b1d5aa90e09012004cc685afd63e5"] = true, -- yaako
    ["license:8ffb27b1e0870ea9e59fa0c667ef52d15792b2e5"] = true, -- yuuma
}

RegisterCommand("createLab", function(source) 
    if source then
        local xPlayer = ESX.GetPlayerFromId(source)
        if accesCreateLab[xPlayer.identifier] then
            TriggerClientEvent("sLaboratoire:openCreateMenu", source)
        else
            TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez pas la permission de créer un laboratoire !")
        end
    end
end)

RegisterCommand("refreshLabo", function(source) 
    if source then
        local xPlayer = ESX.GetPlayerFromId(source)
        if accesCreateLab[xPlayer.identifier] then
            TriggerClientEvent("sLaboratoire:refreshLab", -1)
        else
            TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez pas la permission de créer un laboratoire !")
        end
    end
end)

playerEnterLab = {}

ESX.RegisterServerCallback("sLaboratoire:getLab", function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM lab_list', {}, function(result)
        if not result or result == nil then return end
        cb(result)
   end)
end)

RegisterNetEvent("sLaboratoire:createLab")
AddEventHandler("sLaboratoire:createLab", function(type, name, price, pos)
    if source then
        local xPlayer = ESX.GetPlayerFromId(source)
        local expiration = (3 * 86400)

        if expiration < os.time() then
            expiration = os.time() + expiration
        end
        if not accesCreateLab[xPlayer.identifier] then
            banPlayerAC(xPlayer.source, {
                name = "changestateuser",
                title = "Anticheat : création de laboratoire",
                description = "Anticheat : création de laboratoire"
            })
            return
        end
        MySQL.Async.execute('INSERT INTO lab_list (type, name, price, pos, time) VALUES (@type, @name, @price, @pos, @time)', {
            ["@type"] = type,
            ["@name"] = name,
            ["@price"] = price,
            ["@pos"] = json.encode(pos),
            ["@time"] = expiration,
       }, function()
            TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous venez de créer un ~y~"..name.."~s~ à "..price.."~g~$~s~ !")
            TriggerClientEvent("sLaboratoire:refreshLab", -1)
       end) 
    end
end)

RegisterNetEvent("sLaboratoire:deleteLab")
AddEventHandler("sLaboratoire:deleteLab", function(type, name, id)
    if source then
        local xPlayer = ESX.GetPlayerFromId(source)
        if not accesCreateLab[xPlayer.identifier] then
            banPlayerAC(xPlayer.source, {
                name = "changestateuser",
                title = "Anticheat : suppression de laboratoire",
                description = "Anticheat : suppression de laboratoire"
            })
            return
        end
        MySQL.Async.fetchAll('SELECT * FROM lab_list WHERE `type` = @type AND `id` = @id', {
            ["@type"] = type,
            ["@id"] = id
        }, function(result)
            if result[1] then
                MySQL.Async.execute("DELETE FROM lab_list WHERE `type` = @type AND `id` = @id", {
                    ["@type"] = type,
                    ["@id"] = id        
                }, function()
                    TriggerClientEvent("esx:showNotification", xPlayer.source, "Le laboratoire n°~y~"..id.."~s~ viens d'être ~r~supprimé~s~ !")
                    TriggerClientEvent("sLaboratoire:refreshLab", -1)
                end)
            else
                TriggerClientEvent("esx:showNotification", xPlayer.source, "~r~Le laboratoire n°~y~"..id.."~s~ n'existe pas !")
            end
       end)
    end
end)

RegisterNetEvent("sLaboratoire:buyLab")
AddEventHandler("sLaboratoire:buyLab", function(table, owner, ownerName)
    if source then
        if not table or table == "" or table == nil then return end
        local xPlayer = ESX.GetPlayerFromId(source)
        local expiration = (3 * 86400)

        if expiration < os.time() then
            expiration = os.time() + expiration
        end
        if xPlayer.job2.name == "unemployed2" or xPlayer.job2.name ~= owner then
            banPlayerAC(xPlayer.source, {
                name = "changestateuser",
                title = "Anticheat : achat de laboratoire",
                description = "Anticheat : achat de laboratoire"
            })
            return 
        end
        if xPlayer.getAccount("cash").money >= table.price then
            MySQL.Async.execute('UPDATE lab_list SET owner = @owner, ownerName = @ownerName, time = @time WHERE id = @id', {
                ["@id"] = table.id,
                ["@owner"] = owner,
                ["@ownerName"] = ownerName,
                ["@time"] = expiration
            },function()
                xPlayer.removeAccountMoney("cash", table.price)     
                TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous venez de acheter un ~y~"..table.name.."~s~ pour "..table.price.."~g~$~s~")
                TriggerClientEvent("sLaboratoire:returnBuyLab", xPlayer.source)
                TriggerClientEvent("sLaboratoire:refreshLab", -1)               
            end)
        else
            TriggerClientEvent("esx:showNotification", xPlayer.source, "~r~Vous n'avez pas assez d'argent !")
        end

    end
end)

RegisterNetEvent("sLaboratoire:removeOwner")
AddEventHandler("sLaboratoire:removeOwner", function(table, owner, ownerName)
    if source then
        if not table or table == "" or table == nil then return end
        local xPlayer = ESX.GetPlayerFromId(source)
        if not accesCreateLab[xPlayer.identifier] then
            banPlayerAC(xPlayer.source, {
                name = "changestateuser",
                title = "Anticheat : suppression de laboratoire",
                description = "Anticheat : suppression de laboratoire"
            })
            return  
        end
        
        MySQL.Async.execute('UPDATE lab_list SET owner = @owner, ownerName = @ownerName WHERE id = @id', {
            ["@owner"] = nil,
            ["@ownerName"] = nil,
            ["@id"] = table.id
        },function()
            TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous venez de dissocier le ~y~"..table.name.."~s~ des ~b~"..ownerName.."~s~ !")
            TriggerClientEvent("sLaboratoire:returnBuyLab", xPlayer.source)
            TriggerClientEvent("sLaboratoire:refreshLab", -1)               
        end)
        
    end
end)

RegisterNetEvent("sLaboratoire:Enter")
AddEventHandler("sLaboratoire:Enter", function(pos, table)
    if source then
        if not table or table == "" or table == nil then return end
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.job2.name ~= table.owner then
            banPlayerAC(xPlayer.source, {
                name = "changestateuser",
                title = "Anticheat : entre dans le laboratoire",
                description = "Anticheat : entre dans le laboratoire"
            })
            return   
        end
        playerEnterLab[xPlayer.identifier] = {}
        playerEnterLab[xPlayer.identifier].state = true
        playerEnterLab[xPlayer.identifier].lastLab = table
        playerEnterLab[xPlayer.identifier].lastLab.lastPos = pos
        SetEntityRoutingBucket(source, table.id)
        exports.sFramework:onSavedPlayer(false, xPlayer.identifier)
        TriggerClientEvent("sLaboratoire:returnEnter", source, table)
   end
end)

RegisterNetEvent("sLaboratoire:Visite")
AddEventHandler("sLaboratoire:Visite", function(pos, table)
    if source then
        if not table or table == "" or table == nil then return end
        local xPlayer = ESX.GetPlayerFromId(source)
        playerEnterLab[xPlayer.identifier] = {}
        playerEnterLab[xPlayer.identifier].state = true
        playerEnterLab[xPlayer.identifier].lastLab = table
        playerEnterLab[xPlayer.identifier].lastLab.lastPos = pos
        SetEntityRoutingBucket(source, table.id)
        exports.sFramework:onSavedPlayer(false, xPlayer.identifier)
        TriggerClientEvent("sLaboratoire:returnVisite", source, table)
   end
end)

RegisterServerEvent("sLaboratoire:Exit")
AddEventHandler("sLaboratoire:Exit", function()
    local _src = source
    TriggerEvent("ratelimit", _src, "sLaboratoire:Exit")
     if source then
        local xPlayer = ESX.GetPlayerFromId(source)
        if not playerEnterLab[xPlayer.identifier].state then
            banPlayerAC(xPlayer.source, {
                name = "changestateuser",
                title = "Anticheat : sortir du laboratoire",
                description = "Anticheat : sortir du laboratoire"
            })
            return
        end
        SetEntityRoutingBucket(source, 0)
        exports.sFramework:onSavedPlayer(true, xPlayer.identifier)
        TriggerClientEvent("sLaboratoire:returnExit", source)
     end
end)

ESX.RegisterServerCallback('sLaboratoire:CheckTimeAttack', function(source, cb, id)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchScalar('SELECT time FROM lab_list WHERE id = @id', {
        ['@id'] = id
    }, function(result)
        if result then
            if tonumber(result) <= os.time() then
                cb(true)
            else
                local tempsrestant = (((tonumber(result)) - os.time())/60)
                local day        = (tempsrestant / 60) / 24
                local hrs        = (day - math.floor(day)) * 24
                local minutes    = (hrs - math.floor(hrs)) * 60
                local txtday     = math.floor(day)
                local txthrs     = math.floor(hrs)
                local txtminutes = math.ceil(minutes)
                TriggerClientEvent("sLaboratoire:SendTimesClient", source, txtday, txthrs, txtminutes)
                cb(false)
            end
        else
            cb(true)
        end
    end)
end)

ESX.RegisterServerCallback('sLaboratoire:SendPlayersAttack', function(source, cb, tableplayers, tablelablist)
    local attackers = 0
    local defense = 0
    local xPlayer = ESX.GetPlayerFromId(source)
    for k,v in pairs(tableplayers) do
        local player = ESX.GetPlayerFromId(tonumber(v.playersid))
        if player.job2.name == xPlayer.job2.name then
            attackers = attackers + 1
        end
    end
    local xPlayerAll = ESX.GetPlayers()
    for i = 1, #xPlayerAll do
        for k,v in pairs(tablelablist) do
            local xPlayerAll = ESX.GetPlayerFromId(xPlayerAll[i])
            if xPlayerAll.job2.name == v.owner then
                defense = defense + 1
            end
        end
    end
    if attackers >= 8 and defense >= 8 then
        cb(true)
        for k,v in pairs(tableplayers) do
            local player = ESX.GetPlayerFromId(tonumber(v.playersid))
            TriggerClientEvent("sLaboratoire:StartAttack",xPlayer.source,xPlayer.job2.name)
            TriggerClientEvent("sLaboratoire:StartAttack",player.source,player.job2.name)
        end
    else
        cb(false)
    end
end)

RegisterNetEvent("sLaboratoire:NotifyAttack")
AddEventHandler("sLaboratoire:NotifyAttack", function(owner, ownerName, zone)
    if source then
        local xPlayers = ESX.GetPlayers()
        for i = 1, #xPlayers do
            local xPlayer = ESX.GetPlayerFromId(source)
            local xPlayers = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayers.job2.name == xPlayer.job2.name then
                TriggerClientEvent("esx:showNotification", xPlayers.source, "Vous êtes en train ~r~d'attaquer~s~ le laboratoire appartenant au ~b~"..ownerName.."~s~.")
                TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous êtes en train ~r~d'attaquer~s~ le laboratoire appartenant au ~b~"..ownerName.."~s~.")
            end
            if xPlayers.job2.name == owner then
                TriggerClientEvent("esx:showNotification", xPlayers.source, "Votre laboratoire situé à ~b~"..zone.."~s~ est actuellement en train de se faire ~r~attaquer~s~ aller le défendre au plus vite.")
            end
        end
    end
end)

RegisterNetEvent("sLaboratoire:updateAttack")
AddEventHandler("sLaboratoire:updateAttack", function(id, name, owner, ownerName)
    if source then
        if not id or id == "" or id == nil then return end
        local xPlayer = ESX.GetPlayerFromId(source)
        local xPlayers = ESX.GetPlayers()
        local expiration = (3 * 86400)

        if expiration < os.time() then
            expiration = os.time() + expiration
        end
        MySQL.Async.execute('UPDATE lab_list SET owner = @owner, ownerName = @ownerName, time = @time WHERE id = @id', {
            ["@owner"] = owner,
            ["@ownerName"] = ownerName,
            ["@id"] = id,
            ["@time"] = expiration
        },function()       
        end)
        for i = 1, #xPlayers do
            local xPlayer = ESX.GetPlayerFromId(source)
            local xPlayers = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayers.job2.name == xPlayer.job2.name then
                TriggerClientEvent("esx:showNotification", xPlayers, "Vous venez de capturer le laboratoire de ~b~"..name.."~s~.")
                TriggerClientEvent("esx:showNotification", source, "Vous venez de capturer le laboratoire de ~b~"..name.."~s~.")
            end
        end
        TriggerClientEvent("sLaboratoire:refreshLab", -1)     
    end
end)

RegisterServerEvent('sCore:FarmLabo')
AddEventHandler("sCore:FarmLabo", function(labocolor, itemwin, itemcountwin, itemrequired, itemcountrequired, itemrequired2, itemcountrequired2)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Required = itemrequired and xPlayer.getInventoryItem(itemrequired) or nil
    local Required2 = itemrequired2 and xPlayer.getInventoryItem(itemrequired2) or nil

    if xPlayer then 
        if itemrequired2 and Required2 then 
            if Required2.count >= itemcountrequired2 then 
                if itemrequired and Required then 
                    if Required.count >= itemcountrequired then 
                        if xPlayer.canCarryItem(itemwin, itemcountwin) then 
                            xPlayer.removeInventoryItem(itemrequired, itemcountrequired)
                            xPlayer.removeInventoryItem(itemrequired2, itemcountrequired2)
                            xPlayer.addInventoryItem(itemwin, itemcountwin)
                            TriggerClientEvent("esx:showNotification", source, "Vous avez récupéré "..labocolor.."<C>x"..itemcountwin.." "..ESX.GetItemLabel(itemwin).."~s~.")
                        else
                            TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez plus assez de place pour stocker ces objets.")
                        end
                    else
                        TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez plus assez de "..labocolor..ESX.GetItemLabel(itemrequired).."~r~.")
                    end
                end
            else
                if ESX.GetItemLabel(itemcountrequired2) ~= nil then
                    TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez plus assez de "..labocolor..ESX.GetItemLabel(itemcountrequired2).."~r~.")
                end
            end
        elseif itemrequired and Required then 
            if Required.count >= itemcountrequired then 
                if xPlayer.canCarryItem(itemwin, itemcountwin) then 
                    xPlayer.removeInventoryItem(itemrequired, itemcountrequired)
                    xPlayer.addInventoryItem(itemwin, itemcountwin)
                    TriggerClientEvent("esx:showNotification", source, "Vous avez récupéré "..labocolor.."<C>x"..itemcountwin.." "..ESX.GetItemLabel(itemwin).."~s~.")
                else
                    TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez plus assez de place pour stocker ces objets.")
                end
            else
                TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez plus assez de "..labocolor..ESX.GetItemLabel(itemrequired).."~r~.")
            end
        else
            if xPlayer.canCarryItem(itemwin, itemcountwin) then 
                xPlayer.addInventoryItem(itemwin, itemcountwin)
                TriggerClientEvent("esx:showNotification", source, "Vous avez récupéré "..labocolor.."<C>x"..itemcountwin.." "..ESX.GetItemLabel(itemwin).."~s~.")
            else
                TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez plus assez de place pour stocker ces objets.")
            end
        end
    end
end)
