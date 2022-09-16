ESX = nil
TriggerEvent("Sneakyesx:getSharedObject", function(SneakyESX) ESX = SneakyESX end)

sPropertyManager = {}
sPropertyManager.instanceRange = 1000
sPropertyManager.list = {}
sPropertyManager.Keys = {
    jobList = {
        ["mecano"] = {label = "Bennys"},
        ["police"] = {label = "Los Santos Police Department"},
        ["ambulance"] = {label = "Los Santos Medical Center"},
        ["carshop"] = {label = "Concessionnaire Voiture"},
        ["motoshop"] = {label = "Concessionnaire Moto"},
        ["agentimmo"] = {label = "Agence immobilière"},
        ["unicorn"] = {label = "Unicorn"},
        ["burgershot"] = {label = "Burger Shot"},
        ["pizza"] = {label = "Drusilla's Pizza"},
        ["lssd"] = {label = "Los Santos Sheriff Department"},
        ["yellowjack"] = {label = "Yellowjack"},
        ["gouvernement"] = {label = "Gouvernement"},
        ["fbi"] = {label = "Federal Bureau of Investigation"},
        ["noodle"] = {label = "Noodle Exchange"},
        ["taxi"] = {label = "Downtown Cab Co"},
        ["ltd_nord"] = {label = "LTD Nord"},
        ["ltd_sud"] = {label = "LTD Sud"},
        ["bahamas"] = {label = "Bahamas Mamas"}
    },
    groupList = {
        ["biker"] = {label = "Biker"},
        ["madrazo"] = {label = "Madrazo"},
        ["families"] = {label = "Families"},
        ["ballas"] = {label = "Ballas"},
        ["marabunta"] = {label = "Marabunta"},
        ["vagos"] = {label = "Vagos"},
        ["zetas"] = {label = "Zetas"},
        ["mnc"] = {label = "Minnightclick"},
        ["cosanostra"] = {label = "Cosanostra"},
        ["coronado"] = {label = "Coronado"},
        ["aztecas"] = {label = "Aztecas"},
        ["mayans"] = {label = "Mayans"},
        ["hudson"] = {label = "Hudson"},
        ["triade"] = {label = "Triade"},
        ["mcreary"] = {label = "Mcreary"},
        ["kkangpae"] = {label = "Kkangpae"},
        ["bandadiaz"] = {label = "bandadiaz"},
        ["blueboys"] = {label = "blueboys"},
        ["mafiaarmenienne"] = {label = "Mafia arménienne"},
        ["professionnels"] = {label = "Les professionnels"},
        ["reiffen"] = {label = "Reiffen"},
        ["jashari"] = {label = "Mafia jashari"},
        ["aod"] = {label = "Angels of Death"},
        ["loco"] = {label = "Loco syndicate"},
    },
}
sPropertyManager.sonneSpam = {}

local function addProperty(info, needDecode)
    local property
    if needDecode then
        property = Property(info.id, info.owner, json.decode(info.infos), info.ownerInfo, json.decode(info.inventory), json.decode(info.keys), info.street)
    else
        property = Property(info.id, info.owner, info.infos, info.ownerInfo, info.inventory, info.keys, info.street)
    end
    sPropertyManager.list[property.propertyId] = property
end

local function createProperty(data, author, street)
    local player = ESX.GetPlayerFromId(author)
    if player then
        MySQL.Async.insert("INSERT INTO property (`owner`, `ownerInfo`, `infos`, `inventory`, `keys`, `createdAt`, `createdBy`, `street`) VALUES(@a, @b, @c, @d, @e, @f, @g, @h)", {
            ['a'] = "none",
            ['b'] = "none",
            ['c'] = json.encode(data),
            ['d'] = json.encode({}),
            ['e'] = json.encode({}),
            ['f'] = os.time(),
            ['g'] = player.identifier,
            ['h'] = street
        }, function()
            local insertId = MySQL.Sync.fetchScalar("SELECT MAX(id) FROM property")
            addProperty({ id = insertId, owner = "none", infos = data, ownerInfo = "none", inventory = {}, keys = {}, street = street }, false)
            TriggerClientEvent("Sneakyesx:showNotification", author, "~g~Création de la propriété effectuée !")
            TriggerClientEvent("sProperty:returnProperty", -1, sPropertyManager.list)

            local xPlayers = ESX.GetPlayers()
            for i = 1, #xPlayers, 1 do
                local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                local license = xPlayer.identifier
                local allowed = {}
                local available = {}
                local owned = {}
                for propertyID, property in pairs(sPropertyManager.list) do
                    if property.ownerLicense == "none" then
                        available[propertyID] = property.info.pos
                    else
                        if property.ownerLicense == license then
                            owned[propertyID] = property.info.pos
                        end
                    end
                end
                TriggerClientEvent("sProperty:cbavailableProperties", xPlayer.source, license, available, owned, allowed)
            end

        end)
    end
