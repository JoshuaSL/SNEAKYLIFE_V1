ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
end)
SneakyEvent = TriggerServerEvent
local Weapon = {}
local LicenseOwned = 0
function ShowHelpNotification(msg)
    AddTextEntry('HelpNotification', msg)
	BeginTextCommandDisplayHelp('HelpNotification')
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function CheckLicense()
    ESX.TriggerServerCallback('Sneakyesx_license:checkLicense', function(hasWeaponLicense)
        if hasWeaponLicense then
            LicenseOwned = 1
        else
            LicenseOwned = 0
        end
    end, GetPlayerServerId(PlayerId()), 'weapon')
end

RMenu.Add('weapon', 'main', RageUI.CreateMenu("", "~r~Armurerie", 10, 200,'shopui_title_gunclub','shopui_title_gunclub'))
RMenu:Get('weapon', 'main').EnableMouse = false

RMenu.Add('weapon', 'whitearms', RageUI.CreateSubMenu(RMenu:Get('weapon', 'main'), "", "~r~Armes blanches"))
RMenu.Add('weapon', 'letalsarms', RageUI.CreateSubMenu(RMenu:Get('weapon', 'main'), "", "~r~Armes létales"))
RMenu.Add('weapon', 'accessories', RageUI.CreateSubMenu(RMenu:Get('weapon', 'main'), "", "~r~Accessoires"))

RMenu:Get('weapon', 'main').Closed = function() Weapon.Menu = false FreezeEntityPosition(GetPlayerPed(-1), false) end

function OpenWeaponRageUIMenu()

    if Weapon.Menu then
        Weapon.Menu = false
    else
        Weapon.Menu = true
        RageUI.Visible(RMenu:Get('weapon', 'main'), true)
        FreezeEntityPosition(GetPlayerPed(-1), true)

        Citizen.CreateThread(function()
			while Weapon.Menu do
                RageUI.IsVisible(RMenu:Get('weapon', 'main'), true, false, true, function()
                    --if XNL_GetCurrentPlayerXP() >= 600 then
                        if LicenseOwned == 1 then
                            RageUI.Separator("License : ~g~Valide")
                            RageUI.Button("Armes blanches", false, {RightLabel = "→"}, true, function(h,a,s)
                            end,RMenu:Get("weapon","whitearms"))

                            RageUI.Button("Armes létales", false, {RightLabel = "→"}, true, function(h,a,s)
                            end,RMenu:Get("weapon","letalsarms"))
                            RageUI.Button("Accessoires", false, {RightLabel = "→"}, true, function(h,a,s)
                            end,RMenu:Get("weapon","accessories"))
                        else
                            RageUI.Separator("License : ~r~Invalide")
                            RageUI.Button("Acheter le permis port d'armes", "Allez voir la ~b~L.S.P.D~s~ !", {}, true, function(h,a,s)
                            end)
                            RageUI.Button("Armes blanches", false, {RightLabel = "→"}, true, function(h,a,s)
                            end,RMenu:Get("weapon","whitearms"))
                            RageUI.Button("Accessoires", false, {RightLabel = "→"}, true, function(h,a,s)
                            end,RMenu:Get("weapon","accessories"))
                        end
                    --else
                        --RageUI.Separator("")
                        --RageUI.Separator("~r~Vous n'avez pas le niveau nécessaire.")
                        --RageUI.Separator("")
                    --end
                end)
                RageUI.IsVisible(RMenu:Get('weapon', 'whitearms'), true, false, true, function()
                    RageUI.Button("Club de golf", false, {RightLabel = "→ 2500~g~$"}, true, function(h,a,s)
                        if s then
                            SneakyEvent('sAmmunation:buyWeapon', "WEAPON_GOLFCLUB", 2500)
                        end
                    end)
                    RageUI.Button("Couteau à cran d'arrêt", false, {RightLabel = "→ 3500~g~$"}, true, function(h,a,s)
                        if s then
                            SneakyEvent('sAmmunation:buyWeapon', "WEAPON_SWITCHBLADE", 3500)
                        end
                    end)
                    RageUI.Button("Hachete", false, {RightLabel = "→ 4500~g~$"}, true, function(h,a,s)
                        if s then
                            SneakyEvent('sAmmunation:buyWeapon', "WEAPON_HATCHET", 4500)
                        end
                    end)
                    RageUI.Button("Poing américain", false, {RightLabel = "→ 3000~g~$"}, true, function(h,a,s)
                        if s then
                            SneakyEvent('sAmmunation:buyWeapon', "WEAPON_KNUCKLE", 3000)
                        end
                    end)
                end)
                RageUI.IsVisible(RMenu:Get('weapon', 'letalsarms'), true, false, true, function()
                    RageUI.Button("Pétoire", false, {RightLabel = "→ 41000~g~$"}, true, function(h,a,s)
                        if s then
                            SneakyEvent('sAmmunation:buyWeapon', "WEAPON_SNSPISTOL", 41000)
                        end
                    end)
                end)
                RageUI.IsVisible(RMenu:Get('weapon', 'accessories'), true, false, true, function()
                    RageUI.Button("Chargeur", false, {RightLabel = "→ 50~g~$"}, true, function(h,a,s)
                        if s then
                            SneakyEvent('sAmmunation:buyItem', 'clip')
                        end
                    end)
                end)
				Wait(0)
			end
		end)
	end
end

RegisterNetEvent('sAmmunation:useClip')
AddEventHandler('sAmmunation:useClip', function()
	local playerPed = PlayerPedId()

	if IsPedArmed(playerPed, 4) then
		local hash = GetSelectedPedWeapon(playerPed)

		if hash then
            AddAmmoToPed(playerPed, hash, 25)
            ESX.ShowNotification("Vous avez ~g~utilisé~s~ 1x chargeur")
		else
			ESX.ShowNotification("~r~Action Impossible~s~ : Vous n'avez pas d'arme en main !")
		end
	else
		ESX.ShowNotification("~r~Action Impossible~s~ : Ce type de munition ne convient pas !")
	end
end)

local WeaponShop = {

    {
        pos = vector3(22.181812286377,-1106.7244873047,29.797006607056),
        blip = {
            label = "Armurerie", 
            ID = 110, 
            Color = 40
        },
    },
}


Citizen.CreateThread(function()
    while true do
        att = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs(WeaponShop) do
            local mPos = #(pCoords-v.pos)
            if not Weapon.Menu then
                if mPos <= 10.0 then
                    att = 1
                    DrawMarker(1, v.pos.x, v.pos.y, v.pos.z-0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 150, 200, 170, 0, 0, 0, 1, nil, nil, 0)
                
                    if mPos <= 1.5 then
                        ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour interagir avec l'armurerier")
                        if IsControlJustPressed(0, 51) then
                            CheckLicense()
                            OpenWeaponRageUIMenu()
                        end
                    end
                end
            end
        end
        Citizen.Wait(att)
    end
end)