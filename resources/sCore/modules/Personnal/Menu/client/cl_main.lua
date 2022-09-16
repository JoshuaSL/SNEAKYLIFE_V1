local blackListWeapon = {
    ["WEAPON_NIGHTSTICK"] = true,
    ["WEAPON_STUNGUN"] = true,
    ["WEAPON_COMBATPISTOL"] = true,
    ["WEAPON_PUMPSHOTGUN"] = true,
    ["WEAPON_CARBINERIFLE"] = true,
    ["WEAPON_MUSKET"] = true
}

ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('Sneakyesx:getSharedObject', function(obj)
            ESX = obj
        end)
        ESX.PlayerData = ESX.GetPlayerData()
        Citizen.Wait(10)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then
        ESX.PlayerData = ESX.GetPlayerData()
    end

    WeaponData = ESX.GetWeaponList()

    for i = 1, #WeaponData, 1 do
        if WeaponData[i].name == 'WEAPON_UNARMED' then
            WeaponData[i] = nil
        else
            WeaponData[i].hash = GetHashKey(WeaponData[i].name)
        end
    end
end)
SneakyEvent = TriggerServerEvent
ToucheAncre = 58 		
TexteAncre = "~INPUT_THROW_GRENADE~"

local TextVisible = true
local AncreJetee = false
local speedlimitateur = false
local speedlimited = 0

Citizen.CreateThread(function ()
    while true do
    	Citizen.Wait(50)
		local playerPed = GetPlayerPed(-1)
		if IsPedInAnyVehicle(playerPed, false) then
            local myVehicle = GetVehiclePedIsIn(playerPed, false)
			local myVehicleHash = GetEntityModel(myVehicle)
			if IsThisModelABoat(myVehicleHash) then
					
				if TextVisible then
					Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING")
					Citizen.InvokeNative(0x5F68520888E69014, "Appuyez sur "..TexteAncre.." pour ~b~jeter~s~ ou ~b~remonter~s~ votre ancre.")
					Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1)				
					TextVisible = false
				end
				if IsControlJustPressed(1, ToucheAncre) then
					local myVehicleSpeed = GetEntitySpeed(myVehicle)
					if (myVehicleSpeed * 3.6) > 20 then
					
						Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING")
						Citizen.InvokeNative(0x5F68520888E69014, "Trop rapide pour jeter l'ancre")
						Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1)	
					else
						if AncreJetee then
							FreezeEntityPosition(myVehicle, false)
							AncreJetee = false
							SetVehicleEngineOn(myVehicle, true, false, true)								
							Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING")
							Citizen.InvokeNative(0x5F68520888E69014, "Ancre remontée")
							Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1)				
							TextVisible = false
						elseif AncreJetee == false then
							FreezeEntityPosition(myVehicle, true)
							AncreJetee = true
							SetVehicleEngineOn(myVehicle, false, false, true)
							TaskLeaveVehicle(playerPed, myVehicle, 64)
							Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING")
							Citizen.InvokeNative(0x5F68520888E69014, "Ancre jetée, bateau arrêté")
							Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1)				
							TextVisible = false
						end	
						
					end
						
				end											
					
			end

		else
        	TextVisible = true
			
		end
				
	end
	
end)


RegisterNetEvent("SneakyLife:StopSellDrugs")
AddEventHandler("SneakyLife:StopSellDrugs",function()
    pnjVente = false
end)

local lockKeys = false
function SpawnObj(obj)
    local playerPed = PlayerPedId()
	local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
    local objectCoords = (coords + forward * 1.0)
    local Ent = nil

    SpawnObject(obj, objectCoords, function(obj)
        SetEntityCoords(obj, objectCoords, 0.0, 0.0, 0.0, 0)
        SetEntityHeading(obj, GetEntityHeading(playerPed))
		PlaceObjectOnGroundProperly(obj)
        Ent = obj
        Wait(1)
    end) 
    Wait(1)
    while Ent == nil do Wait(1) end
    SetEntityHeading(Ent, GetEntityHeading(playerPed))
    PlaceObjectOnGroundProperly(Ent)
    local placed = false
    lockKeys = true
    CreateThread(function()
        while lockKeys do
            Wait(1)
            DisableControlAction(0, 22, true) 
            DisableControlAction(0, 21, true)
        end
    end)
    while not placed do
        Citizen.Wait(1)
        local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
        local objectCoords = (coords + forward * 3.0)
        SetEntityCoords(Ent, objectCoords, 0.0, 0.0, 0.0, 0)
        SetEntityHeading(Ent, GetEntityHeading(playerPed))
        PlaceObjectOnGroundProperly(Ent)
        SetEntityAlpha(Ent, 170, 170)
        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour placer l'objet")
        if IsControlJustReleased(1, 38) then
			placed = true
			SneakyEvent("3dme:afficher", "place un objet")
        end
    end
    lockKeys = false
    FreezeEntityPosition(Ent, true)
    SetEntityInvincible(Ent, true)
    ResetEntityAlpha(Ent)
    local NetId = NetworkGetNetworkIdFromEntity(Ent)
    table.insert(object, NetId)

end

object = {}
OtherItems = {}
local status = true


function RemoveObj(id, k)
    Citizen.CreateThread(function()
        SetNetworkIdCanMigrate(id, true)
        local entity = NetworkGetEntityFromNetworkId(id)
        NetworkRequestControlOfEntity(entity)
        local test = 0
        while test > 100 and not NetworkHasControlOfEntity(entity) do
            NetworkRequestControlOfEntity(entity)
            Wait(1)
            test = test + 1
        end
        SetEntityAsNoLongerNeeded(entity)

        local test = 0
        while test < 100 and DoesEntityExist(entity) do 
            SetEntityAsNoLongerNeeded(entity)
            SneakyEvent("DeleteEntity", NetworkGetNetworkIdFromEntity(entity))
            DeleteEntity(entity)
            DeleteObject(entity)
            if not DoesEntityExist(entity) then 
                table.remove(object, k)
            end
            SetEntityCoords(entity, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0)
            Wait(1)
            test = test + 1
        end
    end)
end

function GoodName(hash)
    if hash == GetHashKey("prop_roadcone02a") then
        return "Cone"
    elseif hash == GetHashKey("prop_barrier_work05") then
        return "Barrière"
    else
        return hash
    end

end



function SpawnObject(model, coords, cb)
	local model = GetHashKey(model)

	Citizen.CreateThread(function()
		RequestModels(model)
        Wait(1)
		local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)

		if cb then
			cb(obj)
		end
	end)
end


function RequestModels(modelHash)
	if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
		RequestModel(modelHash)

        while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)
		end
	end
end




local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

local PersonalMenu = {
    billing = {},
    engineActionList = {
        "Allumer",
        "Éteindre",
    },
    engineActionIndex = 1,
}
local ItemSelected = {}
local engineCoolDown = false
local bank = nil
local sale = nil
local societymoney = nil
local societymoney2 = nil
local extraList = {"n°1","n°2","n°3","n°4","n°5","n°6","n°7","n°8","n°9","n°10","n°11","n°12","n°13","n°14","n°15"}
local extraIndex = 1
local extraCooldown = false
local extraStateIndex = 1
local doorActionIndex = 1
local radioturn = nil

function GetCurrentWeight()
	local currentWeight = 0

	for i = 1, #ESX.PlayerData.inventory, 1 do
		if ESX.PlayerData.inventory[i].count > 0 then
			currentWeight = currentWeight + (ESX.PlayerData.inventory[i].weight * ESX.PlayerData.inventory[i].count)
		end
	end

	return currentWeight
end

function getvehicleskey()
    getplayerkeys = {}
    ESX.TriggerServerCallback('Sneakyesx_vehiclelock:allkey', function(mykey)
        for i = 1, #mykey, 1 do
			if mykey[i].NB == 1 then
				table.insert(getplayerkeys, {label = 'Clés : '.. ' [' .. mykey[i].plate .. ']', value = mykey[i].plate})
			elseif mykey[i].NB == 2 then
				table.insert(getplayerkeys, {label = '[DOUBLE] Véhicule : '.. ' [' .. mykey[i].plate .. ']', value = nil})
			end
		end
    end)
