ESX = nil
SneakyEvent = TriggerServerEvent
--local rgbArray = {}
local Vehicles = {}
local PlayerData = {}
local lsMenuIsShowed = false
local isInLSMarker = false
local myCar = {}
local vehicleClass = nil
local vehiclePrice = 50000

local shopProfitValue = 0
local shopProfit = 2
local shopCart = {}
local totalCartValue = 0
local canClose = false
local society = ""
local stop = false
local deleting = false
local onService = false
local ActionsAnnonce = {
	"~b~Ouverture~s~",
	"~b~Fermeture~s~"
}
local ActionsAnnonceIndex = 1

MecanoMenu = {

    PositionVestiaire = {
        {coords = vector3(-210.88482666016,-1337.7976074219,30.890434265137-0.9)},
    },
	PositionKitRepa = {
        {coords = vector3(-190.98756408691,-1308.4470214844,31.29490852356-0.9)},
    },
	PositionGarage = {
        {coords = vector3(-193.50018310547,-1295.0726318359,31.295980453491-0.9)},
    },
	PositionDeleteGarage = {
        {coords = vector3(-183.68037414551,-1297.4237060547,31.295957565308-0.9)},
    },
}

local Clothesbennys = {


    clothsbleu = {
        men = {
            {
                grade = "Mécanicien (BLEU)",
                cloths = {
                    ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                    ['torso_1'] = 65,   ['torso_2'] = 1,
                    ['decals_1'] = 0,   ['decals_2'] = 0,
                    ['arms'] = 4,
                    ['pants_1'] = 38,   ['pants_2'] = 1,
                    ['shoes_1'] = 51,   ['shoes_2'] = 0,
                    ['chain_1'] = 0,    ['chain_2'] = 0,
                    ['ears_1'] = -1,     ['ears_2'] = 0,
                    ['mask_1'] = 0,     ['mask_2'] = 0,
                    ['bproof_1'] = 0,     ['bproof_2'] = 0
                },
            },
        },
        women = {

            {
                grade = "Mécaniciene (BLEU)",
                cloths = {
                    ['tshirt_1'] = 14,  ['tshirt_2'] = 0,
                    ['torso_1'] = 59,   ['torso_2'] = 1,
                    ['decals_1'] = 0,   ['decals_2'] = 0,
                    ['arms'] = 3,
                    ['pants_1'] = 38,   ['pants_2'] = 1,
                    ['shoes_1'] = 52,   ['shoes_2'] = 0,
                    ['chain_1'] = 0,    ['chain_2'] = 0,
                    ['ears_1'] = -1,     ['ears_2'] = 0,
                    ['mask_1'] = 0,     ['mask_2'] = 0,
                    ['bproof_1'] = 0,     ['bproof_2'] = 0
                },
            },
        },
    },




    clothsrouge = {
        men = {
            {
                grade = "Mécanicien (ROUGE)",
                cloths = {
                    ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                    ['torso_1'] = 65,   ['torso_2'] = 0,
                    ['decals_1'] = 0,   ['decals_2'] = 0,
                    ['arms'] = 4,
                    ['pants_1'] = 38,   ['pants_2'] = 0,
                    ['shoes_1'] = 51,   ['shoes_2'] = 0,
                    ['chain_1'] = 0,    ['chain_2'] = 0,
                    ['ears_1'] = -1,     ['ears_2'] = 0,
                    ['mask_1'] = 0,     ['mask_2'] = 0,
                    ['bproof_1'] = 0,     ['bproof_2'] = 0
                },
            },
        },
        women = {

            {
                grade = "Mécanicien (ROUGE)",
                cloths = {
                    ['tshirt_1'] = 14,  ['tshirt_2'] = 0,
                    ['torso_1'] = 59,   ['torso_2'] = 0,
                    ['decals_1'] = 0,   ['decals_2'] = 0,
                    ['arms'] = 3,
                    ['pants_1'] = 38,   ['pants_2'] = 0,
                    ['shoes_1'] = 52,   ['shoes_2'] = 0,
                    ['chain_1'] = 0,    ['chain_2'] = 0,
                    ['ears_1'] = -1,     ['ears_2'] = 0,
                    ['mask_1'] = 0,     ['mask_2'] = 0,
                    ['bproof_1'] = 0,     ['bproof_2'] = 0
                }
            },
        },
    },
}

