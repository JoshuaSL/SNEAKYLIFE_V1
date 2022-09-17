ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
end)
SneakyEvent = TriggerServerEvent

local AutoecoleMenu = {

    {
        pos = vector3(240.61151123047,-1379.4989013672,33.741771697998),
        blip = {
            label = "Auto école", 
            ID = 545, 
            Color = 0
        },
    },
}

local AutoEcole = {}
local Licenses = {}
local question = 0
local question1 = false
local question2 = false
local question3 = false
local question4 = false
local question5 = false
local question6 = false
local question7 = false
local question8 = false
local question9 = false
local question10 = false
local question11 = false
local question12 = false
local question13 = false
local question14 = false
local question15 = false
local question16 = false
local error = 0
local localpermistart = false
local MaxErrors = 5
local SpeedMultiplier = 3.6
local Prices = {
	dmv = 150,
	drive = 750,
	drive_bike = 600,
	drive_truck = 1000
}
local SpeedLimits = {
	residence = 50,
	town = 80,
	freeway = 120
}
local VehicleModels = {
	drive = 'blista',
	drive_bike = 'thrust',
	drive_truck = 'mule3'
}
local Zones = {
	VehicleSpawnPoint = {
		Pos = vector3(249.409, -1407.230, 30.4094),
		Size = vector3(1.5, 1.5, 1.0),
		Color = {r = 255, g = 119, b = 0},
		Type = -1
	}
}

function DrawMissionText(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, 1)
end

