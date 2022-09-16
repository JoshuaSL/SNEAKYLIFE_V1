Citizen.CreateThread(function()
     while ESX == nil do
		TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then
        ESX.PlayerData = ESX.GetPlayerData()
    end
end)
RegisterNetEvent('Sneakyesx:playerLoaded')
AddEventHandler('Sneakyesx:playerLoaded', function(xPlayer)
     ESX.PlayerData = xPlayer
end)
RegisterNetEvent('Sneakyesx:setJob')
AddEventHandler('Sneakyesx:setJob', function(job)
     ESX.PlayerData.job = job
end)

Keys.Register('F6','InteractionsJob', 'Menu job', function()
    if not bloquertouchejojo and not toucheBloqueKadir and not exports.phone:GetStatePhone() and not exports.inventaire:GetStateInventory() then
        if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == "police" or ESX.PlayerData.job.name == "lssd" then
            if PoliceJob[ESX.PlayerData.job.name] == nil then return end
            if CheckServiceLspdLssd() then
                openF6PoliceJob(PoliceJob[ESX.PlayerData.job.name])
            else
                ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
            end
        end
    end
    if not toucheBloqueKadir and not bloquertouchejojo and not exports.phone:GetStatePhone() and not exports.inventaire:GetStateInventory() then
        if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then
            if CheckServiceAmbulance() then
                OpenAmbulanceActionMenuRageUIMenu()
            else
                ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
            end
        elseif ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'mecano' then
            if CheckServiceMecano() then
                OpenMecanoActionMenuRageUIMenu()
            else
                ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
            end
        elseif ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == "harmony" then
            if CheckServiceHarmony() then
                OpenHarmonyActionMenuRageUIMenu()
            else
                ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
            end
        elseif ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == "carshop" then
            if CheckServiceConcess() then
                OpenConcessActionMenuRageUIMenu()
            else
                ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
            end
        elseif ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == "unicorn" then
            if CheckServiceUnicorn() then
                OpenUnicornActionMenuRageUIMenu()
            else
                ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
            end
        elseif ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == "yellowjack" then
            if CheckServiceYellowJack() then
                OpenYellowjackActionMenuRageUIMenu()
            else
                ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
            end
        elseif ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == "taxi" then
            if CheckServiceTaxi() then
                openF6Taxi()
            else
                ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
            end
        elseif ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == "noodle" then
            if CheckServiceNoodle() then
                OpenNoodleActionMenuRageUIMenu()
            else
                ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
            end
        elseif ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == "agentimmo" then
            if CheckServiceImmo() then
                OpenDynasty8ActionMenuRageUIMenu()
            else
                ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
            end
        elseif ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == "bahamas" then
            if CheckServiceBahamas() then
                OpenBahamasActionMenuRageUIMenu()
            else
                ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
            end
        elseif ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == "pizza" then
            if CheckServicePizza() then
                OpenPizzaActionMenuRageUIMenu()
            else
                ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
            end
        elseif ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == "burger" then
            if CheckServiceBurger() then
                OpenBurgerActionMenuRageUIMenu()
            else
                ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
            end
        end
    end
 end)