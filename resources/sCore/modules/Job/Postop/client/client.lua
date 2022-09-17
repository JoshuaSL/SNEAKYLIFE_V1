ESX = nil

local postopService = false
local tenueService = false
local Status = {
	DELIVERY_INACTIVE                 = 0,
	PLAYER_STARTED_DELIVERY           = 1,
	PLAYER_REACHED_VEHICLE_POINT      = 2,
	PLAYER_REMOVED_GOODS_FROM_VEHICLE = 3,
	PLAYER_REACHED_DELIVERY_POINT     = 4,
	PLAYER_RETURNING_TO_BASE          = 5
}

local CurrentStatus             = Status.DELIVERY_INACTIVE
local CurrentSubtitle           = nil
local CurrentBlip               = nil
local CurrentType               = nil
local CurrentVehicle            = nil
local CurrentAttachments        = {}
local CurrentVehicleAttachments = {}
local DeliveryLocation          = {}
local DeliveryComplete          = {}
local DeliveryRoutes            = {}
local PlayerJob                 = nil
local FinishedJobs              = 0
SneakyEvent = TriggerServerEvent
function refresh()
    Citizen.CreateThread(function()
        ESX.PlayerData = ESX.GetPlayerData()
        pGrade = ESX.GetPlayerData().job.grade_label
    end)
end

PostOPVestiaire = {}
RMenu.Add('postopvestiaire', 'main', RageUI.CreateMenu("", "",0,0,"root_cause","gopostal"))
RMenu:Get('postopvestiaire', 'main'):SetSubtitle("~b~Actions disponibles")
RMenu:Get('postopvestiaire', 'main').EnableMouse = false
RMenu:Get('postopvestiaire', 'main').Closed = function()
    PostOPVestiaire.Menu = false
end

function OpenpostopvestiaireRageUIMenu()

    if PostOPVestiaire.Menu then
        PostOPVestiaire.Menu = false
    else
        PostOPVestiaire.Menu = true
        RageUI.Visible(RMenu:Get('postopvestiaire', 'main'), true)

        Citizen.CreateThread(function()
            while PostOPVestiaire.Menu do
                RageUI.IsVisible(RMenu:Get('postopvestiaire', 'main'), true, false, true, function()
                    RageUI.Button("Tenue Civil", nil, {RightLabel = "~g~Se changer →"}, true, function(h,a,s)
                        if s then
								tenueService = false
					ESX.TriggerServerCallback('Sneakyesx_skin:getPlayerSkin', function(skin)
                                TriggerEvent('Sneakyskinchanger:loadSkin', skin)
                            end)
                        end
                    end)
                    RageUI.Separator("~b~↓~s~ Tenues de service ~b~↓~s~")
                    if GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01") then
						for k,v in pairs(config.clothsgopost.men) do
							RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "~g~Se changer →"}, true, function(h,a,s)
								if s then
									tenueService = true
									TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
									TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
									
								end)
								end
							end)
						end
                    else
						for k,v in pairs(config.clothsgopost.women) do
							RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "~g~Se changer →"}, true, function(h,a,s)
								if s then
									tenueService = true
								TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
									TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
									
								end)
								end
							end)
						end
                    end
                end)
				Wait(0)
			end
		end)
	end

end

