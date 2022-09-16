ESX = nil

local playerInService = false
local tomate, steak, pate, pizza  = false, false, false, false
SneakyEvent = TriggerServerEvent
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
    while true do
        local myCoords = GetEntityCoords(PlayerPedId())
        local nofps = false

        if ESX.PlayerData.job.name == ConfigPizza.JobName then
            if #(myCoords-ConfigPizza.Pos.Service) < 1.0 then
                nofps = true
                if not playerInService then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour se ~g~mettre~s~ son service")
                else
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour se ~r~quitter~s~ son service")
                end
                if IsControlJustReleased(0, 38) then
                    ESX.TriggerServerCallback("sPizza:Service", function(service)
                        if service then
                            playerInService = false
                        else
                            playerInService = true
                        end
                    end)
                end
            elseif #(myCoords-ConfigPizza.Pos.Service) < 4.5 then
                nofps = true
                DrawMarker(22, ConfigPizza.Pos.Service, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 0, 0, 255, 155, true, true, p19, true)
            end
        end

        if nofps then
            Wait(1)
        else
            Wait(850)
        end
    end
end)

function CheckServicePizza()
    return playerInService
end

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
    while true do
        if not playerInService then
            Wait(1500)
        else
            local myCoords = GetEntityCoords(PlayerPedId())
            local servicefps = false

            if ESX.PlayerData.job.name == ConfigPizza.JobName then
                if not openedCaisseMenu then
                    for k,v in pairs(ConfigPizza.Pos.Actions) do
                        if #(myCoords-v.pos) < 1.0 then
                            servicefps = true
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour acceder à la caisse")
                            if IsControlJustReleased(0, 38) then
                                openCaisseMenuPizza()
                            end
                        elseif #(myCoords-v.pos) < 4.5 then
                            servicefps = true
                            DrawMarker(22, v.pos, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 255, 162, 0, 150, true, true, p19, true)
                        end
                    end
                end
                if not tomate then
                    if #(myCoords-ConfigPizza.Pos.Tomates) < 1.0 then
                        servicefps = true
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour couper les tomates")
                        if IsControlJustReleased(0, 38) then
                            ESX.TriggerServerCallback('Sneakypizza:getItemAmount', function(tomatoes)
                                if tomatoes > 0 then
                                    tomate = true
                                    FreezeEntityPosition(PlayerPedId(), true)
                                    PlayAnim("anim@amb@business@cfm@cfm_cut_sheets@", "cut_guilotine_v1_billcutter", 10000)
                                    Wait(10000)
                                    FreezeEntityPosition(PlayerPedId(), false)
                                    ClearPedTasks(PlayerPedId())
                                    SneakyEvent("Pizza:Removeitem","tomate",1,"tomate_coupe",1)
                                else
                                    tomate = false
                                    steak = false
                                    pate = false
                                    pizza = false
                                    ESX.ShowNotification("~r~Erreur~s~\nVous n'avez pas de tomate sur vous")
                                end
                            end, 'tomate')
                        end
                    elseif #(myCoords-ConfigPizza.Pos.Tomates) < 4.5 then
                        servicefps = true
                        DrawMarker(22, ConfigPizza.Pos.Tomates, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 255, 113, 113, 150, true, true, p19, true)
                    end
                end
                if not pate then
                    if #(myCoords-ConfigPizza.Pos.Pates) < 1.0 then
                        servicefps = true
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour faire cuire les pates")
                        if IsControlJustReleased(0, 38) then
                            ESX.TriggerServerCallback('Sneakypizza:getItemAmount', function(pate)
                                if pate > 0 then
                                    pate = true
                                    FreezeEntityPosition(PlayerPedId(), true)
                                    PlayAnim("anim@amb@business@coc@coc_unpack_cut@", "fullcut_cycle_cokecutter", 10000)
                                    Wait(10000)
                                    FreezeEntityPosition(PlayerPedId(), false)
                                    ClearPedTasks(PlayerPedId())
                                    SneakyEvent("Pizza:Removeitem","pate",1,"spaghetti_bolognaise",1)
                                else
                                    tomate = false
                                    steak = false
                                    pate = false
                                    pizza = false
                                    ESX.ShowNotification("~r~Erreur~s~\nVous n'avez pas de pate fraîche sur vous")
                                end
                            end, 'pate')
                        end
                    elseif #(myCoords-ConfigPizza.Pos.Pates) < 4.5 then
                        servicefps = true
                        DrawMarker(22, ConfigPizza.Pos.Pates, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 238, 255, 113, 150, true, true, p19, true)
                    end
                end
                if #(myCoords-ConfigPizza.Pos.Steak) < 1.0 then
                    servicefps = true
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour faire cuire la viande")
                    if IsControlJustReleased(0, 38) then
                        ESX.TriggerServerCallback('Sneakypizza:getItemAmount', function(steaks)
                            if steaks > 0 then
                                steak = true
                                FreezeEntityPosition(PlayerPedId(), true)
                                TaskStartScenarioInPlace(GetPlayerPed(-1),"PROP_HUMAN_BBQ", 0, true)
                                Wait(10000)
                                FreezeEntityPosition(PlayerPedId(), false)
                                ClearPedTasks(PlayerPedId())
                                SneakyEvent("Pizza:Removeitem","morviande_2",1,"steaks_cuit",1)
                            else
                                tomate = false
                                steak = false
                                pate = false
                                pizza = false
                                ESX.ShowNotification("~r~Erreur~s~\nVous n'avez pas de viande rouge sur vous")
                            end
                        end, 'morviande_2')
                    end
                elseif #(myCoords-ConfigPizza.Pos.Steak) < 4.5 then
                    servicefps = true
                    DrawMarker(22, ConfigPizza.Pos.Steak, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 135, 90, 60, 150, true, true, p19, true)
                end
                if #(myCoords-ConfigPizza.Pos.Assemblement) < 1.0 then
                    servicefps = true
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour assembler la pizza")
                    if IsControlJustReleased(0, 38) then
                        ESX.TriggerServerCallback('Sneakypizza:getItemAmount', function(bread)
                            if bread > 0 then
                                pizza = true
                                ESX.TriggerServerCallback('Sneakypizza:getItemAmount', function(steaks)
                                    if steaks > 0 then
                                        steaks = true
                                        ESX.TriggerServerCallback('Sneakypizza:getItemAmount', function(tomate)
                                            if tomate > 0 then
                                                FreezeEntityPosition(PlayerPedId(), true)
                                                PlayAnim("anim@amb@business@coc@coc_unpack_cut@", "fullcut_cycle_cokecutter", 10000)
                                                Wait(10000)
                                                FreezeEntityPosition(PlayerPedId(), false)
                                                ClearPedTasks(PlayerPedId())
                                                SneakyEvent("Pizza:Removeitem","tomate_coupe",1,"tomate_coupe",0)
                                                SneakyEvent("Pizza:Removeitem","steaks_cuit",1,"tomate_coupe",0)
                                                SneakyEvent("Pizza:Removeitem","bread",1,"pizza",1)
                                            else
                                                tomate = false
                                                steak = false
                                                pate = false
                                                pizza = false
                                                ESX.ShowNotification("~r~Erreur~s~\nVous n'avez pas de tomate sur vous")
                                            end
                                        end,"tomate_coupe")
                                    else
                                        tomate = false
                                        steak = false
                                        pate = false
                                        pizza = false
                                        ESX.ShowNotification("~r~Erreur~s~\nVous n'avez pas de steak cuit sur vous")
                                    end
                                end,"steaks_cuit")
                            else
                                tomate = false
                                steak = false
                                pate = false
                                pizza = false
                                ESX.ShowNotification("~r~Erreur~s~\nVous n'avez pas de pain sur vous")
                            end
                        end, 'bread')
                    end
                elseif #(myCoords-ConfigPizza.Pos.Assemblement) < 4.5 then
                    servicefps = true
                    DrawMarker(22, ConfigPizza.Pos.Assemblement, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 121, 216, 237, 150, true, true, p19, true)
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

