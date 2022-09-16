PoliceConnected = 0

function CountJobs()
    local xPlayers = ESX.GetPlayers()
    PoliceConnected = 0

    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' or xPlayer.job.name == "lssd" then
            PoliceConnected = PoliceConnected + 1
        end
    end

    SetTimeout(60000, CountJobs)
end

CountJobs()

local DeadPedsRobbery = {}

RegisterServerEvent('eSup:PedDeadRobbery')
AddEventHandler('eSup:PedDeadRobbery', function(store)
    if not DeadPedsRobbery[store] then
        DeadPedsRobbery[store] = 'dead'
        TriggerClientEvent('eSup:OnPedDeathRobbery', -1, store)
        local second = 1000
        local minute = 60 * second
        local hour = 60 * minute
        local cooldown = eSup.Braquage[store].cooldown
        local wait = cooldown.hour * hour + cooldown.minute * minute + cooldown.second * second
        Wait(wait)
        if not eSup.Braquage[store].robbed then
            for k, v in pairs(DeadPedsRobbery) do 
                if k == store then 
                    table.remove(DeadPedsRobbery, k) 
                end 
            end
            TriggerClientEvent('eSup:ResetPedDeath', -1, store)
        end
    end
end)

RegisterServerEvent('eSup:PickupRobbery')
AddEventHandler('eSup:PickupRobbery', function(store, numbers)
	if store == nil or store.coords == nil then 
		DropPlayer(source, 'Desynchronisation avec le serveur.')
	else
		if #(GetEntityCoords(GetPlayerPed(source))-store.coords) > 10.0 then
			DropPlayer(source, 'Desynchronisation avec le serveur.')
		else
			local xPlayer = ESX.GetPlayerFromId(source)
			local randomAmount = math.random(eSup.BraquageWin.Minimum, eSup.BraquageWin.Maximum)
			xPlayer.addAccountMoney('cash', randomAmount)
			xPlayer.showNotification("Vous avez récupéré ~g~".. randomAmount .."$~s~.")
			TriggerClientEvent('eSup:RemovePickupRobbery', -1, numbers) 
		end
	end
end)

ESX.RegisterServerCallback('eSup:CanRobbery', function(source, cb, store)
    if PoliceConnected >= eSup.Braquage[store].cops then
        if not eSup.Braquage[store].robbed and not DeadPedsRobbery[store] then
            cb(true)
        else
            cb(false)
        end
    else
        cb('no_cops')
    end
end)

RegisterServerEvent('eSup:RobberyStart')
AddEventHandler('eSup:RobberyStart', function(store)
    local src = source
    eSup.Braquage[store].robbed = true
    local xPlayers = ESX.GetPlayers()

    TriggerClientEvent('eSup:RobberyStart', -1, store)
    Wait(30000)
    TriggerClientEvent('eSup:RobberyStartOver', src)

    local second = 1000
    local minute = 60 * second
    local hour = 60 * minute
    local cooldown = eSup.Braquage[store].cooldown
    local wait = cooldown.hour * hour + cooldown.minute * minute + cooldown.second * second
    Wait(wait)
    eSup.Braquage[store].robbed = false
    for k, v in pairs(DeadPedsRobbery) do 
        if k == store then 
            table.remove(DeadPedsRobbery, k) 
        end 
    end
    TriggerClientEvent('eSup:ResetPedDeath', -1, store)
end)

Citizen.CreateThread(function()
    while true do
        for i = 1, #DeadPedsRobbery do 
            TriggerClientEvent('eSup:PedDeadRobbery', -1, i) 
        end
        Citizen.Wait(500)
    end
end)