Citizen.CreateThread(function()
    while true do
		att = 500
		local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
		if postopService then
			for k,v in pairs(Config.PostOP.PositionVestiaire) do
				local mPos = Vdist(pCoords, v.coords)
				if not PostOPVestiaire.Menu then
					if mPos <= 10.0 then
						att = 1
						
						if mPos <= 2.0 then
						DrawMarker(20, v.coords.x, v.coords.y, v.coords.z+0.9, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 0, 155, 255, 255, 0, false, false, 2, false, false, false, false)
						ESX.ShowHelpNotification("Appyez sur ~INPUT_CONTEXT~ pour accéder au vestiaire")
						if IsControlJustPressed(0, 51) then
							ESX.TriggerServerCallback("kPostOp:checkService", function(cb) 
								if cb then
									postopService = false
									ESX.ShowNotification("Vous devez allez ~b~prendre~s~ votre ~g~service~s~ !")
								else
									postopService = true
									refresh()
									OpenpostopvestiaireRageUIMenu()		
								end
							end)
						end
						end
					end
				end
			end
		end
		if #(pCoords-vector3(68.872756958008,126.9900970459,79.20386505127)) < 1.0 then
			att = 1
			ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour pour ~g~prendre~s~/~r~quitter~s~ votre service !")
			if IsControlJustPressed(0, 51) then
				ESX.TriggerServerCallback("kPostOp:checkService", function(cb) 
					if cb then
						postopService = true
					else
						postopService = false
						ESX.TriggerServerCallback('Sneakyesx_skin:getPlayerSkin', function(skin)
							TriggerEvent('Sneakyskinchanger:loadSkin', skin) 
						 end)   
					end
					SneakyEvent("kPostOp:service", cb)
				end)
			end
		elseif #(pCoords-vector3(68.872756958008,126.9900970459,79.20386505127)) < 1.0 then
			att = 1
			DrawMarker(20, 68.872756958008,126.9900970459,79.20386505127, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 0, 155, 255, 255, 0, false, false, 2, false, false, false, false)
		end
        Citizen.Wait(att)
    end
end)

function HandleInput()
	
	if postopService ~= true or tenueService ~= true then
		return
	end
	
	if CurrentStatus == Status.PLAYER_REMOVED_GOODS_FROM_VEHICLE then
		DisableControlAction(0, 21, true)
	else
		Wait(500)
	end
end

