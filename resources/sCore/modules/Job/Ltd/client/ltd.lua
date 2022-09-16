ESX = nil
CreateThread(function()
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
    TriggerServerEvent("sLtd:requestLoad")
end)

RegisterNetEvent('Sneakyesx:playerLoaded')
AddEventHandler('Sneakyesx:playerLoaded', function(xPlayer)
     ESX.PlayerData = xPlayer
end)

RegisterNetEvent('Sneakyesx:setJob')
AddEventHandler('Sneakyesx:setJob', function(job)
     ESX.PlayerData.job = job
end)
local Tableped = {}
local ltdEntreprise = false
local onService = false

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
local callcooldown = false
local function openInteractions(ltdState, store)
    if ltdState == "yes" then
        local mainMenu = RageUI.CreateMenu("", "Limited ~r~LTD~s~ Gasoline", 0, 0,"shopui_title_gasstation","shopui_title_gasstation")
        
        RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

        local list = {
            Announce = {
                view = {
                    "Ouvert",
                    "Fermer"
                },
                index = 1
            },
        }

        FreezeEntityPosition(PlayerPedId(), true)

        while mainMenu do
            Wait(1)
            RageUI.IsVisible(mainMenu, true, false, true, function()                
                local player, distance = ESX.Game.GetClosestPlayer()  
                local playerjob = ESX.PlayerData.job.name
                RageUI.List("Annonce", list.Announce.view, list.Announce.index, nil, {}, true, function(h, a, s, i)
                    list.Announce.index = i
                    if s then
                        if i == 1 then
                            typeAnnounce = "open"
                        elseif i == 2 then
                            typeAnnounce = "close"
                        end
                        TriggerServerEvent("sLtd:sendAnnounce", typeAnnounce)
                        RageUI.CloseAll()
                    end
                end)

                RageUI.Button("Attribuer une facture", nil, {RightLabel = "→"}, true,function(h,a,s)
                    if s then
                        FreezeEntityPosition(PlayerPedId(), false)
                        RageUI.CloseAll()
                        TriggerEvent("sBill:CreateBill",playerjob)
                    end
                end)

                if not callcooldown then
                    RageUI.Button("Appeler la LSPD", nil, {RightLabel = "→"}, onService and not callcooldown , function(h, a, s)
                        if s then
                            callcooldown = true
                            local pos = GetEntityCoords(PlayerPedId())
                            SneakyEvent("sPolice:enterAppel", pos.x, pos.y, pos.z, "Braquage", "Notre LTD se fait actuellement braquer !")
                            Citizen.SetTimeout(60000, function()
                                callcooldown = false
                            end)
                        end
                    end)
                else
                    RageUI.Button("Appeler la LSPD", nil, {RightBadge = RageUI.BadgeStyle.Lock}, onService and not callcooldown , function()
                    end)
                end
            end)
            
            if not RageUI.Visible(mainMenu) then
                mainMenu = RMenu:DeleteType("menu", true)
            end
        end

        FreezeEntityPosition(PlayerPedId(), false) 
    elseif ltdState == "no" then
        local mainMenu = RageUI.CreateMenu("", "Limited ~r~LTD~s~ Gasoline", 0, 0,"shopui_title_gasstation","shopui_title_gasstation")
        
        RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

        FreezeEntityPosition(PlayerPedId(), true)

        while mainMenu do
            Wait(1)
            RageUI.IsVisible(mainMenu, true, false, true, function()
                for k,v in pairs(store.ltdItems) do
                    RageUI.Button(v.label, nil, {RightLabel = "Prix : "..v.price.."~g~$~s~ →"}, true, function(h, a, s)
                        if s then
                            TriggerServerEvent("sLtd:buyItem", v.name)
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
end

CreateThread(function()
    for k,v in pairs(ConfigLtd) do
        local blip = AddBlipForCoord(v.blip.pos)
        SetBlipSprite(blip, v.blip.sprite)
        SetBlipScale(blip, 0.5)
        SetBlipColour(blip, v.blip.color)
        SetBlipAsShortRange(blip, true)
        SetBlipCategory(blip, 8)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.label)
        EndTextCommandSetBlipName(blip)
    end

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
        
        for k,v in pairs(ConfigLtd) do
            if ESX.PlayerData.job.name == v.job then
                if #(myCoords-v.positions.service) < 1.0 then
                    waiting = 1 
                    if onService then label = "~r~arrêter~s~" else label = "~g~démarrer~s~" end
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour "..label.." son service.")
                    if IsControlJustReleased(0, 54) then
                        onService = not onService
                        TriggerServerEvent("sLtd:StateService")
                    end
                end
            end
        end
        if onService then
            if ESX.PlayerData.job.name == "ltd_nord" then
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 1699.8234863281,4927.2905273438,42.063682556152, true) > 50.0 then
                    onService = not onService
                    TriggerServerEvent("sLtd:StateService")
                end
            end
        end

        if onService then
            if ESX.PlayerData.job.name == "ltd_sud" then
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), -707.52587890625,-914.47375488281,19.215599060059, true) > 50.0 then
                    onService = not onService
                    TriggerServerEvent("sLtd:StateService")
                end
            end
        end

        if ltdEntreprise then
            for k,v in pairs(ConfigLtd) do
                if onService and ESX.PlayerData.job.name == v.job then
                    if #(myCoords-v.positions.interactionsPos.online) < 1.0 then
                        waiting = 1
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour acceder au ~b~intéractions du LTD~s~.")
                        if IsControlJustReleased(0, 54) then
                            openInteractions("yes", v)
                        end
                    end
                end
            end
        else
            for k,v in pairs(ConfigLtd) do
                if #(myCoords-v.positions.interactionsPos.offline) < 1.0 then
                    waiting = 1
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour acceder au ~b~LTD~s~.")
                    if IsControlJustReleased(0, 54) then
                        openInteractions("no", v)
                    end
                end
            end
        end

        Wait(waiting)
    end
