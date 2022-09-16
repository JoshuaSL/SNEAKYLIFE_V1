ESX = nil 

CreateThread(function()
	while ESX == nil do
		TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)
		Wait(0)
	end
end) 

Drugs = {}

Drugs.Items = {
    ["weed_pooch"] = true,
    ["meth_pooch"] = true,
    ["coke_pooch"] = true
}

Drugs.Sell = false

function Drugs:GetRandomCoords()
    if Drugs.Sell == nil or Drugs.Sell == false then return end
    
    local playerCoords = GetEntityCoords(PlayerPedId())
    local CoordsDrugs, SafeCoords = GetSafeCoordForPed(playerCoords.x + GetRandomIntInRange(-40, 40), playerCoords.y + GetRandomIntInRange(-40, 40), playerCoords.z, true, 0, 16)

    if not CoordsDrugs or GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, SafeCoords.x, SafeCoords.y, SafeCoords.z) < 20 then
        return
    end

    return vector3(SafeCoords.x, SafeCoords.y, SafeCoords.z - 1.0)
end 

function Drugs:PlayerHasItem()
    local hasItem = false

    for _,item in pairs(ESX.PlayerData.inventory) do
        if item.count > 0 then
            if Drugs.Items[item.name] then
                hasItem = item.name
            end
        end
    end

    return hasItem
end

function Drugs:CreateBlip(pos, data)
    if blip then 
        RemoveBlip(blip) 
    end 
    blip = AddBlipForCoord(pos)
    SetBlipSprite(blip, data[1])
    SetBlipColour(blip, data[2])
    SetBlipScale(blip, data[4])
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
	AddTextComponentString(data[3])
	EndTextCommandSetBlipName(blip)
end

function Drugs:DrawText(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, 1)
end

function Drugs:Anim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
	end)
end

function Drugs:StartBoucleForSelling()
    local playerHasItem = Drugs:PlayerHasItem()
    if playerHasItem == nil or playerHasItem == false then return ESX.ShowNotification("~r~Vous n'avez pas ce qu'il faut sur vous.") end

    Drugs.Sell = not Drugs.Sell

    local delivery, deliveryPos = nil, nil
    while true do
        if Drugs.Sell == nil or Drugs.Sell == false then
            if delivery then
                if DoesBlipExist(delivery.blip) then
                    RemoveBlip(delivery.blip)
                    delivery.blip = nil
                end
                delivery = nil
            end
            break
        end

        playerHasItem = Drugs:PlayerHasItem()
        if playerHasItem == nil or playerHasItem == false then 
            if delivery then
                if DoesBlipExist(delivery.blip) then
                    RemoveBlip(delivery.blip)
                    delivery.blip = nil
                end
                playerHasItem = nil
                delivery = nil
            end
            ESX.ShowNotification("~r~Vous n'avez plus assez de marchandise.")
            break
        end

        local Interval = 250

        while deliveryPos == nil do
            Wait(0)
            Drugs:DrawText("Vous êtes a la recherche de ~b~clients~s~.", 1)
            deliveryPos = Drugs:GetRandomCoords()
        end
        
        if deliveryPos ~= nil and delivery == nil then
            delivery = {
                point = deliveryPos, 
                blip = Drugs:CreateBlip(deliveryPos, {501, 3, "Livraison", 0.7}),
                entity = nil
            }
            
            while delivery.point == nil do
                Wait(50)
            end

            deliveryPos = nil
        else
            Interval = 0
            Drugs:DrawText("Un point de livraison a été marqué dans la ~b~zone~s~.", 1)
            if #(GetEntityCoords(PlayerPedId())-delivery["point"]) < 3.0 then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~g~déposer~s~ votre ~b~livraison~s~.")
                if IsControlJustReleased(0, 54) then
                    Drugs:Anim("random@domestic", "pickup_low")
                    FreezeEntityPosition(PlayerPedId(), true)
                    Wait(GetAnimDuration("pickup_object", "pickup_low") * 400)
                    FreezeEntityPosition(PlayerPedId(), false)
                    if DoesBlipExist(delivery.blip) then
                        RemoveBlip(delivery.blip)
                        delivery.blip = nil
                    end
                    local random = math.random(1, 10)
                    if random == 3 then
                        TriggerServerEvent("sCall:SendCallMsg", "Vente de drogue en cours", GetEntityCoords(PlayerPedId()), "police", false)
                        TriggerServerEvent("sCall:SendCallMsg", "Vente de drogue en cours", GetEntityCoords(PlayerPedId()), "lssd", false)
                    end
                    TriggerServerEvent("Drugs:Sell", playerHasItem)
                    delivery = nil
                end
            elseif #(GetEntityCoords(PlayerPedId())-delivery["point"]) < 30.0 then
                DrawMarker(1,delivery["point"],0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,162,255,162,80,0,0,0,0,0,0,0)
            end
        end

        Wait(Interval)
    end
end

RegisterCommand("drugs", function()
    Drugs:StartBoucleForSelling()
end)

RegisterNetEvent("Drugs:SellDrugs")
AddEventHandler("Drugs:SellDrugs", function()
    Drugs:StartBoucleForSelling()
end)