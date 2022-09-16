-- 
-- Created by Kadir#6400
-- 

ESX = nil

Citizen.CreateThread(function()
    getESX()
end)
SneakyEvent = TriggerServerEvent
local playerInService = false
local tomate, salade, steak, frite, burger  = false, false, false, false, false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("Sneakyesx:getSharedObject", function(niceESX) ESX = niceESX end)
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
        local myCoords = GetEntityCoords(PlayerPedId())
        local nofps = false

        if ESX.PlayerData.job.name == ConfigBurger.JobName then
            if #(myCoords-ConfigBurger.Pos.Service) < 1.0 then
                nofps = true
                if not playerInService then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour se ~g~mettre~s~ son service")
                else
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour se ~r~quitter~s~ son service")
                end
                if IsControlJustReleased(0, 38) then
                    ESX.TriggerServerCallback("sBurger:Service", function(service)
                        if service then
                            playerInService = false
                        else
                            playerInService = true
                        end
                    end)
                end
            elseif #(myCoords-ConfigBurger.Pos.Service) < 4.5 then
                nofps = true
                DrawMarker(22, ConfigBurger.Pos.Service, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 0, 0, 255, 155, true, true, p19, true)
            end
        end

        if nofps then
            Wait(1)
        else
            Wait(850)
        end
    end
end)

