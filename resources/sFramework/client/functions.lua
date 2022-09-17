ESX = {}
ESX.PlayerData = {}
ESX.PlayerLoaded = false
ESX.CurrentRequestId = 0
ESX.ServerCallbacks = {}
ESX.TimeoutCallbacks = {}
SneakyEvent = TriggerServerEvent
ESX.Game = {}
ESX.Game.Utils = {}

ESX.Scaleform = {}
ESX.Scaleform.Utils = {}

ESX.Streaming = {}

function ESX.SetTimeout(msec, cb)
	table.insert(ESX.TimeoutCallbacks, {
		time = GetGameTimer() + msec,
		cb = cb
	})

	return #ESX.TimeoutCallbacks
end

function ESX.ClearTimeout(i)
	ESX.TimeoutCallbacks[i] = nil
end

function ESX.IsPlayerLoaded()
	return ESX.PlayerLoaded
end

function ESX.GetPlayerData()
	return ESX.PlayerData
end

function ESX.SetPlayerData(key, val)
	ESX.PlayerData[key] = val
end

function ESX.ShowNotification(msg, hudColorIndex)
	AddTextEntry('esxNotification', msg)
	BeginTextCommandThefeedPost('esxNotification')
	if hudColorIndex then ThefeedNextPostBackgroundColor(hudColorIndex) end
	EndTextCommandThefeedPostTicker(false, true)
end

function ESX.ShowAdvancedNotification(title, subject, msg, icon, iconType, hudColorIndex)
	AddTextEntry('esxAdvancedNotification', msg)
	BeginTextCommandThefeedPost('esxAdvancedNotification')
	if hudColorIndex then ThefeedNextPostBackgroundColor(hudColorIndex) end
	EndTextCommandThefeedPostMessagetext(icon, icon, false, iconType, title, subject)
	EndTextCommandThefeedPostTicker(false, false)
end

function ESX.ShowHelpNotification(msg)
	AddTextEntry('esxHelpNotification', msg)
	BeginTextCommandDisplayHelp('esxHelpNotification')
	EndTextCommandDisplayHelp(0, false, true, -1)
end

function ESX.TriggerServerCallback(name, cb, ...)
	ESX.ServerCallbacks[ESX.CurrentRequestId] = cb
	SneakyEvent('esx:triggerServerCallback', name, ESX.CurrentRequestId, ...)

	if ESX.CurrentRequestId < 65535 then
		ESX.CurrentRequestId = ESX.CurrentRequestId + 1
	else
		ESX.CurrentRequestId = 0
	end
end


function ESX.Game.GetPedMugshot(ped)
	if DoesEntityExist(ped) then
		local mugshot = RegisterPedheadshot(ped)

		while not IsPedheadshotReady(mugshot) do
			Citizen.Wait(0)
		end

		return mugshot, GetPedheadshotTxdString(mugshot)
	end
end

function ESX.Game.Teleport(entity, coords, cb)
	if entity ~= nil and entity == 'source' then
		RequestCollisionAtCoord(coords)

		while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
			RequestCollisionAtCoord(coords)
			Citizen.Wait(0)
		end

		SetEntityCoords(PlayerPedId(), coords)
	else
		if DoesEntityExist(entity) then
			RequestCollisionAtCoord(coords)

			while not HasCollisionLoadedAroundEntity(entity) do
				RequestCollisionAtCoord(coords)
				Citizen.Wait(0)
			end

			SetEntityCoords(entity, coords)
		end
	end

	if cb then
		cb()
	end
end

function ESX.Game.DeleteVehicle(vehicle)
	SetEntityAsMissionEntity(vehicle, false, false)
	DeleteVehicle(vehicle)
end

function ESX.Game.DeleteObject(object)
	SetEntityAsMissionEntity(object, false, false)
	DeleteObject(object)
end

function ESX.Game.DeleteEntity(entity)
	SetEntityAsMissionEntity(entity, false, false)
	DeleteEntity(entity)
end

function ESX.Game.SpawnObject(model, coords, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))

	Citizen.CreateThread(function()
		ESX.Streaming.RequestModel(model)
		local object = CreateObject(model, coords, true, false, true)
		local id = NetworkGetNetworkIdFromEntity(object)

		SetNetworkIdCanMigrate(id, true)
		SetEntityAsMissionEntity(object, false, false)
		SetModelAsNoLongerNeeded(model)

		RequestCollisionAtCoord(coords)

		while not HasCollisionLoadedAroundEntity(object) do
			Citizen.Wait(0)
		end

		if cb then
			cb(object)
		end
	end)
