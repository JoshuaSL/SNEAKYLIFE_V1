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
    TriggerServerEvent("sGarage:requestList")
    TriggerServerEvent("sGarage:requestAvailableGarages")
end)

-- Create

local myLicense = ""
listGarages = {}

local CreateGarage = {
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

local function openCreateMenu()

    local mainMenu = RageUI.CreateMenu("", "Liste des garages", nil, nil, "root_cause", ConfigImmo.texture)
    local createMenuGarage = RageUI.CreateSubMenu(mainMenu, "", "Création de Garage", nil, nil, "root_cause", ConfigImmo.texture)
    local garageInfo = RageUI.CreateSubMenu(mainMenu, "", "Informations du Garage", nil, nil, "root_cause", ConfigImmo.texture)
    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

    while mainMenu do
        Wait(0)

        RageUI.IsVisible(mainMenu, true, false, false, function()
            RageUI.Button("Créer un ~o~garage~s~", nil, {RightLabel = "→"}, true, function(h, a, s)
                if s then
                    CreateGarage.Selected.state = false
                    CreateGarage.Selected.name = ""
                    CreateGarage.Selected.label = ""
                    CreateGarage.name = ""
                    CreateGarage.price = ""
                    CreateGarage.pos = ""
                end
            end, createMenuGarage)

            RageUI.Separator("↓ Liste des ~o~garages~s~ ↓")
                for k,v in pairs(listGarages) do
                    if v.ownerLicense ~= "none" then labelAppartenant = "~g~Oui~s~" else labelAppartenant = "~r~Non~s~" end
                    local infos = v.info
                    RageUI.Button(infos.name, "Modèle : ~o~"..infos.Selected.label.."~s~\nAppartenant à une personne : "..labelAppartenant, {RightLabel = "~o~Voir plus~s~ →"}, true, function(h, a, s)
                        if s then
                            onGarage = v
                        end
                    end, garageInfo)
                end
        end)

        RageUI.IsVisible(garageInfo, true, false, false, function()
            if onGarage == nil then
                RageUI.Separator("")
                RageUI.Separator("~o~Chargement...")
                RageUI.Separator("")
            else
                local infos = onGarage.info
                RageUI.Separator("↓ Informations du ~o~Garage~s~ n°~b~"..onGarage.garageId.."~s~ ↓")
                RageUI.Separator("Type: ~o~"..infos.Selected.label)
                RageUI.Separator("Nom: ~b~"..infos.name)
                RageUI.Separator("Prix: "..infos.price.."~g~$~s~")
                if onGarage.street ~= nil then
                    RageUI.Separator("Avenue: ~b~"..onGarage.street)
                end
                if onGarage.ownerLicense == "none" then
                    RageUI.Separator("Appartenant à une personne : ~r~Non~s~")
                else
                    RageUI.Separator("Appartenant à une personne : ~g~Oui~s~")
                end
                RageUI.Button("Supprimer le garage", nil, {RightLabel = "→ ~r~Supprimer~s~"}, true, function(h, a, s)
                    if s then 
                        TriggerServerEvent("sGarage:deleteGarage", onGarage.garageId)
                        RageUI.CloseAll()
                    end
                end)
            end
        end)

        RageUI.IsVisible(createMenuGarage, true, false, false, function()
            if not CreateGarage.Selected.state then
                RageUI.Separator("↓ Liste des garages disponibles ↓")
                for k,v in pairs(ConfigImmo.Batiment.Garage) do
                    RageUI.Button(v.label, "Faites '~b~ENTER~s~' pour sélectionner le garage !", {}, true, function(h, a, s)
                        if s then
                            CreateGarage.Selected.state = true
                            CreateGarage.Selected.name = v.name
                            CreateGarage.Selected.label = v.label
                        end
                    end)
                end
            else 
                RageUI.Separator("~o~Garage~s~ - Sélectionné (~b~"..CreateGarage.Selected.label.."~s~)")
                RageUI.Button("Nom du Garage", nil, {RightLabel = CreateGarage.name}, true, function(h, a, s)
                    if s then
                        local result = PropertyInput("Veuillez saisir un Nom !", "", 50)
                        if result == "" or result == nil then return ESX.ShowNotification("~r~Erreur~s~~n~Valeur non valide !") end
                        CreateGarage.name = result
                    end
                end)
                RageUI.Button("Prix du Garage", nil, {RightLabel = CreateGarage.price.."~g~$~s~"}, true, function(h, a, s)
                    if s then
                        local result = tonumber(PropertyInput("Veuillez saisir un Prix !", "", 7))
                        if result < 2500 then return ESX.ShowNotification("~r~Erreur~s~~n~Veuillez saisir un bon prix !") end
                        if result == "" or result == nil then return ESX.ShowNotification("~r~Erreur~s~~n~Valeur non valide !") end
                        CreateGarage.price = result
                    end
                end)
                RageUI.Button("Définir l'entrée", nil, { RightLabel = "~b~Définir~s~ →" }, true, function(_, _, s)
                    if s then
                        local pos = GetEntityCoords(PlayerPedId())
                        CreateGarage.pos = pos
                    end
                end)
                RageUI.Button("~g~Valider et sauvegarder", nil, {RightLabel = "→"}, true, function(h, a, s)
                    if s then
                        if CreateGarage.Selected.state == false or CreateGarage.Selected.name == "" or CreateGarage.Selected.name == nil or CreateGarage.Selected.label == "" or CreateGarage.Selected.label == nil or CreateGarage.name == "" or CreateGarage.name == nil or CreateGarage.price == 0 or CreateGarage.price == nil or CreateGarage.price == "" or CreateGarage.price <= 2500 or CreateGarage.pos == "" or CreateGarage.pos == nil then 
                            ESX.ShowNotification("~r~Erreur~s~~n~Des valeurs sont incorrecte !")
                        else
                            local streetHash = Citizen.InvokeNative(0x2EB41072B4C1E4C0, CreateGarage.pos, Citizen.PointerValueInt(), Citizen.PointerValueInt())
                            local street = GetStreetNameFromHashKey(streetHash)
                            TriggerServerEvent("sGarage:saveGarage", CreateGarage, street)
                            ESX.ShowNotification("~o~Création du garage en cours...")
                            RageUI.GoBack()    
                        end
                    end
                end)
            end
        end)

        if not RageUI.Visible(mainMenu) and not RageUI.Visible(createMenuGarage) and not RageUI.Visible(garageInfo) then
            mainMenu = RMenu:DeleteType('menu', true)
        end
    end

end

RegisterNetEvent("sGarage:openCreateMenu")
AddEventHandler("sGarage:openCreateMenu", function()
    if ESX.PlayerData.job.name ~= ConfigImmo.job then return end
    openCreateMenu()
end)

RegisterNetEvent("sGarage:returnGarage")
AddEventHandler("sGarage:returnGarage", function(a)
    listGarages = a
end)

-- Blips

local availableGarages = {}
local ownedGarages = {}

RegisterNetEvent("sGarage:cbavailableGarages")
AddEventHandler("sGarage:cbavailableGarages", function(license, available, owned)
    myLicense = license
    for _, blip in pairs(availableGarages) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    for _, blip in pairs(ownedGarages) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    for k,v in pairs(available) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, 369)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 0)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Garage à vendre")
        EndTextCommandSetBlipName(blip)
        availableGarages[k] = blip
    end
    for k,v in pairs(owned) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, 357)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 3)
        SetBlipAsShortRange(blip, true)
        SetBlipDisplay(blip, 5)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Garage acquis")
        EndTextCommandSetBlipName(blip)
        ownedGarages[k] = blip
    end
