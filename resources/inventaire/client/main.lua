isInInventory = false
local open = false
ESX = nil
currentMenu = 'item'
local sneakylife = nil
IncludeWeapons = true
IncludeCash = true
local BlockInventory = false
CloseUiItems = {
    "radio"
}
local fastWeapons = {
	[1] = nil,
	[2] = nil,
	[3] = nil
}

function AddLongString(txt)
	local maxLen = 100
	for i = 0, string.len(txt), maxLen do
		local sub = string.sub(txt, i, math.min(i + maxLen, string.len(txt)))
		AddTextComponentString(sub)
	end
end

function ShowAboveRadarMessage(message, back)
	if back then ThefeedNextPostBackgroundColor(back) end
	SetNotificationTextEntry("jamyfafi")
	AddLongString(message)
	return DrawNotification(0, 1)
end

Citizen.CreateThread(function() 
    while ESX == nil do 
        TriggerEvent("Sneakyesx:getSharedObject", function(obj) ESX = obj end) 
        Citizen.Wait(0) 
    end 
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterCommand('invbug', function()
    SetNuiFocus(true, true)
end, false)

function openInventory()
    loadPlayerInventory(currentMenu)
    isInInventory = true
    open = true
    SendNUIMessage({action = "display", type = "normal"})
    SetNuiFocus(true, true)
    SetKeepInputMode(true)
end

function closeInventory()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local vehicle = nil

    if IsPedInAnyVehicle(playerPed, false) then
        vehicle = GetVehiclePedIsIn(playerPed, false)
    else
        vehicle = getVehicleInDirection(3.0)

        if not DoesEntityExist(vehicle) then
            vehicle = GetClosestVehicle(coords, 3.0, 0, 70)
        end
    end
    SetVehicleDoorShut(vehicle, 5, false)
    isInInventory = false
    open = false
    SendNUIMessage({action = "hide"})
    if not BlockInventory then
        DisplayRadar(true)
        TriggerEvent("SneakyLife:HideHungerAndThirst",true)
    end
    SetNuiFocus(false, false)
    SetKeepInputMode(false)
end

RegisterNUICallback('escape', function(data, cb)
    closeInventory()
    SetKeepInputMode(false)
end)

RegisterNUICallback("NUIFocusOff",function()
    closeInventory()
    SetKeepInputMode(false)
end)

RegisterNUICallback("GetNearPlayers", function(data, cb)
    local playerPed = PlayerPedId()
    local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
    local foundPlayers = false
    local elements = {}



    local closestPly = GetNearbyPlayer(false, true)
    if closestPly ~= nil then
        foundPlayers = true 
    end 


    if not foundPlayers then
        ESX.ShowNotification('~r~Personne à proximité.')
    else
   
        SendNUIMessage({action = "nearPlayers", foundAny = foundPlayers, players = GetPlayerServerId(closestPly), item = data.item})
    end

    cb("ok")
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLength)
	AddTextEntry("FMMC_KEY_TIP1", TextEntry)
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

RegisterNUICallback("dsqds", function(data, cb)
    if currentMenu ~= data.type then 
        currentMenu = data.type
        loadPlayerInventory(data.type)
    end
end)

RegisterNUICallback("RenameItem", function(data, cb)
    if data.item.type ~= "item_weapon" then 
        closeInventory()
        local result = KeyboardInput('', data.item.label, 30)
        if result ~= nil then 
            if data.item.type ~= "item_standard" and data.item.type ~= "item_weapon" then 
                TriggerServerEvent('SneakyLife:ChangeName', data.item.id, result)
            elseif data.item.type == "item_standard" then 
                TriggerServerEvent('SneakyLife:ChangeName', data.item.name, result)
            end
            ESX.ShowNotification('Vous avez changer le nom ~c~'..data.item.label..'~s~ en ~b~'..result..'~s~')
        end 
    else
        closeInventory()
        local result = KeyboardInput('', data.item.label, 30)
        if result ~= nil then 
            for k, v in pairs(ESX.GetPlayerData().loadout) do 
                if data.item.name == v.name then
                end 
            end 
        end 
    end
end)

RegisterNUICallback("InformationItem", function(data, cb)
    ESX.ShowNotification('~b~Type : ~s~'..data.item.type..'\n~b~Nombre : ~s~'..data.item.count..'\n~b~Nom : ~s~'..data.item.label..'')
end)


local notifItem = false

RegisterNUICallback("UseItem", function(data, cb)
  
    if data.item.type == "item_standard" then 
        TriggerServerEvent("Sneakyesx:useItem", data.item.name)
    elseif data.item.type == "item_tenue" then 
        TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
            if tenue then 
                TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                    if skin.sex == 0 then
                        TriggerEvent('Sneakyskinchanger:loadSkin', {
                            sex      = 0,
                            tshirt_1 = 15,
                            tshirt_2 = 0,
                            arms     = 15,
                            torso_1  = 15,
                            torso_2  = 0,
                            pants_1  = 14,
                            pants_2  = 0,
                            shoes_1 = 43,
                            shoes_2 = 0,
                            chain_1 = 0,
                            chain_2 = 0,
                            bproof_1 = 0,
                            bproof_2 = 0,
                            watches_1 = 0,
                            watches_2 = 0,
                        })
                    else
                        TriggerEvent('Sneakyskinchanger:loadSkin', {
                            sex      = 1,
                            tshirt_1 = 14,
                            tshirt_2 = 0,
                            arms     = 15,
                            torso_1  = 15,
                            torso_2  = 0,
                            pants_1  = 15,
                            pants_2  = 0,
                            shoes_1 = 41,
                            shoes_2 = 0,
                            chain_1 = 0,
                            chain_2 = 0,
                            bproof_1 = 0,
                            bproof_2 = 0,
                            watches_1 = 0,
                            watches_2 = 0,
                        })
                    end
                end)
            else
                TriggerEvent('Sneakyskinchanger:loadClothes', skin, { 
                    ["pants_1"] = data.item.skins["pants_1"], 
                    ["pants_2"] = data.item.skins["pants_2"], 
                    ["tshirt_2"] = data.item.skins["tshirt_2"], 
                    ["tshirt_1"] = data.item.skins["tshirt_1"], 
                    ["torso_1"] = data.item.skins["torso_1"], 
                    ["torso_2"] = data.item.skins["torso_2"],
                    ["arms"] = data.item.skins["arms"],
                    ["arms_2"] = data.item.skins["arms_2"],
                    ["decals_1"] = data.item.skins["decals_1"],
                    ["decals_2"] = data.item.skins["decals_2"],
                    ["shoes_1"] = data.item.skins["shoes_1"],
                    ["shoes_2"] = data.item.skins["shoes_2"]})
            end
            tenue = not tenue
            save()
            end)
        elseif data.item.type == "item_chaussures" or data.item.type == "item_calque" or data.item.type == "item_montre" or data.item.type == "item_chaine" or data.item.type == "item_masque" or data.item.type == "item_pantalon" or data.item.type == "item_chapeau" or data.item.type == "item_sac" then 
            local info = data.item.skins
            local type  = info[data.item.info] 
            local var = info[data.item.info2] 
            TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                if used then 
                   
                    if data.item.decals ~= nil then 
                      
                        TriggerEvent('Sneakyskinchanger:loadClothes', skin, {[data.item.info] = data.item.decals, [data.item.info2] = 0})
                    else
                        TriggerEvent('Sneakyskinchanger:loadClothes', skin, {[data.item.info] = 0, [data.item.info2] = 0})
                    end
                else
                    if notifItem then 
                        RemoveNotification(notifItem) 
                    end
                    notifItem = ShowAboveRadarMessage("Vous venez d'equipé le ~b~"..data.item.label)
                    TriggerEvent('Sneakyskinchanger:loadClothes', skin, {[data.item.info] = type, [data.item.info2] = var})
                end  
                save()
                used = not used
            end)
    end 
    if shouldCloseInventory(data.item.name) then
        closeInventory()
    else
        Citizen.Wait(250)
        loadPlayerInventory(currentMenu)
    end
    cb("ok")