end

function ESX.Game.SpawnLocalObject(model, coords, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))

	Citizen.CreateThread(function()
		ESX.Streaming.RequestModel(model)
		local object = CreateObject(model, coords, false, false, true)

		SetEntityAsMissionEntity(object, false, false)
		SetModelAsNoLongerNeeded(model)

		RequestCollisionAtCoord(coords)

		while not HasCollisionLoadedAroundEntity(object) do
			Citizen.Wait(0)
		end

		if cb then
			cb(object)
		end
	end)
end

function ESX.Game.SpawnVehicle(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))
	coords = ESX.Vector(coords)

	Citizen.CreateThread(function()
		ESX.Streaming.RequestModel(model)
		local vehicle = CreateVehicle(model, coords, heading, true, false)
		local id = NetworkGetNetworkIdFromEntity(vehicle)
		TriggerEvent('persistent-vehicles/register-vehicle', vehicle)
		SetNetworkIdCanMigrate(id, true)
		SetEntityAsMissionEntity(vehicle, false, false)
		SetModelAsNoLongerNeeded(model)

		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleOnGroundProperly(vehicle)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetVehRadioStation(vehicle, 'OFF')
		DecorSetInt(plyVeh, 'indicatorLights', 0)

		RequestCollisionAtCoord(coords)

		while not HasCollisionLoadedAroundEntity(vehicle) do
			Citizen.Wait(0)
		end

		if cb then
			cb(vehicle)
		end
	end)
end

function ESX.Game.SpawnLocalVehicle(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))
	coords = ESX.Vector(coords)

	Citizen.CreateThread(function()
		ESX.Streaming.RequestModel(model)
		local vehicle = CreateVehicle(model, coords, heading, false, false)
		TriggerEvent('persistent-vehicles/register-vehicle', vehicle)
		SetEntityAsMissionEntity(vehicle, false, false)
		SetModelAsNoLongerNeeded(model)

		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleOnGroundProperly(vehicle)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetVehRadioStation(vehicle, 'OFF')

		RequestCollisionAtCoord(coords)

		while not HasCollisionLoadedAroundEntity(vehicle) do
			Citizen.Wait(0)
		end

		if cb then
			cb(vehicle)
		end
	end)
end

function ESX.Game.IsVehicleEmpty(vehicle)
	local passengers = GetVehicleNumberOfPassengers(vehicle)
	local driverSeatFree = IsVehicleSeatFree(vehicle, -1)
	return passengers == 0 and driverSeatFree
end

function ESX.Game.GetObjects()
	local objects = {}

	for object in EnumerateObjects() do
		table.insert(objects, object)
	end

	return objects
end

