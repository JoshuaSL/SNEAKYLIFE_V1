local showMenu = false
local toggleCoffre = 0
local toggleCapot = 0
local toggleLocked = 0
local playing_emote = false
local src = sourc
ESX = nil

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

function GetPlayers() -- Get Les joueurs
	local players = {}

	for _,player in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(player)

		if DoesEntityExist(ped) then
			table.insert(players, player)
		end
	end

	return players
end


function GetNearbyPlayers(distance)
	local ped = GetPlayerPed(-1)
	local playerPos = GetEntityCoords(ped)
	local nearbyPlayers = {}

	for _,v in pairs(GetPlayers()) do
		local otherPed = GetPlayerPed(v)
		local otherPedPos = otherPed ~= ped and IsEntityVisible(otherPed) and GetEntityCoords(otherPed)

		if otherPedPos and GetDistanceBetweenCoords(otherPedPos, playerPos) <= (distance or max) then
			nearbyPlayers[#nearbyPlayers + 1] = v
		end
	end
	return nearbyPlayers
end

local cWait = false;
local xWait = false
function GetNearbyPlayer(solo, other)
    if cWait then
        xWait = true
        while cWait do
            Citizen.Wait(5)
        end
    end
    xWait = false
    local cTimer = GetGameTimer() + 10000;
    local oPlayer = GetNearbyPlayers(2)
    if solo then
        oPlayer[#oPlayer + 1] = PlayerId()
    end
    if #oPlayer == 0 then
        ShowAboveRadarMessage("~b~Distance\n~w~Rapprochez-vous.")
        return false
    end
    if #oPlayer == 1 and other then
        return oPlayer[1]
    end
    ShowAboveRadarMessage("Appuyer sur ~g~E~s~ pour valider.~n~Appuyer sur ~b~A~s~ pour changer de cible.~n~Appuyer sur ~r~X~s~ pour annuler.")
    Citizen.Wait(100)
    local cBase = 1
    cWait = true
    while GetGameTimer() <= cTimer and not xWait do
        Citizen.Wait(0)
        DisableControlAction(0, 38, true)
        DisableControlAction(0, 73, true)
        DisableControlAction(0, 44, true)
        if IsDisabledControlJustPressed(0, 38) then
            cWait = false
            return oPlayer[cBase]
        elseif IsDisabledControlJustPressed(0, 73) then
            ShowAboveRadarMessage("~r~Vous avez annulé.")
            break
        elseif IsDisabledControlJustPressed(0, 44) then
            cBase = (cBase == #oPlayer) and 1 or (cBase + 1)
        end
        local cPed = GetPlayerPed(oPlayer[cBase])
        local cCoords = GetEntityCoords(cPed)
        DrawMarker(0, cCoords.x, cCoords.y, cCoords.z + 1.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.1, 0.1, 0.1, 0, 243, 255, 30, 1, 1, 0, 0, 0, 0, 0)
    end
    cWait = false
    return false
end



-- Toggle car trunk (Example of Vehcile's menu)
RegisterNUICallback('togglecoffre', function(data)
    TriggerEvent(Config.openTrunkEvent)
    SetVehicleDoorOpen(data.id, 5, false)
end)

-- Toggle car hood (Example of Vehcile's menu)
RegisterNUICallback('togglecapot', function(data)
    if (toggleCapot == 0) then
        SetVehicleDoorOpen(data.id, 4, false)
        toggleCapot = 1
    else
        SetVehicleDoorShut(data.id, 4, false)
        toggleCapot = 0
    end
end)


RegisterNUICallback('togglelock', function()
    local src = source
    exports.sCore:OpenCloseVehicle()
end)

function GetVehicleHealth(entityVeh)
	return math.floor( math.max(0, math.min(100, GetVehicleEngineHealth(entityVeh) / 10 ) ) )
end

RegisterNUICallback('etat', function(data)
    local coords = GetEntityCoords(PlayerPedId())
    local vehicle = ESX.Game.GetClosestVehicle(coords)
    if not DoesEntityExist(vehicle) then return end
    ESX.ShowNotification("Réservoir: ~b~"..math.ceil(GetVehicleFuelLevel(vehicle)).."L\n~w~État moteur: ~b~"..math.ceil(GetVehicleEngineHealth(vehicle)/10).."%\n~w~État carosserie: ~b~"..math.ceil(GetVehicleBodyHealth(vehicle)/10).."%")
end)

function forceAnim(animName, flag, args)
	flag, args = flag and tonumber(flag) or false, args or {}
	local ped, time, clearTasks, animPos, animRot, animTime = args.ped or GetPlayerPed(-1), args.time, args.clearTasks, args.pos, args.ang

	if IsPedInAnyVehicle(ped) and (not flag or flag < 40) then return end

	if not clearTasks then ClearPedTasks(ped) end

	if not animName[2] and femaleFix[animName[1]] and GetEntityModel(ped) == -1667301416 then
		animName = femaleFix[animName[1]]
	end

	if animName[2] and not HasAnimDictLoaded(animName[1]) then
		if not DoesAnimDictExist(animName[1]) then return end
		RequestAnimDict(animName[1])
		while not HasAnimDictLoaded(animName[1]) do
			Citizen.Wait(10)
		end
	end

	if not animName[2] then
		ClearAreaOfObjects(GetEntityCoords(ped), 1.0)
		TaskStartScenarioInPlace(ped, animName[1], -1, not tableHasValue(animBug, animName[1]))
	else
        if not animPos then
            TaskPlayAnim(ped, animName[1], animName[2], 8.0, -8.0, -1, flag or 44, 1, 0, 0, 0, 0)
            --TaskPlayAnim(ped, animName[1], animName[2], 8.0, -8.0, -1, 1, 1, 0, 0, 0)
		else
			TaskPlayAnimAdvanced(ped, animName[1], animName[2], animPos.x, animPos.y, animPos.z, animRot.x, animRot.y, animRot.z, 8.0, -8.0, -1, 1, 1, 0, 0, 0)
		end
	end

	if time and type(time) == "number" then
		Citizen.Wait(time)
		ClearPedTasks(ped)
	end

	if not args.dict then RemoveAnimDict(animName[1]) end
end

RegisterNUICallback('trainer', function(data)
    local closestPly = GetNearbyPlayer(false, true)
    if not closestPly then 
        return
    end
    idplayertonotdrag = GetPlayerServerId(closestPly)
    TriggerServerEvent('sContext:drag', GetPlayerServerId(closestPly))
end)

RegisterNUICallback('PlayerIdPersonnage', function(data)
    local closestPly = GetNearbyPlayer(false, true)
    if not closestPly then 
        return
    end
    TriggerServerEvent('sContext:GetServerIdPersonnage', GetPlayerServerId(closestPly))
end)




