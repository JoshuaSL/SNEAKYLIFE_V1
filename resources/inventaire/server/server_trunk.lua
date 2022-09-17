ESX = nil
local arrayWeight = {

    armor = 5,
    assiete_de_sushis = 1,
    bandage = 0.5,
    bed = 20,
    beer = 1,
    beer_2 = 1,
    bmx = 10,
    bol_de_nouilles = 1,
    bread = 0.5,
    burger = 0.8,
    canne_peche = 2,
    carpecuir = 8,
    casserole = 3,
    chips = 1,
    chocolate = 1,
    clip = 1,
    coca = 0.5,
    coca_acide = 1,
    coca_feuille = 1,
    coke = 1,
    coke_coupe = 1,
    coke_pooch = 1,
    cola = 0.5,
    cruiser = 10,
    cutter = 2,
    diable = 10,
    donut = 1,
    fish = 1,
    fishd = 1,
    fishandchips = 1,
    fixkit = 5,
    fixter = 10,
    fixtool = 4,
    frites = 0.5,
    frites_chauffe = 0.5,
    golf = 1,
    golf_green = 1,
    golf_pink = 1,
    golf_yellow = 1,
    hotdog = 1,
    id_card_f = 2,
    jumelles = 0.5,
    jus_leechi = 1,
    jus_orange = 1,
    kit_de_crochetage = 5,
    limonade = 0.5,
    lockpick = 0.4,
    maki = 0.5, 
    medikit = 2,
    meth = 1,
    meth_coupe = 1,
    meth_lode = 1,
    meth_phosphore = 1,
    meth_pooch = 1,
    mor_fish = 0.5,
    morbig_fish = 1,
    morviande_1 = 1,
    morviande_2 = 1,
    moteur = 7,
    oeuvreart = 8,
    oeuvreart_luxe = 8,
    opium = 1,
    opium_pooch = 1,
    ors = 2,
    oxygen_mask = 0.6,
    pate = 0.5,
    peinture = 10,
    peinture_luxe = 10,
    pelle = 5,
    perfusion = 1,
    phone= 0.5,
    pizza = 0.5,
    pneu = 7,
    pompom = 1,
    radio = 1,
    redbull = 0.3,
    redfish = 1,
    repairkit = 5,
    rouleau_de_printemps = 1,
    salade = 0.5,
    salade_fraiche = 0.5,
    sandwich = 1,
    secure_card = 2,
    soda = 1,
    soupe_de_nouille = 1,
    spaghetti_bolognaise = 1,
    steak_cuit = 0.5,
    tequila = 0.7,
    terre = 3,
    the_vert = 0.5,
    tomate = 0.5,
    tomate_coupe = 0,5,
    tribike = 10,
    tribike2 = 10,
    tribike3 = 10,
    ventouse = 3,
    viande_1 = 2,
    viande_2 = 2,
    vodka = 1,
    water = 0.7,
    weed = 1,
    weed_fertiligene = 1,
    weed_graine = 1,
    weed_pooch = 2,
    wheelchair = 10,
    whisky = 0.7,
    whitefish = 3,

    -- armes

    -- argent
    dirtycash = 0.0,

}

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

MySQL.ready(function()
    MySQL.Async.execute("DELETE FROM `truck_inventory2` WHERE `owned` = 0", {})
end)

ESX.RegisterServerCallback('esx_vehicleshop:isPlateTaken', function (source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function (result)
		cb(result[1] ~= nil)
	end)
end)


function getItemWeight(item)
    local weight = 0
    local itemWeight = 0
    if item ~= nil then
        itemWeight = 1
        if arrayWeight[item] ~= nil then
            itemWeight = arrayWeight[item]
        end
    end
    return itemWeight
end

function getInventoryWeight(inventory)
    local weight = 0
    local itemWeight = 0
    if inventory ~= nil then
        for i = 1, #inventory, 1 do
            if inventory[i] ~= nil then
                itemWeight = 1
                if arrayWeight[inventory[i].name] ~= nil then
                    itemWeight = arrayWeight[inventory[i].name]
                end
                weight = weight + (itemWeight * (inventory[i].count or 1))
            end
        end
    end
    return weight
end

function getTotalInventoryWeight(plate)
    local total
    TriggerEvent("esx_inventoryhud_trunk:getSharedDataStore",plate,function(store)
        local W_weapons = getInventoryWeight(store.get("weapons") or {})
        local W_coffre = getInventoryWeight(store.get("coffre") or {})
        local W_blackMoney = 0
        local blackAccount = (store.get("dirtycash")) or 0
        if blackAccount ~= 0 then
            W_blackMoney = blackAccount[1].amount / 10
        end
        total = W_weapons + W_coffre + 0
    end)
    return total
end

