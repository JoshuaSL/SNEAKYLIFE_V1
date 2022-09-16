Death = Death or {}
Death.deathTime = 0
Death.deathTime1 = 0
Death.waitTime = 8 * 60000
Death.waitTimeKo = 10 * 1000
Death.deathCause = {}
Death.HasRespawn = false
Death.HasRespawnTimer = 0
Death.RespawnTimeClean = 33 * 1000
Death.RespawnTime = 0
Death.contend = false
Death.tranch = false 
Death.Call = true 
isPlayerAbuse = false
local deadtimeout = false
Death.IsSoigne = false

Death.weaponHashType = { "Inconnue", "Dégâts de mêlée", "Blessure par balle", "Chute", "Dégâts explosifs", "Feu", "Chute", "Éléctrique", "Écorchure", "Gaz", "Gaz", "Eau" }
Death.boneTypes = {
    ["Dos"] = { 0, 23553, 56604, 57597 },
    ["Crâne"] = { 1356, 11174, 12844, 17188, 17719, 19336, 20178, 20279, 20623, 21550, 25260, 27474, 29868, 31086, 35731, 43536, 45750, 46240, 47419, 47495, 49979, 58331, 61839, 39317 },
    ["Coude droit"] = { 2992 },
    ["Coude gauche"] = { 22711 },
    ["Main gauche"] = { 4089, 4090, 4137, 4138, 4153, 4154, 4169, 4170, 4185, 4186, 18905, 26610, 26611, 26612, 26613, 26614, 60309 },
    ["Main droite"] = { 6286, 28422, 57005, 58866, 58867, 58868, 58869, 58870, 64016, 64017, 64064, 64065, 64080, 64081, 64096, 64097, 64112, 64113 },
    ["Bras gauche"] = { 5232, 45509, 61007, 61163 },
    ["Bras droit"] = { 28252, 40269, 43810 },
    ["Jambe droite"] = { 6442, 16335, 51826, 36864 },
    ["Jambe gauche"] = { 23639, 46078, 58271, 63931 },
    ["Pied droit"] = { 20781, 24806, 35502, 52301 },
    ["Pied gauche"] = { 2108, 14201, 57717, 65245 },
    ["Poîtrine"] = { 10706, 64729, 24816, 24817, 24818 },
    ["Ventre"] = { 11816 },
}

Death.AllWeaponKO = {
    GetHashKey("weapon_bat"),
    GetHashKey("weapon_crowbar"),
    GetHashKey("weapon_unarmed"),
    GetHashKey("weapon_flashlight"),
    GetHashKey("weapon_golfclub"),
    GetHashKey("weapon_hammer"),
    GetHashKey("weapon_knuckle"),
    GetHashKey("weapon_nightstick"),
    GetHashKey("weapon_wrench"),
    GetHashKey("weapon_poolcue"),
    GetHashKey("weapon_snowball"),
    GetHashKey("weapon_ball"),
    GetHashKey("weapon_flare"),
    GetHashKey("weapon_flaregun"),
    GetHashKey("weapon_dagger"),
    GetHashKey("weapon_bottle"),
    GetHashKey("weapon_hatchet"),
    GetHashKey("weapon_knife"),
    GetHashKey("weapon_machete"),
    GetHashKey("weapon_switchblade"),
    GetHashKey("weapon_battleaxe"),
    GetHashKey("weapon_stone_hatchet"),
}

Death.WeaponHashcontend = {
    GetHashKey("weapon_bat"),
    GetHashKey("weapon_crowbar"),
    GetHashKey("weapon_unarmed"),
    GetHashKey("weapon_flashlight"),
    GetHashKey("weapon_golfclub"),
    GetHashKey("weapon_hammer"),
    GetHashKey("weapon_knuckle"),
    GetHashKey("weapon_nightstick"),
    GetHashKey("weapon_wrench"),
    GetHashKey("weapon_poolcue"),
    GetHashKey("weapon_snowball"),
    GetHashKey("weapon_ball"),
    GetHashKey("weapon_flare"),
    GetHashKey("weapon_flaregun"),
}

