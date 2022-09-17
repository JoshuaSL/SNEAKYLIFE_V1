-- 
-- Created by Kadir#6400
-- 

ESX = nil

getESX = function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(niceESX) ESX = niceESX end)
        Wait(500)
   end
   while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then
        ESX.PlayerData = ESX.GetPlayerData()
    end
    ESX.PlayerData = ESX.GetPlayerData()
end

Citizen.CreateThread(function()
    getESX()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)
