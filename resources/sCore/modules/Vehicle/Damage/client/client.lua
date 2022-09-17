ESX = nil
SneakyEvent = TriggerServerEvent
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
end)

local healthEngineLast = 1000.0
local healthBodyLast = 1000.0
local healthPetrolTankLast = 1000.0

local cfg = {
	deformationMultiplier = 3.0,					-- How much should the vehicle visually deform from a collision. Range 0.0 to 10.0 Where 0.0 is no deformation and 10.0 is 10x deformation. -1 = Don't touch. Visual damage does not sync well to other players.
	deformationExponent = 0.4,					-- How much should the handling file deformation setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
	collisionDamageExponent = 0.6,					-- How much should the handling file deformation setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.

	damageFactorEngine = 10.0,					-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
	damageFactorBody = 10.0,					-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
	damageFactorPetrolTank = 64.0,					-- Sane values are 1 to 200. Higher values means more damage to vehicle. A good starting point is 64
	engineDamageExponent = 0.6,					-- How much should the handling file engine damage setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
	weaponsDamageMultiplier = 1.5,					-- How much damage should the vehicle get from weapons fire. Range 0.0 to 10.0, where 0.0 is no damage and 10.0 is 10x damage. -1 = don't touch
	degradingHealthSpeedFactor = 10,			-- Speed of slowly degrading health, but not failure. Value of 10 means that it will take about 0.25 second per health point, so degradation from 800 to 305 will take about 2 minutes of clean driving. Higher values means faster degradation
	cascadingFailureSpeedFactor = 8.0,			-- Sane values are 1 to 100. When vehicle health drops below a certain point, cascading failure sets in, and the health drops rapidly until the vehicle dies. Higher values means faster failure. A good starting point is 8

	degradingFailureThreshold = 200.0,			-- Below this value, slow health degradation will set in
	cascadingFailureThreshold = 100.0,			-- Below this value, health cascading failure will set in
	engineSafeGuard = 0.0,					-- Final failure value. Set it too high, and the vehicle won't smoke when disabled. Set too low, and the car will catch fire from a single bullet to the engine. At health 100 a typical car can take 3-4 bullets to the engine before catching fire.

	torqueMultiplierEnabled = true,					-- Decrease engine torque as engine gets more and more damaged

	-- The response curve to apply to the Brake. Range 0.0 to 10.0. Higher values enables easier braking, meaning more pressure on the throttle is required to brake hard. Does nothing for keyboard drivers

	classDamageMultiplier = {
		[0] = 	1.0,		--	0: Compacts
			1.0,		--	1: Sedans
			1.0,		--	2: SUVs
			1.0,		--	3: Coupes
			1.0,		--	4: Muscle
			1.0,		--	5: Sports Classics
			1.0,		--	6: Sports
			1.0,		--	7: Super
			0.25,		--	8: Motorcycles
			0.7,		--	9: Off-road
			0.25,		--	10: Industrial
			1.0,		--	11: Utility
			1.0,		--	12: Vans
			1.0,		--	13: Cycles
			0.5,		--	14: Boats
			1.0,		--	15: Helicopters
			1.0,		--	16: Planes
			1.0,		--	17: Service
			0.75,		--	18: Emergency
			0.75,		--	19: Military
			1.0,		--	20: Commercial
			1.0,		--	21: Trains
			1.0, 		--  22: OpenWheel
	}
}

local pedInSameVehicleLast = false
local vehicle
local lastVehicle
local vehicleClass
local fCollisionDamageMult = 0.0
local fDeformationDamageMult = 0.0
local fEngineDamageMult = 0.0
local fBrakeForce = 1.0

local healthEngineCurrent = 1000.0
local healthEngineNew = 1000.0
local healthEngineDelta = 0.0
local healthEngineDeltaScaled = 0.0

local healthBodyCurrent = 1000.0
local healthBodyNew = 1000.0
local healthBodyDelta = 0.0
local healthBodyDeltaScaled = 0.0

local healthPetrolTankCurrent = 1000.0
local healthPetrolTankNew = 1000.0
local healthPetrolTankDelta = 0.0
local healthPetrolTankDeltaScaled = 0.0