local CheckPoints = {
	{
		Pos = vector3(258.25311279297,-1396.8686523438,30.347593307495-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage ! Vitesse limite : ~b~' ..SpeedLimits['residence'] .. 'km/h', 5000)
		end
	},
	{
		Pos = vector3(235.61381530762,-1345.3148193359,30.397048950195-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
	{
		Pos = vector3(217.00117492676,-1411.796875,29.082345962524-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			Citizen.CreateThread(function()
				DrawMissionText('Faite rapidement un ~r~stop~s~ pour le piéton qui ~b~traverse', 5000)
				PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
				FreezeEntityPosition(vehicle, true)
				Citizen.Wait(4000)
				FreezeEntityPosition(vehicle, false)
				DrawMissionText('~g~Bien!~s~ Continuons!', 5000)
			end)
		end
	},
	{
		Pos = vector3(183.71893310547,-1397.4123535156,29.292037963867-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			setCurrentZoneType('town')

			Citizen.CreateThread(function()
				DrawMissionText('Marquer rapidement un ~r~stop~s~ et regardez à votre ~b~gauche~s~. Vitesse limite : ~b~'..SpeedLimits['town'] .. 'km/h', 5000)
				PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
				FreezeEntityPosition(vehicle, true)
				Citizen.Wait(6000)
				FreezeEntityPosition(vehicle, false)
				DrawMissionText('~g~Bien!~s~ Prenez à ~b~droite~s~ et suivez votre file', 5000)
			end)
		end
	},
	{
		Pos = vector3(228.14575195312,-1230.6403808594,29.154365539551-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Observez le traffic ~b~allumez vos feux~s~ !', 5000)
		end
	},
	{
		Pos = vector3(253.48747253418,-967.94555664062,29.158140182495-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
	{
		Pos = vector3(353.87908935547,-685.41748046875,29.159255981445-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Marquez le stop pour laisser passer les véhicules !', 5000)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
			FreezeEntityPosition(vehicle, true)
			Citizen.Wait(6000)
			FreezeEntityPosition(vehicle, false)
		end
	},
	{
		Pos = vector3(510.83700561523,-438.96737670898,30.226638793945-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
	{
		Pos = vector3(745.14093017578,-63.286270141602,57.562614440918-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
	{
		Pos = vector3(1026.9334716797,310.44326782227,83.514839172363-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			setCurrentZoneType('freeway')

			DrawMissionText('Il est temps d\'aller sur la rocade ! Vitesse limite : ~b~' ..SpeedLimits['freeway'] .. 'km/h', 5000)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
		end
	},
	{
		Pos = vector3(1480.2329101562,793.15228271484,76.898742675781-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
	{
		Pos = vector3(1688.5865478516,1301.8911132812,86.272422790527-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
	{
		Pos = vector3(2014.5841064453,1507.8138427734,75.303894042969-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
    {
		Pos = vector3(2341.6530761719,1072.1314697266,80.61572265625-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
    {
		Pos = vector3(2528.7204589844,318.47537231445,109.53538513184-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
 {
		Pos = vector3(2397.8923339844,-238.69960021973,85.197975158691-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
     {
		Pos = vector3(2085.6977539062,-601.03179931641,95.456886291504-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
     {
		Pos = vector3(1341.7247314453,-1089.0533447266,51.871551513672-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
         {
		Pos = vector3(1035.0584716797,-1350.1417236328,33.638000488281-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
	{
		Pos = vector3(1060.4498291016,-1732.2159423828,35.434772491455-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			setCurrentZoneType('town')
			DrawMissionText('Entrée en ville, attention à votre vitesse ! Vitesse limite : ~b~' ..SpeedLimits['town'] .. 'km/h', 5000)
		end
	},
         {
		Pos = vector3(766.09649658203,-1734.90234375,29.307653427124-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Allez vers le prochain passage !', 5000)
		end
	},
	{
		Pos = vector3(376.53546142578,-1547.0297851562,29.081115722656-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText('Bravo, restez vigiliant!', 5000)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
		end
	},
	{
		Pos = vector3(243.82214355469,-1401.1730957031,30.391017913818-0.98),
		Action = function(playerPed, vehicle, setCurrentZoneType)
            TriggerEvent('persistent-vehicles/forget-vehicle', vehicle)
			ESX.Game.DeleteVehicle(vehicle)
		end
	}
}
function ShowHelpNotification(msg)
    AddTextEntry('HelpNotification', msg)
	BeginTextCommandDisplayHelp('HelpNotification')
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function CheckLicenseCode()
    ESX.TriggerServerCallback('Sneakyesx_license:checkLicense', function(hasDmvLicense)
        if hasDmvLicense then
            LicenseOwned = 1
        else
            LicenseOwned = 0
        end
    end, GetPlayerServerId(PlayerId()), 'dmv')
end

function CheckLicensePermisTruck()
    ESX.TriggerServerCallback('Sneakyesx_license:checkLicense', function(hasDrive_TruckLicense)
        if hasDrive_TruckLicense then
            LicenseTruckOwned = 1
        else
            LicenseTruckOwned = 0
        end
    end, GetPlayerServerId(PlayerId()), 'drive_truck')
end

function CheckLicensePermisMoto()
    ESX.TriggerServerCallback('Sneakyesx_license:checkLicense', function(hasDrive_MotoLicense)
        if hasDrive_MotoLicense then
            LicenseMotoOwned = 1
        else
            LicenseMotoOwned = 0
        end
    end, GetPlayerServerId(PlayerId()), 'drive_bike')
end

function CheckLicensePermisVoiture()
    ESX.TriggerServerCallback('Sneakyesx_license:checkLicense', function(hasDrive_CarLicense)
        if hasDrive_CarLicense then
            LicenseVoitureOwned = 1
        else
            LicenseVoitureOwned = 0
        end
    end, GetPlayerServerId(PlayerId()), 'drive')
end

RMenu.Add('autoecole', 'main', RageUI.CreateMenu("", "~b~San Andreas DMV", 10, 200,'root_cause',"shopui_title_sanandreasdmv"))
RMenu.Add('autoecole', 'question1', RageUI.CreateSubMenu(RMenu:Get('autoecole', 'main'), "", "~b~Examen code de la route"))
RMenu:Get('autoecole', 'main').EnableMouse = false
RMenu:Get('autoecole', 'question1').Closable = false
RMenu:Get('autoecole', 'main').Closed = function() AutoEcole.Menu = false end

function OpenAutoEcoleRageUIMenu()

    if AutoEcole.Menu then
        AutoEcole.Menu = false
    else
        AutoEcole.Menu = true
        RageUI.Visible(RMenu:Get('autoecole', 'main'), true)

        Citizen.CreateThread(function()
			while AutoEcole.Menu do
                RageUI.IsVisible(RMenu:Get('autoecole', 'main'), true, false, true, function()
                    if LicenseOwned == 1 then
                        if LicenseMotoOwned ~= 1 then
                            RageUI.Button("Passer le permis moto", nil, { RightBadge = RageUI.BadgeStyle.Bike }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    ESX.TriggerServerCallback('Dmv:buy', function(ok)
                                        if ok then
                                            RageUI.CloseAll()
                                            AutoEcole.Menu = false
                                            StartDriveTest("drive_bike")
                                        else
                                            ESX.ShowNotification("~r~Erreur~s~\nVous n'avez pas assez d'argent")
                                        end
                                    end,600)
                                end
                            end)
                        end
                        if LicenseVoitureOwned ~= 1 then
                            RageUI.Button("Passer le permis voiture", nil, { RightBadge = RageUI.BadgeStyle.Car }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    ESX.TriggerServerCallback('Dmv:buy', function(ok)
                                        if ok then
                                            RageUI.CloseAll()
                                            AutoEcole.Menu = false
                                            StartDriveTest("drive")
                                        else
                                            ESX.ShowNotification("~r~Erreur~s~\nVous n'avez pas assez d'argent")
                                        end
                                    end,750)
                                end
                            end)
                        end
                        if LicenseTruckOwned ~= 1 then
                            RageUI.Button("Passer le permis camion", nil, { RightBadge = RageUI.BadgeStyle.Car }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    ESX.TriggerServerCallback('Dmv:buy', function(ok)
                                        if ok then
                                            RageUI.CloseAll()
                                            AutoEcole.Menu = false
                                            StartDriveTest("drive_truck")
                                        else
                                            ESX.ShowNotification("~r~Erreur~s~\nVous n'avez pas assez d'argent")
                                        end
                                    end,1000)
                                end
                            end)
                        end
                        if LicenseMotoOwned == 1 and LicenseTruckOwned == 1 and LicenseVoitureOwned == 1 then
                            RageUI.Separator("~r~Vous possédez actuellement toutes les formations")
                        end
                    else
                        RageUI.Button("Examen du code", nil, { RightLabel = "~g~300$ ~s~" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                ESX.TriggerServerCallback('Dmv:buy', function(ok)
                                    if ok then
                                        question = 1
                                        RageUI.Visible(RMenu:Get('autoecole', 'question1'),true)
                                    else
                                        ESX.ShowNotification("~r~Erreur~s~\nVous n'avez pas assez d'argent")
                                    end
                                end,300)
                            end
                        end)
                    end
                end)
                RageUI.IsVisible(RMenu:Get('autoecole', 'question1'), true, false, true, function()
                    if question == 1 then
                        RageUI.Separator("Niveau d'alcool dans le sang autorisé ?")
                        RageUI.Checkbox("Réponse 1 : 0.05%", nil, question1,{},function(Hovered,Active,Selected,Checked)
                            question1 = Checked
                            if Checked then
                                question = 2
                                error = 1
                            else
                            end
                        end)
                        RageUI.Checkbox("Réponse 2 : 0.06%", nil, question2,{},function(Hovered,Active,Selected,Checked)
                            question2 = Checked
                            if Checked then
                                question = 2
                                error = 1
                            else
                            end
                        end)
                        RageUI.Checkbox("Réponse 3 : 0.08%", nil, question3,{},function(Hovered,Active,Selected,Checked)
                            question3 = Checked
                            if Checked then
                                question = 2
                            else
                            end
                        end)
                        RageUI.Checkbox("Réponse 4 : 0.10%", nil, question4,{},function(Hovered,Active,Selected,Checked)
                            question4 = Checked
                            if Checked then
                                question = 2
                                error = 1
                            else
                            end
                        end)
                    elseif question == 2 then
                        RageUI.Separator("A quel moment vous pouvez passer aux feux ?")
                        RageUI.Checkbox("Réponse 1 : Quand il est vert", nil, question5,{},function(Hovered,Active,Selected,Checked)
                            question5 = Checked
                            if Checked then
                                question = 3
                            else
                            end
                        end)
                        RageUI.Checkbox("Réponse 2 : Quand il n'y a personne sur l'intersection", nil, question6,{},function(Hovered,Active,Selected,Checked)
                            question6 = Checked
                            if Checked then
                                question = 3
                                error = error + 1
                            else
                            end
                        end)
                        RageUI.Checkbox("Réponse 3 : Vous êtes dans une zone d'école", nil, question7,{},function(Hovered,Active,Selected,Checked)
                            question7 = Checked
                            if Checked then
                                question = 3
                                error = error + 1
                            else
                            end
                        end)
                        RageUI.Checkbox("Réponse 4 : Quand il est rouge", nil, question8,{},function(Hovered,Active,Selected,Checked)
                            question8 = Checked
                            if Checked then
                                question = 3
                                error = error + 1
                            else
                            end
                        end)
                    elseif question == 3 then
                        RageUI.Separator("Vous approchez d'un lieu de résidence")
                        RageUI.Separator("que devez vous faire ?")
                        RageUI.Checkbox("Réponse 1 : Vous devez accélérer", nil, question9,{},function(Hovered,Active,Selected,Checked)
                            question9 = Checked
                            if Checked then
                                question = 4
                                error = error + 1
                            else
                            end
                        end)
                        RageUI.Checkbox("Réponse 2 : Vous pouvez garder votre vitesse", nil, question10,{},function(Hovered,Active,Selected,Checked)
                            question10 = Checked
                            if Checked then
                                question = 4
                                error = error + 1
                            else
                            end
                        end)
                        RageUI.Checkbox("Réponse 3 : Vous devez ralentir", nil, question11,{},function(Hovered,Active,Selected,Checked)
                            question11 = Checked
                            if Checked then
                                question = 4
                            else
                            end
                        end)
                        RageUI.Checkbox("Réponse 4 : Vous devez vous arrêter", nil, question12,{},function(Hovered,Active,Selected,Checked)
                            question12 = Checked
                            if Checked then
                                question = 4
                                error = error + 1
                            else
                            end
                        end)
                    elseif question == 4 then
                        RageUI.Separator("Vous vous apprétez à tourner à droite au feu vert")
                        RageUI.Separator("mais vous voyez un piéton qui traverse ?")
                        RageUI.Checkbox("Réponse 1 : Vous passez avant le piéton", nil, question13,{},function(Hovered,Active,Selected,Checked)
                            question13 = Checked
                            if Checked then
                                question = 5
                                error = error + 1
                            else
                            end
                        end)
                        RageUI.Checkbox("Réponse 2 : Vous l'insultez et vous lui faites un doigt", nil, question14,{},function(Hovered,Active,Selected,Checked)
                            question14 = Checked
                            if Checked then
                                question = 5
                                error = error + 1
                            else
                            end
                        end)
                        RageUI.Checkbox("Réponse 3 : Vous attendez que le piéton est terminé", nil, question15,{},function(Hovered,Active,Selected,Checked)
                            question15 = Checked
                            if Checked then
                                question = 5
                            else
                            end
                        end)
                        RageUI.Checkbox("Réponse 4 : Vous renverser le piéton pour passer", nil, question16,{},function(Hovered,Active,Selected,Checked)
                            question16 = Checked
                            if Checked then
                                question = 5
                                error = error + 1
                            else
                            end
                        end)
                    elseif question == 5 then
                        RageUI.Separator("Un piéton est au feu rouge pour les piétons")
                        RageUI.Checkbox("Réponse 1 : Vous le laissez passer", nil, question13,{},function(Hovered,Active,Selected,Checked)
                            question13 = Checked
                            if Checked then
                                question = 6
                                error = error + 1
                            else
                            end
                        end)
                        RageUI.Checkbox("Réponse 2 : Vous observez avant de continuer", nil, question14,{},function(Hovered,Active,Selected,Checked)
                            question14 = Checked
                            if Checked then
                                question = 6
                                error = error + 1
                            else
                            end
                        end)
                        RageUI.Checkbox("Réponse 3 : Vous lui faite un signe de la main", nil, question15,{},function(Hovered,Active,Selected,Checked)
                            question15 = Checked
                            if Checked then
                                question = 6
                                error = error + 1
                            else
                            end
                        end)
                        RageUI.Checkbox("Réponse 4 : Vous continuez votre chemin car votre feu est vert", nil, question16,{},function(Hovered,Active,Selected,Checked)
                            question16 = Checked
                            if Checked then
                                question = 6
                            else
                            end
                        end)
                    elseif question == 6 then
                        if error > 2 then
                            local resultatexamen = "~r~Raté"
                            RageUI.Button("Résultat de votre examen : "..resultatexamen, nil, { RightLabel = "Recommencer" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    question = 0
                                    question1 = false
                                    question2 = false
                                    question3 = false
                                    question4 = false
                                    question5 = false
                                    question6 = false
                                    question7 = false
                                    question8 = false
                                    question9 = false
                                    question10 = false
                                    question11 = false
                                    question12 = false
                                    question13 = false
                                    question14 = false
                                    question15 = false
                                    question16 = false
                                    error = 0
                                    RageUI.Visible(RMenu:Get('autoecole', 'main'),true)
                                end
                            end)
                        else
                            local resultatexamen = "~g~Réussi"
                            RageUI.Button("Résultat de votre examen : "..resultatexamen, nil, { RightLabel = "Récupérer" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    SneakyEvent("Sneakyesx_dmvschool:addLicense", GetEntityCoords(PlayerPedId()), 'dmv')
                                    ESX.SetTimeout(100, function()
                                        CheckLicenseCode()
                                    end)
                                    RageUI.GoBack()
                                end
                            end)
                        end
                    end

                end)
				Wait(0)
			end
		end)
	end
end

Citizen.CreateThread(function()
    while true do
        att = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs(AutoecoleMenu) do
            local mPos = #(pCoords-v.pos)
            if not AutoEcole.Menu then
                if mPos <= 10.0 then
                    att = 1
                
                    if mPos <= 1.5 then
                        ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour interagir avec la monitrice")
                        if IsControlJustPressed(0, 51) then
                            CheckLicenseCode()
                            CheckLicensePermisTruck()
                            CheckLicensePermisMoto()
                            CheckLicensePermisVoiture()
                            OpenAutoEcoleRageUIMenu()
                        end
                    end
                end
            end
        end
        Citizen.Wait(att)
    end
end)

function StartDriveTest(type)
	ESX.Game.SpawnVehicle(VehicleModels[type], Zones.VehicleSpawnPoint.Pos, 317.0, function(vehicle)
		CurrentTest = 'drive'
		CurrentTestType = type
		CurrentCheckPoint = 0
		LastCheckPoint = -1
		CurrentZoneType = 'residence'
		DriveErrors = 0
		IsAboveSpeedLimit = false
		CurrentVehicle = vehicle
		LastVehicleHealth = GetEntityHealth(vehicle)
		local playerPed = PlayerPedId()
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		SetVehicleNumberPlateText(vehicle, "DMV1")
        local newPlate = GetVehicleNumberPlateText(vehicle)
		SneakyEvent('Sneakyesx_vehiclelock:givekey', 'no', newPlate)
        typekodalegrosfdp = type
        localpermistart = true
        TriggerEvent('persistent-vehicles/register-vehicle', vehicle)
	end)
end

function StopDriveTest(success)
	if success then
        SneakyEvent("Sneakyesx_dmvschool:addLicense", GetEntityCoords(PlayerPedId()), typekodalegrosfdp)
		ESX.ShowNotification('vous avez ~g~réussi~s~ le test.')
	else
		ESX.ShowNotification('vous avez ~r~raté~s~ le test.')
	end

	CurrentTest = nil
	CurrentTestType = nil
end

function SetCurrentZoneType(type)
	CurrentZoneType = type
end

-- Drive test
Citizen.CreateThread(function()
	while true do
        if CurrentTest == nil then
            Wait(850)
        else
            Wait(10)
            if CurrentTest == 'drive' then
                local playerPed = PlayerPedId()
                local coords = GetEntityCoords(playerPed, false)
                local nextCheckPoint = CurrentCheckPoint + 1

                if CheckPoints[nextCheckPoint] == nil then
                    if DoesBlipExist(CurrentBlip) then
                        RemoveBlip(CurrentBlip)
                    end

                    CurrentTest = nil

                    ESX.ShowNotification('Vous avez terminé le test de conduire')

                    if DriveErrors < MaxErrors then
                        StopDriveTest(true)
                        localpermistart = false
                    else
                        StopDriveTest(false)
                        localpermistart = false
                    end
                else
                    if CurrentCheckPoint ~= LastCheckPoint then
                        if DoesBlipExist(CurrentBlip) then
                            RemoveBlip(CurrentBlip)
                        end

                        CurrentBlip = AddBlipForCoord(CheckPoints[nextCheckPoint].Pos.x, CheckPoints[nextCheckPoint].Pos.y, CheckPoints[nextCheckPoint].Pos.z)
                        SetBlipRoute(CurrentBlip, 1)

                        LastCheckPoint = CurrentCheckPoint
                    end

                    local distance = GetDistanceBetweenCoords(coords, CheckPoints[nextCheckPoint].Pos.x, CheckPoints[nextCheckPoint].Pos.y, CheckPoints[nextCheckPoint].Pos.z, true)

                    if distance <= 100.0 then
                        DrawMarker(1, CheckPoints[nextCheckPoint].Pos.x, CheckPoints[nextCheckPoint].Pos.y, CheckPoints[nextCheckPoint].Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 119, 0, 255, false, false, 2, false, false, false, false)
                    end

                    if distance <= 3.0 then
                        CheckPoints[nextCheckPoint].Action(playerPed, CurrentVehicle, SetCurrentZoneType)
                        CurrentCheckPoint = CurrentCheckPoint + 1
                    end
                end
            end
        end
	end
end)

-- Speed / Damage control
Citizen.CreateThread(function()
	while true do
        if CurrentTest == nil then
            Wait(850)
        else
            Wait(10)
            if CurrentTest == 'drive' then
                local playerPed = PlayerPedId()

                if IsPedInAnyVehicle(playerPed, false) then
                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                    local speed = GetEntitySpeed(vehicle) * SpeedMultiplier
                    local tooMuchSpeed = false

                    for k, v in pairs(SpeedLimits) do
                        if CurrentZoneType == k and speed > v then
                            tooMuchSpeed = true

                            if not IsAboveSpeedLimit then
                                DriveErrors = DriveErrors + 1
                                IsAboveSpeedLimit = true

                                ESX.ShowNotification('Vous roulez trop vite, vitesse limite: ~b~'..v..'~s~ km/h!')
                                ESX.ShowNotification('Erreurs : ~r~'..DriveErrors..'~s~/'..MaxErrors)
                            end
                        end
                    end

                    if not tooMuchSpeed then
                        IsAboveSpeedLimit = false
                    end

                    local health = GetEntityHealth(vehicle)

                    if health < LastVehicleHealth then
                        DriveErrors = DriveErrors + 1

                        ESX.ShowNotification('Vous avez endommagé votre véhicule')
                        ESX.ShowNotification('Erreurs : ~r~'..DriveErrors..'~s~/'..MaxErrors)
                        LastVehicleHealth = health
                    end
                end
            end
        end
	end
end)