Death.WeaponHashtranch = {
    GetHashKey("weapon_dagger"),
    GetHashKey("weapon_bottle"),
    GetHashKey("weapon_hatchet"),
    GetHashKey("weapon_knife"),
    GetHashKey("weapon_machete"),
    GetHashKey("weapon_switchblade"),
    GetHashKey("weapon_battleaxe"),
    GetHashKey("weapon_stone_hatchet"),
}

Death.PlayerDead = false 
Death.PlayerKO = false 
ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do 
        TriggerEvent('Sneakyesx:getSharedObject', function(a)
            ESX = a 
        end)
    end 
end)

local function GetPlayerByEntityID(id)
    for i = 0, 255 do
        if (NetworkIsPlayerActive(i) and GetPlayerPed(i) == id) then
            return i
        end
    end
    return nil
end

function Death:TableGetValue(Y,Z,n)
    if not Y or not Z or type(Y)~="table"then 
        return 
    end
    for O,y in pairs(Y)do 
        if n and y[n]==Z or y==Z then 
            return true,O 
        end 
    end 
end

function Death:Revive()
    local pPed = PlayerPedId()
    NetworkResurrectLocalPlayer(GetEntityCoords(pPed), GetEntityHeading(pPed), true, true, false)
    ClearPedDecorations(PlayerPedId())
	SneakyEvent("SneakyLife:requestPlayerTatoos")
	SneakyEvent("SneakyClothesGetHairFade")
    SetTimeout(100, function()
        local pPed2 = GetPlayerPed(-1)
        if pPed ~= pPed2 then
            DeleteEntity(pPed)
        end
    end)
end

function Death:DrawTextScreen(Text,Text3,Taille,Text2,Font,Justi,havetext)
    SetTextFont(Font)
    SetTextScale(Taille, Taille)
    SetTextColour(255, 255, 255, 255)
    SetTextJustification(Justi or 1)
    SetTextEntry("STRING")
    if havetext then 
        SetTextWrap(Text, Text + 0.1)
    end
    AddTextComponentString(Text2)
    DrawText(Text, Text3)
end

function Death:DrawCenterText(msg, time)
	ClearPrints()
	SetTextEntry_2("jamyfafi")
	AddTextComponentString(msg)
	DrawSubtitleTimed(time and math.ceil(time) or 0, true)
end

function Death:TeleportCoords(vector, peds)
	if not vector or not peds then return end
	local x, y, z = vector.x, vector.y, vector.z + 0.98
	peds = peds or PlayerPedId()

	RequestCollisionAtCoord(x, y, z)
	NewLoadSceneStart(x, y, z, x, y, z, 50.0, 0)

	local TimerToGetGround = GetGameTimer()
	while not IsNewLoadSceneLoaded() do
		if GetGameTimer() - TimerToGetGround > 3500 then
			break
		end
		Citizen.Wait(0)
	end

	SetEntityCoordsNoOffset(peds, x, y, z)

	TimerToGetGround = GetGameTimer()
	while not HasCollisionLoadedAroundEntity(peds) do
		if GetGameTimer() - TimerToGetGround > 3500 then
			break
		end
		Citizen.Wait(0)
	end

	local retval, GroundPosZ = GetGroundZCoordWithOffsets(x, y, z)
	TimerToGetGround = GetGameTimer()
	while not retval do
		z = z + 5.0
		retval, GroundPosZ = GetGroundZCoordWithOffsets(x, y, z)
		Wait(0)

		if GetGameTimer() - TimerToGetGround > 3500 then
			break
		end
	end

	SetEntityCoordsNoOffset(peds, x, y, retval and GroundPosZ or z)
	NewLoadSceneStop()
	return true
end

function Death:CreateEffect(style, default, time) 
    Citizen.CreateThread(function()
        DoScreenFadeOut(1000)
        Citizen.Wait(1000)
        SetTimecycleModifier(style or "spectator3")
        if default then 
            SetCamEffect(2)
        end
        DoScreenFadeIn(1000)
        Citizen.Wait(time or 20000)
        local pPed = GetPlayerPed(-1)
        DoScreenFadeOut(1000)
        Citizen.Wait(1000)
        DoScreenFadeIn(1000)
        ClearTimecycleModifier()
        ResetScenarioTypesEnabled()
        SetPedIsDrunk(pPed,false)
		SetCamEffect(0)
    end)