local DoesEntityExist = DoesEntityExist
local IsPedInAnyVehicle = IsPedInAnyVehicle
local GetEntityRoll = GetEntityRoll
local PlayerPedId = PlayerPedId
local IsThisModelACar = IsThisModelACar
local GetEntityModel = GetEntityModel
local GetEntitySpeed = GetEntitySpeed
local DisableControlAction = DisableControlAction
local GetPedInVehicleSeat = GetPedInVehicleSeat
local GetVehicleClass = GetVehicleClass

local function IsPedDrivingAVehicle(ped, vehicle)
	if GetPedInVehicleSeat(vehicle, -1) == ped then
		local class = GetVehicleClass(vehicle)
		if class ~= 15 and class ~= 16 and class ~= 21 and class ~= 13 then
			return true
		end
	end

	return false
end

Citizen.CreateThread(function()
	local player = PlayerPedId()
	while true do
		local wait = 500

		local ped, veh = player, GetVehiclePedIsUsing(PlayerPedId())

		if IsPedSittingInAnyVehicle(PlayerPedId()) and veh and IsPedDrivingAVehicle(ped, veh) and IsThisModelACar(GetEntityModel(veh)) and not IsControlPressed(1, 337) then
			wait = 5
			vehicle = veh
			vehicleClass = GetVehicleClass(vehicle)

			healthEngineCurrent = GetVehicleEngineHealth(vehicle)
			if healthEngineCurrent == 1000 then healthEngineLast = 1000.0 end
			healthEngineNew = healthEngineCurrent
			healthEngineDelta = healthEngineLast - healthEngineCurrent
			healthEngineDeltaScaled = healthEngineDelta * cfg.damageFactorEngine * cfg.classDamageMultiplier[vehicleClass]

			healthBodyCurrent = GetVehicleBodyHealth(vehicle)
			if healthBodyCurrent == 1000 then healthBodyLast = 1000.0 end
			healthBodyNew = healthBodyCurrent
			healthBodyDelta = healthBodyLast - healthBodyCurrent
			healthBodyDeltaScaled = healthBodyDelta * cfg.damageFactorBody * cfg.classDamageMultiplier[vehicleClass]

			healthPetrolTankCurrent = GetVehiclePetrolTankHealth(vehicle)
			if cfg.compatibilityMode and healthPetrolTankCurrent < 1 then
				healthPetrolTankLast = healthPetrolTankCurrent
			end
			if healthPetrolTankCurrent == 1000 then healthPetrolTankLast = 1000.0 end
			healthPetrolTankNew = healthPetrolTankCurrent
			healthPetrolTankDelta = healthPetrolTankLast-healthPetrolTankCurrent
			healthPetrolTankDeltaScaled = healthPetrolTankDelta * cfg.damageFactorPetrolTank * cfg.classDamageMultiplier[vehicleClass]
			if healthEngineCurrent > cfg.engineSafeGuard + 1 then
				SetVehicleUndriveable(vehicle,false)
			end
			if healthEngineCurrent <= cfg.engineSafeGuard + 1 then
				SetVehicleUndriveable(vehicle,true)
			end
			-- If ped spawned a new vehicle while in a vehicle or teleported from one vehicle to another, handle as if we just entered the car
			if vehicle ~= lastVehicle then
				pedInSameVehicleLast = false
			end
			if pedInSameVehicleLast == true then
				-- Damage happened while in the car = can be multiplied
				-- Only do calculations if any damage is present on the car. Prevents weird behavior when fixing using trainer or other script
				if healthEngineCurrent ~= 1000.0 or healthBodyCurrent ~= 1000.0 or healthPetrolTankCurrent ~= 1000.0 then
					-- Combine the delta values (Get the largest of the three)
					local healthEngineCombinedDelta = math.max(healthEngineDeltaScaled, healthBodyDeltaScaled, healthPetrolTankDeltaScaled)
					-- If huge damage, scale back a bit
					if healthEngineCombinedDelta > (healthEngineCurrent - cfg.engineSafeGuard) then
						healthEngineCombinedDelta = healthEngineCombinedDelta * 0.7
					end
					-- If complete damage, but not catastrophic (ie. explosion territory) pull back a bit, to give a couple of seconds og engine runtime before dying
					if healthEngineCombinedDelta > healthEngineCurrent then
						healthEngineCombinedDelta = healthEngineCurrent - (cfg.cascadingFailureThreshold / 5)
					end
					------- Calculate new value
					healthEngineNew = healthEngineLast - healthEngineCombinedDelta
					------- Sanity Check on new values and further manipulations
					-- If somewhat damaged, slowly degrade until slightly before cascading failure sets in, then stop
					if healthEngineNew > (cfg.cascadingFailureThreshold + 5) and healthEngineNew < cfg.degradingFailureThreshold then
						healthEngineNew = healthEngineNew-(0.038 * cfg.degradingHealthSpeedFactor)
					end
					-- If Damage is near catastrophic, cascade the failure
					if healthEngineNew < cfg.cascadingFailureThreshold then
						healthEngineNew = healthEngineNew-(0.1 * cfg.cascadingFailureSpeedFactor)
					end
					-- Prevent Engine going to or below zero. Ensures you can reenter a damaged car.
					if healthEngineNew < cfg.engineSafeGuard then
						healthEngineNew = cfg.engineSafeGuard
					end
					-- Prevent Explosions
					if cfg.compatibilityMode == false and healthPetrolTankCurrent < 750 then
						healthPetrolTankNew = 750.0
					end
					-- Prevent negative body damage.
					if healthBodyNew < 0  then
						healthBodyNew = 0.0
					end
				end
			else
				-- Just got in the vehicle. Damage can not be multiplied this round
				-- Set vehicle handling data
				fDeformationDamageMult = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fDeformationDamageMult')
				fBrakeForce = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fBrakeForce')
				local newFDeformationDamageMult = fDeformationDamageMult ^ cfg.deformationExponent	-- Pull the handling file value closer to 1
				if cfg.deformationMultiplier ~= -1 then SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fDeformationDamageMult', newFDeformationDamageMult * cfg.deformationMultiplier) end  -- Multiply by our factor
				if cfg.weaponsDamageMultiplier ~= -1 then SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fWeaponDamageMult', cfg.weaponsDamageMultiplier / cfg.damageFactorBody) end -- Set weaponsDamageMultiplier and compensate for damageFactorBody

				--Get the CollisionDamageMultiplier
				fCollisionDamageMult = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fCollisionDamageMult')
				--Modify it by pulling all number a towards 1.0
				local newFCollisionDamageMultiplier = fCollisionDamageMult ^ cfg.collisionDamageExponent	-- Pull the handling file value closer to 1
				SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fCollisionDamageMult', newFCollisionDamageMultiplier)

				--Get the EngineDamageMultiplier
				fEngineDamageMult = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fEngineDamageMult')
				--Modify it by pulling all number a towards 1.0
				local newFEngineDamageMult = fEngineDamageMult ^ cfg.engineDamageExponent	-- Pull the handling file value closer to 1
				SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fEngineDamageMult', newFEngineDamageMult)

				-- If body damage catastrophic, reset somewhat so we can get new damage to multiply
				if healthBodyCurrent < cfg.cascadingFailureThreshold then
					healthBodyNew = cfg.cascadingFailureThreshold
				end
				pedInSameVehicleLast = true
			end

			-- set the actual new values
			if healthEngineNew ~= healthEngineCurrent then
				SetVehicleEngineHealth(vehicle, healthEngineNew)
			end

			if healthBodyNew ~= healthBodyCurrent then SetVehicleBodyHealth(vehicle, healthBodyNew) end
			if healthPetrolTankNew ~= healthPetrolTankCurrent then SetVehiclePetrolTankHealth(vehicle, healthPetrolTankNew) end

			-- Store current values, so we can calculate delta next time around
			healthEngineLast = healthEngineNew
			healthBodyLast = healthBodyNew
			healthPetrolTankLast = healthPetrolTankNew
			lastVehicle = vehicle
		else
			if pedInSameVehicleLast == true then
				-- We just got out of the vehicle
				lastVehicle = GetVehiclePedIsIn(ped, true)
				if IsThisModelACar(GetEntityModel(lastVehicle)) then
					if cfg.deformationMultiplier ~= -1 then SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fDeformationDamageMult', fDeformationDamageMult) end -- Restore deformation multiplier
					SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fBrakeForce', fBrakeForce)  -- Restore Brake Force multiplier
					if cfg.weaponsDamageMultiplier ~= -1 then SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fWeaponDamageMult', cfg.weaponsDamageMultiplier) end	-- Since we are out of the vehicle, we should no longer compensate for bodyDamageFactor
					SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fCollisionDamageMult', fCollisionDamageMult) -- Restore the original CollisionDamageMultiplier
					SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fEngineDamageMult', fEngineDamageMult) -- Restore the original EngineDamageMultiplier
				end
			end
			pedInSameVehicleLast = false
		end
		Wait(wait)
	end
end)

