local playerCars = {}
local KeyFobHash = `p_car_keys_01`
local notifID = false
local NotifDontOwner = false
function AddLongString(txt)
	local maxLen = 100
	for i = 0, string.len(txt), maxLen do
		local sub = string.sub(txt, i, math.min(i + maxLen, string.len(txt)))
		AddTextComponentSubstringPlayerName(sub)
	end
end

function ShowAboveRadarMessage(message, back)
	if back then ThefeedNextPostBackgroundColor(back) end
	BeginTextCommandThefeedPost("jamyfafi")
	AddLongString(message)
	return EndTextCommandThefeedPostTicker(0, 1)
end

function OpenCloseVehicle()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, false)
	local vehicle, inveh = nil, false
	if IsPedInAnyVehicle(playerPed, false) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
		inveh = true
	else
		vehicle = GetClosestVehicle(coords, 7.0, 0, 71)
	end
	ESX.TriggerServerCallback('Sneakyesx_vehiclelock:mykey', function(gotkey)
		if gotkey then
			local locked = GetVehicleDoorLockStatus(vehicle)
			if not inveh then
				local plyPed = PlayerPedId()
				ESX.Streaming.RequestAnimDict("anim@mp_player_intmenu@key_fob@")
				ESX.Game.SpawnObject(KeyFobHash, vector3(0.0, 0.0, 0.0), function(object)
					SetEntityCollision(object, false, false)
					AttachEntityToEntity(object, plyPed, GetPedBoneIndex(plyPed, 57005), 0.09, 0.03, -0.02, -76.0, 13.0, 28.0, false, true, true, true, 0, true)
					SetCurrentPedWeapon(plyPed, 'WEAPON_UNARMED', true)
					ClearPedTasks(plyPed)
					TaskTurnPedToFaceEntity(plyPed, vehicle, 500)
					TaskPlayAnim(plyPed, "anim@mp_player_intmenu@key_fob@", "fob_click", 3.0, 3.0, 1000, 16)
					RemoveAnimDict("anim@mp_player_intmenu@key_fob@")
					PlaySoundFromEntity(-1, "Remote_Control_Fob", vehicle, "PI_Menu_Sounds", true, 0)
					Citizen.Wait(1250)
					DetachEntity(object, false, false)
					DeleteObject(object)
				end)
			end
			if locked == 1 or locked == 0 then
				SetVehicleDoorsLocked(vehicle, 2)
				PlayVehicleDoorCloseSound(vehicle, 1)
				labelnotif = "~r~verouillé(e)~s~"
			elseif locked == 2 then
				SetVehicleDoorsLocked(vehicle, 1)
				PlayVehicleDoorOpenSound(vehicle, 0)
				labelnotif = "~g~déverrouillé(e)~s~"
			end
			if notifID then ThefeedRemoveItem(notifID) end
			notifID = ShowAboveRadarMessage(string.format("Vous avez "..labelnotif.." votre véhicule."))
			SetTimeout(6000, function() 
				if notifID then 
					ThefeedRemoveItem(notifID) 
				end 
			end)
		else
			if NotifDontOwner then
				ThefeedRemoveItem(NotifDontOwner)
			end
			NotifDontOwner = ShowAboveRadarMessage("~r~Vous n'avez pas les clés de ce véhicule.")
		end
	end,ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)))
end

Keys.Register('U','U', 'Ouvrir votre véhicule', function()
	if not exports.phone:GetStatePhone() and not exports.inventaire:GetStateInventory() and not GetStateFishing() then
     	OpenCloseVehicle()
	end
 end)