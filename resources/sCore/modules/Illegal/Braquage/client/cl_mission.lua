local configPed = {}
local configMission = {}
local MissionDone = {}
local sync = false
local MenuOpen = false

ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
    	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    	Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    TriggerServerEvent("sMission:GetData")
    TriggerServerEvent("sMission:status")
end)
RegisterNetEvent("sMission:GetData")
AddEventHandler("sMission:GetData", function(confPed, confMission)
    configPed = confPed
    configMission = confMission
    sync = true
end)
RegisterNetEvent("sMission:status")
AddEventHandler("sMission:status", function(done)
    MissionDone = done
end)

local TimeMissionLimit = 60*1000*20

function createped(model,pos,heading,pPed,weapon)
    local playerped = GetPlayerPed(-1)
    RequestModel(model)
        while not HasModelLoaded(model) do
        Wait(10)
    end
    AddRelationshipGroup('MissionNPC')
	AddRelationshipGroup('PlayerPed')
	pedy = CreatePed(4, model, pos.x, pos.y+5, pos.z, heading, false, false)
	SetPedRelationshipGroupHash(pedy, 'MissionNPC')
    GiveWeaponToPed(pedy,GetHashKey(weapon),250,false,true)
    SetPedInfiniteAmmo(pedy,true,GetHashKey(weapon))
    SetCurrentPedWeapon(pedy,GetHashKey(weapon),true)
	SetPedArmour(pedy,100)
	SetPedDropsWeaponsWhenDead(pedy, false) 
	SetRelationshipBetweenGroups(5,GetPedRelationshipGroupDefaultHash(playerped),'MissionNPC')
	SetRelationshipBetweenGroups(5,'MissionNPC',GetPedRelationshipGroupDefaultHash(playerped))
    TaskAimGunAtEntity(pedy,playerped,2000,false)
    TaskShootAtEntity(pedy,playerped,6000,-957453492)