Citizen.CreateThread(function()
	while true do
		local attente = 1000
		local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		local speed = GetEntitySpeed(vehicle)
		local kmh = 3.6
		local mph = 2.23694
		local vehicleClass = GetVehicleClass(vehicle)
		local vehicleModel = GetEntityModel(vehicle)
		playerPed = GetPlayerPed(-1)
			if IsPedInAnyVehicle(GetPlayerPed(-1), false) and math.floor(speed*kmh) > 18 then
				attente = 10
				DisableControlAction(0, 75, true)
				DisableControlAction(0, 24, true)
				DisableControlAction(0, 159, true) -- INPUT_VEH_PREV_RADIO_TRACK  
				DisableControlAction(0, 161, true) -- INPUT_VEH_NEXT_RADIO_TRACK 
				DisableControlAction(0, 162, true) -- INPUT_VEH_NEXT_RADIO
				DisableControlAction(0, 165, true) -- INPUT_VEH_PREV_RADIO
				DisableControlAction(0, 164, true) -- INPUT_VEH_PREV_RADIO
			elseif not IsPedInAnyVehicle(playerPed, false) then 
				attente = 2500
			end
		Wait(attente)
	end
end)

-- Draw Text 
function DrawTextScreen(Text,Text3,Taille,Text2,Font,Justi,havetext) -- Créer un text 2D a l'écran
    SetTextFont(Font)
    SetTextScale(Taille,Taille)
    SetTextColour(255,255,255,255)
    SetTextJustification(Justi or 1)
    SetTextEntry("STRING")
    if havetext then 
        SetTextWrap(Text,Text+.1)
    end;
    AddTextComponentString(Text2)
    DrawText(Text,Text3)