end

local stateStreet = false
function GetStreetLabel()
    print("Refresh state street !")
    return stateStreet
end

function OpenPersonalMenuRageUIMenu()

    if PersonalMenu.Menu then 
        PersonalMenu.Menu = false 
        RageUI.Visible(RMenu:Get('personalmenu', 'main'), false)
        return
    else
        RMenu.Add('personalmenu', 'main', RageUI.CreateMenu("", "", 0, 0,"root_cause","sneakylife"))
        RMenu.Add('personalmenu', 'inventory', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "main"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'inventory_use', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "inventory"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'wallet', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "main"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'weapon', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "main"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'keys', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "main"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'keysmanagement', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "keys"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'gestionveh', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "main"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'clothes', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "main"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'portefeuille_money', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "wallet"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'portefeuille_blackmoney', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "wallet"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'portefeuille_chip', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "wallet"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'papers', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "wallet"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'billing', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "wallet"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'vipmenu', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "main"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'vipped', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "vipmenu"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'vipweapontint', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "vipmenu"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'divers', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "main"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'propscivil', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "divers"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'props', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "vipmenu"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'object', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "props"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'object2', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "props"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'object3', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "props"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'object4', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "props"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'object5', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "propscivil"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'object6', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "propscivil"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'object7', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "props"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'objectlist', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "props"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'objectlistcivil', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "propscivil"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'limitateur', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "gestionveh"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'animals', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "vipped"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'females', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "vipped"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'males', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "vipped"),"", "~b~Menu personnel de votre personnage"))
        RMenu.Add('personalmenu', 'cutscenes', RageUI.CreateSubMenu(RMenu:Get("personalmenu", "vipped"),"", "~b~Menu personnel de votre personnage"))
        RMenu:Get('personalmenu', 'main'):SetSubtitle("~b~Menu personnel de votre personnage")
        RMenu:Get('personalmenu', 'main').EnableMouse = false
        RMenu:Get('personalmenu', 'main').Closed = function()
            PersonalMenu.Menu = false
        end
        PersonalMenu.Menu = true 
        RageUI.Visible(RMenu:Get('personalmenu', 'main'), true)
        Citizen.CreateThread(function()
            while ESX == nil do
                TriggerEvent('Sneakyesx:getSharedObject', function(obj)
                    ESX = obj
                end)
                ESX.PlayerData = ESX.GetPlayerData()
                Citizen.Wait(10)
            end
        
            while ESX.GetPlayerData().job == nil do
                Citizen.Wait(10)
            end
            if ESX.IsPlayerLoaded() then
                ESX.PlayerData = ESX.GetPlayerData()
            end        
			while PersonalMenu.Menu do
                RageUI.IsVisible(RMenu:Get('personalmenu', 'main'), true, false, true, function()
                    ESX.PlayerData = ESX.GetPlayerData()
                    pGrade = ESX.GetPlayerData().job.grade_name
                    pGrade2 = ESX.GetPlayerData().job2.grade_name
                    RageUI.Button("Inventaire", nil, { RightLabel = "→" },true, function()
                    end, RMenu:Get('personalmenu', 'inventory'))
                    RageUI.Button("Vêtement", nil, { RightLabel = "→" },true, function()
                    end, RMenu:Get('personalmenu', 'clothes'))
                    RageUI.Button("Portefeuille", nil, { RightLabel = "→" },true, function()
                    end, RMenu:Get('personalmenu', 'wallet'))
                    RageUI.Button("Gestion des armes", nil, { RightLabel = "→" },true, function(h,a,s)
                    end, RMenu:Get('personalmenu', 'weapon'))
                    RageUI.Button("Gestion des clés", nil, { RightLabel = "→" },true, function(h,a,s)
                        if s then
                            getvehicleskey()
                        end
                    end, RMenu:Get('personalmenu', 'keys'))
                    if IsPedSittingInAnyVehicle(PlayerPedId()) then
						RageUI.Button("Gestion du véhicule", nil, {RightLabel = "→"},true, function()
						end, RMenu:Get('personalmenu', 'gestionveh'))
					else
						RageUI.Button("Gestion du véhicule", nil, {RightBadge = RageUI.BadgeStyle.Lock},false, function()
						end)
					end
                    if vip == 1 or vip == 2 then  
                        RageUI.Button("VIP", nil, { RightLabel = "→" },true, function(h,a,s)
                            if s then
                            end
                        end,RMenu:Get("personalmenu","vipmenu"))
                    else
						RageUI.Button("VIP", nil, {RightBadge = RageUI.BadgeStyle.Lock},false, function()
						end)
					end
                    RageUI.Button("Divers", nil, { RightLabel = "→" },true, function(h,a,s)
                    end, RMenu:Get('personalmenu', 'divers'))
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'weapon'), true, false, true, function()
                    for i = 1, #WeaponData, 1 do
                        if HasPedGotWeapon(PlayerPedId(), WeaponData[i].hash, false) then
                            local ammo = GetAmmoInPedWeapon(PlayerPedId(), WeaponData[i].hash)
            
                            RageUI.Button(WeaponData[i].label, "Munition(s) : ~c~x"..ammo, {RightLabel = "~c~Donner~s~ →"}, true, function(h, a, s)
                                if s then
                                    if blackListWeapon[WeaponData[i].name] then
                                        ESX.ShowNotification("~r~Erreur~s~~n~Vous ne pouvez pas donner cette arme !")
                                        return
                                    else
                                        local playerdst, distance = ESX.Game.GetClosestPlayer()
                                        if playerdst ~= -1 and distance <= 2.0 then
                                            local closestPed = GetPlayerPed(playerdst)
                                            if IsPedOnFoot(closestPed) then
                                                local ammo = GetAmmoInPedWeapon(PlayerPedId(), WeaponData[i].hash)
                                                SneakyEvent('Sneakyesx:giveInventoryItem', GetPlayerServerId(playerdst), "item_weapon", WeaponData[i].name, ammo)
                                                RageUI.CloseAll()
                                                PersonalMenu.Menu = false
                                            else
                                            RageUI.Popup({message = "~r~Impossible~s~ de donner une arme dans un véhicule."})
                                            end
                                        else
                                            ESX.ShowNotification("~r~Personne autour de vous !")
                                        end             
                                    end
                                end
                            end)
                        end
                    end
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'keys'), true, false, true, function()
                    for k,v in pairs(getplayerkeys) do
                        RageUI.Button(v.label, nil, {RightLabel = ""}, true, function(h,a,s)  
                            if s then
                                v.value = actualvalue
                            end
                        end,RMenu:Get("personalmenu","keysmanagement"))
                    end
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'clothes'), true, false, true, function()
                    RageUI.Separator("~b~Gestion des vêtements~s~ ↓")

                    RageUI.Button("Haut", nil, { RightBadge = RageUI.BadgeStyle.Clothes }, true,function(h,a,s)
                        if s then
                            TriggerEvent("jMenu:requestClothes", "haut")
                        end
                    end)
                    RageUI.Button("Bas", nil, { RightBadge = RageUI.BadgeStyle.Clothes }, true,function(h,a,s)
                        if s then
                            TriggerEvent("jMenu:requestClothes", "bas")
                        end
                    end)
                    RageUI.Button("Chaussures", nil, { RightBadge = RageUI.BadgeStyle.Clothes }, true,function(h,a,s)
                        if s then
                            TriggerEvent("jMenu:requestClothes", "chaussures")
                        end
                    end)
                    RageUI.Button("Sac", nil, { RightBadge = RageUI.BadgeStyle.Clothes }, true,function(h,a,s)
                        if s then
                            TriggerEvent("jMenu:requestClothes", "sac")
                        end
                    end)
                    RageUI.Button("Gilet par Balles", nil, { RightBadge = RageUI.BadgeStyle.Clothes }, true,function(h,a,s)
                        if s then
                            TriggerEvent("jMenu:requestClothes", "gilet")
                        end
                    end)

                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'keysmanagement'), true, false, true, function()
                    local playerPed = PlayerPedId()
                    local pos = GetEntityCoords(PlayerPedId())
                    local vehicle, dst = ESX.Game.GetClosestVehicle({x = pos.x, y = pos.y, z = pos.z})
                    local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
                    local vehPlate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
                    local player, distance = ESX.Game.GetClosestPlayer()
                    RageUI.Button("Donner le véhicule/clés", nil, {RightLabel = ""}, true, function(h,a,s)  
                        if s then
							if distance ~= -1 and distance <= 3.0 then
								TriggerServerEvent('Sneakyesx_vehiclelock:changeowner', GetPlayerServerId(player), vehPlate, vehicleProps)
							else
								ESX.ShowNotification("Aucun joueur à proximité")
							end
                        end
                    end)
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'divers'), true, false, true, function()
                    RageUI.Checkbox("Cacher HUD", nil, hudActive, { Style = RageUI.CheckboxStyle.Tick }, function(h, s, a, c)
                        hudActive = c;
                        end, function()
                        DisplayRadar(false)
                        TriggerEvent("SneakyLife:HideHungerAndThirst",false)
                        TriggerEvent("SneakyLife:RequestVariable",true)
                        TriggerEvent("SneakyLife:RequestHud",true)
                        end, function()
                        DisplayRadar(true)
                        TriggerEvent("SneakyLife:HideHungerAndThirst",true)
                        TriggerEvent("SneakyLife:RequestVariable",false)
                        TriggerEvent("SneakyLife:RequestHud",false)
                    end)
                    RageUI.Checkbox("Rechercher des clients (Drogues)", nil, pnjVente, {Style = RageUI.CheckboxStyle.Tick}, function(h, a, s, c)
                        pnjVente = c;
                        end, function()
                            TriggerEvent("neo:ActivDrugsSell", true)
                        end, function()
                            TriggerEvent("neo:ActivDrugsSell", false)
                    end)
                    RageUI.Checkbox("Lampe torche toujours allumé", nil, flashlightActive, {Style = RageUI.CheckboxStyle.Tick}, function(h, a, s, c)
                        flashlightActive = c;
                        end, function()
                        SetFlashLightKeepOnWhileMoving(true)
                        end, function()
                            SetFlashLightKeepOnWhileMoving(false)
                    end)
                    RageUI.Button("Props", nil, { RightLabel = "→" }, true, function(h,a,s)
                    end, RMenu:Get('personalmenu', 'propscivil'))
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'propscivil'), true, false, true, function()
                    if ESX.PlayerData.job.name == "police" or ESX.PlayerData.job.name == "lssd" or ESX.PlayerData.job.name == "ambulance" then
                        RageUI.Button("EMS", "Poser des objets", { RightLabel = "→" }, true, function(h,a,s)
                        end, RMenu:Get('personalmenu', 'object6'))
                        RageUI.Button("LSPD/LSSD", "Poser des objets", { RightLabel = "→" }, true, function(h,a,s)
                        end, RMenu:Get('personalmenu', 'object5'))
                        RageUI.Button("~r~Mode suppression", "Supprimer les objets posées", { RightLabel = "" }, true, function(h,a,s)
                        end, RMenu:Get('personalmenu', 'objectlistcivil'))
                    end
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'props'), true, false, true, function()
					if vip == 2 or vip == 1 and not IsPedInAnyVehicle(PlayerPedId(),false) then
                        if ESX.PlayerData.job.name ~= "unemployed" then
                            RageUI.Button("Civil", "Poser des objets", { RightLabel = "→" }, true, function(h,a,s)
                            end, RMenu:Get('personalmenu', 'object'))
                        end 
                        if ESX.PlayerData.job2.name ~= "unemployed" then
                            RageUI.Button("Gang", "Poser des objets", { RightLabel = "→" }, true, function(h,a,s)
                            end, RMenu:Get('personalmenu', 'object2'))
                        end
                        if ESX.PlayerData.job2.name ~= "unemployed" then
                            RageUI.Button("Drogues", "Poser des objets", { RightLabel = "→" }, true, function(h,a,s)
                            end, RMenu:Get('personalmenu', 'object3'))
                        end
                        if ESX.PlayerData.job2.name ~= "unemployed" then
                            RageUI.Button("Armes", "Poser des objets", { RightLabel = "→" }, true, function(h,a,s)
                            end, RMenu:Get('personalmenu', 'object4'))
                        end
                        RageUI.Button("~r~Mode suppression", "Supprimer les objets posées", { RightLabel = "" }, true, function(h,a,s)
                        end, RMenu:Get('personalmenu', 'objectlist'))
                    end
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'objectlistcivil'), true, false, true, function()
                    for k,v in pairs(object) do
						if GoodName(GetEntityModel(NetworkGetEntityFromNetworkId(v))) == 0 then table.remove(object, k) end
						RageUI.Button("Object: "..GoodName(GetEntityModel(NetworkGetEntityFromNetworkId(v))).." ["..v.."]", nil, {}, true, function(h,a,s)
							if a then
								local entity = NetworkGetEntityFromNetworkId(v)
								local ObjCoords = GetEntityCoords(entity)
								DrawMarker(2, ObjCoords.x, ObjCoords.y, ObjCoords.z+1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 170, 1, 0, 2, 1, nil, nil, 0)
							end
							if s then
								RemoveObj(v, k)
							end
						end)
					end
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'object2'), true, true, true, function()
					RageUI.Button("Chaise", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_weed_chair_01a")
						end
					end)
		
					RageUI.Button("Sac pour arme", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("prop_gun_case_01")
						end
					end)
		
					
					RageUI.Button("Prop meth", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_meth_pseudoephedrine")
						end
					end)
					
					RageUI.Button("Sac de meth ouvert", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_meth_openbag_01a")
						end
					end)
					
					RageUI.Button("Gros sac de meth", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_meth_bigbag_04a")
						end
					end)
					
					RageUI.Button("Gros sac de weed", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_weed_bigbag_03a")
						end
					end)
					
					RageUI.Button("Weed plante", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_weed_01_small_01a")
						end
					end)
					
					RageUI.Button("Weed", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_weed_dry_02b")
						end
					end)
					
					RageUI.Button("Table de weed", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_weed_table_01a")
						end
					end)
					
					RageUI.Button("Cash", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("hei_prop_cash_crate_half_full")
						end
					end)
					
					RageUI.Button("Valise de cash", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("prop_cash_case_02")
						end
					end)
					
					RageUI.Button("Petite pile de cash", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("prop_cash_crate_01")
						end
					end)
					
					RageUI.Button("Poubelle", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("prop_cs_dumpster_01a")
						end
					end)
					
					RageUI.Button("Canapé", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("v_tre_sofa_mess_c_s")
						end
					end)
					
					RageUI.Button("Canapé 2", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("v_res_tre_sofa_mess_a")
						end
					end)
					
					RageUI.Button("Pile de cash", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_bkr_cashpile_04")
						end
					end)
					
					RageUI.Button("Pile de cash 2", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_bkr_cashpile_05")
						end
					end)
					
					RageUI.Button("Block de coke", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_coke_block_01a")
						end
					end)
					
					RageUI.Button("Coke en bouteille", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_coke_bottle_01a")
						end
					end)
					
					RageUI.Button("Coke coupé", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_coke_cut_01")
						end
					end)
		
					RageUI.Button("Bol de coke", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_coke_fullmetalbowl_02")
						end
					end)
				end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'object3'), true, true, true, function()
					RageUI.Button("Cocaine Block", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_coke_block_01a")
						end
					end)
		
					RageUI.Button("Cocaine Pallet", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_coke_pallet_01a")
						end
					end)
		
					
					RageUI.Button("Balance Cocaine", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_coke_scale_01")
						end
					end)
		
					
					RageUI.Button("Spatule Cocaine", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_coke_spatula_04")
						end
					end)
		
					
					RageUI.Button("Table Cocaine", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_coke_table01a")
						end
					end)
		
					
					RageUI.Button("Caisse", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_crate_set_01a")
						end
					end)
					
					RageUI.Button("Palette Weed", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_fertiliser_pallet_01a")
						end
					end)
					
					RageUI.Button("Palette 1", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_fertiliser_pallet_01b")
						end
					end)
					
					RageUI.Button("Palette 2", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_fertiliser_pallet_01c")
						end
					end)
					
					RageUI.Button("Palette 3", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_fertiliser_pallet_01d")
						end
					end)
					
					RageUI.Button("Acetone Meth", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_meth_acetone")
						end
					end)
					
					RageUI.Button("Bidon Meth", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_meth_ammonia")
						end
					end)
					
					RageUI.Button("Bac Meth", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_meth_bigbag_01a")
						end
					end)
					
					RageUI.Button("Bac Meth 2", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_meth_bigbag_02a")
						end
					end)
					
					RageUI.Button("Bac Meth 3", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_meth_bigbag_03a")
						end
					end)
					
					RageUI.Button("Lithium Meth", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_meth_lithium")
						end
					end)
					
					RageUI.Button("Phosphorus Meth", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_meth_phosphorus")
						end
					end)
					
					RageUI.Button("Pseudoephedrine", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_meth_pseudoephedrine")
						end
					end)
					
					RageUI.Button("Meth Smash", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_meth_smashedtray_01")
						end
					end)
					
					RageUI.Button("Machine a sous", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_money_counter")
						end
					end)
					
					RageUI.Button("Acetone Meth", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_meth_acetone")
						end
					end)
					
					RageUI.Button("Pot Weed", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_weed_01_small_01b")
						end
					end)
					
					RageUI.Button("Packet Weed", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_weed_bigbag_03a")
						end
					end)
					
					RageUI.Button("Packet Weed Ouvert", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_weed_bigbag_open_01a")
						end
					end)
					
					RageUI.Button("Pot Weed 2", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_weed_bucket_01d")
						end
					end)
					
					RageUI.Button("Weed", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_weed_drying_01a")
						end
					end)
					
					RageUI.Button("Weed Plante", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_weed_lrg_01b")
						end
					end)
					
					RageUI.Button("Weed Plante 2", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_weed_med_01b")
						end
					end)
					
					RageUI.Button("Table Weed", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_weed_drying_01a")
						end
					end)
					
					RageUI.Button("Weed Pallet", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("hei_prop_heist_weed_pallet")
						end
					end)
		
					RageUI.Button("Coke", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("imp_prop_impexp_boxcoke_01")
						end
					end)
				end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'object4'), true, true, true, function()
					RageUI.Button("Malette Armes", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_biker_gcase_s")
						end
					end)
					RageUI.Button("Caisse Batteuses", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("ex_office_swag_guns04")
						end
					end)
					RageUI.Button("Caisse Armes", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("ex_prop_crate_ammo_bc")
						end
					end)
					RageUI.Button("Caisse Batteuses 2", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("ex_prop_crate_ammo_sc")
						end
					end)
					RageUI.Button("Caisse Fermé", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("ex_prop_adv_case_sm_03")
						end
					end)
					RageUI.Button("Petite Caisse", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("ex_prop_adv_case_sm_flash")
						end
					end)
					RageUI.Button("Caisse Explosif", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("ex_prop_crate_expl_bc")
						end
					end)
					RageUI.Button("Caisse Vetements", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("ex_prop_crate_expl_sc")
						end
					end)
					RageUI.Button("Caisse Chargeurs", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("gr_prop_gr_crate_mag_01a")
						end
					end)
					RageUI.Button("Grosse Caisse Armes", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("gr_prop_gr_crates_rifles_01a")
						end
					end)
					RageUI.Button("Grosse Caisse Armes 2", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("gr_prop_gr_crates_weapon_mix_01a")
						end
					end)
				end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'object5'), true, true, true, function()
					RageUI.Button("Cone", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("prop_roadcone02a")
						end
					end)
		
					RageUI.Button("Barrière", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("prop_barrier_work05")
						end
					end)
		
					RageUI.Button("Éclairage", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("prop_worklight_01a")
						end
					end)
		
					RageUI.Button("Gazebo", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("prop_gazebo_02")
						end
					end)
				end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'object6'), true, true, true, function()
					RageUI.Button("Sac mortuaire", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("xm_prop_body_bag")
						end
					end)
		
					RageUI.Button("Trousse médical 1", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("xm_prop_smug_crate_s_medical")
						end
					end)
		
					RageUI.Button("Trousse médical 2", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("xm_prop_x17_bag_med_01a")
						end
					end)
                    RageUI.Button("Table", nil, {}, true, function(h,a,s)
                        if s then
                            SpawnObj("prop_table_04")
                        end
                    end)
                    RageUI.Button("Chaise", nil, {}, true, function(h,a,s)
                        if s then
                            SpawnObj("prop_chair_08")
                        end
                    end)
                    RageUI.Button("barriere EMS", nil, {}, true, function(h,a,s)
                        if s then
                            SpawnObj("prop_barrier_work06a")
                        end
                    end)
				end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'object7'), true, true, true, function()
                    RageUI.Button("Balise maritime", nil, {}, true, function(h,a,s)
                        if s then
                            SpawnObj("prop_dock_bouy_1")
                        end
                    end)
                    RageUI.Button("Décoration enterrement", nil, {}, true, function(h,a,s)
                        if s then
                            SpawnObj("prop_road_memorial_02")
                        end
                    end)
                    RageUI.Button("Platine", nil, {}, true, function(h,a,s)
                        if s then
                            SpawnObj("v_club_vu_deckcase")
                        end
                    end)
                    RageUI.Button("Lumière", nil, {}, true, function(h,a,s)
                        if s then
                            SpawnObj("prop_studio_light_01")
                        end
                    end)
                    RageUI.Button("Panneau gauche", nil, {}, true, function(h,a,s)
                        if s then
                            SpawnObj("prop_offroad_bale03")
                        end
                    end)
                    RageUI.Button("Panneau droite", nil, {}, true, function(h,a,s)
                        if s then
                            SpawnObj("prop_offroad_bale02")
                        end
                    end)
                    RageUI.Button("Enceinte", nil, {}, true, function(h,a,s)
                        if s then
                            SpawnObj("prop_speaker_07")
                        end
                    end)
                    RageUI.Button("Table de camping", nil, {}, true, function(h,a,s)
                        if s then
                            SpawnObj("prop_table_para_comb_05")
                        end
                    end)
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'objectlist'), true, false, true, function()
                    for k,v in pairs(object) do
						if GoodName(GetEntityModel(NetworkGetEntityFromNetworkId(v))) == 0 then table.remove(object, k) end
						RageUI.Button("Object: "..GoodName(GetEntityModel(NetworkGetEntityFromNetworkId(v))).." ["..v.."]", nil, {}, true, function(h,a,s)
							if a then
								local entity = NetworkGetEntityFromNetworkId(v)
								local ObjCoords = GetEntityCoords(entity)
								DrawMarker(2, ObjCoords.x, ObjCoords.y, ObjCoords.z+1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 170, 1, 0, 2, 1, nil, nil, 0)
							end
							if s then
								RemoveObj(v, k)
							end
						end)
					end
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'object'), true, false, true, function()
                    RageUI.Button("Chaise", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("apa_mp_h_din_chair_12")
						end
					end)
		
					RageUI.Button("Outils", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("prop_cs_trolley_01")
						end
					end)
		
					RageUI.Button("Carton", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("prop_cardbordbox_04a")
						end
					end)
					RageUI.Button("Outils mecano", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("prop_carcreeper")
						end
					end)
					RageUI.Button("Sac", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("prop_cs_heist_bag_02")
						end
					end)
					RageUI.Button("Table", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("apa_mp_h_din_table_06")
						end
					end)
					RageUI.Button("Chaise", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_clubhouse_chair_01")
						end
					end)
					RageUI.Button("Ordinateur", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_clubhouse_laptop_01a")
						end
					end)
					RageUI.Button("Chaise Bureau", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("bkr_prop_clubhouse_offchair_01a")
						end
					end)
					RageUI.Button("Lit Bunker", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("gr_prop_bunker_bed_01")
						end
					end)
					RageUI.Button("Lit Biker", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("gr_prop_gr_campbed_01")
						end
					end)
					RageUI.Button("Chaise Peche", nil, {}, true, function(h,a,s)
						if s then
							SpawnObj("hei_prop_hei_skid_chair")
						end
					end)
                    RageUI.Button("Fauteil", nil, {}, true, function(h,a,s)
                        if s then
                            SpawnObj("prop_sol_chair")
                        end
                    end)
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'vipmenu'), true, false, true, function()
                    RageUI.Button("Se transformer en ped", nil, { RightLabel = "→" },true, function(h,a,s)
                    end,RMenu:Get("personalmenu","vipped"))
                    RageUI.Button("Teintures armes", nil, { RightLabel = "→" },true, function(h,a,s)
                    end,RMenu:Get("personalmenu","vipweapontint"))
                    if vip == 1 or vip == 2 and not IsPedInAnyVehicle(PlayerPedId(),false) then
                        RageUI.Button("Props", nil, { RightLabel = "→" },true, function(h,a,s)
                        end, RMenu:Get('personalmenu', 'props'))
                    else
                        RageUI.Button("Props", nil, {RightBadge = RageUI.BadgeStyle.Lock},false, function()
                        end)
                    end
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'vipweapontint'), true, false, true, function()
                    if IsPedArmed(GetPlayerPed(-1), 7) then
                        local _,pWeapon = GetCurrentPedWeapon(GetPlayerPed(-1), 0)
                        local count = GetWeaponTintCount(pWeapon)
                       
                        for i = 0, count - 1 do
                            RageUI.Button("Teinture d'arme n°"..i, nil,{RightLabel = ""}, true, function(_,h,s)
                                if s then
                                    SetPedWeaponTintIndex(GetPlayerPed(-1), pWeapon, i)
                                end
                                if h then
                                    if GetPedWeaponTintIndex(GetPlayerPed(-1), pWeapon) ~= i then
                                        SetPedWeaponTintIndex(GetPlayerPed(-1), pWeapon, i)
                                    end
                                end
                            end)
                        end
                    else
                        RageUI.Separator("")
                        RageUI.Separator("~r~Tu a besoin d'une arme")
                        RageUI.Separator("")
                    end
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'vipped'), true, false, true, function()
                    RageUI.Button("Reprendre son personnage", nil, {RightLabel = "~b~Reprendre ~s~→"}, true, function(h,a,s)
                        if s then
                            bloquerpedanimaux = false
                            ESX.TriggerServerCallback('Sneakyesx_skin:getPlayerSkin', function(skin, jobSkin)
                                local isMale = skin.sex == 0
                                TriggerEvent('Sneakyskinchanger:loadDefaultModel', isMale, function()
                                    ESX.TriggerServerCallback('Sneakyesx_skin:getPlayerSkin', function(skin)
                                        local ped = PlayerPedId()
                                        TriggerEvent('Sneakyskinchanger:loadSkin', skin)
                                        TriggerEvent('Sneakyesx:restoreLoadout')
                                        ESX.ShowNotification('~b~VIP\n~s~Vous avez bien repris votre personnage')
                                end)
                                    end)
                            end)
                        end
                    end)
                    RageUI.Button("Animaux", nil, { RightLabel = "→" },true, function(h,a,s)
                    end,RMenu:Get("personalmenu","animals"))
                    RageUI.Button("Femmes", nil, { RightLabel = "→" },true, function(h,a,s)
                    end,RMenu:Get("personalmenu","females"))
                    RageUI.Button("Hommes", nil, { RightLabel = "→" },true, function(h,a,s)
                    end,RMenu:Get("personalmenu","males"))
                    RageUI.Button("All Peds", nil, { RightLabel = "→" },true, function(h,a,s)
                    end,RMenu:Get("personalmenu","cutscenes"))
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'animals'), true, false, true, function()
                    for k,v in pairs(pedanimals) do 
                        RageUI.Button(v.label, nil, {RightLabel = "~b~Mettre ~s~→"}, true, function(h,a,s)
                            if s then
                                bloquerpedanimaux = true
                                modelHash = GetHashKey(v.model)
                                ESX.Streaming.RequestModel(modelHash, function()
                                    SetPlayerModel(PlayerId(), modelHash)
                                    SetModelAsNoLongerNeeded(modelHash)
                                    SetPedDefaultComponentVariation(PlayerPedId())
                                    TriggerEvent('Sneakyesx:restoreLoadout')
                                end)
                            end
                        end)
                    end
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'females'), true, false, true, function()
                    for k,v in pairs(pedfemale) do 
                        RageUI.Button(v.label, nil, {RightLabel = "~b~Mettre ~s~→"}, true, function(h,a,s)
                            if s then
                                modelHash = GetHashKey(v.model)
                                ESX.Streaming.RequestModel(modelHash, function()
                                    SetPlayerModel(PlayerId(), modelHash)
                                    SetModelAsNoLongerNeeded(modelHash)
                                    SetPedDefaultComponentVariation(PlayerPedId())
                                    TriggerEvent('Sneakyesx:restoreLoadout')
                                end)
                            end
                        end)
                    end
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'males'), true, false, true, function()
                    for k,v in pairs(pedmale) do 
                        RageUI.Button(v.label, nil, {RightLabel = "~b~Mettre ~s~→"}, true, function(h,a,s)
                            if s then
                                modelHash = GetHashKey(v.model)
                                ESX.Streaming.RequestModel(modelHash, function()
                                    SetPlayerModel(PlayerId(), modelHash)
                                    SetModelAsNoLongerNeeded(modelHash)
                                    SetPedDefaultComponentVariation(PlayerPedId())
                                    TriggerEvent('Sneakyesx:restoreLoadout')
                                end)
                            end
                        end)
                    end
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'cutscenes'), true, false, true, function()
                    for k,v in pairs(pedall) do 
                        RageUI.Button(v.label, nil, {RightLabel = "~b~Mettre ~s~→"}, true, function(h,a,s)
                            if s then
                                modelHash = GetHashKey(v.model)
                                ESX.Streaming.RequestModel(modelHash, function()
                                    SetPlayerModel(PlayerId(), modelHash)
                                    SetModelAsNoLongerNeeded(modelHash)
                                    SetPedDefaultComponentVariation(PlayerPedId())
                                    TriggerEvent('Sneakyesx:restoreLoadout')
                                end)
                            end
                        end)
                    end
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'limitateur'), true, false, true, function()
                    RageUI.Button("Vitesse :~r~ par défault" , nil, {RightLabel = "→"}, true, function(h, a, s)
                        if s then
                            speedlimitateur = false
                            SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 1000.0/3.6)
                            ESX.ShowNotification('Vitesse par ~b~défault.')
                        end
                    end)
                    RageUI.Button("Vitesse :~g~ 50 km" , nil, {RightLabel = "→"}, true, function(h, a, s)
                        if s then
                            --SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 50.0/3.6)
                            speedlimitateur = true
                            speedlimited = 50
                            ESX.ShowNotification('Vitesse fixé à ~b~50~s~km/h.')
                        end
                    end)
                    RageUI.Button("Vitesse :~g~ 80 km" , nil, {RightLabel = "→"}, true, function(h, a, s)
                        if s then
                            speedlimitateur = true
                            speedlimited = 80
                            --SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 80.0/3.6)
                            ESX.ShowNotification('Vitesse fixé à ~b~80~s~km/h.')
                        end
                    end)
                    RageUI.Button("Vitesse :~g~ 120 km" , nil, {RightLabel = "→"}, true, function(h, a, s)
                        if s then
                            speedlimitateur = true
                            speedlimited = 120
                            --SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 120.0/3.6)
                            ESX.ShowNotification('Vitesse fixé à ~b~120~s~km/h.')
                        end
                    end)
                    RageUI.Button("Vitesse :~g~ 150 km" , nil, {RightLabel = "→"}, true, function(h, a, s)
                        if s then
                            speedlimitateur = true
                            speedlimited = 150
                            --SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 150.0/3.6)
                            ESX.ShowNotification('Vitesse fixé à ~b~150~s~km/h.')
                        end
                    end)
                    RageUI.Button("Vitesse :~g~ 180 km" , nil, {RightLabel = "→"}, true, function(h, a, s)
                        if s then
                            speedlimitateur = true
                            speedlimited = 180
                            --SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 180.0/3.6)
                            ESX.ShowNotification('Vitesse fixé à ~b~180~s~km/h.')
                        end
                    end)
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'gestionveh'), true, false, true, function()
                    if IsPedSittingInAnyVehicle(PlayerPedId()) then
                        RageUI.Button("Limitateur" , nil, {RightLabel = "→"}, true, function(h, a, s)
						end, RMenu:Get('personalmenu', 'limitateur'))

                        RageUI.List("Action moteur", PersonalMenu.engineActionList, PersonalMenu.engineActionIndex, nil, {}, not engineCoolDown, function(h,a,s, Index)
                            if s then        
                                if Index == 1 then
                                    SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId(),false),true,true,false)
                                else
                                    SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId(),false),false,true,true)
                                end
                                engineCoolDown = true
                                Citizen.SetTimeout(1000, function()
                                    engineCoolDown = false
                                end)
                            end
                
                            PersonalMenu.engineActionIndex = Index
                        end)
                        --if ESX.PlayerData.job.label == "Police" then
                            RageUI.List("Extra du véhicule", extraList, extraIndex, nil, {}, true, function(h,a,s, Index)
                                if s then
                                    if isAllowedToManageVehicle() then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
                                        if not vehicleIsDamaged() then
                                            if Index == 1 then
                                                SetVehicleExtra(vehicle,1)
                                                ESX.Game.SetVehicleProperties(vehicle, {
                                                    modFender = 0
                                                })
                                                TriggerEvent('persistent-vehicles/update-vehicle', vehicle)
                                            elseif Index == 2 then
                                                SetVehicleExtra(vehicle,2)
                                            elseif Index == 3 then
                                                SetVehicleExtra(vehicle,3)
                                            elseif Index == 4 then
                                                SetVehicleExtra(vehicle,4)
                                            elseif Index == 5 then
                                                SetVehicleExtra(vehicle,5)
                                            elseif Index == 6 then
                                                SetVehicleExtra(vehicle,6)
                                            elseif Index == 7 then
                                                SetVehicleExtra(vehicle,7)
                                            elseif Index == 8 then
                                                SetVehicleExtra(vehicle,8)
                                            elseif Index == 9 then
                                                SetVehicleExtra(vehicle,9)
                                            elseif Index == 10 then
                                                SetVehicleExtra(vehicle,10)
                                            elseif Index == 11 then
                                                SetVehicleExtra(vehicle,11)
                                            elseif Index == 12 then
                                                SetVehicleExtra(vehicle,12)
                                            elseif Index == 13 then
                                                SetVehicleExtra(vehicle,13)
                                            elseif Index == 14 then
                                                SetVehicleExtra(vehicle,14)
                                            elseif Index == 15 then
                                                SetVehicleExtra(vehicle,15)
                                            end
                                        end
                                    end
                                end
                                extraIndex = Index
                            end)
                            RageUI.Button("Extra ~g~ON", nil, {}, not extraCooldown, function(_,_,s)
                                if s then
                                    if isAllowedToManageVehicle() then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
                                        if not vehicleIsDamaged() then
                                            SetVehicleExtra(vehicle,extraIndex,0)
                                            ESX.Game.SetVehicleProperties(vehicle, {
                                                modFender = 0
                                            })
                                            TriggerEvent('persistent-vehicles/update-vehicle', vehicle)
                                            extraCooldown = true
                                            Citizen.SetTimeout(150, function()
                                                extraCooldown = false
                                            end)
                                        else
                                            ESX.ShowNotification("Ton véhicule est trop endommagé pour pouvoir y apporter des modificiations.")
                                        end
                                    end  
                                end
                            end)
            
                            RageUI.Button("Extra ~r~OFF", nil, {}, not extraCooldown, function(_,_,s)
                                if s then
                                    if isAllowedToManageVehicle() then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
                                        if not vehicleIsDamaged() then
                                            SetVehicleExtra(vehicle,extraIndex,1)
                                            ESX.Game.SetVehicleProperties(vehicle, {
                                                modFender = 1
                                            })
                                            TriggerEvent('persistent-vehicles/update-vehicle', vehicle)
                                            extraCooldown = true
                                            Citizen.SetTimeout(150, function()
                                                extraCooldown = false
                                            end)
                                        else
                                            ESX.ShowNotification("Ton véhicule est trop endommagé pour pouvoir y apporter des modificiations.")
                                        end
                                    end  
                                end
                            end)
                            RageUI.List("Tous les extras", {"Activer","Désactiver"}, extraStateIndex, nil, {}, not extraCooldown, function(h,a,s, Index)
                                if s then
                                    if isAllowedToManageVehicle() then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
                                        if not vehicleIsDamaged() then
                                            if Index == 1 then
                                                for index,_ in pairs(extraList) do
                                                    SetVehicleExtra(vehicle,index,0)
                                                end
                                            else
                                                for index,_ in pairs(extraList) do
                                                    SetVehicleExtra(vehicle,index,1)
                                                end
                                            end
                                            extraCooldown = true
                                            Citizen.SetTimeout(150, function()
                                                extraCooldown = false
                                            end)
                                        else
                                            ESX.ShowNotification("Ton véhicule est trop endommagé pour pouvoir y apporter des modificiations.")
                                        end
                                    end
                                end
                                extraStateIndex = Index
                            end)
                            
                        --end
                        RageUI.List("Action portes", {"Ouvrir","Fermer"}, doorActionIndex, nil, {}, true, function(h,a,s, Index)
                            doorActionIndex = Index
                        end)
        
                        RageUI.Button("Tout le véhicule", nil, {}, not doorCoolDown, function(_,_,s)
                            if s then
                                if isAllowedToManageVehicle() then doorAction(-1) end
                            end
                        end)
        
                        RageUI.Button("Porte avant-gauche", nil, {}, not doorCoolDown, function(_,_,s)
                            if s then
                                if isAllowedToManageVehicle() then doorAction(0) end 
                            end
                        end)
        
                        RageUI.Button("Porte avant-droite", nil, {}, not doorCoolDown, function(_,_,s)
                            if s then
                                if isAllowedToManageVehicle() then doorAction(1) end 
                            end
                        end)
        
                        RageUI.Button("Porte arrière-gauche", nil, {}, not doorCoolDown, function(_,_,s)
                            if s then
                                if isAllowedToManageVehicle() then doorAction(2) end 
                            end
                        end)
        
                        RageUI.Button("Porte arrière-droite", nil, {}, not doorCoolDown, function(_,_,s)
                            if s then
                                if isAllowedToManageVehicle() then doorAction(3) end 
                            end
                        end)
        
                        RageUI.Button("Capot", nil, {}, not doorCoolDown, function(_,_,s)
                            if s then
                                if isAllowedToManageVehicle() then doorAction(4) end 
                            end
                        end)
        
                        RageUI.Button("Coffre", nil, {}, not doorCoolDown, function(_,_,s)
                            if s then
                                if isAllowedToManageVehicle() then doorAction(5) end
                            end
                        end)
                    else
                        RageUI.GoBack()
                    end
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'inventory'), true, false, true, function()
                    ESX.PlayerData = ESX.GetPlayerData()
                    RageUI.Separator("~b~Inventaire~s~ ".. GetCurrentWeight().." / "..ESX.PlayerData.maxWeight..".0")
                    for i = 1, #ESX.PlayerData.inventory, 1 do
                        if ESX.PlayerData.inventory[i].count > 0 then
                            local invCount = {}

                            for i = 1, ESX.PlayerData.inventory[i].count, 1 do
                                table.insert(invCount, i)
                            end

                            RageUI.Button(ESX.PlayerData.inventory[i].label .. ' ~b~(' .. ESX.PlayerData.inventory[i].count .. ')~s~', nil, {}, true, function(h, a, s)
                                if s then
                                    ItemSelected = ESX.PlayerData.inventory[i]
                                end
                            end, RMenu:Get('personalmenu', 'inventory_use'))
                        end
                    end
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'inventory_use'), true, false, true, function()
                    RageUI.Separator(ItemSelected.label.." ~b~("..ItemSelected.count..")")
                    RageUI.Button("Utiliser", nil, {}, true, function(h, a, s)
                        if s then
                            SneakyEvent('Sneakyesx:useItem', ItemSelected.name)
                        end
                    end)
                    RageUI.Button("Donner", nil, {}, true, function(h, a, s)
                        if a then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestPlayer ~= -1 and closestDistance <= 3 then
                                playerMarker(closestPlayer)
                            end
                        end
                        if s then
                            local sonner,quantity = CheckQuantity(CustomAmount())
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            local pPed = GetPlayerPed(-1)
                            local coords = GetEntityCoords(pPed)
                            local x,y,z = table.unpack(coords)
                            if sonner then
                                if closestDistance ~= -1 and closestDistance <= 3 then
                                    local closestPed = GetPlayerPed(closestPlayer)

                                    if IsPedOnFoot(closestPed) then
                                        SneakyEvent('Sneakyesx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_standard', ItemSelected.name, quantity)
                                    else
                                        ESX.ShowNotification("~b~Menu personnel~s~\nvous ne pouvez pas donner d'item en étant dans une voiture")
                                    end
                                else
                                    ESX.ShowNotification("~r~Erreur\n~s~Aucun joueur à proximité !")
                                end
                            end
                        end
                    end) 
                    RageUI.Button("Jeter", nil, {}, true, function(h,a,s)
                        if s then
                            local sonner,quantity = CheckQuantity(CustomAmount())
                            if sonner then
                                if IsPedInAnyVehicle(PlayerPedId(), true) then
                                    ESX.ShowNotification("~r~Erreur~s~\nvous ne pouvez pas jeter d'item en étant dans une voiture")
                                else
                                    SneakyEvent('Sneakyesx:dropInventoryItem', 'item_standard', ItemSelected.name, quantity)
                                    RageUI.GoBack()
                                end
                            else
                                ESX.ShowNotification("~r~Erreur\n~s~Valeur incorrect")
                            end
                        end
                    end) 
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'wallet'), true, false, true, function()
                    ESX.PlayerData = ESX.GetPlayerData()
                    for i = 1, #ESX.PlayerData.accounts, 1 do
                        if ESX.PlayerData.accounts[i].name == 'cash'  then
                            cash = RageUI.Button('Argent liquide :', description, {RightLabel = "~g~"..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money.." ~g~$")}, true, function(h, a, s) 
                            end, RMenu:Get('personalmenu', 'portefeuille_money'))
                        end
                    end
            
                    for i = 1, #ESX.PlayerData.accounts, 1 do
                        if ESX.PlayerData.accounts[i].name == 'bank'  then
                            bank = RageUI.Button('Banque :', description, {RightLabel = "~b~"..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money.." ~b~$")}, true, function(h, a, s) 
                                if s then
                                    ESX.ShowNotification("~b~Menu personnel~s~\nMerci de vous rendre dans une banque")
                                end 
                            end)
                            for i = 1, #ESX.PlayerData.accounts, 1 do
                                if ESX.PlayerData.accounts[i].name == 'chip'  then
                                    sale = RageUI.Button('Vos jetons :', description, {RightLabel = "~o~"..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money)}, true, function() 
                                    end, RMenu:Get('personalmenu', 'portefeuille_chip'))
                                end
                            end
                            for i = 1, #ESX.PlayerData.accounts, 1 do
                                if ESX.PlayerData.accounts[i].name == 'dirtycash'  then
                                    sale = RageUI.Button('Source inconnue :', description, {RightLabel = "~c~"..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money.." ~c~$")}, true, function() 
                                    end, RMenu:Get('personalmenu', 'portefeuille_blackmoney'))
                                end
                            end
                        end
                    end
                    RageUI.Button("Papiers", nil, { RightLabel = "→" },true, function()
                    end, RMenu:Get('personalmenu', 'papers'))
                    RageUI.Button("Facture", nil, { RightLabel = "→" },true, function(h,a,s)
                        if s then
                            RefreshBilling()
                        end
                    end, RMenu:Get('personalmenu', 'billing'))
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'billing'), true, false, true, function()
                    if #PersonalMenu.billing == 0 then
                        RageUI.Separator("")
                        RageUI.Separator("~c~Vous avez aucune facture !")
                        RageUI.Separator("")
                    end
                    for i = 1, #PersonalMenu.billing, 1 do
						RageUI.Button(PersonalMenu.billing[i].label, nil, {RightLabel = ESX.Math.GroupDigits(PersonalMenu.billing[i].amount.."~g~$")}, true, function(h,a,s)
							if s then
								ESX.TriggerServerCallback('Sneakyesx_billing:payBill', function()
								end, PersonalMenu.billing[i].id)
                                ESX.SetTimeout(100, function()
                                    RefreshBilling()
                                    RageUI.GoBack()
                                end)
							end
						end)
					end
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'papers'), true, false, true, function()
                    RageUI.Separator("Métier : ~b~"..ESX.PlayerData.job.label)
                    RageUI.Separator("Grade : ~b~"..ESX.PlayerData.job.grade_label)
                    if ESX.PlayerData.job2.label ~= "Aucune" then
                        RageUI.Separator("Groupe : ~y~"..ESX.PlayerData.job2.label)
                    end
                    if ESX.PlayerData.job2.grade_label ~= "Citoyen" then
                        RageUI.Separator("Rang : ~y~"..ESX.PlayerData.job2.grade_label)
                    end
                    RageUI.Button("Regarder sa carte d'identité", nil, { RightLabel = "→" },true, function(h,a,s)
                        if s then
                            TriggerEvent("SneakyLife:RequestShowCard","me")
                        end
                    end)
                    RageUI.Button("Montrer sa carte d'identité", nil, { RightLabel = "→" },true, function(h,a,s)
                        if s then
                            TriggerEvent("SneakyLife:RequestShowCard","players")
                        end
                    end)
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'portefeuille_money'), true, false, true, function()
                    for i = 1, #ESX.PlayerData.accounts, 1 do
                        if ESX.PlayerData.accounts[i].name == 'cash'  then
                            cash = RageUI.Separator('Argent liquide :~g~ '..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money.." ~g~$")) 
                            RageUI.Button("Donner", nil, {}, true, function(h,a,s)
                                if a then
                                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                    if closestPlayer ~= -1 and closestDistance <= 3 then
                                        playerMarker(closestPlayer)
                                    end
                                end
                                if s then
                                    local black, quantity = CheckQuantity(CustomAmount())
                                        if black then
                                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                                if closestDistance ~= -1 and closestDistance <= 3 then
                                                    local closestPed = GetPlayerPed(closestPlayer)
                                                    if not IsPedSittingInAnyVehicle(closestPed) then
                                                        SneakyEvent('Sneakyesx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', ESX.PlayerData.accounts[i].name, quantity)
                                                    else
                                                        ESX.ShowNotification('Vous ne pouvez pas donner ', 'de l\'argent dans un véhicles')
                                                    end
                                                else
                                                    ESX.ShowNotification('~r~Erreur\n~s~Aucune personne à proximité.')
                                                end
                                        else
                                            ESX.ShowNotification('~r~Erreur\n~s~Somme invalide')
                                        end
                                end
                            end)
                            RageUI.Button("Jeter", nil, {}, true, function(h,a,s)
                                if s then
                                    local black, quantity = CheckQuantity(CustomAmount())
                                    if black then
                                        if not IsPedSittingInAnyVehicle(PlayerPed) then
                                            SneakyEvent('Sneakyesx:dropInventoryItem', 'item_account', ESX.PlayerData.accounts[i].name, quantity)
                                        else
                                            ESX.ShowNotification('Vous pouvez pas jeter', 'de l\'argent')
                                        end
                                    else
                                        ESX.ShowNotification('~r~Erreur\n~s~Somme invalide')
                                    end
                                end
                            end)
                        end
                    end
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'portefeuille_blackmoney'), true, false, true, function()
                    for i = 1, #ESX.PlayerData.accounts, 1 do
                        if ESX.PlayerData.accounts[i].name == 'dirtycash' then
                            RageUI.Separator("Source inconnue :~c~ "..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money.."$"), nil, {}, true, function(h,a,s)
                            end)
                            RageUI.Button("Donner", nil, {}, true, function(h,a,s)
                                if a then
                                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                    if closestPlayer ~= -1 and closestDistance <= 3 then
                                        playerMarker(closestPlayer)
                                    end
                                end
                                if s then
                                    local black, quantity = CheckQuantity(CustomAmount())
                                    if black then
                                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                        if closestDistance ~= -1 and closestDistance <= 3 then
                                            local closestPed = GetPlayerPed(closestPlayer)
            
                                            if not IsPedSittingInAnyVehicle(closestPed) then
                                                SneakyEvent('Sneakyesx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', ESX.PlayerData.accounts[i].name, quantity)
                                            else
                                                ESX.ShowNotification('Vous ne pouvez pas donner ', 'de l\'argent dans un véhicles')
                                            end
                                        else
                                            ESX.ShowNotification('~r~Erreur\n~s~Aucune personne à proximité.')
                                        end
                                    else
                                        ESX.ShowNotification('~r~Erreur\n~s~Somme invalide')
                                    end
                                end
                            end)
                            RageUI.Button("Jeter", nil, {}, true, function(h,a,s)
                                if s then
                                    local black, quantity = CheckQuantity(CustomAmount())
                                    if black then
                                        if not IsPedSittingInAnyVehicle(PlayerPed) then
                                            SneakyEvent('Sneakyesx:dropInventoryItem', 'item_account', ESX.PlayerData.accounts[i].name, quantity)
                                        else
                                            ESX.ShowNotification('~r~Erreur\n~s~nVous ne pouvez pas jeter de l\'argent dans un véhicule')
                                        end
                                    else
                                        ESX.ShowNotification('~r~Erreur\n~s~Somme invalide')
                                    end
                                end
                            end)
                        end
                    end
                end)
                RageUI.IsVisible(RMenu:Get('personalmenu', 'portefeuille_chip'), true, false, true, function()
                    for i = 1, #ESX.PlayerData.accounts, 1 do
                        if ESX.PlayerData.accounts[i].name == 'chip' then
                            RageUI.Separator("Vos jetons :~o~ "..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money), nil, {}, true, function(h,a,s)
                            end)
                            RageUI.Button("Donner", nil, {}, true, function(h,a,s)
                                if a then
                                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                    if closestPlayer ~= -1 and closestDistance <= 3 then
                                        playerMarker(closestPlayer)
                                    end
                                end
                                if s then
                                    local black, quantity = CheckQuantity(CustomAmount())
                                    if black then
                                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                        if closestDistance ~= -1 and closestDistance <= 3 then
                                            local closestPed = GetPlayerPed(closestPlayer)
            
                                            if not IsPedSittingInAnyVehicle(closestPed) then
                                                SneakyEvent('Sneakyesx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', ESX.PlayerData.accounts[i].name, quantity)
                                            else
                                                ESX.ShowNotification('Vous ne pouvez pas donner ', 'de l\'argent dans un véhicles')
                                            end
                                        else
                                            ESX.ShowNotification('~r~Erreur\n~s~Aucune personne à proximité.')
                                        end
                                    else
                                        ESX.ShowNotification('~r~Erreur\n~s~Somme invalide')
                                    end
                                end
                            end)
                            RageUI.Button("Jeter", nil, {}, true, function(h,a,s)
                                if s then
                                    local black, quantity = CheckQuantity(CustomAmount())
                                    if black then
                                        if not IsPedSittingInAnyVehicle(PlayerPed) then
                                            SneakyEvent('Sneakyesx:dropInventoryItem', 'item_account', ESX.PlayerData.accounts[i].name, quantity)
                                        else
                                            ESX.ShowNotification('~r~Erreur\n~s~nVous ne pouvez pas jeter de l\'argent dans un véhicule')
                                        end
                                    else
                                        ESX.ShowNotification('~r~Erreur\n~s~Somme invalide')
                                    end
                                end
                            end)
                        end
                    end
                end)
				Wait(0)
			end
		end)
	end