function ESX.Game.GetClosestObject(filter, coords)
	local objects = ESX.Game.GetObjects()
	local closestDistance, closestObject = -1, -1

	if type(filter) == 'string' then
		if filter ~= '' then
			filter = {filter}
		end
	end

	if coords == nil then
		coords = GetEntityCoords(PlayerPedId(), false)
	end

	for i = 1, #objects, 1 do
		local foundObject = false

		if filter == nil or (type(filter) == 'table' and #filter == 0) then
			foundObject = true
		else
			local objectModel = GetEntityModel(objects[i])

			for j = 1, #filter, 1 do
				if objectModel == GetHashKey(filter[j]) then
					foundObject = true
					break
				end
			end
		end

		if foundObject then
			local objectCoords = GetEntityCoords(objects[i], false)
			local distance = #(objectCoords - coords)

			if closestDistance == -1 or closestDistance > distance then
				closestObject = objects[i]
				closestDistance = distance
			end
		end
	end

	return closestObject, closestDistance
end

function ESX.Game.GetAllPlayers()
	local clientPlayers = false

	ESX.TriggerServerCallback('esx:getActivePlayers', function(players)
		clientPlayers = players
	end)

	while not clientPlayers do
		Citizen.Wait(0)
	end

	return clientPlayers
end

function ESX.Game.GetPlayers()
	local activePlayers = GetActivePlayers()
	local players = {}

	for i = 1, #activePlayers, 1 do
		local ped = GetPlayerPed(activePlayers[i])

		if DoesEntityExist(ped) then
			table.insert(players, activePlayers[i])
		end
	end

	return players
end

function ESX.Game.GetClosestPlayer(coords)
	local players = ESX.Game.GetPlayers()
	local closestDistance, closestPlayer = -1, -1
	local usePlayerPed, playerId = false, 0

	if coords == nil then
		usePlayerPed = true
		playerId = PlayerId()
		coords = GetEntityCoords(PlayerPedId(), false)
	end

	for i = 1, #players, 1 do
		if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then
			local targetPed = GetPlayerPed(players[i])
			local targetCoords = GetEntityCoords(targetPed, false)
			local distance = #(targetCoords - coords)

			if closestDistance == -1 or closestDistance > distance then
				closestPlayer = players[i]
				closestDistance = distance
			end
		end
	end

	return closestPlayer, closestDistance
end

function ESX.Game.GetPlayersInArea(coords, area)
	local players = ESX.Game.GetPlayers()
	local playersInArea = {}

	if coords == nil then
		coords = GetEntityCoords(PlayerPedId(), false)
	end

	for i = 1, #players, 1 do
		local target = GetPlayerPed(players[i])
		local targetCoords = GetEntityCoords(target, false)
		local distance = #(targetCoords - coords)

		if distance <= area then
			table.insert(playersInArea, players[i])
		end
	end

	return playersInArea
end


function ESX.Game.GetVehicles()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

--[[ function ESX.Game.GetClosestVehicle(coords)
	local vehicles = ESX.Game.GetVehicles()
	local closestDistance, closestVehicle = -1, -1

	if coords == nil then
		coords = GetEntityCoords(PlayerPedId(), false)
	end

	for i = 1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i], false)
		local distance = #(vehicleCoords - coords)

		if closestDistance == -1 or closestDistance > distance then
			closestVehicle, closestDistance = vehicles[i], distance
		end
	end

	return closestVehicle, closestDistance
end ]]

ESX.Game.GetClosestVehicle = function(coords)
	local vehicles        = ESX.Game.GetVehicles()
	local closestDistance = -1
	local closestVehicle  = -1
	local coords          = coords

	if coords == nil then
		local playerPed = PlayerPedId()
		coords          = GetEntityCoords(playerPed)
	end

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if closestDistance == -1 or closestDistance > distance then
			closestVehicle  = vehicles[i]
			closestDistance = distance
		end
	end

	return closestVehicle, closestDistance
end

function ESX.Game.GetVehiclesInArea(coords, area)
	local vehicles = ESX.Game.GetVehicles()
	local vehiclesInArea = {}

	if coords == nil then
		coords = GetEntityCoords(PlayerPedId(), false)
	end

	for i = 1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i], false)
		local distance = #(vehicleCoords - coords)

		if distance <= area then
			table.insert(vehiclesInArea, vehicles[i])
		end
	end

	return vehiclesInArea
end

function ESX.Game.GetVehicleInDirection()
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed, false)
	local inDirection = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
	local rayHandle = StartShapeTestRay(playerCoords, inDirection, 10, playerPed, 0)
	local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

	if hit == 1 and GetEntityType(entityHit) == 2 then
		return entityHit
	end

	return nil
end

function ESX.Game.IsSpawnPointClear(coords, radius)
	local vehicles = ESX.Game.GetVehiclesInArea(coords, radius)
	return #vehicles == 0
end

function ESX.Game.GetPeds(ignoreList)
	local ignoreList = ignoreList or {}
	local peds = {}

	for ped in EnumeratePeds() do
		local found = false

		for j = 1, #ignoreList, 1 do
			if ignoreList[j] == ped then
				found = true
			end
		end

		if not found then
			table.insert(peds, ped)
		end
	end

	return peds
end

function ESX.Game.GetClosestPed(coords, ignoreList)
	ignoreList = ignoreList or {}
	local peds = ESX.Game.GetPeds(ignoreList)
	local closestDistance, closestPed = -1, -1

	if coords == nil then
		coords = GetEntityCoords(PlayerPedId(), false)
	end

	for i = 1, #peds, 1 do
		local pedCoords = GetEntityCoords(peds[i], false)
		local distance = #(pedCoords - coords)

		if closestDistance == -1 or closestDistance > distance then
			closestPed = peds[i]
			closestDistance = distance
		end
	end

	return closestPed, closestDistance
end

