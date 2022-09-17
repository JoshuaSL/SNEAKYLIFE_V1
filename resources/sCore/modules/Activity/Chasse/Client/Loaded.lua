ESX = nil

getESX = function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(niceESX) ESX = niceESX end)
        Wait(500)
   end
end

Citizen.CreateThread(function()
    getESX()
end)