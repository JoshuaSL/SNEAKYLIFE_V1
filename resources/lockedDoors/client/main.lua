CreateThread(function()
	ESX.TriggerServerCallback('lockedDoors:getDoorInfo', function(doorInfo, doorCount)
		for localID = 1, doorCount do
			if doorInfo[localID] ~= nil then
				DoorLock.DoorList[doorInfo[localID].doorID].locked = doorInfo[localID].state
			end
		end
	end)
end)


CreateThread(function()
	PinInteriorInMemory(GetInteriorAtCoords(440.84, -983.14, 30.69))

	while true do
		Wait(0)
		local plyCoords = GetEntityCoords(PlayerPedId(), false)

		for i = 1, #DoorLock.DoorList do
			local theDoor = DoorLock.DoorList[i]

			if GetDistanceBetweenCoords(plyCoords, theDoor.objCoords, true) < theDoor.distance then
				if IsControlJustReleased(0, 38) then
					local myEnterprise = CheckDataEnterpise()
            		if myEnterprise == nil then return ESX.ShowNotification("Vous n'avez pas les cléfs de cette porte") end

                	if (myEnterprise.my["name"] == theDoor.job) then
						theDoor.locked = not theDoor.locked
						if theDoor.locked == true then
							ESX.ShowNotification("Vous avez ~r~fermer~s~ la porte.")
						else
							ESX.ShowNotification("Vous avez ~g~ouvert~s~ la porte.")
						end
						TriggerServerEvent('lockedDoors:updateState', i, theDoor.locked, theDoor.job)
					else
						ESX.ShowNotification("~r~Vous n'avez pas les clés de cette porte.")
					end
				end

				FreezeEntityPosition(GetClosestObjectOfType(theDoor.objCoords, 1.0, theDoor.objName, false, false, false), theDoor.locked)
			end
		end
	end
end)

RegisterNetEvent('lockedDoors:setState')
AddEventHandler('lockedDoors:setState', function(doorID, state)
	if type(DoorLock.DoorList[id]) ~= nil then
		DoorLock.DoorList[doorID].locked = state
	end
end)