local ScreenCoords = { baseX = 0.918, baseY = 0.984, titleOffsetX = 0.012, titleOffsetY = -0.012, valueOffsetX = 0.0785, valueOffsetY = -0.0165, pbarOffsetX = 0.047, pbarOffsetY = 0.0015 }
local Sizes = {	timerBarWidth = 0.165, timerBarHeight = 0.035, timerBarMargin = 0.038, pbarWidth = 0.0616, pbarHeight = 0.0105 }

local activeBars = {}

ESX.AddTimerBar = function(title, itemData)
	if not itemData then return end
	RequestStreamedTextureDict("timerbars", true)

	local barIndex = #activeBars + 1
	activeBars[barIndex] = {
		title = title,
		text = itemData.text,
		textColor = itemData.color or { 255, 255, 255, 255 },
		percentage = itemData.percentage,
		endTime = itemData.endTime,
		pbarBgColor = itemData.bg or { 155, 155, 155, 255 },
		pbarFgColor = itemData.fg or { 255, 255, 255, 255 }
	}

	return barIndex
end


ESX.RemoveTimerBar = function()
	activeBars = {}
	SetStreamedTextureDictAsNoLongerNeeded("timerbars")
end

ESX.UpdateTimerBar = function(barIndex, itemData)
	if not activeBars[barIndex] or not itemData then return end
	for k,v in pairs(itemData) do
		activeBars[barIndex][k] = v
	end
end

local HideHudComponentThisFrame = HideHudComponentThisFrame
local GetSafeZoneSize = GetSafeZoneSize
local DrawSprite = DrawSprite
local DrawText2 = DrawText2
local DrawRect = DrawRect
local SecondsToClock = SecondsToClock
local GetGameTimer = GetGameTimer
local textColor = { 200, 100, 100 }
local math = math

function SecondsToClock1(seconds)
	seconds = tonumber(seconds)

	if seconds <= 0 then
		return "00:00"
	else
		mins = string.format("%02.f", math.floor(seconds / 60))
		secs = string.format("%02.f", math.floor(seconds - mins * 60))
		return string.format("%s:%s", mins, secs)
	end
end

Citizen.CreateThread(function()
	while true do
		local attente = 250

		local safeZone = GetSafeZoneSize()
		local safeZoneX = (1.0 - safeZone) * 0.5
		local safeZoneY = (1.0 - safeZone) * 0.5

		if #activeBars > 0 then
			attente = 1
			HideHudComponentThisFrame(6)
			HideHudComponentThisFrame(7)
			HideHudComponentThisFrame(8)
			HideHudComponentThisFrame(9)

			for i,v in pairs(activeBars) do
				local drawY = (ScreenCoords.baseY - safeZoneY) - (i * Sizes.timerBarMargin);
				DrawSprite("timerbars", "all_black_bg", ScreenCoords.baseX - safeZoneX, drawY, Sizes.timerBarWidth, Sizes.timerBarHeight, 0.0, 255, 255, 255, 160)
				DrawText2(0, v.title, 0.3, (ScreenCoords.baseX - safeZoneX) + ScreenCoords.titleOffsetX, drawY + ScreenCoords.titleOffsetY, v.textColor, false, 2)

				if v.percentage then
					local pbarX = (ScreenCoords.baseX - safeZoneX) + ScreenCoords.pbarOffsetX;
					local pbarY = drawY + ScreenCoords.pbarOffsetY;
					local width = Sizes.pbarWidth * v.percentage;

					DrawRect(pbarX, pbarY, Sizes.pbarWidth, Sizes.pbarHeight, v.pbarBgColor[1], v.pbarBgColor[2], v.pbarBgColor[3], v.pbarBgColor[4])

					DrawRect((pbarX - Sizes.pbarWidth / 2) + width / 2, pbarY, width, Sizes.pbarHeight, v.pbarFgColor[1], v.pbarFgColor[2], v.pbarFgColor[3], v.pbarFgColor[4])
				elseif v.text then
					DrawText2(0, v.text, 0.425, (ScreenCoords.baseX - safeZoneX) + ScreenCoords.valueOffsetX, drawY + ScreenCoords.valueOffsetY, v.textColor, false, 2)
				elseif v.endTime then
					local remainingTime = math.floor(v.endTime - GetGameTimer())
					DrawText2(0, SecondsToClock1(remainingTime / 1000), 0.425, (ScreenCoords.baseX - safeZoneX) + ScreenCoords.valueOffsetX, drawY + ScreenCoords.valueOffsetY, remainingTime <= 0 and textColor or v.textColor, false, 2)
				end
			end
		end
		Wait(attente)
	end
end)

