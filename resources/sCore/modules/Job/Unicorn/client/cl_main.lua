ESX = nil
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
SneakyEvent = TriggerServerEvent
local onService = false
RegisterNetEvent('Sneakyesx:playerLoaded')
AddEventHandler('Sneakyesx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)
RegisterNetEvent('Sneakyesx:setJob')
AddEventHandler('Sneakyesx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent('announce:unicorn')
AddEventHandler('announce:unicorn', function(announce)
    if announce == 'ouvert' then
        ESX.ShowAdvancedNotification('Unicorn', '~y~Informations', "- Unicorn ~g~ouvert~s~~n~- Horaire : ~g~Maintenant", "CHAR_UNICORN", 1)
    elseif announce == 'fermeture' then
        ESX.ShowAdvancedNotification('Unicorn', '~y~Informations', "- Unicorn ~r~fermé~s~~n~- Horaire : ~g~Maintenant", "CHAR_UNICORN", 1)
    end
end)


function ShowHelpNotification(msg)
    AddTextEntry('HelpNotification', msg)
	BeginTextCommandDisplayHelp('HelpNotification')
    EndTextCommandDisplayHelp(0, false, true, -1)
end

local ActionsAnnonce = {
    "~b~Ouverture~s~",
    "~b~Fermeture~s~"
}
local ActionsAnnonceIndex = 1

local MenuUnicorn = {}
RMenu.Add('unicornmenu', 'main', RageUI.CreateMenu("", "~y~Unicorn", nil, nil,"root_cause","shopui_title_vanillaunicorn"))
RMenu:Get('unicornmenu', 'main').EnableMouse = false
RMenu:Get('unicornmenu', 'main').Closed = function() MenuUnicorn.Menu = false end

function OpenUnicornMenuRageUIMenu()

    if MenuUnicorn.Menu then
        MenuUnicorn.Menu = false
    else
        MenuUnicorn.Menu = true
        RageUI.Visible(RMenu:Get('unicornmenu', 'main'), true)

        Citizen.CreateThread(function()
			while MenuUnicorn.Menu do
                RageUI.IsVisible(RMenu:Get('unicornmenu', 'main'), true, false, true, function()
                    if onService then
                        RageUI.Button("Stopper son ~r~service~s~", nil, {RightLabel = "→"}, onService, function(h,a,s)
                            if s then
                                onService = false
                            end
                        end)
                        RageUI.List("Annonce", ActionsAnnonce, ActionsAnnonceIndex, nil, {}, true, function(Hovered, Active, Selected, Index) 
                            if (Selected) then 
                                if Index == 1 then 
                                    local announce = 'ouvert'
                                    SneakyEvent('unicorn:announce', announce)
                                elseif Index == 2 then
                                    local announce = 'fermeture'
                                    SneakyEvent('unicorn:announce', announce)
                                end 
                            end 
                            ActionsAnnonceIndex = Index 
                        end)
                    else
                        RageUI.Button("Prendre son ~g~service~s~", nil, {RightLabel = "→"}, not onService, function(h,a,s)
                            if s then
                                onService = true
                            end
                        end)
                    end
                end)
				Wait(0)
			end
		end)
	end
end

function OpenUnicornActionMenuRageUIMenu()
    local mainMenu = RageUI.CreateMenu("", "~y~Unicorn", 0, 0,"root_cause","shopui_title_vanillaunicorn")

    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

    while mainMenu do
       Wait(1)
       RageUI.IsVisible(mainMenu, true, true, false, function()
            RageUI.Button("Attribuer une facture", nil, {RightLabel = "→"}, true,function(h,a,s)
                if s then
                    RageUI.CloseAll()
                    TriggerEvent("sBill:CreateBill","society_unicorn")
                end
            end)
       end)

       if not RageUI.Visible(mainMenu) then
           mainMenu = RMenu:DeleteType("menu", true)
       end
    end
end




local Unicornpos = {

    PositionAnnonce = {
        {coords = vector3(92.313148498535,-1291.8741455078,29.26354598999-0.9)},
    },
}


Citizen.CreateThread(function()
    while ESX == nil do
		TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
    while true do
        att = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs(Unicornpos.PositionAnnonce) do
            local mPos = #(pCoords-v.coords)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'unicorn' then
                if not MenuUnicorn.Menu then
                    if mPos <= 10.0 then
                        att = 1
                        if mPos <= 3.5 then
                            DrawMarker(25, v.coords.x, v.coords.y, v.coords.z-0.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 0, 155, 255, 255, 0, false, false, 2, false, false, false, false)
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au annonce")
                            if IsControlJustPressed(0, 51) then
                                OpenUnicornMenuRageUIMenu()
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(att)
    end
end)

function CheckServiceUnicorn()
    return onService
end