end)

RegisterNetEvent("sGarage:addAvailableGarage")
AddEventHandler("sGarage:addAvailableGarage", function(available)
    if availableGarages[available.id] then
        return
    end
    local blip = AddBlipForCoord(available.coords.x, available.coords.y, available.coords.z)
    SetBlipSprite(blip, 369)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, 0.5)
    SetBlipDisplay(blip, 3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Garage à vendre")
    EndTextCommandSetBlipName(blip)
    availableGarages[available.id] = blip
end)

RegisterNetEvent("sGarage:addOwnedGarage")
AddEventHandler("sGarage:addOwnedGarage", function(owned)
    if ownedGarages[owned.id] then
        return
    end
    local blip = AddBlipForCoord(owned.coords.x, owned.coords.y, owned.coords.z)
    SetBlipSprite(blip, 357)
    SetBlipAsShortRange(blip, false)
    SetBlipScale(blip, 0.5)
    SetBlipDisplay(blip, 3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Garage acquis")
    EndTextCommandSetBlipName(blip)
    ownedGarages[owned.id] = blip
end)

RegisterNetEvent("sGarage:garageNoLongerAvailable")
AddEventHandler("sGarage:garageNoLongerAvailable", function(garageId)
    if not availableGarages[garageId] or not DoesBlipExist(availableGarages[garageId]) then
        return
    end
    RemoveBlip(availableGarages[garageId])
    availableGarages[garageId] = nil
end)

RegisterNetEvent("sGarage:garageNoLongerOwner")
AddEventHandler("sGarage:garageNoLongerOwner", function(owned)
    if not ownedGarages[owned.id] or not DoesBlipExist(ownedGarages[owned.id]) then
        return
    end
    RemoveBlip(ownedGarages[owned.id])
    ownedGarages[owned.id] = nil
end)

RegisterNetEvent("sGarage:garageNoLongerAllowed")
AddEventHandler("sGarage:garageNoLongerAllowed", function(garageId)
    if not accessGarage[garageId] or not DoesBlipExist(availableGarages[garageId]) then
        return
    end
    RemoveBlip(accessGarage[garageId])
    accessGarage[garageId] = nil
end)

-- Management vehicle

local infoVeh = nil
local function openManagementVehicle(vehicles)
    local mainMenu = RageUI.CreateMenu("Gestion", "Véhicules", 80, 80)
    local infosVehicle = RageUI.CreateSubMenu(mainMenu, "Info", "Véhicule", 80, 80)

    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))
    FreezeEntityPosition(PlayerPedId(), true)

    while mainMenu do
        Wait(0)

        RageUI.IsVisible(mainMenu, true, false, false, function()
            if #vehicles > 0 then
                RageUI.Separator("↓ Liste de vos ~b~véhicules~s~ ↓")
                for k,v in pairs(vehicles) do
                    props = v.props
                    RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(props.model)), "Plaque: ~b~"..props.plate, {RightLabel = "~b~Voir plus~s~ →"}, true, function(h, a, s)
                        if s then
                            infoVeh = v
                        end
                    end, infosVehicle)
                end
            else
                RageUI.Separator("")
                RageUI.Separator("~r~Aucun véhicules trouvé !")
                RageUI.Separator("")
            end
        end)

        RageUI.IsVisible(infosVehicle, true, false, false, function()
            if infoVeh == nil then
                RageUI.Separator("")
                RageUI.Separator("~c~Chargement...")
                RageUI.Separator("")
            else
                props = infoVeh.props
                RageUI.Separator("Modèle du véhicule: ~b~"..GetLabelText(GetDisplayNameFromVehicleModel(props.model)))
                RageUI.Separator("Plaque du véhicule: ~b~"..props.plate)
                RageUI.Separator("Essence du véhicule: "..math.ceil(props.fuelLevel).."~b~/~s~100%")
                RageUI.Separator("État du véhicule: "..math.ceil(props.bodyHealth).."~b~/~s~1000%")
                RageUI.Separator("État du moteur: "..math.ceil(props.engineHealth).."~b~/~s~1000%")
            end
        end)

        if not RageUI.Visible(mainMenu) and not RageUI.Visible(infosVehicle) then
            mainMenu = RMenu:DeleteType('menu', true)
        end

    end

    FreezeEntityPosition(PlayerPedId(), false)