end

function Death:GetAllCauseOfDeath(ped)
    local exist, lastBone = GetPedLastDamageBone(ped)
    local cause, what, timeDeath = GetPedCauseOfDeath(ped), Citizen.InvokeNative(0x93C8B64DEB84728C, ped), Citizen.InvokeNative(0x1E98817B311AE98A, ped)
    if what and DoesEntityExist(what) then
        if IsEntityAPed(what) then
            what = "Traces de combat"
        elseif IsEntityAVehicle(what) then
            what = "Écrasé par un véhicule"
        elseif IsEntityAnObject(what) then
            what = "Semble s'être pris un objet"
        end
    end
    what = type(what) == "string" and what or "Inconnue"

    if cause then
        if IsWeaponValid(cause) then
            cause = Death.weaponHashType[GetWeaponDamageType(cause)] or "Inconnue"
        elseif IsModelInCdimage(cause) then
            cause = "Véhicule"
        end
    end
    cause = type(cause) == "string" and cause or "Mêlée"

    local boneName = "Dos"
    if exist and lastBone then
        for k, v in pairs(Death.boneTypes) do
            if Death:TableGetValue(v, lastBone) then
                boneName = k
                break
            end
        end
    end

    return timeDeath, what, cause, boneName
end

function Death:RequestAndWaitDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do 
        Wait(50)
    end
end

RegisterCommand("die",function()
	SetEntityHealth(PlayerPedId(),0)
end)

