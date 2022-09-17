local AmbulanceMenu = {}
local IsBusy = false
local count = 0
local AmbulancePharmacie = {}
local AmbulanceRdv = {}
local AppelerCooldown = false
SneakyEvent = TriggerServerEvent
local Ambulance = {

    PositionPharmacie = {
        {coords = vector3(305.96969604492,-580.40905761719,43.281585693359-0.9)},
		{coords = vector3(337.61016845703,-586.19775390625,28.898637771606-0.9)},
		{coords = vector3(320.37698364258,-571.20159912109,43.281627655029-0.9)},
    },
	PositionRdv = {
        {coords = vector3(342.75476074219,-588.8359375,28.898637771606-0.9)},
		{coords = vector3(345.00256347656,-582.27069091797,28.898637771606-0.9)},
		{coords = vector3(303.50527954102,-597.88916015625,43.292797088623-0.9)},
		{coords = vector3(309.68585205078,-595.18615722656,43.292762756348-0.9)},
    },
}

RegisterNetEvent('Ems:Rdv')
AddEventHandler('Ems:Rdv', function(pinfo)
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then
        ESX.ShowNotification("~g~Pillbox Hill\n~s~Une personne demande un ~b~médecin.")
		Citizen.Wait(100)
    end
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
    while true do
        att = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
		for k,v in pairs(Ambulance.PositionPharmacie) do
            local mPos = #(pCoords-v.coords)

			if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then
				if not AmbulancePharmacie.Menu then
					if mPos <= 4.0 then
						DrawText3D(v.coords.x, v.coords.y, v.coords.z+1, "Appuyez sur ~g~E~s~ pour accéder à la ~g~pharmacie~s~.", 9)
						att = 1
						if mPos <= 1.5 then
							ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder à ~g~l'armoire~s~.")
							if IsControlJustPressed(0, 51) then
							OpenAmbulancePharmacieRageUIMenu()
							end
						end
					end
				end
			end

        	end
		for k,v in pairs(Ambulance.PositionRdv) do
            local mPos = #(pCoords-v.coords)

			if not AmbulanceRdv.Menu then
				if mPos <= 7.0 then
					att = 1
					DrawText3D(v.coords.x, v.coords.y, v.coords.z+1, "Appuyez sur ~g~E~s~ pour demander un ~g~médecin~s~.", 9)
					if mPos <= 1.5 then
						ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour demander un ~g~médecin~s~.")
						if IsControlJustPressed(0, 51) then
							OpenAmbulanceRdvRageUIMenu()
						end
					end
				end
			end

		end
        Citizen.Wait(att)
    end
end)


RMenu.Add('ambulancerdv', 'main', RageUI.CreateMenu("", "",nil,nil,"root_cause","ambulance"))
RMenu:Get('ambulancerdv', 'main'):SetSubtitle("~g~Actions disponibles")
RMenu:Get('ambulancerdv', 'main').EnableMouse = false
RMenu:Get('ambulancerdv', 'main').Closed = function()
    AmbulanceRdv.Menu = false
end

function OpenAmbulanceRdvRageUIMenu()
	if AmbulanceRdv.Menu then
        AmbulanceRdv.Menu = false
    else
        AmbulanceRdv.Menu = true
        RageUI.Visible(RMenu:Get('ambulancerdv', 'main'), true)

        Citizen.CreateThread(function()
			while AmbulanceRdv.Menu do
                RageUI.IsVisible(RMenu:Get('ambulancerdv', 'main'), true, false, true, function()
					if AppelerCooldown == false then
						RageUI.Button("Appeler un médecin", false, {RightLabel = "~g~→ Sonner"}, not AppelerCooldown, function(h,a,s)
							if s then
								SneakyEvent("Ems:DemandeRdv","Une personne demande un médecin.")
								AppelerCooldown = true
                                Citizen.SetTimeout(1200000, function()
                                    AppelerCooldown = false
                                end)
							end
						end)
					else
						RageUI.Button("Appeler un médecin", nil, {RightBadge = RageUI.BadgeStyle.Lock},false, function()
						end)
					end
                end)
				Wait(0)
			end
		end)
	end
end



RMenu.Add('ambulancepharmacie', 'main', RageUI.CreateMenu("", "",nil,nil,"root_cause","ambulance"))
RMenu:Get('ambulancepharmacie', 'main'):SetSubtitle("~b~Produits disponibles")
RMenu:Get('ambulancepharmacie', 'main').EnableMouse = false
RMenu:Get('ambulancepharmacie', 'main').Closed = function()
    AmbulancePharmacie.Menu = false
