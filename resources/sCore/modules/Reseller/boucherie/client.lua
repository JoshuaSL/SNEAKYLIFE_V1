local config = {
    label = "Boucherie",
    color = "~r~",
    dict = "root_cause",
    banner = "boucherie",
    ped = {pos = vector3(961.6025390625,-2111.5151367188,30.948392868042), heading = 94.76, model = "s_m_y_factory_01"},
    menu = {pos = vector3(961.33172607422,-2111.466796875,31.948392868042), message = "Appuyez sur ~INPUT_CONTEXT~ pour ~b~ouvrir le menu~s~."},
    items = {
        {
            itemReseller = "viande_1",
            itemSeller = "morviande_1",
            label = "Viande Blanche",
            priceSeller = 10,
            priceReseller = 36,
        },
        {
            itemReseller = "viande_2",
            itemSeller = "morviande_2",
            label = "Viande Rouge",
            priceSeller = 12,
            priceReseller = 30
        }
    },
}

ESX = nil

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
end)

RegisterNetEvent('Sneakyesx:playerLoaded')
AddEventHandler('Sneakyesx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('Sneakyesx:setJob')
AddEventHandler('Sneakyesx:setJob', function(job)
    ESX.PlayerData.job = job
end)

local function BoucherieInput(TextEntry, ExampleText, MaxStringLength)
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

local function openMenu()
    local mainMenu = RageUI.CreateMenu("", config.color..config.label.."~s~ : Achat & Vente", 80, 90, config.dict, config.banner)
    local resellerMenu = RageUI.CreateSubMenu(mainMenu, "", config.color..config.label.."~s~ : Vente", 80, 90, config.dict, config.banner)
    local sellerMenu = RageUI.CreateSubMenu(mainMenu, "", config.color..config.label.."~s~ : Achat", 80, 90, config.dict, config.banner)

    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

    FreezeEntityPosition(PlayerPedId(), true)

    while mainMenu do
        Wait(1)

        RageUI.IsVisible(mainMenu, true, true, true, function()
            if ESX.PlayerData.job.grade_name == "boss" then
                RageUI.Button("Achat", nil, {RightLabel = "→"}, true, function(h, a, s)
                end, sellerMenu)
            else
                RageUI.Button("Achat", nil, {RightBadge = RageUI.BadgeStyle.Lock}, false, function(h, a, s)
                end, sellerMenu)
            end

            RageUI.Button("Vente", nil, {RightLabel = "→"}, true, function(h, a, s)

            end, resellerMenu)
        end)

        RageUI.IsVisible(resellerMenu, true, true, true, function()
            for k,v in pairs(config.items) do
                RageUI.Button("Vendre de la "..config.color..""..v.label, nil, {RightLabel = v.priceReseller.."~g~$~s~"}, true, function(h, a, s)
                    if s then
                        local count = tonumber(BoucherieInput("Veuillez saisir une "..config.color.."quantité~s~ :", "", 3))
                        if count == "" or count == nil then return ESX.ShowNotification("~r~Erreur~s~~n~Cette quantité est invalide !") end
                        TriggerServerEvent("sBoucherie:sellItem", v.itemReseller, count)
                    end
                end)
            end
        end)

        RageUI.IsVisible(sellerMenu, true, true, true, function()
            for k,v in pairs(config.items) do
                RageUI.Button("Acheter des morceau de "..config.color..""..v.label, nil, {RightLabel = v.priceSeller.."~g~$~s~"}, true, function(h, a, s)
                    if s then
                        local count = tonumber(BoucherieInput("Veuillez saisir une "..config.color.."quantité~s~ :", "", 3))
                        if count == "" or count == nil then return ESX.ShowNotification("~r~Erreur~s~~n~Cette quantité est invalide !") end
                        TriggerServerEvent("sBoucherie:buyItem", v.itemSeller, count)
                    end
                end)
            end
        end)

        if not RageUI.Visible(mainMenu) and not RageUI.Visible(resellerMenu) and not RageUI.Visible(sellerMenu) then
            mainMenu = RMenu:DeleteType("menu", true)
        end
    end

    FreezeEntityPosition(PlayerPedId(), false)
end 

CreateThread(function()
    local model = GetHashKey(config.ped.model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(1)
    end
    local ped = CreatePed(9, model, config.ped.pos, config.ped.heading, false, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)

    while true do
        local waiting = 250
        local pedCoords = GetEntityCoords(PlayerPedId())

        if #(pedCoords-config.menu.pos) < 1.0 then
            waiting = 1
            ESX.ShowHelpNotification(config.menu.message)
            if IsControlJustReleased(0, 54) then
                openMenu()
            end
        end

        Wait(waiting)
    end
end)