end)

RegisterNUICallback("DropItem", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end
    if currentMenu ~= 'clothe' then 
        if type(data.number) == "number" and math.floor(data.number) == data.number then
            if data.item.label == "Argent" then
                data.item.name = "cash"
            end
            if data.item.label == "Argent sale" then
                data.item.name = "dirtycash"
            end
            if data.item.type == "item_weapon" then
                SetCurrentPedWeapon(PlayerPedId(),"WEAPON_UNARMED", true)
                ResetWeaponSlots()
            end
            TriggerServerEvent('Sneakyesx:dropInventoryItem', data.item.type, data.item.name, data.number)
        end
    else
        TriggerServerEvent('Neo:deleteitem', data.item.id) 
    end

    Wait(250)
    loadPlayerInventory(currentMenu)

    cb("ok")
end)

RegisterNUICallback("GiveItem", function(data, cb)
    local playerPed = PlayerPedId()
    local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
    local foundPlayer = false
    for i = 1, #players, 1 do
        if players[i] ~= PlayerId() then
            if GetPlayerServerId(players[i]) == data.player then
                foundPlayer = true
            end
        end
    end
 
    if foundPlayer then
        
        local count = tonumber(data.number)

        if data.item.type == "item_weapon" then
            count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
            SetCurrentPedWeapon(PlayerPedId(),"WEAPON_UNARMED", true)
            ResetWeaponSlots()
        end

        if data.item.type == "item_tenue" or data.item.type == "item_chaussures" or data.item.type == "item_calque" or data.item.type == "item_montre" or data.item.type == "item_chaine" or data.item.type == "item_masque" or data.item.type == "item_pantalon" or data.item.type == "item_chapeau" or data.item.type == "item_sac" then
            TriggerServerEvent('SneakyLife:InventoryItem', data.item.id, data.player)
            Wait(250)
            loadPlayerInventory(currentMenu)
            ESX.ShowNotification('Vous venez de donner votre ~b~'..data.item.label)
        else
            if data.item.label == "Argent" then
                data.item.name = "cash"
            end
            if data.item.label == "Argent sale" then
                data.item.name = "dirtycash"
            end
            TriggerServerEvent("Sneakyesx:giveInventoryItem", data.player, data.item.type, data.item.name, count)
            Wait(250)
            loadPlayerInventory(currentMenu)
        end
    else
        ESX.ShowNotification('~r~Personne à proximité.')
    end
    cb("ok")
end)

