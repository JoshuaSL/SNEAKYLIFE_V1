local menuillegalf77, Ligotter, DragStatus = false, false, {}
local playerItem, playerWeapon, playerBlackMoney, playerCashMoney = {}, {}, {}, {}
local StatusDeplacement = false

ESX = nil
CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job2 == nil do
		Citizen.Wait(100)
	end

	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()
end)
SneakyEvent = TriggerServerEvent
RegisterNetEvent('esx:setJob2') AddEventHandler('esx:setJob2', function(job2) ESX.PlayerData.job2 = job2 end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLength)
    AddTextEntry('f7', TextEntry .. ' :')
    DisplayOnscreenKeyboard(1, "f7", "", ExampleText, "", "", "", MaxStringLength)
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

local function LoadAnimDict(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname) 
		while not HasAnimDictLoaded(dictname) do 
			Citizen.Wait(1)
		end
	end
end

local function MarquerJoueur()
        local pos = GetEntityCoords(GetPlayerPed(ESX.Game.GetClosestPlayer()))
        local _, distance = ESX.Game.GetClosestPlayer()
        if distance <= 3.0 then
        DrawMarker(21, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.2, 255, 0, 0, 255, 0, 1, 2, 1, nil, nil, 0)
    end
end

local function getPlayerInv(player)
    playerItem = {}
    playerWeapon = {}
    playerBlackMoney = {}
    playerCashMoney = {}

    ESX.TriggerServerCallback('sF7:getOtherPlayerData', function(data)
        for i=1, #data.accounts, 1 do
            if data.accounts[i].name == 'dirtycash' and data.accounts[i].money > 0 then
                table.insert(playerBlackMoney, {
                    label    = data.accounts[i].money,
                    value    = 'dirtycash',
                    itemType = 'item_account',
                    amount   = data.accounts[i].money
                })
                break
			elseif data.accounts[i].name == 'cash' and data.accounts[i].money > 0 then
				table.insert(playerCashMoney, {
                    label    = data.accounts[i].money,
                    value    = 'cash',
                    itemType = 'item_account',
                    amount   = data.accounts[i].money
				})
            end
        end

        for i=1, #data.weapons, 1 do
            table.insert(playerWeapon, {
                label    = ESX.GetWeaponLabel(data.weapons[i].name),
                value    = data.weapons[i].name,
                right    = data.weapons[i].ammo,
                itemType = 'item_weapon',
                amount   = data.weapons[i].ammo
            })
        end

        for i=1, #data.inventory, 1 do
            if data.inventory[i].count > 0 then
                table.insert(playerItem, {
                    label    = data.inventory[i].label,
                    right    = data.inventory[i].count,
                    value    = data.inventory[i].name,
                    itemType = 'item_standard',
                    amount   = data.inventory[i].count
                })
            end
        end
    end, GetPlayerServerId(player), "~r~Individu\n~o~Quelqu'un vous fouille..")
end

RMenu.Add('menuf7', 'main', RageUI.CreateMenu("", "Intéractions Citoyens", 10, 80, "root_cause", "shopui_title_gr_gunmod"))
RMenu:Get('menuf7', 'main').Closed = function()
	menuillegalf77 = false
end;

RMenu.Add('sousmenu', 'fouiller', RageUI.CreateSubMenu(RMenu:Get('menuf7', 'main'), "", "Fouiller l'individu", 10, 80, "root_cause", "shopui_title_gr_gunmod"))
RMenu:Get('sousmenu', 'fouiller').Closed = function()
end;

RMenu.Add('secondmenu', 'groupe', RageUI.CreateSubMenu(RMenu:Get('menuf7', 'main'), "", "Gestion du groupe", 10, 80, "root_cause", "shopui_title_gr_gunmod"))
RMenu:Get('secondmenu', 'groupe').Closed = function()
end;


