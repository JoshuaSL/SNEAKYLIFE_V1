local lastStorage = nil
local CurrentJob = nil

RegisterNetEvent("esx_inventoryhud:openStorageInventory")
AddEventHandler("esx_inventoryhud:openStorageInventory", function(job)
    CurrentJob = job
    ESX.TriggerServerCallback("Sneaky:getStockItems", function(item,weapon,dirtycash)
        setStorageInventoryData({inventory = item, weapons = weapon, blackMoney = dirtycash})
        openStorageInventory(trunkType)
    end, job)
end)

function refreshStorageInventory()
    ESX.TriggerServerCallback("Sneaky:getStockItems", function(item,weapon,dirtycash)
        setStorageInventoryData({inventory = item, weapons = weapon, blackMoney = dirtycash})
    end, CurrentJob)
end

function setStorageInventoryData(data)
    items = {}

    local blackMoney = data.blackMoney
    local storageItems = data.inventory
    local storageWeapons = data.weapons

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

        for i = 1, #storageItems, 1 do
            local item = storageItems[i]

            if item.count > 0 then
                item.type = "item_standard"
                item.usable = false
                item.rare = false
                item.limit = -1
                item.canRemove = false

                table.insert(items, item)
            end
        end
    end

    if trunkType == 'weapon' then
        for i = 1, #storageWeapons, 1 do
            local weapon = storageWeapons[i]

            if storageWeapons[i].name ~= "WEAPON_UNARMED" then
                table.insert(
                    items,
                    {
                        label = ESX.GetWeaponLabel(weapon.name),
                        count = weapon.ammo,
                        limit = -1,
                        type = "item_weapon",
                        name = weapon.name,
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

function openStorageInventory(trunkType)
    loadPlayerInventory(currentMenu)
    isInInventory = true
    SendNUIMessage({action = "display",type = "storage"})
    SetNuiFocus(true, true)
end

RegisterNUICallback("PutIntoStorage",function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local count = tonumber(data.number)
        if data.item.type == "item_weapon" then
            count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
            TriggerServerEvent("Sneaky:putStockItems","weapon",data.item.name, 1, CurrentJob, count)
        end
        if data.item.type == "item_standard" then
            TriggerServerEvent("Sneaky:putStockItems","item",data.item.name, count, CurrentJob)
        end
        if data.item.type == "item_account" then
            TriggerServerEvent("Sneaky:putStockItems","dirtycash","dirtycash", count, CurrentJob)
        end
    end

    Wait(150)
    refreshStorageInventory()
    Wait(150)
    loadPlayerInventory(currentMenu)

    cb("ok")
end)

RegisterNUICallback("TakeFromStorage",function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local count = tonumber(data.number)
        if data.item.type == "item_weapon" then
            count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
            TriggerServerEvent("Sneaky:getStockItem","weapon",data.item.name, 1, CurrentJob, count)
        end
        if data.item.type == "item_standard" then
            print("Salut")
            print(data.item.name, count, CurrentJob)
            TriggerServerEvent("Sneaky:getStockItem","item",data.item.name, count, CurrentJob)
        end
        if data.item.type == "item_account" then
            TriggerServerEvent("Sneaky:getStockItem","dirtycash","dirtycash", count, CurrentJob)
        end
    end

    Wait(150)
    refreshStorageInventory()
    Wait(150)
    loadPlayerInventory(currentMenu)
    cb("ok")
end)