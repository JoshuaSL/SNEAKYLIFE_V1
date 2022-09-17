ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        player = ESX.GetPlayerData()
        Citizen.Wait(10)
    end
end)

SneakyEvent = TriggerServerEvent
RegisterNetEvent('Sneakyesx_armour:armor')
AddEventHandler('Sneakyesx_armour:armor', function()
	local plyPed = PlayerPedId()

	if GetPedArmour(plyPed) == 100 then
		ESX.ShowNotification("Tu a un gilet par balle neuf")
	else
		SetPedArmour(plyPed, 0)
		ClearPedBloodDamage(plyPed)
		ResetPedVisibleDamage(plyPed)
		ClearPedLastWeaponDamage(plyPed)
		ResetPedMovementClipset(plyPed, 0.0)
		AnimGilet()
		SneakyEvent('Sneakyesx_armour:armorremove')
		ESX.ShowNotification("Tu as utilisé un ~b~gilet~s~ par balle.")
	end
end)

function AntiChlitch()
    Citizen.CreateThread(function()
        while UnGlitch do
            Wait(1)
            DisableControlAction(1, 73, 1)
            DisableControlAction(1, 166, 1)
            DisableControlAction(1, 170, 1)
        end
        ClearPedTasks(GetPlayerPed(-1))
    end)
end

local obj = GetHashKey("prop_cs_heist_bag_02")
local UnGlitch = false

function AnimGilet()
	local pPed = GetPlayerPed(-1)
    local coords = GetOffsetFromEntityInWorldCoords(pPed, 0.0, 0.7, -1.0)
    UnGlitch = true
    AntiChlitch()
    RequestModel(obj)
    while not HasModelLoaded(obj) do Wait(10) end
    local object = CreateObject(obj, coords, 1, 0, 0)
    FreezeEntityPosition(object, 1)
	TaskStartScenarioInPlace(pPed, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, 1)
    Wait(3000)
    PlaySoundFrontend(-1, "Object_Collect_Player", "GTAO_FM_Events_Soundset", 0)
	TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			TriggerEvent('Sneakyskinchanger:loadClothes', skin, {['bproof_1'] = 9,  ['bproof_2'] = 2})
		else
			TriggerEvent('Sneakyskinchanger:loadClothes', skin, {['bproof_1'] = 6,  ['bproof_2'] = 2})
		end
	end)
	SetPedArmour(pPed, 200)
    ClearPedTasks(pPed)
    DeleteEntity(object)
    UnGlitch = false
end

RepairTime = 25
IgnoreAbort = true

RegisterNetEvent('Sneakyesx_repairkit:onUse')
AddEventHandler('Sneakyesx_repairkit:onUse', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, false)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle = nil

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			if IgnoreAbort then
				SneakyEvent('Sneakyesx_repairkit:removeKit')
			end
			TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)

			Citizen.CreateThread(function()
				ThreadID = GetIdOfThisThread()
				CurrentAction = 'repair'

				Citizen.Wait(RepairTime * 1000)

				if CurrentAction ~= nil then
					local veh = ESX.Game.GetClosestVehicle(GetEntityCoords(GetPlayerPed(-1)), nil)
					local ServerID = GetPlayerServerId(NetworkGetEntityOwner(veh))
					SneakyEvent("SneakyLife:Repair", VehToNet(veh), ServerID)
					ESX.ShowNotification("Vous avez fini de ~b~réparer")
					CurrentAction = nil
					ClearPedTasksImmediately(PlayerPedId())
				end
			end)
		end
	else
		ESX.ShowNotification("Aucun véhicule à proximité")
	end
end)


Citizen.CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId(ped))) then
            local veh = GetVehiclePedIsTryingToEnter(PlayerPedId(ped))
            local lock = GetVehicleDoorLockStatus(veh)
            if lock == 7 then
                SetVehicleDoorsLocked(veh, 2)
            end
            local pedd = GetPedInVehicleSeat(veh, -1)
            if pedd then
                SetPedCanBeDraggedOut(pedd, false)
            end
        end
    end
 end)

