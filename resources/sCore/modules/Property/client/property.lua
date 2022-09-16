ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then
        ESX.PlayerData = ESX.GetPlayerData()
    end
    TriggerServerEvent("sProperty:requestList")
    TriggerServerEvent("sProperty:requestavailableProperties")
    TriggerServerEvent("sProperty:requestKeysList")
end)

-- Create

local myLicense = ""
listProperties = nil

local CreateProperty = {
    Selected = {
        state = false,
        name = "",
        label = ""
    },
    name = "",
    price = 0,
    pos = "",
}
local labelAppartenant = ""

ObjectsDetails = {
    bong = {
        pretime = 300,
        anim = {"anim@safehouse@bong", "bong_stage1"},
        txt = "pour ~b~utiliser le bong~s~",
        time = 8000,
        func = CreateEffect,
        dynamic = true
    },
    wine = {
        pretime = 300,
        anim = {"mp_safehousewheatgrass@", "ig_2_wheatgrassdrink_michael"},
        txt = "pour ~p~boire du vin~s~",
        time = 8000
    },
    whiskey = {
        pretime = 300,
        anim = {"mp_safehousewheatgrass@", "ig_2_wheatgrassdrink_michael"},
        txt = "pour ~o~boire du whisky~s~",
        time = 8000
    },
    apple = {
        pretime = 300,
        anim = {"mp_safehousewheatgrass@", "ig_2_wheatgrassdrink_michael"},
        txt = "pour ~g~boire du jus de pomme~s~",
        time = 8000
    }
}

PropsInteract = {
    ["prop_bong_01"] = "bong",
    ["prop_bong_02"] = "bong",
    ["prop_sh_bong_01"] = "bong",
    ["hei_heist_sh_bong_01"] = "bong",

    ["p_wine_glass_s"] = "wine",
    ["prop_drink_champ"] = "wine",
    ["prop_drink_redwine"] = "wine",

    ["prop_drink_whtwine"] = "whiskey",
    ["prop_drink_whisky"] = "whiskey",
    ["prop_whiskey_01"] = "whiskey",
    ["p_whiskey_bottle_s"] = "whiskey",
    ["prop_whiskey_bottle"] = "whiskey",
    ["p_whiskey_notop_empty"] = "whiskey",
    ["prop_cs_whiskey_bottle"] = "whiskey",

    ["p_w_grass_gls_s"] = "apple",
    ["prop_wheat_grass_glass"] = "apple",
    ["prop_wheat_grass_half"] = "apple",
}

isInAnim = false

function UseProps(k, table, obj)
    local pPed = PlayerPedId()
    if table.anim then
        isInAnim = true 
        TaskAnim(table.anim)
        FreezeEntityPosition(pPed, true)
        local ObjectAttach
        Citizen.Wait(table.pretime or 0)
        SetEntityVisible(obj, false)
        if k then
            ObjectAttach = AttachObjectToHandsPeds(pPed, k, nil, nil, table.dynamic)
        end
        Citizen.Wait(table.time or 5000)
        if table.func then
            table.func()
        end
        if ObjectAttach and DoesEntityExist(ObjectAttach) then
            DeleteEntity(ObjectAttach)
        end
        FreezeEntityPosition(pPed, false)
        SetEntityVisible(obj, true)
        isInAnim = false 
    else
        if table.func then
            table.func()
        end
    end
end

-- Entity (vehicle)
function RequestControl(entity) --Request Control d'une entité
	local start = GetGameTimer()
	local entityId = tonumber(entity)
	if not DoesEntityExist(entityId) then return end
	if not NetworkHasControlOfEntity(entityId) then		
		NetworkRequestControlOfEntity(entityId)
		while not NetworkHasControlOfEntity(entityId) do
			Citizen.Wait(10)
			if GetGameTimer() - start > 5000 then return end
		end
	end
	return entityId
end


