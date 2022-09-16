-- 
-- Created by Kadir#6400
-- 

actionsBlips, chasseBlips, chassePed = {}, {}, {}
SneakyEvent = TriggerServerEvent
Citizen.CreateThread(function()
    -- ESX
    getESX()
    -- Ped
    for k,v in pairs(KadirChasse.Position) do
        local hash = GetHashKey(v.pedModel)
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(250)
        end
        local ped = CreatePed(7, hash, v.pedPos.x, v.pedPos.y, v.pedPos.z-1.0, v.pedHeading, false, false)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)
        Citizen.CreateThread(function()
            Wait(250)
            GiveWeaponToPed(ped, v.pedWeapon, 250, true, true)
        end)
    end
    -- Pos
    while true do
        local pos = GetEntityCoords(PlayerPedId())
        local nofps = false
        for k,v in pairs(KadirChasse.Position) do
            if not openedMenu then
                if #(pos-v.pedPos) < 1.5 then
                    nofps = true
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour parler au ~c~Gérant des Chasseurs~s~ !")
                    if IsControlJustReleased(0, 38) then
                        openMenu(v)
                    end
                end
            end
        end
        if nofps then
            Wait(1)
        else
            Wait(850)
        end
    end
end)

local EnteredChasse = false
Citizen.CreateThread(function()
    while true do
        local InChasse = false
        if playerInTheChasse then
            for k,v in pairs(KadirChasse.Position) do
                local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local PlayerPos = #(vector3(-567.24816894531,5211.8745117188,83.624855041504)-pCoords)
                if PlayerPos <= 400.0 then
                    InChasse = true
                    if not EnteredChasse then
                        EnteredChasse = true
                    end
                    break
                end
            end
            if InChasse then
                Wait(1)
            else
                if EnteredChasse then
                    if lastChasse ~= nil then
                        SneakyEvent("sChasse:stop", false, GetEntityCoords(PlayerPedId()), lastChasse)
                    end
                end
                Wait(500)
            end
        else
            Wait(850)
        end
    end
end)