local function openMenuIllegalF7()
	if not menuillegalf77 then
		menuillegalf77 = true
		RageUI.Visible(RMenu:Get('menuf7', 'main'), true)
	CreateThread(function()
		while menuillegalf77 do
			Wait(1)
				RageUI.IsVisible(RMenu:Get('menuf7', 'main'), true, true, true, function()
					closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					RageUI.Separator("↓ Actions disponibles ↓")
					RageUI.Button("Fouiller l'individu", nil, {RightLabel = "→"}, closestPlayer ~= -1 and closestDistance <= 3.0, function(_, a, s)
						if a then
							if not IsPedInAnyVehicle(PlayerPedId(), -1) then
								MarquerJoueur()
							end
						end
						if s then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				            if closestPlayer ~= -1 and closestDistance <= 3.0 then
								ExecuteCommand("me fouille un individu illégallement...")
								getPlayerInv(closestPlayer)
							else
                                ESX.ShowNotification("~r~Personne à proximité")
                            end
						end
					end, RMenu:Get('sousmenu', 'fouiller'))
		
					RageUI.Button("Ligotter", nil, {RightLabel = "→"}, closestPlayer ~= -1 and closestDistance <= 3.0, function(_, a, s)
						closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if a then
							MarquerJoueur()
						end
						if s then
							if IsPedInAnyVehicle(PlayerPedId(), -1) then
								ESX.ShowNotification("~r~Tu ne peux pas faire ca dans un véhicule")
							else
								local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				            	if closestPlayer ~= -1 and closestDistance <= 3.0 then
									local target, _ = ESX.Game.GetClosestPlayer()
									SneakyEvent('sIllegal:Arrestation', "arrest", GetPlayerServerId(target), GetEntityHeading(PlayerPedId()), GetEntityCoords(PlayerPedId()), GetEntityForwardVector(PlayerPedId()))
								else
									ESX.ShowNotification("~r~Personne à proximité")
								end
							end
						end
					end)

					RageUI.Button("Libérer", nil, {RightLabel = "→"}, closestPlayer ~= -1 and closestDistance <= 3.0, function(_, a, s)
						closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if a then
							MarquerJoueur()
						end
						if s then
							if IsPedInAnyVehicle(PlayerPedId(), -1) then
								ESX.ShowNotification("~r~Tu ne peux pas faire ca dans un véhicule")
							else
								local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				            	if closestPlayer ~= -1 and closestDistance <= 3.0 then
									local target, _ = ESX.Game.GetClosestPlayer()
									SneakyEvent('sIllegal:Arrestation', "notarrest", GetPlayerServerId(target), GetEntityHeading(PlayerPedId()), GetEntityCoords(PlayerPedId()), GetEntityForwardVector(PlayerPedId()))
								else
									ESX.ShowNotification("~r~Personne à proximité")
								end
							end
						end
					end)
					if ESX.PlayerData.job2 and ESX.PlayerData.job2.name ~= "unemployed" and ESX.PlayerData.job2.name ~= "unemployed2" then
						RageUI.Button("Gestion du groupe", nil, {RightLabel = "→"}, true, function(_, a, s)
						end,RMenu:Get("secondmenu","groupe"))
					end
				end, function() end)
				RageUI.IsVisible(RMenu:Get("secondmenu",'groupe'),true,true,true,function()
					RageUI.Button("Recruter", nil, {RightLabel = "→"}, closestPlayer ~= -1 and closestDistance <= 3.0, function(_, a, s)
						closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if a then
							MarquerJoueur()
						end
						if s then
							TriggerServerEvent('Sneaky:RecruitPlayer', GetPlayerServerId(closestPlayer), ESX.PlayerData.job2.name, 0)
						end
					end)
					RageUI.Button("Promouvoir", nil, {RightLabel = "→"}, closestPlayer ~= -1 and closestDistance <= 3.0, function(_, a, s)
						closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if a then
							MarquerJoueur()
						end
						if s then
							TriggerServerEvent('Sneaky:PromotePlayer', GetPlayerServerId(closestPlayer))
						end
					end)
					RageUI.Button("Rétrograder", nil, {RightLabel = "→"}, closestPlayer ~= -1 and closestDistance <= 3.0, function(_, a, s)
						closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if a then
							MarquerJoueur()
						end
						if s then
							TriggerServerEvent('Sneaky:RetrogradePlayer', GetPlayerServerId(closestPlayer))
						end
					end)
					RageUI.Button("Virer", nil, {RightLabel = "→"}, closestPlayer ~= -1 and closestDistance <= 3.0, function(_, a, s)
						closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if a then
							MarquerJoueur()
						end
						if s then
							TriggerServerEvent('Sneaky:VirerPlayer', GetPlayerServerId(closestPlayer))
						end
					end)
				end, function() end)

				RageUI.IsVisible(RMenu:Get("sousmenu",'fouiller'),true,true,true,function()

					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer ~= -1 and closestDistance <= 1.5 then
						for _, cash in pairs (playerCashMoney) do
							RageUI.Separator("↓ ~g~Argents~s~ ↓")
							RageUI.Button("Liquide", nil, {RightLabel = cash.label.."~g~$"}, true, function() end)
						end

						for _, black  in pairs(playerBlackMoney) do
							RageUI.Button("Non déclaré", nil, {RightLabel = ""..black.label.."~r~$"}, true, function() end)
						end
				
						RageUI.Separator("↓ ~b~Liste des objets ~s~↓")
						for _,items  in pairs(playerItem) do
							RageUI.Button(items.label, nil, {RightLabel = "~b~x~s~"..items.right}, true, function() end)
						end

						RageUI.Separator("↓ ~o~Liste des armes ~s~↓")
						for _,weapon  in pairs(playerWeapon) do
							if weapon.right ~= nil and weapon.label ~= nil then
								RageUI.Button(weapon.label, nil, {RightLabel = weapon.right.." Balle(~o~s~s~)"}, true, function() end)
							else
								RageUI.Button(weapon.label, nil, {}, true, function() end)
							end
						end
					else
						RageUI.Button("Personne à proximité", nil, {RightBadge = RageUI.BadgeStyle.Lock},false, function()
						end)
					end
					end, function() 
				end, 1)
			end
		end)
	end
