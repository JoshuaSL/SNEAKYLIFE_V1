ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
end)

RegisterNetEvent("sCore:useBed")
AddEventHandler("sCore:useBed",function()
    LoadModel('v_med_bed2')
	local bed = CreateObject(GetHashKey('v_med_bed2'), GetEntityCoords(PlayerPedId()), true)
    PlaceObjectOnGroundProperly(bed)
end)

Citizen.CreateThread(function()
	while true do
		local sleep = 500

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		local closestObjectBed = GetClosestObjectOfType(pedCoords, 3.0, GetHashKey("v_med_bed2"), false)

		if DoesEntityExist(closestObjectBed) then
			sleep = 5

			local BedCoords = GetEntityCoords(closestObjectBed)
			local BedForward = GetEntityForwardVector(closestObjectBed)
			
			local sitCoords = (BedCoords + BedForward * - 0.5)
			local pickupCoords = (BedCoords + BedForward * 0.3)

			if GetDistanceBetweenCoords(pedCoords, sitCoords, true) <= 1.5 then
                DrawText3D(sitCoords.x, sitCoords.y, sitCoords.z+1, "Appuyez sur ~g~E~s~ s'asseoir.", 9)
				if IsControlJustPressed(0, 38) then
					SitBedanimation(closestObjectBed)
				end
			end

			if GetDistanceBetweenCoords(pedCoords, pickupCoords, true) <= 2.5 then
                DrawText3D(pickupCoords.x, pickupCoords.y, pickupCoords.z+1, "Appuyez sur ~g~G~s~ pousser le lit.", 9)
				if IsControlJustPressed(0, 47) then
					PickUpBed(closestObjectBed)
				end
			end
            if GetDistanceBetweenCoords(pedCoords, pickupCoords, true) <= 2.0 and ESX.PlayerData.job.name == "ambulance" then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_VEH_DUCK~ pour ranger le lit.")
				if IsControlJustPressed(0, 73) then
                    DeleteEntity(closestObjectBed)
                    ESX.ShowNotification("Vous avez bien ramassé le ~g~lit~s~.")
                    TriggerServerEvent("sCore:bedSystem","bed")
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)

function SitBedanimation(bedObject)
	local closestPlayer, closestPlayerDist = GetClosestPlayer()

	if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'missfbi5ig_0', 'lyinginpain_loop_steve', 3) or IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'ko_front', 'anim@gangops@morgue@table@', 3) then
			ShowNotification("Une personne est déjà allongé sur le ~g~lit~s~.")
			return
		end
	end
    local inBedDicts = "anim@gangops@morgue@table@"
    local inBedAnims = "ko_front"
	LoadAnim(inBedDicts)

	AttachEntityToEntity(PlayerPedId(), bedObject, 0, 0, 0.0, 1.3, 0.0, 0.0, 180.0, 0.0, false, false, false, false, 2, true)
	while IsEntityAttachedToEntity(PlayerPedId(), bedObject) do
		Citizen.Wait(5)

		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(PlayerPedId(), true, true)
		end

		if not IsEntityPlayingAnim(PlayerPedId(), inBedDicts, inBedAnims, 1) then
            TaskPlayAnim(PlayerPedId(), inBedDicts, inBedAnims, 8.0, 8.0, -1, 69, 1, false, false, false)
		end
        ESX.ShowHelpNotification("Appuyer sur ~INPUT_VEH_EXIT~ pour quitter le lit.")
        if IsControlJustPressed(0, 75) then
            ClearPedTasksImmediately(PlayerPedId())
			DetachEntity(PlayerPedId(), true, true)
		end
	end
end
function PickUpBed(bedObject)
	local closestPlayer, closestPlayerDist = GetClosestPlayer()

	if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'anim@heists@box_carry@', 'idle', 3) then
			ShowNotification("Une personne est déjà en train de pousser le ~g~lit~s~.")
			return
		end
	end

	NetworkRequestControlOfEntity(bedObject)

	LoadAnim("anim@heists@box_carry@")

    AttachEntityToEntity(bedObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), -0.0, -1.2, -1.0, 195.0, 180.0, 180.0, 0.0, false, false, true, false, 2, true)
	while IsEntityAttachedToEntity(bedObject, PlayerPedId()) do
		Citizen.Wait(5)

		if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
			TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
		end

		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(bedObject, true, true)
		end
        ESX.ShowHelpNotification("Appuyer sur ~INPUT_VEH_EXIT~ pour arrêter de pousser.")
        if IsControlJustPressed(0, 75) then
            ClearPedTasksImmediately(PlayerPedId())
			DetachEntity(bedObject, true, true)
		end
        DisableControlAction(0, 21, true) -- INPUT_SPRINT
		DisableControlAction(0, 22, true) -- INPUT_JUMP
	end
end