RegisterNetEvent("sChasse:returnStart")
AddEventHandler("sChasse:returnStart", function(chasse)
    if openedMenu then
        RageUI.CloseAll()
        FreezeEntityPosition(PlayerPedId(), false) 
        openedMenu = false 
        resultLicense = nil
    end
    RageUI.Popup({message = "Bonne ~o~chasse~s~ ! Je t'ai mis un fusil dans ton sac et un véhicule proche de toi ."})
    local hash = GetHashKey("rebel2")
    if not ESX.Game.IsSpawnPointClear(chasse.spawnVeh, 5.0) then
        RageUI.Popup({message = "~r~Impossible de faire apparaître le véhicule !"})
    else
        ESX.Game.SpawnVehicle(hash, chasse.spawnVeh, chasse.headingVeh, function(chasseVehicle)
            lastVehicle = chasseVehicle
            local plate = GetVehicleNumberPlateText(chasseVehicle)
            print(plate)
            TriggerEvent('persistent-vehicles/register-vehicle', chasseVehicle)
            TriggerServerEvent("Sneakyesx_vehiclelock:givekey","no",plate)
        end)
    end
    blipsZone = AddBlipForRadius(chasse.posChasse, chasse.radiusChasse)
    SetBlipHighDetail(blipsZone, true)
    SetBlipColour(blipsZone, 17)
    SetBlipAlpha (blipsZone, 128) 
    table.insert(actionsBlips, blipsZone)
    local blipsZone2 = AddBlipForCoord(chasse.posChasse)
    SetBlipSprite (blipsZone2, 141)
    SetBlipDisplay(blipsZone2, 4)
    SetBlipScale  (blipsZone2, 0.9)
    SetBlipAsShortRange(blipsZone2, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Zone de ~o~chasse~s~")
    EndTextCommandSetBlipName(blipsZone2)
    table.insert(actionsBlips, blipsZone2)
    playerInTheChasse = true
    lastChasse = chasse
    launchAnimal(lastChasse)
end)

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end    
end


function launchAnimal(chasse)
    local randomModel = math.random(1, #chasse.animal.model)
    local hash = GetHashKey(chasse.animal.model[randomModel].model)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(250)
    end
    local randomPos = math.random(1, #chasse.animal.pos)
    local randomPed = CreatePed(9, hash, chasse.animal.pos[randomPos].random, 250.0, false, false)
    local blipToPed = AddBlipForEntity(randomPed)
    SetBlipDisplay(blipToPed, 4)
    SetBlipScale(blipToPed, 0.8)
    SetBlipColour(blipToPed, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Animal à tuer")
    EndTextCommandSetBlipName(blipToPed)
    table.insert(chassePed, randomPed)
    table.insert(chasseBlips, blipToPed)
    TaskWanderStandard(randomPed, true, true)
    SetEntityAsMissionEntity(randomPed, true, true)

    while randomPed ~= nil and GetEntityHealth(randomPed) > 0 do
        Wait(50)
    end

    SetBlipColour(blipToPed, 3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Animal à découper")
    EndTextCommandSetBlipName(blipToPed)

    LoadAnimDict('amb@medic@standing@kneel@base')
    LoadAnimDict('anim@gangops@facility@servers@bodysearch@')

    local animalDecoupe = false
    
    while not animalDecoupe do
        local nofps = false
        local entityCoords = GetEntityCoords(randomPed)
        
        if #(GetEntityCoords(PlayerPedId())-entityCoords) < 1.5 then
            nofps = true
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour découper l'animal")
            if IsControlJustReleased(0, 38) then
                TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
                TaskPlayAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
                
                Citizen.Wait(5000)

                ClearPedTasksImmediately(PlayerPedId())
                ESX.ShowNotification('Vous avez ~g~réussi~s~ à découper l\'animal')
                SneakyEvent("sChasse:addItem", chasse.animal.model[randomModel].item, 1)
                animalDecoupe = true
            end
        end

        if nofps then
            Wait(1)
        else
            Wait(850)
        end

    end

    for k,v in pairs(chasseBlips) do
        if DoesBlipExist(v) then
            RemoveBlip(v)
        end
    end

    for k,v in pairs(chassePed) do
        if DoesEntityExist(v) then
            DeleteEntity(v)
        end
    end

    if not playerInTheChasse then
        return
    end

    launchAnimal(chasse)

end

RegisterNetEvent("sChasse:returnStop")
AddEventHandler("sChasse:returnStop", function(chasse, message)
    
    if openedMenu then
        RageUI.CloseAll()
        FreezeEntityPosition(PlayerPedId(), false) 
        openedMenu = false 
        resultLicense = nil
    end
    if message then
        if weaponHash == GetHashKey('weapon_musket') then
            RemoveWeaponFromPed(PlayerPedId(), GetHashKey('weapon_musket'))
        end
        RageUI.Popup({message = "Bon retour parmis ~b~nous~s~ ! J'ai pris ton fusil inutile de le chercher ."})
    else
        RageUI.Popup({message = "Mes affaires c'est en options ? Hahaha, repasse quand tu veux !"})
    end
    if DoesEntityExist(lastVehicle) then
        TriggerEvent('persistent-vehicles/forget-vehicle', lastVehicle)
        DeleteEntity(lastVehicle)
    end

    for k,v in pairs(chasseBlips) do
        if DoesBlipExist(v) then
            RemoveBlip(v)
        end
    end

    for k,v in pairs(chassePed) do
        if DoesEntityExist(v) then
            DeleteEntity(v)
        end
    end

    if #actionsBlips ~= 0 then
        for k,v in pairs(actionsBlips) do
            RemoveBlip(v)
        end
    else
    end
    playerInTheChasse = false
    lastChasse = nil
end)