end

function DrawText3D(x, y, z, string, sizes, v3) -- Draw Text 3D
    local size = sizes or 7
    local camx, camy, camz = table.unpack(GetGameplayCamCoords())
    sizes = GetDistanceBetweenCoords(camx, camy, camz, x, y, z, 1)
    local distance = GetDistanceBetweenCoords(GetPlayer().Pos, x, y, z, 1) - 1.65
    local scale, dst = ((1 / sizes) * (size * .7)) * (1 / GetGameplayCamFov()) * 100, 255;
    if distance < size then
        dst = math.floor(255 * ((size - distance) / size))
    elseif distance >= size then
        dst = 0
    end
    dst = v3 or dst
    SetTextFont(0)
    SetTextScale(.0 * scale, .1 * scale)
    SetTextColour(255, 255, 255, math.max(0, math.min(255, dst)))
    SetTextCentre(1)
    SetDrawOrigin(x, y, z, 0)
    SetTextEntry("STRING")
    AddTextComponentString(string)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end
function DrawText2(intFont, stirngText, floatScale, intPosX, intPosY, color, boolShadow, intAlign, addWarp) -- Draw text 2D
	SetTextFont(intFont)
	SetTextScale(floatScale, floatScale)
	if boolShadow then
		SetTextDropShadow(0, 0, 0, 0, 0)
		SetTextEdge(0, 0, 0, 0, 0)
	end
	SetTextColour(color[1], color[2], color[3], 255)
	if intAlign == 0 then
		SetTextCentre(true)
	else
		SetTextJustification(intAlign or 1)
		if intAlign == 2 then
			SetTextWrap(.0, addWarp or intPosX)
		end
	end
	SetTextEntry("STRING")
	AddTextComponentString(stirngText)
	DrawText(intPosX, intPosY)
