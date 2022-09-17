ESX = nil

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
local Society = {}
local BossZone = {}
local EmployeesTab = {}
local societymoney = nil
local SelectedEmployee = nil
local JobTab = {}
local Alert = {
	Inprogress = false
}
SneakyEvent = TriggerServerEvent
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

function OpenBossMenu(_society, texturedict, texturename, options)
	RMenu.Add('bossmenu', 'main', RageUI.CreateMenu("", "~b~Menu Patron", nil, nil,texturedict,texturename))
	RMenu:Get('bossmenu', 'main').EnableMouse = false

	RMenu:Get('bossmenu', 'main').Closed = function()
		Society.Menu = false
		FreezeEntityPosition(PlayerPedId(), false)
	end

	RMenu.Add('bossmenu', 'manage_employees', RageUI.CreateSubMenu(RMenu:Get('bossmenu', 'main'), "", "~b~Gestion des employés"))
	RMenu.Add('bossmenu', 'update_employee', RageUI.CreateSubMenu(RMenu:Get('bossmenu', 'main'), "", "~b~Gestion des employés"))
	RMenu.Add('bossmenu', 'manage_salary', RageUI.CreateSubMenu(RMenu:Get('bossmenu', 'main'), "", "~b~Gestion des salaires"))

	scty = _society
	local isBoss = nil
	local options  = options or {}
	ESX.TriggerServerCallback('pSociety:isBoss', function(result) isBoss = result end, scty)
	while isBoss == nil do Citizen.Wait(100) end
	if not isBoss then return end
	local defaultOptions = {money = true, wash = false,employees = true,grades = true}

	for k,v in pairs(defaultOptions) do
		if options[k] == nil then
			options[k] = v
		end
	end

	if Society.Menu then
        Society.Menu = false
    else
        Society.Menu = true
		FreezeEntityPosition(PlayerPedId(), true)
        RageUI.Visible(RMenu:Get('bossmenu', 'main'), true)
		RefreshMoney()

        Citizen.CreateThread(function()
			while Society.Menu do
				RageUI.IsVisible(RMenu:Get('bossmenu', 'main'), true, false, true, function()
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if societymoney ~= nil then
						RageUI.Separator("Entreprise :~y~ " ..ESX.PlayerData.job.label)
						RageUI.Separator("Argent :~b~ $" ..societymoney)
					end

					if closestPlayer ~= -1  and closestDistance <= 5.0 then
						RageUI.Button("Recruter", "Permet de recruter le joueur le plus proche.", {}, true, function(Hovered, Active, Selected)
							if Active then
								local pCoords = GetEntityCoords(GetPlayerPed(closestPlayer))
								DrawMarker(2, pCoords.x, pCoords.y, pCoords.z+1.1, 0, 0, 0, 180.0, nil, nil, 0.2, 0.2, 0.2, 255, 255, 255, 170, 0, 1, 0, 0, nil, nil, 0)
								if Selected then
									SneakyEvent("pSociety:RequestSetRecruit", GetPlayerServerId(closestPlayer), scty)
								end
							end
						end)
					end

					if options.money then
						RageUI.Button("Retirer de l'argent", false, {}, true, function(Hovered, Active, Selected)
							if Selected then
								result = KeyboardInput("pick", '~b~Combien ?', "", 8)
								if tonumber(result) then
									result = ESX.Math.Round(tonumber(result))
									if result > 0 then
										SneakyEvent('pSociety:withdrawMoney', scty, result)
										ESX.SetTimeout(100, function()
											RefreshMoney()
										end)
									else
										RageUI.Popup({message = "~b~Action impossible"})
									end
								else
									RageUI.Popup({message = "~r~Veuillez entrer un nombre !"})
								end
							end
						end)

						RageUI.Button("Déposer de l'argent", false, {}, true, function(Hovered, Active, Selected)
							if Selected then
								result = KeyboardInput("deposit", '~b~Combien ?', "", 8)
								if tonumber(result) then
									result = ESX.Math.Round(tonumber(result))
									if result > 0 then
										SneakyEvent('pSociety:depositMoney', scty, result)
										ESX.SetTimeout(100, function()
											RefreshMoney()
										end)
									else
										RageUI.Popup({message = "~b~Action impossible"})
									end
								else
									RageUI.Popup({message = "~r~Veuillez entrer un nombre !"})
								end
							end
						end)
					end

					if options.wash then
						RageUI.Button("Blanchir de l'argent", "Convertie l'argent sale en argent propre (90%).", {}, true, function(Hovered, Active, Selected)
							if Selected then
								result = KeyboardInput("wash", '~b~Combien ?', "", 8)
								if tonumber(result) then
									result = ESX.Math.Round(result*0.9)
									if result > 0 then
										SneakyEvent('pSociety:washMoney', scty, result)
										ESX.SetTimeout(100, function()
											RefreshMoney()
										end)
									else
										RageUI.Popup({message = "~b~Action impossible"})
									end
								else
									RageUI.Popup({message = "~r~Veuillez entrer un nombre !"})
								end
							end
						end)
					end

					if options.employees then
						RageUI.Button("Gestion des employés", false, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
							if Selected then
								RefeshEmployeesList(scty)
								filterstring = ""
							end
						end, RMenu:Get('bossmenu', 'manage_employees'))
					end

					--[[ if options.grades then
						RageUI.Button("Gestion des salaires", "Les salaires sont tirés du compte de l'entreprise !", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
							if Selected then
								RefeshjobInfos(scty)
							end
						end, RMenu:Get('bossmenu', 'manage_salary'))
					end ]]
				end)

				RageUI.IsVisible(RMenu:Get('bossmenu', 'manage_employees'), true, false, true, function()
					RageUI.Button("Rechercher", false, {RightLabel = filterstring}, true, function(Hovered, Active, Selected)
                        if Selected then
                            filterstring = KeyboardInput("entysearch", "~b~Rechercher", "", 50)
                        end
                    end)
					RageUI.Separator("↓↓ ~b~Liste~s~ ↓↓")

					for i=1, #EmployeesTab do
                        local ply = EmployeesTab[i]

						if filterstring == nil or string.find(ply.name, filterstring) or string.find(ply.job.grade_label, filterstring) then
							RageUI.Button(ply.name, false, {RightLabel = "~b~"..ply.job.grade_label.."~s~ →"}, true, function(Hovered, Active, Selected)
								if Selected then
									RefeshjobInfos(scty)
									SelectedEmployee = ply
								end
							end, RMenu:Get('bossmenu', 'update_employee'))
						end
					end
				end)

				RageUI.IsVisible(RMenu:Get('bossmenu', 'update_employee'), true, false, true, function()

					RageUI.Separator("↓↓ ~b~"..SelectedEmployee.name.."~s~ ↓↓")

					for i=1, #JobTab, 1 do
						local jb = JobTab[i]

						if SelectedEmployee.job.grade ~= jb.grade then
							RageUI.Button(jb.label, false, {RightLabel = "~b~Choisir →"}, true, function(Hovered, Active, Selected)
								if Selected then
									ESX.TriggerServerCallback('pSociety:setJob', function(data)
										if data ~= false then
											SelectedEmployee.job.grade = jb.grade
										end
									end, SelectedEmployee.identifier, scty, jb.grade)
								end
							end)
						else
							RageUI.Button(jb.label, false, {RightLabel = "~r~Actuel"}, true, function(Hovered, Active, Selected)
							end)
						end
					end

					RageUI.Button("~r~Expulser de l'entreprise", false, {RightBadge = RageUI.BadgeStyle.Alert}, true, function(Hovered, Active, Selected)
						if Selected then
							result = KeyboardInput("valid", '~b~Êtes-vous vraiment sûre ?~s~ (oui)', "", 8)
							if result == "oui" then
								ESX.TriggerServerCallback('pSociety:setJob', function()
									RageUI.GoBack()
								end, SelectedEmployee.identifier, 'unemployed', 0)
							end
						end
					end)
				end)

				--[[ RageUI.IsVisible(RMenu:Get('bossmenu', 'manage_salary'), true, false, true, function()
					RageUI.Separator("↓↓ ~b~"..ESX.PlayerData.job.label.."~s~ ↓↓")

					for i=1, #JobTab, 1 do
						local jb = JobTab[i]

						RageUI.Button(jb.grade..". "..jb.label, false, {RightLabel = "~g~$"..jb.salary}, true, function(Hovered, Active, Selected)
							if Selected then
								result = tostring(KeyboardInput("pick", '~b~Combien ?', "", 4))
                                result = ESX.Math.Round(tonumber(result))
								if result >= 1 then
									ESX.TriggerServerCallback('pSociety:setJobSalary', function()
										ESX.SetTimeout(100, function()
											RefeshjobInfos(scty)
										end)
									end, scty, jb.grade, result)
								else
									RageUI.Popup({message = "~b~Action impossible"})
								end
							end
						end)
					end
				end) ]]

				Wait(0)
			end
		end)
	end

