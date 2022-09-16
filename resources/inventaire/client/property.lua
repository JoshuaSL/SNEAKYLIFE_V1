local CurrentPropertyId = nil
local stockInventory = nil
RegisterNetEvent("esx_inventoryhud:openPropertyInventory")
AddEventHandler("esx_inventoryhud:openPropertyInventory",function(data)
    setPropertyInventoryData(data)
    openPropertyInventory(trunkType)
end)

RegisterNetEvent("sProperty:returnInventory")
AddEventHandler("sProperty:returnInventory", function(inventory)
    stockInventory = inventory
end)

function refreshPropertyInventory()
    local items, weapons, blackMoney = {}, {}, 0
    TriggerServerEvent("sProperty:requestInventory", CurrentPropertyId)
    while stockInventory == nil do
        Wait(0)
    end
    for k,v in pairs(stockInventory) do
        if v.type == "item" then
            table.insert(items, {count = v.count, label = v.label, name = v.name})
        end
        if v.type == 'weapon' then 
            table.insert(weapons, {name = v.name, ammo = v.ammo})
        end 
        if v.type == 'dirtycash' then 
            blackMoney = v.count
        end
    end
    setPropertyInventoryData({blackMoney = blackMoney, items = items, weapons = weapons})
end

function setPropertyInventoryData(data)
    items = {}

    local blackMoney = data.blackMoney
    local propertyItems = data.items
    local propertyWeapons = data.weapons
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

        for i = 1, #propertyItems, 1 do
            local item = propertyItems[i]

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
        for i = 1, #propertyWeapons, 1 do
            local weapon = propertyWeapons[i]

            if propertyWeapons[i].name ~= "WEAPON_UNARMED" then
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

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            itemList = items
        }
    )
end

function openPropertyInventory(trunkType)
    loadPlayerInventory(currentMenu)
    isInInventory = true
    SendNUIMessage({action = "display",type = "property"})
    SetNuiFocus(true, true)
end

RegisterNetEvent("sProperty:SendIdProperty")
AddEventHandler("sProperty:SendIdProperty", function(propertyId)
    CurrentPropertyId = propertyId
end)

RegisterNUICallback("PutIntoProperty",function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local count = tonumber(data.number)
        local ammo = 0
        if data.item.type == "item_standard" then
            data.item.type = "item"
        elseif data.item.type == "item_account" then
            data.item.type = "money"
        elseif data.item.type == "item_weapon" then
            data.item.type = "weapon"
            ammo = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
        end
        TriggerServerEvent("sProperty:addItems", CurrentPropertyId, data.item.type, data.item.name, count, ammo)
    end

    Wait(150)
    refreshPropertyInventory()
    Wait(150)
    loadPlayerInventory(currentMenu)

    cb("ok")
end)

RegisterNUICallback("TakeFromProperty",function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end
    local ammo = 0
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        if data.item.type == "item_standard" then
            data.item.type = "item"
        elseif data.item.type == "item_account" then
            data.item.type = "money"
        elseif data.item.type == "item_weapon" then
            data.item.type = "weapon"
            local ammo = GetAmmoInPedWeapon(PlayerPedId())
        end
        TriggerServerEvent("sProperty:removeItems", CurrentPropertyId, data.item.type, data.item.name, tonumber(data.number), ammo)
    end
    Wait(150)
    refreshPropertyInventory()
    Wait(150)
    loadPlayerInventory(currentMenu)
    cb("ok")
end)