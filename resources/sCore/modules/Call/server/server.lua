RegisterServerEvent("sCall:TookCallName")
AddEventHandler("sCall:TookCallName", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identity = GetIdentityServer(xPlayer.identifier)
	local name =  identity.firstname..' '..identity.lastname
	local xPlayers = ESX.GetPlayers()
 
	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == thePlayer.job.name then
			TriggerClientEvent("sCall:SendCallerNameService", xPlayers[i], "L'appel à été pris par ~g~"..name..".")
		end
	end
end)

RegisterServerEvent("sCall:SendCallMsg")
AddEventHandler("sCall:SendCallMsg", function(msg, coords, job, tel)
    local xPlayers = ESX.GetPlayers()
    local xSource = ESX.GetPlayerFromId(source)
    for k, v in pairs(xPlayers) do 
        local xPlayer = ESX.GetPlayerFromId(v)

        if xPlayer.job.name == job then
            xPlayer.triggerEvent("sCall:SendMessageCall", msg, coords, job, source, tel)
        end
    end
end)