end


RegisterNetEvent('illegalmenu:arretter')
AddEventHandler('illegalmenu:arretter', function(playerheading, playercoords, playerlocation)
	local playerPed = PlayerPedId()
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
	SetPedCanPlayGestureAnims(playerPed, false)
	DisablePlayerFiring(playerPed, true)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	Wait(500)
	SetEntityCoords(PlayerPedId(), x, y, z-0.1)
	SetEntityHeading(PlayerPedId(), playerheading)
	Wait(250)
	LoadAnimDict('mp_arrest_paired')
	TaskPlayAnim(PlayerPedId(), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
	Wait(1600)
	Ligotter = true
	LoadAnimDict('mp_arresting')
	TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
end)

RegisterNetEvent('illegalmenu:arrestation')
AddEventHandler('illegalmenu:arrestation', function()
	Wait(250)
	LoadAnimDict('mp_arrest_paired')
	TaskPlayAnim(PlayerPedId(), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
	Wait(3000)
    ClearPedTasks(PlayerPedId())
end) 

RegisterNetEvent('illegalmenu:enlevermenottes')
AddEventHandler('illegalmenu:enlevermenottes', function(playerheading, playercoords, playerlocation)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(PlayerPedId(), x, y, z-0.1)
	SetEntityHeading(PlayerPedId(), playerheading)
	SetPedCanPlayGestureAnims(playerPed, true)
	DisablePlayerFiring(playerPed, false)
	Wait(250)
	LoadAnimDict('mp_arresting')
	TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Wait(5500)
	Ligotter = false
	DisplayRadar(true)
	TriggerEvent("SneakyLife:HideHungerAndThirst",true)
	SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('illegalmenu:notarrest2')
AddEventHandler('illegalmenu:notarrest2', function()
	Wait(250)
	LoadAnimDict('mp_arresting')
	TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Wait(5500)
	ClearPedTasks(PlayerPedId())
end)

-- DEPLACER JOUEUR
RegisterNetEvent('illegalmenu:drag')
AddEventHandler('illegalmenu:drag', function(copID)
	if not Ligotter then return end
	StatusDeplacement = not StatusDeplacement
	DragStatus.CopId     = tonumber(copID)
end)

toucheBloqueKadir = false

CreateThread(function()
	while true do

        if Ligotter then
			Wait(1)
			toucheBloqueKadir = true
			SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1

			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?

			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job

			DisableControlAction(0, 0, true) -- Disable changer de point de vue
			DisableControlAction(0, 26, true) -- Disable regarder derrière soi
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable écran de pause

			DisableControlAction(0, 59, true) -- Disable direction dans le véhicule
			DisableControlAction(0, 71, true) -- Disable la conduite d'un véhicule en marche avant
			DisableControlAction(0, 72, true) -- Disable faire marche arrière dans le véhicule

			DisableControlAction(2, 36, true) -- Disable en cachette

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle

            DisableControlAction(0, 77, true) -- Animations enlever
            DisableControlAction(1, 77, true) -- Animations enlever

            DisplayRadar(false)
			TriggerEvent("SneakyLife:HideHungerAndThirst",false)
			StatusDeplacement = false
			if StatusDeplacement then
				-- se dégager si la cible se trouve dans un véhicule
				if not IsPedSittingInAnyVehicle(GetPlayerPed(GetPlayerFromServerId(DragStatus.CopId))) then
					AttachEntityToEntity(PlayerPedId(), GetPlayerPed(GetPlayerFromServerId(DragStatus.CopId)), 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else
					StatusDeplacement = false
					DetachEntity(PlayerPedId(), true, false)
				end
			else
				DetachEntity(PlayerPedId(), true, false)
			end
		else
            EnableAllControlActions(0)
			if toucheBloqueKadir then
				DisplayRadar(true)
				TriggerEvent("SneakyLife:HideHungerAndThirst",true)
			end
			toucheBloqueKadir = false
			Wait(850)
		end
	end
end)

RegisterNetEvent('illegalmenu:ActionsVeh')
AddEventHandler('illegalmenu:ActionsVeh', function(typee)
	if typee == "leaveveh" then 
		if not IsPedSittingInAnyVehicle(PlayerPedId()) then return end
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		TaskLeaveVehicle(PlayerPedId(), vehicle, 0)
		SetTimeout(2000, function() 
			LoadAnimDict('mp_arresting')
			TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
			StatusDeplacement = true
		end)
	elseif typee == "putinvehicle" then 
		local coordsveh = GetEntityCoords(PlayerPedId())
		if not Ligotter then return end
		if not StatusDeplacement then return end
		if IsAnyVehicleNearPoint(coordsveh.x, coordsveh.y, coordsveh.z, 5.0) then
			local vehicle = GetClosestVehicle(coordsveh.x, coordsveh.y, coordsveh.z, 5.0, 0, 71)
			if DoesEntityExist(vehicle) then
				local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
				local freeSeat = nil
				for i=maxSeats - 1, 0, -1 do
					if IsVehicleSeatFree(vehicle, i) then
						freeSeat = i
						break
					end
				end
				if freeSeat ~= nil then
					TaskEnterVehicle(PlayerPedId(), vehicle, 10, freeSeat, 10.0, 1, 0)
					StatusDeplacement = true
				end
			end
		end
	end
end)

Keys.Register("F7", "openF7Illegal", "Menu intéraction illégal", function()
	if not toucheBloqueKadir and not bloquertouchejojo then
		if ESX.PlayerData.job2 and ESX.PlayerData.job2.name ~= "unemployed" and ESX.PlayerData.job2.name ~= "unemployed2" then
			if menuillegalf77 == false then
				openMenuIllegalF7()
			end
		end
	end
end)

AddEventHandler("esx:onPlayerDeath", function()
    if Ligotter then
		Ligotter = false
		DisplayRadar(true)
		TriggerEvent("SneakyLife:HideHungerAndThirst",true)
		SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
    end
end)