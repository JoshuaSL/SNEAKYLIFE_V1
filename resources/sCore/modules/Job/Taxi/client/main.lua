Citizen.CreateThread(function()
    while ESX == nil do
       TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)
       Citizen.Wait(10)
   end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
   end
   if ESX.IsPlayerLoaded() then
        ESX.PlayerData = ESX.GetPlayerData()
   end
end)
local taketaxi = false
RegisterNetEvent('Sneakyesx:playerLoaded')
AddEventHandler('Sneakyesx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)
RegisterNetEvent('Sneakyesx:setJob')
AddEventHandler('Sneakyesx:setJob', function(job)
    ESX.PlayerData.job = job
end)
local onService = false
local CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, targetCoords = nil, nil, nil, nil, nil
local SharedConfigTaxi = {
    Job = "taxi",
    Garage = {
        pos = vector3(895.01440429688,-179.05609130859,74.700271606445),
		delete = vector3(909.43731689453,-177.01348876953,73.819389343262),
        Vehicle = {
            Positions = {
                {coords = vector3(899.20709228516,-180.44212341309,73.434677124023), heading = 237.54},
                {coords = vector3(899.34295654297,-180.30104064941,73.439697265625), heading = 236.11},
                {coords = vector3(903.43817138672,-191.77958679199,73.406440734863), heading = 58.82},
                {coords = vector3(904.86511230469,-188.73606872559,73.439529418945), heading = 57.85},
                {coords = vector3(906.96166992188,-186.22630310059,73.637626647949), heading = 60.41},
                {coords = vector3(908.85925292969,-183.30331420898,73.76961517334), heading = 58.70},
                {coords = vector3(920.27844238281,-163.87524414062,74.416847229004), heading = 103.75},
                {coords = vector3(918.21887207031,-167.2610168457,74.207382202148), heading = 102.14},
                {coords = vector3(916.17712402344,-170.79109191895,74.038360595703), heading = 101.92},
                {coords = vector3(911.56591796875,-163.57945251465,73.972557067871), heading = 196.74},
                {coords = vector3(913.61145019531,-159.75421142578,74.38111114502), heading = 197.57},
            },
            List = {
                {name = "taxi", label = "Taxi - Downtown Cab Co"}
            }
        }
    },
    onJob = false,
	JobLocations = {
		vector3(293.5, -590.2, 42.7),
		vector3(253.4, -375.9, 44.1),
		vector3(120.8, -300.4, 45.1),
		vector3(-38.4, -381.6, 38.3),
		vector3(-107.4, -614.4, 35.7),
		vector3(-252.3, -856.5, 30.6),
		vector3(-236.1, -988.4, 28.8),
		vector3(-277.0, -1061.2, 25.7),
		vector3(-576.5, -999.0, 21.8),
		vector3(-602.8, -952.6, 21.6),
		vector3(-790.7, -961.9, 14.9),
		vector3(-912.6, -864.8, 15.0),
		vector3(-1069.8, -792.5, 18.8),
		vector3(-1306.9, -854.1, 15.1),
		vector3(-1468.5, -681.4, 26.2),
		vector3(-1380.9, -452.7, 34.1),
		vector3(-1326.3, -394.8, 36.1),
		vector3(-1383.7, -270.0, 42.5),
		vector3(-1679.6, -457.3, 39.4),
		vector3(-1812.5, -416.9, 43.7),
		vector3(-2043.6, -268.3, 23.0),
		vector3(-2186.4, -421.6, 12.7),
		vector3(-1862.1, -586.5, 11.2),
		vector3(-1859.5, -617.6, 10.9),
		vector3(-1635.0, -988.3, 12.6),
		vector3(-1284.0, -1154.2, 5.3),
		vector3(-1126.5, -1338.1, 4.6),
		vector3(-867.9, -1159.7, 5.0),
		vector3(-847.5, -1141.4, 6.3),
		vector3(-722.6, -1144.6, 10.2),
		vector3(-575.5, -318.4, 34.5),
		vector3(-592.3, -224.9, 36.1),
		vector3(-559.6, -162.9, 37.8),
		vector3(-535.0, -65.7, 40.6),
		vector3(-758.2, -36.7, 37.3),
		vector3(-1375.9, 21.0, 53.2),
		vector3(-1320.3, -128.0, 48.1),
		vector3(-1285.7, 294.3, 64.5),
		vector3(-1245.7, 386.5, 75.1),
		vector3(-760.4, 285.0, 85.1),
		vector3(-626.8, 254.1, 81.1),
		vector3(-563.6, 268.0, 82.5),
		vector3(-486.8, 272.0, 82.8),
		vector3(88.3, 250.9, 108.2),
		vector3(234.1, 344.7, 105.0),
		vector3(435.0, 96.7, 99.2),
		vector3(482.6, -142.5, 58.2),
		vector3(762.7, -786.5, 25.9),
		vector3(809.1, -1290.8, 25.8),
		vector3(490.8, -1751.4, 28.1),
		vector3(432.4, -1856.1, 27.0),
		vector3(164.3, -1734.5, 28.9),
		vector3(-57.7, -1501.4, 31.1),
		vector3(52.2, -1566.7, 29.0),
		vector3(310.2, -1376.8, 31.4),
		vector3(182.0, -1332.8, 28.9),
		vector3(-74.6, -1100.6, 25.7),
		vector3(-887.0, -2187.5, 8.1),
		vector3(-749.6, -2296.6, 12.5),
		vector3(-1064.8, -2560.7, 19.7),
		vector3(-1033.4, -2730.2, 19.7),
		vector3(-1018.7, -2732.0, 13.3),
		vector3(797.4, -174.4, 72.7),
		vector3(508.2, -117.9, 60.8),
		vector3(159.5, -27.6, 67.4),
		vector3(-36.4, -106.9, 57.0),
		vector3(-355.8, -270.4, 33.0),
		vector3(-831.2, -76.9, 37.3),
		vector3(-1038.7, -214.6, 37.0),
		vector3(1918.4, 3691.4, 32.3),
		vector3(1820.2, 3697.1, 33.5),
		vector3(1619.3, 3827.2, 34.5),
		vector3(1418.6, 3602.2, 34.5),
		vector3(1944.9, 3856.3, 31.7),
		vector3(2285.3, 3839.4, 34.0),
		vector3(2760.9, 3387.8, 55.7),
		vector3(1952.8, 2627.7, 45.4),
		vector3(1051.4, 474.8, 93.7),
		vector3(866.4, 17.6, 78.7),
		vector3(319.0, 167.4, 103.3),
		vector3(88.8, 254.1, 108.2),
		vector3(-44.9, 70.4, 72.4),
		vector3(-115.5, 84.3, 70.8),
		vector3(-384.8, 226.9, 83.5),
		vector3(-578.7, 139.1, 61.3),
		vector3(-651.3, -584.9, 34.1),
		vector3(-571.8, -1195.6, 17.9),
		vector3(-1513.3, -670.0, 28.4),
		vector3(-1297.5, -654.9, 26.1),
		vector3(-1645.5, 144.6, 61.7),
		vector3(-1160.6, 744.4, 154.6),
		vector3(-798.1, 831.7, 204.4)
	}
}

local function KeyboardInput(TextEntry, ExampleText, MaxStringLength)
	AddTextEntry("FMMC_KEY_TIP1", TextEntry)
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

local function LoadModelTaxi(model)
	local oldName = model
	local model = GetHashKey(model)
	if IsModelInCdimage(model) then
		RequestModel(model)
		while not HasModelLoaded(model) do Wait(1) end
	else
		ShowNotification("~r~ERREUR: ~s~Modèle inconnu.\nMerci de report le problème au dev. (Modèle: "..oldName.." #"..model..")")
	end
end

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
        local enum = {
            handle = iter,
            destructor = disposeFunc
        }
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

local function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

local function GetVehiclesTaxi()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

local function GetVehiclesInAreaTaxi(coords, area)
    local vehicles       = GetVehiclesTaxi()
    local vehiclesInArea = {}

    for i=1, #vehicles, 1 do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

        if distance <= area then
            table.insert(vehiclesInArea, vehicles[i])
        end
    end

    return vehiclesInArea
end


local function IsSpawnPointClearTaxi(coords, radius)
	local vehicles = GetVehiclesInAreaTaxi(coords, radius)

	return #vehicles == 0
end

local function FoundClearSpawnPointTaxi(zones)
	local found = false
	local count = 0
	for k,v in pairs(zones) do
		local clear = IsSpawnPointClearTaxi(v.coords, 2.0)
		if clear then
			found = v
			break
		end
	end
	return found
end
local function openGarage()
    local mainMenu = RageUI.CreateMenu("Taxi", "Garage", 80, 90, "root_cause", "taxi")

    FreezeEntityPosition(PlayerPedId(), true)
    
    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

    while mainMenu do 
        Wait(1)

        RageUI.IsVisible(mainMenu, true, true, true, function()
            RageUI.Separator("↓ ~y~Liste des véhicules de service~s~ ↓")
            for k,v in pairs(SharedConfigTaxi.Garage.Vehicle.List) do
                RageUI.Button(v.label, nil, {}, true, function(h, a, s)
                    if s then
						if not taketaxi then
							local pos = FoundClearSpawnPointTaxi(SharedConfigTaxi.Garage.Vehicle.Positions)
							if pos ~= false then
								LoadModelTaxi(v.name)
								local veh = CreateVehicle(GetHashKey(v.name), pos.coords, pos.heading, true, false)
								SetVehicleLivery(veh, 12)
								SetEntityAsMissionEntity(veh, 1, 1)
								SetVehicleDirtLevel(veh, 0.0)
								ShowLoadingMessageBurger("Véhicule de service sortie.", 2, 2000)
								local num = math.random(0, 99)
								SetVehicleNumberPlateText(veh, "TAXI-"..num)
								SneakyEvent('Sneakyesx_vehiclelock:givekey', 'no', GetVehicleNumberPlateText(veh))
								TriggerEvent('persistent-vehicles/register-vehicle', veh)
								Wait(350)
								onService = true
								taketaxi = true
							else
								ESX.ShowNotification("Aucun point de sortie disponible")
							end
						else
							ESX.ShowNotification("~r~Vous ne pouvez pas prendre deux fois votre service !")
						end
                    end
                end)
            end
        end)

        if not RageUI.Visible(mainMenu) then
            mainMenu = RMenu:DeleteType("menu", true)
        end

    end

    FreezeEntityPosition(PlayerPedId(), false)

end

local function DrawSub(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, 1)
end

local function GetRandomWalkingNPC()
	local search = {}
	local peds   = ESX.Game.GetPeds()

	for i=1, #peds, 1 do
		if IsPedHuman(peds[i]) and IsPedWalking(peds[i]) and not IsPedAPlayer(peds[i]) then
			table.insert(search, peds[i])
		end
	end

	if #search > 0 then
		return search[GetRandomIntInRange(1, #search)]
	end

	for i=1, 250, 1 do
		local ped = GetRandomPedAtCoord(0.0, 0.0, 0.0, math.huge + 0.0, math.huge + 0.0, math.huge + 0.0, 26)

		if DoesEntityExist(ped) and IsPedHuman(ped) and IsPedWalking(ped) and not IsPedAPlayer(ped) then
			table.insert(search, ped)
		end
	end

	if #search > 0 then
		return search[GetRandomIntInRange(1, #search)]
	end
end

local function ClearCurrentMission()
	if DoesBlipExist(CurrentCustomerBlip) then
		RemoveBlip(CurrentCustomerBlip)
	end

	if DoesBlipExist(DestinationBlip) then
		RemoveBlip(DestinationBlip)
	end

	CurrentCustomer           = nil
	CurrentCustomerBlip       = nil
	DestinationBlip           = nil
	IsNearCustomer            = false
	CustomerIsEnteringVehicle = false
	CustomerEnteredVehicle    = false
	targetCoords              = nil
end

local function StartTaxiJob()
	ClearCurrentMission()

	SharedConfigTaxi.onJob = true
end

local function StopTaxiJob()
	local playerPed = PlayerPedId()

	if IsPedInAnyVehicle(playerPed, false) and CurrentCustomer ~= nil then
		local vehicle = GetVehiclePedIsIn(playerPed,  false)
		TaskLeaveVehicle(CurrentCustomer,  vehicle,  0)

		if CustomerEnteredVehicle then
			TaskGoStraightToCoord(CurrentCustomer,  targetCoords.x,  targetCoords.y,  targetCoords.z,  1.0,  -1,  0.0,  0.0)
		end
	end

	ClearCurrentMission()
	SharedConfigTaxi.onJob = false
end


Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if SharedConfigTaxi.onJob then
			if CurrentCustomer == nil then
				DrawSub('Conduire et chercher un passager', 5000)

				if IsPedInAnyVehicle(playerPed, false) and GetEntitySpeed(playerPed) > 0 then
					local waitUntil = GetGameTimer() + GetRandomIntInRange(30000, 45000)

					while SharedConfigTaxi.onJob and waitUntil > GetGameTimer() do
						Citizen.Wait(0)
					end

					if SharedConfigTaxi.onJob and IsPedInAnyVehicle(playerPed, false) and GetEntitySpeed(playerPed) > 0 then
						CurrentCustomer = GetRandomWalkingNPC()

						if CurrentCustomer ~= nil then
							CurrentCustomerBlip = AddBlipForEntity(CurrentCustomer)

							SetBlipAsFriendly(CurrentCustomerBlip, true)
							SetBlipColour(CurrentCustomerBlip, 2)
							SetBlipCategory(CurrentCustomerBlip, 3)
							SetBlipRoute(CurrentCustomerBlip, true)

							SetEntityAsMissionEntity(CurrentCustomer, true, false)
							ClearPedTasksImmediately(CurrentCustomer)
							SetBlockingOfNonTemporaryEvents(CurrentCustomer, true)

							local standTime = GetRandomIntInRange(60000, 180000)
							TaskStandStill(CurrentCustomer, standTime)

							ESX.ShowNotification('~g~Client trouvé')
						end
					end
				end
			else
				if IsPedFatallyInjured(CurrentCustomer) then
					ESX.ShowNotification('~r~Client inconscient')

					if DoesBlipExist(CurrentCustomerBlip) then
						RemoveBlip(CurrentCustomerBlip)
					end

					if DoesBlipExist(DestinationBlip) then
						RemoveBlip(DestinationBlip)
					end

					SetEntityAsMissionEntity(CurrentCustomer, false, true)

					CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, targetCoords = nil, nil, nil, false, false, false, nil
				end

				if IsPedInAnyVehicle(playerPed, false) then
					local vehicle          = GetVehiclePedIsIn(playerPed, false)
					local playerCoords     = GetEntityCoords(playerPed)
					local customerCoords   = GetEntityCoords(CurrentCustomer)
					local customerDistance = #(playerCoords - customerCoords)

					if IsPedSittingInVehicle(CurrentCustomer, vehicle) then
						if CustomerEnteredVehicle then
							local targetDistance = #(playerCoords - targetCoords)

							if targetDistance <= 10.0 then
								TaskLeaveVehicle(CurrentCustomer, vehicle, 0)

								TriggerServerEvent('fTaxi:success')
								ESX.ShowNotification('Arriver à destination')

								TaskGoStraightToCoord(CurrentCustomer, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)
								SetEntityAsMissionEntity(CurrentCustomer, false, true)
								RemoveBlip(DestinationBlip)

								local scope = function(customer)
									ESX.SetTimeout(60000, function()
										DeletePed(customer)
									end)
								end

								scope(CurrentCustomer)

								CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, targetCoords = nil, nil, nil, false, false, false, nil
							end

							if targetCoords then
								DrawMarker(36, targetCoords.x, targetCoords.y, targetCoords.z + 1.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 234, 223, 72, 155, false, false, 2, true, nil, nil, false)
							end
						else
							RemoveBlip(CurrentCustomerBlip)
							CurrentCustomerBlip = nil
							targetCoords = SharedConfigTaxi.JobLocations[GetRandomIntInRange(1, #SharedConfigTaxi.JobLocations)]
							local distance = #(playerCoords - targetCoords)
							while distance < 3000 do
								Citizen.Wait(5)

								targetCoords = SharedConfigTaxi.JobLocations[GetRandomIntInRange(1, #SharedConfigTaxi.JobLocations)]
								distance = #(playerCoords - targetCoords)
							end

							local street = table.pack(GetStreetNameAtCoord(targetCoords.x, targetCoords.y, targetCoords.z))
							local msg    = nil

							if street[2] ~= 0 and street[2] ~= nil then
								msg =  'Emmenez-moi à proximité de '..GetStreetNameFromHashKey(street[1])..' '..GetStreetNameFromHashKey(street[2])
							else
								msg = 'Emmenez-moi à '..GetStreetNameFromHashKey(street[1])
							end

							ESX.ShowNotification(msg)

							DestinationBlip = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

							BeginTextCommandSetBlipName('STRING')
							AddTextComponentSubstringPlayerName('Destination')
							EndTextCommandSetBlipName(blip)
							SetBlipRoute(DestinationBlip, true)

							CustomerEnteredVehicle = true
						end
					else
						DrawMarker(36, customerCoords.x, customerCoords.y, customerCoords.z + 1.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 234, 223, 72, 155, false, false, 2, true, nil, nil, false)

						if not CustomerEnteredVehicle then
							if customerDistance <= 40.0 then

								if not IsNearCustomer then
									ESX.ShowNotification("~b~ Vous êtes proche du client")
									IsNearCustomer = true
								end

							end

							if customerDistance <= 20.0 then
								if not CustomerIsEnteringVehicle then
									ClearPedTasksImmediately(CurrentCustomer)

									local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

									for i=maxSeats - 1, 0, -1 do
										if IsVehicleSeatFree(vehicle, i) then
											freeSeat = i
											break
										end
									end

									if freeSeat then
										TaskEnterVehicle(CurrentCustomer, vehicle, -1, freeSeat, 2.0, 0)
										CustomerIsEnteringVehicle = true
									end
								end
							end
						end
					end
				else
					DrawSub("Retour au véhicule", 5000)
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function openF6Taxi()
    local mainMenu = RageUI.CreateMenu("Taxi", "Intéractions F6", 80, 90, "root_cause", "taxi")
    
    local list = {
        Announces = {
            "Ouverture~s~",
            "Fermeture~s~"
        },
        AnnouncesIndex = 1
    }

    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

    while mainMenu do 
        Wait(1)

        RageUI.IsVisible(mainMenu, true, true, true, function()
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if taketaxi then
				RageUI.List("Annonce", list.Announces, list.AnnouncesIndex, nil, {}, true, function(Hovered, Active, Selected, Index) 
					if (Selected) then 
						if Index == 1 then
							local announce = 'open'
							TriggerServerEvent('sTaxi:addAnnounce', announce)
						elseif Index == 2 then
							local announce = 'close'
							TriggerServerEvent('sTaxi:addAnnounce', announce)
						end 
					end 
					list.AnnouncesIndex = Index 
				end)

				RageUI.Checkbox("Activé les services PNJ", nil, SharedConfigTaxi.onJob, { Style = RageUI.CheckboxStyle.Tick }, function(h, s, a, c)
					end, function()
						local playerPed = PlayerPedId()
						local vehicle   = GetVehiclePedIsIn(playerPed, false)

						if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
							local playerPed = PlayerPedId()
							local vehModel  = GetEntityModel(GetVehiclePedIsIn(playerPed, false))
							if vehModel ~= -956048545 then return end
							StartTaxiJob()
						end
					end, function()
						StopTaxiJob()
				end)

				RageUI.Button("Attribuer une facture", nil, {RightLabel = "→"}, true,function(h,a,s)
					if s then
						RageUI.CloseAll()
						 TriggerEvent("sBill:CreateBill","society_taxi")
					end
				end)
			else
				RageUI.Separator("")
				RageUI.Separator("~c~Vous n'êtes pas en service.")
				RageUI.Separator("")
			end
        end)

        if not RageUI.Visible(mainMenu) then
            mainMenu = RMenu:DeleteType("menu", true)
        end

    end
end

function DelVehTaxi()
	local pPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(pPed, false) then
		local pVeh = GetVehiclePedIsIn(pPed, false)
		local model = GetEntityModel(pVeh)
		Citizen.CreateThread(function()
			ShowLoadingMessage("Rangement du véhicule ...", 1, 2500)
		end)
		local vehicle = GetVehiclePedIsIn(PlayerPedId(),  false)
        local plate = GetVehicleNumberPlateText(vehicle)
        SneakyEvent('Sneakyesx_vehiclelock:deletekeyjobs', 'no', plate)
		TaskLeaveAnyVehicle(pPed, 1, 1)
		Wait(2500)
		while IsPedInAnyVehicle(pPed, false) do
			TaskLeaveAnyVehicle(pPed, 1, 1)
			ShowLoadingMessage("Rangement du véhicule ...", 1, 300)
			Wait(200)
		end
		TriggerEvent('persistent-vehicles/forget-vehicle', pVeh)
	    DeleteEntity(pVeh)
		taketaxi = false
		onService = false
	else
		ESX.ShowNotification("Vous devez être dans un véhicule.")
	end
end



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
	
    while true do
		
        local waiting = 250
        local myCoords = GetEntityCoords(PlayerPedId())

        if ESX.PlayerData.job.name == SharedConfigTaxi.Job then        
            if #(myCoords-SharedConfigTaxi.Garage.pos) < 1.0 then
                waiting = 1
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~ouvrir le garage~s~.")
                if IsControlJustReleased(0, 54) then
                    openGarage()
                end
            end
			if #(myCoords-SharedConfigTaxi.Garage.delete) < 3.0 then
                waiting = 1
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~r~ranger le véhicule~s~.")
                if IsControlJustReleased(0, 54) then
					if onService then
                    	DelVehTaxi()
					else
						ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
					end
                end
            end
        end

        Wait(waiting)
    end
end)

function CheckServiceTaxi()
	return onService
end