Clothsambulancepatient = {

	clothspatient = {
		men = {
			{
				grade = "Blouse Patient",
				cloths = {
					['tshirt_1'] = 15,  ['tshirt_2'] = 0,
					['torso_1'] = 448,   ['torso_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 15,
					['pants_1'] = 145,   ['pants_2'] = 0,
					['shoes_1'] = 34,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 0,    ['chain_2'] = 0,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['mask_1'] = 0,     ['mask_2'] = 0,
					['bags_1'] = 0,     ['bags_2'] = 0,
					['bproof_1'] = 0,     ['bproof_2'] = 0
				},
			},
		},
		women = {
			
			{
				grade = "Blouse Patient",
				cloths = {
					['tshirt_1'] = 14,  ['tshirt_2'] = 0,
					['torso_1'] = 451,   ['torso_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 4,
					['pants_1'] = 151,   ['pants_2'] = 0,
					['shoes_1'] = 35,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 0,    ['chain_2'] = 1,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['mask_1'] = 0,     ['mask_2'] = 0,
					['bags_1'] = 0,     ['bags_2'] = 0,
					['bproof_1'] = 0,     ['bproof_2'] = 0
	
				},
			},
		},
	},
}

timerbaractive = false
local function ThinkDeath(player)
    if Death.PlayerDead then
        Death.PlayerKO = false 
        SetPedToRagdoll(PlayerPedId(),1000, 1000, 0, 0, 0, 0)
        if IsControlJustPressed(1, 47) and Death.Call then 
            ESX.ShowNotification("Vous avez appelé les ~b~secours~s~.")
            TriggerServerEvent("sCall:SendCallMsg", "Une personne est au sol.", GetEntityCoords(PlayerPedId()), "ambulance", true)
            Death.Call = false 
        end
        if GetGameTimer() >= Death.deathTime and Death.PlayerDead then
            SetTimecycleModifier("damage")
            Death:DrawTextScreen(0.85, 0.82, 0.8, "Appuyez sur ~b~E~s~ pour contacter les internes.", 4, 0)
            if IsControlJustPressed(1, 38) then 
                local emsCan = nil
                ESX.TriggerServerCallback('sComa:CheckAmbulance', function(cb)
                    emsCan = cb
                end)
                while emsCan == nil do
                    Wait(0)
                end
                if emsCan == true then
                local pPed = player
                Death.PlayerDead = false 
                DoScreenFadeOut(1000)
                local dst1 = Vdist(GetEntityCoords(PlayerPedId()), 326.83410644531,-571.43524169922,43.281616210938) -- LOS SANTOS
                local dst2 = Vdist(GetEntityCoords(PlayerPedId()), 1827.1378173828,3680.2099609375,34.277328491211) -- SANDY SHORE
                if dst1 < dst2 then
                    Death:TeleportCoords(vector3(326.83410644531,-571.43524169922,43.281616210938), pPed)
                else
                    Death:TeleportCoords(vector3(1827.1378173828,3680.2099609375,34.277328491211), pPed)
                end
                if GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01") then
                    for k,v in pairs(Clothsambulancepatient.clothspatient.men) do
                        TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                            TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                            
                        end)
                    end
                else
                    for k,v in pairs(Clothsambulancepatient.clothspatient.women) do
                        TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                            TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                            
                        end)
                    end
                end
                Wait(500)
                DoScreenFadeIn(1000)
                TriggerEvent('Sneakyesx_status:healPlayer')
                ClearPedBloodDamage(pPed)
                PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
                Citizen.Wait(10)
                ClearPedTasksImmediately(pPed)
                Death.HasRespawn = true 
                Death.HasRespawnTimer = GetGameTimer() or 0
                SetEntityHealth(pPed, 120)
                RequestAnimSet("move_m@drunk@verydrunk")
                while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
                    Citizen.Wait(0)
                end
                PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
                TriggerServerEvent("Sneaky:StopDeadPlayer")
                SneakyEvent("Sneakyesx_ambulancejob:payrevive",500)
                ESX.ShowNotification("~b~Médecin~s~\nVous avez été soigné par un médecin en urgence , merci de ne pas forcer sur vos blessures")
                ESX.ShowNotification("~b~Médecin~s~\nVous avez été débité de 500~g~$~s~ pour les soins")
                SetTimeout(2000,function()
                    deadtimeout = false
                end)
                timerbaractive = false
                elseif emsCan == false then
                    ESX.ShowNotification("~r~Des médecins sont présents merci de patienter.")
                end
            end
        else
            SetTimecycleModifier("damage")
            while GetGameTimer() <= Death.deathTime and Death.PlayerDead do
                if not timerbaractive then
                    timerbaractive = true
                    ESX.AddTimerBar("Temps restant :", {endTime = Death.deathTime - GetGameTimer() / 1000})
                end
                if IsControlJustPressed(1, 47) and Death.Call then 
                    ESX.ShowNotification("Vous avez appelé les ~b~secours~s~.")
                    TriggerServerEvent("sCall:SendCallMsg", "Une personne est au sol.", GetEntityCoords(PlayerPedId()), "ambulance", true)
                    Death.Call = false 
                end
                SetPedToRagdoll(PlayerPedId(),1000, 1000, 0, 0, 0, 0)
                Citizen.Wait(0)
            end
            ESX.RemoveTimerBar()
            DoScreenFadeOut(1000)
            Citizen.Wait(1000)
            ClearTimecycleModifier()
            DoScreenFadeIn(1000)
        end
    elseif Death.PlayerKO then 
        Death.PlayerDead = false 
        SetPedToRagdoll(PlayerPedId(),1000, 1000, 0, 0, 0, 0)
        if GetGameTimer() >= Death.deathTime and Death.PlayerKO then
            Death:DrawTextScreen(0.85, 0.82, 0.8, "Appuyez sur ~b~E~s~ pour vous relever.", 4, 0)
            if IsControlJustPressed(1, 38) then
                local pPed = player
                Death.PlayerKO = false 
                DoScreenFadeOut(1000)
                Wait(1000)
                DoScreenFadeIn(1000)
                ClearPedBloodDamage(pPed)
                SetEntityHealth(pPed, 120)
                PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
                Citizen.Wait(10)
                ClearPedTasks(pPed)
                if Death.tranch then 
                    Death.HasRespawn = true 
                    Death.HasRespawnTimer = GetGameTimer() or 0
                end
                RequestAnimSet("move_m@drunk@verydrunk")
                while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
                    Citizen.Wait(0)
                end
                PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
                ESX.ShowNotification("~b~KO\n~w~Vous venez de vous relever.")
                ESX.RemoveTimerBar()
                timerbaractive = false
            end
        else
            while GetGameTimer() <= Death.deathTime and Death.PlayerKO do
                if not timerbaractive then
                    timerbaractive = true
                    ESX.AddTimerBar("Temps restant :", {endTime = Death.deathTime - GetGameTimer() / 1000})
                end
                SetPedToRagdoll(PlayerPedId(),1000, 1000, 0, 0, 0, 0)
                Citizen.Wait(0)
            end
            DoScreenFadeOut(500)
            Citizen.Wait(500)
            ClearTimecycleModifier()
            DoScreenFadeIn(500)
        end
    end