local function openCreateMenu()

    local mainMenu = RageUI.CreateMenu("", "Liste des propriétés", 0, 0, "root_cause", ConfigImmo.texture)
    local createMenuProperty = RageUI.CreateSubMenu(mainMenu, "", "Création de Propriété", 80, 90, "root_cause", ConfigImmo.texture)
    local propertyInfo = RageUI.CreateSubMenu(mainMenu, "", "Informations du Propriété", 80, 90, "root_cause", ConfigImmo.texture)
    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

    while mainMenu do
        Wait(0)

        RageUI.IsVisible(mainMenu, true, false, false, function()
            RageUI.Button("Créer une ~b~propriété~s~", nil, {RightLabel = "→"}, true, function(h, a, s)
                if s then
                    CreateProperty.Selected.state = false
                    CreateProperty.Selected.name = ""
                    CreateProperty.Selected.label = ""
                    CreateProperty.name = ""
                    CreateProperty.price = 0
                    CreateProperty.pos = ""
                end
            end, createMenuProperty)
            if listProperties == nil then
                RageUI.Separator("")
                RageUI.Separator("Hummm !")
                RageUI.Separator("")
            else
                RageUI.Separator("↓ Liste des ~b~propriétés~s~ ↓")
                for k,v in pairs(listProperties) do
                    if v.ownerLicense ~= "none" then labelAppartenant = "~g~Oui~s~" else labelAppartenant = "~r~Non~s~" end
                    local infos = v.info
                    RageUI.Button(infos.name, "Modèle : ~o~"..infos.Selected.label.."~s~\nAppartenant à une personne : "..labelAppartenant, {RightLabel = "~b~Voir plus~s~ →"}, true, function(h, a, s)
                        if s then
                            onProperty = v
                        end
                    end, propertyInfo)
                end
            end
        end)

        RageUI.IsVisible(propertyInfo, true, false, false, function()
            if onProperty == nil then
                RageUI.Separator("")
                RageUI.Separator("~b~Chargement...")
                RageUI.Separator("")
            else
                local infos = onProperty.info
                RageUI.Separator("↓ Informations de la ~b~Propriété~s~ n°~o~"..onProperty.propertyId.."~s~ ↓")
                RageUI.Separator("Type: ~o~"..infos.Selected.label)
                RageUI.Separator("Nom: ~b~"..infos.name)
                RageUI.Separator("Prix: "..infos.price.."~g~$~s~")
                if onProperty.street ~= nil then
                    RageUI.Separator("Avenue: ~b~"..onProperty.street)
                end
                if onProperty.ownerLicense == "none" then
                    RageUI.Separator("Appartenant à une personne : ~r~Non~s~")
                else
                    RageUI.Separator("Appartenant à une personne : ~g~Oui~s~")
                end
                RageUI.Button("Supprimer la propriété", nil, {RightLabel = "→ ~r~Supprimer~s~"}, true, function(h, a, s)
                    if s then 
                        TriggerServerEvent("sProperty:deleteProperty", onProperty.propertyId)
                        RageUI.CloseAll()
                    end
                end)
            end
        end)

        RageUI.IsVisible(createMenuProperty, true, false, false, function()
            if not CreateProperty.Selected.state then
                RageUI.Separator("↓ Liste des propriétés disponible ↓")
                for k,v in pairs(ConfigImmo.Batiment.Property) do
                    RageUI.Button(v.label, "Faites '~b~ENTRER~s~' pour sélectionner la propriété !", {}, true, function(h, a, s)
                        if s then
                            CreateProperty.Selected.state = true
                            CreateProperty.Selected.name = k
                            CreateProperty.Selected.label = v.label
                        end
                    end)
                end
            else 
                RageUI.Separator("~b~Propriété~s~ - Sélectionné (~b~"..CreateProperty.Selected.label.."~s~)")
                RageUI.Button("Nom de la Propriété", nil, {RightLabel = CreateProperty.name}, true, function(h, a, s)
                    if s then
                        local result = PropertyInput("Veuillez saisir un Nom !", "", 50)
                        if result == "" or result == nil then return ESX.ShowNotification("~r~Erreur~s~~n~Valeur non valide !") end
                        CreateProperty.name = result
                    end
                end)
                RageUI.Button("Prix de la Propriété", nil, {RightLabel = CreateProperty.price.."~g~$~s~"}, true, function(h, a, s)
                    if s then
                        local result = tonumber(PropertyInput("Veuillez saisir un Prix !", "", 7))
                        if result < 2500 then return ESX.ShowNotification("~r~Erreur~s~~n~Veuillez saisir un bon prix !") end
                        if result == "" or result == nil then return ESX.ShowNotification("~r~Erreur~s~~n~Valeur non valide !") end
                        CreateProperty.price = result
                    end
                end)
                RageUI.Button("Définir l'entrée", nil, { RightLabel = "~b~Définir~s~ →" }, true, function(_, _, s)
                    if s then
                        local pos = GetEntityCoords(PlayerPedId())
                        CreateProperty.pos = pos
                    end
                end)
                RageUI.Button("~g~Valider et sauvegarder", nil, {RightLabel = "→"}, true, function(h, a, s)
                    if s then
                        if CreateProperty.Selected.state == false or CreateProperty.Selected.name == "" or CreateProperty.Selected.name == nil or CreateProperty.Selected.label == "" or CreateProperty.Selected.label == nil or CreateProperty.name == "" or CreateProperty.name == nil or CreateProperty.price == 0 or CreateProperty.price == nil or CreateProperty.price == "" or CreateProperty.price < 2500 or CreateProperty.pos == "" or CreateProperty.pos == nil then 
                            ESX.ShowNotification("~r~Erreur~s~~n~Des valeurs sont incorrecte !")
                        else
                            local streetHash = Citizen.InvokeNative(0x2EB41072B4C1E4C0, CreateProperty.pos, Citizen.PointerValueInt(), Citizen.PointerValueInt())
                            local street = GetStreetNameFromHashKey(streetHash)
                            TriggerServerEvent("sProperty:saveProperty", CreateProperty, street)
                            ESX.ShowNotification("~b~Création de la propriétée en cours...")
                            RageUI.GoBack()    
                        end
                    end
                end)
            end
        end)

        if not RageUI.Visible(mainMenu) and not RageUI.Visible(createMenuProperty) and not RageUI.Visible(propertyInfo) then
            mainMenu = RMenu:DeleteType('menu', true)
        end
    end

