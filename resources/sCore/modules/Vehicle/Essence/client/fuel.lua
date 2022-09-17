ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
end)

local SneakyEvent = TriggerServerEvent
local onRemplissage = false
local fuelPumps = {}
local isNearPump = false
local onFuelMenu = false
local ActualEssence = false
local function FindNearestFuelPump()
	local coords = GetEntityCoords(PlayerPedId())
	local fuelPumps = {}
	local handle, object = FindFirstObject()
	local success

	repeat
		if FuelServices.PumpModels[GetEntityModel(object)] then
			table.insert(fuelPumps, object)
		end

		success, object = FindNextObject(handle, object)
	until not success

	EndFindObject(handle)

	local pumpObject = 0
	local pumpDistance = 1000

	for _, fuelPumpObject in pairs(fuelPumps) do
		local dstcheck = GetDistanceBetweenCoords(coords, GetEntityCoords(fuelPumpObject))

		if dstcheck < pumpDistance then
			pumpDistance = dstcheck
			pumpObject = fuelPumpObject
		end
	end

	return pumpObject, pumpDistance
end

local function CreateBlip(coords)
	local blip = AddBlipForCoord(coords)

	SetBlipSprite(blip, 361)
	SetBlipScale(blip, 0.3)
	SetBlipColour(blip, 1)
	SetBlipDisplay(blip, 4)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Station Essence")
	EndTextCommandSetBlipName(blip)

	return blip
end

local function openMenu(vehicle)
    local mainMenu = RageUI.CreateMenu("Essence", "Station service, ~o~que voulez-vous faire~s~ ?", 0, 0)
    
    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

    FreezeEntityPosition(vehicle, true)
    onFuelMenu = true
    local ChooseLitre = 1

    while mainMenu do
        Wait(1)

        RageUI.IsVisible(mainMenu, true, true, true, function()
            RageUI.Button("Consulter le réservoir du véhicule", nil, {}, true, function(h, a, s)
                if s then
                    if ActualEssence then
                        RemoveNotification(ActualEssence)
                    end
                    ActualEssence = ShowAboveRadarMessage("Réservoir du véhicule : ~b~"..math.ceil(GetVehicleFuelLevel(vehicle)).."L~s~.")
                end
            end)
            NeedFuel = (100 - math.ceil(GetVehicleFuelLevel(vehicle)))
            RageUI.Button("Faire le plein du véhicule", nil, {RightLabel = "Prix : "..FuelServices.defaultPrice*NeedFuel.."~g~$~s~"}, true, function(h, a, s)
                if s then
                    TriggerServerEvent("sFuel:requestToAddFuelFull", GetVehicleFuelLevel(vehicle))
                end
            end)
            RageUI.Progress("Litre d'essence", ChooseLitre, 100, nil, false, true, function(Hovered, Active, Selected, Color)
                ChooseLitre = Color
            end)

            RageUI.Button("Acheter "..ChooseLitre.." ~o~litre d'essence~s~", "Prix : "..FuelServices.defaultPrice*ChooseLitre.."~g~$~s~", {}, true, function(h, a, s)
                if s then
                    TriggerServerEvent("sFuel:requestToAddFuel", GetVehicleFuelLevel(vehicle), ChooseLitre)
                end
            end)
        end)

        if not RageUI.Visible(mainMenu) then
            mainMenu = RMenu:DeleteType("menu", true)
        end
    end

    onFuelMenu = false
    SetVehicleEngineOn(vehicle, true, false, false)
    FreezeEntityPosition(vehicle, false)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(250)

		local pumpObject, pumpDistance = FindNearestFuelPump()

		if pumpDistance < 4.0 then
			isNearPump = pumpObject
		else
			isNearPump = false
			Citizen.Wait(math.ceil(pumpDistance * 20))
		end
	end
end)

CreateThread(function()
    for id, pos in pairs(FuelServices.PositionBlip) do
        CreateBlip(pos)
    end
    while true do
        local myCoords = GetEntityCoords(PlayerPedId())
        local waiting = 250

        if not onRemplissage and isNearPump and IsPedInAnyVehicle(PlayerPedId(), true) then
            waiting = 1
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour acceder à la ~b~station service~s~.")
            if IsControlJustReleased(0, 54) then
                openMenu(GetVehiclePedIsIn(PlayerPedId(), false))
            end
        end

        Wait(waiting)
    end
end)

RegisterNetEvent("sFuel:animatedPlayer")
AddEventHandler("sFuel:animatedPlayer", function(fuel)
    onRemplissage = true
    local waiting = true
    SetVehicleEngineOn(vehicle, false, true, true)
    ProgressBar("Remplissage", 245, 167, 0, 100, 500*fuel)
    
    Wait(500*fuel)
    
    RemoveProgressBar()
    SetVehicleEngineOn(vehicle, true, false, false)
    onRemplissage = false
end)

RegisterNetEvent("sFuel:addFuelToVehicle")
AddEventHandler("sFuel:addFuelToVehicle", function(liters)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local actualFuel = DecorGetFloat(vehicle, "fuel")
    ESX.ShowNotification("Réaprovisionnement en cours (~b~"..math.floor(liters+0.5).."L~s~).")
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        ESX.ShowNotification("~r~Le plein n'a pas été effectué, la prochaine fois ne sortez pas de votre véhicule")
        return
    end
    if GetPedInVehicleSeat(vehicle, -1) ~= PlayerPedId() then
        ESX.ShowNotification("~r~Le plein n'a pas été effectué.")
        return
    end
    local total = DecorGetFloat(vehicle, "fuel")+liters
    if total >= 100 then 
        total = 100.0 
    end
    DecorSetFloat(vehicle, "fuel", total)
    ESX.ShowNotification("Le plein a été ~g~effectué~s~.")
    SetVehicleUndriveable(vehicle, false)
    SetVehicleEngineOn(vehicle, 1, 1, 0)
end)

local function useFuel(vehicle, speed)
    local fuelToRemove = 0.0
    local multiplicator = 0.5
    if speed >= 2.0 then
        fuelToRemove = speed*0.0000075
    end
    if DecorGetFloat(vehicle, "fuel") - fuelToRemove*multiplicator >= 0 then
        DecorSetFloat(vehicle, "fuel", DecorGetFloat(vehicle, "fuel") - fuelToRemove*multiplicator)
    end
    return fuelToRemove*multiplicator
end

Citizen.CreateThread(function()
    DecorRegister("fuel", 1)
    while true do
        if IsPedInAnyVehicle(PlayerPedId(), false) then 
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if not DecorExistOn(vehicle, "fuel") then
                local essencebase = math.random(30.0, 65.0)
                DecorSetFloat(vehicle, "fuel", essencebase+ 0.00)
            end
            if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
                local speed = math.floor(GetEntitySpeed(vehicle) * 3.6 + 0.5)
                local consommation = useFuel(vehicle, speed)
                if DecorGetFloat(vehicle, "fuel") ~= GetVehicleFuelLevel(vehicle) then
                    SetVehicleFuelLevel(vehicle, DecorGetFloat(vehicle, "fuel"))
                end
            end
        end
        Wait(1)
    end
end)
