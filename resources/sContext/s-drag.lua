RegisterServerEvent('sContext:drag')
AddEventHandler('sContext:drag', function(target)
	if target ~= -1 then
		TriggerClientEvent('sContext:dragclient', target, source)
	end
end)

RegisterServerEvent('sContext:GetServerIdPersonnage')
AddEventHandler('sContext:GetServerIdPersonnage', function(playerserverid)
	TriggerClientEvent('Sneakyesx:showNotification', source, "ID du personnage : ~b~"..playerserverid.."~s~")
end)