RegisterNetEvent("Sneaky:Uselockpick")
AddEventHandler("Sneaky:Uselockpick",function()
	local vehicle = ESX.Game.GetVehicleInDirection()
	local coords = GetEntityCoords(PlayerPedId(), false)

	if IsPedSittingInAnyVehicle(PlayerPedId()) then
		ESX.ShowNotification("Vous ne pouvez pas crocheter de véhicule en étant dans un véhicule")
		return
	end
    if ProgressBarExists() then return ShowNotification("~r~Vous ne pouvez pas faire cela.") end
	if DoesEntityExist(vehicle) then
		TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, 1)
        ProgressBar("Crochetage en cours", 100, 100, 100, 200, 10000)
		Citizen.CreateThread(function()
			Citizen.Wait(10000)

			SetVehicleDoorsLocked(vehicle, 1)
			SetVehicleDoorsLockedForAllPlayers(vehicle, false)
			ClearPedTasksImmediately(PlayerPedId())

			ESX.ShowNotification("Véhicule ~g~déverouillé~s~.")
            local chance = math.random(1,100)
            if chance >= 70 then
                TriggerServerEvent("Sneakyremovelockpick")
            end
		end)
	else
		ESX.ShowNotification("~r~Aucun véhicule à proximité.")
	end
end)

function InitTBmx()
    ESX = nil
    Citizen.CreateThread(function()
        while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
        end
    end)
    local entityEnumerator = {
        __gc = function(enum)
            if enum.destructor and enum.handle then
                enum.destructor(enum.handle)
            end

            enum.destructor = nil
            enum.handle = nil
        end
    }

    local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
        return coroutine.wrap(function()
            local iter, id = initFunc()
            if not id or id == 0 then
                disposeFunc(iter)
                return
            end

            local enum = {handle = iter, destructor = disposeFunc}
            setmetatable(enum, entityEnumerator)

            local next = true
            repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
            until not next

            enum.destructor, enum.handle = nil, nil
            disposeFunc(iter)
        end)
    end

    local function EnumerateObjects()
        return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
    end

    local function EnumeratePeds()
        return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
    end

    local function EnumerateVehicles()
        return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
    end

    local function EnumeratePickups()
        return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
    end
    local function spawnCar(car)
        local car = GetHashKey(car)
        RequestModel(car)
        while not HasModelLoaded(car) do
            RequestModel(car)
            Citizen.Wait(0)
        end
        local playerPed = GetPlayerPed(-1)
        local heading = GetEntityHeading(playerPed)
        local vehicle = CreateVehicle(car, x, y-0.6, z, heading, true, false)
        SetEntityAsMissionEntity(vehicle, true, true)
        SetVehicleNumberPlateText(vehicle, "BMX")
    end
    local function locabmxpos()
        x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
        playerX = tonumber(string.format("%.2f", x))
        playerY = tonumber(string.format("%.2f", y))
        playerZ = tonumber(string.format("%.2f", z))
    end
    local function RangerVeh()
        local vehicle = nil
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
            vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), 0)
        else
            vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), 1)
        end
        local plaque = GetVehicleNumberPlateText(vehicle)
        if plaque == "BMX" then
            SetEntityAsMissionEntity(vehicle, false, true)
            DeleteVehicle(vehicle)
            TriggerServerEvent('clp_bmx:addbmx')
        else
            ESX.ShowNotification("~r~Ce n'est pas un bmx.")
        end
    end
    RegisterNetEvent('clp_bmx:usebmx')
    AddEventHandler('clp_bmx:usebmx', function()
        locabmxpos()
        TriggerServerEvent('clp_bmx:removebmx')
        spawnCar("bmx")
    end)
    local vehicle = {}
    Citizen.CreateThread(function()
        while true do 
            vehicle = {}
            for v in EnumerateVehicles() do 
                table.insert(vehicle, v)
            end
            Wait(3000)
        end
    end)
    Citizen.CreateThread(function()
        local count = 0
        while true do
            Wait(0)
            local pPed = GetPlayerPed(-1)
            local pCoords = GetEntityCoords(pPed)
            for k,v in pairs(vehicle) do 
                local oCoords = GetEntityCoords(v)
                local dst = GetDistanceBetweenCoords(pCoords, oCoords, true)
                local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), 1)
                local plaque = GetVehicleNumberPlateText(vehicle)
                if dst <= 1.8 and plaque == "BMX" then 
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~ramasser le bmx.")
                    if IsControlJustReleased(1, 38) then 
                        TaskLeaveVehicle(PlayerPedId(), vehicle, 0)
                        while IsPedInVehicle(PlayerPedId(), vehicle, true) do
                            Citizen.Wait(0)
                        end
                        RangerVeh()
                    end
                end
            end
        end
    end)