ESX.RegisterServerCallback("esx_inventoryhud_trunk:getInventoryV",function(source, cb, plate)
    TriggerEvent("esx_inventoryhud_trunk:getSharedDataStore",plate,function(store)
    local blackMoney = 0
    local items = {}
    local weapons = {}
    weapons = (store.get("weapons") or {})

    local blackAccount = (store.get("dirtycash")) or 0
    if blackAccount ~= 0 then
        blackMoney = blackAccount[1].amount
    end

    local coffre = (store.get("coffre") or {})
    for i = 1, #coffre, 1 do
        table.insert(items, {name = coffre[i].name, count = coffre[i].count, label = ESX.GetItemLabel(coffre[i].name)})
    end

    local weight = getTotalInventoryWeight(plate)
    cb({blackMoney = blackMoney,items = items,weapons = weapons,weight = weight})
    end)
end)

RegisterServerEvent("esx_inventoryhud_trunk:getItem")
AddEventHandler("esx_inventoryhud_trunk:getItem",function(plate, type, item, count, max, owned)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if type == "item_standard" then
        local targetItem = xPlayer.getInventoryItem(item)
        TriggerEvent("esx_inventoryhud_trunk:getSharedDataStore",plate,function(store)
            local coffre = (store.get("coffre") or {})
            for i = 1, #coffre, 1 do
                if coffre[i].name == item then
                    if (coffre[i].count >= count and count > 0) then
                        if (xPlayer.getWeight()+(getItemWeight(item)*count)) > ESX.GetConfig().MaxWeight then 
                            return 
                            TriggerClientEvent("esx:showNotification", _source, "~r~Vous n'avez pas assez de place sur vous !") 
                        end
                        if coffre[i].canMove == nil or coffre[i].canMove then
                            xPlayer.addInventoryItem(item, count)
                            exports.sCore:SendLogs(1752220,"Coffre véhicule",""..GetPlayerName(_source).." vient de retirer "..count.." de **"..item.."** dans le coffre "..plate.." \n License : "..xPlayer.identifier,"https://discord.com/api/webhooks/878560083628404758/pQWwnystcns-vgHQ1wwbRbpQomwQdCY4Zb1ZdkmoYkZRSNTceJ0mUSUc2s17vwjBv3Eu")
                            if (coffre[i].count - count) == 0 then
                                table.remove(coffre, i)
                            else
                                coffre[i].count = coffre[i].count - count
                            end
                        end
                        break
                    else
                        TriggerClientEvent("esx:showNotification", source, "~r~Quantité invalide.")
                    end
                end
            end

            store.set("coffre", coffre)

            local blackMoney = 0
            local items = {}
            local weapons = {}
            weapons = (store.get("weapons") or {})

            local blackAccount = (store.get("dirtycash")) or 0
            if blackAccount ~= 0 then
                blackMoney = blackAccount[1].amount
            end

            local coffre = (store.get("coffre") or {})
            for i = 1, #coffre, 1 do
                table.insert(
                    items,
                    {
                        name = coffre[i].name,
                        count = coffre[i].count,
                        label = ESX.GetItemLabel(coffre[i].name)
                    }
                )
            end

            local weight = getTotalInventoryWeight(plate)

            text = "<h3>Coffre</h3><br><strong>Plaque :</strong> "..plate.."<br><strong>Capacité :</strong> "..(weight).." / "..(max)
            data = {plate = plate, max = max, myVeh = owned, text = text}
            TriggerClientEvent("esx_inventoryhud:refreshTrunkInventory", _source, data, blackMoney, items, weapons)
        end)
    elseif type == "item_account" then
        TriggerEvent("esx_inventoryhud_trunk:getSharedDataStore",plate,function(store)
            local blackMoney = store.get("dirtycash")
            if (blackMoney[1].amount >= count and count > 0) then
                blackMoney[1].amount = blackMoney[1].amount - count
                store.set("dirtycash", blackMoney)
                xPlayer.addAccountMoney(item, count)
                exports.sCore:SendLogs(1752220,"Coffre véhicule",""..GetPlayerName(_source).." vient de retirer "..count.." de **"..item.."** dans le coffre "..plate.." \n License : "..xPlayer.identifier,"https://discord.com/api/webhooks/878560083628404758/pQWwnystcns-vgHQ1wwbRbpQomwQdCY4Zb1ZdkmoYkZRSNTceJ0mUSUc2s17vwjBv3Eu")
                local blackMoney = 0
                local items = {}
                local weapons = {}
                weapons = (store.get("weapons") or {})

                local blackAccount = (store.get("dirtycash")) or 0
                if blackAccount ~= 0 then
                    blackMoney = blackAccount[1].amount
                end

                local coffre = (store.get("coffre") or {})
                for i = 1, #coffre, 1 do
                    table.insert(
                        items,
                        {
                            name = coffre[i].name,
                            count = coffre[i].count,
                            label = ESX.GetItemLabel(coffre[i].name)
                        }
                    )
                end

                local weight = getTotalInventoryWeight(plate)

                text = "<h3>Coffre</h3><br><strong>Plaque :</strong> "..plate.."<br><strong>Capacité :</strong> "..(weight).." / "..(max)
                data = {plate = plate, max = max, myVeh = owned, text = text}
                TriggerClientEvent("esx_inventoryhud:refreshTrunkInventory", _source, data, blackMoney, items, weapons)
            else
                TriggerClientEvent("esx:showNotification", source, "~r~Quantité invalide.")
            end
        end)
    elseif type == "item_weapon" then
        if xPlayer.hasWeapon(item) then
            TriggerClientEvent("esx:showNotification", source, "~r~Vous avez déjà cette arme avec vous.")
        else
            TriggerEvent("esx_inventoryhud_trunk:getSharedDataStore",plate,function(store)
                local storeWeapons = store.get("weapons")

                if storeWeapons == nil then
                    storeWeapons = {}
                end

                local weaponName = nil
                local ammo = nil
                local components = {}

                for i = 1, #storeWeapons, 1 do
                    if storeWeapons[i].name == item then
                        weaponName = storeWeapons[i].name
                        ammo = storeWeapons[i].ammo

                        if storeWeapons[i].components ~= nil then
                            components = storeWeapons[i].components
                        end

                        table.remove(storeWeapons, i)

                        break
                    end
                end

                store.set("weapons", storeWeapons)

                xPlayer.addWeapon(weaponName, ammo)
                exports.sCore:SendLogs(1752220,"Coffre véhicule",""..GetPlayerName(_source).." vient de retirer **"..weaponName.."** dans le coffre "..plate.." \n License : "..xPlayer.identifier,"https://discord.com/api/webhooks/878560083628404758/pQWwnystcns-vgHQ1wwbRbpQomwQdCY4Zb1ZdkmoYkZRSNTceJ0mUSUc2s17vwjBv3Eu")
                for i = 1, #components do
                    xPlayer.addWeaponComponent(weaponName, components[i])
                end

                local blackMoney = 0
                local items = {}
                local weapons = {}
                weapons = (store.get("weapons") or {})

                local blackAccount = (store.get("dirtycash")) or 0
                if blackAccount ~= 0 then
                    blackMoney = blackAccount[1].amount
                end

                local coffre = (store.get("coffre") or {})
                for i = 1, #coffre, 1 do
                    table.insert(
                        items,
                        {
                            name = coffre[i].name,
                            count = coffre[i].count,
                            label = ESX.GetItemLabel(coffre[i].name)
                        }
                    )
                end

                local weight = getTotalInventoryWeight(plate)

                text = "<h3>Coffre</h3><br><strong>Plaque :</strong> "..plate.."<br><strong>Capacité :</strong> "..(weight).." / "..(max)
                data = {plate = plate, max = max, myVeh = owned, text = text}
                TriggerClientEvent("esx_inventoryhud:refreshTrunkInventory", _source, data, blackMoney, items, weapons)
            end)
        end
    end
end)

