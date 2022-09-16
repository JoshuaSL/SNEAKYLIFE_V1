ESX = nil
TriggerEvent("Sneakyesx:getSharedObject", function(niceESX) ESX = niceESX end)

local terreActivity = {
    onService = {}
}

RegisterNetEvent("sTerreActivity:ChangeState")
AddEventHandler("sTerreActivity:ChangeState",function(state)
    local source = source
    terreActivity.onService[source] = state
end)

RegisterServerEvent('sTerreActivity:HarvestTerre')
AddEventHandler('sTerreActivity:HarvestTerre', function(item_name)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
    local count = math.random(1,3)
    if not terreActivity.onService[source] then return end
    if item_name ~= "terre" then
        banPlayerAC(xPlayer.source, {
			name = "createentity",
			title = "Give d'item : ("..item_name..")",
			description = "Give d'item : ("..item_name..")"
		})
    else
        if xPlayer.canCarryItem("terre", count) then
            xPlayer.addInventoryItem('terre', count)
            TriggerClientEvent('Sneakyesx:showNotification', source, "Vous avez récupéré ~b~"..count.." Terre~s~.")
        else
            TriggerClientEvent('Sneakyesx:showNotification', source, "~r~Vous ne pouvez pas prendre ça sur vous.")
        end
    end
end)

RegisterServerEvent('sTerreActivity:BrokenPelle')
AddEventHandler('sTerreActivity:BrokenPelle', function(item_name)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
    if not terreActivity.onService[source] then return end
    if item_name ~= "pelle" then
        banPlayerAC(xPlayer.source, {
			name = "createentity",
			title = "Give d'item : ("..item_name..")",
			description = "Give d'item : ("..item_name..")"
		})
    else
	    xPlayer.removeInventoryItem('pelle', 1)
    end
end)

RegisterServerEvent('sterreActivity:useCasserole')
AddEventHandler('sterreActivity:useCasserole', function()
    if not terreActivity.onService[source] then return end
    local total   = math.random(0, 99);
	local xPlayer = ESX.GetPlayerFromId(source)
    local Terre = xPlayer.getInventoryItem('terre').count
    if Terre >= 1 then
        if total >= 0 and total <= 40 then
            if xPlayer.canCarryItem("ors", 1) then
                TriggerClientEvent('Sneakyesx:showNotification', source, "Vous avez trouvé ~y~1 pépite d'or~s~ dans la terre.")
                xPlayer.removeInventoryItem('terre', 1)
                xPlayer.addInventoryItem('ors', 1)
            else
                TriggerClientEvent('Sneakyesx:showNotification', source, "~r~Vous ne pouvez pas prendre ça sur vous.")
            end
        elseif total >= 40 and total <= 80 then
            TriggerClientEvent('Sneakyesx:showNotification', source, "~r~Vous n'avez rien trouvé dans la terre.")
            xPlayer.removeInventoryItem('terre', 1)
        elseif total >= 80 and total <= 99 then
            if xPlayer.canCarryItem("ors", 2) then
                TriggerClientEvent('Sneakyesx:showNotification', source, "Vous avez trouvé ~y~2 pépites d'or~s~ dans la terre.")
                xPlayer.addInventoryItem('ors', 2)
                xPlayer.removeInventoryItem('terre', 1)
            else
                TriggerClientEvent('Sneakyesx:showNotification', source, "~r~Vous ne pouvez pas prendre ça sur vous.")
            end
        end
    end
end)

RegisterNetEvent("sTerreActivity:removeItem")
AddEventHandler("sTerreActivity:removeItem",function()
    local source = source
    if not terreActivity.onService[source] then return end
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem("casserole", 1)
end)

ESX.RegisterUsableItem('casserole', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local Terre = xPlayer.getInventoryItem('terre').count
    if Terre > 0 then
	    TriggerClientEvent('sTerreActivity:addCasserole', _source)
    else
        TriggerClientEvent('Sneakyesx:showNotification', source, "~r~Vous n'avez pas de terre sur vous.")
    end
end)

ESX.RegisterUsableItem('pelle', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('sTerreActivity:VerifPelle', _source)
end)