end

InitTBmx()
function LoadModel(model)
	while not HasModelLoaded(model) do
		RequestModel(model)
		
		Citizen.Wait(1)
	end
end
function LoadDict(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	  	Citizen.Wait(10)
    end
end

function GetCurrentWeight()
	local currentWeight = 0

	for i = 1, #ESX.PlayerData.inventory, 1 do
		if ESX.PlayerData.inventory[i].count > 0 then
			currentWeight = currentWeight + (ESX.PlayerData.inventory[i].weight * ESX.PlayerData.inventory[i].count)
		end
	end

	return currentWeight
end

RegisterNetEvent("sCore:useDiable")
AddEventHandler("sCore:useDiable",function()
    LoadModel('prop_sacktruck_02b')
    local coords = GetEntityCoords(PlayerPedId())
	local diable = CreateObject(GetHashKey('prop_sacktruck_02b'), coords.x,coords.y + 1.0,coords.z, true)
    PlaceObjectOnGroundProperly(diable)
    PickDiable(diable)
end)

function PickDiable(diable)
    NetworkRequestControlOfEntity(diable)
	LoadDict("anim@heists@box_carry@")
    AttachEntityToEntity(diable, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), -0.00, 0.0, -1.2, 195.0, 180.0, 180.0, 0.0, false, false, true, false, 2, true)
    while IsEntityAttachedToEntity(diable, PlayerPedId()) do
		Citizen.Wait(5)

		if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
			TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
		end

		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(diable, true, true)
		end
        ESX.ShowHelpNotification("Appuyer sur ~INPUT_VEH_DUCK~ pour ranger le diable.")
        if IsControlJustPressed(0, 73) then
            local PlayerWeight = GetCurrentWeight()
            if PlayerWeight < 45 then
                TriggerServerEvent("sCore:diableSystem","diable")
                ClearPedTasksImmediately(PlayerPedId())
                DetachEntity(diable, true, true)
                DeleteEntity(diable)
            else
                ESX.ShowNotification("Vous ne pouvez pas ranger le ~r~diable~s~.")
            end
		end
		DisableControlAction(0, 21, true) -- INPUT_SPRINT
		DisableControlAction(0, 22, true) -- INPUT_JUMP
        DisableControlAction(0, 75, true) -- INPUT_VEH_EXIT
        DisableControlAction(0, 23, true) -- INPUT_ENTER
        DisableControlAction(0, 49, true) -- INPUT_ARREST
        DisableControlAction(0, 145, true) -- INPUT_PARACHUTE_DETACH
        DisableControlAction(0, 185, true) -- INPUT_CELLPHONE_CAMERA_DOF
        DisableControlAction(0, 251, true) -- INPUT_CREATOR_RS
        SetPedMoveRateOverride(PlayerPedId(), 0.6)
	end
end

local Entity = false
local remove_itemname;
function RequestAndWaitModel(modelName)
	if modelName and IsModelInCdimage(modelName) and not HasModelLoaded(modelName) then
		RequestModel(modelName)
		while not HasModelLoaded(modelName) do Citizen.Wait(100) end
	end
end

function DrawTopNotification(txt, beep)
	BeginTextCommandDisplayHelp("jamyfafi")
	AddLongString(txt)
	EndTextCommandDisplayHelp(0, 0, beep, -1)