end

local ScreenCoords = { baseX = 0.918, baseY = 0.984, titleOffsetX = 0.012, titleOffsetY = -0.012, valueOffsetX = 0.0785, valueOffsetY = -0.0165, pbarOffsetX = 0.047, pbarOffsetY = 0.0015 }
local Sizes = {	timerBarWidth = 0.165, timerBarHeight = 0.035, timerBarMargin = 0.038, pbarWidth = 0.0616, pbarHeight = 0.0105 }
local activeBars = {}

function AddTimerBar(title, itemData) -- Add un timber bar
    if not itemData then return end
    RequestStreamedTextureDict("timerbars", true)

    local barIndex = #activeBars + 1
    activeBars[barIndex] = {
        title = title,
        text = itemData.text,
        textColor = itemData.color or { 255, 255, 255, 255 },
        percentage = itemData.percentage,
        endTime = itemData.endTime,
        pbarBgColor = itemData.bg or { 155, 155, 155, 255 },
        pbarFgColor = itemData.fg or { 255, 255, 255, 255 }
    }

    return barIndex
end

function RemoveTimerBar() -- Remove une timer bar
    activeBars = {}
    SetStreamedTextureDictAsNoLongerNeeded("timerbars")
end

function UpdateTimerBar(barIndex, itemData) -- Update une timer bar
    if not activeBars[barIndex] or not itemData then return end
    for k,v in pairs(itemData) do
        activeBars[barIndex][k] = v
    end
end

local HideHudComponentThisFrame = HideHudComponentThisFrame
local GetSafeZoneSize = GetSafeZoneSize
local DrawSprite = DrawSprite
local DrawText2 = DrawText2
local DrawRect = DrawRect
local SecondsToClock = SecondsToClock
local GetGameTimer = GetGameTimer
local textColor = { 200, 100, 100 }
local math = math

function SecondsToClock(seconds) -- Get les secondes
    seconds = tonumber(seconds)

    if seconds <= 0 then
        return "00:00"
    else
        mins = string.format("%02.f", math.floor(seconds / 60))
        secs = string.format("%02.f", math.floor(seconds - mins * 60))
        return string.format("%s:%s", mins, secs)
    end
end

Citizen.CreateThread(function()
    while true do
        local attente = 500

        local safeZone = GetSafeZoneSize()
        local safeZoneX = (1.0 - safeZone) * 0.5
        local safeZoneY = (1.0 - safeZone) * 0.5

        if #activeBars > 0 then
            attente = 1
            HideHudComponentThisFrame(6)
            HideHudComponentThisFrame(7)
            HideHudComponentThisFrame(8)
            HideHudComponentThisFrame(9)

            for i,v in pairs(activeBars) do
                local drawY = (ScreenCoords.baseY - safeZoneY) - (i * Sizes.timerBarMargin);
                DrawSprite("timerbars", "all_black_bg", ScreenCoords.baseX - safeZoneX, drawY, Sizes.timerBarWidth, Sizes.timerBarHeight, 0.0, 255, 255, 255, 160)
                DrawText2(0, v.title, 0.3, (ScreenCoords.baseX - safeZoneX) + ScreenCoords.titleOffsetX, drawY + ScreenCoords.titleOffsetY, v.textColor, false, 2)

                if v.percentage then
                    local pbarX = (ScreenCoords.baseX - safeZoneX) + ScreenCoords.pbarOffsetX;
                    local pbarY = drawY + ScreenCoords.pbarOffsetY;
                    local width = Sizes.pbarWidth * v.percentage;

                    DrawRect(pbarX, pbarY, Sizes.pbarWidth, Sizes.pbarHeight, v.pbarBgColor[1], v.pbarBgColor[2], v.pbarBgColor[3], v.pbarBgColor[4])

                    DrawRect((pbarX - Sizes.pbarWidth / 2) + width / 2, pbarY, width, Sizes.pbarHeight, v.pbarFgColor[1], v.pbarFgColor[2], v.pbarFgColor[3], v.pbarFgColor[4])
                elseif v.text then
                    DrawText2(0, v.text, 0.425, (ScreenCoords.baseX - safeZoneX) + ScreenCoords.valueOffsetX, drawY + ScreenCoords.valueOffsetY, v.textColor, false, 2)
                elseif v.endTime then
                    local remainingTime = math.floor(v.endTime - GetGameTimer())
                    DrawText2(0, SecondsToClock(remainingTime / 1000), 0.425, (ScreenCoords.baseX - safeZoneX) + ScreenCoords.valueOffsetX, drawY + ScreenCoords.valueOffsetY, remainingTime <= 0 and textColor or v.textColor, false, 2)
                end
            end
        end
        Wait(attente)
    end
end)

