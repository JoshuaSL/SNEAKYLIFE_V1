ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('Faille:duBanquierLol',function(source, cb, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if xPlayer.getAccount("cash").money >= price then
            xPlayer.removeAccountMoney("cash", price)
            SendLogs(47103,"Location - Achat","**"..GetPlayerName(source).."** vient de louer un véhicule pour ***"..price.."$ ***\n **License** : "..xPlayer.identifier,"https://canary.discord.com/api/webhooks/841147017635823626/N969yEy1I535pzY8BkqZlphD3QARsf6ZhYvd14XyKeb9tf7QlE13iP43EjkNGXROka9N")
            cb(true)
        else
            cb(false)
        end
    end
end)