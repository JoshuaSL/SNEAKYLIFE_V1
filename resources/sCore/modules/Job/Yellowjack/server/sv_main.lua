ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('yellowjack:announce')
AddEventHandler('yellowjack:announce', function(announce)
    local _src = source
	TriggerEvent("ratelimit", _src, "yellowjack:announce")
    local _source = source
    local announce = announce
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name ~= "yellowjack" then
        banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : annonce yellowjack",
			description = "Anticheat : annonce yellowjack"
		})
		return 
    end
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent("announce:yellowjack",  xPlayers[i], announce)
    end
end)


local instances = {}
 
RegisterServerEvent("instanceyellowjack:reset")
AddEventHandler("instanceyellowjack:reset", function(set)
    local _src = source
	TriggerEvent("ratelimit", _src, "instanceyellowjack:reset")
    local src = source
    exports["pma-voice"]:updateRoutingBucket(src,set)
end)

