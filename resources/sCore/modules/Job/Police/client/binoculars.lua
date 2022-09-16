ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then
        ESX.PlayerData = ESX.GetPlayerData()
    end
end)

local State = false
local jumelle_x, jumelle_y, jumelle_z, control = 40.0, 2.0, 2.0, 51
local overlay_cam = (jumelle_x + jumelle_y) * 0.5
local function HideComponent()
    HideHudAndRadarThisFrame()
    HideHudComponentThisFrame(19)
    HideHudComponentThisFrame(1)
    HideHudComponentThisFrame(2)
    HideHudComponentThisFrame(3)
    HideHudComponentThisFrame(4)
    HideHudComponentThisFrame(13)
    HideHudComponentThisFrame(11)
    HideHudComponentThisFrame(12)
    HideHudComponentThisFrame(15)
    HideHudComponentThisFrame(18)
end
local function SetPositionAndHeading(RfsnisO, lvW2ga)
    local T7RKP = GetDisabledControlNormal(0, 220)
    local _L6Bs = GetDisabledControlNormal(0, 221)
    local SH = GetCamRot(RfsnisO, 2)
    if T7RKP ~= 0.0 or _L6Bs ~= 0.0 then
        local wU4wYbA9 = overlay_cam * 0.3
        local fFeQcIM = SH.z + T7RKP * -1.0 * wU4wYbA9
        local JEHSHPh3 = math.max(math.min(20.0, SH.x + _L6Bs * -1.0 * wU4wYbA9), -89.5)
        SetCamRot(RfsnisO, JEHSHPh3, 0.0, fFeQcIM, 2)
        if lvW2ga and not IsPedInAnyVehicle(PlayerPedId()) then
            SetEntityHeading(PlayerPedId(), fFeQcIM)
        end
    end
end

local Entity = false

function RequestAndWaitModel(modelName) -- Request un modèle de véhicule
	if modelName and IsModelInCdimage(modelName) and not HasModelLoaded(modelName) then
		RequestModel(modelName)
		while not HasModelLoaded(modelName) do Citizen.Wait(100) end
	end
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

local booljumelle
local newposition = 1.0
local function IsControlFunction(argument)
    if IsControlPressed(0, 241) then
        overlay_cam = math.max(overlay_cam - jumelle_z, jumelle_y)
        SetCamFov(argument, overlay_cam)
        local Matrixcam, Matrixcam2, Matrixcam, Matrixcam3 = GetCamMatrix(argument)
        newposition = jumelle_x - overlay_cam
        booljumelle = Matrixcam3 + Matrixcam2 * newposition
        SetFocusPosAndVel(booljumelle)
    end
    if IsControlPressed(0, 242) then
        overlay_cam = math.min(overlay_cam + jumelle_z, jumelle_x)
        SetCamFov(argument, overlay_cam)
        local Matrixcam4, Matrixcam5, Matrixcam4, Matrixcam6 = GetCamMatrix(argument)
        newposition = jumelle_x - overlay_cam
        booljumelle = Matrixcam6 + Matrixcam5 * newposition
        SetFocusPosAndVel(booljumelle)
    end
    local Controls187, Controls188 = IsControlPressed(0, 187), IsControlPressed(0, 188)
    if Controls187 or Controls188 then
        local Matrixcam7, Matrixcam8, Matrixcam7, Matrixcam9 = GetCamMatrix(argument)
        newposition = newposition + (Controls187 and -2.0 or 2.0)
        booljumelle = Matrixcam9 + Matrixcam8 * newposition
        SetFocusPosAndVel(booljumelle)
    end
end
function ToggleHeliCam(bool)
    bool = bool or not State
    State = bool
