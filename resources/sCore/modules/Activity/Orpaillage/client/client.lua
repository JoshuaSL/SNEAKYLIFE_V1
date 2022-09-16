Citizen.CreateThread(function()
	while ESX == nil do
    	TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)
    	Citizen.Wait(0)
	end
end)

local allowedDirts = {3008270349, 3833216577, 1333033863, 1109728704, 3594309083, 1144315879, 2128369009, 223086562, 1584636462, -700658213}
local orpillageZone = {"LAGO"}
local pCoords = GetEntityCoords(PlayerPedId())
local enpelle = false
local chancepelle = 0
local chancebroken = 0
function RequestAndWaitModel(modelName)
	if modelName and IsModelInCdimage(modelName) and not HasModelLoaded(modelName) then
		RequestModel(modelName)
		while not HasModelLoaded(modelName) do Citizen.Wait(100) end
	end
end

function RequestAndWaitDict(dictName)
	if dictName and DoesAnimDictExist(dictName) and not HasAnimDictLoaded(dictName) then
		RequestAnimDict(dictName)
		while not HasAnimDictLoaded(dictName) do Citizen.Wait(100) end
	end
end

local shovelModel = GetHashKey("prop_ld_shovel")
local animDict = "random@burial"
local B6zKxgVs,O3_X2=0,60*1000*0.27
local pellebroken = 0
local function UseShovel(Player)
	TriggerServerEvent("sTerreActivity:ChangeState",true)
	ProgressBar("Récupération en cours",99,57,0,200, O3_X2)
	enpelle = true
    local pos, ped = GetEntityCoords(PlayerPedId()), PlayerPedId()
    local weaponUsed = GetCurrentPedWeapon(ped)
	pellebroken = pellebroken + 1
	RequestAndWaitDict(animDict)
	RequestAndWaitModel(shovelModel)
	local playerPed = PlayerPedId()
	local shovel = CreateObject(shovelModel, GetEntityCoords(playerPed), true, false, true)
	SetNetworkIdCanMigrate(ObjToNet(shovel), false)
    SetModelAsNoLongerNeeded(shovelModel)
	SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(shovel), false)
	SetCurrentPedWeapon(playerPed, GetHashKey("weapon_unarmed"), true)
	TaskPlayAnim(playerPed, animDict, "a_burial", 8.0, -4.0, -1, 0, 0, 0, 0, 0)
	AttachEntityToEntity(shovel, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 2, 1)
	local endTime = GetGameTimer() + GetAnimDuration(animDict, "a_burial") * 900
	local particleDict = "scr_reburials"
	RequestNamedPtfxAsset(particleDict)
	while not HasNamedPtfxAssetLoaded(particleDict) do
		Citizen.Wait(0)
	end
	while GetGameTimer() < endTime do
		if IsEntityPlayingAnim(playerPed, "random@burial", "a_burial", 3) then
			Citizen.Wait(250)
			UseParticleFxAssetNextCall(particleDict)
			StartNetworkedParticleFxNonLoopedOnEntity("scr_burial_dirt", shovel, 0.0, 0.0, -0.95, 0.0, 180.0, 0.0, 1065353216, 0, 0, 0)
		end
		Citizen.Wait(0)
	end
	TaskPlayAnim(playerPed, animDict, "a_burial_stop", 8.0, -4.0, -1, 0, 0, 0, 0, 0)
	DetachEntity(shovel, 0, true)
	AttachEntityToEntity(shovel, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 2, 1)
	UseParticleFxAssetNextCall(particleDict)
	StartNetworkedParticleFxNonLoopedOnEntity("scr_burial_dirt", shovel, 0.0, 0.0, -0.95, 0.0, 180.0, 0.0, 1065353216, 0, 0, 0)
	RemoveNamedPtfxAsset(particleDict)
	while GetEntityAnimCurrentTime(playerPed, "random@burial", "a_burial_stop") <= 0.275 do 
		Citizen.Wait(320) 
	end
	TriggerServerEvent('sTerreActivity:HarvestTerre', "terre")
	enpelle = false
    DeleteEntity(shovel)
	RemoveAnimDict(animDict)
    ClearPedTasks(ped)
	SetCurrentPedWeapon(ped, weaponUsed, true)
	if pellebroken >= 30 then 
		ShowAboveRadarMessage("~r~Votre pelle s'est brisé au niveau du manche.")
		TriggerServerEvent("sTerreActivity:BrokenPelle","pelle")
		pellebroken = 0
	end
    return true