end
function VoleDeVehicule(LongText, vehicule, possibleSpawn, stop, prix, id)
    TriggerServerEvent("sMission:ChangeState",true)
    StartMusicEvent("MP_MC_ASSAULT_ADV_START")
    StartMusicEvent("MP_MC_ASSAULT_ADV_SUSPENSE")
    ESX.AddTimerBar("TEMPS RESTANT :",{endTime=GetGameTimer()+TimeMissionLimit})
    ShowAboveRadarMessage("~b~Simeon\n~s~"..LongText)
    local i = math.random(1, #possibleSpawn)
    local spawn = possibleSpawn[i].pos
    local heading = possibleSpawn[i].heading

    local blip = createBlip(spawn ,326,3,"Véhicule",true,1.0)
    local pPed = GetPlayerPed(-1)
    local pVeh = GetVehiclePedIsIn(pPed, false)
    local pCoords = GetEntityCoords(pPed)
    local dst = GetDistanceBetweenCoords(spawn, pCoords, true)
    while dst >= 30.0 do
        Wait(100)
        pCoords = GetEntityCoords(pPed)
        dst = GetDistanceBetweenCoords(spawn, pCoords, true)
        RageUI.Text({message = "Dirigez vous vers ~b~la destination~s~."})
    end
    local pos = PlayerPedId()
    TriggerServerEvent("sPolice:enterAppel", spawn.x, spawn.y, spawn.z, "Fusillade", "Des coups de feu ont été ~r~tirés~s~ rendez vous sur place.")
    SpawnVehNotIn(vehicule, spawn, heading, "SIMEONYE")
    createped("s_m_y_robber_01",spawn,heading,GetPlayerPed(-1),"weapon_poolcue")
    createped("mp_m_g_vagfun_01",spawn,heading,GetPlayerPed(-1),"weapon_battleaxe")

    while dst >= 3.0 do
        Wait(1)
        DistantCopCarSirens(1)
        ShowFloatingHelp("VOLE_VEH_MISSION", spawn)
        RageUI.Text({message = "Le ~r~véhicule ~s~n'est pas loin."})
        pCoords = GetEntityCoords(pPed)
        DrawMarker(0,spawn.x,spawn.y,spawn.z+2.6,0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,0.7,0,192,255,70,0,0,2,0,0,0,0)
        dst = GetDistanceBetweenCoords(spawn, pCoords, true)
    end

    RemoveBlip(blip)

    local blip = AddBlipForCoord(stop)
    SetBlipRoute(blip, 1)
    
    local dst = GetDistanceBetweenCoords(stop, pCoords, true)
    PlaySoundFrontend(-1, "Object_Dropped_Remote", "GTAO_FM_Events_Soundset", 0)
    ShowAboveRadarMessage("~b~Simeon\n~s~Crochetez le véhicule avec vos lockpick.")
    SetFakeWantedLevel(2)
    while dst >= 5.0 do
        Wait(1)
        RageUI.Text({message = "Livrez le véhicule ~y~à destination~s~."})
        pCoords = GetEntityCoords(pPed)
        dst = GetDistanceBetweenCoords(pCoords, stop, true)
    end

    local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), 0))
    local pEngine = GetVehicleEngineHealth(GetVehiclePedIsIn(GetPlayerPed(-1)))
    if plate == "SIMEONYE" then 
        if pEngine > 750 then 
            ESX.RemoveTimerBar()
            PlaySoundFrontend(-1, "Out_Of_Bounds_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
            ShowAboveRadarMessage("~b~Simeon\n~s~Vous avez reçu de l'argent. (~r~"..prix.."$~s~).")
            DistantCopCarSirens(0)
            RemoveBlip(blip)
            SetBlipRoute(blip, 0)
            TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), 0), 6, 2000)
            Wait(2000)
            TaskLeaveAnyVehicle(GetPlayerPed(-1), 0, 0)
            SetVehicleDoorsLocked(GetVehiclePedIsIn(GetPlayerPed(-1), 1), 1)
            StartMusicEvent("MP_MC_ASSAULT_ADV_STOP")
            TriggerServerEvent("sMission:Gain", prix)
            TriggerServerEvent("sMission:ChangeState",false)
            TriggerServerEvent("sMission:SetStatus", id)
            gain = prix
            DeleteVehi()
            SetFakeWantedLevel(0)
        else 
            ShowAboveRadarMessage("~b~Simeon\n~s~Votre véhicule est trop abimé.")
            ESX.RemoveTimerBar()
            PlaySoundFrontend(-1, "Out_Of_Bounds_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
            DistantCopCarSirens(0)
            RemoveBlip(blip)
            SetBlipRoute(blip, 0)
            TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), 0), 6, 2000)
            Wait(2000)
            TaskLeaveAnyVehicle(GetPlayerPed(-1), 0, 0)
            SetVehicleDoorsLocked(GetVehiclePedIsIn(GetPlayerPed(-1), 1), 1)
            StartMusicEvent("MP_MC_ASSAULT_ADV_STOP")
            TriggerServerEvent("sMission:SetStatus", id)
            Wait(3500)
            DeleteVehi()
            TriggerServerEvent("sMission:ChangeState",false)
            SetFakeWantedLevel(0)
        end
    else
        ESX.RemoveTimerBar()
        DistantCopCarSirens(0)
        PlaySoundFrontend(-1, "Out_Of_Bounds_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
        RemoveBlip(blip)
        SetBlipRoute(blip, 0)
        ShowAboveRadarMessage("~b~Simeon\n~s~T'a essayé de me niquer ? T'aurais pas dû !")
        StartMusicEvent("MP_MC_ASSAULT_ADV_STOP")
        TriggerServerEvent("sMission:SetStatus", id)
        SetEntityHealth(GetPlayerPed(-1), 125)
        DeleteVehi()
        TriggerServerEvent("sMission:ChangeState",false)
        SetFakeWantedLevel(0)
    end
end

function VoleDeVehiculeLamar(LongText, vehicule, possibleSpawn, stop, prix, id)
    TriggerServerEvent("sMission:ChangeState",true)
    local pVehSdq = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    StartMusicEvent("MP_MC_ASSAULT_ADV_START")
    StartMusicEvent("MP_MC_ASSAULT_ADV_SUSPENSE")
    ESX.AddTimerBar("TEMPS RESTANT :",{endTime=GetGameTimer()+TimeMissionLimit})
    ShowAboveRadarMessage("~g~Lamar\n~s~"..LongText)
    local i = math.random(1, #possibleSpawn)
    local spawn = possibleSpawn[i].pos
    local heading = possibleSpawn[i].heading

    local blip = createBlip(spawn ,326,2,"Véhicule",true,1.0)
    local pPed = GetPlayerPed(-1)
    local pVeh = GetVehiclePedIsIn(pPed, false)
    local pCoords = GetEntityCoords(pPed)
    local dst = GetDistanceBetweenCoords(spawn, pCoords, true)
    while dst >= 30.0 do
        Wait(100)
        pCoords = GetEntityCoords(pPed)
        dst = GetDistanceBetweenCoords(spawn, pCoords, true)
        RageUI.Text({message = "Dirigez vous vers ~y~la destination~s~."})
    end
    TriggerServerEvent("sPolice:enterAppel", spawn.x, spawn.y, spawn.z, "Bagarre", "Une bagarre vient d'éclater.")
    SpawnVehNotIn(vehicule, spawn, heading, "LOWRIDER")
    createped("ig_g",spawn,heading,GetPlayerPed(-1),"weapon_bat")
    createped("s_m_y_dealer_01",spawn,heading,GetPlayerPed(-1),"weapon_machete")

    while dst >= 3.0 do
        Wait(1)
        DistantCopCarSirens(1)
        ShowFloatingHelp("VOLE_VEH_MISSION", spawn)
        RageUI.Text({message = "Le ~r~véhicule ~s~n'est pas loin."})
        pCoords = GetEntityCoords(pPed)
        DrawMarker(0,spawn.x,spawn.y,spawn.z+2.6,0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,0.7,6,214,20,70,0,0,2,0,0,0,0)
        dst = GetDistanceBetweenCoords(spawn, pCoords, true)
    end

    RemoveBlip(blip)

    local blip = AddBlipForCoord(stop)
    SetBlipRoute(blip, 1)
    
    local dst = GetDistanceBetweenCoords(stop, pCoords, true)
    PlaySoundFrontend(-1, "Object_Dropped_Remote", "GTAO_FM_Events_Soundset", 0)
    ShowAboveRadarMessage("~g~Lamar\n~s~Crochetez le véhicule avec vos lockpick.")
    SetFakeWantedLevel(2)
    while dst >= 5.0 do
        Wait(1)
        RageUI.Text({message = "Livrez le véhicule ~g~à destination~s~."})
        pCoords = GetEntityCoords(pPed)
        dst = GetDistanceBetweenCoords(pCoords, stop, true)
    end

    local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), 0))
    local pEngine = GetVehicleEngineHealth(GetVehiclePedIsIn(GetPlayerPed(-1)))
    if plate == "LOWRIDER" then 
        if pEngine > 750 then 
            ESX.RemoveTimerBar()
            PlaySoundFrontend(-1, "Out_Of_Bounds_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
            ShowAboveRadarMessage("~g~Lamar\n~s~Vous avez reçu de l'argent. (~r~"..prix.."$~s~).")
            DistantCopCarSirens(0)
            RemoveBlip(blip)
            SetBlipRoute(blip, 0)
            TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), 0), 6, 2000)
            Wait(2000)
            TaskLeaveAnyVehicle(GetPlayerPed(-1), 0, 0)
            SetVehicleDoorsLocked(GetVehiclePedIsIn(GetPlayerPed(-1), 1), 1)
            StartMusicEvent("MP_MC_ASSAULT_ADV_STOP")
            TriggerServerEvent("sMission:Gain", prix)
            TriggerServerEvent("sMission:SetStatus", id)
            TriggerServerEvent("sMission:ChangeState",false)
            gain = prix
            DeleteVehi()
            SetFakeWantedLevel(0)
        else 
            ShowAboveRadarMessage("~g~Lamar\n~s~Votre véhicule est trop abimé.")
            ESX.RemoveTimerBar()
            PlaySoundFrontend(-1, "Out_Of_Bounds_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
            DistantCopCarSirens(0)
            RemoveBlip(blip)
            SetBlipRoute(blip, 0)
            TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), 0), 6, 2000)
            Wait(2000)
            TaskLeaveAnyVehicle(GetPlayerPed(-1), 0, 0)
            SetVehicleDoorsLocked(GetVehiclePedIsIn(GetPlayerPed(-1), 1), 1)
            StartMusicEvent("MP_MC_ASSAULT_ADV_STOP")
            TriggerServerEvent("sMission:SetStatus", id)
            DeleteVehi()
            TriggerServerEvent("sMission:ChangeState",false)
            SetFakeWantedLevel(0)
        end
    else
        ESX.RemoveTimerBar()
        DistantCopCarSirens(0)
        PlaySoundFrontend(-1, "Out_Of_Bounds_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
        RemoveBlip(blip)
        SetBlipRoute(blip, 0)
        ShowAboveRadarMessage("~g~Lamar\n~s~T'a essayé de me niquer ? T'aurais pas dû !")
        StartMusicEvent("MP_MC_ASSAULT_ADV_STOP")
        TriggerServerEvent("sMission:SetStatus", id)
        SetEntityHealth(GetPlayerPed(-1), 125)
        DeleteVehi()
        TriggerServerEvent("sMission:ChangeState",false)
        SetFakeWantedLevel(0)
    end
end
function Voledemarchandise(LongText, vehicule, possibleSpawn, stop, prix, id)
    TriggerServerEvent("sMission:ChangeState",true)
    local pVehSdq = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    StartMusicEvent("MP_MC_ASSAULT_ADV_START")
    StartMusicEvent("MP_MC_ASSAULT_ADV_SUSPENSE")
    ESX.AddTimerBar("TEMPS RESTANT :",{endTime=GetGameTimer()+TimeMissionLimit})
    ShowAboveRadarMessage("~r~Cargaison\n~s~"..LongText)
    local i = math.random(1, #possibleSpawn)
    local spawn = possibleSpawn[i].pos
    local heading = possibleSpawn[i].heading

    local blip = createBlip(spawn ,514,1,"Cargaison",true,1.0)
    local pPed = GetPlayerPed(-1)
    local pVeh = GetVehiclePedIsIn(pPed, false)
    local pCoords = GetEntityCoords(pPed)
    local dst = GetDistanceBetweenCoords(spawn, pCoords, true)
    while dst >= 30.0 do
        Wait(100)
        pCoords = GetEntityCoords(pPed)
        dst = GetDistanceBetweenCoords(spawn, pCoords, true)
        RageUI.Text({message = "La ~r~cargaison ~s~ne vas pas t'attendre, dépêche toi !"})
    end
    TriggerServerEvent("sPolice:enterAppel", spawn.x, spawn.y, spawn.z, "Transaction suspecte", "Une cargaison de drogue à été signalé rendez vous sur place au plus vite.")
    SpawnVehNotIn(vehicule, spawn, heading, "MARCH911")
    PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 0)
    createped("ig_dreyfuss",spawn,heading,GetPlayerPed(-1),"weapon_pistol50")

    while dst >= 3.0 do
        Wait(1)
        DistantCopCarSirens(1)
        ShowFloatingHelp("VOLE_VEH_MISSION", spawn)
        RageUI.Text({message = "La ~r~cargaison ~s~n'est pas loin."})
        pCoords = GetEntityCoords(pPed)
        DrawMarker(0,spawn.x,spawn.y,spawn.z+5,0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,0.7,255,0,0,70,0,0,2,0,0,0,0)
        dst = GetDistanceBetweenCoords(spawn, pCoords, true)
    end

    RemoveBlip(blip)

    local blip = AddBlipForCoord(stop)
    SetBlipRoute(blip, 1)
    
    local dst = GetDistanceBetweenCoords(stop, pCoords, true)
    PlaySoundFrontend(-1, "Object_Dropped_Remote", "GTAO_FM_Events_Soundset", 0)
    ShowAboveRadarMessage("~r~Cargaison\n~s~Je t'attend avec la cargaison complète !")
    ShowAboveRadarMessage("~r~Cargaison\n~s~Crochetez le véhicule avec vos lockpick.")
    SetFakeWantedLevel(2)
    while dst >= 5.0 do
        Wait(1)
        RageUI.Text({message = "Livrez la cargaison ~y~à destination~s~."})
        pCoords = GetEntityCoords(pPed)
        dst = GetDistanceBetweenCoords(pCoords, stop, true)
    end

    local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), 0))
    local pEngine = GetVehicleEngineHealth(GetVehiclePedIsIn(GetPlayerPed(-1)))
    if plate == "MARCH911" then 
        if pEngine > 750 then 
            ESX.RemoveTimerBar()
            PlaySoundFrontend(-1, "Out_Of_Bounds_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
            ShowAboveRadarMessage("~r~Cargaison terminé.\n~s~Vous avez reçu une partie de la ~r~cargaison~s~.")
            DistantCopCarSirens(0)
            RemoveBlip(blip)
            SetBlipRoute(blip, 0)
            TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), 0), 6, 2000)
            Wait(2000)
            TaskLeaveAnyVehicle(GetPlayerPed(-1), 0, 0)
            SetVehicleDoorsLocked(GetVehiclePedIsIn(GetPlayerPed(-1), 1), 1)
            StartMusicEvent("MP_MC_ASSAULT_ADV_STOP")
            TriggerServerEvent("sMission:GiveDrugs")
            TriggerServerEvent("sMission:SetStatus", id)
            DeleteVehi()
            TriggerServerEvent("sMission:ChangeState",false)
            SetFakeWantedLevel(0)
        else 
            ShowAboveRadarMessage("~r~Cargaison\n~s~Votre véhicule est trop abimé.")
            ESX.RemoveTimerBar()
            PlaySoundFrontend(-1, "Out_Of_Bounds_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
            DistantCopCarSirens(0)
            RemoveBlip(blip)
            SetBlipRoute(blip, 0)
            TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), 0), 6, 2000)
            Wait(2000)
            TaskLeaveAnyVehicle(GetPlayerPed(-1), 0, 0)
            SetVehicleDoorsLocked(GetVehiclePedIsIn(GetPlayerPed(-1), 1), 1)
            StartMusicEvent("MP_MC_ASSAULT_ADV_STOP")
            TriggerServerEvent("sMission:SetStatus", id)
            DeleteVehi()
            TriggerServerEvent("sMission:ChangeState",false)
            SetFakeWantedLevel(0)
        end
    else
        ESX.RemoveTimerBar()
        DistantCopCarSirens(0)
        PlaySoundFrontend(-1, "Out_Of_Bounds_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
        RemoveBlip(blip)
        SetBlipRoute(blip, 0)
        ShowAboveRadarMessage("~r~Cargaison\n~s~T'a essayé de me niquer ? T'aurais pas dû !")
        StartMusicEvent("MP_MC_ASSAULT_ADV_STOP")
        TriggerServerEvent("sMission:SetStatus", id)
        SetEntityHealth(GetPlayerPed(-1), 125)
        DeleteVehi()
        TriggerServerEvent("sMission:ChangeState",false)
        SetFakeWantedLevel(0)
    end
end

RMenu.Add('mission', 'main', RageUI.CreateMenu("", "",0,0,"root_cause","voldevehicule"))
RMenu:Get('mission', 'main'):SetSubtitle("~c~Missions disponibles")
RMenu:Get('mission', 'main').EnableMouse = false
RMenu:Get('mission', 'main').Closed = function()
    MenuOpen = false
end;

local function OpenMenu(id)
    RageUI.Visible(RMenu:Get('mission', 'main'), not RageUI.Visible(RMenu:Get('mission', 'main')))
    while MenuOpen do
        Citizen.Wait(1)
        if RageUI.Visible(RMenu:Get('mission', 'main')) then
            RageUI.IsVisible(RMenu:Get('mission', 'main'), true, false, true, function()
                for _,v in pairs(configMission) do
                    if v.ped == id then
                        local done = false
                        for _,i in pairs(MissionDone) do
                            if v.id == i then
                                done = true
                            end
                        end
                        if not done then
                            RageUI.Button(v.Titre.." - ~g~Possible", v.Desc, {}, true, function(Hovered, Active, Selected)
                                if (Selected) then
                                    if v.type == "voleVehicule" then
                                        RageUI.Visible(RMenu:Get('mission', 'main'), not RageUI.Visible(RMenu:Get('mission', 'main')))
                                        ESX.TriggerServerCallback('sMissionCheck1', function(valid)
                                            if valid then
                                                MenuOpen = false
                                                TriggerEvent("randPickupAnim")
                                                VoleDeVehicule(v.LongText, v.vehicule, v.possibleSpawn, v.stop, v.prix, v.id) 
                                            else
                                                MenuOpen = false
                                                ESX.ShowNotification("~r~Vous n'avez pas assez de lockpick sur vous (1 requis).")
                                            end
                                        end)
                                    elseif v.type == "voleVehiculeLamar" then
                                        RageUI.Visible(RMenu:Get('mission', 'main'), not RageUI.Visible(RMenu:Get('mission', 'main')))
                                        ESX.TriggerServerCallback('sMissionCheck1', function(valid)
                                            if valid then
                                                MenuOpen = false
                                                TriggerEvent("randPickupAnim")
                                                VoleDeVehiculeLamar(v.LongText, v.vehicule, v.possibleSpawn, v.stop, v.prix, v.id) 
                                            else
                                                MenuOpen = false
                                                ESX.ShowNotification("~r~Vous n'avez pas assez de lockpick sur vous (1 requis).")
                                            end
                                        end)
                                    elseif v.type == "voleMarchandise" then
                                        RageUI.Visible(RMenu:Get('mission', 'main'), not RageUI.Visible(RMenu:Get('mission', 'main')))
                                        ESX.TriggerServerCallback('sMissionCheck1', function(valid)
                                            if valid then
                                                MenuOpen = false
                                                TriggerEvent("randPickupAnim")
                                                Voledemarchandise(v.LongText, v.vehicule, v.possibleSpawn, v.stop, v.prix, v.id) 
                                            else
                                                MenuOpen = false
                                                ESX.ShowNotification("~r~Vous n'avez pas assez de lockpick sur vous (1 requis).")
                                            end
                                        end)
                                    elseif v.type == "braquo" then
                                        RageUI.Visible(RMenu:Get('mission', 'main'), not RageUI.Visible(RMenu:Get('mission', 'main')))
                                        MenuOpen = false
                                        TriggerEvent("randPickupAnim")
                                        braquo(v)
                                    end
                                end
                            end)
                        else
                            RageUI.Button(v.Titre.." - ~r~Impossible", nil, { RightBadge = RageUI.BadgeStyle.Lock }, true, function(Hovered, Active, Selected)
                                if (Selected) then
                                    ShowAboveRadarMessage("~r~Vous avez déjà réalisé cette mission.")
                                end
                            end)
                        end
                    end
                end
            end)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local attente = 500
        local pPed = GetPlayerPed(-1)
        local pCoords = GetEntityCoords(pPed)
        for _,v in pairs(configPed) do
            local dst = GetDistanceBetweenCoords(pCoords, v.coords)
            if not IsPedInAnyVehicle(pPed, false) then 
                if dst <= 2.0 then
                    attente = 5
                    DrawText3D(v.coords.x,v.coords.y,v.coords.z+1.1, "Appuyez sur ~b~E ~w~pour ~b~accéder aux missions.", 9)
                    if IsControlJustReleased(1, 38) then
                        MenuOpen = true
                        OpenMenu(v.id)
                    end
                end
            elseif IsPedInAnyVehicle(pPed, false) then 
                attente = 2500
            end
        end
        Wait(attente)
    end
end)