end

AddEventHandler('SneakyLife:onPlayerDied', function(victimEntity, attackEntity)
    if victimEntity and not Death.PlayerDead and not Death.PlayerKO and IsEntityDead(victimEntity) then
        Death.PlayerDead = true
        Death.Call = true 
        Death.deathCause = table.pack(Death:GetAllCauseOfDeath(PlayerPedId()))
        Death.deathTime = GetGameTimer() + Death.waitTime
        Death.deathTime1 = GetGameTimer()
        deadtimeout = true
        isPlayerAbuse = false
        TriggerServerEvent("Sneaky:DeadPlayer")
        ESX.ShowNotification("Appuyez sur ~b~G~s~ pour contacter les ~b~secours~s~.")
        Death:Revive()
        SetTimecycleModifier("damage")
        SetPedToRagdoll(PlayerPedId(),1000, 1000, 0, 0, 0, 0)
        ResetPedRagdollTimer(PlayerPedId())
        Citizen.CreateThread(function()
            while Death.PlayerDead do 
                Wait(0)
                ThinkDeath(PlayerPedId())
            end
        end)
    end
end)

AddEventHandler('SneakyLife:onPlayerKilled', function(victimEntity, _z)
    if not Death.PlayerDead and not Death.PlayerKO then
        Death.PlayerKO = true
        Death.PlayerDead = false 

        if Death:TableGetValue(Death.WeaponHashcontend, _z) then 
            Death.contend = true 
        elseif Death:TableGetValue(Death.WeaponHashtranch, _z) then 
            Death.tranch = true 
        end

        Death.deathCause = table.pack(Death:GetAllCauseOfDeath(PlayerPedId()))
        Death.deathTime = GetGameTimer() + (Death.tranch and Death.waitTimeKo + 15000 or Death.waitTimeKo)
        Death.deathTime1 = GetGameTimer()

        ESX.ShowNotification("Vous êtes tombé ~b~KO~s~.")

        Death:Revive()
        SetPedToRagdollWithFall(PlayerPedId(), 1500, 2000, 0, - GetEntityForwardVector(PlayerPedId()), 1.0, 0.0, .0, .0, .0, .0, .0)
        Citizen.Wait(1000)
        SetPedToRagdollWithFall(PlayerPedId(), 0, 0, 0, -GetEntityForwardVector(PlayerPedId()), .0, 0.0, .0, .0, .0, .0, .0)

        Citizen.CreateThread(function()
            while Death.PlayerKO do 
                Wait(0)
                ThinkDeath(PlayerPedId())
            end
        end)
    end
end)

RegisterNetEvent("SneakyLife:RequestDeath")
AddEventHandler("SneakyLife:RequestDeath", function()
    SetEntityHealth(PlayerPedId(), 0)
    isPlayerAbuse = true
end)

function DrawMissionText(msg, time)
    ClearPrints()
    SetTextEntry_2('STRING')
    AddTextComponentString(msg)
    DrawSubtitleTimed(time, 1)
end

Citizen.CreateThread(function()
    while true do
        local wait = 2000
        if not deadtimeout then
            if IsEntityDead(PlayerPedId()) then
                local pCause = GetPedSourceOfDeath(PlayerPedId())
                local Cause = GetPedCauseOfDeath(PlayerPedId())
                local KO = IsPedArmed(pCause, 1) or Death:TableGetValue(Death.AllWeaponKO, Cause)
                if isPlayerAbuse then
                    TriggerEvent("SneakyLife:onPlayerDied", PlayerPedId(), Cause)
                else
                    TriggerEvent(KO and "SneakyLife:onPlayerKilled" or "SneakyLife:onPlayerDied", PlayerPedId(), Cause)
                end
            end

            if Death.PlayerDead or Death.PlayerKO then 
                wait = 5
                SetEntityHealth(PlayerPedId(), 101)
                SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 1, 1, 0)
                ResetPedRagdollTimer(PlayerPedId())
            end

            if Death.HasRespawn then 
                wait = 5
                DisableControlAction(0, 22, true)
                DisableControlAction(0, 21, true)
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 25, true)
                DisableControlAction(0, 45, true)

                SetPedMovementClipset(PlayerPedId(), "move_m@drunk@verydrunk", true)
            
                Death.RespawnTime = Death.HasRespawnTimer + Death.RespawnTimeClean
                if Death.RespawnTime <= GetGameTimer() then 
                    Death.HasRespawn = false 
                    Death.RespawnTime = 0
                    Death.HasRespawnTimer = 0
                    ResetPedMovementClipset(PlayerPedId())
                end
            end

            Citizen.Wait(wait)
        end
        Citizen.Wait(wait)
    end