function shouldCloseInventory(itemName)
    for index, value in ipairs(CloseUiItems) do
        if value == itemName then
            return true
        end
    end

    return false
end

function save()
	TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
		TriggerServerEvent('Sneakyesx_skin:save', skin)
	end)
end

RegisterNUICallback("weightHelp", function(data, cb)
    ESX.ShowNotification("Pour avoir plus ~b~d'espace~s~, vous pouvez toujours obtenir un ~b~diable")
end)

function GetCurrentWeight()
    
    TriggerEvent("Sneakyesx:getSharedObject", function(obj) ESX = obj end) 

    local currentWeight = 0
    for i = 1, #ESX.PlayerData.inventory, 1 do
        if ESX.PlayerData.inventory[i].count > 0 then
            currentWeight = currentWeight + (ESX.PlayerData.inventory[i].weight * ESX.PlayerData.inventory[i].count)
        end
    end
    return currentWeight
end



local tenue,chaussures,masque,pantalon,tshirt,lunettes,modifitems,chapeau,sac,chaine,calque,montre,torse = {},{},{},{},{},{},{},{},{},{},{},{},{}

function loadPlayerInventory(result)
  
    local weight = {currentWeight = GetCurrentWeight(), maxWeight = ESX.PlayerData.maxWeight..".0"}
 
    if result == 'item' then 
        ESX.TriggerServerCallback("esx_inventoryhud:getPlayerInventory", function(data)
            items = {}
            fastItems = {}
            inventory = data.inventory
            dirtycash = data.dirtycash
            money = data.money
            weapons = data.weapons

            if IncludeCash and money ~= nil and money > 0 then
                moneyData = {
                    label = "Argent",
                    name = "money",
                    type = "item_account",
                    count = money,
                    usable = false,
                    rename = false,
                    rare = false,
                    information = true, 
                    weight = -1,
                    canRemove = true
                }

                table.insert(items, moneyData)
            end
            
            if dirtycash ~= nil and dirtycash > 0 then
                dirtycashData = {
                    label = "Argent sale",
                    name = "dirtycash",
                    type = "item_account",
                    count = dirtycash,
                    usable = false,
                    rename = false,
                    rare = false,
                    information = true, 
                    weight = -1,
                    canRemove = true
                }

                table.insert(items, dirtycashData)
            end

            if inventory ~= nil then
                for key, value in pairs(inventory) do
            if inventory[key].count <= 0 then
                        inventory[key] = nil
                    
                    else
                        for k, v in pairs(modifitems) do
                            if v.item == inventory[key].name then 
                                if v.name ~= nil then 
                                    inventory[key].label = v.name
                                end
                            end 
                        end
                        inventory[key].type = "item_standard"
                        information = true
                        
                        table.insert(items, inventory[key])
                    end
                end
            end

         
        SendNUIMessage({ action = "setItems", itemList = items, fastItems = fastItems, text = texts, crMenu = currentMenu, weight = weight})
        end, GetPlayerServerId(PlayerId()))
    elseif result == 'weapon' then 
        ESX.TriggerServerCallback("esx_inventoryhud:getPlayerInventory", function(data)
            items = {}
            fastItems = {}
            inventory = data.inventory
            accounts = data.accounts
            money = data.money
            weapons = data.weapons
            
            

            if inventory ~= nil then
            for key, value in pairs(inventory) do


                for slot, weapon in pairs(fastWeapons) do
                    if weapon == inventory[key].name then
                        table.insert(
                            fastItems,
                            {
                                label = inventory[key].label,
                                limit = -1,
                                count = inventory[key].count,
                                type = "item_standard",
                                name = inventory[key].name, 
                                usable = false, 
                                rare = false,
                                information = false, 
                                rename = false,
                                canRemove = true,
                                slot = slot
                            }
                        )
                        found = true
                        break
                    end
                end

                if inventory[key].count <= 0 then
                        inventory[key] = nil
                    
                    else
                        for k, v in pairs(modifitems) do
                        
                            if v.item == inventory[key].name then 
                           
                                if v.name ~= nil then 
                                    inventory[key].label = v.name
                                end
                            end 
                        end 
                        inventory[key].type = "item_standard"
                        information = true
                      
                        table.insert(items, inventory[key])
                    end
                end
            end
        SendNUIMessage({ action = "setItems", itemList = items, fastItems = fastItems, text = texts, crMenu = currentMenu, weight = weight})
        end, GetPlayerServerId(PlayerId()))
    elseif result == 'clothe' then 
        items = {}

        ESX.TriggerServerCallback('SneakyLife:GetOutfit', function(Vetement)
            tenue, chaussures, masque, pantalon, tshirt, lunettes, chapeau, sac,chaine,calque,montre, torse = {}, {}, {}, {}, {}, {}, {}, {}, {}, {},{},{}
            for k, v in pairs(Vetement) do  
                if v.type == "peelotenue" then 
                    table.insert(tenue, {name = v.nom, skins = json.decode(v.clothe), id = v.id})
                end
                if v.type == "peelochaussures" then 
                    table.insert(chaussures, {name = v.nom, skins = json.decode(v.clothe), id = v.id, data = "shoes_1", data2 = "shoes_2", decals = 34})
                end 
                if v.type == "peelotorse" then 
                    table.insert(torse, {name = v.nom, skins = json.decode(v.clothe), id = v.id, data = "torso_1", data2 = "torso_2", decals = 15})
                end 
                if v.type == "peelomasque" then 
                    table.insert(masque, {name = v.nom, skins = json.decode(v.clothe), id = v.id, data = "mask_1", data2 = "mask_2"})
                end 
                if v.type == "peelopantalon" then 
                    table.insert(pantalon, {name = v.nom, skins = json.decode(v.clothe), id = v.id, data = "pants_1", data2 = "pants_2", decals = 14})
                end 
                if v.type == "peelotshirt" then 
                    table.insert(tshirt, {name = v.nom, skins = json.decode(v.clothe), id = v.id, data = "tshirt_1", data2 = "tshirt_2"})
                end 
                if v.type == "peelogant" then 
                    table.insert(lunettes, {name = v.nom, skins = json.decode(v.clothe), id = v.id, data = "arms", data2 = "arms_2"})
                end 
                if v.type == "peelolunettes" then 
                    table.insert(lunettes, {name = v.nom, skins = json.decode(v.clothe), id = v.id, data = "glasses_1", data2 = "glasses_2"})
                end 
                if v.type == "peelochapeau" then 
                    table.insert(chapeau, {name = v.nom, skins = json.decode(v.clothe), id = v.id, data = "helmet_1", data2 = "helmet_2"})
                end 
                if v.type == "peelosac" then 
                    table.insert(sac, {name = v.nom, skins = json.decode(v.clothe), id = v.id, data = "bags_1", data2 = "bags_1"})
                end 
                if v.type == "peelochaine" then 
                    table.insert(chaine, {name = v.nom, skins = json.decode(v.clothe), id = v.id, data = "chain_1", data2 = "chain_2"})
                end 
                if v.type == "peeloCalques" then 
                    table.insert(calque, {name = v.nom, skins = json.decode(v.clothe), id = v.id, data = "decals_1", data2 = "decals_2"})
                end 
                if v.type == "peeloomontre" then 
                    table.insert(montre, {name = v.nom, skins = json.decode(v.clothe), id = v.id, data = "watches_1", data2 = "watches_2"})
                end 
            end 
    

        Wait(50)

            for k, v in pairs(tenue) do
                tenueData = {
                    label = v.name,
                    name = "tenue",
                    type = "item_tenue",
                    skins = v.skins,
                    count = "",
                    usable = true,
                    rename = true,
                    rare = false,
                    information = true, 
                    id = v.id, 
                    weight = -1,
                    canRemove = true
                }
                table.insert(items, tenueData)
            end

            for k, v in pairs(chaussures) do
                chaussuresData = {
                    label = v.name,
                    name = "shoes",
                    type = "item_chaussures",
                    skins = v.skins,
                    info = v.data,
                    info2 = v.data2,
                    count = "",
                    usable = true,
                    information = true, 
                    id = v.id, 
                    decals = v.decals,
                    rename = true,
                    rare = false,
                    weight = -1,
                    canRemove = true
                }
                table.insert(items, chaussuresData)
            end

            for k, v in pairs(masque) do
                masqueData = {
                    label = v.name,
                    name = "mask",
                    type = "item_chaussures",
                    skins = v.skins,
                    info = v.data,
                    info2 = v.data2,
                    id = v.id, 
                    count = "",
                    information = true, 
                    usable = true,
                    rename = true,
                    rare = false,
                    weight = -1,
                    canRemove = true
                }
                table.insert(items, masqueData)
            end

            for k, v in pairs(pantalon) do
                pantalonData = {
                    label = v.name,
                    name = "jean",
                    type = "item_chaussures",
                    skins = v.skins,
                    info = v.data,
                    info2 = v.data2,
                    decals = v.decals,
                    id = v.id, 
                    count = "",
                    information = true, 
                    usable = true,
                    rename = true,
                    rare = false,
                    weight = -1,
                    canRemove = true
                }
                table.insert(items, pantalonData)
            end

            for k, v in pairs(tshirt) do
                tshirtData = {
                    label = v.name,
                    name = "shirt",
                    type = "item_chaussures",
                    skins = v.skins,
                    info = v.data,
                    info2 = v.data2,
                    id = v.id, 
                    count = "",
                    information = true, 
                    usable = true,
                    rename = true,
                    rare = false,
                    weight = -1,
                    canRemove = true
                }
                table.insert(items, tshirtData)
            end

            for k, v in pairs(torse) do
                torseData = {
                    label = v.name,
                    name = "torse", 
                    type = "item_chaussures",
                    skins = v.skins,
                    info = v.data,
                    info2 = v.data2,
                    id = v.id,  
                    count = "",
                    information = true, 
                    usable = true,
                    rename = true, 
                    rare = false,
                    weight = -1,
                    canRemove = true
                }
                table.insert(items, torseData)
            end

            for k, v in pairs(lunettes) do
                lunettesData = {
                    label = v.name,
                    name = "tie",
                    type = "item_chaussures",
                    skins = v.skins,
                    info = v.data,
                    info2 = v.data2,
                    id = v.id, 
                    count = "",
                    usable = true,
                    information = true, 
                    rename = true,
                    rare = false,
                    weight = -1,
                    canRemove = true
                }
                table.insert(items, lunettesData)
            end

            for k, v in pairs(chapeau) do
                chapeauData = {
                    label = v.name,
                    name = "hat",
                    type = "item_chapeau",
                    skins = v.skins,
                    info = v.data,
                    info2 = v.data2,
                    id = v.id, 
                    decals = 11,
                    count = "",
                    usable = true,
                    information = true, 
                    rename = true,
                    rare = false,
                    weight = -1,
                    canRemove = true
                }
                table.insert(items, chapeauData)
            end
            
            for k, v in pairs(sac) do
                sacData = {
                    label = v.name,
                    name = "bag",
                    type = "item_sac",
                    skins = v.skins,
                    info = v.data,
                    info2 = v.data2,
                    id = v.id, 
                    count = "",
                    usable = true,
                    information = true, 
                    rename = true,
                    rare = false,
                    weight = -1,
                    canRemove = true
                }
                table.insert(items, sacData)
            end
    
                
            for k, v in pairs(chaine) do
                chaineData = {
                    label = v.name,
                    name = "tie",
                    type = "item_chaine",
                    skins = v.skins,
                    info = v.data,
                    info2 = v.data2,
                    id = v.id, 
                    count = "",
                    usable = true,
                    information = true, 
                    rename = true,
                    rare = false,
                    weight = -1,
                    canRemove = true
                }
                table.insert(items, chaineData)
            end
    
            for k, v in pairs(calque) do
                calqueData = {
                    label = v.name,
                    name = "tie",
                    type = "item_calque",
                    skins = v.skins,
                    info = v.data,
                    info2 = v.data2,
                    id = v.id, 
                    count = "",
                    usable = true,
                    information = true, 
                    rename = true,
                    rare = false,
                    weight = -1,
                    canRemove = true
                }
                table.insert(items, calqueData)
            end

            for k, v in pairs(montre) do
                montreData = {
                    label = v.name,
                    name = "tie",
                    type = "item_montre",
                    skins = v.skins,
                    info = v.data,
                    info2 = v.data2,
                    id = v.id, 
                    count = "",
                    usable = true,
                    information = true, 
                    rename = true,
                    rare = false,
                    weight = -1,
                    canRemove = true
                }
                table.insert(items, montreData)
            end
 
        SendNUIMessage({ action = "setItems", itemList = items, fastItems = fastItems, text = texts, crMenu = currentMenu, weight = weight})
        Wait(250)
    end)
    end