end

RegisterServerEvent("sProperty:saveProperty")
AddEventHandler("sProperty:saveProperty", function(info, street)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if xPlayer.job.name ~= "agentimmo" then
            banPlayerAC(xPlayer.source, {
                name = "changestateuser",
                title = "Anticheat : création de propriété",
                description = "Anticheat : création de propriété"
            })
            return 
        end
        createProperty(info, source, street)
        local infosproperty = json.encode(info)
        exports.sCore:SendLogs(1752220,"Création de propriété",""..GetPlayerName(source).." vient de créer la propriété : **"..infosproperty.."\n License de la source : "..xPlayer.identifier,"https://discord.com/api/webhooks/878556554138365973/y0tWXNxWMx1hCZb25rSJewXnyWtqoaAElPBaVdnol3hNdFSINf9FzAVG5RP_YB53ECr_")
    end
end)

RegisterServerEvent("sProperty:requestList")
AddEventHandler("sProperty:requestList", function()
    if source then 
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            TriggerClientEvent("sProperty:returnProperty", xPlayer.source, sPropertyManager.list)
        end
    end
end)

local function loadProperties()
    MySQL.Async.fetchAll("SELECT * FROM property", {}, function(properties)
        local count = 0
        for id, info in pairs(properties) do
            count = count + 1
            addProperty(info, true)
        end
        if count >= 1 then
            print("[^3sProperty^0]: Nous avons ajouté "..count.." propriété(s) via la base de donnée !")
        end
    end)
end

Citizen.CreateThread(function()
    loadProperties()
end)

RegisterServerEvent("sProperty:requestInventory")
AddEventHandler("sProperty:requestInventory", function(propertyId)
    
    if sPropertyManager.list[propertyId] == nil then
        return
    end

    local source = source
    TriggerClientEvent("sProperty:returnInventory", source, sPropertyManager.list[propertyId].inventory)

end)

