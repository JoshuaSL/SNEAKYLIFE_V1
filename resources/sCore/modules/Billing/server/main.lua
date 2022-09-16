ESX = nil

TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("sBill:SendBill")
AddEventHandler("sBill:SendBill", function(bill)
    local xPlayer = ESX.GetPlayerFromId(source)
    bill.source = source
    TriggerClientEvent('Sneakyesx:showNotification', xPlayer.source, "~b~Vous avez bien envoyé la demande.")
    TriggerClientEvent("sBill:GetBill", bill.playerId, bill)
end)

RegisterServerEvent("sBill:PayBills")
AddEventHandler("sBill:PayBills",function(bill)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local rPlayer = ESX.GetPlayerFromId(bill.source)
    local xMoney = xPlayer.getAccount('cash').money
    local bMoney = xPlayer.getAccount('bank').money

    if xMoney >= bill.price then 
        TriggerClientEvent("sBill:AlertBill", bill.source, 1)
        xPlayer.removeAccountMoney("cash",bill.price)
        local billinfo = json.encode(bill)
        exports.sCore:SendLogs(1752220,"Paiement de facture",""..GetPlayerName(source).." vient de payer une facture "..billinfo.." \n License : "..xPlayer.identifier,"https://discord.com/api/webhooks/878602186395881472/qIry9vc7c-8W4daXYhOdQu2ArWPPELOVfSVwaAVWb49d-IOCVyUW0-k1l0AzZcLeb99S")
        if bill.account then 
            TriggerEvent('Sneakyesx_addonaccount:getSharedAccount', bill.account, function(account)
                account.addMoney(bill.price)
            end)
        end
        TriggerClientEvent('Sneakyesx:showNotification', _source, "Vous avez payé la facture de: "..bill.price.."~g~$~s~.")
    else 
        if bMoney >= bill.price then
            TriggerClientEvent("sBill:AlertBill", bill.source, 1)
            local billinfo = json.encode(bill)
            exports.sCore:SendLogs(1752220,"Paiement de facture",""..GetPlayerName(source).." vient de payer une facture "..billinfo.." \n License : "..xPlayer.identifier,"https://discord.com/api/webhooks/878602186395881472/qIry9vc7c-8W4daXYhOdQu2ArWPPELOVfSVwaAVWb49d-IOCVyUW0-k1l0AzZcLeb99S")
            xPlayer.removeAccountMoney("bank", bill.price)
            if bill.account then 
                TriggerEvent('Sneakyesx_addonaccount:getSharedAccount', bill.account, function(account)
                    account.addMoney(bill.price)
                end)
            end
            TriggerClientEvent('Sneakyesx:showNotification', _source, "Vous avez payé la facture de: "..bill.price.."~g~$~s~.")
        else
            TriggerClientEvent('Sneakyesx:showNotification', _source, "~r~Vous n'avez pas assez d'argent.")
            TriggerClientEvent("Sneakyesx:showNotification", bill.source, "~r~La personne n'est pas solvable.")
            MySQL.Async.execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)', {
                ['@identifier'] = xPlayer.identifier,
                ['@sender'] = rPlayer.identifier,
                ['@target_type'] = 'society',
                ['@target'] = bill.account,
                ['@label'] = bill.title,
                ['@amount'] = bill.price
            }, function(rowsChanged)
                TriggerClientEvent('Sneakyesx:showNotification', _source, "~r~Vous venez de recevoir une facture de force.")
                TriggerClientEvent('Sneakyesx:showNotification', bill.source, "~r~Vous venez de mettre une facture de force.")
            end)
        end
    end
end)

ESX.RegisterServerCallback('SneakyLife:billing', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local bills = {}

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier ORDER BY amount ASC', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		for i = 1, #result, 1 do
			table.insert(bills, {
				id = result[i].id,
				label = result[i].label,
				amount = result[i].amount
			})
		end

		cb(bills)
	end)
end)

ESX.RegisterServerCallback('Sneakyesx_billing:payBill', function(source, cb, billId)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT sender, target_type, target, amount FROM billing WHERE id = @id', {
		['@id'] = billId
	}, function(result)
		if result[1] then
			local amount = result[1].amount
			local xTarget = ESX.GetPlayerFromIdentifier(result[1].sender)
            TriggerEvent('Sneakyesx_addonaccount:getSharedAccount', result[1].target, function(account)
                if xPlayer.getAccount('cash').money >= amount then
                    MySQL.Async.execute('DELETE FROM billing WHERE id = @id', {
                        ['@id'] = billId
                    }, function(rowsChanged)
                        if rowsChanged == 1 then
                            xPlayer.removeAccountMoney('cash', amount)
                            account.addMoney(amount)
                            TriggerClientEvent('Sneakyesx:showNotification', xPlayer.source, "Vous venez de payer la facture d'un montant de "..ESX.Math.GroupDigits(amount).."~g~$~s~.")
                            if xTarget then
                                TriggerClientEvent('Sneakyesx:showNotification', xTarget.source, "Vous venez de recevoir un paiement de "..ESX.Math.GroupDigits(amount).."~g~$~s~.")
                            end
                        end

                        cb()
                    end)
                elseif xPlayer.getAccount('bank').money >= amount then
                    MySQL.Async.execute('DELETE FROM billing WHERE id = @id', {
                        ['@id'] = billId
                    }, function(rowsChanged)
                        if rowsChanged == 1 then
                            xPlayer.removeAccountMoney('bank', amount)
                            account.addMoney(amount)
                            TriggerClientEvent('Sneakyesx:showNotification', xPlayer.source, "Vous venez de payer la facture d'un montant de "..ESX.Math.GroupDigits(amount).."~g~$~s~.")

                            if xTarget then
                                TriggerClientEvent('Sneakyesx:showNotification', xTarget.source, "Vous venez de recevoir un paiement de "..ESX.Math.GroupDigits(amount).."~g~$~s~.")
                            end
                        end

                        cb()
                    end)
                else
                    if xTarget then
                        TriggerClientEvent('Sneakyesx:showNotification', xTarget.source, "~r~La personne n'a pas assez d'argent pour payer sa facture.")
                    end
                    TriggerClientEvent('Sneakyesx:showNotification', xPlayer.source, "~r~Vous n'avez pas assez d'argent.")
                    cb()
                end
            end)
		end
	end)
end)