end

--FAST ITEMS
RegisterNUICallback("PutIntoFast", function(data, cb)
	if data.item.slot ~= nil then
		fastWeapons[data.item.slot] = nil
	end
	fastWeapons[data.slot] = data.item.name
	loadPlayerInventory(currentMenu)
	cb("ok")
end)

RegisterNUICallback("TakeFromFast", function(data, cb)
	fastWeapons[data.item.slot] = nil
	loadPlayerInventory(currentMenu)
	cb("ok")
end)


RegisterKeyMapping('ouvririnventaire', 'Ouverture inventaire', 'keyboard', 'TAB')
RegisterKeyMapping('keybind1', 'Slot d\'arme 1', 'keyboard', '1')
RegisterKeyMapping('keybind2', 'Slot d\'arme 2', 'keyboard', '2')
RegisterKeyMapping('keybind3', 'Slot d\'arme 3', 'keyboard', '3')

local AnimBlacklist = {"WORLD_HUMAN_MUSICIAN", "WORLD_HUMAN_CLIPBOARD"}
local AnimFemale = {
	["WORLD_HUMAN_BUM_WASH"] = {"amb@world_human_bum_wash@male@high@idle_a", "idle_a"},
	["WORLD_HUMAN_SIT_UPS"] = {"amb@world_human_sit_ups@male@idle_a", "idle_a"},
	["WORLD_HUMAN_PUSH_UPS"] = {"amb@world_human_push_ups@male@base", "base"},
	["WORLD_HUMAN_BUM_FREEWAY"] = {"amb@world_human_bum_freeway@male@base", "base"},
	["WORLD_HUMAN_CLIPBOARD"] = {"amb@world_human_clipboard@male@base", "base"},
	["WORLD_HUMAN_VEHICLE_MECHANIC"] = {"amb@world_human_vehicle_mechanic@male@base", "base"},
}

