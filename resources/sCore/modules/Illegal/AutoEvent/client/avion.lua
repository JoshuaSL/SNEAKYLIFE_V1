local ObjNetId = 0
local sended = false
local ObjTable = {}
local tip = ""
local ArmesRecup = 0
function removeBlips()
    StopSound(GetSoundId())
    RemoveBlip(blip)
    for k,v in pairs(ObjTable) do
        RemoveObj(v)
    end
end
SneakyEvent = TriggerServerEvent
function avionEvent(data, zone)
    sended = false
    Citizen.CreateThread(function()

        blip = AddBlipForCoord(zone)
        SetBlipSprite(blip, 251)
        SetBlipColour(blip, 1)
        SetBlipScale(blip, 0.5)
        ShowAdvancedNotification("Joaquìn Hernàndez", "~r~Event illégal", data.message, "CHAR_ORTEGA",1)
        local pPed = GetPlayerPed(-1)
        local pCoords = GetEntityCoords(pPed)
        local dst = GetDistanceBetweenCoords(pCoords, zone, true)
        while dst > 150 do
            Wait(100)
            pPed = GetPlayerPed(-1)
            pCoords = GetEntityCoords(pPed)
            dst = GetDistanceBetweenCoords(pCoords, zone, true)
            if EventStop then return end
            if EventStop then break end
        end

        Citizen.CreateThread(function()

            while not EventStop do
                Citizen.Wait(1)
                if closeToEvent then
                    ESX.ShowHelpNotification(tip)
                end
            end
        end)
    
        Citizen.CreateThread(function()
            while not EventStop do
                Citizen.Wait(3500)
                local playerPos = GetEntityCoords(PlayerPedId())
                if GetDistanceBetweenCoords(zone, playerPos, 1) < 30 then
                    closeToEvent = true
                    if GetDistanceBetweenCoords(positionped, playerPos, 1) < 3 then
                        if IsPedInAnyVehicle(PlayerPedId(), true) then
                            tip = "Descendez de votre véhicule."
                        else
                            if ArmesRecup < 10 then
                                tip = "Chercher dans la zone du crash les différents sacs de butins !"
                                PlaySoundFrontend(-1, "Bus_Schedule_Pickup", "DLC_PRISON_BREAK_HEIST_SOUNDS", 1)
                            else
                                tip = "Vous avez eu votre part, partez vite d'ici !"
                                if finish == false then
                                    PlayAmbientSpeech1(ped3, "GENERIC_FUCK_YOU", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR")
                                    finish = true
                                end
                            end
                        end
                    else
                        if ArmesRecup >= 10 then
                            tip = "Éloigne-toi de la zone du crash ! Pour ne pas vous faire attraper par los pollos."
                        else
                            tip = "Chercher les différents butins que vous pouvez trouver dans la zone du crash"
                        end
                    end
                else
                    closeToEvent = false
                end
            end
        end)

        if not EventStop then
            local ped3Model = GetHashKey("g_m_y_salvaboss_01")
            local positionped = vector3(zone.x+math.random(-5.0,5.0), zone.y+math.random(-5.0,5.0), zone.z)
            local positionheading = math.random(20,90)
            RequestModel(ped3Model)
            while not HasModelLoaded(ped3Model) do 
                Citizen.Wait(10) 
            end
            ped3 = CreatePed(9, ped3Model, positionped, positionheading, false, false)
            SetEntityAsMissionEntity(ped3, true,true)
            SetBlockingOfNonTemporaryEvents(ped3, true)
            SetEntityInvincible(ped3, true)
            TaskStartScenarioInPlace(ped3, "WORLD_HUMAN_BINOCULARS", 0, true)
            Citizen.CreateThread(function()
                Citizen.Wait(2000)
                FreezeEntityPosition(ped3,true)
            end)
            table.insert(ObjTable, ped3)
            local ped4Model = GetHashKey("g_m_y_salvaboss_01")
            local positionped2 = vector3(zone.x+math.random(-20.0,20.0), zone.y+math.random(-5.0,5.0), zone.z)
            local positionheading2 = math.random(90,180)
            RequestModel(ped4Model)
            while not HasModelLoaded(ped4Model) do 
                Citizen.Wait(10) 
            end
            ped4 = CreatePed(9, ped4Model, positionped2, positionheading2, false, false)
            SetEntityAsMissionEntity(ped4, true,true)
            SetBlockingOfNonTemporaryEvents(ped4, true)
            SetEntityInvincible(ped4, true)
            Citizen.CreateThread(function()
                Citizen.Wait(2000)
                FreezeEntityPosition(ped4,true)
            end)
            TaskStartScenarioInPlace(ped4, "WORLD_VEHICLE_BIKER", 0, true)
            table.insert(ObjTable, ped4)
            local avion = GetHashKey("cuban800")
            RequestModel(avion)
            while not HasModelLoaded(avion) do Wait(10) end
            local av = CreateVehicle(avion, zone, math.random(0.0,180.0), 0, 0)
            TriggerEvent('persistent-vehicles/register-vehicle', av)
            SetVehicleUndriveable(av, 1)
            FreezeEntityPosition(av, 1)
            SetVehicleEngineHealth(av, 0.0)
            for i = 1,9 do
                SetVehicleDoorOpen(av, i, 0, 1)
            end
            table.insert(ObjTable, av)
            while ArmesRecup < 10 do
                Wait(1)
                local randomProp = data.prop[math.random(1, #data.prop)]
                RequestModel(GetHashKey(randomProp))
                while not HasModelLoaded(GetHashKey(randomProp)) do Wait(10) end
                local randomZone = vector3(zone.x+math.random(-15.0,15.0), zone.y+math.random(-15.0,15.0), zone.z)


                local obj = CreateObject(GetHashKey(randomProp), randomZone, 0, 0, 0)
                table.insert(ObjTable, obj)
                ObjNetId = obj
                PlaceObjectOnGroundProperly(obj)
                FreezeEntityPosition(obj, 1)

                local oCoords = GetEntityCoords(obj)
                local dst = GetDistanceBetweenCoords(pCoords, oCoords, 0)
                while dst > 2.0 do
                    Wait(1)
                    pPed = GetPlayerPed(-1)
                    oCoords = GetEntityCoords(obj)
                    pCoords = GetEntityCoords(pPed)
                    dst = GetDistanceBetweenCoords(pCoords, oCoords, 0)
                    if EventStop then return end
                    if EventStop then break end
                end

                if not EventStop then
                    PlaySoundFrontend(-1, "Bus_Schedule_Pickup", "DLC_PRISON_BREAK_HEIST_SOUNDS", 1)
                    RemoveObj(ObjNetId)
                    ArmesRecup = ArmesRecup + 1
                    local nombre = math.random(1,2)
                    local item = data.item[math.random(1,#data.item)]
                    SneakyEvent("RS_AUTOEVENT:GetItem", item, nombre)
                    if EventStop then return end
                    if EventStop then break end
                end

                if ArmesRecup >= 10 then
                    ShowAdvancedNotification("Joaquìn Hernàndez", "~r~Event illégal", "Tu as terminé le travail avant les autres ! On va leur laisser un peu de temps !", "CHAR_ORTEGA",1)
                    Wait(10000)
                    for k,v in pairs(ObjTable) do
                        RemoveObj(v)
                    end
                    SneakyEvent("RS_AUTOEVENT:Recuperer")
                    sended = true
                    break
                end
                if EventStop then 
                    ArmesRecup = 99 break 
                end
            end

            if not sended then
                SneakyEvent("RS_AUTOEVENT:Recuperer")
                sended = true
            end
            ShowAdvancedNotification("Joaquìn Hernàndez", "~r~Event illégal", "Cargaison récupérée!", "CHAR_ORTEGA",1)
            PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
        end
        Wait(10000)
        for k,v in pairs(ObjTable) do
            RemoveObj(v)
        end
        ObjTable = {}

        RemoveBlip(blip)
    end)
end