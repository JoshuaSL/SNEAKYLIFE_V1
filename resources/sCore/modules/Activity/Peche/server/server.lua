ESX = nil
TriggerEvent("Sneakyesx:getSharedObject", function(niceESX) ESX = niceESX end)

local fishActivity = {
    onService = {}
}

RegisterNetEvent("sFish:ChangeState")
AddEventHandler("sFish:ChangeState",function(state)
    local source = source
    fishActivity.onService[source] = state
end)

RegisterServerEvent("Peche:givefish")
AddEventHandler("Peche:givefish", function()
    local chance = math.random(0, 99);
    local xPlayer = ESX.GetPlayerFromId(source)
    if not fishActivity.onService[source] then
        banPlayerAC(xPlayer.source, {
			name = "createentity",
			title = "Give d'item : (pêche)",
			description = "Give d'item : (pêche)"
		})
        return 
    end
    if chance >= 0 and chance <= 18 then
        if xPlayer.canCarryItem("whitefish", 1) then
            xPlayer.addInventoryItem('whitefish', 1)
            TriggerClientEvent('Sneakyesx:showNotification', source, 'Vous avez pêché un ~g~Poisson blanc.~b~ +1')
        else
            TriggerClientEvent("Sneakyesx:showNotification", source, "~r~Vous n'avez pas assez de place.")
        end
    elseif chance >= 18 and chance <= 37 then
        if xPlayer.canCarryItem("fish", 1) then
            xPlayer.addInventoryItem('fish', 1)
            TriggerClientEvent('Sneakyesx:showNotification', source, 'Vous avez pêché un ~g~Poisson.~b~ +1')
        else
            TriggerClientEvent("Sneakyesx:showNotification", source, "~r~Vous n'avez pas assez de place.")
        end
    elseif chance >= 37 and chance <= 53 then
        if xPlayer.canCarryItem("redfish", 1) then
            xPlayer.addInventoryItem('redfish', 1)
            TriggerClientEvent('Sneakyesx:showNotification', source, 'Vous avez pêché un ~g~Poisson rouge.~b~ +1')
        else
            TriggerClientEvent("Sneakyesx:showNotification", source, "~r~Vous n'avez pas assez de place.")
        end
    elseif chance >= 53 and chance <= 68 then
        if xPlayer.canCarryItem("fishd", 1) then
            xPlayer.addInventoryItem('fishd', 1)
            TriggerClientEvent('Sneakyesx:showNotification', source, 'Vous avez pêché un ~g~Poisson abattu.~b~ +1')
        else
            TriggerClientEvent("Sneakyesx:showNotification", source, "~r~Vous n'avez pas assez de place.")
        end
    elseif chance >= 68 and chance <= 85 then
        if xPlayer.canCarryItem("carpecuir", 1) then
            xPlayer.addInventoryItem('carpecuir', 1)
            TriggerClientEvent('Sneakyesx:showNotification', source, 'Vous avez pêché une ~g~Carpe cuir.~b~ +1')
        else
            TriggerClientEvent("Sneakyesx:showNotification", source, "~r~Vous n'avez pas assez de place.")
        end
    elseif chance >= 85 and chance <= 99 then
        if xPlayer.canCarryItem("pompom", 1) then
            xPlayer.addInventoryItem('pompom', 1)
            TriggerClientEvent('Sneakyesx:showNotification', source, 'Vous avez pêché un ~g~Poisson pompom.~b~ +1')
        else
            TriggerClientEvent("Sneakyesx:showNotification", source, "~r~Vous n'avez pas assez de place.")
        end
    end
end)

RegisterServerEvent("sFish:BrokeCanne")
AddEventHandler("sFish:BrokeCanne", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem("canne_peche", 1)
end)

ESX.RegisterUsableItem('canne_peche', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent("sFishing:usePêche", source)
end)