RegisterServerEvent("esx_inventoryhud_trunk:putItem")
AddEventHandler("esx_inventoryhud_trunk:putItem",function(plate, type, item, count, max, owned, label)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    print(type,item,count,max,owned,label)
    if type == "item_standard" then
        local playerItemCount = xPlayer.getInventoryItem(item).count

        if (playerItemCount >= count and count > 0) then
            TriggerEvent("esx_inventoryhud_trunk:getSharedDataStore",plate,function(store)
                local found = false
                local coffre = (store.get("coffre") or {})

                for i = 1, #coffre, 1 do
                    if coffre[i].name == item then
                        coffre[i].count = coffre[i].count + count
                        found = true
                    end
                end
                if not found then
                    table.insert(
                        coffre,
                        {
                            name = item,
                            count = count
                        }
                    )
                end
                if (getTotalInventoryWeight(plate) + (getItemWeight(item) * count)) > max then
                    TriggerClientEvent("esx:showNotification", source, "~r~Espace insuffisant.")
                else
                    store.set("coffre", coffre)
                    xPlayer.removeInventoryItem(item, count)
                    exports.sCore:SendLogs(1752220,"Coffre véhicule",""..GetPlayerName(_source).." vient de déposer "..count.." de **"..item.."** dans le coffre "..plate.." \n License : "..xPlayer.identifier,"https://discord.com/api/webhooks/878560083628404758/pQWwnystcns-vgHQ1wwbRbpQomwQdCY4Zb1ZdkmoYkZRSNTceJ0mUSUc2s17vwjBv3Eu")
                    MySQL.Async.execute(
                        "UPDATE truck_inventory2 SET owned = @owned WHERE plate = @plate",
                        {
                            ["@plate"] = plate,
                            ["@owned"] = owned
                        }
                    )
                end
            end)
        else
            TriggerClientEvent("esx:showNotification", source, "~r~Quantité invalide.")
        end
    end

    if type == "item_account" then
        local playerAccountMoney = xPlayer.getAccount(item).money
        if (playerAccountMoney >= count and count > 0) then
            TriggerEvent("esx_inventoryhud_trunk:getSharedDataStore",plate,function(store)
                local blackMoney = (store.get("dirtycash") or nil)
                if blackMoney ~= nil then
                    blackMoney[1].amount = blackMoney[1].amount + count
                else
                    blackMoney = {}
                    table.insert(blackMoney, {amount = count})
                end

               
               
                    xPlayer.removeAccountMoney(item, count)
                    store.set("dirtycash", blackMoney)
                    exports.sCore:SendLogs(1752220,"Coffre véhicule",""..GetPlayerName(_source).." vient de déposer "..count.." de **"..item.."** dans le coffre "..plate.." \n License : "..xPlayer.identifier,"https://discord.com/api/webhooks/878560083628404758/pQWwnystcns-vgHQ1wwbRbpQomwQdCY4Zb1ZdkmoYkZRSNTceJ0mUSUc2s17vwjBv3Eu")
                    MySQL.Async.execute(
                        "UPDATE truck_inventory2 SET owned = @owned WHERE plate = @plate",
                        {
                            ["@plate"] = plate,
                            ["@owned"] = owned
                        }
                    )
             
            end)
        else
            TriggerClientEvent("esx:showNotification", source, "~r~Quantité invalide.")
        end
    end

    if type == "item_weapon" then
        TriggerEvent("esx_inventoryhud_trunk:getSharedDataStore",plate,function(store)
            local storeWeapons = store.get("weapons")

            if storeWeapons == nil then
                storeWeapons = {}
            end

            local pos, playerWeapon = xPlayer.getWeapon(item)

            local components = playerWeapon.components
            if components == nil then
                components = {}
            end

            table.insert(
                storeWeapons,
                {
                    name = item,
                    label = label,
                    ammo = count,
                    components = components
                }
            )

            if (getTotalInventoryWeight(plate) + (getItemWeight(item))) > max then
                TriggerClientEvent("esx:showNotification", source, "~r~Quantité invalide.")
            else
                if xPlayer.hasWeapon(item) then
                    store.set("weapons", storeWeapons)
                    xPlayer.removeWeapon(item)
                    exports.sCore:SendLogs(1752220,"Coffre véhicule",""..GetPlayerName(_source).." vient de déposer **"..ESX.GetWeaponLabel(item).."** dans le coffre "..plate.." \n License : "..xPlayer.identifier,"https://discord.com/api/webhooks/878560083628404758/pQWwnystcns-vgHQ1wwbRbpQomwQdCY4Zb1ZdkmoYkZRSNTceJ0mUSUc2s17vwjBv3Eu")
                    MySQL.Async.execute(
                        "UPDATE truck_inventory2 SET owned = @owned WHERE plate = @plate",
                        {
                            ["@plate"] = plate,
                            ["@owned"] = owned
                        }
                    )
                end
            end
        end)
    end

    TriggerEvent("esx_inventoryhud_trunk:getSharedDataStore",plate,function(store)
        local blackMoney = 0
        local items = {}
        local weapons = {}
        weapons = (store.get("weapons") or {})

        local blackAccount = (store.get("dirtycash")) or 0
        if blackAccount ~= 0 then
            blackMoney = blackAccount[1].amount
        end

        local coffre = (store.get("coffre") or {})
        for i = 1, #coffre, 1 do
            table.insert(items, {name = coffre[i].name, count = coffre[i].count, label = ESX.GetItemLabel(coffre[i].name)})
        end

        local weight = getTotalInventoryWeight(plate)

        text = "<h3>Coffre</h3><br><strong>Plaque :</strong> "..plate.."<br><strong>Capacité :</strong> "..(weight).." / "..(max)
        data = {plate = plate, max = max, myVeh = owned, text = text}
        TriggerClientEvent("esx_inventoryhud:refreshTrunkInventory", _source, data, blackMoney, items, weapons)
    end)
end)

ESX.RegisterServerCallback("esx_inventoryhud_trunk:getPlayerInventory",function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local blackMoney = xPlayer.getAccount("dirtycash").money
    local items = xPlayer.inventory
    cb({blackMoney = blackMoney,items = items})
end)