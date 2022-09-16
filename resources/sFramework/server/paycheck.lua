local function testSalary()
    attempts = false
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer then
            local salary = xPlayer.job.grade_salary
            if salary > 0 then

                stateVip = nil
                local stateVip = exports.sCore:GetVIP(xPlayer.source)
                
                while stateVip == nil do
                    Wait(150)
                end

                print(xPlayer.name.." VIP salary is "..stateVip)
                
                attempts = true

                if stateVip == 0 then
                    multiplicator = 1
                    text = ""
                    attempts = false
                elseif stateVip == 1 then
                    multiplicator = 1.25
                    text = "(~y~Gold~s~)"
                    attempts = false
                elseif stateVip == 2 then
                    multiplicator = 1.5
                    text = "(~b~Diamond~s~)"
                    attempts = false
                end

                while attempts do
                    Wait(100)
                end

                returnText = text

                if xPlayer.job.grade_name == 'unemployed' then
                    xPlayer.addAccountMoney('bank', salary*multiplicator)
                    TriggerClientEvent("Sneakyesx:showNotification",xPlayer.source,"Jour de paye : ~g~+$"..salary*multiplicator.." ~s~"..returnText)
                elseif Config.EnableSocietyPayouts then
                    local society = "society_"..xPlayer.job.name
                    if society ~= nil then
                        TriggerEvent('Sneakyesx_addonaccount:getSharedAccount', society, function(account)
                            if account.money >= salary then
                                xPlayer.addAccountMoney('bank', salary*multiplicator)
                                account.removeMoney(salary)
                                TriggerClientEvent("Sneakyesx:showNotification",xPlayer.source,"Jour de paye : ~g~+$"..salary*multiplicator.." ~s~"..returnText)
                            else
                                TriggerClientEvent("Sneakyesx:showNotification",xPlayer.source,"~r~L'entreprise ne peut pas vous payer !")
                            end
                        end)
                    else
                        xPlayer.addAccountMoney('bank', salary*multiplicator)
                        TriggerClientEvent("Sneakyesx:showNotification",xPlayer.source,"Jour de paye : ~g~+$"..salary*multiplicator.." ~s~"..returnText)
                    end
                else
                    xPlayer.addAccountMoney('bank', salary*multiplicator)
                    TriggerClientEvent("Sneakyesx:showNotification",xPlayer.source,"Jour de paye : ~g~+$"..salary*multiplicator.." ~s~"..returnText)
                end
            end
        end
    end

end



RegisterCommand("payCheck", function(source)
	if source ~= 0 then return end
    testSalary()
end)

ESX.StartPayCheck = function()
	function payCheck()
		attempts = false
		local xPlayers = ESX.GetPlayers()

		for i = 1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

			if xPlayer then
				local salary = xPlayer.job.grade_salary
				if salary > 0 then

					stateVip = nil
					local stateVip = exports.sCore:GetVIP(xPlayer.source)
					
					while stateVip == nil do
						Wait(150)
					end

					print("VIP salary: "..stateVip)
					
					attempts = true

					if stateVip == 0 then
						multiplicator = 1
						text = ""
						attempts = false
					elseif stateVip == 1 then
						multiplicator = 1.25
						text = "(~y~Gold~s~)"
						attempts = false
					elseif stateVip == 2 then
						multiplicator = 1.5
						text = "(~b~Diamond~s~)"
						attempts = false
					end

					while attempts do
						Wait(100)
					end

					returnText = text

					if xPlayer.job.grade_name == 'unemployed' then
						xPlayer.addAccountMoney('bank', salary*multiplicator)
						TriggerClientEvent("Sneakyesx:showNotification",xPlayer.source,"Jour de paye : ~g~+$"..salary*multiplicator.." ~s~"..returnText)
					elseif Config.EnableSocietyPayouts then
						local society = "society_"..xPlayer.job.name
						if society ~= nil then
							TriggerEvent('Sneakyesx_addonaccount:getSharedAccount', society, function(account)
								if account.money >= salary then
									xPlayer.addAccountMoney('bank', salary*multiplicator)
									account.removeMoney(salary)
									TriggerClientEvent("Sneakyesx:showNotification",xPlayer.source,"Jour de paye : ~g~+$"..salary*multiplicator.." ~s~"..returnText)
								else
									TriggerClientEvent("Sneakyesx:showNotification",xPlayer.source,"~r~L'entreprise ne peut pas vous payer !")
								end
							end)
						else
							xPlayer.addAccountMoney('bank', salary*multiplicator)
							TriggerClientEvent("Sneakyesx:showNotification",xPlayer.source,"Jour de paye : ~g~+$"..salary*multiplicator.." ~s~"..returnText)
						end
					else
						xPlayer.addAccountMoney('bank', salary*multiplicator)
						TriggerClientEvent("Sneakyesx:showNotification",xPlayer.source,"Jour de paye : ~g~+$"..salary*multiplicator.." ~s~"..returnText)
					end
				end
			end
		end

		SetTimeout(Config.PaycheckInterval, payCheck)
	end

	SetTimeout(Config.PaycheckInterval, payCheck)
end
