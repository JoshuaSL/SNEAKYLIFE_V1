ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('BarberShop:Buy')
AddEventHandler('BarberShop:Buy', function(type, price)
	local _src = source
	TriggerEvent("ratelimit", _src, "BarberShop:Buy")
	local price = 100
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getAccount('cash').money >= price then
		xPlayer.removeAccountMoney('cash', price)
		SendLogs(15105570,"Barbier - Achat","**"..GetPlayerName(source).."** vient de payer ***"..price.."$ ***\n **License** : "..xPlayer.identifier,"https://canary.discord.com/api/webhooks/841147836912893982/c_w9L_zBCr_Uktt6rQmvyMUbXwE2C4M-b1a5UrXp53KSBbhI2aTYPhN7sqEZqpbpA05N")
		xPlayer.showNotification('Vous avez payé ~g~'..price..' $~s~ au barbier')
		TriggerClientEvent('BarberShop:CheckBuy', xPlayer.source, 'yes')
	else
		xPlayer.showNotification('~r~Vous n\'avez pas assez d\'argent pour payer le barbier')
	end
end)