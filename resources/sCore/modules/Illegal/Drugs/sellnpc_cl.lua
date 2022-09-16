ESX = nil 
local drugSell, blip = false, false, 

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end) 

Neo = {
    distanceAnelysingStart = {20, 40},
    cooldown = {5000, 10000},  
    callCops = {1, 5},
    drugs = { 
        ["weed_pooch"] = {index = 1, prices = {50, 65}}, 
        ["meth_pooch"] = {index = 2, prices = {115, 130}},
        ["coke_pooch"] = {index = 3, prices = {135, 145}}
    },
    indexes = {
        [1] = "weed_pooch",
        [2] = "meth_pooch",
        [3] = "coke_pooch"
    }
}  

RegisterNetEvent('neo:askToStart')
AddEventHandler('neo:askToStart', function(data)
    local clicked = false
    local tbl = {}
    for k, v in pairs(data) do 
        if v.weed_pooch then 
            table.insert(tbl, Neo.drugs["weed_pooch"].index)
        elseif v.coke_pooch then 
            table.insert(tbl, Neo.drugs["coke_pooch"].index)
        elseif v.meth_pooch then 
            table.insert(tbl, Neo.drugs["meth_pooch"].index)
        end 
    end

    startSell(Neo.indexes[tbl[math.random(#tbl)]])

end) 
 
RegisterNetEvent('neo:ActivDrugsSell')
AddEventHandler('neo:ActivDrugsSell', function(bool)
    if not drugSell then  
        local cooldown = math.random(Neo.cooldown[1], Neo.cooldown[2])
        DrawSub("Vous êtes a la recherche de ~b~clients~s~.", cooldown)
        Wait(cooldown) 
        TriggerServerEvent('neo:trytoStart')
    else
        if blip then 
            RemoveBlip(blip) 
        end 
        randomPos = false
        boolTaken = false
        ShowAboveRadarMessage("~r~Vous venez d'arrêter de chercher des clients.")
    end
    drugSell = bool
end)

RegisterNetEvent('neo:restartFarming')
AddEventHandler('neo:restartFarming', function()
    local cooldown = math.random(Neo.cooldown[1], Neo.cooldown[2])
    DrawSub("Vous êtes a la recherche de ~b~clients~s~.", cooldown)
    Wait(cooldown)
    TriggerServerEvent('neo:trytoStart')
end) 

function startSell(item)
    ESX.TriggerServerCallback('neo:checkCops', function(cb)
        if cb then 
            local pPos = GetEntityCoords(PlayerPedId())
            local randomPos = getRandomPos()
            while randomPos == nil or randomPos == false do 
                randomPos = getRandomPos()
            end
            if randomPos then
                local boolTaken = false
                createBlip(randomPos, {501, 3, "Point de vente", 0.7})
            
                Citizen.CreateThread( function()
                    while not boolTaken and drugSell do
                        msec = 0
                        local pPos = GetEntityCoords(PlayerPedId())
                        local dist = #(vec2(pPos.x, pPos.y) - randomPos)
                        if not IsPedInAnyVehicle(PlayerPedId(), true) then 
                            DrawSub("Un point de livraison a été marqué dans la zone (~b~"..math.floor(dist).."m~s~)", 1)
                            if dist < 10 then
                                DrawMarker(1, randomPos.x, randomPos.y, pPos.z-1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 170, 255, 180, false, false, 2, false, false, false, false)
                            end
                            if dist < 7 then  
                                msec = 1
                                ESX.ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour effectuer la ~b~Vente")
                                if IsControlJustPressed(0, 51) then 
                                    boolTaken = true 
                                    RemoveBlip(blip) 
                                    startAnimNeo("random@domestic", "pickup_low")
                                    TriggerServerEvent('neo:sellDrugs', item, math.random(Neo.drugs[item].prices[1], Neo.drugs[item].prices[2]), Neo.drugs)
                                    local randomCallCops = math.random(Neo.callCops[1], Neo.callCops[2])
                                    if randomCallCops == 1 then   
                                        TriggerServerEvent("sCall:SendCallMsg", "Vente de drogue en cours", GetEntityCoords(PlayerPedId()), "police", false)
                                        TriggerServerEvent("sCall:SendCallMsg", "Vente de drogue en cours", GetEntityCoords(PlayerPedId()), "lssd", false)
                                    end
                                end
                            end 
                        end
                        Citizen.Wait(msec) 
                    end
                end)
            end
        else
            ShowAboveRadarMessage("Il n’y a aucun clients intéressé. (Pas assez de flic en service)")
        end
    end)
end

function getRandomPos()
    while true and drugSell do 
        Wait(0)
        local pPos = GetEntityCoords(PlayerPedId())
        local CoordsDrugs, SafeCoords = GetSafeCoordForPed(pPos.x + GetRandomIntInRange(-40, 40), pPos.y + GetRandomIntInRange(-40, 40), pPos.z, true, 0, 16)
        if not CoordsDrugs then
            return
        end
        if GetDistanceBetweenCoords(pPos.x, pPos.y, pPos.z, SafeCoords.x, SafeCoords.y, SafeCoords.z) < 20 then
            return
        end
        if IsPedInAnyVehicle(PlayerPedId(), true) then
            return
        end
        DrawSub("Vous êtes a la recherche de ~b~clients~s~.", 1)
        return vec2(SafeCoords.x, SafeCoords.y)
    end
end 

function DrawSub(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, 1)
end

function startAnimNeo(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
	end)
end

function createBlip(pos, data)
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

RegisterCommand('drugs', function()
    if drugSell then 
        startSell()
    else
        ESX.ShowNotification("Vous avez ~r~arrêter~s~ de vendre.")
    end
end)