RegisterServerEvent("sProperty:addItems")
AddEventHandler("sProperty:addItems", function(propertyId, type, name, count, ammo)
    local labelmoney = ""
    if sPropertyManager.list[propertyId] == nil then
        return
    end

    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local license = xPlayer.identifier
        local property = sPropertyManager.list[propertyId]

        for k, v in pairs(sPropertyManager.list[propertyId].inventory) do
            if v.name == name then
                lastCount = v.count
                lastKle = k
                exist = true
            end
        end

        if type == "item" then
            local limitCount = xPlayer.getInventoryItem(name).count
            if count > limitCount then return TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "~r~Vous n'avez pas cela sur vous !") end
            if exist then
                xPlayer.removeInventoryItem(name, count)
                exports.sCore:SendLogs(1752220,"Déposer coffre item (propriété)",""..GetPlayerName(source).." vient de déposer "..type.." de "..name.." : "..count.." dans la propriété avec l'ID : "..propertyId.." \n License de la source : "..xPlayer.identifier,"https://discord.com/api/webhooks/878551131322736660/oZtXJHEbfIthun_croBx91DZ7HGZo4SlRSiGv9QJLNkdJMGKkE6M8yEGGZn_ZZUvg7Rn")
                sPropertyManager.list[propertyId].inventory[lastKle].count = lastCount+count
                TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "Vous avez ajouté ~b~x"..count.." de "..ESX.GetItemLabel(name).."~s~ qui vous fais au total (~b~x"..lastCount+count.." "..ESX.GetItemLabel(name).."~s~) !")
                lastCount = 0
                exist = false
            else
                xPlayer.removeInventoryItem(name, count)
                exports.sCore:SendLogs(1752220,"Déposer coffre item (propriété)",""..GetPlayerName(source).." vient de déposer "..type.." de "..name.." : "..count.." dans la propriété avec l'ID : "..propertyId.." \n License de la source : "..xPlayer.identifier,"https://discord.com/api/webhooks/878551131322736660/oZtXJHEbfIthun_croBx91DZ7HGZo4SlRSiGv9QJLNkdJMGKkE6M8yEGGZn_ZZUvg7Rn")
                table.insert(sPropertyManager.list[propertyId].inventory, {type = type, label = ESX.GetItemLabel(name), name = name, count = count})
                TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "Vous avez ajouté ~b~x"..count.." de "..ESX.GetItemLabel(name).."~s~ !")
            end
        elseif type == "money" then
            local limitCount = xPlayer.getAccount(name).money
            if count > limitCount then return TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "~r~Vous n'avez pas cela sur vous !") end
                if name == "cash" then
                    labelmoney = "Argent liquide"
                else
                    labelmoney = "Argent sale"
                end
                xPlayer.removeAccountMoney(name, count)
                if exist then 
                    sPropertyManager.list[propertyId].inventory[lastKle].count = lastCount+count
                else
                    table.insert(sPropertyManager.list[propertyId].inventory, {type = type, label = labelmoney, name = name, count = count})
                end
                exports.sCore:SendLogs(1752220,"Déposer coffre argent (propriété)",""..GetPlayerName(source).." vient de déposer "..type.." de "..name.." : "..count.." dans la propriété avec l'ID : "..propertyId.." \n License de la source : "..xPlayer.identifier,"https://discord.com/api/webhooks/878551131322736660/oZtXJHEbfIthun_croBx91DZ7HGZo4SlRSiGv9QJLNkdJMGKkE6M8yEGGZn_ZZUvg7Rn")
                TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "Vous avez ajouté "..count.."~g~$~s~ de "..labelmoney.."~s~.")
                exist = false
        elseif type == "weapon" then
            local infoLoadout, infoWeapon = xPlayer.getWeapon(name)
            if xPlayer.hasWeapon(name) then
                xPlayer.removeWeapon(name)
            end
            exports.sCore:SendLogs(1752220,"Déposer coffre weapon (propriété)",""..GetPlayerName(source).." vient de déposer "..type.." de "..infoWeapon.label.." : "..count.." dans la propriété avec l'ID : "..propertyId.." \n License de la source : "..xPlayer.identifier,"https://discord.com/api/webhooks/878551131322736660/oZtXJHEbfIthun_croBx91DZ7HGZo4SlRSiGv9QJLNkdJMGKkE6M8yEGGZn_ZZUvg7Rn")
            table.insert(sPropertyManager.list[propertyId].inventory, {type = type, label = infoWeapon.label, name = name, count = count, ammo = ammo})
            TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "Vous avez déposé ~b~un(e) "..infoWeapon.label.."~s~ avec ~o~"..ammo.."munition(s)~s~ !")
        end
        TriggerClientEvent("sProperty:returnInventory", xPlayer.source, sPropertyManager.list[propertyId].inventory)
    end

end)