end

Keys.Register('F5','F5', 'Menu Personnel ', function()
    if not exports.inventaire:GetStateInventory() and not GetStateFishing() then 
        vip = GetVIP()
        OpenPersonalMenuRageUIMenu()
    end
end)

function doorAction(door)
    if not IsPedInAnyVehicle(PlayerPedId(),false) then return end
    local veh = GetVehiclePedIsIn(PlayerPedId(),false)
    if door == -1 then
        if doorActionIndex == 1 then
            for i = 0, 7 do
                SetVehicleDoorOpen(veh,i,false,false)
            end
        else
            for i = 0, 7 do
                SetVehicleDoorShut(veh,i,false)
            end
        end
        doorCoolDown = true
        Citizen.SetTimeout(500, function()
            doorCoolDown = false
        end)
        return
    end
    if doorActionIndex == 1 then
        SetVehicleDoorOpen(veh,door,false,false)
        doorCoolDown = true
        Citizen.SetTimeout(500, function()
            doorCoolDown = false
        end)
    else
        SetVehicleDoorShut(veh,door,false)
        doorCoolDown = true
        Citizen.SetTimeout(500, function()
            doorCoolDown = false
        end)
    end
end

function RefreshBilling()
    ESX.TriggerServerCallback('SneakyLife:billing', function(bills)
        PersonalMenu.billing = bills
    end)