function StartMusicEvent(event)
	PrepareMusicEvent(event)
	return TriggerMusicEvent(event) == 1
end

function SpawnVeh(vehicle, start, heading)
    RequestModel(vehicle)
    while not HasModelLoaded(vehicle) do Wait(100) end

    local veh = CreateVehicle(vehicle, start, heading, 1, 0) 
    SetVehicleDoorsLocked(veh, 1)
	SetVehicleDoorsLockedForAllPlayers(veh, false)
    SetEntityAsMissionEntity(veh,true,true)
    SetVehicleHasBeenOwnedByPlayer(veh,true)
    TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
    SetVehicleNumberPlateText(veh, "BRAQU911")
end

function SpawnVehNotIn(vehicle, start, heading, plate)
    RequestModel(vehicle)
    while not HasModelLoaded(vehicle) do Wait(100) end

    local veh = CreateVehicle(vehicle, start, heading, 1, 0) 
    SetVehicleDoorsLocked(veh, 0)
	SetVehicleDoorsLockedForAllPlayers(veh, true)
    SetEntityAsMissionEntity(veh,false,false)
    SetVehicleHasBeenOwnedByPlayer(veh,false)
    SetVehicleNumberPlateText(veh, plate)
end

function DeleteVehi()
    Citizen.CreateThread(function()
        local entity = GetVehiclePedIsIn(GetPlayerPed(-1), true)
        NetworkRequestControlOfEntity(entity)
        local test = 0
        while test > 100 and not NetworkHasControlOfEntity(entity) do
            NetworkRequestControlOfEntity(entity)
            Wait(1)
            test = test + 1
        end

        SetEntityAsNoLongerNeeded(entity)
        SetEntityAsMissionEntity(entity, true, true)

        Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized(entity))
     
        while DoesEntityExist(entity) do 
            SetEntityAsNoLongerNeeded(entity)
            DeleteEntity(entity)
            Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized(entity))
            SetEntityCoords(entity, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0)
            Wait(300)
        end 
    end)
