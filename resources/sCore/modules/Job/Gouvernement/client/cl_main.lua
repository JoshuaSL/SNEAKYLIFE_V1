ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
local onService = false
local Gouvernement = {
	job = "gouvernement",
	label = "Gouvernement",
	texture = "gouvernement",
	positions = {
		["garage"] = {
			menuPos = vector3(-570.56652832031,-170.6410369873,38.171669006348-0.9),
			vehicle = {
				Pos = {
					{pos = vector3(-573.88037109375,-169.01741027832,37.625427246094), heading = 112.965},
					{pos = vector3(-566.27288818359,-165.79425048828,37.724758148193), heading = 112.965},
					{pos = vector3(-558.79541015625,-162.62562561035,37.82243347168), heading = 112.965}
				},
				Vehicles = {
					{label = "Granger blindé", veh = "usssgranger", stock = 4},
					{label = "Van banalisé", veh = "usssvan", stock = 2},
                    {label = "Granger vip blindé", veh = "usssvip", stock = 1},
				}
			},
			deleteVehicle = vector3(-575.38275146484,-169.14524841309,37.608043670654-0.9)
		}, -- Fin garagxe
		["armory"] = {
			armoryPos = vector3(-541.73913574219,-192.90643310547,47.423046112061-0.2),
			acces = {["agentsecurite"] = true, ["superviseursecurite"] = true, ["directeursecurite"] = true},
			weapons = {
				[1] = {name = "WEAPON_COMBATPISTOL", label = "Pistolet de combat"},
			}
		}, -- Fin armory
        ["avocat"] = {
            acces = {["avocat"] = true, ["directeuravocat"] = true},
            createBill = {
                label = "",
                price = 0
            },
            Positions = {
                {pos = vector3(-530.08117675781,-191.13844299316,38.222400665283-0.9)}
            },
		}, -- Fin avocat
        ["service"] = {
            Positions = {
                {pos = vector3(-551.02453613281,-191.99537658691,38.223079681396-0.9)}
            },
		}
	},
}

local function openArmory()
    local mainMenu = RageUI.CreateMenu("", "Armurerie", nil, nil, "root_cause", Gouvernement.texture)
    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))
    local weapons = Gouvernement.positions["armory"].weapons
    while mainMenu do
        Wait(0)
        RageUI.IsVisible(mainMenu, true, false, false, function()
            ESX.ShowHelpNotification("Chaque arme empruntée doit être rendu des\n~r~sanctions~s~ seront prises si des armes sont perdues")
            RageUI.Button("Déposer ses armes de services", nil, {RightLabel = "~g~Déposer →"}, true, function(h,a,s)
                if s then
                    exports.inventaire:ResetWeaponSlots()
                    if HasPedGotWeapon(PlayerPedId(),"WEAPON_COMBATPISTOL",false) then
                        SetCurrentPedWeapon(PlayerPedId(), "WEAPON_UNARMED", true)
                        SneakyEvent("sPolice:removeWeapons")
                    else
                        ESX.ShowNotification("~b~Armurerie~s~\nVous n'avez pas d'arme à déposer")
                    end
                end
            end)
            for k,v in pairs(weapons) do
                RageUI.Button("Prendre un(e) "..v.label, nil, {RightLabel = "~g~Prendre →"}, true, function(h, a, s)
                    if s then
                        if HasPedGotWeapon(PlayerPedId(),v.name,false) then
                            ESX.ShowNotification("~b~Armurerie~s~\nVous avez déjà pris un(e) "..v.label)
                        else
                            SneakyEvent("sPolice:addWeapon", v.name)
                        end
                    end
                end)
            end
        end)
        if not RageUI.Visible(mainMenu) then
            mainMenu = RMenu:DeleteType('menu', true)
        end
    end
end

local function DeleteVehicle()
	local pPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(pPed, false) then
        local vehGarage = Gouvernement.positions["garage"].vehicle.Vehicles
		local pVeh = GetVehiclePedIsIn(pPed, false)
		local model = GetEntityModel(pVeh)
		Citizen.CreateThread(function()
			ShowLoadingMessage("Rangement du véhicule ...", 1, 2500)
		end)
        local vehicle = GetVehiclePedIsIn(PlayerPedId(),  false)
        local plate = GetVehicleNumberPlateText(vehicle)
        SneakyEvent('Sneakyesx_vehiclelock:deletekeyjobs', 'no', plate)
		TaskLeaveAnyVehicle(pPed, 1, 1)
		Wait(2500)
		while IsPedInAnyVehicle(pPed, false) do
			TaskLeaveAnyVehicle(pPed, 1, 1)
			ShowLoadingMessage("Rangement du véhicule ...", 1, 300)
			Wait(200)
		end
        TriggerEvent('persistent-vehicles/forget-vehicle', pVeh)
	    DeleteEntity(pVeh)
		for k,v in pairs(vehGarage) do
			if GetHashKey(v.veh) == model then
				vehGarage[k].stock = vehGarage[k].stock + 1
			end
		end
	else
		ESX.ShowNotification("Vous devez être dans un véhicule.")
	end
