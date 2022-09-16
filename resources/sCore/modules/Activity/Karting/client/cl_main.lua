ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end
end)
SneakyEvent = TriggerServerEvent
local garagekarting = {

	garagekarting = {
        vehs = {
            {label = "Karting", veh = "veto"},
        },
        pos  = {
            {pos = vector3(-163.83071899414,-2134.9816894531,15.837880134583), heading = 290.950},
			{pos = vector3(-162.44828796387,-2138.3923339844,15.838112831116), heading = 289.262},
			{pos = vector3(-161.32278442383,-2141.7961425781,15.83833694458), heading = 289.292},
        },
    },
}


function ShowLoadingMessageKarting(text, spinnerType, timeMs)
	Citizen.CreateThread(function()
		BeginTextCommandBusyspinnerOn("STRING")
		AddTextComponentSubstringPlayerName(text)
		EndTextCommandBusyspinnerOn(spinnerType)
		Wait(timeMs)
		RemoveLoadingPrompt()
	end)
end

local KartActive = false
local TableKarting = {}
local KartingBlocksControls = false
SneakyEvent = TriggerServerEvent
function SpawnKarting()
	for k,v in pairs(garagekarting.garagekarting.vehs) do
		local pos = FoundClearSpawnPoint(garagekarting.garagekarting.pos)
		if pos ~= false then
			LoadModel(v.veh)
			local lastVehicle = CreateVehicle(GetHashKey(v.veh), pos.pos, pos.heading, true, true)
			TriggerEvent('persistent-vehicles/register-vehicle', lastVehicle)
			table.insert(TableKarting, lastVehicle)
			KartingBlocksControls = true
			local playerPed = PlayerPedId()
			TaskWarpPedIntoVehicle(playerPed, lastVehicle, -1)
			SetEntityAsMissionEntity(lastVehicle, 1, 1)
			SetVehicleDirtLevel(lastVehicle, 0.0)
			ShowLoadingMessageKarting("Véhicule de karting sortie.", 2, 2000)
		else
			ESX.ShowNotification("Aucun point de sortie disponible")
			KartActive = false
			SneakyEvent("Karting:CheckVeh")
		end
	end
end

function removeKarting()
	local pPed = GetPlayerPed(-1)
	local pVeh = GetVehiclePedIsIn(pPed, false)
	local model = GetEntityModel(pVeh)
	Citizen.CreateThread(function()
		ShowLoadingMessageKarting("Rangement du véhicule ...", 1, 2500)
	end)
	local plate = GetVehicleNumberPlateText(veh)
	TaskLeaveAnyVehicle(pPed, 1, 1)
	Wait(2500)
	while IsPedInAnyVehicle(pPed, false) do
		TaskLeaveAnyVehicle(pPed, 1, 1)
		ShowLoadingMessageKarting("Rangement du véhicule ...", 1, 300)
		Wait(200)
	end
	KartingBlocksControls = false
	for k,v in pairs(TableKarting) do
		if DoesEntityExist(v) then
			print("[^3sKarting^0]: Deleting vehicle ["..v.."] !")
			TriggerEvent('persistent-vehicles/forget-vehicle', v)
			DeleteEntity(v)
		end
	end
end

AddEventHandler("onResourceStop", function(name)
    if name == "sCore" then
        for k,v in pairs(TableKarting) do
			if DoesEntityExist(v) then
				print("[^3sKarting^0]: Deleting vehicle ["..v.."] !")
				TriggerEvent('persistent-vehicles/forget-vehicle', v)
				DeleteEntity(v)
			end
		end
    end
end)


function LoadModel(model)
	local oldName = model
	local model = GetHashKey(model)
	if IsModelInCdimage(model) then
		RequestModel(model)
		while not HasModelLoaded(model) do Wait(1) end
	else
		ShowNotification("~r~ERREUR: ~s~Modèle inconnu.\nMerci de report le problème au dev. (Modèle: "..oldName.." #"..model..")")
	end
end

function FoundClearSpawnPoint(zones)
	local found = false
	local count = 0
	for k,v in pairs(zones) do
		local clear = IsSpawnPointClear(v.pos, 2.0)
		if clear then
			found = v
			break
		end
	end
	return found
end

function IsSpawnPointClear(coords, radius)
	local vehicles = GetVehiclesInArea(coords, radius)

	return #vehicles == 0
end

function GetVehiclesInArea (coords, area)
	local vehicles       = GetVehicles()
	local vehiclesInArea = {}

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if distance <= area then
			table.insert(vehiclesInArea, vehicles[i])
		end
	end

	return vehiclesInArea
end

function GetVehicles()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

Citizen.CreateThread(function()
	while true do 
		if KartingBlocksControls == true then
			print("Boucle enabled")
			DisableControlAction(0, 23, true)
			DisableControlAction(0, 75, true)
			DisableControlAction(0, 49, true)
			DisableControlAction(0, 145, true)
			DisableControlAction(0, 185, true)
			DisableControlAction(0, 251, true)
			Wait(1)
		else
			Wait(850)
		end
	end
end)


Citizen.CreateThread(function()
    while true do
        att = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        local pPed = GetPlayerPed(-1)
        if #(pCoords-vector3(-162.82264709473,-2130.9057617188,16.705026626587)) < 1.0 then
			att = 1
			ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~g~prendre~s~/~r~rendre~s~ votre kart.\n~b~Frais~s~ : 200~g~$~s~")
			if IsControlJustPressed(0, 51) then
				ESX.TriggerServerCallback("Kart:checkService", function(cb) 
					if cb then
						ESX.TriggerServerCallback('Karting:buy', function(ok)
							if ok then
								KartActive = true
								SpawnKarting()
								SneakyEvent("Kart:service", cb)
							else
								ESX.ShowNotification("~r~Erreur~s~\nVous n'avez pas assez d'argent")
							end
						end,200)
					else
						KartActive = false
						removeKarting()
						SneakyEvent("Kart:service", cb)
					end
				end)
			end
		elseif #(pCoords-vector3(-162.82264709473,-2130.9057617188,16.705026626587)) < 3.0 then
			att = 1
			DrawMarker(20, -162.82264709473,-2130.9057617188,16.705026626587, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 0, 155, 255, 255, 0, false, false, 2, false, false, false, false)
		end
        if GetDistanceBetweenCoords(GetEntityCoords(pPed), -101.77151489258,-2078.32421875,17.560871124268, true) > 125.0 then
            att = 1
            if KartActive then
                removeKarting()
                KartActive = false
                SneakyEvent("Kart:service")
            end
        end
		if GetDistanceBetweenCoords(GetEntityCoords(pPed), -101.77151489258,-2078.32421875,17.560871124268, true) < 60.0 then
            att = 1
            ClearAreaOfVehicles(-85.162, -2067.108, 21.797, 1000, false, false, false, false, false)
        	RemoveVehiclesFromGeneratorsInArea(-85.162 - 90.0, -2067.108 - 90.0, 21 - 90.0, -85.162 + 90.0, 2067.108 + 90.0, 21 + 90.0)
        end
        Citizen.Wait(att)
    end
end)

ShowNotification = function(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	DrawNotification(0, 1)
end

--[[ AddEventHandler('onClientResourceStart', function(res)
    if res == "sCore" then
        ShowNotification("Le ~b~core~s~ se relance ...")
    end
end) ]]