ESX = nil

TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('unicorn:announce')
AddEventHandler('unicorn:announce', function(announce)
    local _src = source
	TriggerEvent("ratelimit", _src, "unicorn:announce")
    local _source = source
    local announce = announce
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name ~= "unicorn" then
        banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : annonce unicorn",
			description = "Anticheat : annonce unicorn"
		})
		return 
    end
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent("announce:unicorn",  xPlayers[i], announce)
    end
end)


local instances = {}
 
RegisterServerEvent("instanceunicorn:reset")
AddEventHandler("instanceunicorn:reset", function(set)
    local _src = source
	TriggerEvent("ratelimit", _src, "instanceunicorn:reset")
    local src = source
    exports.pmavoice:updateRoutingBucket(src,set)
end)