ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
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
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent('announce:noodlee')
AddEventHandler('announce:noodlee', function(announce)
    if announce == 'ouvert' then
        ESX.ShowAdvancedNotification('Noodle Exchange', '~y~Informations', "- Noodle Exchange ~g~ouvert~s~~n~- Horaire : ~g~Maintenant", "CHAR_NOODLE", 1)
    elseif announce == 'fermeture' then
        ESX.ShowAdvancedNotification('Noodle Exchange', '~y~Informations', "- Noodle Exchange ~r~fermé~s~~n~- Horaire : ~g~Maintenant", "CHAR_NOODLE", 1)
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

local MenuNoodle = {}
RMenu.Add('noodlemenu', 'main', RageUI.CreateMenu("", "~y~Noodle", nil, nil,"root_cause","noodle"))
RMenu:Get('noodlemenu', 'main').EnableMouse = false
RMenu:Get('noodlemenu', 'main').Closed = function() MenuNoodle.Menu = false end

function OpenNoodleMenu()

    if MenuNoodle.Menu then
        MenuNoodle.Menu = false
    else
        MenuNoodle.Menu = true
        RageUI.Visible(RMenu:Get('noodlemenu', 'main'), true)

        Citizen.CreateThread(function()
			while MenuNoodle.Menu do
                RageUI.IsVisible(RMenu:Get('noodlemenu', 'main'), true, false, true, function()
                    if onService then
                        RageUI.Button("Stopper son ~r~service", nil, {RightLabel = "→"}, onService, function(h,a,s)
                            if s then
                                onService = false
                            end
                        end)
                        RageUI.List("Annonce", ActionsAnnonce, ActionsAnnonceIndex, nil, {}, onService, function(Hovered, Active, Selected, Index) 
                            if (Selected) then 
                                if Index == 1 then 
                                    local announce = 'ouvert'
                                    SneakyEvent('noodle:announce', announce)
                                elseif Index == 2 then
                                    local announce = 'fermeture'
                                    SneakyEvent('noodle:announce', announce)
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

function OpenNoodleActionMenuRageUIMenu()
    local mainMenu = RageUI.CreateMenu("", "~y~Noodle Exchange", 0, 0,"root_cause","noodle")

    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

    while mainMenu do
       Wait(1)
       RageUI.IsVisible(mainMenu, true, true, false, function()
            RageUI.Button("Attribuer une facture", nil, {RightLabel = "→"}, true,function(h,a,s)
                if s then
                    RageUI.CloseAll()
                    TriggerEvent("sBill:CreateBill","society_noodle")
                end
            end)
       end)

       if not RageUI.Visible(mainMenu) then
           mainMenu = RMenu:DeleteType("menu", true)
       end
    end
end




local Noodlepos = {

    PositionAnnonce = {
        {coords = vector3(-1184.2305908203,-1149.7867431641,7.6686658859253-0.9)},
    },
}


Citizen.CreateThread(function()
    while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
    while true do
        att = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs(Noodlepos.PositionAnnonce) do
            local mPos = #(pCoords-v.coords)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'noodle' then
                if not MenuNoodle.Menu then
                    if mPos <= 10.0 then
                        att = 1
                        if mPos <= 1.5 then
                            DrawMarker(25, v.coords.x, v.coords.y, v.coords.z-0.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 0, 155, 255, 255, 0, false, false, 2, false, false, false, false)
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au annonce")
                            if IsControlJustPressed(0, 51) then
                                OpenNoodleMenu()
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(att)
    end
end)

local garagenoodle = {

	garagenoodle = {
        vehs = {
            {label = "Voiture noodle", veh = "foodcar2", stock = 3},
            {label = "Scooter noodle", veh = "foodbike", stock = 3},
        },
        pos  = {
            {pos = vector3(-1206.25,-1163.9765625,7.4045581817627), heading = 12.55},
        },
    },
}

local NoodlePos = {
	PositionGarage = {
        {coords = vector3(-1201.8037109375,-1157.91796875,7.7238712310791-0.9)},
    },
	PositionDeleteGarage = {
        {coords = vector3(-1206.25,-1163.9765625,7.4045581817627-0.9)},
    },
}

GarageNoodle = {}
RMenu.Add('garagenoodle', 'main', RageUI.CreateMenu("", "",nil,nil,"root_cause","noodle"))
RMenu:Get('garagenoodle', 'main'):SetSubtitle("~o~Noodle Exchange~s~")
RMenu:Get('garagenoodle', 'main').EnableMouse = false
RMenu:Get('garagenoodle', 'main').Closed = function()
    GarageNoodle.Menu = false
end

function OpenGarageNoodleRageUIMenu()

    if GarageNoodle.Menu then
        GarageNoodle.Menu = false
    else
        GarageNoodle.Menu = true
        RageUI.Visible(RMenu:Get('garagenoodle', 'main'), true)

        Citizen.CreateThread(function()
            while GarageNoodle.Menu do
                RageUI.IsVisible(RMenu:Get('garagenoodle', 'main'), true, false, true, function()
                    RageUI.Separator("~o~↓~s~ Véhicule de service ~o~↓~s~")
                    for k,v in pairs(garagenoodle.garagenoodle.vehs) do
                        RageUI.Button(v.label, nil, {RightLabel = "Stock: (~o~"..v.stock.."~s~)"}, v.stock > 0, function(h,a,s)
                            if s then
                                local pos = FoundClearSpawnPoint(garagenoodle.garagenoodle.pos)
                                if pos ~= false then
                                    LoadModel(v.veh)
                                    local veh = CreateVehicle(GetHashKey(v.veh), pos.pos, pos.heading, true, false)
                                    SetVehicleLivery(veh, 15)
                                    local chance = math.random(1,2)
                                    if chance == 1 then
                                        SetVehicleColours(veh,111,111)
                                    else
                                        SetVehicleColours(veh,89,89)
                                    end
                                    SetEntityAsMissionEntity(veh, 1, 1)
                                    SetVehicleDirtLevel(veh, 0.0)
                                    ShowLoadingMessageNoodle("Véhicule de service sortie.", 2, 2000)
                                    SneakyEvent('Sneakyesx_vehiclelock:givekey', 'no', GetVehicleNumberPlateText(veh))
                                    TriggerEvent('persistent-vehicles/register-vehicle', veh)
                                    garagenoodle.garagenoodle.vehs[k].stock = garagenoodle.garagenoodle.vehs[k].stock - 1
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

function ShowLoadingMessageNoodle(text, spinnerType, timeMs)
	Citizen.CreateThread(function()
		BeginTextCommandBusyspinnerOn("STRING")
		AddTextComponentSubstringPlayerName(text)
		EndTextCommandBusyspinnerOn(spinnerType)
		Wait(timeMs)
		RemoveLoadingPrompt()
	end)
end

function DelVehNoodle()
	local pPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(pPed, false) then
		local pVeh = GetVehiclePedIsIn(pPed, false)
		local model = GetEntityModel(pVeh)
		Citizen.CreateThread(function()
			ShowLoadingMessageNoodle("Rangement du véhicule ...", 1, 2500)
		end)
		local vehicle = GetVehiclePedIsIn(PlayerPedId(),  false)
        local plate = GetVehicleNumberPlateText(vehicle)
        SneakyEvent('Sneakyesx_vehiclelock:deletekeyjobs', 'no', plate)
		TaskLeaveAnyVehicle(pPed, 1, 1)
		Wait(2500)
		while IsPedInAnyVehicle(pPed, false) do
			TaskLeaveAnyVehicle(pPed, 1, 1)
			ShowLoadingMessageNoodle("Rangement du véhicule ...", 1, 300)
			Wait(200)
		end
        TriggerEvent('persistent-vehicles/forget-vehicle', pVeh)
	    DeleteEntity(pVeh)
		for k,v in pairs(garagenoodle.garagenoodle.vehs) do
			if model == GetHashKey(v.veh) then
				garagenoodle.garagenoodle.vehs[k].stock = garagenoodle.garagenoodle.vehs[k].stock + 1
			end
		end
	else
		ShowNotification("Vous devez être dans un véhicule.")
	end
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while true do
        att = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs(NoodlePos.PositionGarage) do
            local mPos = #(v.coords-pCoords)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'noodle' then
                if not GarageNoodle.Menu then
                    if mPos <= 10.0 then
                        att = 1
                        
                        if mPos <= 1.5 then
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au ~o~garage~s~.")
                            if IsControlJustPressed(0, 51) then
                                if onService then
                                    OpenGarageNoodleRageUIMenu()
                                else
                                    ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
                                end
                            end
                        end
                    end
                end
            end
        end
		for k,v in pairs(NoodlePos.PositionDeleteGarage) do
            local mPos = #(v.coords-pCoords)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'noodle' then
                if not GarageNoodle.Menu then
                    if IsPedInAnyVehicle(PlayerPedId(), true) then
                        if mPos <= 10.0 then
                            att = 1
                            if mPos <= 3.5 then
                                DrawMarker(20, v.coords.x, v.coords.y, v.coords.z+0.9, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255, 0, 0, 255, 55555, false, true, 2, false, false, false, false)
                                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule de service.")
                                if IsControlJustPressed(0, 51) then
                                    if onService then
                                        DelVehNoodle()
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


function CheckServiceNoodle()
    return onService
end