end)

function _CreatePed(hash, coords, heading)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(5)
    end

    local ped = CreatePed(4, hash, coords, false, false)
    SetEntityHeading(ped, heading)
    SetEntityAsMissionEntity(ped, true, true)
    SetPedHearingRange(ped, 0.0)
    SetPedSeeingRange(ped, 0.0)
    SetPedAlertness(ped, 0.0)
    SetPedFleeAttributes(ped, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCombatAttributes(ped, 46, true)
    SetPedFleeAttributes(ped, 0, 0)
    return ped
end

Citizen.CreateThread(function()
    while true do
        if ltdEntreprise then
            for k,v in pairs(Tableped) do
                if DoesEntityExist(v) then
                    DeleteEntity(v)
                end
            end
            Tableped = {}
            Wait(5000)
        else
            for k,v in pairs(Tableped) do
                if DoesEntityExist(v) then
                    DeleteEntity(v)
                end
            end
            Tableped = {}
            local ped = _CreatePed("a_m_o_ktown_01",vector3(-705.90350341797,-914.31616210938,18.215591430664),86.53)
            local pednord = _CreatePed("a_m_m_afriamer_01",vector3(1697.1027832031,4923.1865234375,41.063678741455),328.35)
            table.insert(Tableped, ped)
            table.insert(Tableped, pednord)
            Wait(1000*60*10)
        end
    end
end)

AddEventHandler("onResourceStop", function(name)
    if name == "sCore" then
        for k,v in pairs(Tableped) do
			if DoesEntityExist(v) then
				DeleteEntity(v)
			end
		end
        Tableped = {}
    end
end)

RegisterNetEvent("sLtd:updateState")
AddEventHandler("sLtd:updateState", function(state)
    ltdEntreprise = state
end)

local garageltd_sud = {

	garageltd_sud = {
        vehs = {
            {label = "Speedo Ltd Sud", veh = "nspeedo", stock = 4},
        },
        pos  = {
            {pos = vector3(-730.33166503906,-910.02587890625,18.817956924438), heading = 179.68},
        },
    },
}

local LtdSudPos = {
	PositionGarage = {
        {coords = vector3(-727.89630126953,-908.06689453125,19.013914108276-0.9)},
    },
	PositionDeleteGarage = {
        {coords = vector3(-730.32666015625,-910.02752685547,18.820550918579-0.9)},
    },
}

GarageLtdSud = {}
RMenu.Add('garageltd_sud', 'main', RageUI.CreateMenu("", "",nil,nil,"shopui_title_gasstation","shopui_title_gasstation"))
RMenu:Get('garageltd_sud', 'main'):SetSubtitle("Limited ~r~LTD~s~ Gasoline")
RMenu:Get('garageltd_sud', 'main').EnableMouse = false
RMenu:Get('garageltd_sud', 'main').Closed = function()
    GarageLtdSud.Menu = false
end

function OpenGarageLtdSudRageUIMenu()

    if GarageLtdSud.Menu then
        GarageLtdSud.Menu = false
    else
        GarageLtdSud.Menu = true
        RageUI.Visible(RMenu:Get('garageltd_sud', 'main'), true)

        Citizen.CreateThread(function()
            while GarageLtdSud.Menu do
                RageUI.IsVisible(RMenu:Get('garageltd_sud', 'main'), true, false, true, function()
                    RageUI.Separator("~r~↓~s~ Véhicule de service ~r~↓~s~")
                    for k,v in pairs(garageltd_sud.garageltd_sud.vehs) do
                        RageUI.Button(v.label, nil, {RightLabel = "Stock: (~b~"..v.stock.."~s~)"}, v.stock > 0, function(h,a,s)
                            if s then
                                local pos = FoundClearSpawnPoint(garageltd_sud.garageltd_sud.pos)
                                if pos ~= false then
                                    LoadModel(v.veh)
                                    local veh = CreateVehicle(GetHashKey(v.veh), pos.pos, pos.heading, true, false)
                                    SetVehicleLivery(veh, 16)
                                    local chance = math.random(1,2)
                                    if chance == 1 then
                                        SetVehicleColours(veh,1,1)
                                    else
                                        SetVehicleColours(veh,1,1)
                                    end
                                    SetEntityAsMissionEntity(veh, 1, 1)
                                    SetVehicleDirtLevel(veh, 0.0)
                                    ShowLoadingMessageLtdSud("Véhicule de service sortie.", 2, 2000)
                                    SneakyEvent('Sneakyesx_vehiclelock:givekey', 'no', GetVehicleNumberPlateText(veh))
                                    TriggerEvent('persistent-vehicles/register-vehicle', veh)
                                    garageltd_sud.garageltd_sud.vehs[k].stock = garageltd_sud.garageltd_sud.vehs[k].stock - 1
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

function ShowLoadingMessageLtdSud(text, spinnerType, timeMs)
	Citizen.CreateThread(function()
		BeginTextCommandBusyspinnerOn("STRING")
		AddTextComponentSubstringPlayerName(text)
		EndTextCommandBusyspinnerOn(spinnerType)
		Wait(timeMs)
		RemoveLoadingPrompt()
	end)
end

function DelVehLtdSud()
	local pPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(pPed, false) then
		local pVeh = GetVehiclePedIsIn(pPed, false)
		local model = GetEntityModel(pVeh)
		Citizen.CreateThread(function()
			ShowLoadingMessageLtdSud("Rangement du véhicule ...", 1, 2500)
		end)
		local vehicle = GetVehiclePedIsIn(PlayerPedId(),  false)
        local plate = GetVehicleNumberPlateText(vehicle)
        SneakyEvent('Sneakyesx_vehiclelock:deletekeyjobs', 'no', plate)
		TaskLeaveAnyVehicle(pPed, 1, 1)
		Wait(2500)
		while IsPedInAnyVehicle(pPed, false) do
			TaskLeaveAnyVehicle(pPed, 1, 1)
			ShowLoadingMessageLtdSud("Rangement du véhicule ...", 1, 300)
			Wait(200)
		end
        TriggerEvent('persistent-vehicles/forget-vehicle', pVeh)
	    DeleteEntity(pVeh)
		for k,v in pairs(garageltd_sud.garageltd_sud.vehs) do
			if model == GetHashKey(v.veh) then
				garageltd_sud.garageltd_sud.vehs[k].stock = garageltd_sud.garageltd_sud.vehs[k].stock + 1
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
        for k,v in pairs(LtdSudPos.PositionGarage) do
            local mPos = #(v.coords-pCoords)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ltd_sud' then
                if not GarageLtdSud.Menu then
                    if mPos <= 10.0 then
                        att = 1
                        
                        if mPos <= 1.5 then
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au ~b~garage~s~.")
                            if IsControlJustPressed(0, 51) then
                                if onService then
                                    OpenGarageLtdSudRageUIMenu()
                                else
                                    ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
                                end
                            end
                        end
                    end
                end
            end
        end
		for k,v in pairs(LtdSudPos.PositionDeleteGarage) do
            local mPos = #(v.coords-pCoords)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ltd_sud' then
                if not GarageLtdSud.Menu then
                    if IsPedInAnyVehicle(PlayerPedId(), true) then
                        if mPos <= 10.0 then
                            att = 1
                            if mPos <= 3.5 then
                                DrawMarker(20, v.coords.x, v.coords.y, v.coords.z+0.9, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255, 0, 0, 255, 55555, false, true, 2, false, false, false, false)
                                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule de service.")
                                if IsControlJustPressed(0, 51) then
                                    if onService then
                                        DelVehLtdSud()
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

