ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

sGarageManager = {}
sGarageManager.instanceRange = 1000
sGarageManager.list = {}
sGarageManager.enterPlayers = {}

local function addGarage(info, needDecode)
    local garage
    if needDecode then
        garage = Garage(info.id, info.owner, json.decode(info.infos), info.ownerInfo, json.decode(info.vehicles), info.street)
    else
        garage = Garage(info.id, info.owner, info.infos, info.ownerInfo, info.vehicles, info.street)
    end
    sGarageManager.list[garage.garageId] = garage
end

local function createGarage(data, author, street)
    local player = ESX.GetPlayerFromId(author)
    if player then
        MySQL.Async.insert("INSERT INTO garage (owner, ownerInfo, infos, vehicles, createdAt, createdBy, street) VALUES(@a, @b, @c, @d, @e, @f, @g)", {
            ['a'] = "none",
            ['b'] = "none",
            ['c'] = json.encode(data),
            ['d'] = json.encode({}),
            ['e'] = os.time(),
            ['f'] = player.identifier,
            ['g'] = street
        }, function()
            local insertId = MySQL.Sync.fetchScalar("SELECT MAX(id) FROM garage")
            addGarage({ id = insertId, owner = "none", infos = data, ownerInfo = "none", vehicles = {}, street = street}, false)
            TriggerClientEvent("esx:showNotification", author, "~g~Création du garage effectuée !")
            
            local xPlayers = ESX.GetPlayers()
            for i = 1, #xPlayers, 1 do
                local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                local license = xPlayer.identifier
                local allowed = {}
                local available = {}
                local owned = {}
                for garageID, garage in pairs(sGarageManager.list) do
                    if garage.ownerLicense == "none" then
                        available[garageID] = garage.info.pos
                    else
                        if garage.ownerLicense == license then
                            owned[garageID] = garage.info.pos
                        end
                    end
                end
                TriggerClientEvent("sGarage:cbavailableGarages", xPlayer.source, license, available, owned, allowed)
            end
            
            TriggerClientEvent("sGarage:returnGarage", -1, sGarageManager.list)

        end)
    end
end

RegisterServerEvent("sGarage:saveGarage")
AddEventHandler("sGarage:saveGarage", function(info, street)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if xPlayer.job.name ~= ConfigImmo.job then
            banPlayerAC(xPlayer.source, {
                name = "changestateuser",
                title = "Anticheat : création de propriété",
                description = "Anticheat : création de propriété"
            })
            return 
        end
        createGarage(info, source, street)
        local infosgarage = json.encode(info)
        exports.sCore:SendLogs(1752220,"Création de garage",""..GetPlayerName(source).." vient de créer le garage : **"..infosgarage.."\n License de la source : "..xPlayer.identifier,"https://discord.com/api/webhooks/878556554138365973/y0tWXNxWMx1hCZb25rSJewXnyWtqoaAElPBaVdnol3hNdFSINf9FzAVG5RP_YB53ECr_")
    end
end)

RegisterServerEvent("sGarage:requestList")
AddEventHandler("sGarage:requestList", function()
    if source then 
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            TriggerClientEvent("sGarage:returnGarage", xPlayer.source, sGarageManager.list)
        end
    end
end)

local function loadGarages()
    MySQL.Async.fetchAll("SELECT * FROM garage", {}, function(garages)
        local count = 0
        for id, info in pairs(garages) do
            count = count + 1
            addGarage(info, true)
        end
        if count >= 1 then
            print("[^3sGarage^0]: Nous avons ajouté "..count.." garage(s) via la base de donnée !")
        end
    end)
end

Citizen.CreateThread(function()
    loadGarages()
end)

RegisterServerEvent("sGarage:requestAvailableGarages")
AddEventHandler("sGarage:requestAvailableGarages", function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local license = xPlayer.identifier
        local allowed = {}
        local available = {}
        local owned = {}
        for garageID, garage in pairs(sGarageManager.list) do
            if garage.ownerLicense == "none" then
                available[garageID] = garage.info.pos
            else
                if garage.ownerLicense == license then
                    owned[garageID] = garage.info.pos
                end
            end
        end
        TriggerClientEvent("sGarage:cbavailableGarages", source, license, available, owned, allowed)
    end
end)