Citizen.CreateThread(function()
    getESX()
    while true do
        if not playerInService then
            Wait(1500)
        else
            local myCoords = GetEntityCoords(PlayerPedId())
            local servicefps = false

            if ESX.PlayerData.job.name == ConfigBurger.JobName then
                if not openedCaisseMenu then
                    for k,v in pairs(ConfigBurger.Pos.Actions) do
                        if #(myCoords-v.pos) < 1.0 then
                            servicefps = true
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour acceder à la caisse")
                            if IsControlJustReleased(0, 38) then
                                openCaisseMenu()
                            end
                        elseif #(myCoords-v.pos) < 4.5 then
                            servicefps = true
                            DrawMarker(22, v.pos, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 255, 162, 0, 150, true, true, p19, true)
                        end
                    end
                end
                if not tomate then
                    if #(myCoords-ConfigBurger.Pos.Tomates) < 1.0 then
                        servicefps = true
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour couper les tomates")
                        if IsControlJustReleased(0, 38) then
                            ESX.TriggerServerCallback('Sneakyburgershot:getItemAmount', function(tomatoes)
                                if tomatoes > 0 then
                                    tomate = true
                                    FreezeEntityPosition(PlayerPedId(), true)
                                    PlayAnim("anim@amb@business@cfm@cfm_cut_sheets@", "cut_guilotine_v1_billcutter", 10000)
                                    Wait(10000)
                                    FreezeEntityPosition(PlayerPedId(), false)
                                    ClearPedTasks(PlayerPedId())
                                    SneakyEvent("Burgershot:Removeitem","tomate",1,"tomate_coupe",1)
                                else
                                    tomate = false
                                    salade = false
                                    steak = false
                                    frite = false
                                    burger = false
                                    ESX.ShowNotification("~r~Erreur~s~\nVous n'avez pas de tomate sur vous")
                                end
                            end, 'tomate')
                        end
                    elseif #(myCoords-ConfigBurger.Pos.Tomates) < 4.5 then
                        servicefps = true
                        DrawMarker(22, ConfigBurger.Pos.Tomates, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 255, 113, 113, 150, true, true, p19, true)
                    end
                end
                if not salade then
                    if #(myCoords-ConfigBurger.Pos.Salade) < 1.0 then
                        servicefps = true
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour couper la salade")
                        if IsControlJustReleased(0, 38) then
                            ESX.TriggerServerCallback('Sneakyburgershot:getItemAmount', function(salade)
                                if salade > 0 then
                                    salade = true
                                    FreezeEntityPosition(PlayerPedId(), true)
                                    PlayAnim("anim@amb@business@cfm@cfm_cut_sheets@", "cut_guilotine_v1_billcutter", 10000)
                                    Wait(10000)
                                    FreezeEntityPosition(PlayerPedId(), false)
                                    ClearPedTasks(PlayerPedId())
                                    SneakyEvent("Burgershot:Removeitem","salade",1,"salade_fraiche",1)
                                else
                                    tomate = false
                                    salade = false
                                    steak = false
                                    frite = false
                                    burger = false
                                    ESX.ShowNotification("~r~Erreur~s~\nVous n'avez pas de salade sur vous")
                                end
                            end, 'salade')
                        end
                    elseif #(myCoords-ConfigBurger.Pos.Salade) < 4.5 then
                        servicefps = true
                        DrawMarker(22, ConfigBurger.Pos.Salade, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 150, 255, 156, 150, true, true, p19, true)
                    end
                end
                if not frite then
                    if #(myCoords-ConfigBurger.Pos.Frites) < 1.0 then
                        servicefps = true
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour faire cuire les frites")
                        if IsControlJustReleased(0, 38) then
                            ESX.TriggerServerCallback('Sneakyburgershot:getItemAmount', function(frites)
                                if frites > 0 then
                                    frite = true
                                    FreezeEntityPosition(PlayerPedId(), true)
                                    PlayAnim("anim@amb@business@coc@coc_unpack_cut@", "fullcut_cycle_cokecutter", 10000)
                                    Wait(10000)
                                    FreezeEntityPosition(PlayerPedId(), false)
                                    ClearPedTasks(PlayerPedId())
                                    SneakyEvent("Burgershot:Removeitem","frites",1,"frites_chauffe",1)
                                else
                                    tomate = false
                                    salade = false
                                    steak = false
                                    frite = false
                                    burger = false
                                    ESX.ShowNotification("~r~Erreur~s~\nVous n'avez pas de frites sur vous")
                                end
                            end, 'frites')
                        end
                    elseif #(myCoords-ConfigBurger.Pos.Frites) < 4.5 then
                        servicefps = true
                        DrawMarker(22, ConfigBurger.Pos.Frites, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 238, 255, 113, 150, true, true, p19, true)
                    end
                end
                if #(myCoords-ConfigBurger.Pos.Steak) < 1.0 then
                    servicefps = true
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour faire cuire les steaks")
                    if IsControlJustReleased(0, 38) then
                        ESX.TriggerServerCallback('Sneakyburgershot:getItemAmount', function(steaks)
                            if steaks > 0 then
                                steak = true
                                FreezeEntityPosition(PlayerPedId(), true)
                                TaskStartScenarioInPlace(GetPlayerPed(-1),"PROP_HUMAN_BBQ", 0, true)
                                Wait(10000)
                                FreezeEntityPosition(PlayerPedId(), false)
                                ClearPedTasks(PlayerPedId())
                                SneakyEvent("Burgershot:Removeitem","morviande_2",1,"steaks_cuit",1)
                            else
                                tomate = false
                                salade = false
                                steak = false
                                frite = false
                                burger = false
                                ESX.ShowNotification("~r~Erreur~s~\nVous n'avez pas de viande rouge sur vous")
                            end
                        end, 'morviande_2')
                    end
                elseif #(myCoords-ConfigBurger.Pos.Steak) < 4.5 then
                    servicefps = true
                    DrawMarker(22, ConfigBurger.Pos.Steak, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 135, 90, 60, 150, true, true, p19, true)
                end
                if #(myCoords-ConfigBurger.Pos.Assemblement) < 1.0 then
                    servicefps = true
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour assembler le burger")
                    if IsControlJustReleased(0, 38) then
                        ESX.TriggerServerCallback('Sneakyburgershot:getItemAmount', function(bread)
                            if bread > 0 then
                                burger = true
                                ESX.TriggerServerCallback('Sneakyburgershot:getItemAmount', function(salade)
                                    if salade > 0 then
                                        salade = true
                                        ESX.TriggerServerCallback('Sneakyburgershot:getItemAmount', function(steaks)
                                            if steaks > 0 then
                                                steaks = true
                                                ESX.TriggerServerCallback('Sneakyburgershot:getItemAmount', function(tomate)
                                                    if tomate > 0 then
                                                        FreezeEntityPosition(PlayerPedId(), true)
                                                        PlayAnim("anim@amb@business@coc@coc_unpack_cut@", "fullcut_cycle_cokecutter", 10000)
                                                        Wait(10000)
                                                        FreezeEntityPosition(PlayerPedId(), false)
                                                        ClearPedTasks(PlayerPedId())
                                                        SneakyEvent("Burgershot:Removeitem","salade_fraiche",1,"tomate_coupe",0)
                                                        SneakyEvent("Burgershot:Removeitem","tomate_coupe",1,"tomate_coupe",0)
                                                        SneakyEvent("Burgershot:Removeitem","steaks_cuit",1,"tomate_coupe",0)
                                                        SneakyEvent("Burgershot:Removeitem","bread",1,"burger",1)
                                                    else
                                                        tomate = false
                                                        salade = false
                                                        steak = false
                                                        frite = false
                                                        burger = false
                                                        ESX.ShowNotification("~r~Erreur~s~\nVous n'avez pas de tomate sur vous")
                                                    end
                                                end,"tomate_coupe")
                                            else
                                                tomate = false
                                                salade = false
                                                steak = false
                                                frite = false
                                                burger = false
                                                ESX.ShowNotification("~r~Erreur~s~\nVous n'avez pas de steak cuit sur vous")
                                            end
                                        end,"steaks_cuit")
                                    else
                                        tomate = false
                                        salade = false
                                        steak = false
                                        frite = false
                                        burger = false
                                        ESX.ShowNotification("~r~Erreur~s~\nVous n'avez pas de salade sur vous")
                                    end
                                end,"salade_fraiche")
                            else
                                tomate = false
                                salade = false
                                steak = false
                                frite = false
                                burger = false
                                ESX.ShowNotification("~r~Erreur~s~\nVous n'avez pas de pain sur vous")
                            end
                        end, 'bread')
                    end
                elseif #(myCoords-ConfigBurger.Pos.Assemblement) < 4.5 then
                    servicefps = true
                    DrawMarker(22, ConfigBurger.Pos.Assemblement, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 121, 216, 237, 150, true, true, p19, true)
                end
            end

            if servicefps then
                Wait(1)
            else
                Wait(850)
            end
        end
    end
end)

