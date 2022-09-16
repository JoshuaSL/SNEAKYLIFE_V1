local trunkData = nil

trunkType = 'item'


RegisterNetEvent("esx_inventoryhud:openTrunkInventory")
AddEventHandler("esx_inventoryhud:openTrunkInventory", function(data, blackMoney, inventory, weapons)
    setTrunkInventoryData(data, blackMoney, inventory, weapons)
    openTrunkInventory(trunkType)
end)

RegisterNetEvent("esx_inventoryhud:refreshTrunkInventory")
AddEventHandler("esx_inventoryhud:refreshTrunkInventory",function(data, blackMoney, inventory, weapons)
    setTrunkInventoryData(data, blackMoney, inventory, weapons)
end)

RegisterNUICallback("Sneaky:changeTheCurrentTruckMenu", function(sneakyInfo)

    trunkType = sneakyInfo.type
    if sneakyInfo.item == 'trunk' then 
        openmenuvehicle()
    elseif sneakyInfo.item == 'property' then 
        refreshPropertyInventory()
    elseif sneakyInfo.item == 'storage' then 
        refreshStorageInventory() 
    end
end)

function getVehicleInDirection(range)
    local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
    local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, range, 0.0)

    local rayHandle = CastRayPointToPoint(coordA.x, coordA.y, coordA.z, coordB.x, coordB.y, coordB.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end

VehicleLimit = {
    [0] = 30, --Compact
    [1] = 50, --Sedan
    [2] = 80, --SUV
    [3] = 35, --Coupes
    [4] = 40, --Muscle
    [5] = 20, --Sports Classics
    [6] = 20, --Sports
    [7] = 20, --Super
    [8] = 20, --Motorcycles
    [9] = 180, --Off-road
    [10] = 350, --Industrial
    [11] = 70, --Utility
    [12] = 100, --Vans
    [13] = 0, --Cycles
    [14] = 100, --Boats
    [15] = 20, --Helicopters
    [16] = 0, --Planes
    [17] = 40, --Service
    [18] = 40, --Emergency
    [19] = 0, --Military
    [20] = 350, --Commercial
    [21] = 0 --Trains
}


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
    local class = GetVehicleClass(vehicle)
    local locked = GetVehicleDoorLockStatus(vehicle)
    if locked == 1 then
        SetVehicleDoorOpen(vehicle, 5, false, false)
        OpenCoffreInventoryMenu(GetVehicleNumberPlateText(vehicle), VehicleLimit[class])
    else
        ESX.ShowNotification("Ce coffre est ~r~fermé~s~.")
    end
end

local count = 0

function OpenCoffreInventoryMenu(plate, max)
    ESX.TriggerServerCallback("esx_inventoryhud_trunk:getInventoryV",function(inventory)
        text = '<h3>Vehicle trunk</h3><br><strong>Plaque :</strong> '..plate..'  <br><strong>Capacité : </strong>'..(inventory.weight)..' / '..(max)..''
        data = {plate = plate, max = max, text = text}
        TriggerEvent("esx_inventoryhud:openTrunkInventory", data, inventory.blackMoney, inventory.items, inventory.weapons)
    end,plate)
end

function setTrunkInventoryData(data, blackMoney, inventory, weapons)
    trunkData = data
    SendNUIMessage({action = "setInfoText",text = data.text,type = "trunk"})
    items = {}
    if trunkType == 'item' then
        if blackMoney > 0 then
            accountData = {
                label = "Argent sale",
                count = blackMoney,
                type = "item_account",
                name = "dirtycash",
                usable = false,
                rare = false,
                limit = -1,
                canRemove = false
            }
            table.insert(items, accountData)
        end

        if inventory ~= nil then
            for key, value in pairs(inventory) do
                if inventory[key].count <= 0 then
                    inventory[key] = nil
                else
                    inventory[key].type = "item_standard"
                    inventory[key].usable = false
                    inventory[key].rare = false
                    inventory[key].limit = -1
                    inventory[key].canRemove = false
                    table.insert(items, inventory[key])
                end
            end
        end
        SendNUIMessage({action = "setSecondInventoryItems",itemList = items,type = "trunk"})
    end

    if trunkType == 'weapon' then
        if IncludeWeapons and weapons ~= nil then
            for key, value in pairs(weapons) do
                local weaponHash = GetHashKey(weapons[key].name)
                if weapons[key].name ~= "WEAPON_UNARMED" then
                    table.insert(
                        items,
                        {
                            label = weapons[key].label,
                            count = weapons[key].ammo,
                            limit = -1,
                            type = "item_weapon",
                            name = weapons[key].name,
                            usable = false,
                            rare = false,
                            canRemove = false
                        }
                    )
                end
            end
        end
        SendNUIMessage({action = "setSecondInventoryItems",itemList = items})
    end
end

function openTrunkInventory(trunkType)
    loadPlayerInventory(currentMenu)
    isInInventory = true
    SendNUIMessage({action = "display",type = "trunk"})
    SetNuiFocus(true, true)
end

RegisterNUICallback("PutIntoTrunk", function(data, cb)
    print(json.encode(data))
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local count = tonumber(data.number)

        if data.item.type == "item_weapon" then
            count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
        end

        ESX.TriggerServerCallback("esx_vehicleshop:isPlateTaken",function(isPlateTaken)
            TriggerServerEvent("esx_inventoryhud_trunk:putItem", trunkData.plate, data.item.type, data.item.name, count, trunkData.max, isPlateTaken, data.item.label)
        end,trunkData.plate)
    end
    Wait(250)
    loadPlayerInventory(currentMenu)
    cb("ok")
end)

RegisterNUICallback("TakeFromTrunk",function(data, cb)
    print(json.encode(data))
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        ESX.TriggerServerCallback("esx_vehicleshop:isPlateTaken",function(isPlateTaken)
            TriggerServerEvent("esx_inventoryhud_trunk:getItem", trunkData.plate, data.item.type, data.item.name, tonumber(data.number), trunkData.max, isPlateTaken)
        end,trunkData.plate)
    end
    Wait(250)
    loadPlayerInventory(currentMenu)
    cb("ok")
end)