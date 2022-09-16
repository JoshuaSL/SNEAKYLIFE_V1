ESX = nil

TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('bahamas:announce')
AddEventHandler('bahamas:announce', function(announce)
    local _src = source
	TriggerEvent("ratelimit", _src, "bahamas:announce")
    local _source = source
    local announce = announce
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name ~= "bahamas" then
        banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : buy item",
			description = "Anticheat : buy item"
		})
		return
    end
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent("announce:bahamas",  xPlayers[i], announce)
    end
end)