local garagepizza = {

	garagepizza = {
        vehs = {
            {label = "Speedo Pizza", veh = "nspeedo", stock = 4},
        },
        pos  = {
            {pos = vector3(292.74160766602,-958.01953125,29.124111175537), heading = 90.31},
        },
    },
}

local Pizza = {
	PositionGarage = {
        {coords = vector3(284.69171142578,-962.60491943359,29.418687820435-0.9)},
    },
	PositionDeleteGarage = {
        {coords = vector3(292.74160766602,-958.01953125,29.124111175537-0.9)},
    },
}

GaragePizza = {}
RMenu.Add('garagepizza', 'main', RageUI.CreateMenu("", "",nil,nil,"root_cause","shopui_title_pizzathis"))
RMenu:Get('garagepizza', 'main'):SetSubtitle("~g~Drusilla's~s~ Pizza~s~")
RMenu:Get('garagepizza', 'main').EnableMouse = false
RMenu:Get('garagepizza', 'main').Closed = function()
    GaragePizza.Menu = false
end

function OpenGaragePizzaRageUIMenu()

    if GaragePizza.Menu then
        GaragePizza.Menu = false
    else
        GaragePizza.Menu = true
        RageUI.Visible(RMenu:Get('garagepizza', 'main'), true)

        Citizen.CreateThread(function()
            while GaragePizza.Menu do
                RageUI.IsVisible(RMenu:Get('garagepizza', 'main'), true, false, true, function()
                    RageUI.Separator("~g~↓~s~ Véhicule de service ~g~↓~s~")
                    for k,v in pairs(garagepizza.garagepizza.vehs) do
                        RageUI.Button(v.label, nil, {RightLabel = "Stock: [~b~"..v.stock.."~s~]"}, v.stock > 0, function(h,a,s)
                            if s then
                                local pos = FoundClearSpawnPoint(garagepizza.garagepizza.pos)
                                if pos ~= false then
                                    LoadModel(v.veh)
                                    local veh = CreateVehicle(GetHashKey(v.veh), pos.pos, pos.heading, true, false)
                                    SetVehicleLivery(veh, 13)
                                    local chance = math.random(1,2)
                                    if chance == 1 then
                                        SetVehicleColours(veh,111,111)
                                    else
                                        SetVehicleColours(veh,52,52)
                                    end
                                    SetEntityAsMissionEntity(veh, 1, 1)
                                    SetVehicleDirtLevel(veh, 0.0)
                                    ShowLoadingMessagePizza("Véhicule de service sortie.", 2, 2000)
                                    SneakyEvent('Sneakyesx_vehiclelock:givekey', 'no', GetVehicleNumberPlateText(veh))
                                    TriggerEvent('persistent-vehicles/register-vehicle', veh)
                                    garagepizza.garagepizza.vehs[k].stock = garagepizza.garagepizza.vehs[k].stock - 1
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

function ShowLoadingMessagePizza(text, spinnerType, timeMs)
	Citizen.CreateThread(function()
		BeginTextCommandBusyspinnerOn("STRING")
		AddTextComponentSubstringPlayerName(text)
		EndTextCommandBusyspinnerOn(spinnerType)
		Wait(timeMs)
		RemoveLoadingPrompt()
	end)
end

function DelVehPizza()
	local pPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(pPed, false) then
		local pVeh = GetVehiclePedIsIn(pPed, false)
		local model = GetEntityModel(pVeh)
		Citizen.CreateThread(function()
			ShowLoadingMessagePizza("Rangement du véhicule ...", 1, 2500)
		end)
		local vehicle = GetVehiclePedIsIn(PlayerPedId(),  false)
        local plate = GetVehicleNumberPlateText(vehicle)
        SneakyEvent('Sneakyesx_vehiclelock:deletekeyjobs', 'no', plate)
		TaskLeaveAnyVehicle(pPed, 1, 1)
		Wait(2500)
		while IsPedInAnyVehicle(pPed, false) do
			TaskLeaveAnyVehicle(pPed, 1, 1)
			ShowLoadingMessagePizza("Rangement du véhicule ...", 1, 300)
			Wait(200)
		end
        TriggerEvent('persistent-vehicles/forget-vehicle', pVeh)
	    DeleteEntity(pVeh)
		for k,v in pairs(garagepizza.garagepizza.vehs) do
			if model == GetHashKey(v.veh) then
				garagepizza.garagepizza.vehs[k].stock = garagepizza.garagepizza.vehs[k].stock + 1
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
        for k,v in pairs(Pizza.PositionGarage) do
            local mPos = #(v.coords-pCoords)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'pizza' then
                if not GaragePizza.Menu then
                    if mPos <= 10.0 then
                        att = 1
                        
                        if mPos <= 1.5 then
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au Garage")
                            if IsControlJustPressed(0, 51) then
                                OpenGaragePizzaRageUIMenu()
                            end
                        end
                    end
                end
            end
        end
		for k,v in pairs(Pizza.PositionDeleteGarage) do
            local mPos = #(v.coords-pCoords)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'pizza' then
                if not GaragePizza.Menu then
                    if IsPedInAnyVehicle(PlayerPedId(), true) then
                        if mPos <= 10.0 then
                            att = 1
                            if mPos <= 3.5 then
                                DrawMarker(20, v.coords.x, v.coords.y, v.coords.z+0.9, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255, 0, 0, 255, 55555, false, true, 2, false, false, false, false)
                                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule de service")
                                if IsControlJustPressed(0, 51) then
                                    DelVehPizza()
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

function OpenPizzaActionMenuRageUIMenu()
    local mainMenu = RageUI.CreateMenu("", "~g~Drusilla's~s~ Pizza~s~", 0, 0,"root_cause","shopui_title_pizzathis")

    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

    while mainMenu do
       Wait(1)
       RageUI.IsVisible(mainMenu, true, true, false, function()
            RageUI.Button("Attribuer une facture", nil, {RightLabel = "→"}, true,function(h,a,s)
                if s then
                    RageUI.CloseAll()
                    TriggerEvent("sBill:CreateBill","society_pizza")
                end
            end)
       end)

       if not RageUI.Visible(mainMenu) then
           mainMenu = RMenu:DeleteType("menu", true)
       end
    end
end