end

local function getEntInSight(entityType)
	if entityType and type(entityType) == "string" then entityType = entityType == "VEHICLE" and 2 or entityType == "PED" and 8 end
	local ped = GetPlayerPed(-1)
	local pos = GetEntityCoords(ped) + vector3(.0, .0, -.4)
	local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 20.0, 0.0) + vector3(.0, .0, -.4)
	local rayHandle = StartShapeTestRay(pos, entityWorld, entityType and entityType or 10, ped, 0)
	local _,_,_,_, ent = GetShapeTestResult(rayHandle)
	return ent
end

function GetVehicleInSight()
	local ent = getEntInSight(2)
	if ent == 0 then return end
	return ent
end

function AttachObjectPedHand(prop_name, time, flags, state, netstate)
    local pPed = PlayerPedId()
    if Entity and DoesEntityExist(Entity) then
        DeleteEntity(Entity)
    end
    local GameTimer = GetGameTimer()
    while GameTimer + 3000 > GetGameTimer() do
        Wait(500)
    end
    Entity = CreateObject(GetHashKey(prop_name), GetEntityCoords(pPed), not netstate)
    SetNetworkIdCanMigrate(ObjToNet(Entity), false)
    AttachEntityToEntity(Entity, pPed, GetPedBoneIndex(pPed, state and 60309 or 28422), .0, .0, .0, .0, .0, .0, true,true, false, true, 1, not flags)
    if time then
        Citizen.Wait(time)
        if Entity and DoesEntityExist(Entity) then
            DeleteEntity(Entity)
        end
        ClearPedTasks(pPed)
    end
    return Entity
end
local Item_list = {
    ["engine"] = {
        name = "moteur",
        prop = "prop_tool_box_02",
        pos = vector3(.45, -.15, -.005),
        ang = vector3(-90.24, -50.64, 70.24),
        advanced = true
    },
    ["outils"] = {
        name = "trousse à outils",
        prop = "prop_tool_box_04",
        pos = vector3(.35, -.1, -.005),
        ang = vector3(-90.24, -50.64, 70.24),
        advanced = true
    }
}
local isPropsSpawn = false
local DontSpam = false
function AttachCaseToPed(item_name)
    if not DontSpam then
        local EntityVehicle = GetVehicleInSight()
        if exports["sCore"]:ProgressBarExists() then
            ShowAboveRadarMessage("~r~Vous êtes déjà entrain de réaliser quelque chose.")
            return
        end
        if not EntityVehicle then
            ShowAboveRadarMessage("~r~Vous devez regarder un véhicule.")
            return
        end
    end
    if Entity and DoesEntityExist(Entity) then
        DeleteEntity(Entity)
        ClearAreaOfObjects(GetEntityCoords(PlayerPedId()), 3.0, 2)
        return
    end
    if EntityVehicle then
        DontSpam = true
    end
    isPropsSpawn = false;
    local Props = Item_list[item_name]
    local props_model = Props and GetHashKey(Props.prop)
    if not props_model or not IsModelInCdimage(props_model) then
        return
    end
    RequestAndWaitModel(props_model)
    local Time = GetGameTimer()
    while Time + 3000 > GetGameTimer() do
        Wait(1000)
    end
    Entity = CreateObject(props_model, GetEntityCoords(PlayerPedId()), true)
    SetNetworkIdCanMigrate(ObjToNet(Entity), false)
    AttachEntityToEntity(Entity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), Props.pos, Props.ang, true, true, false, true, 0,true)
    if Props.advanced then
        isPropsSpawn = true;
        local PropsClose = false
        DrawTopNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~utiliser votre "..Props.name.."~w~.")
        Citizen.CreateThread(function()
            while isPropsSpawn and Entity and DoesEntityExist(Entity) and GetEntityAttachedTo(Entity) ~= 0 do
                Citizen.Wait(1000)
                if Props.prop == "prop_tool_box_02" or Props.prop == "prop_tool_box_04" then
                    local GetClosestEntity = GetVehicleInSight()
                    PropsClose = nil;
                    if GetClosestEntity and DoesEntityExist(GetClosestEntity) and
                        GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(GetClosestEntity), true) < 4 then
                        PropsClose = GetClosestEntity
                    end
                end
            end
            ClearHelp(-1)
        end)
        Citizen.CreateThread(function()
            while isPropsSpawn and Entity and DoesEntityExist(Entity) and GetEntityAttachedTo(Entity) ~= 0 do
                Citizen.Wait(0)
                if PropsClose and Props.prop == "prop_tool_box_02" or Props.prop == "prop_tool_box_04" and IsControlJustPressed(1, 51) then
                    ClearHelp(-1)
                    AttachCaseToPed(item_name)
                    if Entity and DoesEntityExist(Entity) then
                        DeleteEntity(Entity)
                    end
                    local Propsped = AttachObjectPedHand("prop_cs_wrench")
                    SetFollowVehicleCamViewMode(4)
                    RepairVehicle(Props.prop == "prop_tool_box_02" and 1 or 2, PropsClose)
                    if Propsped and DoesEntityExist(Propsped) then
                        DeleteEntity(Propsped)
                    end
                    SetFollowVehicleCamViewMode(0)
                end
            end
        end)
    end
