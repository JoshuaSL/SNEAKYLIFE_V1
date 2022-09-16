dragStatus        = {}
dragStatus.isDragged = false

RegisterNetEvent('sContext:dragclient')
AddEventHandler('sContext:dragclient', function(copId)
	if IsPedRagdoll(PlayerPedId()) or dragStatus.isDragged then
		dragStatus.isDragged = not dragStatus.isDragged
		dragStatus.CopId = copId
	end
end)

Citizen.CreateThread(function()
	local playerPed
	local targetPed

	while true do
		Citizen.Wait(1)
		playerPed = PlayerPedId()
		if dragStatus.isDragged then
			targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))
			if not IsPedSittingInAnyVehicle(targetPed) then
				AttachEntityToEntity(PlayerPedId(), targetPed, 11816, 0, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
			else
				dragStatus.isDragged = false
				DetachEntity(playerPed, true, false)
			end
			if IsPedDeadOrDying(targetPed, true) then
				dragStatus.isDragged = false
				DetachEntity(playerPed, true, false)
			end
		else
			DetachEntity(playerPed, true, false)
		end
	end
end)