end

RegisterNetEvent("sProperty:openCreateMenu")
AddEventHandler("sProperty:openCreateMenu", function()
    if ESX.PlayerData.job.name ~= ConfigImmo.job then return end
    openCreateMenu()
end)

RegisterNetEvent("sProperty:returnProperty")
AddEventHandler("sProperty:returnProperty", function(a)
    if a == nil then return end
    listProperties = a
end)

-- Blips

local availableProperties = {}
local ownedProperties = {}

RegisterNetEvent("sProperty:cbavailableProperties")
AddEventHandler("sProperty:cbavailableProperties", function(license, available, owned)
    myLicense = license
    for _, blip in pairs(availableProperties) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    for _, blip in pairs(ownedProperties) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    for k,v in pairs(available) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, 350)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 2)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Propriété à vendre")
        EndTextCommandSetBlipName(blip)
        availableProperties[k] = blip
    end
    for k,v in pairs(owned) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, 411)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 2)
        SetBlipAsShortRange(blip, true)
        SetBlipDisplay(blip, 5)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Propriété acquise")
        EndTextCommandSetBlipName(blip)
        ownedProperties[k] = blip
    end
end)

RegisterNetEvent("sProperty:addAvailableProperty")
AddEventHandler("sProperty:addAvailableProperty", function(available)
    if availableProperties[available.id] then
        return
    end
    local blip = AddBlipForCoord(available.coords.x, available.coords.y, available.coords.z)
    SetBlipSprite(blip, 375)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, 0.5)
    SetBlipDisplay(blip, 3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Propriété à vendre")
    EndTextCommandSetBlipName(blip)
    availableProperties[available.id] = blip
end)

