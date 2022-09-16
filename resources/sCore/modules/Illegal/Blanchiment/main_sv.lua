ESX = nil
TriggerEvent("Sneakyesx:getSharedObject", function(niceESX) ESX = niceESX end)

RegisterServerEvent("kBlanch:transformMoney")
AddEventHandler("kBlanch:transformMoney", function(token, money)
    local _source = source
    if _source then
        if not getToken(_source, token) then 
            banPlayerAC(xPlayer.source, {
                name = "changestateuser",
                title = "Anticheat : transformation d'argent",
                description = "Anticheat : transformation d'argent"
            })
            return
        end
        local xPlayer = ESX.GetPlayerFromId(_source)
        if xPlayer.getAccount("dirtycash").money >= money then
            local moneyTransform = money*0.80
            local niceMoney = ESX.Math.Round(moneyTransform)
            xPlayer.removeAccountMoney("dirtycash", money)
            xPlayer.addAccountMoney("cash", niceMoney)
            TriggerClientEvent("Sneakyesx:showNotification", _source, "Vous avez transformé "..money.."~r~$~s~ en "..niceMoney.."~g~$~s~ .")
        else
            TriggerClientEvent("Sneakyesx:showNotification", _source, "~r~Vous n'avez pas assez d'argent sale !")
        end
    end
end)