end

function ShowHelp(text, n)
    BeginTextCommandDisplayHelp(text)
    EndTextCommandDisplayHelp(n or 0, false, true, -1)
end

function ShowFloatingHelp(text, pos)
    SetFloatingHelpTextWorldPosition(1, pos)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    ShowHelp(text, 2)
end

function createBlip(vector3Pos, intSprite, intColor, stringText, boolRoad, floatScale, intDisplay, intAlpha)
	local blip = AddBlipForCoord(vector3Pos.x, vector3Pos.y, vector3Pos.z)
	SetBlipSprite(blip, intSprite)
	SetBlipAsShortRange(blip, true)
	if intColor then 
		SetBlipColour(blip, intColor) 
	end
	if floatScale then 
		SetBlipScale(blip, floatScale) 
	end
	if boolRoad then 
		SetBlipRoute(blip, boolRoad) 
	end
	if intDisplay then 
		SetBlipDisplay(blip, intDisplay) 
	end
	if intAlpha then 
		SetBlipAlpha(blip, intAlpha) 
	end
	if stringText and (not intDisplay or intDisplay ~= 8) then
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(stringText)
		EndTextCommandSetBlipName(blip)
	end
	return blip
end

local CanDo = nil
RegisterNetEvent("sMission:CanDoIt")
AddEventHandler("sMission:CanDoIt", function(status)
    CanDo = status
end)

