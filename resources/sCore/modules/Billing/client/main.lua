ESX = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)
local max = 1.5
Bill = Bill or {}
Bill.Data = {}

function AddLongString(txt)
	local maxLen = 100
	for i = 0, string.len(txt), maxLen do
		local sub = string.sub(txt, i, math.min(i + maxLen, string.len(txt)))
		AddTextComponentString(sub)
	end
end

function RequestAndWaitDict(dictName)
	if dictName and DoesAnimDictExist(dictName) and not HasAnimDictLoaded(dictName) then
		RequestAnimDict(dictName)
		while not HasAnimDictLoaded(dictName) do Citizen.Wait(100) end
	end
end

function ShowAdvancedAboveRadarMessage(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
	if saveToBrief == nil then saveToBrief = true end
	AddTextEntry('jamyfafis', msg)
	BeginTextCommandThefeedPost('jamyfafis')
	if hudColorIndex then ThefeedNextPostBackgroundColor(hudColorIndex) end
	EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
	EndTextCommandThefeedPostTicker(flash or false, saveToBrief)
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

local AnimBlacklist = {"WORLD_HUMAN_MUSICIAN", "WORLD_HUMAN_CLIPBOARD"}
local AnimFemale = {
	["WORLD_HUMAN_BUM_WASH"] = {"amb@world_human_bum_wash@male@high@idle_a", "idle_a"},
	["WORLD_HUMAN_SIT_UPS"] = {"amb@world_human_sit_ups@male@idle_a", "idle_a"},
	["WORLD_HUMAN_PUSH_UPS"] = {"amb@world_human_push_ups@male@base", "base"},
	["WORLD_HUMAN_BUM_FREEWAY"] = {"amb@world_human_bum_freeway@male@base", "base"},
	["WORLD_HUMAN_CLIPBOARD"] = {"amb@world_human_clipboard@male@base", "base"},
	["WORLD_HUMAN_VEHICLE_MECHANIC"] = {"amb@world_human_vehicle_mechanic@male@base", "base"},
}

function TaskAnimForce(animName, flag, args) -- Faire forcer une anim a un ped (joueur)
	flag, args = flag and tonumber(flag) or false, args or {}
	local ped, time, clearTasks, animPos, animRot, animTime = args.ped or GetPlayerPed(-1), args.time, args.clearTasks, args.pos, args.ang

	if IsPedInAnyVehicle(ped) and (not flag or flag < 40) then return end

	if not clearTasks then ClearPedTasks(ped) end

	if not animName[2] and AnimFemale[animName[1]] and GetEntityModel(ped) == -1667301416 then
		animName = AnimFemale[animName[1]]
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
		TaskStartScenarioInPlace(ped, animName[1], -1, not TableGetValue(AnimBlacklist, animName[1]))
	else
        if not animPos then
            TaskPlayAnim(ped, animName[1], animName[2], 8.0, -8.0, -1, flag or 44, 1, 0, 0, 0, 0)
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

function TaskAnim(animName, time, flag, ped, customPos) -- Faire jouer une anim a un ped (joueur)
	if type(animName) ~= "table" then animName = {animName} end
	ped, flag = ped or GetPlayerPed(-1), flag and tonumber(flag) or false

	if not animName or not animName[1] or string.len(animName[1]) < 1 then return end
    if IsEntityPlayingAnim(ped, animName[1], animName[2], 3) or IsPedActiveInScenario(ped) then ClearPedTasks(ped) 
        return end

	Citizen.CreateThread(function()
		TaskAnimForce(animName, flag, { ped = ped, time = time, pos = customPos })
	end)
end

local function checknumber(num)
    if type(num) == "number" then
        return true
    else
        return false
    end
end

RegisterNetEvent("sBill:CreateBill")
AddEventHandler("sBill:CreateBill", function(data)
    local pPed = PlayerPedId()
    local pPedJob = ESX.PlayerData.job.name
    if ProgressBarExists() then 
        ShowAboveRadarMessage("~r~Vous ne pouvez pas faire cela.")
        return
    end

    local closestPly = GetNearbyPlayer(false, true)

    if not closestPly then 
        return
    end
    --TaskAnim("CODE_HUMAN_MEDIC_TIME_OF_DEATH")
    local raisn = KeyboardInput("Model :",  "Raison :","" ,10)       
    local amount = KeyboardInput("Montant :",  "Montant :","" ,10)
    local amount = tonumber(amount)
    if raisn ~= nil and raisn ~= "" then
        if amount ~= nil and amount ~= "" and checknumber(amount) then
            Bill.Data = {
                title = raisn,
                price = amount,
                playerId = GetPlayerServerId(closestPly),
                solo = data == 2 and true or false,
                account = data ~= 2 and "society_"..pPedJob
            }
            TriggerServerEvent("sBill:SendBill", Bill.Data)
            ClearPedTasks(pPed)
        else
            ShowAboveRadarMessage("~r~Veuillez renseigner un montant.")
            ClearPedTasks(pPed)
        end
    else
        ShowAboveRadarMessage("~r~Veuillez renseigner un motif.")
        ClearPedTasks(pPed)
    end
end)
local BillStopThread = false
RegisterNetEvent("sBill:GetBill")
AddEventHandler("sBill:GetBill", function(bill)
    local pPed = PlayerPedId()
    ShowAboveRadarMessage("Facture: ~b~"..bill.title.."~s~.\nMontant: ~g~"..bill.price.."$~s~.")
    ShowAboveRadarMessage("Accepter: ~b~B~s~ ou Refuser: ~r~X~s~.")
    Bill.OnThread = false
    Bill.HavePayed = false
    Bill.OnThread = true
    Citizen.CreateThread(function()
        while true do 
            Wait(1)
            if Bill.OnThread and IsControlJustPressed(1, 29) then 
                Bill.OnThread = false
                TriggerServerEvent("sBill:PayBills", bill)
                RequestAndWaitDict("mp_common")
                TaskAnim({"mp_common", "givetake2_a"}, 2500, 51)
                PlaySoundFrontend(-1, 'Bus_Schedule_Pickup', 'DLC_PRISON_BREAK_HEIST_SOUNDS', false)
                Bill.HavePayed = true
                break
            end
            if Bill.OnThread and IsControlJustPressed(1, 73) then 
                Bill.OnThread = false
                ShowAboveRadarMessage("~r~Vous avez refusé de payé la facture.")
                TriggerPlayerEvent("esx:showNotification", bill.source, "~r~La personne a refusé de payé la facture.")
                Bill.HavePayed = true
                break
            end
            if BillStopThread then
                BillStopThread = false
                break
            end
        end
    end)
    Wait(6000)
    if not Bill.HavePayed then
        BillStopThread = true
        ShowAboveRadarMessage("~r~Vous avez refusé de payé la facture.")
        TriggerPlayerEvent("esx:showNotification", bill.source, "~r~La personne n'a pas payé.")
        return
    end
    Bill.OnThread = false
    Bill.Data = {}
    return
end)

RegisterNetEvent('sBill:AlertBill')
AddEventHandler('sBill:AlertBill', function(data)
    if data == 1 then 
        ShowAboveRadarMessage("~b~La personne a payé la facture.")
    elseif data == 2 then 
        ShowAboveRadarMessage("~r~La personne n'a pas assez d'argent.")
    elseif data == 3 then
        ShowAboveRadarMessage("~r~La personne n'est pas solvable.")
    end
end)