end
local Jumellestate = false
local Jumelletable = {enabled = false, prop = 0}
local scaleformjumelle
function ToggleJumelle()
    local pPed = PlayerPedId()
    if not Jumelletable.enabled then
        if IsPedArmed(pPed, 7) then
            ShowAboveRadarMessage("~r~Vous devez avoir les mains vides pour utiliser vos jumelles.")
            return
        end
        if Jumelletable.prop and DoesEntityExist(Jumelletable.prop) then
            DeleteEntity(Jumelletable.prop)
        end
        Jumelletable.prop = AttachObjectPedHand("prop_binoc_01")
        RequestAnimDict("amb@world_human_binoculars@male@base")
        while not HasAnimDictLoaded("amb@world_human_binoculars@male@base") do
            Citizen.Wait(10)
        end
        TaskPlayAnim(PlayerPedId(), "amb@world_human_binoculars@male@base", "base", 8.0, -8.0, -1, 1, 0.0, false, false, false)
        Citizen.Wait(1000)
        if not Jumelletable.cam or not DoesCamExist(Jumelletable.cam) then
            Jumelletable.cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
            AttachCamToEntity(Jumelletable.cam, pPed, 0.0, 0.0, 1.0, true)
            SetCamRot(Jumelletable.cam, 0.0, 0.0, GetEntityHeading(pPed))
            RenderScriptCams(true, false, 0, 1, 0)
            if not Jumelletable.scaleform and not HasScaleformMovieLoaded(Jumelletable.scaleform) then
                Jumelletable.scaleform = createScaleform and createScaleform("binoculars")
                Jumellestate = true
            end
        end
        scaleformjumelle =
            createScaleform(
                "INSTRUCTIONAL_BUTTONS", {{
                    name = "CLEAR_ALL",
                    param = {}
                }, {
                    name = "TOGGLE_MOUSE_BUTTONS",
                    param = {0}
                }, {
                    name = "CREATE_CONTAINER",
                    param = {}
                }, {
                    name = "SET_DATA_SLOT",
                    param = {0, GetControlInstructionalButton(2, 187, 0), "Focus (-)"}
                }, {
                    name = "SET_DATA_SLOT",
                    param = {1, GetControlInstructionalButton(2, 188, 0), "Focus (+)"}
                }, {
                    name = "SET_DATA_SLOT",
                    param = {2, GetControlInstructionalButton(2, 51, 0), "Quitter"}
                }, {
                    name = "DRAW_INSTRUCTIONAL_BUTTONS",
                    param = {-1}
                }})
    else
        ClearFocus()
        RequestAnimDict("amb@world_human_binoculars@male@exit")
        while not HasAnimDictLoaded("amb@world_human_binoculars@male@exit") do
            Citizen.Wait(10)
        end
        TaskPlayAnim(PlayerPedId(), "amb@world_human_binoculars@male@exit", "exit", 8.0, -8.0, -1, 1, 0.0, false, false, false)
        if Jumelletable.cam and DoesCamExist(Jumelletable.cam) then
            SetCamActive(Jumelletable.cam, false)
            RenderScriptCams(false, false, 0, true, true)
            DestroyCam(Jumelletable.cam, true)
            Jumelletable.cam = nil
        end
        Jumellestate = false
        SetScaleformMovieAsNoLongerNeeded(Jumelletable.scaleform)
        SetScaleformMovieAsNoLongerNeeded(scaleformjumelle)
        Citizen.Wait(3000)
        Jumelletable.scaleform = nil
        if Jumelletable.prop and DoesEntityExist(Jumelletable.prop) then
            DeleteEntity(Jumelletable.prop)
        end
        ClearAreaOfObjects(GetEntityCoords(pPed), 2.0)
        ClearPedTasks(PlayerPedId())
        ClearPedTasksImmediately(PlayerPedId())
    end
    Jumelletable.enabled = not Jumelletable.enabled