end

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

    while true do
        local nofps = false
        local myCoords = GetEntityCoords(PlayerPedId())

        for k,v in pairs(listGarages) do
            local infos = v.info
            if #(vector3(infos.pos.x, infos.pos.y, infos.pos.z)-myCoords) < 2.0 then
                nofps = true
                if v.ownerLicense ~= "none" then
                    while myLicense == "" do
                        Wait(150)
                    end
                    
                    if v.ownerLicense == myLicense then
                        if not IsPedInAnyVehicle(PlayerPedId(), false) then
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour rentrer dans ~b~le garage~s~.")
                            if IsControlJustReleased(0, 54) then
                                TriggerServerEvent("sGarage:enter", v.garageId, true)
                            end
                        else
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour rentrer votre ~b~véhicule~s~ dans le garage.")
                            if IsControlJustReleased(0, 54) then
                                local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false))
                                TriggerServerEvent("sGarage:backVehicle", plate, ESX.Game.GetVehicleProperties(GetVehiclePedIsIn(PlayerPedId(), false)), v.garageId)                            end
                        end
                    end
                else
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~visiter~s~.")
                    if IsControlJustReleased(0, 54) then
                        TriggerServerEvent("sGarage:enter", v.garageId, false)
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

RegisterNetEvent("sGarage:returnEnter")
AddEventHandler("sGarage:returnEnter", function(lastpos, table, owner, infosGarage, vehicles)
    if table == nil then return end
    onGarage = true

    local currentVehicles = {}
    FreezeEntityPosition(PlayerPedId(), true)
    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do
        Wait(1)
    end
    local co = table.entry
    SetEntityCoords(PlayerPedId(), co.pos, false, false, false, false)
    SetEntityHeading(PlayerPedId(), co.heading)
    for k, v in pairs(vehicles) do
        local model = v.props.model
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(1)
        end
        local coV = table.places[k]
        if coV == nil then return ESX.ShowNotification("~r~Erreur~s~~n~Veuillez contacter un développeur !") end
        local vehicle = CreateVehicle(model, coV.pos, coV.heading, false, false)
        ESX.Game.SetVehicleProperties(vehicle, v.props)
        TriggerEvent('persistent-vehicles/update-vehicle', vehicle)
        SetVehicleUndriveable(vehicle, true)
        currentVehicles[k] = vehicle
    end
    Wait(250)
    DoScreenFadeIn(800)
    FreezeEntityPosition(PlayerPedId(), false)

    CreateThread(function()

        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end

        while onGarage do
            local nofps = false
            local pCoords = GetEntityCoords(PlayerPedId())

            if owner and #(pCoords-table.manager) < 1.25 then
                nofps = true
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~gérer vos véhicules~s~.")
                if IsControlJustReleased(0, 54) then
                    openManagementVehicle(vehicles)
                end
            end

            if #(pCoords-table.entry.pos) < 1.0 then
                nofps = true
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~sortir du garage~s~.")
                if IsControlJustReleased(0, 54) then
                    stopVeh = false
                    onGarage = false
                end
            end

            if owner and IsPedInAnyVehicle(PlayerPedId(), false) then
                nofps = true
                local vehProps = ESX.Game.GetVehicleProperties(GetVehiclePedIsIn(PlayerPedId()))
                for k, v in pairs(vehicles) do

                    local plateVerif = string.gsub(v.plate, "%s+", "")
                    local plateBonne = string.gsub(vehProps.plate, "%s+", "")

                    if plateVerif == plateBonne then
                        TriggerServerEvent("sGarage:outWithVeh", v.plate, v.props, infosGarage.garageId)
                        stopVeh = true
                        onGarage = false
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
    
    while onGarage do
        Wait(150)
    end
        
    SetTimeout(2500, function()
        for k, v in pairs(currentVehicles) do
            if DoesEntityExist(v) then
                TriggerEvent('persistent-vehicles/forget-vehicle', v)
                DeleteEntity(v)
                DeleteVehicle(v)
            end
        end
    end)

    FreezeEntityPosition(PlayerPedId(), true)
    DoScreenFadeOut(750)
    Wait(750)
    Wait(750)
    SetCanAttackFriendly(PlayerPedId(), true, false)
    SetEntityCoords(PlayerPedId(), lastpos, false, false, false, false)
    SetEntityInvincible(PlayerPedId(), false)
    DoScreenFadeIn(750)
    FreezeEntityPosition(PlayerPedId(), false)
    TriggerServerEvent("sGarage:exitGarage", infosGarage.garageId)

end)

RegisterNetEvent("sGarage:addRequestAttribute")
AddEventHandler("sGarage:addRequestAttribute", function(request, price)

    RageUI.PopupChar({
		message = "Paiement d'un garage le prix : "..price.."~g~$~s~\n~g~B~s~ accepter ou ~r~G~s~ pour décliner.",
		picture = "CHAR_CHAT_CALL",
		title = "Garage",
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

RegisterNetEvent("sGarage:returnInvitePlayer")
AddEventHandler("sGarage:returnInvitePlayer", function(name, r)

    RageUI.PopupChar({
		message = "La personne ~b~"..name.."~s~ veut se faire inviter\n\n~b~B~s~ Accepter. | ~r~G~s~ Décliner.",
		picture = "CHAR_CHAT_CALL",
		title = "~o~Garage~s~",
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
				InProgress = true
				count = 0
                TriggerServerEvent("sGarage:returnCbInvite", r, InProgress)
			elseif IsControlPressed(0, 58) then
				RageUI.Popup({message="~r~Vous avez décliner l'invitation"})
				InProgress = false
				count = 0
                TriggerServerEvent("sGarage:returnCbInvite", r, InProgress)
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

RegisterNetEvent("sGarage:backVeh")
AddEventHandler("sGarage:backVeh", function()
    DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false))
end)

RegisterNetEvent("sGarage:outVehicle")
AddEventHandler("sGarage:outVehicle", function(table, props)

    local nicePos = vector3(table.pos.x, table.pos.y, table.pos.z)

    waiting = true
    SetCanAttackFriendly(PlayerPedId(), true, false)
    SetEntityCoords(PlayerPedId(), nicePos, false, false, false, false)
    SetEntityInvincible(PlayerPedId(), false)
    DoScreenFadeIn(750)
    FreezeEntityPosition(PlayerPedId(), false)
    waiting = false
    while waiting do
        Wait(50)
    end

    ESX.ShowNotification("~b~Information~s~~n~Vous venez de sortir avec votre véhicule ~o~"..GetLabelText(GetDisplayNameFromVehicleModel(props.model)).."~s~ ["..props.plate.."] !")
    RequestModel(props.model)
    while not HasModelLoaded(props.model) do Wait(1) end

    local vehicle = CreateVehicle(props.model, nicePos, GetEntityHeading(PlayerPedId()), true, true)
    while IsVehicleVisible(vehicle) ~= false do
        Wait(50)
    end

    ESX.Game.SetVehicleProperties(vehicle, props)
    TriggerEvent('persistent-vehicles/update-vehicle', vehicle)
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)

end)