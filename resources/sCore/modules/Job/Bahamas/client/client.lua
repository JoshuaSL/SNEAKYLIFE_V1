ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
		TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
         Citizen.Wait(10)
   end
   if ESX.IsPlayerLoaded() then
         ESX.PlayerData = ESX.GetPlayerData()
   end
end)
local onService = false
SneakyEvent = TriggerServerEvent
RegisterNetEvent('Sneakyesx:playerLoaded')
AddEventHandler('Sneakyesx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)
RegisterNetEvent('Sneakyesx:setJob')
AddEventHandler('Sneakyesx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent('announce:bahamas')
AddEventHandler('announce:bahamas', function(announce)
    if announce == 'ouvert' then
        ESX.ShowAdvancedNotification('Bahamas Mamas', '~p~Informations', "- Bahamas Mamas ~g~ouvert~s~~n~- Horaire : ~g~Maintenant", "CHAR_BAHAMAS", 1)
    elseif announce == 'fermeture' then
        ESX.ShowAdvancedNotification('Bahamas Mamas', '~p~Informations', "- Bahamas Mamas ~r~fermé~s~~n~- Horaire : ~g~Maintenant", "CHAR_BAHAMAS", 1)
    end
end)


function ShowHelpNotification(msg)
    AddTextEntry('HelpNotification', msg)
	BeginTextCommandDisplayHelp('HelpNotification')
    EndTextCommandDisplayHelp(0, false, true, -1)
end

local ActionsAnnonce = {
    "~b~Ouverture~s~",
    "~b~Fermeture~s~"
}
local ActionsAnnonceIndex = 1

local MenuBahamas = {}
RMenu.Add('bahamasmenu', 'main', RageUI.CreateMenu("", "Bahamas ~p~Mamas", nil, nil,"root_cause","bahamas"))
RMenu:Get('bahamasmenu', 'main').EnableMouse = false
RMenu:Get('bahamasmenu', 'main').Closed = function() MenuBahamas.Menu = false end

function OpenBahamasMenu()

    if MenuBahamas.Menu then
        MenuBahamas.Menu = false
    else
        MenuBahamas.Menu = true
        RageUI.Visible(RMenu:Get('bahamasmenu', 'main'), true)

        Citizen.CreateThread(function()
			while MenuBahamas.Menu do
                RageUI.IsVisible(RMenu:Get('bahamasmenu', 'main'), true, false, true, function()
                    if onService then
                        RageUI.Button("Stopper son ~r~service", nil, {RightLabel = "→"}, onService, function(h,a,s)
                            if s then
                                onService = false
                            end
                        end)
                        RageUI.List("Annonce", ActionsAnnonce, ActionsAnnonceIndex, nil, {}, true, function(Hovered, Active, Selected, Index) 
                            if (Selected) then 
                                if Index == 1 then 
                                    local announce = 'ouvert'
                                    SneakyEvent('bahamas:announce', announce)
                                elseif Index == 2 then
                                    local announce = 'fermeture'
                                    SneakyEvent('bahamas:announce', announce)
                                end 
                            end 
                            ActionsAnnonceIndex = Index 
                        end)
                    else
                        RageUI.Button("Prendre son ~g~service", nil, {RightLabel = "→"}, not onService, function(h,a,s)
                            if s then
                                onService = true
                            end
                        end)
                    end
                end)
				Wait(0)
			end
		end)
	end
end

function OpenBahamasActionMenuRageUIMenu()
    local mainMenu = RageUI.CreateMenu("", "Bahamas ~p~Mamas", 0, 0,"root_cause","bahamas")

    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

    while mainMenu do
       Wait(1)
       RageUI.IsVisible(mainMenu, true, true, false, function()
            RageUI.Button("Attribuer une facture", nil, {RightLabel = "→"}, true,function(h,a,s)
                if s then
                    RageUI.CloseAll()
                    TriggerEvent("sBill:CreateBill","society_bahamas")
                end
            end)
       end)

       if not RageUI.Visible(mainMenu) then
           mainMenu = RMenu:DeleteType("menu", true)
       end
    end
end




local BahamasPos = {

    PositionAnnonce = {
        {coords = vector3(-1389.7717285156,-607.82708740234,30.319543838501-0.9)},
    },
}


Citizen.CreateThread(function()
    while ESX == nil do
		TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
    while true do
        att = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs(BahamasPos.PositionAnnonce) do
            local mPos = #(pCoords-v.coords)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'bahamas' then
                if not MenuBahamas.Menu then
                    if mPos <= 10.0 then
                        att = 1
                        if mPos <= 1.5 then
                            DrawMarker(25, v.coords.x, v.coords.y, v.coords.z-0.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 0, 155, 255, 255, 0, false, false, 2, false, false, false, false)
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au annonce")
                            if IsControlJustPressed(0, 51) then
                                OpenBahamasMenu()
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(att)
    end
end)

local garagebahamas = {

	garagebahamas = {
        vehs = {
            {label = "Limousine", veh = "stretch", stock = 2},
            {label = "Limousine Hummer", veh = "patriot2", stock = 1},
        },
        pos  = {
            {pos = vector3(-1395.6231689453,-582.91027832031,29.90877532959), heading = 299.700},
        },
    },
}

local Bahamas = {
	PositionGarage = {
        {coords = vector3(-1391.2854003906,-587.80651855469,30.242715835571-0.9)},
    },
	PositionDeleteGarage = {
        {coords = vector3(-1395.6231689453,-582.91003417969,29.90736579895-0.9)},
    },
}

GarageBahamas = {}
RMenu.Add('garagebahamas', 'main', RageUI.CreateMenu("", "",nil,nil,"root_cause","bahamas"))
RMenu:Get('garagebahamas', 'main'):SetSubtitle("Bahamas ~p~Mamas")
RMenu:Get('garagebahamas', 'main').EnableMouse = false
RMenu:Get('garagebahamas', 'main').Closed = function()
    GarageBahamas.Menu = false
end

function OpenGarageBahamasRageUIMenu()

    if GarageBahamas.Menu then
        GarageBahamas.Menu = false
    else
        GarageBahamas.Menu = true
        RageUI.Visible(RMenu:Get('garagebahamas', 'main'), true)

        Citizen.CreateThread(function()
            while GarageBahamas.Menu do
                RageUI.IsVisible(RMenu:Get('garagebahamas', 'main'), true, false, true, function()
                    RageUI.Separator("~g~↓~s~ Véhicule de service ~g~↓~s~")
                    for k,v in pairs(garagebahamas.garagebahamas.vehs) do
                        RageUI.Button(v.label, nil, {RightLabel = "Stock: [~b~"..v.stock.."~s~]"}, v.stock > 0, function(h,a,s)
                            if s then
                                local pos = FoundClearSpawnPoint(garagebahamas.garagebahamas.pos)
                                if pos ~= false then
                                    LoadModel(v.veh)
                                    local veh = CreateVehicle(GetHashKey(v.veh), pos.pos, pos.heading, true, false)
                                    SetVehicleLivery(veh, 14)
                                    local chance = math.random(1,2)
                                    if chance == 1 then
                                        SetVehicleColours(veh,111,111)
                                    else
                                        SetVehicleColours(veh,89,89)
                                    end
                                    SetEntityAsMissionEntity(veh, 1, 1)
                                    SetVehicleDirtLevel(veh, 0.0)
                                    ShowLoadingMessageBahamas("Véhicule de service sortie.", 2, 2000)
                                    SneakyEvent('Sneakyesx_vehiclelock:givekey', 'no', GetVehicleNumberPlateText(veh))
                                    TriggerEvent('persistent-vehicles/register-vehicle', veh)
                                    garagebahamas.garagebahamas.vehs[k].stock = garagebahamas.garagebahamas.vehs[k].stock - 1
                                    Wait(350)
                                else
                                    ESX.ShowNotification("Aucun point de sortie disponible")
                                end
                            end
                        end)
                    end
                end)
				Wait(0)
			end
		end)
	end
end

function ShowLoadingMessageBahamas(text, spinnerType, timeMs)
	Citizen.CreateThread(function()
		BeginTextCommandBusyspinnerOn("STRING")
		AddTextComponentSubstringPlayerName(text)
		EndTextCommandBusyspinnerOn(spinnerType)
		Wait(timeMs)
		RemoveLoadingPrompt()
	end)
end

function DelVehBahamas()
	local pPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(pPed, false) then
		local pVeh = GetVehiclePedIsIn(pPed, false)
		local model = GetEntityModel(pVeh)
		Citizen.CreateThread(function()
			ShowLoadingMessageBahamas("Rangement du véhicule ...", 1, 2500)
		end)
		local vehicle = GetVehiclePedIsIn(PlayerPedId(),  false)
        local plate = GetVehicleNumberPlateText(vehicle)
        SneakyEvent('Sneakyesx_vehiclelock:deletekeyjobs', 'no', plate)
		TaskLeaveAnyVehicle(pPed, 1, 1)
		Wait(2500)
		while IsPedInAnyVehicle(pPed, false) do
			TaskLeaveAnyVehicle(pPed, 1, 1)
			ShowLoadingMessageBahamas("Rangement du véhicule ...", 1, 300)
			Wait(200)
		end
        TriggerEvent('persistent-vehicles/forget-vehicle', pVeh)
	    DeleteEntity(pVeh)
		for k,v in pairs(garagebahamas.garagebahamas.vehs) do
			if model == GetHashKey(v.veh) then
				garagebahamas.garagebahamas.vehs[k].stock = garagebahamas.garagebahamas.vehs[k].stock + 1
			end
		end
	else
		ShowNotification("Vous devez être dans un véhicule.")
	end
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while true do
        att = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs(Bahamas.PositionGarage) do
            local mPos = #(v.coords-pCoords)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'bahamas' then
                if not GarageBahamas.Menu then
                    if mPos <= 10.0 then
                        att = 1
                        
                        if mPos <= 1.5 then
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au Garage")
                            if IsControlJustPressed(0, 51) then
                                if onService then
                                    OpenGarageBahamasRageUIMenu()
                                else
                                    ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
                                end
                            end
                        end
                    end
                end
            end
        end
		for k,v in pairs(Bahamas.PositionDeleteGarage) do
            local mPos = #(v.coords-pCoords)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'bahamas' then
                if not GarageBahamas.Menu then
                    if IsPedInAnyVehicle(PlayerPedId(), true) then
                        if mPos <= 10.0 then
                            att = 1
                            if mPos <= 3.5 then
                                DrawMarker(20, v.coords.x, v.coords.y, v.coords.z+0.9, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255, 0, 0, 255, 55555, false, true, 2, false, false, false, false)
                                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule de service")
                                if IsControlJustPressed(0, 51) then
                                    if onService then
                                        DelVehBahamas()
                                    else
                                        ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(att)
    end
end)

function CheckServiceBahamas()
    return onService
end


Citizen.CreateThread(function()
    while ESX == nil do
		TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while true do
        att = 500
        local pCoords = GetEntityCoords(PlayerPedId(), false)
        local pPed = PlayerPedId()
        if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'bahamas' then
            if #(pCoords-vector3(-1389.2504882812,-592.14727783203,30.319570541382)) < 2.0 then
                att = 1
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~p~aller~s~ au bar.")
                if IsControlJustPressed(0, 51) then
                    SetEntityCoordsNoOffset(PlayerPedId(),-1385.1363525391,-606.46838378906,30.31954574585)
                    SetEntityHeading(PlayerPedId(), 124.51)
                end
            end
            if #(pCoords-vector3(-1385.1645507812,-606.48913574219,30.31954574585)) < 2.0 then
                att = 1
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~p~sortir~s~ du bar.")
                if IsControlJustPressed(0, 51) then
                    SetEntityCoordsNoOffset(PlayerPedId(),-1389.3432617188,-591.91357421875,30.319568634033)
                    SetEntityHeading(PlayerPedId(), 31.44)
                end
            end
            if #(pCoords-vector3(-1386.2307128906,-627.435546875,30.819561004639)) < 2.0 then
                att = 1
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~p~aller~s~ au bar.")
                if IsControlJustPressed(0, 51) then
                    SetEntityCoordsNoOffset(PlayerPedId(),-1372.4232177734,-626.39758300781,30.819570541382)
                    SetEntityHeading(PlayerPedId(), 114.9)
                end
            end
            if #(pCoords-vector3(-1372.4232177734,-626.39758300781,30.819570541382)) < 2.0 then
                att = 1
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~p~sortir~s~ du bar.")
                if IsControlJustPressed(0, 51) then
                    SetEntityCoordsNoOffset(PlayerPedId(),-1386.2307128906,-627.435546875,30.819561004639)
                    SetEntityHeading(PlayerPedId(), 308.354)
                end
            end
        end
        Citizen.Wait(att)
    end
end)