end

function vehicleIsDamaged()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
    return GetVehicleEngineHealth(vehicle) < 1000
end

function isAllowedToManageVehicle()
    if IsPedInAnyVehicle(PlayerPedId(),false) then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
        if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
            return true
        end
        return false
    end
    return false
end

function CheckQuantity(number)
    number = tonumber(number)
  
    if type(number) == 'number' then
      number = ESX.Math.Round(number)
  
      if number > 0 then
        return true, number
      end
    end
  
    return false, number
end

Citizen.CreateThread(function()
    while true do
        local waiting = 250

        if IsPedInAnyVehicle(PlayerPedId(), true) then
            waiting = 10
            if speedlimitateur then
                waiting = 0
                local ped = PlayerPedId()
                local vehicle = GetVehiclePedIsIn(ped, false)  
                SetEntityMaxSpeed(vehicle, speedlimited/3.6) 
            end
        end

        Wait(waiting)
      end
  end)


function CustomAmountRadio()
    local montant = nil
    AddTextEntry("BANK_CUSTOM_AMOUNT", "Entrez la fréquence")
    DisplayOnscreenKeyboard(1, "BANK_CUSTOM_AMOUNT", '', "", '', '', '', 15)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        montant = GetOnscreenKeyboardResult()
        Citizen.Wait(1)
    else
        Citizen.Wait(1)
    end
    return tonumber(montant)
end

function playerMarker(player)
    local ped = GetPlayerPed(player)
    local pos = GetEntityCoords(ped)
    DrawMarker(2, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 170, 0, 1, 2, 0, nil, nil, 0)
end

RegisterNetEvent('Sneakyesx_addonaccount:setMoney')
AddEventHandler('Sneakyesx_addonaccount:setMoney', function(society, money)
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job.name == society then
		societymoney = ESX.Math.GroupDigits(money)
	elseif ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job2.name == society then
		societymoney2 = ESX.Math.GroupDigits(money)
	end
end)