end

function StartPelleDirt(Player)
    local pos, ped = GetEntityCoords(PlayerPedId()), PlayerPedId()
	local _, hit, _, _, material = GetShapeTestResultEx(CastRayPointToPoint(pos, pos - vector3(0.0, 0.0, 2.0), -1, ped))
	if not tableHasValue(allowedDirts, material) then 
		ShowAboveRadarMessage("~r~Vous ne pouvez pas creuser ici.") 
		return 
	end
	if not tableHasValue(orpillageZone, GetNameOfZone(pos.x,pos.y,pos.z)) then 
		ShowAboveRadarMessage("~r~Vous ne pouvez pas creuser ici.") 
		return 
	end
	if not UseShovel(Player) then 
		return 
	end
end

RegisterNetEvent('sTerreActivity:VerifPelle') 
AddEventHandler('sTerreActivity:VerifPelle', function()
	if IsEntityInWater(PlayerPedId()) then
		ShowAboveRadarMessage("~r~Vous devez être en dehors de l'eau.")
	else
		if IsPedStill(PlayerPedId()) then
			if not enpelle then 
				StartPelleDirt(PlayerPedId())
			end
		end
	end
end)

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

function ShowNotificationWithButton(button, message, back)
	if back then ThefeedNextPostBackgroundColor(back) end
	SetNotificationTextEntry("jamyfafi")
	return EndTextCommandThefeedPostReplayInput(1, button, message)
end


local casseroltime
local notifCass = false
local casserolebroken = 0
function Casserole()
	TriggerServerEvent("sTerreActivity:ChangeState",true)
	local pProps=GetHashKey("prop_kitch_pot_lrg")
	
	local time = 12000
	local ped = PlayerPedId()
	if casseroltime and casseroltime > GetGameTimer() then 
		if notifCass then 
			RemoveNotification(notifCass) 
		end
		notifCass = ShowAboveRadarMessage(string.format("~r~Veuillez patienter encore %s seconde(s) avant de re-utiliser votre casserole.", math.floor((casseroltime - GetGameTimer()) / 1000))) return 
	end

	local treeeeTime = 0 + time
	casseroltime = GetGameTimer() + treeeeTime

	RequestAndWaitModel(pProps)
	RemoveNotification(notifCass) 
	local objectca = CreateObject(pProps,GetEntityCoords(PlayerPedId())+GetEntityForwardVector(PlayerPedId())*0.7-vec3(0.0,0.0,1.0),true,true,true)
	casserolebroken = casserolebroken + 1
	FreezeEntityPosition(objectca,true)
	SetNetworkIdCanMigrate(ObjToNet(objectca),false)
	if not IsPedSwimming(ped) then 
		ProgressBar("Filtrage de la terre",0,243,255,150, 12000)
	end
	TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_BUM_WASH", 0, false)
	Citizen.Wait(12000)
	if not IsPedSwimming(ped) then
		TriggerServerEvent('sterreActivity:useCasserole', true)
	end
	if casserolebroken >= 50 then 
		ShowAboveRadarMessage("~r~Votre casserole s'est abîmée.")
		TriggerServerEvent('sTerreActivity:removeItem')
		casserolebroken = 0
	end
	ClearPedTasks(PlayerPedId())
	SetModelAsNoLongerNeeded(pProps)
	DeleteEntity(objectca)
	return true 
end

RegisterNetEvent('sTerreActivity:addCasserole')
AddEventHandler('sTerreActivity:addCasserole', function()
	if IsEntityInWater(PlayerPedId()) then
		Casserole()
	else
		ShowAboveRadarMessage("~r~Vous devez avoir les pieds dans l'eau.")
	end
end)