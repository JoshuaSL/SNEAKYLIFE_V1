local DoorInfo = {}

RegisterServerEvent('lockedDoors:updateState')
AddEventHandler('lockedDoors:updateState', function(doorID, state, doorJob)
	local playerSrc = source
	if (not playerSrc) then return end

	local playerSelected = ESX.GetPlayerFromId(playerSrc)
	if (not playerSelected) then return end

	if Enterprise.Players[playerSelected["identifier"]] == nil then return end
    local enterpriseName = Enterprise.Players[playerSelected["identifier"]].my.name
	if enterpriseName ~= doorJob then return playerSelected.showNotification("~r~Vous n'avez pas les cléfs de cette porte.") end

	DoorInfo[doorID] = {}
	DoorInfo[doorID].state = state
	DoorInfo[doorID].doorID = doorID

	TriggerClientEvent('lockedDoors:setState', -1, doorID, state)
end)

ESX.RegisterServerCallback('lockedDoors:getDoorInfo', function(source, cb)
	local amount = 0

	for i = 1, #DoorLock.DoorList, 1 do
		amount = amount + 1
	end

	cb(DoorInfo, amount)
end)