function TaskAnimForce(animName, flag, args) -- Faire forcer une anim a un ped (joueur)
	flag, args = flag and tonumber(flag) or false, args or {}
	local ped, time, clearTasks, animPos, animRot, animTime = args.ped or GetPlayerPed(-1), args.time, args.clearTasks, args.pos, args.ang

	if IsPedInAnyVehicle(ped) and (not flag or flag < 40) then return end

	if not clearTasks then ClearPedTasks(ped) end

	if not animName[2] and AnimFemale[animName[1]] and GetEntityModel(ped) == -1667301416 then
		animName = AnimFemale[animName[1]]
	end

	if animName[2] and not HasAnimDictLoaded(animName[1]) then
		if not DoesAnimDictExist(animName[1]) then return end
		RequestAnimDict(animName[1])
		while not HasAnimDictLoaded(animName[1]) do
			Citizen.Wait(10)
		end
	end

	if not animName[2] then
		ClearAreaOfObjects(GetEntityCoords(ped), 1.0)
		TaskStartScenarioInPlace(ped, animName[1], -1, not TableGetValue(AnimBlacklist, animName[1]))
	else
        if not animPos then
            TaskPlayAnim(ped, animName[1], animName[2], 8.0, -8.0, -1, flag or 44, 1, 0, 0, 0, 0)
		else
			TaskPlayAnimAdvanced(ped, animName[1], animName[2], animPos.x, animPos.y, animPos.z, animRot.x, animRot.y, animRot.z, 8.0, -8.0, -1, 1, 1, 0, 0, 0)
		end
	end

	if time and type(time) == "number" then
		Citizen.Wait(time)
		ClearPedTasks(ped)
	end

	if not args.dict then RemoveAnimDict(animName[1]) end