function HandleLogic()
	
	if postopService ~= true or tenueService ~= true then
		return
	end
	
	local playerPed = GetPlayerPed(-1)
	local pCoords   = GetEntityCoords(playerPed)
	
	if CurrentStatus ~= Status.DELIVERY_INACTIVE then
		if IsPedDeadOrDying(playerPed, true) then
			FinishDelivery(CurrentType, false)
			return
		elseif GetVehicleEngineHealth(CurrentVehicle) < 20 and CurrentVehicle ~= nil then
			FinishDelivery(CurrentType, false)
			return
		end
	
		if CurrentStatus == Status.PLAYER_STARTED_DELIVERY then
			if not IsPlayerInsideDeliveryVehicle() then
				CurrentSubtitle = "Entrez dans votre ~b~véhicule~s~"
			else
				CurrentSubtitle = nil
			end
			
			if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, DeliveryLocation.Item1.x, DeliveryLocation.Item1.y, DeliveryLocation.Item1.z, true) < 1.5 then
				CurrentStatus = Status.PLAYER_REACHED_VEHICLE_POINT
				CurrentSubtitle = "Laissez votre voiture et sortez la ~b~marchandise~w~"
				PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", false, 0, true)
			end
		end
		
		if CurrentStatus == Status.PLAYER_REMOVED_GOODS_FROM_VEHICLE then
			if CurrentType == 'van' or CurrentType == 'truck' then
				CurrentSubtitle = "Ammener votre ~b~marchandise~w~ à la destination"
				if CurrentType == 'van' and not IsEntityPlayingAnim(playerPed, "anim@heists@box_carry@", "walk", 3) then
					ForceCarryAnimation();
				end
			end
			
			if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, DeliveryLocation.Item2.x, DeliveryLocation.Item2.y, DeliveryLocation.Item2.z, true) < 1.5 then
				
				SneakyEvent("esx_deliveries:finishDelivery:server", CurrentType)
				PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", false, 0, true)
				FinishedJobs = FinishedJobs + 1
				
				ESX.ShowNotification("~r~Go~s ~~b~Postal~s~ Status de la mission: ~g~".. FinishedJobs .. "/" .. #DeliveryRoutes)
				
				if FinishedJobs >= #DeliveryRoutes then
					RemovePlayerProps()
					RemoveBlip(CurrentBlip)
					DeliveryLocation.Item1 = Config.Base.retveh
					DeliveryLocation.Item2 = Config.Base.retveh2
					CurrentBlip            = CreateBlipAt(DeliveryLocation.Item1.x, DeliveryLocation.Item1.y, DeliveryLocation.Item1.z)
					CurrentSubtitle        = "Retour au centre de livraison et restituer votre véhicule"
					CurrentStatus          = Status.PLAYER_RETURNING_TO_BASE
					return
				else
					RemovePlayerProps()
					GetNextDeliveryPoint(false)
					CurrentStatus = Status.PLAYER_STARTED_DELIVERY
					CurrentSubtitle = "Conduisez à la prochaine ~b~destination~w~"
					PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", false, 0, true)
				end
			end
		end
		Wait(500)
	else
		Wait(1000)
	end
end

-- Handling markers and object status

function HandleMarkers()
	
	if postopService ~= true or tenueService ~= true then
		return
	end
	
	local pCoords = GetEntityCoords(GetPlayerPed(-1))
	local deleter = Config.Base.deleter
	
	if CurrentStatus ~= Status.DELIVERY_INACTIVE then
		if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, deleter.x, deleter.y, deleter.z) < 3.5 then
			DrawMarker(20, deleter.x, deleter.y, deleter.z, 0, 0, 0, 0, 180.0, 0, 1.5, 1.5, 1.5, 249, 38, 114, 150, true, true)
			DisplayHelpText("Appuyez sur ~INPUT_CONTEXT~ pour terminer la livraison")
			if IsControlJustReleased(0, 51) then
				EndDelivery()
				return
			end
		end
		
		if CurrentStatus == Status.PLAYER_STARTED_DELIVERY then
			if not IsPlayerInsideDeliveryVehicle() and CurrentVehicle ~= nil then
				local VehiclePos = GetEntityCoords(CurrentVehicle)
				local ArrowHeight = VehiclePos.z
				ArrowHeight = VehiclePos.z + 1.0
				
				if CurrentType == 'van' then
					ArrowHeight = ArrowHeight + 1.0
				elseif CurrentType == 'truck' then
					ArrowHeight = ArrowHeight + 2.0
				end
				
				DrawMarker(20, VehiclePos.x, VehiclePos.y, ArrowHeight, 0, 0, 0, 0, 180.0, 0, 0.8, 0.8, 0.8, 255, 189, 0, 150, true, true)
			else
				local dl = DeliveryLocation.Item1
				if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, dl.x, dl.y, dl.z, true) < 20 then
					DrawMarker(20, dl.x, dl.y, dl.z, 0, 0, 0, 0, 180.0, 0, 1.5, 1.5, 1.5, 102, 217, 239, 150, true, true)
				end
			end
		end
		
		if CurrentStatus == Status.PLAYER_REACHED_VEHICLE_POINT then
			if not IsPlayerInsideDeliveryVehicle() then
				TrunkPos = GetEntityCoords(CurrentVehicle)
				TrunkForward = GetEntityForwardVector(CurrentVehicle)
				local ScaleFactor = 1.0
				
				for k, v in pairs(Config.Scales) do
					if k == CurrentType then
						ScaleFactor = v
					end
				end
				
				TrunkPos = TrunkPos - (TrunkForward * ScaleFactor)
				TrunkHeight = TrunkPos.z
				TrunkHeight = TrunkPos.z + 0.7
				
				local ArrowSize = {x = 0.8, y = 0.8, z = 0.8}
				DrawMarker(20, TrunkPos.x, TrunkPos.y, TrunkHeight, 0, 0, 0, 180.0, 0, 0, ArrowSize.x, ArrowSize.y, ArrowSize.z, 255, 189, 0, 150, true, true)
				
				if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, TrunkPos.x, TrunkPos.y, TrunkHeight, true) < 1.0 then
					DisplayHelpText("Appuyez sur ~INPUT_CONTEXT~ pour retirer votre ~b~marchandise~s~ de votre véhicule")
					if IsControlJustReleased(0, 51) then
						PlayTrunkAnimation()
						GetPlayerPropsForDelivery(CurrentType)
						CurrentStatus = Status.PLAYER_REMOVED_GOODS_FROM_VEHICLE
					end
				end
			end
		end
		
		if CurrentStatus == Status.PLAYER_REMOVED_GOODS_FROM_VEHICLE then
			local dp = DeliveryLocation.Item2
			DrawMarker(20, dp.x, dp.y, dp.z, 0, 0, 0, 0, 180.0, 0, 1.5, 1.5, 1.5, 255, 189, 0, 150, true, true)
		end
		
		if CurrentStatus == Status.PLAYER_RETURNING_TO_BASE then
			local dp = Config.Base.deleter
			DrawMarker(20, dp.x, dp.y, dp.z, 0, 0, 0, 0, 180.0, 0, 1.5, 1.5, 1.5, 255, 189, 0, 150, true, true)
		end
	else
		local bCoords = Config.Base.coords
		if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, bCoords.x, bCoords.y, bCoords.z, true) < 10.0 then
			local VanPos     = Config.Base.van
			local TruckPos   = Config.Base.truck
			
			DrawMarker(36, VanPos.x, VanPos.y, VanPos.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 250, 170, 60, 150, true, true)
			DrawMarker(39, TruckPos.x, TruckPos.y, TruckPos.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 230, 219, 91, 150, true, true)
			
			local SelectType = false
			if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, VanPos.x, VanPos.y, VanPos.z, true) < 1.5 then
				DisplayHelpText("Appuyez sur ~INPUT_CONTEXT~ pour demarrer les livraisons, dépôt de garantie ~b~$"..tostring(Config.Safe.van))
				SelectType = 'van'
			elseif GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, TruckPos.x, TruckPos.y, TruckPos.z, true) < 1.5 then
				DisplayHelpText("Appuyez sur ~INPUT_CONTEXT~ pour demarrer les livraisons, dépôt de garantie ~b~$"..tostring(Config.Safe.truck))
				SelectType = 'truck'
			else
				SelectType = false
			end
			
			if SelectType ~= false then
				if IsControlJustReleased(0, 51) then
					StartDelivery(SelectType)
					PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", false, 0, true)
				end
			end
		end
	end