MecanoVestiaire = {}
RMenu.Add('mecanovestiaire', 'main', RageUI.CreateMenu("", "",10, 200,"shopui_title_supermod","shopui_title_supermod"))
RMenu:Get('mecanovestiaire', 'main'):SetSubtitle("~y~Actions disponibles")
RMenu:Get('mecanovestiaire', 'main').EnableMouse = false
RMenu:Get('mecanovestiaire', 'main').Closed = function()
    MecanoVestiaire.Menu = false
end

function OpenMecanoVestiaireRageUIMenu()

    if MecanoVestiaire.Menu then
        MecanoVestiaire.Menu = false
    else
        MecanoVestiaire.Menu = true
        RageUI.Visible(RMenu:Get('mecanovestiaire', 'main'), true)

        Citizen.CreateThread(function()
            while MecanoVestiaire.Menu do
                RageUI.IsVisible(RMenu:Get('mecanovestiaire', 'main'), true, false, true, function()
					ESX.PlayerData = ESX.GetPlayerData()
                    pGrade = ESX.GetPlayerData().job.grade_label
                    RageUI.Button("Tenue Civil", nil, {RightLabel = "~g~Se changer →"}, true, function(h,a,s)
                        if s then
                            ESX.TriggerServerCallback('Sneakyesx_skin:getPlayerSkin', function(skin)
                                TriggerEvent('Sneakyskinchanger:loadSkin', skin)
								onService = false
                            end)
                        end
                    end)
                    RageUI.Separator("~y~↓~s~ Tenues de service ~y~↓~s~")
                    if GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01") then
						for k,v in pairs(Clothesbennys.clothsbleu.men) do
							RageUI.Button("Tenue de ~y~"..v.grade, nil, {RightLabel = "~g~Se changer →"}, true, function(h,a,s)
								if s then
									TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
										TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
										onService = true
									end)
								end
							end)
						end
						for k,v in pairs(Clothesbennys.clothsrouge.men) do
							RageUI.Button("Tenue de ~y~"..v.grade, nil, {RightLabel = "~g~Se changer →"}, true, function(h,a,s)
								if s then
									TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
										TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
										onService = true
									end)
								end
							end)
						end
                    else
						for k,v in pairs(Clothesbennys.clothsbleu.women) do
							RageUI.Button("Tenue de ~y~"..v.grade, nil, {RightLabel = "~g~Se changer →"}, true, function(h,a,s)
								if s then
									TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
										TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
										onService = true
									end)
								end
							end)
						end
						for k,v in pairs(Clothesbennys.clothsrouge.women) do
							RageUI.Button("Tenue de ~y~"..v.grade, nil, {RightLabel = "~g~Se changer →"}, true, function(h,a,s)
								if s then
									TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
										TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
										onService = true
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
local MecanoKitRepa = {}
RMenu.Add('mecanoshop', 'main', RageUI.CreateMenu("", "",10, 200,"shopui_title_supermod","shopui_title_supermod"))
RMenu:Get('mecanoshop', 'main'):SetSubtitle("~b~Produits disponibles")
RMenu:Get('mecanoshop', 'main').EnableMouse = false
RMenu:Get('mecanoshop', 'main').Closed = function()
    MecanoKitRepa.Menu = false
    FreezeEntityPosition(PlayerPedId(), false)
end

function OpenMecanoKitRepaRageUI()
	if MecanoKitRepa.Menu then
        MecanoKitRepa.Menu = false
    else
	MecanoKitRepa.Menu = true
	RageUI.Visible(RMenu:Get('mecanoshop', 'main'), true)
	FreezeEntityPosition(PlayerPedId(), true)

        Citizen.CreateThread(function()
			while MecanoKitRepa.Menu do
                RageUI.IsVisible(RMenu:Get('mecanoshop', 'main'), true, false, true, function()
                    RageUI.Button("Kit de réparation", false, {RightLabel = "→ Acheter 500~g~$"}, true, function(h,a,s)
					if s then
						SneakyEvent('Sneakymecano:giveItem', "fixkit",500)
					end
                    end)
                end)
				Wait(0)
			end
		end)
	end
end


local Garagemecano = {

	garagebennys = {
        vehicule = {
            {label = "Grande Dépanneuse", veh = "flatbed", stock = 5},
            {label = "Plateau", veh = "towtruck", stock = 3},
        },
        pos  = {
            {pos = vector3(-189.37858581543,-1290.5090332031,31.262281417847), heading = 270.24},
        },
    },
}


MecanoGarage = {}
RMenu.Add('mecanogarage', 'main', RageUI.CreateMenu("", "",10, 200,"shopui_title_supermod","shopui_title_supermod"))
RMenu:Get('mecanogarage', 'main'):SetSubtitle("~b~Actions disponibles")
RMenu:Get('mecanogarage', 'main').EnableMouse = false
RMenu:Get('mecanogarage', 'main').Closed = function()
    MecanoGarage.Menu = false
end

function OpenMecanoGarageRageUIMenu()

    if MecanoGarage.Menu then
        MecanoGarage.Menu = false
    else
        MecanoGarage.Menu = true
        RageUI.Visible(RMenu:Get('mecanogarage', 'main'), true)

        Citizen.CreateThread(function()
            while MecanoGarage.Menu do
                RageUI.IsVisible(RMenu:Get('mecanogarage', 'main'), true, false, true, function()
                    RageUI.Separator("~b~↓~s~ Véhicule de service ~b~↓~s~")
                    for k,v in pairs(Garagemecano.garagebennys.vehicule) do
                        RageUI.Button(v.label, nil, {RightLabel = "Stock: [~b~"..v.stock.."~s~]"}, v.stock > 0, function(h,a,s)
                            if s then
                                local pos = FoundClearSpawnPoint(Garagemecano.garagebennys.pos)
                                if pos ~= false then
                                    LoadModel(v.veh)
                                    local veh = CreateVehicle(GetHashKey(v.veh), pos.pos, pos.heading, true, false)
                                    SetEntityAsMissionEntity(veh, 1, 1)
                                    SetVehicleDirtLevel(veh, 0.0)
                                    ShowLoadingMessage("Véhicule de service sortie.", 2, 2000)
                                    SneakyEvent('Sneakyesx_vehiclelock:givekey', 'no', GetVehicleNumberPlateText(veh))
									TriggerEvent('persistent-vehicles/register-vehicle', veh)
                                    Garagemecano.garagebennys.vehicule[k].stock = Garagemecano.garagebennys.vehicule[k].stock - 1
                                    Wait(350)
                                else
                                    ESX.ShowNotification("Aucun point de sortie disponible")
                                end
                            end
                        end)
                    end
                end)
				Wait(0)
			end
		end)
	end

end

function ShowLoadingMessage(text, spinnerType, timeMs)
	Citizen.CreateThread(function()
		BeginTextCommandBusyspinnerOn("STRING")
		AddTextComponentSubstringPlayerName(text)
		EndTextCommandBusyspinnerOn(spinnerType)
		Wait(timeMs)
		RemoveLoadingPrompt()
	end)
end

function DelVehMecano()
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
		for k,v in pairs(Garagemecano.garagebennys.vehicule) do
			if GetHashKey(v.veh) == model then
				Garagemecano.garagebennys.vehicule[k].stock = Garagemecano.garagebennys.vehicule[k].stock + 1
			end
		end
	else
		ShowNotification("Vous devez être dans un véhicule.")
	end
end

function LoadModel(model)
	local oldName = model
	local model = GetHashKey(model)
	if IsModelInCdimage(model) then
		RequestModel(model)
		while not HasModelLoaded(model) do Wait(1) end
	else
		ShowNotification("~r~ERREUR: ~s~Modèle inconnu.\nMerci de report le problème au dev. (Modèle: "..oldName.." #"..model..")")
	end
end

function FoundClearSpawnPoint(zones)
	local found = false
	local count = 0
	for k,v in pairs(zones) do
		local clear = IsSpawnPointClear(v.pos, 2.0)
		if clear then
			found = v
			break
		end
	end
	return found
end

function IsSpawnPointClear(coords, radius)
	local vehicles = GetVehiclesInArea(coords, radius)

	return #vehicles == 0
end

function GetVehiclesInArea (coords, area)
	local vehicles       = GetVehicles()
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

function GetVehicles()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

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

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

local MecanoClean = {}
RMenu.Add('mecanoclean', 'main', RageUI.CreateMenu("", "",10, 200,"shopui_title_supermod","shopui_title_supermod"))
RMenu:Get('mecanoclean', 'main'):SetSubtitle("~r~Produits disponibles")
RMenu:Get('mecanoclean', 'main').EnableMouse = false
RMenu:Get('mecanoclean', 'main').Closed = function()
    MecanoClean.Menu = false
end

function doorAction(door)
    if not IsPedInAnyVehicle(PlayerPedId(),false) then return end
    local veh = GetVehiclePedIsIn(PlayerPedId(),false)
    if door == -1 then
        if doorActionIndex == 1 then
            for i = 0, 7 do
                SetVehicleDoorOpen(veh,i,false,false)
            end
        else
            for i = 0, 7 do
                SetVehicleDoorShut(veh,i,false)
            end
        end
        doorCoolDown = true
        Citizen.SetTimeout(500, function()
            doorCoolDown = false
        end)
        return
    end
    if doorActionIndex == 1 then
        SetVehicleDoorOpen(veh,door,false,false)
        doorCoolDown = true
        Citizen.SetTimeout(500, function()
            doorCoolDown = false
        end)
    else
        SetVehicleDoorShut(veh,door,false)
        doorCoolDown = true
        Citizen.SetTimeout(500, function()
            doorCoolDown = false
        end)
    end
end

function isAllowedToManageVehicle()
    if IsPedInAnyVehicle(PlayerPedId(),false) then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
        if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
            return true
        end
        return false
    end
    return false
end

Citizen.CreateThread(function()
	while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(niceESX) ESX = niceESX end)
        Wait(500)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then
        ESX.PlayerData = ESX.GetPlayerData()
    end
    ESX.PlayerData = ESX.GetPlayerData()
    while true do
        att = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
		for k,v in pairs(MecanoMenu.PositionVestiaire) do
            local mPos = #(pCoords-v.coords)
		  if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'mecano' then
			if not MecanoVestiaire.Menu then
				if mPos <= 10.0 then
					att = 1
					
					if mPos <= 2.0 then
					DrawMarker(20, v.coords.x, v.coords.y, v.coords.z+0.9, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 0, 155, 255, 255, 0, false, false, 2, false, false, false, false)
					ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au Vestiaire")
					if IsControlJustPressed(0, 51) then
						ESX.PlayerData = ESX.GetPlayerData()
							pGrade = ESX.GetPlayerData().job.grade_label
						OpenMecanoVestiaireRageUIMenu()
					end
					end
				end
			end
		end
        end
		for k,v in pairs(MecanoMenu.PositionKitRepa) do
            local mPos = #(pCoords-v.coords)

            if not MecanoKitRepa.Menu then
                if mPos <= 10.0 then
                    att = 1
                    DrawMarker(1, v.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 150, 200, 170, 0, 0, 0, 1, nil, nil, 0)
                   
                    if mPos <= 1.5 then
				    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder à l'armoire")
                        if IsControlJustPressed(0, 51) then
                            OpenMecanoKitRepaRageUI()
                        end
                    end
                end
            end
        end
		for k,v in pairs(MecanoMenu.PositionGarage) do
            local mPos = #(pCoords-v.coords)
            if not MecanoGarage.Menu then
                if mPos <= 10.0 then
                    att = 1
                    
                    if mPos <= 1.5 then
						if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'mecano' then
							ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au Garage")
							if IsControlJustPressed(0, 51) then
								if onService then
									OpenMecanoGarageRageUIMenu()
								else
									ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
								end
							end
						end
                    end
                end
            end
        end
        for k,v in pairs(MecanoMenu.PositionDeleteGarage) do
            local mPos = #(pCoords-v.coords)
            if not MecanoGarage.Menu then
                if IsPedInAnyVehicle(PlayerPedId(), true) then
                    if mPos <= 10.0 then
                        att = 1
                        if mPos <= 3.5 then
						if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'mecano' then
							DrawMarker(20, v.coords.x, v.coords.y, v.coords.z+0.9, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255, 0, 0, 255, 55555, false, true, 2, false, false, false, false)
							ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule de service")
							if IsControlJustPressed(0, 51) then
								if onService then
									DelVehMecano()
								else
									ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
								end
							end
						end
                        end
                    end
                end
            end
        end
        Citizen.Wait(att)
    end
end)

