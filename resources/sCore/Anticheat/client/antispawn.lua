AutorizedRessourceSpawnVehicles = {
    ["sFramework"] = true,
    ["sCore"] = true,
}

function DeleteForceEntity(entity)
	if DoesEntityExist(entity) then
		NetworkRequestControlOfEntity(entity)
		local gameTime = GetGameTimer()

		while DoesEntityExist(entity) and (not NetworkHasControlOfEntity(entity) or ((GetGameTimer() - gameTime) < 1)) do
			Citizen.Wait(10)
		end

		if DoesEntityExist(entity) then
			DetachEntity(entity, false, false)
			SetEntityAsMissionEntity(entity, false, false)
			SetEntityCollision(entity, false, false)
			SetEntityAlpha(entity, 0, true)
			SetEntityAsNoLongerNeeded(entity)

			if IsAnEntity(entity) then
				DeleteEntity(entity)
			elseif IsEntityAPed(entity) then
				DeletePed(entity)
			elseif IsEntityAVehicle(entity) then
				DeleteVehicle(entity)
			elseif IsEntityAnObject(entity) then
				DeleteObject(entity)
			end

			gameTime = GetGameTimer()

			while DoesEntityExist(entity) and ((GetGameTimer() - gameTime) < 1) do
				Citizen.Wait(10)
			end

			if DoesEntityExist(entity) then
				SetEntityCoords(entity, vector3(10000.0, -1000.0, 10000.0), vector3(0.0, 0.0, 0.0), false)
			end
		end
	end
end

function CheckVehiclesAnticheat()
	while true do
		Citizen.Wait(10)

		for vehicle in EnumerateVehicles() do
			Citizen.Wait(0)
			local done = false

			if not done then
				local vehModel = GetEntityModel(vehicle)

				if ConfigAC.Vehicles[vehModel] then
					DeleteForceEntity(vehicle)
					done = true
				end
			end

			if not done then
				local handle = GetEntityScript(vehicle)
				if handle ~= nil then 
					if AutorizedRessourceSpawnVehicles[handle] == nil then
						DeleteForceEntity(vehicle)
					  	done = true
					  	--[[ TriggerServerEvent("sAc:banPlayer", {
							name = "createentity",
							title = "Création de véhicule non autorisé",
							description = "Création de véhicule non autorisé, véhicule : "..vehicle
						}) ]]
					end
				end
			end
		end
	end
end

function CheckPedsAnticheat()
	while true do
		Citizen.Wait(10)

		for ped in EnumeratePeds() do
			if not IsPedAPlayer(ped) then
				Citizen.Wait(0)
				local done = false
				if not done then
					local handle = GetEntityScript(ped)

					if handle ~= nil then
						if AutorizedRessourceSpawnVehicles[handle] == nil then
							DeleteForceEntity(ped)
							TriggerServerEvent("sAc:banPlayer", {
								name = "createentity",
								title = "Création de ped non autorisé",
								description = "Création de ped non autorisé, véhicule : "..ped
							})
						end
					end
				end
			end
		end
	end
end

Citizen.CreateThread(CheckVehiclesAnticheat)
Citizen.CreateThread(CheckPedsAnticheat)