end
local Statejumelle2 = false
local function u(AjfoUo)
    local Er9zidsB = GetCamCoord(AjfoUo)
    local X, dR = GetCamMatrix(AjfoUo)
    local JFXtQwy = StartShapeTestRay(Er9zidsB, Er9zidsB + (dR * 200.0), 10, GetVehiclePedIsIn(PlayerPedId()), 0)
    local X, X, X, X, uMV17h0 = GetShapeTestResult(JFXtQwy)
    if uMV17h0 > 0 and IsEntityAVehicle(uMV17h0) then
        return uMV17h0
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Jumellestate and HasScaleformMovieLoaded(Jumelletable.scaleform) then
            if IsPedArmed(PlayerPedId(), 7) then
                ToggleJumelle()
            end
            DrawScaleformMovieFullscreen(Jumelletable.scaleform, 255, 255, 255, 255, 0)
            if HasScaleformMovieLoaded(scaleformjumelle) then
                DrawScaleformMovieFullscreen(scaleformjumelle, 255, 255, 255, 255)
            end
            DisableControlAction(0, 16, true)
            DisableControlAction(0, 17, true)
            if Jumelletable.cam and DoesCamExist(Jumelletable.cam) then
                SetPositionAndHeading(Jumelletable.cam, true)
                IsControlFunction(Jumelletable.cam)
                RenderScriptCams(true, false, 0, 1, 0)
            end
            if IsControlPressed(0, 51) then
                ToggleJumelle()
            end
        end
        if State then
            local ScaleFormHelico, WNWWe = RequestScaleformMovie("HELI_CAM"), PlayerPedId()
            while not HasScaleformMovieLoaded(ScaleFormHelico) do
                Citizen.Wait(100)
            end
            local pPed, pVeh = PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false)
            local HelicoCamState = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", 2)
            AttachCamToVehicleBone(
                HelicoCamState,
                pVeh,
                GetEntityBoneIndexByName(pVeh, "weapon_1a"),
                false,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                true
            )
            SetCamRot(HelicoCamState, 0.0, 0.0, GetEntityHeading(pVeh))
            SetCamFov(HelicoCamState, overlay_cam)
            RenderScriptCams(true, false, 0, 1, 0)
            BeginScaleformMovieMethod(ScaleFormHelico, "SET_CAM_LOGO")
            ScaleformMovieMethodAddParamInt(1)
            EndScaleformMovieMethod()
            scaleformjumelle =
                createScaleform(
                    "INSTRUCTIONAL_BUTTONS", {{
                        name = "CLEAR_ALL",
                        param = {}
                    }, {
                        name = "TOGGLE_MOUSE_BUTTONS",
                        param = {0}
                    }, {
                        name = "CREATE_CONTAINER",
                        param = {}
                    }, {
                        name = "SET_DATA_SLOT",
                        param = {0, GetControlInstructionalButton(2, 187, 0), "Focus (-)"}
                    }, {
                        name = "SET_DATA_SLOT",
                        param = {1, GetControlInstructionalButton(2, 188, 0), "Focus (+)"}
                    }, {
                        name = "SET_DATA_SLOT",
                        param = {2, GetControlInstructionalButton(2, 51, 0), "Quitter"}
                    }, {
                        name = "DRAW_INSTRUCTIONAL_BUTTONS",
                        param = {-1}
                    }})
            while State and not IsPedRagdoll(PlayerPedId()) and IsPedInVehicle(PlayerPedId(), pVeh) do
                if IsControlJustPressed(0, control) then
                    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                    break
                end
                SetPositionAndHeading(HelicoCamState)
                if Statejumelle2 then
                    if DoesEntityExist(Statejumelle2) then
                        PointCamAtEntity(HelicoCamState, Statejumelle2, 0.0, 0.0, 0.0, true)
                        if IsControlJustPressed(0, 22) or IsControlJustPressed(0, 24) then
                            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                            Statejumelle2 = nil
                            local CamRot1 = GetCamRot(HelicoCamState, 2)
                            local CamRot2 = GetCamFov(HelicoCamState)
                            DestroyCam(HelicoCamState, false)
                            HelicoCamState = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
                            AttachCamToEntity(HelicoCamState, pVeh, 0.0, 0.0, -1.5, true)
                            SetCamRot(HelicoCamState, CamRot1, 2)
                            SetCamFov(HelicoCamState, CamRot2)
                            RenderScriptCams(true, false, 0, 1, 0)
                        end
                    else
                        Statejumelle2 = nil
                    end
                else
                    local CalculateFlags = (1.0 / (jumelle_x - jumelle_y)) * (overlay_cam - jumelle_y)
                    SetPositionAndHeading(HelicoCamState, CalculateFlags)
                    local EntityCam = u(HelicoCamState)
                    if DoesEntityExist(EntityCam) and IsControlJustPressed(0, 22) or IsControlJustPressed(0, 24) then
                        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                        Statejumelle2 = EntityCam
                    end
                end
                IsControlFunction(HelicoCamState)
                local HelicoFlags = (1.0 / (jumelle_x - jumelle_y)) * (overlay_cam - jumelle_y)
                HideComponent()
                BeginScaleformMovieMethod(ScaleFormHelico, "SET_ALT_FOV_HEADING")
                ScaleformMovieMethodAddParamFloat(GetEntityCoords(pVeh).z)
                ScaleformMovieMethodAddParamFloat(HelicoFlags)
                ScaleformMovieMethodAddParamFloat(GetCamRot(HelicoCamState, 2).z)
                EndScaleformMovieMethod()
                DrawScaleformMovieFullscreen(ScaleFormHelico, 255, 255, 255, 255)
                if HasScaleformMovieLoaded(scaleformjumelle) then
                    DrawScaleformMovieFullscreen(scaleformjumelle, 255, 255, 255, 255)
                end
                Citizen.Wait(0)
            end
            State = false
            overlay_cam = (jumelle_x + jumelle_y) * 0.5
            RenderScriptCams(false, false, 0, 1, 0)
            SetScaleformMovieAsNoLongerNeeded(ScaleFormHelico)
            SetScaleformMovieAsNoLongerNeeded(scaleformjumelle)
            DestroyCam(HelicoCamState, false)
            ClearFocus()
        end
    end