RegisterServerEvent("sProperty:removeItems")
AddEventHandler("sProperty:removeItems", function(propertyId, type, name, count, ammo)
    if sPropertyManager.list[propertyId] == nil then
        return
    end

    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local license = xPlayer.identifier
        local property = sPropertyManager.list[propertyId]

        for k, v in pairs(sPropertyManager.list[propertyId].inventory) do
            if v.name == name then
                niceCount = v.count
                niceKle = k
                exist = true
            end
        end
        
        if not exist then return end

        if niceCount == nil then niceCount = 1 end
        if count > niceCount then
            return TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "~r~Il n'y a pas tout sa dans le coffre !")
        else
            if type == "money" then
                if name == "cash" then
                    labelmoney = "Argent liquide"
                    xPlayer.addAccountMoney(name, count)
                
                    local total = niceCount-count
                    if total < 1 then 
                        table.remove(sPropertyManager.list[propertyId].inventory, niceKle)
                    else
                        sPropertyManager.list[propertyId].inventory[niceKle].count = total
                    end
                    exports.sCore:SendLogs(1752220,"Retirer coffre argent (propriété)",""..GetPlayerName(source).." vient de retirer "..type.." de "..name.." : "..count.." dans la propriété avec l'ID : "..propertyId.." \n License de la source : "..xPlayer.identifier,"https://discord.com/api/webhooks/878551131322736660/oZtXJHEbfIthun_croBx91DZ7HGZo4SlRSiGv9QJLNkdJMGKkE6M8yEGGZn_ZZUvg7Rn")
                    TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "Vous avez retirer "..count.."~g~$~s~ de "..labelmoney.." !")
                    TriggerClientEvent("sProperty:returnInventory", xPlayer.source, sPropertyManager.list[propertyId].inventory)
                    niceCount = 0
                    niceKle = 0
                    exist = false
                elseif name == "dirtycash" then
                    labelmoney = "Argent non-déclaré"
                    xPlayer.addAccountMoney(name, count)
                
                    local total = niceCount-count
                    if total < 1 then 
                        table.remove(sPropertyManager.list[propertyId].inventory, niceKle)
                    else
                        sPropertyManager.list[propertyId].inventory[niceKle].count = total
                    end
                    exports.sCore:SendLogs(1752220,"Retirer coffre argent sale (propriété)",""..GetPlayerName(source).." vient de retirer "..type.." de "..name.." : "..count.." dans la propriété avec l'ID : "..propertyId.." \n License de la source : "..xPlayer.identifier,"https://discord.com/api/webhooks/878551131322736660/oZtXJHEbfIthun_croBx91DZ7HGZo4SlRSiGv9QJLNkdJMGKkE6M8yEGGZn_ZZUvg7Rn")
                    TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "Vous avez retirer "..count.."~g~$~s~ de "..labelmoney.." !")
                    TriggerClientEvent("sProperty:returnInventory", xPlayer.source, sPropertyManager.list[propertyId].inventory)
                    niceCount = 0
                    niceKle = 0
                    exist = false
                end
            elseif type == "item" then
                xPlayer.addInventoryItem(name, count)
                
                local total = niceCount-count
                if total < 1 then 
                    table.remove(sPropertyManager.list[propertyId].inventory, niceKle)
                else
                    sPropertyManager.list[propertyId].inventory[niceKle].count = total
                end
                exports.sCore:SendLogs(1752220,"Retirer coffre item (propriété)",""..GetPlayerName(source).." vient de retirer "..type.." de "..name.." : "..count.." dans la propriété avec l'ID : "..propertyId.." \n License de la source : "..xPlayer.identifier,"https://discord.com/api/webhooks/878551131322736660/oZtXJHEbfIthun_croBx91DZ7HGZo4SlRSiGv9QJLNkdJMGKkE6M8yEGGZn_ZZUvg7Rn")
                TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "Vous avez retirer ~b~x"..count.." de "..ESX.GetItemLabel(name).."~s~ !")
                TriggerClientEvent("sProperty:returnInventory", xPlayer.source, sPropertyManager.list[propertyId].inventory)
                niceCount = 0
                niceKle = 0
                exist = false
            elseif type == "weapon" then
                itemName = string.upper(name)

			    if xPlayer.hasWeapon(itemName) then
                    TriggerClientEvent("Sneakyesx:showNotification",source,"Vous ne pouvez pas prendre deux fois la même ~r~arme~s~.")
                else
                    xPlayer.addWeapon(name, ammo)
                    table.remove(sPropertyManager.list[propertyId].inventory, niceKle)
                    exports.sCore:SendLogs(1752220,"Retirer coffre weapon (propriété)",""..GetPlayerName(source).." vient de retirer "..type.." de "..ESX.GetWeaponLabel(name).." avec "..ammo.." munition(s) : "..count.." dans la propriété avec l'ID : "..propertyId.." \n License de la source : "..xPlayer.identifier,"https://discord.com/api/webhooks/878551131322736660/oZtXJHEbfIthun_croBx91DZ7HGZo4SlRSiGv9QJLNkdJMGKkE6M8yEGGZn_ZZUvg7Rn")
                    TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "Vous avez retirer ~b~x"..count.." de "..ESX.GetWeaponLabel(name).."~s~ avec ~o~"..ammo.."munition(s)~s~ !")
                    TriggerClientEvent("sProperty:returnInventory", xPlayer.source, sPropertyManager.list[propertyId].inventory)
                    niceCount = 0
                    niceKle = 0
                    exist = false
                end
            end
        end

    end