local MecanoActionMenu = {}
function OpenMecanoActionMenuRageUIMenu()

    if MecanoActionMenu.Menu then 
        MecanoActionMenu.Menu = false 
        RageUI.Visible(RMenu:Get('mecanoactionmenu', 'main'), false)
        return
    else
        RMenu.Add('mecanoactionmenu', 'main', RageUI.CreateMenu("", "", 0, 0,"shopui_title_supermod","shopui_title_supermod"))
		RMenu.Add('mecanoactionmenu', 'action', RageUI.CreateSubMenu(RMenu:Get("mecanoactionmenu", "main"),"", "~y~Benny's"))
        RMenu.Add('mecanoactionmenu', 'facture', RageUI.CreateSubMenu(RMenu:Get("mecanoactionmenu", "action"),"", "~y~Benny's"))
        RMenu:Get('mecanoactionmenu', 'main'):SetSubtitle("~y~Benny's")
        RMenu:Get('mecanoactionmenu', 'main').EnableMouse = false
        RMenu:Get('mecanoactionmenu', 'main').Closed = function()
            MecanoActionMenu.Menu = false
        end
        MecanoActionMenu.Menu = true 
        RageUI.Visible(RMenu:Get('mecanoactionmenu', 'main'), true)
        Citizen.CreateThread(function()
			while MecanoActionMenu.Menu do
                RageUI.IsVisible(RMenu:Get('mecanoactionmenu', 'main'), true, false, true, function()
				RageUI.List("Annonce", ActionsAnnonce, ActionsAnnonceIndex, nil, {}, true, function(Hovered, Active, Selected, Index) 
					if (Selected) then 
						if Index == 1 then
							local announce = 'ouvert'
							SneakyEvent('mecano:addAnnounce', announce)
						elseif Index == 2 then
							local announce = 'fermeture'
							SneakyEvent('mecano:addAnnounce', announce)
						end 
					end 
					ActionsAnnonceIndex = Index 
				end)
                    RageUI.Button("Crocheter", nil, { RightLabel = "→" },true, function(h,a,s)
						if s then
							local playerPed = PlayerPedId()
							local vehicle = ESX.Game.GetVehicleInDirection()
							local coords = GetEntityCoords(playerPed, false)

							if IsPedSittingInAnyVehicle(playerPed) then
								ESX.ShowNotification("Vous ne pouvez pas crocheter de véhicule en étant dans un véhicule")
								return
							end

							if DoesEntityExist(vehicle) then
								TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
								Citizen.CreateThread(function()
									Citizen.Wait(10000)

									SetVehicleDoorsLocked(vehicle, 1)
									SetVehicleDoorsLockedForAllPlayers(vehicle, false)
									ClearPedTasksImmediately(playerPed)

									ESX.ShowNotification("Benny's véhicule dévérouillé")
								end)
							else
								ESX.ShowNotification("Aucun véhicule à proximité")
							end
						end
                    end)
					RageUI.Button("Fourrière", nil, { RightLabel = "→" },true, function(h,a,s)
						if s then
							local vehicle = ESX.Game.GetVehicleInDirection()
							if not impound then
								impound = true
								impoundtask = ESX.SetTimeout(10000,function()
									ClearPedTasks(PlayerPedId())
									local ServerID = GetPlayerServerId(NetworkGetEntityOwner(veh))
                            		SneakyEvent("SneakyLife:Delete", VehToNet(veh), ServerID)
									ESX.ShowHelpNotification("Mise en fourrière ~g~réussi~s~.")
								end)
								ESX.ShowHelpNotification("Vous êtes en train de mettre en fourrière le ~b~véhicule~s~.")
								TaskStartScenarioInPlace(PlayerPedId(), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
							end
							Citizen.CreateThread(function()
								while impound do
									Citizen.Wait(1000)
									local coords = GetEntityCoords(PlayerPedId())
									local coords = GetEntityCoords(PlayerPedId())
									vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
									if not DoesEntityExist(vehicle) and impound then
										ESX.ShowHelpNotification("Mise en fourrière annulée.")
										ESX.ClearTimeout(impoundtask)
										ClearPedTasks(PlayerPedId())
										impound = false
										break
									end
								end
							end)
						end
                    end)
					RageUI.Button("Attribuer une facture", nil, {RightLabel = "→"}, true,function(h,a,s)
						if s then
							RageUI.CloseAll()
							TriggerEvent("sBill:CreateBill","society_mecano")
						end
					end)
                end)
				Wait(0)
			end
		end)
	end
end

RegisterNetEvent('mecano:targetAnnounce')
AddEventHandler('mecano:targetAnnounce', function(announce)
    if announce == 'ouvert' then
        ESX.ShowAdvancedNotification('Mécano', '~y~Informations', "- Mécano ~g~ouvert~s~~n~- Horaire : ~g~Maintenant", "CHAR_BENNYS", 1)
    elseif announce == 'fermeture' then
        ESX.ShowAdvancedNotification('Mécano', '~y~Informations', "- Mécano ~r~fermé~s~~n~- Horaire : ~g~Maintenant", "CHAR_BENNYS", 1)
    end
end)

function CheckServiceMecano()
	return onService
end