end)

function SetScaleformParams(scaleform, data)
	data = data or {}
	for k,v in pairs(data) do
		PushScaleformMovieFunction(scaleform, v.name)
		if v.param then
			for _,par in pairs(v.param) do
				if math.type(par) == "integer" then
					PushScaleformMovieFunctionParameterInt(par)
				elseif type(par) == "boolean" then
					PushScaleformMovieFunctionParameterBool(par)
				elseif math.type(par) == "float" then
					PushScaleformMovieFunctionParameterFloat(par)
				elseif type(par) == "string" then
					PushScaleformMovieFunctionParameterString(par)
				end
			end
		end
		if v.func then v.func() end
		PopScaleformMovieFunctionVoid()
	end
end

function createScaleform(name, data)
	if not name or string.len(name) <= 0 then return end
	local scaleform = RequestScaleformMovie(name)

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end

	SetScaleformParams(scaleform, data)
	return scaleform
end


RegisterNetEvent("binoculars:Activate")
AddEventHandler("binoculars:Activate",function()
    ToggleJumelle()
end)

local HeliDispo = {
    GetHashKey("lspdmav"),
    GetHashKey("lssdmav")
}

function tableHasValue(tbl, value, k)
	if not tbl or not value or type(tbl) ~= "table" then return end
	for _,v in pairs(tbl) do
		if k and v[k] == value or v == value then return true, _ end
	end
end

RegisterCommand("helicocam",function()
    local heli = GetVehiclePedIsIn(PlayerPedId())
    if IsPedSittingInAnyVehicle(PlayerPedId()) then
        if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
        else
            if tableHasValue(HeliDispo,GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false))) and ESX.PlayerData.job.name == "police" or ESX.PlayerData.job.name == "lssd" then 
                ToggleHeliCam()
            end
        end
    end
end)
RegisterKeyMapping('helicocam', 'Ouvrir la caméra hélico', 'keyboard', 'I')