end)

local loadedKeys = {}
RegisterServerEvent("sProperty:requestKeysList")
AddEventHandler("sProperty:requestKeysList", function()
    if loadedKeys[source] ~= nil then return end
    TriggerClientEvent("sProperty:returnKeysList", source, sPropertyManager.Keys.jobList, sPropertyManager.Keys.groupList)
    loadedKeys[source] = "loaded!"
end)

RegisterServerEvent("sProperty:requestKeysAccess")
AddEventHandler("sProperty:requestKeysAccess", function(propertyId)
    if not loadedKeys[source] then return end
    if sPropertyManager.list[propertyId].keys == nil then sPropertyManager.list[propertyId].keys = {} end
    TriggerClientEvent("sProperty:returnCallBackKeys", source, sPropertyManager.list[propertyId].keys)
end)

RegisterServerEvent("sProperty:getKeysAccesPlayer")
AddEventHandler("sProperty:getKeysAccesPlayer", function(propertyId)
    if not loadedKeys[source] then return end
    if sPropertyManager.list[propertyId].keys == nil then sPropertyManager.list[propertyId].keys = {} end
    
    local xPlayer = ESX.GetPlayerFromId(source)
    local license, job, job2 = xPlayer.identifier, xPlayer.job.name, xPlayer.job2.name
    if sPropertyManager.list[propertyId].keys[license] ~= nil or sPropertyManager.list[propertyId].keys[job] ~= nil or sPropertyManager.list[propertyId].keys[job2] ~= nil then
        TriggerClientEvent("sProperty:returnPlayerAcces", source, propertyId, true)
    else
        TriggerClientEvent("sProperty:returnPlayerAcces", source, propertyId, false)
    end
end)

RegisterServerEvent("sProperty:addKeysAccess")
AddEventHandler("sProperty:addKeysAccess", function(propertyId, type, label, name)
    if not loadedKeys[source] then return end

    if sPropertyManager.list[propertyId].keys == nil then sPropertyManager.list[propertyId].keys = {} end

    if type == "jobList" then
        if sPropertyManager.Keys.jobList[name] == nil then return end
        if sPropertyManager.list[propertyId].keys[name] ~= nil then return TriggerClientEvent("Sneakyesx:showNotification", source, "~r~Erreur~s~~n~Le métier à déjà une clé !") end 
        TriggerClientEvent("Sneakyesx:showNotification", source, "Vous avez donné les clé au métier ~b~"..label.."~s~ !")
        TriggerClientEvent("sProperty:returnCallBackKeys", -1, sPropertyManager.list[propertyId].keys)
        TriggerClientEvent("sProperty:returnPlayerAcces", -1, propertyId, nil)
        onRequest = false
        nice = true
    elseif type == "groupList" then
        if sPropertyManager.Keys.groupList[name] == nil then return end
        if sPropertyManager.list[propertyId].keys[name] ~= nil then return TriggerClientEvent("Sneakyesx:showNotification", source, "~r~Erreur~s~~n~Le groupe à déjà une clé !") end 
        TriggerClientEvent("Sneakyesx:showNotification", source, "Vous avez donné les clé au groupe ~b~"..label.."~s~ !")
        TriggerClientEvent("sProperty:returnCallBackKeys", -1, sPropertyManager.list[propertyId].keys)
        TriggerClientEvent("sProperty:returnPlayerAcces", -1, propertyId, nil)
        onRequest = false
        nice = true
    elseif type == "person" then
        if name then
            local player = ESX.GetPlayerFromId(name)
            if player then
                name = player.identifier
                if sPropertyManager.list[propertyId].keys[name] ~= nil then return TriggerClientEvent("Sneakyesx:showNotification", source, "~r~Erreur~s~~n~Le joueur à déjà une clé !") end 
                TriggerClientEvent("Sneakyesx:showNotification", source, "Vous avez donné les clé à ~b~"..player.name.."~s~ !")
                TriggerClientEvent("sProperty:returnCallBackKeys", -1, sPropertyManager.list[propertyId].keys)
                TriggerClientEvent("sProperty:returnPlayerAcces", player.source, propertyId, true)
                MySQL.Async.execute("UPDATE property SET `keys` = @keys WHERE `id` = @propertyId", {
                    ["@propertyId"] = propertyId,
                    ["@keys"] = json.encode(sPropertyManager.list[propertyId].keys)
                })   
                namePerson = player.name
                onRequest = false
                nice = true
            else
                onRequest = false
                nice = false
            end
        else
            onRequest = false
            nice = false
        end
    end

    while onRequest do
        Wait(50)
    end
    
    if nice then
        if type == "jobList" or type == "groupList" then
            sPropertyManager.list[propertyId].keys[name] = {type = type, name = name}
        else
            sPropertyManager.list[propertyId].keys[name] = {type = type, license = name, name = namePerson}
        end 
    end

end)

