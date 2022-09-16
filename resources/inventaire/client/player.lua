local targetPlayer, targetPlayerName

AddEventHandler("onResourceStop", function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent("chat:removeSuggestion", "/openinventory")
	end
end)

RegisterNetEvent("esx_inventoryhud:openPlayerInventory")
AddEventHandler("esx_inventoryhud:openPlayerInventory", function(target, playerName)
	targetPlayer = target
	targetPlayerName = playerName
	setPlayerInventoryData()
	openPlayerInventory()
end)

function refreshPlayerInventory()
    setPlayerInventoryData()
end

function setPlayerInventoryData()
    ESX.TriggerServerCallback("esx_inventoryhud:getPlayerInventory", function(data)
        items = {}
        inventory = data.inventory
        dirtycash = data.dirtycash
        money = data.money
        weapons = data.weapons

        if IncludeCash and money ~= nil and money > 0 then
            moneyData = {
                label = "Argent",
                name = "money",
                type = "item_money",
                count = money,
                usable = false,
                rename = false,
                rare = false,
                information = true, 
                weight = -1,
                canRemove = true
            }

            table.insert(items, moneyData)
        end

        if dirtycash ~= nil and dirtycash > 0 then
            dirtycashData = {
                label = "Argent sale",
                name = "dirtycash",
                type = "item_account",
                count = dirtycash,
                usable = false,
                rename = false,
                rare = false,
                information = true, 
                weight = -1,
                canRemove = true
            }

            table.insert(items, dirtycashData)
        end

        if inventory ~= nil then
            for key, value in pairs(inventory) do
                if inventory[key].count <= 0 then
                    inventory[key] = nil
                else
                    inventory[key].type = "item_standard"
                    table.insert(items, inventory[key])
                end
            end
        end

        if IncludeWeapons and weapons ~= nil then
            for key, value in pairs(weapons) do
                local weaponHash = GetHashKey(weapons[key].name)
                local playerPed = PlayerPedId()
                if weapons[key].name ~= "WEAPON_UNARMED" then
                    local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
                    table.insert(
                        items,
                        {
                            label = weapons[key].label,
                            count = ammo,
                            limit = -1,
                            type = "item_weapon",
                            name = weapons[key].name,
                            usable = false,
                            rare = false,
                            canRemove = true
                        })
                end
            end
        end

        SendNUIMessage({action = "setSecondInventoryItems", itemList = items})
    end, targetPlayer)
end

function openPlayerInventory()
    loadPlayerInventory(currentMenu)
    isInInventory = true

    SendNUIMessage({action = "display", type = "player"})

    SetNuiFocus(true, true)
end

RegisterNUICallback("PutIntoPlayer", function(data, cb)
	if IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	if type(data.number) == "number" and math.floor(data.number) == data.number then
		local count = tonumber(data.number)

	    if data.item.type == "item_weapon" then
		    count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
	    end

		TriggerServerEvent("esx_inventoryhud:tradePlayerItem", GetPlayerServerId(PlayerId()), targetPlayer, data.item.type, data.item.name, count)
	end

    Wait(250)
    refreshPlayerInventory()
    loadPlayerInventory(currentMenu)

    cb("ok")
end)

RegisterNUICallback("TakeFromPlayer", function(data, cb)
	if IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	if type(data.number) == "number" and math.floor(data.number) == data.number then
		local count = tonumber(data.number)

		if data.item.type == "item_weapon" then
			count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
		end

		TriggerServerEvent("esx_inventoryhud:tradePlayerItem", targetPlayer, GetPlayerServerId(PlayerId()), data.item.type, data.item.name, count)
     end

    Wait(250)
    refreshPlayerInventory()
    loadPlayerInventory(currentMenu)

    cb("ok")
end)
