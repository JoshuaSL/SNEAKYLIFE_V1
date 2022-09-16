serverToken = ""
SneakyEvent = TriggerServerEvent
RegisterNetEvent("kToken:view")
AddEventHandler("kToken:view", function(token)
    if token == nil then return end
    serverToken = token
end)

Citizen.CreateThread(function()
    SneakyEvent("kToken:requestCache")
end)