RegisterServerEvent("sProperty:removeKeysAccess")
AddEventHandler("sProperty:removeKeysAccess", function(propertyId, type, label, name)
    if not loadedKeys[source] then return end

    if sPropertyManager.list[propertyId].keys == nil then sPropertyManager.list[propertyId].keys = {} end

    if type == "jobList" then
        if sPropertyManager.Keys.jobList[name] == nil then return end
        TriggerClientEvent("Sneakyesx:showNotification", source, "Vous avez retiré les clé au métier ~b~"..label.."~s~ !")
        TriggerClientEvent("sProperty:returnPlayerAcces", -1, propertyId, nil)
        onRequest = false
        nice = true
    elseif type == "groupList" then
        if sPropertyManager.Keys.groupList[name] == nil then return end
        TriggerClientEvent("Sneakyesx:showNotification", source, "Vous avez retiré les clé au groupe ~b~"..label.."~s~ !")
        TriggerClientEvent("sProperty:returnPlayerAcces", -1, propertyId, nil)
        onRequest = false
        nice = true
    elseif type == "person" then
        if name then
            local player = ESX.GetPlayerFromIdentifier(name)
            if player then
                TriggerClientEvent("Sneakyesx:showNotification", source, "Vous avez retiré les clé à ~b~"..label.."~s~ !")
                TriggerClientEvent("sProperty:returnPlayerAcces", player.source, propertyId, false)
                MySQL.Async.execute("UPDATE property SET `keys` = @keys WHERE `id` = @propertyId", {
                    ["@propertyId"] = propertyId,
                    ["@keys"] = json.encode(sPropertyManager.list[propertyId].keys)
                })  
                onRequest = false
                nice = true
            else
                onRequest = false
                nice = false
            end
        else
            onRequest = false
            nice = false
        end
    end
    
    while onRequest do
        Wait(50)
    end

    if nice then
        sPropertyManager.list[propertyId].keys[name] = nil
        TriggerClientEvent("sProperty:returnCallBackKeys", -1, sPropertyManager.list[propertyId].keys)

        MySQL.Async.execute("UPDATE property SET `keys` = @keys WHERE `id` = @propertyId", {
            ["@propertyId"] = propertyId,
            ["@keys"] = json.encode(sPropertyManager.list[propertyId].keys)
        })
    end

end)

RegisterServerEvent("sProperty:requestavailableProperties")
AddEventHandler("sProperty:requestavailableProperties", function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local license = xPlayer.identifier
        local allowed = {}
        local available = {}
        local owned = {}
        for propertyId, property in pairs(sPropertyManager.list) do
            if property.ownerLicense == "none" then
                available[propertyId] = property.info.pos
            else
                if property.ownerLicense == license then
                    owned[propertyId] = property.info.pos
                end
            end
        end
        TriggerClientEvent("sProperty:cbavailableProperties", source, license, available, owned, allowed)
    end
end)