function DrawText3D(B6zKxgVs, O3_X, DVs8kf2w, vms5, M7, v3)
    local ihKb = M7 or 7
    local JGSK, rA5U, Uc06 = table.unpack(GetGameplayCamCoords())
    M7 = GetDistanceBetweenCoords(JGSK, rA5U, Uc06, B6zKxgVs, O3_X, DVs8kf2w, 1)
    local lcBL = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), B6zKxgVs, O3_X, DVs8kf2w, 1) - 1.65
    local DHPxI, dx = ((1 / M7) * (ihKb * .7)) * (1 / GetGameplayCamFov()) * 100, 255;
    if lcBL < ihKb then
        dx = math.floor(255 * ((ihKb - lcBL) / ihKb))
    elseif lcBL >= ihKb then
        dx = 0
    end
    dx = v3 or dx
    SetTextFont(0)
    SetTextScale(.0 * DHPxI, .1 * DHPxI)
    SetTextColour(255, 255, 255, math.max(0, math.min(255, dx)))
    SetTextCentre(1)
    SetDrawOrigin(B6zKxgVs, O3_X, DVs8kf2w, 0)
    SetTextEntry("STRING")
    AddTextComponentString(vms5)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function GetClosestVehicle2(vector, radius, modelHash, testFunction) -- Get un véhicule par radius
	if not vector or not radius then return end
	local handle, veh = FindFirstVehicle()
	local success, theVeh
	repeat
		local firstDist = GetDistanceBetweenCoords(GetEntityCoords(veh), vector.x, vector.y, vector.z, true)
		if firstDist < radius and (not modelHash or modelHash == GetEntityModel(veh)) and (not theVeh or firstDist < GetDistanceBetweenCoords(GetEntityCoords(theVeh), GetEntityCoords(veh), true)) and (not testFunction or testFunction(veh)) then
			theVeh = veh
		end
		success, veh = FindNextVehicle(handle)
	until not success
		EndFindVehicle(handle)
	return theVeh
end

local HaveProgress
function ProgressBarExists() -- Si une barre de progression existe
    return HaveProgress 
end

local petitpoint = {".","..","...",""}
function ProgressBar(Text, r, g, b, a, Timing, NoTiming) -- Créer une progress bar
    if not Timing then 
        return 
    end
    RemoveProgressBar()
    HaveProgress = true
    Citizen.CreateThread(function()
        local Timing1, Timing2 = .0, GetGameTimer() + Timing
        local E, Timing3 = ""
        while HaveProgress and (not NoTiming and Timing1 < 1) do
            Citizen.Wait(0)
            if not NoTiming or Timing1 < 1 then 
                Timing1 = 1-((Timing2 - GetGameTimer())/Timing)
            end
            if not Timing3 or GetGameTimer() >= Timing3 then
                Timing3 = GetGameTimer()+500;
                E = petitpoint[string.len(E)+1] or ""
            end;
            DrawRect(.5,.875,.15,.03,0,0,0,100)
            local y, endroit=.15-.0025,.03-.005;
            local chance = math.max(0,math.min(y,y*Timing1))
            DrawRect((.5-y/2)+chance/2,.875,chance,endroit,r,g,b,a) -- 0,155,255,125
            DrawTextScreen(.5,.875-.0125,.3,(Text or"Action en cours")..E,0,0,false)
        end;
        RemoveProgressBar()
    end)
