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

RegisterNetEvent('announce:yellowjack')
AddEventHandler('announce:yellowjack', function(announce)
    if announce == 'ouvert' then
        ESX.ShowAdvancedNotification('YellowJack', '~y~Informations', "- YellowJack ~g~ouvert~s~~n~- Horaire : ~g~Maintenant", "CHAR_YELLOWJACK", 1)
    elseif announce == 'fermeture' then
        ESX.ShowAdvancedNotification('YellowJack', '~y~Informations', "- YellowJack ~r~fermé~s~~n~- Horaire : ~g~Maintenant", "CHAR_YELLOWJACK", 1)
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

local MenuYellowjack = {}
RMenu.Add('yellowjackmenu', 'main', RageUI.CreateMenu("", "~y~Yellowjack", nil, nil,"root_cause","yellowjack"))
RMenu:Get('yellowjackmenu', 'main').EnableMouse = false
RMenu:Get('yellowjackmenu', 'main').Closed = function() MenuYellowjack.Menu = false end

function OpenYellowjackMenu()

    if MenuYellowjack.Menu then
        MenuYellowjack.Menu = false
    else
        MenuYellowjack.Menu = true
        RageUI.Visible(RMenu:Get('yellowjackmenu', 'main'), true)

        Citizen.CreateThread(function()
			while MenuYellowjack.Menu do
                RageUI.IsVisible(RMenu:Get('yellowjackmenu', 'main'), true, false, true, function()
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
                                    SneakyEvent('yellowjack:announce', announce)
                                elseif Index == 2 then
                                    local announce = 'fermeture'
                                    SneakyEvent('yellowjack:announce', announce)
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

function OpenYellowjackActionMenuRageUIMenu()
    local mainMenu = RageUI.CreateMenu("", "~y~YellowJack", 0, 0,"root_cause","yellowjack")

    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

    while mainMenu do
       Wait(1)
       RageUI.IsVisible(mainMenu, true, true, false, function()
            RageUI.Button("Attribuer une facture", nil, {RightLabel = "→"}, true,function(h,a,s)
                if s then
                    RageUI.CloseAll()
                    TriggerEvent("sBill:CreateBill","society_yellowjack")
                end
            end)
       end)

       if not RageUI.Visible(mainMenu) then
           mainMenu = RMenu:DeleteType("menu", true)
       end
    end
end




local Yellowjackpos = {

    PositionAnnonce = {
        {coords = vector3(1987.5930175781,3051.0263671875,47.215179443359-0.9)},
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
        for k,v in pairs(Yellowjackpos.PositionAnnonce) do
            local mPos = #(pCoords-v.coords)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'yellowjack' then
                if not MenuYellowjack.Menu then
                    if mPos <= 10.0 then
                        att = 1
                        if mPos <= 1.5 then
                            DrawMarker(25, v.coords.x, v.coords.y, v.coords.z-0.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 0, 155, 255, 255, 0, false, false, 2, false, false, false, false)
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au annonce")
                            if IsControlJustPressed(0, 51) then
                                OpenYellowjackMenu()
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(att)
    end
end)

local garageyellowjack = {

	garageyellowjack = {
        vehs = {
            {label = "Speedo Yellowjack", veh = "nspeedo", stock = 4},
        },
        pos  = {
            {pos = vector3(2010.9315185547,3055.9384765625,46.832321166992), heading = 59.135},
            {pos = vector3(2013.5881347656,3060.1145019531,46.831279754639), heading = 57.39},
            {pos = vector3(2015.7481689453,3063.423828125,46.831699371338), heading = 57.94},
        },
    },
}

local Yellowjack = {
	PositionGarage = {
        {coords = vector3(2001.6931152344,3051.7907714844,47.21403503418-0.9)},
    },
	PositionDeleteGarage = {
        {coords = vector3(1994.1575927734,3057.3996582031,46.836948394775-0.9)},
    },
}

GarageYellowJack = {}
RMenu.Add('garageyellowjack', 'main', RageUI.CreateMenu("", "",nil,nil,"root_cause","yellowjack"))
RMenu:Get('garageyellowjack', 'main'):SetSubtitle("~y~Yellowjack~s~")
RMenu:Get('garageyellowjack', 'main').EnableMouse = false
RMenu:Get('garageyellowjack', 'main').Closed = function()
    GarageYellowJack.Menu = false
end

function OpenGarageYellowJackRageUIMenu()

    if GarageYellowJack.Menu then
        GarageYellowJack.Menu = false
    else
        GarageYellowJack.Menu = true
        RageUI.Visible(RMenu:Get('garageyellowjack', 'main'), true)

        Citizen.CreateThread(function()
            while GarageYellowJack.Menu do
                RageUI.IsVisible(RMenu:Get('garageyellowjack', 'main'), true, false, true, function()
                    RageUI.Separator("~g~↓~s~ Véhicule de service ~g~↓~s~")
                    for k,v in pairs(garageyellowjack.garageyellowjack.vehs) do
                        RageUI.Button(v.label, nil, {RightLabel = "Stock: [~b~"..v.stock.."~s~]"}, v.stock > 0, function(h,a,s)
                            if s then
                                local pos = FoundClearSpawnPoint(garageyellowjack.garageyellowjack.pos)
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
                                    ShowLoadingMessageYellowjack("Véhicule de service sortie.", 2, 2000)
                                    SneakyEvent('Sneakyesx_vehiclelock:givekey', 'no', GetVehicleNumberPlateText(veh))
                                    TriggerEvent('persistent-vehicles/register-vehicle', veh)
                                    garageyellowjack.garageyellowjack.vehs[k].stock = garageyellowjack.garageyellowjack.vehs[k].stock - 1
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

function ShowLoadingMessageYellowjack(text, spinnerType, timeMs)
	Citizen.CreateThread(function()
		BeginTextCommandBusyspinnerOn("STRING")
		AddTextComponentSubstringPlayerName(text)
		EndTextCommandBusyspinnerOn(spinnerType)
		Wait(timeMs)
		RemoveLoadingPrompt()
	end)
end

function DelVehYellowjack()
	local pPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(pPed, false) then
		local pVeh = GetVehiclePedIsIn(pPed, false)
		local model = GetEntityModel(pVeh)
		Citizen.CreateThread(function()
			ShowLoadingMessageYellowjack("Rangement du véhicule ...", 1, 2500)
		end)
		local vehicle = GetVehiclePedIsIn(PlayerPedId(),  false)
        local plate = GetVehicleNumberPlateText(vehicle)
        SneakyEvent('Sneakyesx_vehiclelock:deletekeyjobs', 'no', plate)
		TaskLeaveAnyVehicle(pPed, 1, 1)
		Wait(2500)
		while IsPedInAnyVehicle(pPed, false) do
			TaskLeaveAnyVehicle(pPed, 1, 1)
			ShowLoadingMessageYellowjack("Rangement du véhicule ...", 1, 300)
			Wait(200)
		end
        TriggerEvent('persistent-vehicles/forget-vehicle', pVeh)
	    DeleteEntity(pVeh)
		for k,v in pairs(garageyellowjack.garageyellowjack.vehs) do
			if model == GetHashKey(v.veh) then
				garageyellowjack.garageyellowjack.vehs[k].stock = garageyellowjack.garageyellowjack.vehs[k].stock + 1
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
        for k,v in pairs(Yellowjack.PositionGarage) do
            local mPos = #(v.coords-pCoords)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'yellowjack' then
                if not GarageYellowJack.Menu then
                    if mPos <= 10.0 then
                        att = 1
                        
                        if mPos <= 1.5 then
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au Garage")
                            if IsControlJustPressed(0, 51) then
                                if onService then
                                    OpenGarageYellowJackRageUIMenu()
                                else
                                    ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
                                end
                            end
                        end
                    end
                end
            end
        end
		for k,v in pairs(Yellowjack.PositionDeleteGarage) do
            local mPos = #(v.coords-pCoords)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'yellowjack' then
                if not GarageYellowJack.Menu then
                    if IsPedInAnyVehicle(PlayerPedId(), true) then
                        if mPos <= 10.0 then
                            att = 1
                            if mPos <= 3.5 then
                                DrawMarker(20, v.coords.x, v.coords.y, v.coords.z+0.9, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255, 0, 0, 255, 55555, false, true, 2, false, false, false, false)
                                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule de service")
                                if IsControlJustPressed(0, 51) then
                                    if onService then
                                        DelVehYellowjack()
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

function CheckServiceYellowJack()
    return onService
end