end

RegisterCommand('ouvririnventaire', function()
    if open then 
        openInventory()
        if not BlockInventory then
            DisplayRadar(false)
            TriggerEvent("SneakyLife:HideHungerAndThirst",false)
        end
    else
        closeInventory()
        if not BlockInventory then
            TriggerEvent("SneakyLife:HideHungerAndThirst",true)
            DisplayRadar(true)
        end
    end
    open = not open
end)
RegisterNetEvent("SneakyLife:RequestVariable")
AddEventHandler("SneakyLife:RequestVariable",function(bool)
    if bool then
        BlockInventory = true
    else
        BlockInventory = false
    end
end)

WeaponsHolster = {
    "WEAPON_STUNGUN",
    "WEAPON_COMBATPISTOL",
}

function CheckWeaponsHolster()
    pPed = PlayerPedId()
    for i = 1, #WeaponsHolster do 
        if GetHashKey(WeaponsHolster[i]) == GetSelectedPedWeapon(pPed) then
            return true
        else
            return false
        end
    end
end


local bool1 = false
function StartDisableControlForWeaponAnim(bool)
    Citizen.CreateThread(function()
        while bool do
            Wait(0)
            if bool1 then 
                local playerPed = GetPlayerPed(-1)
                PedSkipNextReloading(playerPed)
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 25, true)
                DisableControlAction(2, 237, true)
                DisableControlAction(2, 238, true)
                DisablePlayerFiring(playerPed, true)
            end
        end
    end)
