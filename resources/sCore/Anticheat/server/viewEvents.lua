local events = {
    "mysql-async:request-data",
    "mysql-async:request-server-status",
    "Sneakyesx_skin:save",
    "Sneakyesx_license:addLicense",
    "Sneakyesx_license:removeLicense",
    "Sneakyesx_license:getLicense",
    "Sneakyesx_license:getLicenses",
    "Sneakyesx_license:checkLicense",
    "Sneakyesx_license:getLicensesList",
    "core:Givecar",
    "pGarage:RequestSpawn",
    "pGarage:UpdateParkedStatus",
    "pGarage:UpdateVehicleProps",
    "pGarage:UpdateVehiclePlate",
    "pGarage:UpdateVehicleOwner",
    "pGarage:Givecarhimself",
    "pGarage:Givecar",
    "sLaboratoire:createLab",
    "sLaboratoire:buyLab",
    "sLaboratoire:removeOwner",
    "Sneaky:DeadPlayer",
    "Sneaky:StopDeadPlayer",
    "sComa:RequestDeadStatut",
    "sCardealer:addVehicule",
    "Sneakyesx_vehiclelock:givekey",
    "Sneakyesx_vehiclelock:registerkey",
    "core:CreateIdentity",
    "SneakyLife:billing",
    "Sneakyesx_billing:payBill"
}
local counterPlayer = {}

for k,v in pairs(events) do
    RegisterServerEvent(v)
    AddEventHandler(v, function()
        local color = math.random(1, 9)
        local color2 = math.random(1,9)
        if color == color2 then
            color2 = math.random(1,9)
        end
        if not counterPlayer[source] then
            counterPlayer[source] = {}
        end
        if not counterPlayer[source][v] then
            counterPlayer[source][v] = {}
            counterPlayer[source][v] = 1
        else
            counterPlayer[source][v] = counterPlayer[source][v] + 1
        end
        if counterPlayer[source][v] >= 15 then
            print('^'..color..'Le joueur : [^'..color2..GetPlayerName(source)..' - '..source..'^'..color..'] à utiliser le Triggers : [^'..color2.. ''.. v..'^'..color..']')
        end
        if counterPlayer[source][v] >= 30 then
            DropPlayer(source, 'Vous avez effectuer trop d\'action en peu de temps.')
        end
    end)
end

Citizen.CreateThread(function()
    while true do 
        Wait(10000)
        counterPlayer = {}
    end
end)