end

function OpenAmbulancePharmacieRageUIMenu()
	if AmbulancePharmacie.Menu then
        AmbulancePharmacie.Menu = false
    else
        AmbulancePharmacie.Menu = true
        RageUI.Visible(RMenu:Get('ambulancepharmacie', 'main'), true)

        Citizen.CreateThread(function()
			while AmbulancePharmacie.Menu do
                RageUI.IsVisible(RMenu:Get('ambulancepharmacie', 'main'), true, false, true, function()
                    RageUI.Button("Medikit", false, {RightLabel = "~g~→ Prendre"}, true, function(h,a,s)
						if s then
							SneakyEvent('Sneakyesx_ambulancejob:giveItem', "medikit")
						end
                    end)
					RageUI.Button("Bandage", false, {RightLabel = "~g~→ Prendre"}, true, function(h,a,s)
						if s then
							SneakyEvent('Sneakyesx_ambulancejob:giveItem', "bandage")
						end
                    end)
					RageUI.Button("Perfusion", false, {RightLabel = "~g~→ Prendre"}, true, function(h,a,s)
						if s then
							SneakyEvent('Sneakyesx_ambulancejob:giveItem', "perfusion")
						end
                    end)
					RageUI.Button("Fauteuil Roulant", false, {RightLabel = "~g~→ Prendre"}, true, function(h,a,s)
						if s then
							SneakyEvent('Sneakyesx_ambulancejob:giveItem', "wheelchair")
						end
                    end)
					RageUI.Button("Lit", false, {RightLabel = "~g~→ Prendre"}, true, function(h,a,s)
						if s then
							SneakyEvent('Sneakyesx_ambulancejob:giveItem', "bed")
						end
                    end)
                end)
				Wait(0)
			end
		end)
	end
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('Sneakyesx_ambulancejob:heal')
AddEventHandler('Sneakyesx_ambulancejob:heal', function(_type)
	local playerPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(playerPed)

	if _type == 'small' then
		local health = GetEntityHealth(playerPed)
		local newHealth = math.min(maxHealth , math.floor(health + maxHealth / 8))
		SetEntityHealth(playerPed, newHealth)
	elseif _type == 'big' then
		SetEntityHealth(playerPed, maxHealth)
	end

	ESX.ShowNotification('Vous avez été ~g~soigné~s~.')
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local AmbulanceActionMenu = {}


function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)

    while (UpdateOnscreenKeyboard() ~= 1) and (UpdateOnscreenKeyboard() ~= 2) do
        DisableAllControlActions(0)
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        return GetOnscreenKeyboardResult()
    else
        return nil
    end
end

