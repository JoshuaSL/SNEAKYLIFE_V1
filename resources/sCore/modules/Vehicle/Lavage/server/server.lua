ESX = nil

TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('Lavage:buy', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 100
    if xPlayer.getAccount('cash').money >= price then
		xPlayer.removeAccountMoney('cash', price)
        SendLogs(15105570,"Lavage - Achat","**"..GetPlayerName(source).."** vient d'acheter pour ***"..price.."$ ***\n **License** : "..xPlayer.identifier,"https://canary.discord.com/api/webhooks/873265801174601758/o5VaIufLrqvODH5xDmYOmggHcmXiyF4Gwz9mTBsVAPlTg90myulS02J_JWzB0R8xI4fe")
		cb(true)
	else
		cb(false)
	end
end)