function DrawText2(intFont, strText, floatScale, intPosX, intPosY, color, boolShadow, intAlign, addWarp)
	SetTextFont(intFont)
	SetTextScale(floatScale, floatScale)

	if boolShadow then
		SetTextDropShadow(0, 0, 0, 0, 0)
		SetTextEdge(0, 0, 0, 0, 0)
	end

	SetTextColour(color[1], color[2], color[3], 255)
	if intAlign == 0 then
		SetTextCentre(true)
	else
		SetTextJustification(intAlign or 1)
		if intAlign == 2 then
			SetTextWrap(.0, addWarp or intPosX)
		end
	end

	SetTextEntry("jamyfafi")
	AddLongString(strText)

	DrawText(intPosX, intPosY)
end

function AddLongString(txt)
	local maxLen = 100
	for i = 0, string.len(txt), maxLen do
		local sub = string.sub(txt, i, math.min(i + maxLen, string.len(txt)))
		AddTextComponentString(sub)
	end
end

ESX.Game.GetVehicleProperties = function(vehicle)
	local color1, color2 = GetVehicleColours(vehicle)
	local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
	local extras = {}

	for id=0, 12 do
		if DoesExtraExist(vehicle, id) then
			local state = IsVehicleExtraTurnedOn(vehicle, id) == 1
			extras[tostring(id)] = state
		end
	end

	return {
		model             = GetEntityModel(vehicle),

		plate             = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)),
		plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

		bodyHealth        = ESX.Math.Round(GetVehicleBodyHealth(vehicle), 1),
		engineHealth      = ESX.Math.Round(GetVehicleEngineHealth(vehicle), 1),

		fuelLevel         = ESX.Math.Round(GetVehicleFuelLevel(vehicle), 1),
		dirtLevel         = ESX.Math.Round(GetVehicleDirtLevel(vehicle), 1),
		color1            = color1,
		color2            = color2,

		interiorcolor = GetVehicleInteriorColour(vehicle),

		pearlescentColor  = pearlescentColor,
		wheelColor        = wheelColor,

		wheels            = GetVehicleWheelType(vehicle),
		windowTint        = GetVehicleWindowTint(vehicle),

		neonEnabled       = {
			IsVehicleNeonLightEnabled(vehicle, 0),
			IsVehicleNeonLightEnabled(vehicle, 1),
			IsVehicleNeonLightEnabled(vehicle, 2),
			IsVehicleNeonLightEnabled(vehicle, 3)
		},

		extras            = extras,

		neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
		tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),

		modSpoilers       = GetVehicleMod(vehicle, 0),
		modFrontBumper    = GetVehicleMod(vehicle, 1),
		modRearBumper     = GetVehicleMod(vehicle, 2),
		modSideSkirt      = GetVehicleMod(vehicle, 3),
		modExhaust        = GetVehicleMod(vehicle, 4),
		modFrame          = GetVehicleMod(vehicle, 5),
		modGrille         = GetVehicleMod(vehicle, 6),
		modHood           = GetVehicleMod(vehicle, 7),
		modFender         = GetVehicleMod(vehicle, 8),
		modRightFender    = GetVehicleMod(vehicle, 9),
		modRoof           = GetVehicleMod(vehicle, 10),

		modEngine         = GetVehicleMod(vehicle, 11),
		modBrakes         = GetVehicleMod(vehicle, 12),
		modTransmission   = GetVehicleMod(vehicle, 13),
		modHorns          = GetVehicleMod(vehicle, 14),
		modSuspension     = GetVehicleMod(vehicle, 15),
		modArmor          = GetVehicleMod(vehicle, 16),

		modTurbo          = IsToggleModOn(vehicle, 18),
		modSmokeEnabled   = IsToggleModOn(vehicle, 20),
		modXenon          = IsToggleModOn(vehicle, 22),

		modFrontWheels    = GetVehicleMod(vehicle, 23),
		modBackWheels     = GetVehicleMod(vehicle, 24),

		modPlateHolder    = GetVehicleMod(vehicle, 25),
		modVanityPlate    = GetVehicleMod(vehicle, 26),
		modTrimA          = GetVehicleMod(vehicle, 27),
		modOrnaments      = GetVehicleMod(vehicle, 28),
		modDashboard      = GetVehicleMod(vehicle, 29),
		modDial           = GetVehicleMod(vehicle, 30),
		modDoorSpeaker    = GetVehicleMod(vehicle, 31),
		modSeats          = GetVehicleMod(vehicle, 32),
		modSteeringWheel  = GetVehicleMod(vehicle, 33),
		modShifterLeavers = GetVehicleMod(vehicle, 34),
		modAPlate         = GetVehicleMod(vehicle, 35),
		modSpeakers       = GetVehicleMod(vehicle, 36),
		modTrunk          = GetVehicleMod(vehicle, 37),
		modHydrolic       = GetVehicleMod(vehicle, 38),
		modEngineBlock    = GetVehicleMod(vehicle, 39),
		modAirFilter      = GetVehicleMod(vehicle, 40),
		modStruts         = GetVehicleMod(vehicle, 41),
		modArchCover      = GetVehicleMod(vehicle, 42),
		modAerials        = GetVehicleMod(vehicle, 43),
		modTrimB          = GetVehicleMod(vehicle, 44),
		modTank           = GetVehicleMod(vehicle, 45),
		modWindows        = GetVehicleMod(vehicle, 46),
		modLivery         = GetVehicleMod(vehicle, 48)
	}