function OpenAmbulanceActionMenuRageUIMenu()

    if AmbulanceActionMenu.Menu then 
        AmbulanceActionMenu.Menu = false 
        RageUI.Visible(RMenu:Get('ambulanceactionmenu', 'main'), false)
        return
    else
        RMenu.Add('ambulanceactionmenu', 'main', RageUI.CreateMenu("", "",nil,nil,"root_cause","ambulance"))
        RMenu:Get('ambulanceactionmenu', 'main'):SetSubtitle("~g~Los Santos Medical Center")
        RMenu:Get('ambulanceactionmenu', 'main').EnableMouse = false
        RMenu:Get('ambulanceactionmenu', 'main').Closed = function()
            AmbulanceActionMenu.Menu = false
            ESX.PlayerData = ESX.GetPlayerData()
        end
        AmbulanceActionMenu.Menu = true 
        RageUI.Visible(RMenu:Get('ambulanceactionmenu', 'main'), true)
        Citizen.CreateThread(function()
			while AmbulanceActionMenu.Menu do
                RageUI.IsVisible(RMenu:Get('ambulanceactionmenu', 'main'), true, false, true, function()
                    ESX.PlayerData = ESX.GetPlayerData()
                    RageUI.Button("Réanimer", nil, { RightLabel = "→" },true, function(h,a,s)
						if s then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowAdvancedNotification('Ambulance', 'Message', 'aucun joueur à proximité', 'CHAR_CALL911', 1)
							else
								ESX.TriggerServerCallback('Sneakyesx_ambulancejob:getItemAmount', function(qtty)
									if qtty > 0 then
										local closestPed = GetPlayerPed(closestPlayer)

										ESX.TriggerServerCallback("EMS:PlayerIsDead", function(dead)
			
											if dead then
												local playerPed = PlayerPedId()
				
												IsBusy = true
												ESX.ShowAdvancedNotification('Ambulance', 'Message', 'réanimation en cours', 'CHAR_CALL911', 1)
												TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
												Wait(10000)
												ClearPedTasks(playerPed)
												SneakyEvent("EMS:RevivePLayer", GetPlayerServerId(closestPlayer))
												SneakyEvent('Sneakyesx_ambulancejob:removeItem', 'medikit')
												IsBusy = false
												ESX.ShowNotification('Vous avez réanimer la personne')
											else
												ESX.ShowAdvancedNotification('Ambulance', 'Message', 'n\'est pas inconscient', 'CHAR_CALL911', 1)
											end
										end, GetPlayerServerId(closestPlayer))
									else
										ESX.ShowAdvancedNotification('Ambulance', 'Message', 'vous n\'avez pas de ~b~kit de soin~w~.', 'CHAR_CALL911', 1)
									end
								end, 'medikit')
							end
						end
                    end)
                    RageUI.Button("Soigner petites blessures", nil, { RightLabel = "→" },true, function(h,a,s)
						if s then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowAdvancedNotification('Ambulance', 'Message', 'aucun joueur à proximité', 'CHAR_CALL911', 1)
							else
								ESX.TriggerServerCallback('Sneakyesx_ambulancejob:getItemAmount', function(qtty)
									if qtty > 0 then
										local closestPlayerPed = GetPlayerPed(closestPlayer)
										local idclosestped = GetPlayerServerId(closestPlayer)
										local health = GetEntityHealth(closestPlayerPed)
			
										if health > 0 then
											local playerPed = PlayerPedId()
			
											IsBusy = true
											ESX.ShowAdvancedNotification('Ambulance', 'Message', 'Vous avez ~g~soigné~s~ la personne.', 'CHAR_CALL911', 1)
											TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
											Citizen.Wait(10000)
											ClearPedTasks(playerPed)
			
											SneakyEvent('Sneakyesx_ambulancejob:removeItem', 'bandage')
											SneakyEvent('Sneakyesx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
											IsBusy = false
										else
											ESX.ShowAdvancedNotification('Ambulance', 'Message', 'Cette personne est inconsciente!', 'CHAR_CALL911', 1)
										end
									else
										ESX.ShowAdvancedNotification('Ambulance', 'Message', 'vous n\'avez pas de ~b~bandage~w~.', 'CHAR_CALL911', 1)
									end
								end, 'bandage')
							end
						end
                    end)
					RageUI.Button("Soigner blessures graves", nil, { RightLabel = "→" },true, function(h,a,s)
						if s then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowAdvancedNotification('Ambulance', 'Message', 'aucun joueur à proximité', 'CHAR_CALL911', 1)
							else
								ESX.TriggerServerCallback('Sneakyesx_ambulancejob:getItemAmount', function(qtty)
									if qtty > 0 then
										local closestPlayerPed = GetPlayerPed(closestPlayer)
										local health = GetEntityHealth(closestPlayerPed)
			
										if health > 0 then
											local playerPed = PlayerPedId()
			
											IsBusy = true
											ESX.ShowAdvancedNotification('Ambulance', 'Message', 'Vous avez ~g~soigné~s~ la personne.', 'CHAR_CALL911', 1)
											TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
											Citizen.Wait(10000)
											ClearPedTasks(playerPed)
			
											SneakyEvent('Sneakyesx_ambulancejob:removeItem', 'medikit')
											SneakyEvent('Sneakyesx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
											IsBusy = false
										else
											ESX.ShowAdvancedNotification('Ambulance', 'Message', 'Cette personne est inconsciente!', 'CHAR_CALL911', 1)
										end
									else
										ESX.ShowAdvancedNotification('Ambulance', 'Message', 'vous n\'avez pas de ~b~kit de soin~w~.', 'CHAR_CALL911', 1)
									end
								end, 'medikit')
							end
						end
                    end)
					RageUI.Button("Attribuer une facture", nil, {RightLabel = "→"}, true,function(h,a,s)
						if s then
							RageUI.CloseAll()
							TriggerEvent("sBill:CreateBill","society_ambulance")
						end
					end)
					RageUI.Button("Gestion des appels", nil, { RightLabel = "→" },true, function(h,a,s)
						if s then
							RageUI.CloseAll()
							TriggerEvent("sCall:OpenCallMenu")
						end
                    end)
                end)
				Wait(0)
			end
		end)
	end
end