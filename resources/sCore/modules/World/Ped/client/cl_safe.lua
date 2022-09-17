ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	ESX.PlayerData = ESX.GetPlayerData()
end)

local safeZones = {
	vector3(228.98168945312,-790.67102050781,30.653341293335), -- Parking central
	vector3(438.50491333008,-986.23333740234,30.689577102661), -- MRPD
	vector3(-855.75128173828,-422.81924438477,36.639907836914), -- Spawn
    vector3(-438.6884765625,-2796.2739257812,7.2960515022278), -- Post OP
	vector3(310.14932250977,-587.99395751953,43.261222839355), -- EMS
}

local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

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

local disabledSafeZonesKeys = {
	{group = 2, key = 37, message = "~r~Attention !\n~s~Trop de personnes sont présentes dans la zone afin que tu puisses sortir une arme."},
	{group = 0, key = 24, message = "~r~Attention !\n~s~Trop de personnes sont présentes dans la zone afin que tu puisses engager un combat."},
	{group = 0, key = 69, message = "~r~Attention !\n~s~Trop de personnes sont présentes dans la zone afin que tu puisses engager un combat."},
	{group = 0, key = 92, message = "~r~Attention !\n~s~Trop de personnes sont présentes dans la zone afin que tu puisses engager un combat."},
	{group = 0, key = 106, message = "~r~Attention !\n~s~Trop de personnes sont présentes dans la zone afin que tu puisses engager un combat."},
	{group = 0, key = 168, message = "~r~Attention !\n~s~Trop de personnes sont présentes dans la zone afin que tu puisses engager un combat."},
	{group = 0, key = 160, message = "~r~Attention !\n~s~Trop de personnes sont présentes dans la zone afin que tu puisses engager un combat."},
	{group = 0, key = 45, message = "~r~Attention !\n~s~Trop de personnes sont présentes dans la zone afin que tu puisses engager un combat."},
	{group = 0, key = 80, message = "~r~Attention !\n~s~Trop de personnes sont présentes dans la zone afin que tu puisses engager un combat."},
	{group = 0, key = 140, message = "~r~Attention !\n~s~Trop de personnes sont présentes dans la zone afin que tu puisses engager un combat."},
	{group = 0, key = 250, message = "~r~Attention !\n~s~Trop de personnes sont présentes dans la zone afin que tu puisses engager un combat."},
	{group = 0, key = 263, message = "~r~Attention !\n~s~Trop de personnes sont présentes dans la zone afin que tu puisses engager un combat."},
	{group = 0, key = 310, message = "~r~Attention !\n~s~Trop de personnes sont présentes dans la zone afin que tu puisses engager un combat."}
}

local notifIn, notifOut = false, false
local closestZone = 1

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end

	while true do
		local plyPed = PlayerPedId()
		local plyCoords = GetEntityCoords(plyPed, false)
		local minDistance = 100000

		for i = 1, #safeZones, 1 do
			local dist = #(safeZones[i] - plyCoords)

			if dist < minDistance then
				minDistance = dist
				closestZone = i
			end
		end

		Citizen.Wait(15000)
	end
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end

	while true do
		interval = 500
		local plyPed = PlayerPedId()
		local plyCoords = GetEntityCoords(plyPed, false)
		local dist = #(safeZones[closestZone] - plyCoords)
		if dist <= 80 then
			interval = 1
			if not notifIn then
				notifIn = true
				notifOut = false
			end
		else
			interval = 850
			if not notifOut then
				notifOut = true
				notifIn = false
			end
		end
		if notifIn then
			interval = 1
			for vehicle in EnumerateVehicles() do
				if not IsVehicleSeatFree(vehicle, -1) then
					SetEntityNoCollisionEntity(plyPed, vehicle, true)
					SetEntityNoCollisionEntity(vehicle, plyPed, true)
					
				end
			end
		end
		Citizen.Wait(interval)
	end
end)