end

ESX.Game.SetVehicleProperties = function(vehicle, props)
	SetVehicleModKit(vehicle, 0)

	if props.plate then
		SetVehicleNumberPlateText(vehicle, props.plate)
	end

	if props.plateIndex then
		SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
	end

	if props.bodyHealth then
		SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0)
	end

	if props.engineHealth then
		SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0)
	end

	if props.fuelLevel then
		SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0)
	end

	if props.dirtLevel then
		SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0)
	end

	if props.color1 then
		local color1, color2 = GetVehicleColours(vehicle)
		SetVehicleColours(vehicle, props.color1, color2)
	end

	if props.color2 then
		local color1, color2 = GetVehicleColours(vehicle)
		SetVehicleColours(vehicle, color1, props.color2)
	end

	if props.interiorcolor then
		local interiorcolor = GetVehicleInteriorColour(vehicle)
		SetVehicleInteriorColor(vehicle,interiorcolor)
	end

	if props.pearlescentColor then
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor)
	end

	if props.wheelColor then
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleExtraColours(vehicle, pearlescentColor, props.wheelColor)
	end

	if props.wheels then
		SetVehicleWheelType(vehicle, props.wheels)
	end

	if props.windowTint then
		SetVehicleWindowTint(vehicle, props.windowTint)
	end

	if props.neonEnabled then
		SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
		SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
		SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
		SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
	end

	if props.extras then
		for id,enabled in pairs(props.extras) do
			if enabled then
				SetVehicleExtra(vehicle, tonumber(id), 0)
			else
				SetVehicleExtra(vehicle, tonumber(id), 1)
			end
		end
	end

	if props.neonColor then
		SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
	end

	if props.modSmokeEnabled then
		ToggleVehicleMod(vehicle, 20, true)
	end

	if props.tyreSmokeColor then
		SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
	end

	if props.modSpoilers then
		SetVehicleMod(vehicle, 0, props.modSpoilers, false)
	end

	if props.modFrontBumper then
		SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
	end

	if props.modRearBumper then
		SetVehicleMod(vehicle, 2, props.modRearBumper, false)
	end

	if props.modSideSkirt then
		SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
	end

	if props.modExhaust then
		SetVehicleMod(vehicle, 4, props.modExhaust, false)
	end

	if props.modFrame then
		SetVehicleMod(vehicle, 5, props.modFrame, false)
	end

	if props.modGrille then
		SetVehicleMod(vehicle, 6, props.modGrille, false)
	end

	if props.modHood then
		SetVehicleMod(vehicle, 7, props.modHood, false)
	end

	if props.modFender then
		SetVehicleMod(vehicle, 8, props.modFender, false)
	end

	if props.modRightFender then
		SetVehicleMod(vehicle, 9, props.modRightFender, false)
	end

	if props.modRoof then
		SetVehicleMod(vehicle, 10, props.modRoof, false)
	end

	if props.modEngine then
		SetVehicleMod(vehicle, 11, props.modEngine, false)
	end

	if props.modBrakes then
		SetVehicleMod(vehicle, 12, props.modBrakes, false)
	end

	if props.modTransmission then
		SetVehicleMod(vehicle, 13, props.modTransmission, false)
	end

	if props.modHorns then
		SetVehicleMod(vehicle, 14, props.modHorns, false)
	end

	if props.modSuspension then
		SetVehicleMod(vehicle, 15, props.modSuspension, false)
	end

	if props.modArmor then
		SetVehicleMod(vehicle, 16, props.modArmor, false)
	end

	if props.modTurbo then
		ToggleVehicleMod(vehicle,  18, props.modTurbo)
	end

	if props.modXenon then
		ToggleVehicleMod(vehicle,  22, props.modXenon)
	end

	if props.modFrontWheels then
		SetVehicleMod(vehicle, 23, props.modFrontWheels, false)
	end

	if props.modBackWheels then
		SetVehicleMod(vehicle, 24, props.modBackWheels, false)
	end

	if props.modPlateHolder then
		SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
	end

	if props.modVanityPlate then
		SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
	end

	if props.modTrimA then
		SetVehicleMod(vehicle, 27, props.modTrimA, false)
	end

	if props.modOrnaments then
		SetVehicleMod(vehicle, 28, props.modOrnaments, false)
	end

	if props.modDashboard then
		SetVehicleMod(vehicle, 29, props.modDashboard, false)
	end

	if props.modDial then
		SetVehicleMod(vehicle, 30, props.modDial, false)
	end

	if props.modDoorSpeaker then
		SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
	end

	if props.modSeats then
		SetVehicleMod(vehicle, 32, props.modSeats, false)
	end

	if props.modSteeringWheel then
		SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
	end

	if props.modShifterLeavers then
		SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
	end

	if props.modAPlate then
		SetVehicleMod(vehicle, 35, props.modAPlate, false)
	end

	if props.modSpeakers then
		SetVehicleMod(vehicle, 36, props.modSpeakers, false)
	end

	if props.modTrunk then
		SetVehicleMod(vehicle, 37, props.modTrunk, false)
	end

	if props.modHydrolic then
		SetVehicleMod(vehicle, 38, props.modHydrolic, false)
	end

	if props.modEngineBlock then
		SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
	end

	if props.modAirFilter then
		SetVehicleMod(vehicle, 40, props.modAirFilter, false)
	end

	if props.modStruts then
		SetVehicleMod(vehicle, 41, props.modStruts, false)
	end

	if props.modArchCover then
		SetVehicleMod(vehicle, 42, props.modArchCover, false)
	end

	if props.modAerials then
		SetVehicleMod(vehicle, 43, props.modAerials, false)
	end

	if props.modTrimB then
		SetVehicleMod(vehicle, 44, props.modTrimB, false)
	end

	if props.modTank then
		SetVehicleMod(vehicle, 45, props.modTank, false)
	end

	if props.modWindows then
		SetVehicleMod(vehicle, 46, props.modWindows, false)
	end

	if props.modLivery then
		SetVehicleMod(vehicle, 48, props.modLivery, false)
		SetVehicleLivery(vehicle, props.modLivery)
	end