RegisterNetEvent("sProperty:addOwnedProperty")
AddEventHandler("sProperty:addOwnedProperty", function(owned)
    if ownedProperties[owned.id] then
        return
    end
    local blip = AddBlipForCoord(owned.coords.x, owned.coords.y, owned.coords.z)
    SetBlipSprite(blip, 374)
    SetBlipAsShortRange(blip, false)
    SetBlipScale(blip, 0.5)
    SetBlipDisplay(blip, 3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Propriété acquis")
    EndTextCommandSetBlipName(blip)
    ownedProperties[owned.id] = blip
end)

RegisterNetEvent("sProperty:propertyNoLongerAvailable")
AddEventHandler("sProperty:propertyNoLongerAvailable", function(propertyId)
    if not availableProperties[propertyId] or not DoesBlipExist(availableProperties[propertyId]) then
        return
    end
    RemoveBlip(availableProperties[propertyId])
    availableProperties[propertyId] = nil
end)

RegisterNetEvent("sProperty:propertyNoLongerOwner")
AddEventHandler("sProperty:propertyNoLongerOwner", function(owned)
    if not ownedProperties[owned.id] or not DoesBlipExist(ownedProperties[owned.id]) then
        return
    end
    RemoveBlip(ownedProperties[owned.id])
    ownedProperties[owned.id] = nil
end)

RegisterNetEvent("sProperty:propertyNoLongerAllowed")
AddEventHandler("sProperty:propertyNoLongerAllowed", function(propertyId)
    if not accessProperty[propertyId] or not DoesBlipExist(availableProperties[propertyId]) then
        return
    end
    RemoveBlip(accessProperty[propertyId])
    accessProperty[propertyId] = nil
end)

-- Manager

local jobList = {}
local groupList = {}

local function openManagement(owner, propertyId)
    local mainMenu = RageUI.CreateMenu("Gestion", "Propriété", 80, 90)
    
    local keysMenu = RageUI.CreateSubMenu(mainMenu, "Propriété", "Clés", 80, 90)
    local keysMenuCivil = RageUI.CreateSubMenu(keysMenu, "Clés", "Gestion des clés civils", 80, 90)
    local keysMenuJob = RageUI.CreateSubMenu(keysMenu, "Clés", "Gestion des métiers")
    local keysMenuGang = RageUI.CreateSubMenu(keysMenu, "Clés", "Gestion des groupes")

    local stockMenu = RageUI.CreateSubMenu(mainMenu, "Propriété", "Stockage", 80, 90)
    local depositStock = RageUI.CreateSubMenu(stockMenu, "Stockage", "Déposer")
    local withdrawStock = RageUI.CreateSubMenu(stockMenu, "Stockage", "Prendre")

    TriggerServerEvent("sProperty:requestKeysAccess", propertyId)
    FreezeEntityPosition(PlayerPedId(), true)

    while returnkeysAccess == nil do
        Wait(50)
    end

    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

    while mainMenu do
        Wait(1)

        RageUI.IsVisible(mainMenu, true, true, true, function()

            if owner == true then
                RageUI.Button("Gérer les clés", nil, {RightLabel = "~b~Gérer~s~ →"}, true, function(h, a, s)
                end, keysMenu)
            end

            RageUI.Button("Stockage", nil, {RightLabel = "~b~Voir et Gérer~s~ →"}, true, function(h, a, s)
                if s then
                    RageUI.CloseAll()
                    local items, weapons, blackMoney = {}, {}, 0
                    TriggerServerEvent("sProperty:requestInventory", propertyId)
                    while stockInventory == nil do
                        Wait(0)
                    end
                    for k,v in pairs(stockInventory) do
                        if v.type == "item" then
                            table.insert(items, {count = v.count, label = v.label, name = v.name})
                        end
                        if v.type == 'weapon' then 
                            table.insert(weapons, {name = v.name, ammo = v.ammo})
                        end 
                        if v.type == 'dirtycash' then 
                            blackMoney = v.count
                        end
                    end

                    TriggerEvent('esx_inventoryhud:openPropertyInventory', {blackMoney = blackMoney, items = items, weapons = weapons})
                end
            end)

        end)

        RageUI.IsVisible(keysMenu, true, true, true, function()
                    
            RageUI.Button("Personne à proximité", nil, {RightLabel = "~b~Attribuer~s~ →"}, true, function(h, a, s)
                if s then
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer ~= -1 and closestDistance <= 3.0 then
                        TriggerServerEvent("sProperty:addKeysAccess", propertyId, "person", GetPlayerName(GetPlayerServerId(closestPlayer)), GetPlayerServerId(closestPlayer))
                    else
                        ESX.ShowNotification("~r~Erreur~s~~n~Personne à proximiter !")
                    end
                end
            end)

            RageUI.Button("Destitué les clés de personnes", nil, {RightLabel = "~b~Voir~s~ →"}, true, function(h, a, s)
            end, keysMenuCivil)

            RageUI.Button("Attribuer à un des ~b~métiers~s~", nil, {RightLabel = "~b~Voir~s~ →"}, true, function(h, a, s)
            end, keysMenuJob)

            RageUI.Button("Attribuer à un des ~b~groupes~s~", nil, {RightLabel = "~b~Voir~s~ →"}, true, function(h, a, s)
            end, keysMenuGang)

        end)

        RageUI.IsVisible(keysMenuCivil, true, true, true, function()

            for k,v in pairs(returnkeysAccess) do
                if v.type == "person" then
                    if #v ~= 0 then
                        RageUI.Separator("")
                        RageUI.Separator("~o~Aucune clés reconnue !")
                        RageUI.Separator("")
                    else
                        RageUI.Button(v.name, nil, {RightLabel = "Enlever la permission~s~ →"}, true, function(h,a,s)
                            if s then
                                TriggerServerEvent("sProperty:removeKeysAccess", propertyId, v.type, v.name, k)
                            end
                        end)
                    end
                end
            end

        end)

        RageUI.IsVisible(keysMenuJob, true, true, true, function()

            RageUI.Separator("↓ Liste des ~b~métiers~s~ ↓")

            for k,v in pairs(jobList) do

                if returnkeysAccess[k] == nil then autorizedLabel = "~r~Non~s~" else autorizedLabel = "~g~Oui~s~" end

                RageUI.Button(v.label, "Autorisé: "..autorizedLabel, {RightLabel = "~o~Changer la permission~s~ →"}, true, function(h, a, s)
                    if s then
                        if returnkeysAccess[k] == nil then
                            TriggerServerEvent("sProperty:addKeysAccess", propertyId, "jobList", v.label, k)
                        else
                            TriggerServerEvent("sProperty:removeKeysAccess", propertyId, "jobList", v.label, k)
                        end                    
                    end
                end)

            end

        end)

        RageUI.IsVisible(keysMenuGang, true, true, true, function()

            RageUI.Separator("↓ Liste des ~b~Groupes~s~ ↓")

            for k,v in pairs(groupList) do

                if returnkeysAccess[k] == nil then autorizedLabel = "~r~Non~s~" else autorizedLabel = "~g~Oui~s~" end

                RageUI.Button(v.label, "Autorisé: "..autorizedLabel, {RightLabel = "~o~Changer la permission~s~ →"}, true, function(h, a, s)
                    if s then
                        if returnkeysAccess[k] == nil then
                            TriggerServerEvent("sProperty:addKeysAccess", propertyId, "groupList", v.label, k)
                        else
                            TriggerServerEvent("sProperty:removeKeysAccess", propertyId, "groupList", v.label, k)
                        end
                    end
                end)
                
            end

        end)

--[[         RageUI.IsVisible(stockMenu, true, true, true, function()
        
            RageUI.Button("Déposer", nil, {RightLabel = "~b~→~s~→"}, true, function(h, a, s)
                if s then
                    ESX.PlayerData = ESX.GetPlayerData()
                end
            end, depositStock)
            
            RageUI.Button("Prendre", nil, {RightLabel = "~b~→~s~→"}, true, function(h, a, s)
                if s then
                    TriggerServerEvent("sProperty:requestInventory", propertyId)
                end
            end, withdrawStock)

        end) ]]

        RageUI.IsVisible(depositStock, true, true, true, function()
            
            if #ESX.PlayerData.inventory == 0 then            

                RageUI.Separator("")
                RageUI.Separator("~r~Aucun items détecté !")
                RageUI.Separator("")

            else

                RageUI.Separator("↓ ~b~Votre argent~s~ ↓")

                for i = 1, #ESX.PlayerData.accounts, 1 do
                    if ESX.PlayerData.accounts[i].name == 'cash'  then
                        RageUI.Button('Argent liquide : '..ESX.PlayerData.accounts[i].money..'~g~$~s~', nil, {RightLabel = "~b~Déposer~s~ →"}, true, function(h, a, s)
                            if s then
                                local count = tonumber(PropertyInput("Veuillez saisir une ~b~quantité~s~ :", "", 6))
                                if count == nil or count == "" or count < 1 then
                                    ESX.ShowNotification("~r~Erreur~s~~n~Quantité invalide !")
                                else
                                    TriggerServerEvent("sProperty:addItems", propertyId,"money", ESX.PlayerData.accounts[i].name, count, 0)
                                    RageUI.GoBack()
                                end
                            end
                        end)
                    elseif ESX.PlayerData.accounts[i].name == 'dirtycash'  then
                        RageUI.Button('Source inconnue : '..ESX.PlayerData.accounts[i].money..'~c~$~s~', nil, {RightLabel = "~b~Déposer~s~ →"}, true, function(h, a, s)
                            if s then
                                local count = tonumber(PropertyInput("Veuillez saisir une ~b~quantité~s~ :", "", 6))
                                if count == nil or count == "" or count < 1 then
                                    ESX.ShowNotification("~r~Erreur~s~~n~Quantité invalide !")
                                else
                                    TriggerServerEvent("sProperty:addItems", propertyId, "money", "dirtycash", count, 0)
                                    RageUI.GoBack()
                                end
                            end
                        end)
                    end
                end

                RageUI.Separator("↓ ~b~Vos armes~s~ ↓")

                for i = 1, #ESX.PlayerData.loadout do
                    local weapon = ESX.PlayerData.loadout[i]
                    if weapon.ammo == nil then weapon.ammo = 0 end
                    RageUI.Button(weapon.label, weapon.ammo.." Munition(s)", {RightLabel = "~b~Déposer~s~ →"}, true, function(h, a, s)
                        if s then
                            TriggerServerEvent("sProperty:addItems", propertyId, "weapon", weapon.name, 1, weapon.ammo)
                            RageUI.GoBack()
                        end
                    end)
                end

                RageUI.Separator("↓ ~b~Votre inventaire~s~ ↓")

                for i = 1, #ESX.PlayerData.inventory do
                    local item = ESX.PlayerData.inventory[i]
                    if item.count > 0 then
                        RageUI.Button(item.label, "Quantité: ~b~"..item.count.."~s~", {RightLabel = "~b~Déposer~s~ →"}, true, function(h, a, s)
                            if s then
                                local count = tonumber(PropertyInput("Veuillez saisir une ~b~quantité~s~ :", "", 6))
                                if count == nil or count == "" or count < 1 then
                                    ESX.ShowNotification("~r~Erreur~s~~n~Quantité invalide !")
                                else
                                    TriggerServerEvent("sProperty:addItems", propertyId, "item", item.name, count, 0)
                                    RageUI.GoBack()
                                end
                            end
                        end)
                    end
                end

                
            
            end

        end)

        --[[ RageUI.IsVisible(withdrawStock, true, true, true, function()
            if stockInventory == nil then
                RageUI.Separator("")
                RageUI.Separator("~c~Chargement...")
                RageUI.Separator("")
            else
                if #stockInventory == 0 then

                    RageUI.Separator("")
                    RageUI.Separator("~r~Aucun stock trouvé !")
                    RageUI.Separator("")

                else

                    RageUI.Separator("↓ ~b~Stockage~s~ ↓")

                    for k,v in pairs(stockInventory) do
                        if v.type == "money" then
                            if v.name == "cash" then
                                RageUI.Button(v.label, v.count.."~g~$~s~", {RightLabel = "~b~Prendre~s~ →"}, true, function(h, a, s)
                                    if s then
                                        local count = tonumber(PropertyInput("Veuillez saisir une ~b~somme~s~ :", "", 6))
                                        if count == nil or count == "" or count < 1 then
                                            ESX.ShowNotification("~r~Erreur~s~~n~Quantité invalide !")
                                        else
                                            TriggerServerEvent("sProperty:removeItems", propertyId, "money", v.name, count, 0)
                                            RageUI.GoBack()
                                        end
                                    end
                                end)
                            elseif v.name == "dirtycash" then
                                RageUI.Button(v.label, v.count.."~c~$~s~", {RightLabel = "~b~Prendre~s~ →"}, true, function(h, a, s)
                                    if s then
                                        local count = tonumber(PropertyInput("Veuillez saisir une ~b~somme~s~ :", "", 6))
                                        if count == nil or count == "" or count < 1 then
                                            ESX.ShowNotification("~r~Erreur~s~~n~Quantité invalide !")
                                        else
                                            TriggerServerEvent("sProperty:removeItems", propertyId, "money", "dirtycash", count, 0)
                                            RageUI.GoBack()
                                        end
                                    end
                                end)
                            end
                        end
                        if v.type == "item" then
                            if v.count > 0 then
                                RageUI.Button(v.label, "Quantité: ~b~"..v.count.."~s~", {RightLabel = "~b~Prendre~s~ →"}, true, function(h, a, s)
                                    if s then
                                        local count = tonumber(PropertyInput("Veuillez saisir une ~b~quantité~s~ :", "", 6))
                                        if count == nil or count == "" or count < 1 then
                                            ESX.ShowNotification("~r~Erreur~s~~n~Quantité invalide !")
                                        else
                                            TriggerServerEvent("sProperty:removeItems", propertyId, "item", v.name, count, 0)
                                            RageUI.GoBack()
                                        end
                                    end
                                end)
                            end
                        end
                        if v.type == "weapon" then
                            if v.count > 0 then
                                RageUI.Button(v.label, "Munition(s): ~o~"..v.ammo.."~s~", {RightLabel = "~b~Prendre~s~ →"}, true, function(h, a, s)
                                    if s then
                                        TriggerServerEvent("sProperty:removeItems", propertyId, "weapon", v.name, 1, v.ammo)
                                        RageUI.GoBack()
                                    end
                                end)
                            end
                        end
                    end

                end
            end
            
        end) ]]

        if not RageUI.Visible(mainMenu) and not RageUI.Visible(keysMenu) and not RageUI.Visible(keysMenuJob) and not RageUI.Visible(keysMenuGang) and not RageUI.Visible(keysMenuCivil) and not RageUI.Visible(stockMenu) and not RageUI.Visible(depositStock) and not RageUI.Visible(withdrawStock) then
            mainMenu = RMenu:DeleteType('menu', true)
        end
    end
    FreezeEntityPosition(PlayerPedId(), false)
end

RegisterNetEvent("sProperty:returnInventory")
AddEventHandler("sProperty:returnInventory", function(inventory)
    stockInventory = inventory
end)

-- Boucle

local playerKeyAcces = {}

Citizen.CreateThread(function()

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    while true do
        local nofps = false
        local myCoords = GetEntityCoords(PlayerPedId())

        while listProperties == nil do
            Wait(50)
        end

        for k,v in pairs(listProperties) do
            local infos = v.info
            if #(vector3(infos.pos.x, infos.pos.y, infos.pos.z)-myCoords) < 2.0 then
                nofps = true
                if v.ownerLicense ~= "none" then

                    while myLicense == "" do
                        Wait(150)
                    end
                    
                    if v.ownerLicense == myLicense then
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour rentrer dans ~b~la propriété~s~.")
                        if IsControlJustReleased(0, 54) then
                            TriggerServerEvent("sProperty:enter", v.propertyId, true)
                        end
                    else
                        while playerKeyAcces[v.propertyId] == nil do
                            Wait(50)
                            TriggerServerEvent("sProperty:getKeysAccesPlayer", v.propertyId)
                        end

                        if not playerKeyAcces[v.propertyId] then
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~sonner~s~.")
                            if IsControlJustReleased(0, 54) then
                                TriggerServerEvent("sProperty:requestInvitePlayer", v.propertyId, false)
                            end
                        else
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~entrer avec vos clés~s~.")
                            if IsControlJustReleased(0, 54) then
                                TriggerServerEvent("sProperty:enter", v.propertyId, "key")
                            end
                        end
                    end
                else
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~visiter~s~.")
                    if IsControlJustReleased(0, 54) then
                        TriggerServerEvent("sProperty:enter", v.propertyId, false)
                    end
                end
            end
        end

        if nofps then
            Wait(1)
        else
            Wait(850)
        end
    end
end)

RegisterNetEvent("sProperty:returnEnter")
AddEventHandler("sProperty:returnEnter", function(lastpos, table, owner, infosProperty, inventory)
    if table == nil then return end
    onProperty = true

    FreezeEntityPosition(PlayerPedId(), true)
    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do
        Wait(1)
    end
    local co = table.interiorEntry
    SetEntityCoords(PlayerPedId(), co.pos, false, false, false, false)
    SetEntityHeading(PlayerPedId(), co.heading)
    Wait(250)
    DoScreenFadeIn(800)
    FreezeEntityPosition(PlayerPedId(), false)

    CreateThread(function()

        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end

        while onProperty do
            local nofps = false
            local pCoords = GetEntityCoords(PlayerPedId())
            for k, v in pairs(PropsInteract) do
                local object = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.0, GetHashKey(k), false, true, true)
                if object and DoesEntityExist(object) and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(object), true) < 1.0 and ObjectsDetails[v] and not isInAnim then
                    nofps = true
                    DrawText3D(GetEntityCoords(object).x, GetEntityCoords(object).y, GetEntityCoords(object).z +.5, "Appuyez sur ~b~E ~s~"..ObjectsDetails[v].txt.."~s~.", 15)
                    if IsControlJustPressed(0, 51) then 
                        RequestControl(object)
                        UseProps(k, ObjectsDetails[v], object)
                    end
                end
            end
            if #(pCoords-table.interiorEntry.pos) < 1.25 then
                nofps = true
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~sortir de la propriété~s~.")
                if IsControlJustReleased(0, 54) then
                    onProperty = false
                end
            end
            
            if owner == true then
                if #(pCoords-table.managerLocation) < 1.25 then
                    nofps = true
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~ouvrir la gestion de la propriété~s~.")
                    if IsControlJustReleased(0, 54) then
                        openManagement(owner, infosProperty.propertyId)
                    end
                end
            elseif owner == "key" then
                if #(pCoords-table.managerLocation) < 1.25 then
                    nofps = true
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~ouvrir la gestion de la propriété~s~.")
                    if IsControlJustReleased(0, 54) then
                        openManagement(owner, infosProperty.propertyId)
                    end
                end
            end

            if nofps then
                Wait(1)
            else
                Wait(850)
            end
        end
    end)
    
    while onProperty do
        Wait(150)
    end

    FreezeEntityPosition(PlayerPedId(), true)
    DoScreenFadeOut(750)
    Wait(750)
    Wait(750)
    SetCanAttackFriendly(PlayerPedId(), true, false)
    SetEntityCoords(PlayerPedId(), lastpos, false, false, false, false)
    SetEntityInvincible(PlayerPedId(), false)
    DoScreenFadeIn(750)
    FreezeEntityPosition(PlayerPedId(), false)
    TriggerServerEvent("sProperty:exitProperty", infosProperty.propertyId)