end

local function openGarage()
    local mainMenu = RageUI.CreateMenu("", "Garage", nil, nil, "root_cause", Gouvernement.texture)
    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))
    local vehPos = Gouvernement.positions["garage"].vehicle.Pos
    local vehGarage = Gouvernement.positions["garage"].vehicle.Vehicles
    while mainMenu do
        Wait(0)
        RageUI.IsVisible(mainMenu, true, false, false, function()
            RageUI.Separator("~b~↓~s~ Véhicule de service ~b~↓~s~")
            for k,v in pairs(vehGarage) do
                RageUI.Button(v.label, nil, {RightLabel = "Stock: [~b~"..v.stock.."~s~]"}, v.stock > 0, function(h,a,s)
                    if s then
                        local pos = FoundClearSpawnPoint(vehPos)
                        if pos ~= false then
                            LoadModel(v.veh)
                            local veh = CreateVehicle(GetHashKey(v.veh), pos.pos, pos.heading, true, false)
                            SetEntityAsMissionEntity(veh, 1, 1)
                            SetVehicleDirtLevel(veh, 0.0)
                            ShowLoadingMessage("Véhicule de service sortie.", 2, 2000)
                            SneakyEvent('Sneakyesx_vehiclelock:givekey', 'no', GetVehicleNumberPlateText(veh))
                            TriggerEvent('persistent-vehicles/register-vehicle', veh)
                            vehGarage[k].stock = vehGarage[k].stock - 1
                            Wait(350)
                        else
                            ESX.ShowNotification("Aucun point de sortie disponible")
                        end
                    end
                end)
            end
        end)
        if not RageUI.Visible(mainMenu) then
            mainMenu = RMenu:DeleteType('menu', true)
        end
    end
end


local function KeyboardInput(TextEntry, ExampleText, MaxStringLength)

	AddTextEntry('FMMC_KEY_TIP1', TextEntry)
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

local function openAvocat()
    local mainMenu = RageUI.CreateMenu("", "Gestion avocat", nil, nil, "root_cause", Gouvernement.texture)
    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))
    while mainMenu do
        Wait(0)
        RageUI.IsVisible(mainMenu, true, false, false, function()
            RageUI.Button("Attribuer une facture", nil, {RightLabel = "→"}, true,function(h,a,s)
                if s then
                    RageUI.CloseAll()
                    TriggerEvent("sBill:CreateBill",'society_'..Gouvernement.job)
                end
           end)
        end)
        if not RageUI.Visible(mainMenu) then
            mainMenu = RMenu:DeleteType('menu', true)
        end
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

    if ESX.IsPlayerLoaded() then
        ESX.PlayerData = ESX.GetPlayerData()
    end

    while true do
        local nofps = false
        local myCoords = GetEntityCoords(PlayerPedId())


		if ESX.PlayerData.job.name == Gouvernement.job then

			if #(myCoords-Gouvernement.positions["garage"].menuPos) < 1.5 then
				nofps = true
				ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le ~b~garage~s~.")
				if IsControlJustReleased(0, 38) then
                    if onService then
					    openGarage()
                    else
                        ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
                    end
				end
			elseif #(myCoords-Gouvernement.positions["garage"].deleteVehicle) < 3.5 then
				nofps = true
				ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ranger ~b~le véhicule de service~s~.")
				if IsControlJustPressed(0, 51) then
                    if onService then
					    DeleteVehicle()
                    else
                        ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
                    end
				end
			end
			
			if Gouvernement.positions["armory"].acces[ESX.PlayerData.job.grade_name] ~= nil then

				if #(myCoords-Gouvernement.positions["armory"].armoryPos) < 1.5 then
					nofps = true
					ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir ~b~l'armurerie~s~.")
					if IsControlJustReleased(0, 38) then
                        if onService then
						    openArmory()
                        else
                            ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
                        end
					end
				end
            elseif Gouvernement.positions["avocat"].acces[ESX.PlayerData.job.grade_name] ~= nil then

                for k,v in pairs(Gouvernement.positions["avocat"].Positions) do
                    if #(myCoords-v.pos) < 1.5 then
                        nofps = true
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir ~b~le menu gestion avocat~s~.")
                        if IsControlJustReleased(0, 38) then
                            if onService then
                                openAvocat()
                            else
                                ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
                            end
                        end
                    end
                end
			end
            for k,v in pairs(Gouvernement.positions["service"].Positions) do
                if #(myCoords-v.pos) < 1.5 then
                    nofps = true
                    if onService then label = "~r~arrêter~s~" else label = "~g~démarrer~s~" end
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour "..label.." son service.")
                    if IsControlJustReleased(0, 38) then
                        onService = not onService
                    end
                end
            end
		end
        if nofps then
            Wait(1)
        else
            Wait(850)
        end
    end

end)