end)

CreateThread(function()
    while true do
        if Death.PlayerDead then
            Wait(0)
            DrawMissionText("~g~Invincible",500)
        else
            Wait(1250)
        end
    end
end)
local loadedcoma = false
Citizen.CreateThread(function()
    while true do
        if not loadedcoma then
            Wait(5000)
            TriggerServerEvent("sComa:RequestDeadStatut")
            loadedcoma = true
        else
            Wait(20000)
        end
    end
end)

AddEventHandler("gameEventTriggered", function(eventName, eventArguments)
    if eventName == "CEventNetworkEntityDamage" then
        local victimEntity, attackEntity, _, fatalBool, weaponUsed, _a, _z, _e, _r, _t, entityType = table.unpack(eventArguments)

        if PlayerPedId() ~= victimEntity then
            return
        end

        local KO = _a ~= 0 and (IsPedArmed(attackEntity, 1) or Death:TableGetValue(Death.AllWeaponKO, _z))
        if not Death.PlayerDead and not Death.PlayerKO then 
            TriggerEvent(KO and "SneakyLife:onPlayerKilled" or _a ~= 0 and "SneakyLife:onPlayerDied" or "SneakyLife:EntityTakeDamage", victimEntity, attackEntity, _z)
        end
    end
end)

RegisterNetEvent('SneakyLife:RevivePlayer')
AddEventHandler('SneakyLife:RevivePlayer', function()
    SetEntityHealth(PlayerPedId(), 200)
    local pPos = GetEntityCoords(PlayerPedId())
    TriggerServerEvent("Sneaky:StopDeadPlayer")
    TriggerEvent('Sneakyesx_status:healPlayer')
    Death.PlayerDead = false 
    Death.PlayerKO = false 
    ClearPedBloodDamage(PlayerPedId())
    PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
    SetEntityHealth(PlayerPedId(), 120)
    Wait(250)
	TriggerEvent('playerSpawned', pPos.x, pPos.y, pPos.z)
	SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
    SetEntityInvincible(PlayerPedId(), false)
    ClearPedTasks(PlayerPedId())
    ESX.RemoveTimerBar()
    timerbaractive = false
    ShowNotification("~b~Réanimation\n~w~Vous venez d\'être réanimé.")
    SetTimeout(2000,function()
        deadtimeout = false
    end)
end)

RegisterNetEvent('SneakyLife:RevivePlayerStaff')
AddEventHandler('SneakyLife:RevivePlayerStaff', function()
    local pPos = GetEntityCoords(PlayerPedId())
    Death.PlayerDead = false 
    Death.PlayerKO = false
    SetEntityHealth(PlayerPedId(), 200)
    TriggerServerEvent("Sneaky:StopDeadPlayer")
    TriggerEvent('Sneakyesx_status:healPlayer')
    ClearPedBloodDamage(PlayerPedId())
    PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
	TriggerEvent('playerSpawned', pPos.x, pPos.y, pPos.z)
	SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
    SetEntityInvincible(PlayerPedId(), false)
    ClearPedTasks(PlayerPedId())
    ESX.RemoveTimerBar()
    timerbaractive = false
    ShowNotification("~b~Réanimation\n~w~Vous venez d\'être réanimé par un staff.")
    SetTimeout(2000,function()
        deadtimeout = false
    end)
end)

function GetStatutComa()
    return Death.PlayerDead
end