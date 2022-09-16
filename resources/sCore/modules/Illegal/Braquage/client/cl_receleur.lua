ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
end)


SneakyEvent = TriggerServerEvent
local Receleur = {}
function ShowHelpNotification(msg)
    AddTextEntry('HelpNotification', msg)
	BeginTextCommandDisplayHelp('HelpNotification')
    EndTextCommandDisplayHelp(0, false, true, -1)
end

local ReceleurPos = {
    {
        pos = vector3(1712.4272460938,4790.740234375,41.988807678223),
    },
}

RMenu.Add('receleur', 'main', RageUI.CreateMenu("", "~c~Receleur", 0, 0,"shopui_title_sm_hangar","shopui_title_sm_hangar"))
RMenu.Add('receleur', 'buy', RageUI.CreateSubMenu(RMenu:Get("receleur", "main"),"", "~c~Receleur", 0, 0))
RMenu.Add('receleur', 'sell', RageUI.CreateSubMenu(RMenu:Get("receleur", "main"),"", "~c~Receleur", 0, 0))
RMenu:Get('receleur', 'main').EnableMouse = false
RMenu:Get('receleur', 'main').Closed = function() Receleur.Menu = false FreezeEntityPosition(GetPlayerPed(-1), false) end

function OpenReceleurRageUIMenu()

    if Receleur.Menu then
        Receleur.Menu = false
    else
        Receleur.Menu = true
        RageUI.Visible(RMenu:Get('receleur', 'main'), true)
        FreezeEntityPosition(GetPlayerPed(-1), true)

        Citizen.CreateThread(function()
			while Receleur.Menu do
                RageUI.IsVisible(RMenu:Get('receleur', 'main'), true, false, true, function()
                    RageUI.Button("Acheter", false, {RightLabel = "→ Accéder"}, true, function(h,a,s)
                    end, RMenu:Get('receleur', 'buy'))
                end)
                RageUI.IsVisible(RMenu:Get('receleur', 'buy'), true, false, true, function()
                    RageUI.Button("Carte d'accès", "Elle sert à accéder à un système de sécurité", {RightLabel = "→ Acheter 15 000~c~$"}, true, function(h,a,s)
                        if s then
                            SneakyEvent('Sneakyreceleur:buyItem', "id_card_f", 1,3)
                        end
                    end)
                    RageUI.Button("Kit de crochetage", "Cela sert à crocheter un véhicule", {RightLabel = "→ Acheter 3 000~c~$"}, true, function(h,a,s)
                        if s then
                            SneakyEvent('Sneakyreceleur:buyItem', "kit_de_crochetage", 1,4)
                        end
                    end)
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
        for k,v in pairs(ReceleurPos) do
            local mPos = #(pCoords-v.pos)
            if not Receleur.Menu then
                if mPos <= 10.0 then
                    att = 1
                
                    if mPos <= 1.5 then
                        ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour interagir")
                        if IsControlJustPressed(0, 51) then
                            OpenReceleurRageUIMenu()
                        end
                    end
                end
            end
        end
        Citizen.Wait(att)
    end
end)