end

-- The trunk animation when the player remove the goods from the vehicle
function PlayTrunkAnimation()
	Citizen.CreateThread(function()
		if CurrentType == 'truck' then
			if Config.Models.vehDoor.usingTrunkForTruck then
				SetVehicleDoorOpen(CurrentVehicle, 5, false, false)
			else
				SetVehicleDoorOpen(CurrentVehicle, 2, false, false)
				SetVehicleDoorOpen(CurrentVehicle, 3, false, false)
			end
		elseif CurrentType == 'van' then
			if Config.Models.vehDoor.usingTrunkForVan then
				SetVehicleDoorOpen(CurrentVehicle, 2, false, false)
				SetVehicleDoorOpen(CurrentVehicle, 3, false, false)
			else
				
			end
			
		end
		Wait(1000)
		if CurrentType == 'truck' then
			if Config.Models.vehDoor.usingTrunkForTruck then
				SetVehicleDoorShut(CurrentVehicle, 5, false)
			else
				SetVehicleDoorShut(CurrentVehicle, 2, false)
				SetVehicleDoorShut(CurrentVehicle, 3, false)
			end
		elseif CurrentType == 'van' then
			if Config.Models.vehDoor.usingTrunkForVan then
				SetVehicleDoorShut(CurrentVehicle, 2, false)
				SetVehicleDoorShut(CurrentVehicle, 3, false)
			else
				SetVehicleDoorShut(CurrentVehicle, 2, false)
				SetVehicleDoorShut(CurrentVehicle, 3, false)
			end
		end
	end)
end

-- Create a blip for the location

