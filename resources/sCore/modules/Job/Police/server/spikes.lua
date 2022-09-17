local TireSpikeLastId = 0
local TireSpikes = {}

RegisterNetEvent("mmtirespikes:CreateSpike", function(data)
    local id = GetNewSpikeId()
    TireSpikes[id] = data
    TriggerClientEvent("mmtirespikes:CreateSpike", -1, id, data)
end)

RegisterNetEvent("mmtirespikes:RemoveSpike", function(id)
    TireSpikes[id] = nil
    TriggerClientEvent("mmtirespikes:RemoveSpike", -1, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem("spike", 1)
end)

RegisterNetEvent("mmtirespikes:GetMissingSpikes", function()
	TriggerClientEvent("mmtirespikes:GetMissingSpikes", source, TireSpikes)
end)

function GetNewSpikeId()
	if TireSpikeLastId < 65535 then
		TireSpikeLastId = TireSpikeLastId + 1
		return tostring(TireSpikeLastId)
	else
		TireSpikeLastId = 0
		return tostring(TireSpikeLastId)
	end
end

ESX.RegisterUsableItem('spike', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name ~= "police" or xPlayer.job.name ~= "lssd" then
        return
    end
	xPlayer.removeInventoryItem('spike', 1)
	TriggerClientEvent("SneakyLife:useSpikes", source)
	TriggerClientEvent('esx:showNotification', source, "Vous venez d'utiliser une ~b~herse~s~.")
end)