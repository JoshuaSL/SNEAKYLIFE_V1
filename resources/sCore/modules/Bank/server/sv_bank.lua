ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('SneakyLife:solde')
AddEventHandler('SneakyLife:solde', function(action , amount)
    local _src = source
    TriggerEvent("ratelimit", _src, "SneakyLife:solde")
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local bankMoney = xPlayer.getAccount('bank').money
    TriggerClientEvent("SneakyLife:GetSoldAccount",source,bankMoney)
end)

RegisterServerEvent('SneakyLife:deposit')
AddEventHandler('SneakyLife:deposit', function(money)
    local _src = source
    TriggerEvent("ratelimit", _src, "SneakyLife:deposit")
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xMoney = xPlayer.getAccount('cash').money
    if xMoney >= money then
        xPlayer.addAccountMoney('bank',money)
        SendLogs(3066993,"Banque - Dépot","**"..GetPlayerName(_source).."** vient de déposer ***"..money.."$ ***\n **License** : "..xPlayer.identifier,"https://canary.discord.com/api/webhooks/841152095448858694/EUA1uMvwM0AiCP-I7bbWxcN-4xXVYbp_DaVNKi6JxEh5y8MbSbFoAMfGKbYNK8hTW7XG")
        xPlayer.removeAccountMoney('cash', money)
        TriggerClientEvent('esx:showAdvancedNotification', source, 'Banque', '~g~Compte bancaire', "Vous avez deposé ~g~"..money.."$~s~ sur votre compte", 'CHAR_BANK_FLEECA', 9)
    else
        TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas assez d\'argent~s~ !")
    end
end)

RegisterServerEvent('SneakyLife:withdraw')
AddEventHandler('SneakyLife:withdraw', function(money)
    local _src = source
    TriggerEvent("ratelimit", _src, "SneakyLife:withdraw")
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xMoney = xPlayer.getAccount('bank').money
    if xMoney >= money then
        xPlayer.removeAccountMoney('bank', money)
        xPlayer.addAccountMoney('cash',money)
        SendLogs(3066993,"Banque - Retrait","**"..GetPlayerName(_source).."** vient de retirer ***"..money.."$ ***\n **License** : "..xPlayer.identifier,"https://canary.discord.com/api/webhooks/841152095448858694/EUA1uMvwM0AiCP-I7bbWxcN-4xXVYbp_DaVNKi6JxEh5y8MbSbFoAMfGKbYNK8hTW7XG")
        TriggerClientEvent('esx:showAdvancedNotification', source, 'Banque', '~g~Compte bancaire', "Vous avez retiré ~g~"..money.."$~s~ de votre compte", 'CHAR_BANK_FLEECA', 9)
    else
        TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas assez d\'argent~s~ !")
    end
end)