function CreateBlipAt(x, y, z)
	
	local tmpBlip = AddBlipForCoord(x, y, z)
	
	SetBlipSprite(tmpBlip, 1)
	SetBlipColour(tmpBlip, 66)
	SetBlipAsShortRange(tmpBlip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Livraison")
	EndTextCommandSetBlipName(blip)
	SetBlipAsMissionCreatorBlip(tmpBlip, true)
	SetBlipRoute(tmpBlip, true)
	
	return tmpBlip
end

-- Let the player carry something

function ForceCarryAnimation()
	TaskPlayAnim(GetPlayerPed(-1), "anim@heists@box_carry@", "walk", 8.0, 8.0, -1, 51)
end

-- Tell the server start delivery job

function StartDelivery(deliveryType)
	SneakyEvent("esx_deliveries:removeSafeMoney:server", deliveryType)
end

-- Check is the player in the delivery vehicle

function IsPlayerInsideDeliveryVehicle()
	if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
		local playerVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		if playerVehicle == CurrentVehicle then
			return true
		end
	end
	return false
end

-- Is this checkpoint the last checkpoint?

function IsLastDelivery()
	local isLast = false
	local dp1    = DeliveryLocation.Item2
	local dp2    = DeliveryRoutes[#DeliveryRoutes].Item2
	if dp1.x == dp2.x and dp1.y == dp2.y and dp1.z == dp2.z then
		isLast = true
	end
	return isLast
end

-- Remove all object from the player ped

function RemovePlayerProps()
	for i = 0, #CurrentAttachments do
		DetachEntity(CurrentAttachments[i])
		DeleteEntity(CurrentAttachments[i])
	end
	ClearPedTasks(GetPlayerPed(-1))
	CurrentAttachments = {}
end

-- Spawn an object and attach it to the player

function GetPlayerPropsForDelivery(deliveryType)
	
	RequestAnimDict("anim@heists@box_carry@")
	while not HasAnimDictLoaded("anim@heists@box_carry@") do
		Citizen.Wait(0)
	end
		
	if deliveryType == 'van' then
		TaskPlayAnim(GetPlayerPed(-1), "anim@heists@box_carry@", "walk", 8.0, 8.0, -1, 51)
		
		local Rand      = GetRandomFromRange(1, #Config.VanGoodsPropNames)
		local ModelHash = GetHashKey(Config.VanGoodsPropNames[Rand])
		
		WaitModelLoad(ModelHash)
		
		local PlayerPed = GetPlayerPed(-1)
		local PlayerPos = GetOffsetFromEntityInWorldCoords(PlayerPed, 0.0, 0.0, -5.0)
		local Object = CreateObject(ModelHash, PlayerPos.x, PlayerPos.y, PlayerPos.z, true, false, false)
		
		AttachEntityToEntity(Object, PlayerPed, GetPedBoneIndex(PlayerPed, 28422), 0.0, 0.0, -0.15, 0.0, 0.0, 90.0, true, false, false, true, 1, true)
		table.insert(CurrentAttachments, Object)
	end
	
	if deliveryType == 'truck' then
		TaskPlayAnim(GetPlayerPed(-1), "anim@heists@box_carry@", "walk", 8.0, 8.0, -1, 51)
		
		local ModelHash = GetHashKey("prop_sacktruck_02b")
		
		WaitModelLoad(ModelHash)
		
		local PlayerPed = GetPlayerPed(-1)
		local PlayerPos = GetOffsetFromEntityInWorldCoords(PlayerPed, 0.0, 0.0, -5.0)
		local Object = CreateObject(ModelHash, PlayerPos.x, PlayerPos.y, PlayerPos.z, true, false, false)
		
		AttachEntityToEntity(Object, PlayerPed, GetEntityBoneIndexByName(PlayerPed, "SKEL_Pelvis"), -0.075, 0.90, -0.86, -20.0, -0.5, 181.0, true, false, false, true, 1, true)
		table.insert(CurrentAttachments, Object)
	end
	
	local JobData = (FinishedJobs + 1) / #DeliveryRoutes
	
	if JobData >= 0.5 and #CurrentVehicleAttachments > 2 then
		DetachEntity(CurrentVehicleAttachments[1])
		DeleteEntity(CurrentVehicleAttachments[1])
		table.remove(CurrentVehicleAttachments, 1)
	end
	if JobData >= 1.0 and #CurrentVehicleAttachments > 1 then
		DetachEntity(CurrentVehicleAttachments[1])
		DeleteEntity(CurrentVehicleAttachments[1])
		table.remove(CurrentVehicleAttachments, 1)
	end
end

function SpawnDeliveryVehicle(deliveryType)
	
	local Rnd           = GetRandomFromRange(1, #Config.ParkingSpawns)
	local SpawnLocation = Config.ParkingSpawns[Rnd]
	
	if deliveryType == 'truck' then
		local ModelHash = GetHashKey(Config.Models.truck)
		WaitModelLoad(ModelHash)
		CurrentVehicle = CreateVehicle(ModelHash, SpawnLocation.x, SpawnLocation.y, SpawnLocation.z, SpawnLocation.h, true, true)
		TriggerEvent('persistent-vehicles/register-vehicle', CurrentVehicle)
		SetVehicleLivery(CurrentVehicle, 2)
		SetVehicleColours(CurrentVehicle, 0, 0)
	end
	
	if deliveryType == 'van' then
		local ModelHash = GetHashKey(Config.Models.van)
		WaitModelLoad(ModelHash)
		CurrentVehicle = CreateVehicle(ModelHash, SpawnLocation.x, SpawnLocation.y, SpawnLocation.z, SpawnLocation.h, true, true)
		TriggerEvent('persistent-vehicles/register-vehicle', CurrentVehicle)
		SetVehicleExtra(CurrentVehicle, 2, false)
		SetVehicleLivery(CurrentVehicle, 3)
		SetVehicleColours(CurrentVehicle, 0, 0)
	end
	
	DecorSetInt(CurrentVehicle, "Delivery.Rental", Config.DecorCode)
	SetVehicleOnGroundProperly(CurrentVehicle)

	if deliveryType == 'van' then
		local ModelHash1 = GetHashKey("prop_cs_cardbox_01")
		local ModelHash2 = GetHashKey("prop_champ_box_01")
		WaitModelLoad(ModelHash1)
		WaitModelLoad(ModelHash2)
		local Object1 = CreateObject(ModelHash1, SpawnLocation.x, SpawnLocation.y, SpawnLocation.z, true, false, false)
		local Object2 = CreateObject(ModelHash1, SpawnLocation.x, SpawnLocation.y, SpawnLocation.z, true, false, false)
		local Object3 = CreateObject(ModelHash2, SpawnLocation.x, SpawnLocation.y, SpawnLocation.z, true, false, false)
		AttachEntityToEntity(Object1, CurrentVehicle, GetEntityBoneIndexByName(CurrentVehicle, "chassic"), 0.25, -1.55, -0.12, 0.0, 0.0, 0.0, true, true, false, true, 0, true)
		AttachEntityToEntity(Object2, CurrentVehicle, GetEntityBoneIndexByName(CurrentVehicle, "chassic"), -0.26, -1.55, 0.2, 0.0, 0.0, 0.0, true, true, false, true, 0, true)
		AttachEntityToEntity(Object3, CurrentVehicle, GetEntityBoneIndexByName(CurrentVehicle, "chassic"), -0.26, -1.55, -0.12, 0.0, 0.0, 0.0, true, true, false, true, 0, true)
		table.insert(CurrentVehicleAttachments, Object1)
		table.insert(CurrentVehicleAttachments, Object2)
		table.insert(CurrentVehicleAttachments, Object3)
	end
end

-- Get the next destination

function GetNextDeliveryPoint(firstTime)
	if CurrentBlip ~= nil then
		RemoveBlip(CurrentBlip)
	end
	
	for i = 1, #DeliveryComplete do
		if not DeliveryComplete[i] then
			if not firstTime then
				DeliveryComplete[i] = true
				break
			end
		end
	end
	
	for i = 1, #DeliveryComplete do
		if not DeliveryComplete[i] then
			CurrentBlip = CreateBlipAt(DeliveryRoutes[i].Item1.x, DeliveryRoutes[i].Item1.y, DeliveryRoutes[i].Item1.z)
			DeliveryLocation = DeliveryRoutes[i]
			break
		end
	end
end

-- Create some random destinations

function CreateRoute(deliveryType)
	
	local TotalDeliveries = GetRandomFromRange(Config.Deliveries.min, Config.Deliveries.max)
	local DeliveryPoints = {}
	if deliveryType == 'van' then
		DeliveryPoints = Config.DeliveryLocationsVan
	else
		DeliveryPoints = Config.DeliveryLocationsTruck
	end
	
	while #DeliveryRoutes < TotalDeliveries do
		Wait(1)
		local PreviousPoint = nil
		if #DeliveryRoutes < 1 then
			PreviousPoint = GetEntityCoords(GetPlayerPed(-1))
		else
			PreviousPoint = DeliveryRoutes[#DeliveryRoutes].Item1
		end
		
		local Rnd             = GetRandomFromRange(1, #DeliveryPoints)
		local NextPoint       = DeliveryPoints[Rnd]
		local HasPlayerAround = false
		
		for i = 1, #DeliveryRoutes do
			local Distance = GetDistanceBetweenCoords(NextPoint.Item1.x, NextPoint.Item1.y, NextPoint.Item1.z, DeliveryRoutes[i].x, DeliveryRoutes[i].y, DeliveryRoutes[i].z, true)
			if Distance < 50 then
				HasPlayerAround = true
			end
		end
		
		if not HasPlayerAround then
			table.insert(DeliveryRoutes, NextPoint)
			table.insert(DeliveryComplete, false)
		end
	end
end

function EndDelivery()
	local PlayerPed = GetPlayerPed(-1)
	if not IsPedSittingInAnyVehicle(PlayerPed) or GetVehiclePedIsIn(PlayerPed) ~= CurrentVehicle then
		ESX.ShowNotification("~r~Go~s ~~b~Postal~s~ Vous avez perdue votre caution")
		FinishDelivery(CurrentType, false)
	else
		ReturnVehicle(CurrentType)
	end
end

-- Return the vehicle to system

function ReturnVehicle(deliveryType)
	SetVehicleAsNoLongerNeeded(CurrentVehicle)
	TriggerEvent('persistent-vehicles/forget-vehicle', CurrentVehicle)
	DeleteEntity(CurrentVehicle)
	ESX.ShowNotification("~r~Go~s ~~b~Postal~s~ Vous avez bien rendu le véhicule")
	FinishDelivery(deliveryType, true)
end

-- When the delivery mission finish

function FinishDelivery(deliveryType, safeReturn)
	if CurrentVehicle ~= nil then
		for i = 0, #CurrentVehicleAttachments do
			DetachEntity(CurrentVehicleAttachments[i])
			DeleteEntity(CurrentVehicleAttachments[i])
		end
		CurrentVehicleAttachments = {}
		TriggerEvent('persistent-vehicles/forget-vehicle', CurrentVehicle)
		DeleteEntity(CurrentVehicle)
	end
	
	CurrentStatus    = Status.DELIVERY_INACTIVE
	CurrentVehicle   = nil
	CurrentSubtitle  = nil
	FinishedJobs     = 0
	DeliveryRoutes   = {}
	DeliveryComplete = {}
	DeliveryLocation = {}
	
	if CurrentBlip ~= nil then
		RemoveBlip(CurrentBlip)
	end
	
	CurrentBlip = nil
	CurrentType = ''
	
	SneakyEvent("esx_deliveries:returnSafe:server", deliveryType, safeReturn)
end

-- Some helpful functions

function DisplayHelpText(text)
	SetTextComponentFormat('STRING')
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function GetRandomFromRange(a, b)
	return GetRandomIntInRange(a, b)
end

function WaitModelLoad(name)
	RequestModel(name)
	while not HasModelLoaded(name) do
		Wait(0)
	end
end

function Draw2DTextCenter(x, y, text, scale)
    SetTextFont(0)
    SetTextProportional(7)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
	SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

-- Initialize ESX

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	Wait(1000)
	while not ESX.IsPlayerLoaded() do
		Citizen.Wait(10)
	end
	SneakyEvent("esx_deliveries:getPlayerJob:server")
end)

-- The other 4 threads

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		HandleInput()
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		HandleLogic()
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		HandleMarkers()
	end
end)

function DrawMissionText(msg, time)
    ClearPrints()
    SetTextEntry_2('STRING')
    AddTextComponentString(msg)
    DrawSubtitleTimed(time, 1)
end


Citizen.CreateThread(function()
	while true do
		if CurrentSubtitle ~= nil then
			DrawMissionText(CurrentSubtitle,1)
		end
		Wait(1)
	end
end)

-- Register events and handlers

RegisterNetEvent('esx:setJob')
RegisterNetEvent('esx_deliveries:setPlayerJob:client')
RegisterNetEvent('esx_deliveries:startJob:client')

AddEventHandler('esx:setJob', function(job)
	PlayerJob = job.name
end)

AddEventHandler('esx_deliveries:setPlayerJob:client', function(job)
	PlayerJob = job
end)

AddEventHandler('esx_deliveries:startJob:client', function(deliveryType)
	ESX.ShowNotification("~r~Go~s ~~b~Postal~s~ Conduisez votre véhicule en toute sécurité jusqu'à la destination et livrer la ~b~marchandise~s~")
	local ModelHash = GetHashKey("prop_paper_bag_01")
	WaitModelLoad(ModelHash)
	SpawnDeliveryVehicle(deliveryType)
	CreateRoute(deliveryType)
	GetNextDeliveryPoint(true)
	CurrentType   = deliveryType
	CurrentStatus = Status.PLAYER_STARTED_DELIVERY
end)
