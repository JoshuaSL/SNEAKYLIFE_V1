Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
end)
pGarage = {}
SneakyEvent = TriggerServerEvent
pGarage.SetVehicleProperties = function(vehicle, vehicleProps)
	ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
	SetVehicleEngineHealth(vehicle, vehicleProps["engineHealth"] and vehicleProps["engineHealth"] + 0.0 or 1000.0)
    SetVehicleBodyHealth(vehicle, vehicleProps["bodyHealth"] and vehicleProps["bodyHealth"] + 0.0 or 1000.0)
    SetVehicleFuelLevel(vehicle, vehicleProps["fuelLevel"] and vehicleProps["fuelLevel"] + 0.0 or 1000.0)

    if vehicleProps["windows"] then
        for windowId = 1, 13, 1 do
            if vehicleProps["windows"][windowId] == false then
                SmashVehicleWindow(vehicle, windowId)
            end
        end
    end
    
    if vehicleProps["interiorcolor"] then
        SetVehicleInteriorColour(vehicle,vehicleProps["interiorcolor"])
    end

    if vehicleProps["tyres"] then
        for tyreId = 1, 7, 1 do
            if vehicleProps["tyres"][tyreId] ~= false then
                SetVehicleTyreBurst(vehicle, tyreId, true, 1000)
            end
        end
    end

    if vehicleProps["doors"] then
        for doorId = 0, 5, 1 do
            if vehicleProps["doors"][doorId] ~= false then
                SetVehicleDoorBroken(vehicle, doorId - 1, true)
            end
        end
    end
end

Citizen.CreateThread(function()
    local PlayerIdP = GetPlayerServerId(PlayerId())
    while true do
        AddTextEntry('PM_PANE_KEYS', '~b~Configuration des touches')
        AddTextEntry('PM_PANE_AUD', 'Audio et son')
        AddTextEntry('PM_PANE_GTAO', 'GTA 5 Online')
        AddTextEntry('PM_PANE_CFX', '~b~Sneaky~s~Life')

        Citizen.Wait(60000)
    end
end)

pGarage.GetVehicleProperties = function(vehicle)
    if DoesEntityExist(vehicle) then
        local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

        vehicleProps["tyres"] = {}
        vehicleProps["windows"] = {}
        vehicleProps["doors"] = {}

        for id = 1, 7 do
            local tyreId = IsVehicleTyreBurst(vehicle, id, false)
        
            if tyreId then
                vehicleProps["tyres"][#vehicleProps["tyres"] + 1] = tyreId
        
                if tyreId == false then
                    tyreId = IsVehicleTyreBurst(vehicle, id, true)
                    vehicleProps["tyres"][ #vehicleProps["tyres"]] = tyreId
                end
            else
                vehicleProps["tyres"][#vehicleProps["tyres"] + 1] = false
            end
        end

        for id = 1, 13 do
            local windowId = IsVehicleWindowIntact(vehicle, id)

            if windowId ~= nil then
                vehicleProps["windows"][#vehicleProps["windows"] + 1] = windowId
            else
                vehicleProps["windows"][#vehicleProps["windows"] + 1] = true
            end
        end
        
        for id = 0, 5 do
            local doorId = IsVehicleDoorDamaged(vehicle, id)
        
            if doorId then
                vehicleProps["doors"][#vehicleProps["doors"] + 1] = doorId
            else
                vehicleProps["doors"][#vehicleProps["doors"] + 1] = false
            end
        end

        vehicleProps["engineHealth"] = GetVehicleEngineHealth(vehicle)
        vehicleProps["bodyHealth"] = GetVehicleBodyHealth(vehicle)
        vehicleProps["fuelLevel"] = GetVehicleFuelLevel(vehicle)

        return vehicleProps
    end
end

function ShowHelpNotification(msg)
    AddTextEntry('HelpNotification', msg)
	BeginTextCommandDisplayHelp('HelpNotification')
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
	AddTextEntry(entryTitle, textEntry)
	DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)

	while (UpdateOnscreenKeyboard() ~= 1) and (UpdateOnscreenKeyboard() ~= 2) do
		DisableAllControlActions(0)
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		return GetOnscreenKeyboardResult()
	else
		return nil
	end
end

-- Generate pate

local NumberCharset = {}
local Charset = {}
local PlateLetters  = 3
local PlateNumbers  = 3
local PlateUseSpace = true

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GeneratePlate()
	local generatedPlate
	local doBreak = false

	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())
		if PlateUseSpace then
			generatedPlate = string.upper(GetRandomLetter(PlateLetters) .. ' ' .. GetRandomNumber(PlateNumbers))
		else
			generatedPlate = string.upper(GetRandomLetter(PlateLetters) .. GetRandomNumber(PlateNumbers))
		end

		ESX.TriggerServerCallback('pGarage:GetAllPlate', function(isPlateTaken)
			if not isPlateTaken then
				doBreak = true
			end
		end, generatedPlate)

		if doBreak then
			break
		end
	end

	return generatedPlate
end

-- mixing async with sync tasks
function IsPlateTaken(plate)
	local callback = 'waiting'

	ESX.TriggerServerCallback('pGarage:GetAllPlate', function(isPlateTaken)
		callback = isPlateTaken
	end, plate)

	while type(callback) == 'string' do
		Citizen.Wait(0)
	end

	return callback
end

function GetRandomNumber(length)
	Citizen.Wait(0)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(0)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

-- end generate plate

pGarage.CamManager = function(type, pos, fcam)
	if type == "create" then
		if not DoesCamExist(pGarage.Cam) then
			pGarage.Cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
		end
		SetCamCoord(pGarage.Cam, pos)
		SetCamFov(pGarage.Cam, 50.0)
		PointCamAtCoord(pGarage.Cam, fcam)
		SetCamShakeAmplitude(pGarage.Cam, 13.0)
		RenderScriptCams(1, 1, 1500, 1, 1)
	elseif type == "delete" then
		RenderScriptCams(0, 1, 1000, 1, 1)
        DestroyAllCams(true)
	end
end

RegisterNetEvent("pGarage:RequestGivecar")
AddEventHandler("pGarage:RequestGivecar", function(target, vehicle)
    plate = GeneratePlate()
    props = ESX.Game.GetVehicleProperties(vehicle)
    local props = {
		fuelLevel = 100.0
	}
	ESX.Game.SetVehicleProperties(vehicle, props)
    SneakyEvent("pGarage:Givecar", target, GetLabelText(GetDisplayNameFromVehicleModel(vehicle)), vehicle, plate, props, 1)
end)

RegisterNetEvent("pGarage:RequestGivecarhimself")
AddEventHandler("pGarage:RequestGivecarhimself", function(vehicle)
    plate = GeneratePlate()
    props = ESX.Game.GetVehicleProperties(vehicle)
    local props = {
		fuelLevel = 100.0
	}
	ESX.Game.SetVehicleProperties(vehicle, props)
    SneakyEvent("pGarage:Givecarhimself", GetLabelText(GetDisplayNameFromVehicleModel(vehicle)), vehicle, plate, props, 1)
end)