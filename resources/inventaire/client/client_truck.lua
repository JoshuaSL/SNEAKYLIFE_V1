ESX = nil
local currentVehicle = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("Sneakyesx:getSharedObject",function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
end)

VehicleLimit = {
    [0] = 30, --Compact
    [1] = 50, --Sedan
    [2] = 180, --SUV
    [3] = 35, --Coupes
    [4] = 40, --Muscle
    [5] = 20, --Sports Classics
    [6] = 20, --Sports
    [7] = 20, --Super
    [8] = 20, --Motorcycles
    [9] = 180, --Off-road
    [10] = 350, --Industrial
    [11] = 70, --Utility
    [12] = 220, --Vans
    [13] = 0, --Cycles
    [14] = 110, --Boats
    [15] = 20, --Helicopters
    [16] = 0, --Planes
    [17] = 40, --Service
    [18] = 40, --Emergency
    [19] = 0, --Military
    [20] = 300, --Commercial
    [21] = 0 --Trains
}

function getVehicleInDirection(range)
    local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
    local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, range, 0.0)

    local rayHandle = CastRayPointToPoint(coordA.x, coordA.y, coordA.z, coordB.x, coordB.y, coordB.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end

function openmenuvehicle()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local vehicle = nil

    if IsPedInAnyVehicle(playerPed, false) then
        vehicle = GetVehiclePedIsIn(playerPed, false)
    else
        vehicle = getVehicleInDirection(3.0)

        if not DoesEntityExist(vehicle) then
            vehicle = GetClosestVehicle(coords, 3.0, 0, 70)
        end
    end

    if DoesEntityExist(vehicle) then
        local vehicle, distance = ESX.Game.GetClosestVehicle(coords)
        if distance <= 2.0 then
            currentVehicle = vehicle
            SetVehicleDoorOpen(vehicle, 5, false, false)
            local class = GetVehicleClass(vehicle)
            OpenCoffreInventoryMenu(vehicle,GetVehicleNumberPlateText(vehicle), VehicleLimit[class])
        else
            ShowAboveRadarMessage("~r~Vous n'êtes pas à côté d'un véhicule.")
        end
    else
       ShowAboveRadarMessage("~r~Vous n'êtes pas à côté d'un véhicule.")
    end
end

local count = 0

RegisterCommand("trunk",function()
    if not exports.inventaire:GetStateInventory() then
        if not IsPedInAnyVehicle(PlayerPedId(), true) then
            openmenuvehicle()
        end
    end
end)

RegisterKeyMapping('trunk', 'Ouvrir le coffre', 'keyboard', 'H')



function OpenCoffreInventoryMenu(veh, plate, max)
    ESX.TriggerServerCallback("esx_inventoryhud_trunk:getInventoryV",function(inventory)
        text = '<h3>Coffre</h3><br><strong>Plaque :</strong> '..plate..'  <br><strong>Capacité : </strong>'..(inventory.weight)..' / '..(max)..''
        data = {plate = plate, max = max, text = text}
        TriggerEvent("esx_inventoryhud:openTrunkInventory", data, inventory.blackMoney, inventory.items, inventory.weapons)
    end,plate)
end

RegisterNetEvent("esx_inventoryhud:onClosedInventory")
AddEventHandler("esx_inventoryhud:onClosedInventory",function(type)
    if type == "trunk" then
        closeTrunk()
    end
end)

function closeTrunk()
    if currentVehicle ~= nil then
        SetVehicleDoorShut(currentVehicle, 5, false)
    end
    currentVehicle = nil
end

Citizen.CreateThread(function()
    while true do
        Wait(500)
        if currentVehicle ~= nil and DoesEntityExist(currentVehicle) then
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local vehicleCoords = GetEntityCoords(currentVehicle)
            local distance = GetDistanceBetweenCoords(coords, vehicleCoords, 1)

            if distance > 4.0 then
                TriggerEvent("esx_inventoryhud:closeInventory")
            end
        end
    end
end)