end

function RequestVehControl(Entity)
    if not Entity then
        return
    end
    local NetVehicle = VehToNet(Entity)
    if NetVehicle > 0 and not NetworkHasControlOfEntity(Entity) then
        NetworkRequestControlOfEntity(Entity)
        while not NetworkHasControlOfEntity(Entity) do
            Citizen.Wait(0)
        end
        return true
    end
end

function RepairVehicle(type, Entity)
    timetowait = 8000
    if exports["sCore"]:ProgressBarExists() then
        ShowAboveRadarMessage("~r~Vous êtes déjà entrain de réaliser quelque chose.")
        return
    end
    if not Entity or not DoesEntityExist(Entity) then
        ShowAboveRadarMessage("~r~Vous devez regarder un véhicule.")
        return
    end
    local Mecano = type == 2 and "outils" or "engine"
    ExecuteCommand("me effectue une réparation.")
    exports["sCore"]:ProgressBar("Réparation en cours", 58, 173, 0, 200, timetowait)
    if type == 2 then
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_VEHICLE_MECHANIC", -1, true)
    else
        RequestAnimDict("mini@repair")
        while not HasAnimDictLoaded("mini@repair") do
            Citizen.Wait(10)
        end
        TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_ped", 8.0, -8.0, -1, 1, 0.0, false, false, false)
    end
    SetEntityHeading(PlayerPedId(), type == 2 and GetEntityHeading(PlayerPedId()) - 180.0 or GetEntityHeading(PlayerPedId()))
    RequestVehControl(Entity)
    SetVehicleUndriveable(Entity, true)
    Citizen.Wait(timetowait)
    RequestVehControl(Entity)
    SetNetworkIdCanMigrate(VehToNet(Entity), false)
    SetVehicleUndriveable(Entity, false)
    if type == 1 then
        SetVehicleEngineHealth(Entity, 1000.0)
    elseif type == 2 then
        local GetBurstVehicle, GetActualFuelLevel, GeEngineHealthFromVehicle = {}, GetVehicleFuelLevel(Entity), GetVehicleEngineHealth(Entity)
        for i = 0, 10 do
            GetBurstVehicle[i] = IsVehicleTyreBurst(Entity, i)
        end
        SetVehicleUndriveable(Entity, false)
        SetVehicleFixed(Entity)
        SetVehicleFuelLevel(Entity, GetActualFuelLevel)
        SetVehicleEngineHealth(Entity, GeEngineHealthFromVehicle)
        for k, v in pairs(GetBurstVehicle) do
            if v and (v == true or v == 1) then
                SetVehicleTyreBurst(Entity, tonumber(k), true, 1000.0)
            end
        end
        SetVehicleEngineOn(Entity, true, false)
        SetVehicleBodyHealth(Entity, 1000.0)
        ForceEntityAiAndAnimationUpdate(Entity)
    end
    SetNetworkIdCanMigrate(VehToNet(Entity), true)
    ShowAboveRadarMessage("~g~Vous avez terminé de réparer le véhicule.")
    DontSpam = false
    TriggerServerEvent("SneakyLife:UseItemFinish", remove_itemname)
    ClearPedTasks(PlayerPedId())