local garageburgershot = {

	garageburgershot = {
        vehs = {
            {label = "Speedo Burger", veh = "nspeedo", stock = 4},
        },
        pos  = {
            {pos = vector3(-1163.8919677734,-891.38024902344,13.901926040649), heading = 121.84},
            {pos = vector3(-1165.8779296875,-888.15863037109,13.900117874146), heading = 121.10},
        },
    },
}

local Burger = {
	PositionGarage = {
        {coords = vector3(-1177.5404052734,-891.16857910156,13.78200340271-0.9)},
    },
	PositionDeleteGarage = {
        {coords = vector3(-1173.2668457031,-888.88031005859,13.923447608948-0.9)},
    },
}

GarageBurger = {}
RMenu.Add('garageburgershot', 'main', RageUI.CreateMenu("", "",nil,nil,"root_cause","burgershot"))
RMenu:Get('garageburgershot', 'main'):SetSubtitle("~c~Burger~s~")
RMenu:Get('garageburgershot', 'main').EnableMouse = false
RMenu:Get('garageburgershot', 'main').Closed = function()
    GarageBurger.Menu = false
end

function OpenGarageBurgerRageUIMenu()

    if GarageBurger.Menu then
        GarageBurger.Menu = false
    else
        GarageBurger.Menu = true
        RageUI.Visible(RMenu:Get('garageburgershot', 'main'), true)

        Citizen.CreateThread(function()
            while GarageBurger.Menu do
                RageUI.IsVisible(RMenu:Get('garageburgershot', 'main'), true, false, true, function()
                    RageUI.Separator("~r~↓~s~ Véhicule de service ~r~↓~s~")
                    for k,v in pairs(garageburgershot.garageburgershot.vehs) do
                        RageUI.Button(v.label, nil, {RightLabel = "Stock: [~b~"..v.stock.."~s~]"}, v.stock > 0, function(h,a,s)
                            if s then
                                local pos = FoundClearSpawnPoint(garageburgershot.garageburgershot.pos)
                                if pos ~= false then
                                    LoadModel(v.veh)
                                    local veh = CreateVehicle(GetHashKey(v.veh), pos.pos, pos.heading, true, false)
                                    SetVehicleLivery(veh, 12)
                                    local chance = math.random(1,2)
                                    if chance == 1 then
                                        SetVehicleColours(veh,111,111)
                                    else
                                        SetVehicleColours(veh,29,29)
                                    end
                                    SetEntityAsMissionEntity(veh, 1, 1)
                                    SetVehicleDirtLevel(veh, 0.0)
                                    ShowLoadingMessageBurger("Véhicule de service sortie.", 2, 2000)
                                    SneakyEvent('Sneakyesx_vehiclelock:givekey', 'no', GetVehicleNumberPlateText(veh))
                                    TriggerEvent('persistent-vehicles/register-vehicle', veh)
                                    garageburgershot.garageburgershot.vehs[k].stock = garageburgershot.garageburgershot.vehs[k].stock - 1
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

function ShowLoadingMessageBurger(text, spinnerType, timeMs)
	Citizen.CreateThread(function()
		BeginTextCommandBusyspinnerOn("STRING")
		AddTextComponentSubstringPlayerName(text)
		EndTextCommandBusyspinnerOn(spinnerType)
		Wait(timeMs)
		RemoveLoadingPrompt()
	end)
end

function DelVehBurger()
	local pPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(pPed, false) then
		local pVeh = GetVehiclePedIsIn(pPed, false)
		local model = GetEntityModel(pVeh)
		Citizen.CreateThread(function()
			ShowLoadingMessageBurger("Rangement du véhicule ...", 1, 2500)
		end)
		local vehicle = GetVehiclePedIsIn(PlayerPedId(),  false)
        local plate = GetVehicleNumberPlateText(vehicle)
        SneakyEvent('Sneakyesx_vehiclelock:deletekeyjobs', 'no', plate)
		TaskLeaveAnyVehicle(pPed, 1, 1)
		Wait(2500)
		while IsPedInAnyVehicle(pPed, false) do
			TaskLeaveAnyVehicle(pPed, 1, 1)
			ShowLoadingMessageBurger("Rangement du véhicule ...", 1, 300)
			Wait(200)
		end
        TriggerEvent('persistent-vehicles/forget-vehicle', pVeh)
	    DeleteEntity(pVeh)
		for k,v in pairs(garageburgershot.garageburgershot.vehs) do
			if model == GetHashKey(v.veh) then
				garageburgershot.garageburgershot.vehs[k].stock = garageburgershot.garageburgershot.vehs[k].stock + 1
			end
		end
	else
		ShowNotification("Vous devez être dans un véhicule.")
	end
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while true do
        att = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs(Burger.PositionGarage) do
            local mPos = #(v.coords-pCoords)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'burgershot' then
                if not GarageBurger.Menu then
                    if mPos <= 10.0 then
                        att = 1
                        
                        if mPos <= 1.5 then
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au Garage")
                            if IsControlJustPressed(0, 51) then
                                OpenGarageBurgerRageUIMenu()
                            end
                        end
                    end
                end
            end
        end
		for k,v in pairs(Burger.PositionDeleteGarage) do
            local mPos = #(v.coords-pCoords)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'burgershot' then
                if not GarageBurger.Menu then
                    if IsPedInAnyVehicle(PlayerPedId(), true) then
                        if mPos <= 10.0 then
                            att = 1
                            if mPos <= 3.5 then
                                DrawMarker(20, v.coords.x, v.coords.y, v.coords.z+0.9, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255, 0, 0, 255, 55555, false, true, 2, false, false, false, false)
                                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule de service")
                                if IsControlJustPressed(0, 51) then
                                    DelVehBurger()
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

function CheckServiceBurger()
    return playerInService
end

function OpenBurgerActionMenuRageUIMenu()
    local mainMenu = RageUI.CreateMenu("", "~r~BurgerShot~s~", 0, 0,"root_cause","burgershot")

    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

    while mainMenu do
       Wait(1)
       RageUI.IsVisible(mainMenu, true, true, false, function()
            RageUI.Button("Attribuer une facture", nil, {RightLabel = "→"}, true,function(h,a,s)
                if s then
                    RageUI.CloseAll()
                    TriggerEvent("sBill:CreateBill","society_burger")
                end
            end)
       end)

       if not RageUI.Visible(mainMenu) then
           mainMenu = RMenu:DeleteType("menu", true)
       end
    end
end