end

function RemoveProgressBar()
    HaveProgress = nil 
end


local CommandTimeout = false
local timerToPos = 0
RegisterCommand("debug", function()
	if CommandTimeout == false then
		if timerToPos + 5000 > GetGameTimer() then return end
		if IsPedDeadOrDying(PlayerPedId(),1) then 
			return 
		end
		CommandTimeout = true
		local pPed = PlayerPedId()
		local pPos = GetEntityCoords(pPed)

		SneakyEvent('instanceunicorn:reset',0)
		ClearFocus()
		SetFocusEntity(pPed)   
		SetNuiFocus(false, false)
		local Matrix2,Matrix1,Matrix2,Matrix3=GetEntityMatrix(pPed)
		ClearFocus()
		SetFocusEntity(GetPlayerPed(PlayerId()))   
		DoScreenFadeOut(20)
		SetEntityCoords(pPed,7000.0,5000.0,300.0)
		Wait(20)
		SetEntityCoords(pPed,Matrix3+Matrix1*0.5)
		DoScreenFadeIn(20)
		DetachEntity(pPed, true, false)
		PrepareMusicEvent("FM_SUDDEN_DEATH_STOP_MUSIC")
		TriggerMusicEvent("FM_SUDDEN_DEATH_STOP_MUSIC")
		SetNuiFocus(false, false)
		SetKeepInputMode(false)
		TriggerScreenblurFadeOut(0)
		ClearPedTasksImmediately(pPed)
		RemoveProgressBar()
		SetPedMoveRateOverride(GetPlayerPed(-1), 1.0)
		ResetEntityAlpha(pPed)
		SetEntityCollision(pPed, 1, 1)
		SetEntityVisible(pPed, true, false)
		RemoveLoadingPrompt()
		ClearAllBrokenGlass()
		ClearAllHelpMessages()
		LeaderboardsReadClearAll()
		ClearBrief()
		ClearGpsFlags()
		ClearPrints()
		ClearSmallPrints()
		ClearReplayStats()
		LeaderboardsClearCacheData()
		ClearFocus()
		ClearHdArea()
		ClearThisPrint()
		ClearPedInPauseMenu()
		ClearFloatingHelp()
		ClearGpsRaceTrack()
		ClearOverrideWeather()
		ClearCloudHat()
		ClearHelp(true)
		SetTimecycleModifier('')
		RemoveTimerBar()
		SetFakeWantedLevel(0)
		SetPedMoveRateOverride(pPed, 1.0)
		SetPedCanRagdoll(pPed, true)
		for _, i in pairs(GetActivePlayers()) do
			NetworkConcealPlayer(i, false, false)
		end
		for v in EnumerateVehicles() do
			pVeh = GetVehiclePedIsIn(pPed, false)
			SetEntityNoCollisionEntity(pVeh, v, true)
			SetEntityNoCollisionEntity(v, pVeh, true)
			SetEntityNoCollisionEntity(pPed, v, true)
			SetEntityNoCollisionEntity(v, pPed, true)
			SetEntityCollision(v, 1, 1)
			ResetEntityAlpha(v)
		end
		for _, i in ipairs(GetActivePlayers()) do
			local iPed = GetPlayerPed(i)
			SetEntityNoCollisionEntity(pPed, iPed, true)
			SetEntityNoCollisionEntity(iPed, pPed, true)
			ResetEntityAlpha(iPed)
		end
		SetRadarZoomPrecise(-1.0)
		NetworkSetFriendlyFireOption(true)
		SetPedCanRagdoll(pPed, true)
		SetEnableHandcuffs(pPed, false)
		ClearPedDecorations(PlayerPedId())
		TriggerServerEvent("SneakyLife:requestPlayerTatoos")
		SneakyEvent("SneakyClothesGetHairFade")
		timerToPos = GetGameTimer()
		Citizen.SetTimeout(30000, function()
			CommandTimeout = false
		end)
	else
		ESX.ShowNotification("~r~Vous devez patienter avant d'effectuer à nouveau cette action.~s~")
	end
end)