end

AddEventHandler('pSociety:CreateBossMenu', function(infos)
	Citizen.CreateThread(function()
		for k,v in pairs(infos) do
			table.insert(BossZone, v)
			SneakyEvent('pSociety:registerSociety', v.name, v.label, "society_"..v.name, "society_"..v.name, "society_"..v.name, {type = "public"})
		end
	end)
end)

Citizen.CreateThread(function()
    while true do
        att = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        if BossZone ~= nil and ESX ~= nil then
            for k,v in pairs(BossZone) do
                local mPos = #(pCoords-v.pos)

                if not Society.Menu then
					if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == v.name and ESX.PlayerData.job.grade_name == "boss" then
						if mPos <= 10.0 then
							att = 1
							DrawMarker(1, v.pos.x, v.pos.y, v.pos.z-0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 150, 200, 170, 0, 0, 0, 1, nil, nil, 0)
						
							if mPos <= 1.0 then
								ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour interagir")
								if IsControlJustPressed(0, 51) then
									OpenBossMenu(v.name,v.texturedict,v.texturename, v.options)
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

RegisterNetEvent("pSociety:SendRequestRecruit")
AddEventHandler("pSociety:SendRequestRecruit", function(bb, cc)
	RageUI.PopupChar({
		message = "~b~infos:~s~\n"..bb.."\n\n~b~B~s~ Accepter. | ~r~G~s~ Décliner.",
		picture = "CHAR_CHAT_CALL",
		title = "~b~Nouvelle offre.",
		iconTypes = 1,
		sender = "Emploie"
	})

	Citizen.Wait(100)
	Alert.Inprogress = true
	local count = 0
	Citizen.CreateThread(function()
		while Alert.Inprogress do

			if IsControlPressed(0, 29) then
				RageUI.Popup({message="~g~Vous avez accepté l'offre"})
				ESX.PlayerData = ESX.GetPlayerData()
				SneakyEvent("pSociety:SetJob", cc, 0)
				Alert.Inprogress = false
				count = 0
			elseif IsControlPressed(0, 58) then
				RageUI.Popup({message="~r~Vous avez décliner l'offre"})
				Alert.Inprogress = false
				count = 0
			end
	
			count = count + 1

			if count >= 1000 then
				Alert.Inprogress = false
				count = 0
				RageUI.Popup({message="~r~Vous avez ignoré l'offre"})
			end
	
			Citizen.Wait(10)
		end
	end)
end)

function RefreshMoney()
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		ESX.TriggerServerCallback('pSociety:getSocietyMoney', function(money)
			societymoney = ESX.Math.GroupDigits(money)
		end, ESX.PlayerData.job.name)
	end
end

function RefeshEmployeesList(_society)
    EmployeesTab = {}
    ESX.TriggerServerCallback('pSociety:getEmployees', function(employees)
        for i=1, #employees, 1 do
            table.insert(EmployeesTab,  employees[i])
        end
    end, _society)
end

function RefeshjobInfos(_society)
    JobTab = {}
    ESX.TriggerServerCallback('pSociety:getJob', function(job)
        for i=1, #job.grades, 1 do
            table.insert(JobTab,  job.grades[i])
        end
    end, _society)
end

function ShowHelpNotification(msg)
    AddTextEntry('HelpNotification', msg)
	BeginTextCommandDisplayHelp('HelpNotification')
    EndTextCommandDisplayHelp(0, false, true, -1)
end

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