end)

RegisterNetEvent("sProperty:addRequestAttribute")
AddEventHandler("sProperty:addRequestAttribute", function(request, price)

    RageUI.PopupChar({
		message = "Paiement d'une propriété le prix : "..price.."~g~$~s~\n~g~B~s~ accepter ou ~r~G~s~ pour décliner.",
		picture = "CHAR_CHAT_CALL",
		title = "Propriété",
		iconTypes = 1,
		sender = "~b~Paiement~s~"
	})

	Citizen.Wait(100)
	InProgress = true
	local count = 0
	Citizen.CreateThread(function()

        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end

		while InProgress do

			if IsControlPressed(0, 29) then
				RageUI.Popup({message="~g~Vous avez accepté le paiement"})
				InProgress = false
				count = 0
                TriggerServerEvent("sProperty:returnCbAtribute", request, true)
			elseif IsControlPressed(0, 58) then
				RageUI.Popup({message="~r~Vous avez décliner le paiement"})
				InProgress = false
				count = 0
                TriggerServerEvent("sProperty:returnCbAtribute", request, false)
			end
	
			count = count + 1

			if count >= 1000 then
				InProgress = false
				count = 0
				RageUI.Popup({message="~r~Vous avez ignoré l'invitation"})
			end
	
			Citizen.Wait(10)
		end
	end)

end)

