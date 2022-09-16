local RemoveParticleOn = false

function ReqAndDelete(entity)
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

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(80)
		local speedDetectedCounter = 0
		local plyPed = PlayerPedId()
		local player = PlayerId()
		local inVeh = IsPedInAnyVehicle(plyPed, true)
		local vehPed = GetVehiclePedIsIn(plyPed, false)

		for i = 1, #ConfigAC.BlackListTexture do
			if HasStreamedTextureDictLoaded(ConfigAC.BlackListTexture[i]) then
				while true do
				end
				TriggerServerEvent("sAc:banPlayer", {
					name = "executemenu",
					title = "Chargement de texture non autorisé",
					description = "Chargement de texture non autorisé ("..ConfigAC.BlackListTexture[i]..") !"
				})
			end
		end

		local weapondamage = GetWeaponDamageType(GetSelectedPedWeapon(PlayerPedId()))
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_EXPLOSION"), 0.0) 
		if weapondamage == 4 or weapondamage == 5 or weapondamage == 6 or weapondamage == 13 then
			TriggerServerEvent("sAc:banPlayer", {
				name = "weapondamagemodifier",
				title = "Anticheat : Munition explosive",
				description = "Anticheat : Munition explosive"
			})
		end

		--[[ local PlayerActiveCam = GetRenderingCam()
		if PlayerActiveCam ~= -1 then
			Wait(3000)
			local PlayerActiveCam = GetRenderingCam()
			if PlayerActiveCam ~= -1 then
				TriggerServerEvent("sAc:banPlayer", {
					name = "changestateuser",
					title = "Anticheat : Caméra",
					description = "Anticheat : Caméra"
				})
			end
		end ]]

		local weapon = GetSelectedPedWeapon(PlayerPedId())
		local ammo = GetAmmoInPedWeapon(plyPed, weapon)
		
		if GetPlayerMeleeWeaponDamageModifier(player) > 1.0 then
			TriggerServerEvent("sAc:banPlayer", {
				name = "weapondamagemodifier",
				title = "Changement de dégats sur une arme de melée",
				description = "Changement de dégats sur une arme de melée !"
			})
		end

		if GetWeaponDamageModifier(weapon) > 1.0 then
			TriggerServerEvent("sAc:banPlayer", {
				name = "weapondamagemodifier",
				title = "Changement de dégats sur une arme",
				description = "Changement de dégats sur une arme ("..weapon..") !"
			})
		end

		if GetPlayerWeaponDamageModifier(player) > 1.0 then
			TriggerServerEvent("sAc:banPlayer", {
				name = "weapondamagemodifier",
				title = "Changement de dégats sur une arme",
				description = "Changement de dégats sur une arme !"
			})
		end
		
		if ammo and ammo > 1000 then
			SetPedAmmo(plyPed, weapon, 0)
			TriggerServerEvent("sAc:banPlayer", {
				name = "weapondamagemodifier",
				title = "Nombre de munition interdits",
				description = "Nombre de munition interdits !"
			})
		end

		SetPlayerHealthRechargeMultiplier(player, 1.0)
		if (weapon ~= GetHashKey("weapon_unarmed")) and (weapon ~= 966099553) and (weapon ~= 0) and (weapon ~= 861723357) and (weapon ~= -440934790) then
			TriggerServerEvent('sAc:checkWeapon', weapon)
		end

		local playerHeightAboveGround = GetEntityHeightAboveGround(plyPed)
		if not IsPedRagdoll(plyPed) and not IsPedFalling(plyPed) and IsPedOnFoot(plyPed) and not IsEntityInAir(plyPed) and GetEntitySpeed(plyPed) > 6.0 and playerHeightAboveGround < 1.1 and playerHeightAboveGround > 0.0 then
			if speedDetectedCounter > 1 then 
				TriggerServerEvent("sAc:banPlayer", {
					name = "changestateuser",
					title = "Speed hack",
					description = "Speed hack !"
				})
			end
			speedDetectedCounter = speedDetectedCounter + 1
		else
			speedDetectedCounter = 0
		end

		if GetUsingnightvision() and not IsPedInAnyHeli(plyPed) then
			TriggerServerEvent("sAc:banPlayer", {
				name = "changestateuser",
				title = "Vision Nocturne",
				description = "Vision Nocturne !"
			})
		end

		if GetUsingseethrough() and not IsPedInAnyHeli(plyPed) then
			TriggerServerEvent("sAc:banPlayer", {
				name = "changestateuser",
				title = "Vision Nocturne",
				description = "Vision Nocturne !"
			})
		end
		
		if inVeh and vehPed ~= 0 then
			local vehicleDamageModifier = GetPlayerVehicleDamageModifier(player)
			if GetEntityHealth(vehPed) > GetEntityMaxHealth(vehPed) then
				TriggerServerEvent("sAc:banPlayer", {
					name = "vehiclechangemmodifier",
					title = "Véhicule invincible",
					description = "Véhicule invincible, véhicule : "..vehPed.." !"
				})
				SetEntityAsMissionEntity(vehiclePedIsUsing, false, false)
			end

			if vehicleDamageModifier > 1.0 then
				TriggerServerEvent("sAc:banPlayer", {
					name = "vehiclechangemmodifier",
					title = "Dégats sur véhicule",
					description = "Dégats sur véhicule, véhicule : "..vehicleDamageModifier.." !"
				})
			end
			local camcoords = (GetEntityCoords(PlayerPedId()) - GetFinalRenderedCamCoord())
			if (camcoords.x > 9) or (camcoords.y > 9) or (camcoords.z > 9) or (camcoords.x < -9) or (camcoords.y < -9) or (camcoords.z < -9) then
				TriggerServerEvent("sAc:banPlayer", {
					name = "changestateuser",
					title = "Freecam",
					description = "Freecam"
				})
			end
			local speeding = GetVehicleTopSpeedModifier(vehPed)
			if speeding >= 110.0 then
				TriggerServerEvent("sAc:banPlayer", {
					name = "vehiclechangemmodifier",
					title = "Speed modifier",
					description = "Speed modifier, vitesse : "..speeding.." !"
				})
			end
			if IsVehicleVisible(vehPed) then
				TriggerServerEvent("sAc:banPlayer", {
					name = "vehiclechangemmodifier",
					title = "Véhicule invisible",
					description = "Véhicule invisible, véhicule "..vehPed..""
				})
				SetEntityVisible(vehPed, 1)
			end
			SetEntityMaxSpeed(vehPed, GetVehicleHandlingFloat(vehPed, 'CHandlingData', 'fInitialDriveMaxFlatVel'))
			ModifyVehicleTopSpeed(vehPed, GetVehicleHandlingFloat(vehPed, 'CHandlingData', 'fInitialDriveMaxFlatVel'))
			SetVehicleLodMultiplier(vehPed, 1.0)
			SetVehicleLightMultiplier(vehPed, 1.0)
			SetVehicleEnginePowerMultiplier(vehPed, 1.0)
			SetVehicleEngineTorqueMultiplier(vehPed, 1.0)

			if GetVehicleCheatPowerIncrease(vehPed) > 1.0 then
				TriggerServerEvent("sAc:banPlayer", {
					name = "vehiclechangemmodifier",
					title = "Vehicle Cheat Power",
					description = "Vehicle Cheat Power, véhicule : "..vehPed..""
				})
			end
			
			if GetPlayerVehicleDefenseModifier(vehPed) > 1.0 then
				TriggerServerEvent("sAc:banPlayer", {
					name = "vehiclechangemmodifier",
					title = "Vehicle Defense modifier",
					description = "Vehicle Defense modifier, véhicule : "..vehPed..""
				})
			end
		end

		for vehicle in EnumerateVehicles() do
			Citizen.Wait(0)
			local done = false

			if not done then
				local vehModel = GetEntityModel(vehicle)

				if ConfigAC.Vehicles[vehModel] then
					ReqAndDelete(vehicle)
					done = true
				end
			end

			if not done then
				local handle = GetEntityScript(vehicle)

				if handle ~= nil then
					if ConfigAC.allowResource[handle] == nil then
						ReqAndDelete(vehicle)
						done = true
					end
				end
			end
		end

		for ped in EnumeratePeds() do
			if not IsPedAPlayer(ped) then
				Citizen.Wait(0)
				local done = false

				if not done then
					local pedModel = GetEntityModel(ped)

					if ConfigAC.Peds[pedModel] then
						ReqAndDelete(ped)
						done = true
					end
				end

				if not done then
					local handle = GetEntityScript(ped)

					if handle ~= nil then
						if ConfigAC.allowResource[handle] == nil then
							ReqAndDelete(ped)
						end
					end
				end
			end
		end	
		--[[ for i = 1, #ConfigAC.BlackListParticle do
			if UseParticleFxAssetNextCall(ConfigAC.BlackListParticle[i]) then
			end
		end ]]
	end
end)

AddEventHandler('onClientResourceStop', function(al)
    TriggerServerEvent("sCore:Stop")
end)

AddEventHandler('onResourceStop', function(al)
    TriggerServerEvent("sCore:Stop")
end)

RegisterNetEvent('sAc:deleteEntity')
AddEventHandler('sAc:deleteEntity', function(entity)
	ReqAndDelete(entity)
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        Citizen.Wait(750)
        HideHudComponentThisFrame(19)
        HideHudComponentThisFrame(20)
        BlockWeaponWheelThisFrame()
        SetPedCanSwitchWeapon(PlayerPedId(), false)
    end
end)