RegisterServerEvent("sProperty:exitProperty")
AddEventHandler("sProperty:exitProperty", function(propertyId)

    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then

        while GetPlayerRoutingBucket(source) ~= 0 do
            Wait(50)
            SetPlayerRoutingBucket(source, 0)
        end
        exports.sFramework:onSavedPlayer(true, xPlayer.identifier)
    end

end)

RegisterServerEvent("sProperty:enter")
AddEventHandler("sProperty:enter", function(propertyId, owner)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if sPropertyManager.list[propertyId] == nil then
        return
    end

    local license = xPlayer.identifier
    local property = sPropertyManager.list[propertyId]

    Property:enter(xPlayer.source, propertyId, owner)
    TriggerClientEvent("sProperty:SendIdProperty", source, propertyId)
end)

local cbRequest
RegisterServerEvent("sProperty:requestInvitePlayer")
AddEventHandler("sProperty:requestInvitePlayer", function(propertyId, owner)

    if sPropertyManager.list[propertyId] == nil then
        return
    end

    cbRequest = nil
    
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local name = xPlayer.name
        local license = xPlayer.identifier

        local property = sPropertyManager.list[propertyId] 
        local ownerLicense = property.ownerLicense
        local online = ESX.GetPlayerFromIdentifier(ownerLicense)
        lastRequest = math.random(1,100)

        if online == nil then return TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "~r~Erreur~s~~n~La personne n'est pas disponible !") end
        
        TriggerClientEvent("Sneakyesx:showNotification", source, "~b~Sonnette~s~~n~Vous avez envoyer une demande !")

        TriggerClientEvent("sProperty:returnInvitePlayer", online.source, name, lastRequest)

        while cbRequest == nil do
            Wait(50)
        end

        if cbRequest == true then
            Property:enter(xPlayer.source, propertyId, owner)
            TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "Inviation~n~Le ~b~propriétaire~s~ à accepté votre invitation !")
        else
            TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "Inviation~n~Le ~b~propriétaire~s~ à refusé votre invitation !")
        end

    end
end)

RegisterServerEvent("sProperty:returnCbInvite")
AddEventHandler("sProperty:returnCbInvite", function(request, cb)
    if request ~= lastRequest then return end
    cbRequest = cb
end)

AddEventHandler("onResourceStop", function(res)
    if res == GetCurrentResourceName() then
        for k,v in pairs(sPropertyManager.list) do

            while sPropertyManager.list[v.propertyId] == nil do
                Wait(50)
            end

            if sPropertyManager.list[v.propertyId].inventory == nil then sPropertyManager.list[v.propertyId].inventory = {} end
            if sPropertyManager.list[v.propertyId].keys == nil then sPropertyManager.list[v.propertyId].keys = {} end
            MySQL.Async.execute("UPDATE property SET `keys` = @keys, `inventory` = @inventory WHERE `id` = @propertyId", {
                ["@propertyId"] = v.propertyId,
                ["@keys"] = json.encode(sPropertyManager.list[v.propertyId].keys),
                ["@inventory"] = json.encode(sPropertyManager.list[v.propertyId].inventory),
            })
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(60*1000*5)
        for k,v in pairs(sPropertyManager.list) do
            
            while sPropertyManager.list[v.propertyId] == nil do
                Wait(50)
            end

            if sPropertyManager.list[v.propertyId].inventory == nil then sPropertyManager.list[v.propertyId].inventory = {} end
            if sPropertyManager.list[v.propertyId].keys == nil then sPropertyManager.list[v.propertyId].keys = {} end
            MySQL.Async.execute("UPDATE property SET `keys` = @keys, `inventory` = @inventory WHERE `id` = @propertyId", {
                ["@propertyId"] = v.propertyId,
                ["@keys"] = json.encode(sPropertyManager.list[v.propertyId].keys),
                ["@inventory"] = json.encode(sPropertyManager.list[v.propertyId].inventory),
            })
        end
    end
end)