end
function StartAnimsWeapons(weapons)
    local playerPed = GetPlayerPed(-1)
    SetPedCurrentWeaponVisible(playerPed, false)
    StartDisableControlForWeaponAnim(true)
    bool1 = true
    TaskAnimForce({"reaction@intimidation@1h", "intro"}, 49)

    local hash = GetHashKey(weapons)
    GiveWeaponToPed(playerPed, hash, 0, false, true)
    SetPedCurrentWeaponVisible(playerPed)
    Citizen.SetTimeout(1000, function()
        SetPedCurrentWeaponVisible(playerPed, true)
    end)
    Citizen.Wait(2700)
    StartDisableControlForWeaponAnim(false)
    bool1 = false
    SetPedCurrentWeaponVisible(playerPed, true)
    ClearPedTasks(playerPed)
end

function loadAnimDict(dict)
	while ( not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end
end

function StartsPoliceAnimsWeapons(weapons)
    loadAnimDict("rcmjosh4")
    loadAnimDict("reaction@intimidation@cop@unarmed")
    local playerPed = GetPlayerPed(-1)
    local hash = GetHashKey(weapons)
    GiveWeaponToPed(playerPed, hash, 0, false, true)
    StartDisableControlForWeaponAnim(true)
    SetPedCurrentWeaponVisible(playerPed, 0, 1, 1, 1)
    TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "intro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
    SetPedCurrentWeaponVisible(playerPed, 1, 1, 1, 1)
    TaskPlayAnim(playerPed, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
    Citizen.Wait(400)
    ClearPedTasks(playerPed)
end
local notifWeapon1 = false

RegisterCommand('keybind1', function()
    if not IsPedSittingInAnyVehicle(PlayerPedId()) then
        if fastWeapons[1] ~= nil then
            print(fastWeapons[1])
            if GetSelectedPedWeapon(GetPlayerPed(-1)) == GetHashKey(fastWeapons[1]) then
                SetCurrentPedWeapon(GetPlayerPed(-1), "WEAPON_UNARMED",true)
            else
                if fastWeapons[1] == "WEAPON_STUNGUN" or fastWeapons[1] == "WEAPON_COMBATPISTOL" then
                    StartsPoliceAnimsWeapons(fastWeapons[1])
                else
                    StartAnimsWeapons(fastWeapons[1],true)
                end
                if notifWeapon1 then 
                    RemoveNotification(notifWeapon1) 
                end
                notifWeapon1 = ShowAboveRadarMessage('Vous avez équipé votre ~g~'..ESX.GetWeaponLabel(fastWeapons[1])..'.')
            end
        end
    end
end)
local notifWeapon2 = false

RegisterCommand('keybind2', function()
    if not IsPedSittingInAnyVehicle(PlayerPedId()) then
        if fastWeapons[2] ~= nil then
            if GetSelectedPedWeapon(GetPlayerPed(-1)) == GetHashKey(fastWeapons[2]) then
                SetCurrentPedWeapon(GetPlayerPed(-1), "WEAPON_UNARMED",true)
            else
                if fastWeapons[2] == "WEAPON_STUNGUN" or fastWeapons[2] == "WEAPON_COMBATPISTOL" then
                    StartsPoliceAnimsWeapons(fastWeapons[2])
                else
                    StartAnimsWeapons(fastWeapons[2],true)
                end
                if notifWeapon2 then 
                    RemoveNotification(notifWeapon2) 
                end
                notifWeapon2 = ShowAboveRadarMessage('Vous avez équipé votre ~g~'..ESX.GetWeaponLabel(fastWeapons[2])..'.')
            end
        end
    end
end)

local notifWeapon3 = false

RegisterCommand('keybind3', function()
    if not IsPedSittingInAnyVehicle(PlayerPedId()) then
        if fastWeapons[3] ~= nil then
            if GetSelectedPedWeapon(GetPlayerPed(-1)) == GetHashKey(fastWeapons[3]) then
                SetCurrentPedWeapon(GetPlayerPed(-1), "WEAPON_UNARMED",true)
            else
                if fastWeapons[3] == "WEAPON_STUNGUN" or fastWeapons[3] == "WEAPON_COMBATPISTOL" then
                    StartsPoliceAnimsWeapons(fastWeapons[3])
                else
                    StartAnimsWeapons(fastWeapons[3],true)
                end
                if notifWeapon3 then 
                    RemoveNotification(notifWeapon3) 
                end
                notifWeapon3 = ShowAboveRadarMessage('Vous avez équipé votre ~g~'..ESX.GetWeaponLabel(fastWeapons[3])..'.')
            end
        end
    end
end)

function GetFastWeaponsChasse()
    if fastWeapons[1]~= "WEAPON_MUSKET" and fastWeapons[2] ~= "WEAPON_MUSKET" and fastWeapons[3] ~= "WEAPON_MUSKET" then
        return false
    else
        return true
    end
end

function ResetWeaponSlots()
    fastWeapons = {
        [1] = nil,
        [2] = nil,
        [3] = nil
    }
end


KEEP_FOCUS = false
local threadCreated = false
local controlDisabled = {1, 2, 3, 4, 5, 6, 18, 24, 25, 37, 44, 45, 52, 68, 69, 70, 80, 85, 91, 92, 106, 111, 114, 117, 118, 122, 135, 138, 140, 141, 142, 143, 144, 152, 176, 177, 182, 199, 200, 205, 222, 223, 225, 229, 237, 238, 250, 257, 263, 264, 310, 329, 330, 331, 346, 347}

function SetKeepInputMode(bool)
    if SetNuiFocusKeepInput then
        SetNuiFocusKeepInput(bool)
    end

    KEEP_FOCUS = bool

    if not threadCreated and bool then
        threadCreated = true

        Citizen.CreateThread(function()
            while KEEP_FOCUS do
                Wait(0)
                for _,v in pairs(controlDisabled) do
                    DisableControlAction(0, v, true)
                end
            end

            threadCreated = false
        end)
    end
end

function GetStateInventory()
    return isInInventory
end


function AddLongString(txt)
	local maxLen = 100
	for i = 0, string.len(txt), maxLen do
		local sub = string.sub(txt, i, math.min(i + maxLen, string.len(txt)))
		AddTextComponentString(sub)
	end
end

function ShowAdvancedAboveRadarMessage(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
	if saveToBrief == nil then saveToBrief = true end
	AddTextEntry('jamyfafis', msg)
	BeginTextCommandThefeedPost('jamyfafis')
	if hudColorIndex then ThefeedNextPostBackgroundColor(hudColorIndex) end
	EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
	EndTextCommandThefeedPostTicker(flash or false, saveToBrief)
end

function ShowAboveRadarMessage(message, back)
	if back then ThefeedNextPostBackgroundColor(back) end
	SetNotificationTextEntry("jamyfafi")
	AddLongString(message)
	return DrawNotification(0, 1)
end

function GetPlayers() -- Get Les joueurs
	local players = {}

	for _,player in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(player)

		if DoesEntityExist(ped) then
			table.insert(players, player)
		end
	end

	return players
end


function GetNearbyPlayers(distance)
	local ped = GetPlayerPed(-1)
	local playerPos = GetEntityCoords(ped)
	local nearbyPlayers = {}

	for _,v in pairs(GetPlayers()) do
		local otherPed = GetPlayerPed(v)
		local otherPedPos = otherPed ~= ped and IsEntityVisible(otherPed) and GetEntityCoords(otherPed)

		if otherPedPos and GetDistanceBetweenCoords(otherPedPos, playerPos) <= (distance or max) then
			nearbyPlayers[#nearbyPlayers + 1] = v
		end
	end
	return nearbyPlayers
end

local cWait = false;
local xWait = false
function GetNearbyPlayer(solo, other)
    if cWait then
        xWait = true
        while cWait do
            Citizen.Wait(5)
        end
    end
    xWait = false
    local cTimer = GetGameTimer() + 10000;
    local oPlayer = GetNearbyPlayers(2)
    if solo then
        oPlayer[#oPlayer + 1] = PlayerId()
    end
    if #oPlayer == 0 then
        ShowAboveRadarMessage("~b~Distance\n~w~Rapprochez-vous.")
        return false
    end
    if #oPlayer == 1 and other then
        return oPlayer[1]
    end
    ShowAboveRadarMessage("Appuyer sur ~g~E~s~ pour valider.~n~Appuyer sur ~b~A~s~ pour changer de cible.~n~Appuyer sur ~r~X~s~ pour annuler.")
    Citizen.Wait(100)
    local cBase = 1
    cWait = true
    while GetGameTimer() <= cTimer and not xWait do
        Citizen.Wait(0)
        DisableControlAction(0, 38, true)
        DisableControlAction(0, 73, true)
        DisableControlAction(0, 44, true)
        if IsDisabledControlJustPressed(0, 38) then
            cWait = false
            return oPlayer[cBase]
        elseif IsDisabledControlJustPressed(0, 73) then
            ShowAboveRadarMessage("~r~Vous avez annulé.")
            break
        elseif IsDisabledControlJustPressed(0, 44) then
            cBase = (cBase == #oPlayer) and 1 or (cBase + 1)
        end
        local cPed = GetPlayerPed(oPlayer[cBase])
        local cCoords = GetEntityCoords(cPed)
        DrawMarker(0, cCoords.x, cCoords.y, cCoords.z + 1.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.1, 0.1, 0.1, 0, 243, 255, 30, 1, 1, 0, 0, 0, 0, 0)
    end
    cWait = false
    return false
end
