ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('noodle:announce')
AddEventHandler('noodle:announce', function(announce)
    local _src = source
	TriggerEvent("ratelimit", _src, "noodle:announce")
    local _source = source
    local announce = announce
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name ~= "noodle" then
        banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : annonce noodle",
			description = "Anticheat : annonce noodle"
		})
		return 
    end
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent("announce:noodlee",  xPlayers[i], announce)
    end
end)


local instances = {}
 
RegisterServerEvent("instancenoodle:reset")
AddEventHandler("instancenoodle:reset", function(set)
    local _src = source
	TriggerEvent("ratelimit", _src, "instancenoodle:reset")
    local src = source
    SetEntityRoutingBucket(src, set)
end)