RegisterNetEvent("sProperty:returnInvitePlayer")
AddEventHandler("sProperty:returnInvitePlayer", function(name, r)

    RageUI.PopupChar({
		message = "La personne ~b~"..name.."~s~ veut se faire inviter\n\n~b~B~s~ Accepter. | ~r~G~s~ Décliner.",
		picture = "CHAR_CHAT_CALL",
		title = "~b~Propriété~s~",
		iconTypes = 1,
		sender = "Invitation"
	})

	Citizen.Wait(100)
	InProgress = true
	local count = 0
	Citizen.CreateThread(function()

        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end

		while InProgress do

			if IsControlPressed(0, 29) then
				RageUI.Popup({message="~g~Vous avez accepté l'invitation"})
				InProgress = false
				count = 0
                TriggerServerEvent("sProperty:returnCbInvite", r, true)
			elseif IsControlPressed(0, 58) then
				RageUI.Popup({message="~r~Vous avez décliner l'invitation"})
				InProgress = false
				count = 0
                TriggerServerEvent("sProperty:returnCbInvite", r, false)
			end
	
			count = count + 1

			if count >= 1000 then
				InProgress = false
				count = 0
				RageUI.Popup({message="~r~Vous avez ignoré l'invitation"})
			end
	
			Citizen.Wait(10)
		end
	end)

end)

RegisterNetEvent("sProperty:returnKeysList")
AddEventHandler("sProperty:returnKeysList", function(jobs, groupes)
    jobList = jobs
    groupList = groupes
end)

RegisterNetEvent("sProperty:returnCallBackKeys")
AddEventHandler("sProperty:returnCallBackKeys", function(keysAccess)
    returnkeysAccess = keysAccess
end)

RegisterNetEvent("sProperty:returnPlayerAcces")
AddEventHandler("sProperty:returnPlayerAcces", function(propertyId, acces)
    if acces == nil then
        playerKeyAcces = {}
    else
        playerKeyAcces[propertyId] = acces
    end
end)