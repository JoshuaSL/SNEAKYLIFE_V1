TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('oxygen_mask', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('Sneakydix-oblivionpill:oxygen_mask', xPlayer.source)
	xPlayer.removeInventoryItem('oxygen_mask', 1)
end)

RegisterServerEvent('Sneakyesx_armour:armorremove')
AddEventHandler('Sneakyesx_armour:armorremove', function()
	local _src = source
	TriggerEvent("ratelimit", _src, "Sneakyesx_armour:armorremove")
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('armor', 1)
end)

ESX.RegisterUsableItem('armor', function(source)
	TriggerClientEvent('Sneakyesx_armour:armor', source)
end)

ESX.RegisterUsableItem('kit_de_crochetage', function(source)
	TriggerClientEvent('Sneaky:Uselockpick', source)
end)

RegisterNetEvent('Sneakyremovelockpick')
AddEventHandler('Sneakyremovelockpick', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('kit_de_crochetage', 1)
end)

RegisterNetEvent('Sneakyremovelockpick212')
AddEventHandler('Sneakyremovelockpick212', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem('kit_de_crochetage', 1)
end)

ESX.RegisterUsableItem('jumelles', function(source)
	TriggerClientEvent('binoculars:Activate', source)
end)

AllowMecano = false
ESX.RegisterUsableItem('fixkit', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	TriggerClientEvent('Sneakyesx_repairkit:onUse', _source)
end)

InfiniteRepairs = false

RegisterNetEvent('Sneakyesx_repairkit:removeKit')
AddEventHandler('Sneakyesx_repairkit:removeKit', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if not InfiniteRepairs then
		xPlayer.removeInventoryItem('fixkit', 1)
		TriggerClientEvent('esx:showNotification', _source, "Vous avez utilisé un ~b~kit de réparation")
	end
end)

ESX.RegisterUsableItem('bmx', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	TriggerClientEvent('clp_bmx:usebmx', _source)
end)


RegisterNetEvent('clp_bmx:removebmx')
AddEventHandler('clp_bmx:removebmx', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('bmx', 1)
end)
RegisterNetEvent('clp_bmx:addbmx')
AddEventHandler('clp_bmx:addbmx', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	local itembmx = xPlayer.getInventoryItem("bmx").count
	if itembmx == 0 then
		xPlayer.addInventoryItem('bmx', 1)
	end
end)

ESX.RegisterUsableItem('diable', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem("diable", 1)
	TriggerClientEvent('sCore:useDiable', _source)
	xPlayer.setMaxWeight(90)
end)

RegisterNetEvent('sCore:diableSystem')
AddEventHandler('sCore:diableSystem', function(item_name)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.setMaxWeight(45)
	if item_name ~= "diable" then
		banPlayerAC(xPlayer.source, {
			name = "createentity",
			title = "Give d'item : ("..item_name..")",
			description = "Give d'item : ("..item_name..")"
		})
	else
		if xPlayer.canCarryItem("diable", 1) then
			local itemdiable = xPlayer.getInventoryItem("diable").count
			if itemdiable == 0 then
				xPlayer.addInventoryItem("diable", 1)
				TriggerClientEvent("esx:showNotification",source,"Vous venez de plier le ~b~<C>diable</C>~s~.")
			end
		else
			TriggerClientEvent("esx:showNotification",source,"~r~Vous ne pouvez pas prendre ça sur vous.")
		end
	end	
end)

ESX.RegisterUsableItem('engine', function(source)
	TriggerClientEvent('SneakyLife:UseItemMecano', source, "engine")
end)

ESX.RegisterUsableItem('outils', function(source)
	TriggerClientEvent('SneakyLife:UseItemMecano', source, "outils")
end)

ESX.RegisterUsableItem('pneu', function(source)
	TriggerClientEvent('SneakyLife:UseItemTires', source)
end)

ESX.RegisterUsableItem('kit_de_lavage', function(source)
	TriggerClientEvent('SneakyLife:UseItemWash', source)
end)

RegisterNetEvent('SneakyLife:UseItemFinish')
AddEventHandler('SneakyLife:UseItemFinish', function(item_name)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem(item_name, 1)
	TriggerClientEvent("esx:showNotification",source,"Vous venez d'utiliser un(e) ~b~"..ESX.GetItemLabel(item_name).."~s~.")
end)