end

function AddLongString(txt)
	local maxLen = 100
	for i = 0, string.len(txt), maxLen do
		local sub = string.sub(txt, i, math.min(i + maxLen, string.len(txt)))
		AddTextComponentString(sub)
	end
end

function ShowAboveRadarMessage(message, back)
	if back then ThefeedNextPostBackgroundColor(back) end
	SetNotificationTextEntry("jamyfafi")
	AddLongString(message)
	return DrawNotification(0, 1)
end

RegisterNetEvent("SneakyLife:UseItemMecano")
AddEventHandler("SneakyLife:UseItemMecano", function(item_name)
    remove_itemname = item_name
    AttachCaseToPed(item_name)
end)
local TimeScenerio = 12000
RegisterNetEvent("SneakyLife:UseItemTires")
AddEventHandler("SneakyLife:UseItemTires", function()
    local Entity = GetVehicleInSight()
    if exports["sCore"]:ProgressBarExists() then
        ShowAboveRadarMessage("~r~Vous êtes déjà entrain de réaliser quelque chose.")
        return
    end
    if not Entity then
        ShowAboveRadarMessage("~r~Vous devez regarder un véhicule.")
        return
    end
    local ActualTires;
    for i = 0, 10 do
        if IsVehicleTyreBurst(Entity, i) then
            ActualTires = i;
            break
        end
    end
    if not ActualTires then
        ShowAboveRadarMessage("~r~Les roues de ce véhicule sont dans un très bon état.")
        return
    end
    local pPed = PlayerPedId()
    ExecuteCommand("me change une roue.")
    TaskStartScenarioInPlace(pPed, "WORLD_HUMAN_VEHICLE_MECHANIC", -1, true)
    SetEntityHeading(pPed, GetEntityHeading(pPed) - 180.0)
    SetVehicleUndriveable(Entity, true)
    exports["sCore"]:ProgressBar("Changement de la roue", 58, 173, 0, 200, TimeScenerio)
    Citizen.Wait(TimeScenerio)
    ClearPedTasks(PlayerPedId())
    SetVehicleUndriveable(Entity, false)
    SetVehicleTyreFixed(Entity, ActualTires)
    ShowAboveRadarMessage("Vous avez réparé une ~b~roue du véhicule~s~.")
    TriggerServerEvent("SneakyLife:UseItemFinish", "pneu")
end)
TimeWash = 6000
RegisterNetEvent("SneakyLife:UseItemWash")
AddEventHandler("SneakyLife:UseItemWash", function()
    local Entity = GetVehicleInSight()
    if exports["sCore"]:ProgressBarExists() then
        ShowAboveRadarMessage("~r~Vous êtes déjà entrain de réaliser quelque chose.")
        return
    end
    if not Entity or not DoesEntityExist(Entity) then
        ShowAboveRadarMessage("~r~Vous devez regarder un véhicule.")
        return
    end
    ExecuteCommand("me lave le véhicule.")
    local pPed = PlayerPedId()
    TaskStartScenarioInPlace(pPed, "WORLD_HUMAN_BUM_WASH", -1, true)
    SetVehicleUndriveable(Entity, true)
    exports["sCore"]:ProgressBar("Nettoyage en cours", 58, 173, 0, 200, TimeWash)
    Citizen.Wait(TimeWash)
    ClearPedTasks(PlayerPedId())
    SetVehicleUndriveable(Entity, true)
    SetVehicleUndriveable(Entity, false)
    SetVehicleDirtLevel(Entity, 0)
    ShowAboveRadarMessage("Vous avez terminé de ~g~laver le véhicule~s~.")
    TriggerServerEvent("SneakyLife:UseItemFinish", "kit_de_lavage")
end)