end

function ESX.Game.Utils.DrawText3D(coords, text, size, font)
	local camCoords = GetGameplayCamCoords()
	local distance = #(coords - camCoords)

	if not size then
		size = 1
	end

	if not font then
		font = 0
	end

	local scale = (size / distance) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	scale = scale * fov

	SetTextScale(0.0 * scale, 0.55 * scale)
	SetTextFont(font)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	SetDrawOrigin(coords, 0)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.0, 0.0)
	ClearDrawOrigin()
end

RegisterNetEvent('esx:serverCallback')
AddEventHandler('esx:serverCallback', function(requestId, ...)
	ESX.ServerCallbacks[requestId](...)
	ESX.ServerCallbacks[requestId] = nil
end)

RegisterNetEvent('esx:showNotification')
AddEventHandler('esx:showNotification', ESX.ShowNotification)

RegisterNetEvent('esx:showAdvancedNotification')
AddEventHandler('esx:showAdvancedNotification', ESX.ShowAdvancedNotification)

RegisterNetEvent('esx:showHelpNotification')
AddEventHandler('esx:showHelpNotification', ESX.ShowHelpNotification)

-- SetTimeout
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		local currTime = GetGameTimer()

		for i = 1, #ESX.TimeoutCallbacks, 1 do
			if ESX.TimeoutCallbacks[i] then
				if currTime >= ESX.TimeoutCallbacks[i].time then
					ESX.TimeoutCallbacks[i].cb()
					ESX.TimeoutCallbacks[i] = nil
				end
			end
		end
	end
end)