function braquo(data)
    CanDo = nil
    TriggerServerEvent("sMission:CanDoIt")
    while CanDo == nil do Wait(10) end
    if CanDo then
        TriggerServerEvent("sMission:SetStatus")
        SetAudioFlag("LoadMPData", 1)
        DoScreenFadeOut(500)
        Wait(500)
        TriggerServerEvent("sMission:ChangeState",true)
        ESX.TriggerServerCallback('Sneakyesx_skin:getPlayerSkin', function(skin)
            TriggerEvent('Sneakyskinchanger:loadSkin', skin)
            TriggerEvent('esx:restoreLoadout')
        end)
        StartMusicEvent("MP_MC_ASSAULT_ADV_START")
        StartMusicEvent("MP_MC_ASSAULT_ADV_SUSPENSE")
        DoScreenFadeIn(500)
        PlaySoundFrontend(-1, "ROUND_ENDING_STINGER_CUSTOM", "CELEBRATION_SOUNDSET", 0)
        
        ShowAboveRadarMessage("~r~Bugstars.\n~b~"..data.LongText)
        local blip = AddBlipForCoord(data.spawnVeh)

        local pPed = GetPlayerPed(-1)
        local pCoords = GetEntityCoords(pPed)
        local dst = GetDistanceBetweenCoords(data.spawnVeh, pCoords, true)
        while dst > 2.5 do
            Wait(1)
            pCoords = GetEntityCoords(pPed)
            dst = GetDistanceBetweenCoords(data.spawnVeh, pCoords, true) 
            ShowFloatingHelp("TRANSPORT_VEH", data.spawnVeh)
            DrawMarker(36, data.spawnVeh.x, data.spawnVeh.y, data.spawnVeh.z+0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 0, 110, 120, 170, 0, 0, 0, 1, nil, nil, 0)
        end
        local clicked = false
        while not clicked do
            Wait(1)
            DrawMarker(36, data.spawnVeh.x, data.spawnVeh.y, data.spawnVeh.z+0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 0, 110, 120, 170, 0, 0, 0, 1, nil, nil, 0)
            DrawTopNotification("Appuyer sur ~INPUT_PICKUP~ pour ~g~sortir le véhicule.")
            if IsControlJustReleased(1, 38) then
                clicked = true
                ShowAboveRadarMessage("~r~Bugstars.\n~b~Maintenant dirigez-vous au lieu indiqué.")
                SpawnVeh(data.vehicule, data.spawnVeh, data.headingStart)
            end
        end
        RemoveBlip(blip)

        local blip = createBlip(data.stopVehicule ,616,3,"Braquage",true,1.0)
        local SurZone = false
        while not SurZone do
            Wait(1)
            RageUI.Text({message = "Dirigez vous vers ~b~la destination~s~."})
            local pPed = GetPlayerPed(-1)
            local pCoords = GetEntityCoords(pPed)
            local dst = GetDistanceBetweenCoords(pCoords, data.stopVehicule, true)
            DrawMarker(36, data.stopVehicule.x, data.stopVehicule.y, data.stopVehicule.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.9, 0.9, 0.9, 0, 110, 120, 170, 0, 0, 0, 1, nil, nil, 0)
            if dst <= 2.0 then
                if GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), 1), 0) == "BRAQU911" then
                    SurZone = true
                end
            end
        end

        SetEntityCoords(GetVehiclePedIsIn(GetPlayerPed(-1), 0), data.stopVehicule.x, data.stopVehicule.y, data.stopVehicule.z, 0.0, 0.0, 0.0, 0.0)
        SetEntityHeading(GetVehiclePedIsIn(GetPlayerPed(-1), 0), data.headingStop)
        TaskLeaveAnyVehicle(GetPlayerPed(-1), 0, 0)
        Wait(500)
        while IsPedInAnyVehicle(GetPlayerPed(-1), 0) do Wait(10) end
        local pCoords = GetEntityCoords(pPed)
        local dst = GetDistanceBetweenCoords(data.ChangementDeTenu, pCoords, true)
        while dst > 1.0 do
            Wait(1)
            pCoords = GetEntityCoords(pPed)
            dst = GetDistanceBetweenCoords(data.ChangementDeTenu, pCoords, true) 
            DrawMarker(41, data.ChangementDeTenu.x, data.ChangementDeTenu.y, data.ChangementDeTenu.z+0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 110, 120, 170, 0, 0, 0, 1, nil, nil, 0)
            RageUI.Text({message = "Dirigez vous vers ~b~le coffre~s~."})
        end
        local clicked = false
        while not clicked do
            Wait(1)
            DrawTopNotification("Appuyer sur ~INPUT_PICKUP~ pour ~b~ouvrir le coffre du véhicule.")
            if IsControlJustReleased(1, 38) then
                clicked = true
            end
        end
        RemoveBlip(blip)
        NetworkRequestControlOfEntity(GetVehiclePedIsIn(GetPlayerPed(-1), 1))
        while not NetworkHasControlOfEntity(GetVehiclePedIsIn(GetPlayerPed(-1), 1)) do Wait(10) end
        SetVehicleDoorOpen(GetVehiclePedIsIn(GetPlayerPed(-1), 1), 3, 0, 0)
        SetVehicleDoorOpen(GetVehiclePedIsIn(GetPlayerPed(-1), 1), 2, 0, 0)

        local clicked = false
        while not clicked do
            Wait(1)
            DrawTopNotification("Appuyer sur ~INPUT_PICKUP~ pour ~r~s'habiller.")
            if IsControlJustReleased(1, 38) then
                clicked = true
            end
        end

        TriggerEvent("Sneakyskinchanger:change", 'mask_1', 85)
        TriggerEvent("Sneakyskinchanger:change", 'bags_1', 12)
        TriggerEvent("Sneakyskinchanger:change", 'bags_2', 0)
        TriggerEvent("Sneakyskinchanger:change", 'decals_1', 76)
        TriggerEvent("Sneakyskinchanger:change", 'tshirt_1', 15)
        TriggerEvent("Sneakyskinchanger:change", 'tshirt_2', 0)
        TriggerEvent("Sneakyskinchanger:change", 'torso_1', 143)
        TriggerEvent("Sneakyskinchanger:change", 'torso_2', 0)
        TriggerEvent("Sneakyskinchanger:change", 'pants_1', 69)
        TriggerEvent("Sneakyskinchanger:change", 'pants_2', 0)
        TriggerEvent("Sneakyskinchanger:change", 'shoes_1', 35)
        TriggerEvent("Sneakyskinchanger:change", 'shoes_2', 0)
        TriggerEvent("Sneakyskinchanger:change", 'arms', 22)
        TriggerEvent("Sneakyskinchanger:change", 'helmet_1', 139)
        TriggerEvent("Sneakyskinchanger:change", 'helmet_2', 0)
        PlaySoundFrontend(-1, "Object_Collect_Player", "GTAO_FM_Events_Soundset", 0)
        local pos = GetEntityCoords(PlayerPedId())
        TriggerServerEvent("sPolice:enterAppel", pos.x, pos.y, pos.z, "Braquage", "Braquage en cours (Bugstars).")
        local EnCours = true
        local blips = {}

        local money = 0
        local objets = 0
        while EnCours do
            Wait(1)
            local pPed = GetPlayerPed(-1)
            local pCoords = GetEntityCoords(pPed)
            local x,y,z = table.unpack(GetEntityCoords(pPed))
            local prop_name = "hei_prop_heist_box"
            RageUI.Text({message = "Volez ~r~les objets~s~ et ~g~l'argent~s~ !"})
            for k,v in pairs(data.possibleVole) do
                DrawMarker(20, v.pos.x, v.pos.y, v.pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.25, 0.25, 0, 110, 120, 170, 0, 0, 0, 1, nil, nil, 0)
                local dst = GetDistanceBetweenCoords(pCoords, v.pos, true)
                if dst <= 0.8 then
                    PlaySoundFrontend(-1, 'Bus_Schedule_Pickup', 'DLC_PRISON_BREAK_HEIST_SOUNDS', 0)
                    local dict, anim = 'anim@heists@box_carry@', 'idle'
					ESX.Streaming.RequestAnimDict(dict)
					TaskPlayAnim(pPed, dict, anim, 1.0, -1.0,-1,49,0,0, 0,0)
                    if not HasModelLoaded(prop_name) then
                        while not HasModelLoaded(GetHashKey(prop_name)) do
                            RequestModel(GetHashKey(prop_name))
                            Wait(10)
                        end
                    end
                    prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
                    AttachEntityToEntity(prop, pPed, GetPedBoneIndex(pPed, 60309), 0.025, 0.08, 0.255, -145.0, 290.0, 0.0, true, true, false, true, 1, true)
                    table.remove(data.possibleVole, k)
                    local dst = GetDistanceBetweenCoords(data.ChangementDeTenu, pCoords, true)
                    while dst > 1.0 do
                        Wait(1)
                        pCoords = GetEntityCoords(pPed)
                        dst = GetDistanceBetweenCoords(data.ChangementDeTenu, pCoords, true) 
                        DrawMarker(39, data.ChangementDeTenu.x, data.ChangementDeTenu.y, data.ChangementDeTenu.z+0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.42, 0.42, 0.42, 0, 110, 120, 170, 0, 0, 0, 1, nil, nil, 0)
                        RageUI.Text({message = "Allez déposer ~b~les objets~s~ dans le coffre."})
                    end

                    objets = objets + math.random(2,6)
                    if notifobj then 
                        RemoveNotification(notifobj)
                    end
                    notifobj = ShowAboveRadarMessage("~r~Bugstars.\n~s~Vous avez (~b~"..objets.."~s~) objets dans votre van.")
                    ClearPedTasks(pPed)
                    DeleteEntity(prop)
                    DeleteObject(prop)
                    PlaySoundFrontend(-1, "Object_Dropped_Remote", "GTAO_FM_Events_Soundset", 0)
                    for k,v in pairs(blips) do
                        RemoveBlip(v)
                    end
                end
            end
            for k,v in pairs(data.Caisse) do
                DrawMarker(29, v.pos.x, v.pos.y, v.pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.25, 0.25, 0, 110, 120, 170, 0, 0, 0, 1, nil, nil, 0)
                local dst = GetDistanceBetweenCoords(pCoords, v.pos, true)
                if dst <= 0.8 then
                    PlaySoundFrontend(-1, 'Bus_Schedule_Pickup', 'DLC_PRISON_BREAK_HEIST_SOUNDS', 0)
                    local dict, anim = 'anim@heists@box_carry@', 'idle'
					ESX.Streaming.RequestAnimDict(dict)
					TaskPlayAnim(pPed, dict, anim, 1.0, -1.0,-1,49,0,0, 0,0)
                    if not HasModelLoaded(prop_name) then
                        while not HasModelLoaded(GetHashKey(prop_name)) do
                            RequestModel(GetHashKey(prop_name))
                            Wait(10)
                        end
                    end
                    prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
                    AttachEntityToEntity(prop, pPed, GetPedBoneIndex(pPed, 60309), 0.025, 0.08, 0.255, -145.0, 290.0, 0.0, true, true, false, true, 1, true)
                    table.remove(data.Caisse, k)
                    local dst = GetDistanceBetweenCoords(data.ChangementDeTenu, pCoords, true)
                    while dst > 1.0 do
                        Wait(1)
                        pCoords = GetEntityCoords(pPed)
                        dst = GetDistanceBetweenCoords(data.ChangementDeTenu, pCoords, true) 
                        DrawMarker(39, data.ChangementDeTenu.x, data.ChangementDeTenu.y, data.ChangementDeTenu.z+0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.42, 0.42, 0.42, 0, 110, 120, 170, 0, 0, 0, 1, nil, nil, 0)
                        RageUI.Text({message = "Déposez les objets dans le coffre."})
                    end

                    ClearPedTasks(pPed)
                    DeleteEntity(prop)
                    DeleteObject(prop)
                    PlaySoundFrontend(-1, "Object_Dropped_Remote", "GTAO_FM_Events_Soundset", 0)
                    local random = math.random(500, 1500)
                    money = money + random
                    ShowAboveRadarMessage("~r~Bugstars.\n~s~Vous avez volé (~b~"..money.."$~s~).")
                    for k,v in pairs(blips) do
                        RemoveBlip(v)
                    end
                end
            end

            if #data.possibleVole + #data.Caisse == 0 then
                EnCours = false
                SetVehicleDoorsShut(GetVehiclePedIsIn(GetPlayerPed(-1), 1), 0)
            end
        end

        for k,v in pairs(blips) do
            RemoveBlip(v)
        end

        PlaySoundFrontend(-1, "Out_Of_Bounds_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
        DistantCopCarSirens(1)
        SetFakeWantedLevel(2)
        local dst = GetDistanceBetweenCoords(data.ChangementDeTenu, pCoords, true)
        while dst <= 100.0 do
            Wait(1)
            pCoords = GetEntityCoords(pPed)
            dst = GetDistanceBetweenCoords(data.ChangementDeTenu, pCoords, true)
        end
        DistantCopCarSirens(0)
        RemoveBlip(blip)
        local blip = AddBlipForCoord(data.stop)
        SetBlipRoute(blip, 1)

        PlaySoundFrontend(-1, "ROUND_ENDING_STINGER_CUSTOM", "CELEBRATION_SOUNDSET", 0)
        local dst = GetDistanceBetweenCoords(data.stop, pCoords, true)
        while dst > 3.0 do
            Wait(1)
            pCoords = GetEntityCoords(pPed)
            dst = GetDistanceBetweenCoords(data.stop, pCoords, true) 
            DrawMarker(36, data.stop.x, data.stop.y, data.stop.z+0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.9, 0.9, 0.9, 0, 110, 120, 170, 0, 0, 0, 1, nil, nil, 0)
            ShowAboveRadarMessage("~r~Bugstars.\n~b~Ok, maintenant rend toi au reseller.")
            RageUI.Text({message = "Dirigez vous vers ~b~le reseller~s~."})
        end
        SetVehicleDoorsLocked(GetVehiclePedIsIn(GetPlayerPed(-1), 1), 1)
        local finalMoney = 0
        for i = 1,objets do
            finalMoney = finalMoney + math.random(50, 160)
        end
        finalMoney = finalMoney + money

        DeleteVehi()
        SetFakeWantedLevel(0)
        DoScreenFadeOut(1000)
        Wait(1000)
        StartMusicEvent("MP_MC_ASSAULT_ADV_STOP")
        Wait(1000)
        SetEntityCoords(PlayerPedId(), -97.24, 2811.32, 53.24-0.98)
        SetEntityHeading(PlayerPedId(), 248.16)
        SetGameplayCamRelativeHeading(0.0)

        local Camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        ShakeCam(Camera,"HAND_SHAKE",0.3)
        SetCamActive(Camera, true)
        RenderScriptCams(true, true, 10, true, true)

        SetCamFov(Camera,50.0)
        SetCamCoord(Camera, -86.44, 2804.96, 53.32-0.93)
        PointCamAtEntity(Camera,GetPlayerPed(-1))
        DoScreenFadeIn(3500)
        local dir = vector3(-87.04, 2805.36, 53.32)
        TaskGoToCoordAnyMeans(PlayerPedId(), dir, 1.0, 0, 0, 786603, 0xbf800000)

        Wait(1000)
        TriggerServerEvent("sMission:Gain", finalMoney)
        TriggerServerEvent("sMission:ChangeState",false)
        ShowAboveRadarMessage("~r~Bugstars.\n~s~Félicitation, vous avez réussi la mission, vous avez reçu (~b~"..finalMoney.."$~s~).")
        TriggerServerEvent("sMission:SetStatus", data.id)
        gain = finalMoney
        displayDoneMission = true
        RemoveBlip(blip)
        Wait(3000)
        RenderScriptCams(false, true, 4000, true, true)
        DestroyCam(Camera)
        Wait(2000)
        ESX.TriggerServerCallback('Sneakyesx_skin:getPlayerSkin', function(skin)
            TriggerEvent('Sneakyskinchanger:loadSkin', skin)
            TriggerEvent('esx:restoreLoadout')
        end)
    else
        ShowAboveRadarMessage("~r~Un braquage à déjà eu lieu recemment.")
    end
end

function DrawTopNotification(txt)
	SetTextComponentFormat("jamyfafi")
	AddLongString(txt)
	DisplayHelpTextFromStringLabel(0, 0, 0, -1)
end