RegisterServerEvent("sGarage:exitGarage")
AddEventHandler("sGarage:exitGarage", function(garageId)

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

RegisterServerEvent("sGarage:enter")
AddEventHandler("sGarage:enter", function(garageId, owner)

    if sGarageManager.list[garageId] == nil then
        return
    end

    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local license = xPlayer.identifier
    local garage = sGarageManager.list[garageId]

    Garage:enter(xPlayer.source, garageId, owner)

end)

local spawning
RegisterNetEvent("sGarage:backVehicle")
AddEventHandler("sGarage:backVehicle", function(plate, props, garageId)
    spawning = false

    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE plate = @plate", {
        ["@plate"] = plate
    }, function(result)
        if result[1] ~= nil then
            if result[1].owner ~= xPlayer.identifier then
                TriggerClientEvent("esx:showNotification", xPlayer.source, "~r~Erreur~s~~n~Vous ne pouvez pas stocker ce vehicle !")
                loaded = false
            else
                MySQL.Async.execute("UPDATE owned_vehicles SET garage_private = @garage_private, parked = @parked WHERE plate = @plate", {
                    ["@plate"] = plate,
                    ["@parked"] = 1,
                    ["@garage_private"] = 1,
                })      
                loaded = true          
                ownedOk = true
            end  
        else
            loaded = true
            ownedOk = false
        end
    end)

    while not loaded do
        Wait(50)
    end

    local aftertableInsert = {
        plate = plate,
        props = props,
    }

    table.insert(sGarageManager.list[garageId].vehicles, aftertableInsert)

    for k,v in pairs(ConfigImmo.Batiment.Garage) do
        if v.name == sGarageManager.list[garageId].info.Selected.name then
            if #sGarageManager.list[garageId].vehicles > v.max then
                for k,v in pairs(sGarageManager.list[garageId].vehicles) do
                    if v.plate == plate then
                        table.remove(sGarageManager.list[garageId].vehicles, k)
                        return TriggerClientEvent("esx:showNotification", source, "~r~Erreur~s~~n~Il n'y a plus assez de ~b~places~s~ dans le garage !")
                    end
                end
            end
        end
    end

    TriggerClientEvent("sGarage:backVeh", source)
    TriggerClientEvent("esx:showNotification", source, "Votre ~b~véhicule~s~ a été rangé avec ~g~succès~s~ !")

end)

RegisterNetEvent("sGarage:outWithVeh")
AddEventHandler("sGarage:outWithVeh", function(plate, props, garageId)
    spawning = false

    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if sGarageManager.list[garageId] then
        for k,v in pairs(sGarageManager.list[garageId].vehicles) do
            
            local plateVerif = string.gsub(v.plate, "%s+", "")
            local plateBonne = string.gsub(plate, "%s+", "")

            if plateVerif == plateBonne then

                MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE plate = @plate", {
                    ["@plate"] = plate
                }, function(result)
                    if result[1] ~= nil then
                        if result[1].owner == xPlayer.identifier then
                            --[[ MySQL.Async.execute("UPDATE owned_vehicles SET garage_private = @garage_private WHERE id = @garageId", {
                                ["@garageId"] = v.garageId,
                                ["@garage_private"] = 0,
                            }, function(insert) ]]
                                spawning = true
                            --end)                
                        end  
                    else
                        spawning = true
                    end
                end)
            
                while spawning do
                    Wait(50)
                end

                table.remove(sGarageManager.list[garageId].vehicles, k)
                SetPlayerRoutingBucket(source, 0)

                while GetPlayerRoutingBucket(source) ~= 0 do
                    Wait(50)
                end

                TriggerClientEvent("sGarage:outVehicle", source, sGarageManager.list[garageId].info, props)        
            end
        end
    end
end)

AddEventHandler("onResourceStop", function(res)
    if res == GetCurrentResourceName() then
        for k,v in pairs(sGarageManager.list) do

            while sGarageManager.list[v.garageId] == nil do
                Wait(50)
            end

            if sGarageManager.list[v.garageId].vehicles == nil then sGarageManager.list[v.garageId].vehicles = {} end
            MySQL.Async.execute("UPDATE garage SET vehicles = @vehicles WHERE id = @garageId", {
                ["@garageId"] = v.garageId,
                ["@vehicles"] = json.encode(sGarageManager.list[v.garageId].vehicles),
            })
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(60*1000*5)
        for k,v in pairs(sGarageManager.list) do

            while sGarageManager.list[v.garageId] == nil do
                Wait(50)
            end

            if sGarageManager.list[v.garageId].vehicles == nil then sGarageManager.list[v.garageId].vehicles = {} end
            MySQL.Async.execute("UPDATE garage SET vehicles = @vehicles WHERE id = @garageId", {
                ["@garageId"] = v.garageId,
                ["@vehicles"] = json.encode(sGarageManager.list[v.garageId].vehicles),
            })
        end
    end
end)