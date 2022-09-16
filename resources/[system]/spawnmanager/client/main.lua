SneakyEvent = TriggerServerEvent
_NetworkExplodeVehicle = NetworkExplodeVehicle
_AddExplosion = AddExplosion

local isFirstSpawn = true

local function FreezePlayer(player, freeze)
	SetPlayerControl(player, not freeze, false)
	local ped = GetPlayerPed(player)

	if not freeze then
		if not IsEntityVisible(ped) then
			SetEntityVisible(ped, true)
		end

		if not IsPedInAnyVehicle(ped) then
			SetEntityCollision(ped, true)
		end

		FreezeEntityPosition(ped, false)
		SetPlayerInvincible(player, false)
	else
		if IsEntityVisible(ped) then
			SetEntityVisible(ped, false)
		end

		SetEntityCollision(ped, false)
		FreezeEntityPosition(ped, true)
		SetPlayerInvincible(player, true)

		if not IsPedFatallyInjured(ped) then
			ClearPedTasksImmediately(ped)
		end
	end
end

RegisterNetEvent('spawnmanager:spawnPlayer')
AddEventHandler('spawnmanager:spawnPlayer', function(spawn)
	DoScreenFadeOut(500)
	while not IsScreenFadedOut() do
		Citizen.Wait(0)
	end

	FreezePlayer(PlayerId(), true)
	RequestModel(spawn.model)

	while not HasModelLoaded(spawn.model) do
		RequestModel(spawn.model)
		Citizen.Wait(0)
	end

	SetPlayerModel(PlayerId(), spawn.model)
	SetModelAsNoLongerNeeded(spawn.model)

	RequestCollisionAtCoord(spawn.coords)
	local ped = PlayerPedId()

	SetEntityCoordsNoOffset(ped, spawn.coords, false, false, false, true)
	NetworkResurrectLocalPlayer(spawn.coords, spawn.heading, true, true, false)

	ClearPedTasksImmediately(ped)
	RemoveAllPedWeapons(ped)

	while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
		Citizen.Wait(0)
	end

	if isFirstSpawn then
		isFirstSpawn = false
		TriggerEvent('playerSpawned', spawn, true)

		ShutdownLoadingScreen()
		ShutdownLoadingScreenNui()

		FreezePlayer(PlayerId(), false)

		DoScreenFadeIn(2000)
		while not IsScreenFadedIn() do
			Citizen.Wait(0)
		end
	else
		FreezePlayer(PlayerId(), false)

		DoScreenFadeIn(500)
		while not IsScreenFadedIn() do
			Citizen.Wait(0)
		end

		TriggerEvent('playerSpawned', spawn, false)
	end
end)

exports('isFirstSpawn', function()
	return isFirstSpawn
end)