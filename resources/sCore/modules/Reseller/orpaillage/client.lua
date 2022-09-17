local config = {
    label = "Fonderie",
    color = "~y~",
    dict = "root_cause",
    banner = "mine",
    ped = {pos = vector3(1074.6055908203,-2008.9940185547,32.084980010986-1.0), heading = 102.15, model = "s_m_y_construct_01"},
    menu = {pos = vector3(1073.7261962891,-2008.9866943359,32.084953308105), message = "Appuyez sur ~INPUT_CONTEXT~ pour vendre vos ~y~pépites d'or~s~."},
    items = {
        {
            itemReseller = "ors",
            label = "Pépites d'or",
            priceReseller = 30,
        }
    },
}

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
   end
   if ESX.IsPlayerLoaded() then
        ESX.PlayerData = ESX.GetPlayerData()
   end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

local function OrpaillageInput(TextEntry, ExampleText, MaxStringLength)
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
    local mainMenu = RageUI.CreateMenu("", config.color..config.label.."~s~ : Vente", 0, 0, config.dict, config.banner)
    local resellerMenu = RageUI.CreateSubMenu(mainMenu, "", config.color..config.label.."~s~ : Vente", 0, 0, config.dict, config.banner)

    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

    FreezeEntityPosition(PlayerPedId(), true)

    while mainMenu do
        Wait(1)

        RageUI.IsVisible(mainMenu, true, false, true, function()

            RageUI.Button("Vente", nil, {RightLabel = "→"}, true, function(h, a, s)

            end, resellerMenu)
        end)

        RageUI.IsVisible(resellerMenu, true, false, true, function()
            for k,v in pairs(config.items) do
                RageUI.Button("Vendre des "..config.color..""..v.label, nil, {RightLabel = v.priceReseller.."~g~$~s~"}, true, function(h, a, s)
                    if s then
                        local count = tonumber(OrpaillageInput("Veuillez saisir une "..config.color.."quantité~s~ :", "", 3))
                        if count == "" or count == nil then return ESX.ShowNotification("~r~Erreur~s~~n~Cette quantité est invalide !") end
                        TriggerServerEvent("sOrpaillage:sellItem", v.itemReseller, count)
                    end
                end)
            end
        end)

        if not RageUI.Visible(mainMenu) and not RageUI.Visible(resellerMenu) then
            mainMenu = RMenu:DeleteType("menu", true)
        end
    end

    FreezeEntityPosition(PlayerPedId(), false)
end 

CreateThread(function()
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