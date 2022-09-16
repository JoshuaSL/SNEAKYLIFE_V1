ESX = nil
local Clothes = {}

local torseIndex = 1
local tshirtIndex = 1
local pantalonIndex = 1
local chaussuresIndex = 1

local compactionIndexes = {
	["peelotorse"] = 1,
	["peelotshirt"] = 1,
	["peelopantalon"] = 1,
	["peelochaussures"] = 1
}

local currentshop = nil
local currentSelection = nil
local currentSelectionMenu = nil 
local currentClothes = {}

local sexIndex = {}

function getMax(number)
	if number ~= 0 then 
		slidemaxTables = {}
		for k = 0, number do 
			table.insert(slidemaxTables, k)
		end 
		return slidemaxTables
	else
		return nil
	end
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLength)
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


local menu = {
	mainClothes = { 
		["T-shirt"] = {name = "T-shirt", ask = "→→", askX = true, id = 'Selection', data = 'tshirt_1', data2 = 'tshirt_2', variation = 8, variation2 = 'texture', price = 45, realName = "peelotshirt"},
		["Torse"] = {name = "Torse", ask = "→→", askX = true, id = 'Selection', data = 'torso_1', data2 = 'torso_2', variation = 11, variation2 = 'texture', price = 45, realName = "peelotorse"},
		["Pantalon"] = {name = "Pantalon", ask = "→→", askX = true, id = 'Selection', data = 'pants_1', data2 = 'pants_2', variation = 4, variation2 = 'texture', price = 45, realName = "peelopantalon"},
		["Chaussures"] = {name = "Chaussures", ask = "→→", askX = true, id = 'Selection', data = 'shoes_1', data2 = 'shoes_2', variation = 6, variation2 = 'texture', price = 25, realName = "peelochaussures"},
		["Calques"] = {name = "Calques", ask = "→→", askX = true, id = 'Selection', data = 'decals_1', data2 = 'decals_2', variation = 1, variation2 = 'props', price = 15, realName = "peeloCalques"}, 
		["Gants"] =	{name = "Gants", ask = "→→", askX = true, id = 'Selection', data = 'arms', data2 = 'arms_2', variation = 1, variation2 = 11, price = 10, realName = "peelogant"}, 
	},   
	accessories = { 
		["Chapeau"] =	{name = "Chapeau", ask = ">", askX = true, id = 'Selection', data = 'helmet_1', data2 = 'helmet_2', variation = 0, variation2 = 'props', price = 20, realName = "peelochapeau"},
		["Lunettes"] =	{name = "Lunettes", ask = ">", askX = true, id = 'Selection', data = 'glasses_1', data2 = 'glasses_2', variation = 1, variation2 = 'props', price = 15, realName = "peelolunettes",},
		["Sac à dos"] =	{name = "Sac à dos", ask = ">", askX = true, id = 'Selection', data = 'bags_1', data2 = 'bags_2', variation = 5, variation2 = 'texture', price = 45, realName = "peelosac"},
		["Chaines"] =	{name = "Chaines", ask = ">", askX = true, id = 'Selection', data = 'chain_1', data2 = 'chain_2', variation = 1, variation2 = 'props', price = 15, realName = "peelochaine"},
		["Oreille"] =	{name = "Oreille", ask = ">", askX = true, id = 'Selection', data = 'ears_1', data2 = 'ears_2', variation = 1, variation2 = 'props', price = 10, realName = "peelooreille"},
		["Montres"] =	{name = "Montres", ask = ">", askX = true, id = 'Selection', data = 'watches_1', data2 = 'watches_2', variation = 0, variation2 = 'props', price = 10, realName = "peeloomontre"},
	},
	extra = {
		["Masque"] = {name = "Masque", id = "extra", data = "mask_1", data2 = "mask_2", realName = "peelomasque", variation = 1, variation2 = "texture", price = 45}
	}
}    
  

function openClotheMenu()
	if Clothes.Menu then 
        Clothes.Menu = false 
        RageUI.Visible(RMenu:Get('clothes', 'main'), false)
        FreezeEntityPosition(GetPlayerPed(-1), true)
        return
    else
		RMenu.Add("clothes", "main", RageUI.CreateMenu("","~o~Ponsonbys",0,0,"root_cause","shopui_title_highendfashion"))
		RMenu.Add("publish", "main", RageUI.CreateSubMenu(RMenu:Get("clothes", "main"), "", "Main"))
		RMenu.Add("masque", "main", RageUI.CreateMenu("","~o~Masque",0,0,"root_cause","shopui_title_highendfashion"))
		RMenu.Add("compactation", "main", RageUI.CreateSubMenu(RMenu:Get("clothes", "main"), "", "Main"))
		RMenu.Add("mainClothes", "main", RageUI.CreateSubMenu(RMenu:Get("clothes", "main"), "", "Main"))
		RMenu.Add("accessories", "main", RageUI.CreateSubMenu(RMenu:Get("clothes", "main"), "", "Main"))
		RMenu.Add("subMenu", "main", RageUI.CreateSubMenu(RMenu:Get("clothes", "main"), "", "Main"))
		

		RMenu:Get("clothes", "main").Closed = function()  
			sexIndex = {}
			SetEntityInvincible(GetPlayerPed(-1), false) 
			FreezeEntityPosition(GetPlayerPed(-1), false)
            ESX.TriggerServerCallback('Sneakyesx_skin:getPlayerSkin', function(skin)
                TriggerEvent('Sneakyskinchanger:loadSkin', skin) 
            end)
		end 
		RMenu:Get("accessories", "main").Closed = function()  
			sexIndex = {}
			SetEntityInvincible(GetPlayerPed(-1), false) 
			FreezeEntityPosition(GetPlayerPed(-1), false)
            ESX.TriggerServerCallback('Sneakyesx_skin:getPlayerSkin', function(skin)
                TriggerEvent('Sneakyskinchanger:loadSkin', skin) 
            end)
		end 
		RMenu:Get("masque", "main").Closed = function()  
			sexIndex = {}
			SetEntityInvincible(GetPlayerPed(-1), false) 
			FreezeEntityPosition(GetPlayerPed(-1), false)
            ESX.TriggerServerCallback('Sneakyesx_skin:getPlayerSkin', function(skin)
                TriggerEvent('Sneakyskinchanger:loadSkin', skin) 
            end)
		end
		Clothes.Menu = true 
		if currentshop ~= "Main" then 
			currentSelection = "Masque"
			currentSelectionMenu = "extra"
			RageUI.Visible(RMenu:Get('masque', 'main'), true)
		else
			RageUI.Visible(RMenu:Get('clothes', 'main'), true)
		end
		Citizen.CreateThread(function()
			while Clothes.Menu do
					RageUI.IsVisible(RMenu:Get("clothes","main"), true, true, true, function()							
							RageUI.Button("Tenue", nil, { RightLabel = "→→" }, true, function(s, p, q)
								if (q) then
									local currentClotheTable = {}
									shoplunettes.Menu["Publier/liste des tenue"].b = {} 
									table.insert(shoplunettes.Menu["Publier/liste des tenue"].b, {name = "Publier de votre tenue actuelle"})
									
									ESX.TriggerServerCallback('Neo:getalltenues', function(Vetement)
										for k, v in pairs(Vetement) do  
											if v.type == "peelopublic" then 
												table.insert(shoplunettes.Menu["Publier/liste des tenue"].b, {name = v.nom, price = 45, skins = json.decode(v.clothe)})
											end
										end
									end)
								end
							end, RMenu:Get('publish', 'main'))

							RageUI.Button("Vêtements", nil, { RightLabel = "→→" }, true, function(s, p, q)
								if (q) then
									
								end
							end, RMenu:Get('mainClothes', 'main'))

							RageUI.Button("Accessoires", nil, { RightLabel = "→→" }, true, function(s, p, q)
								if (q) then
									
								end
							end, RMenu:Get('accessories', 'main'))

							RageUI.Button("Sauvegarder la tenue actuelle", nil, { RightLabel = "~g~$45" }, true, function(s, p, q)
								if (q) then 
									ESX.TriggerServerCallback('Checkmoney', function(cb)
										if cb then 
											savetenue()
										end
									end, 45)
								end  
							end)
					end)
					
					RageUI.IsVisible(RMenu:Get("compactation","main"), true, true, true,function()
						
						local slidemax = {
							["peelotorse"] = {},
							["peelotshirt"] = {},
							["peelopantalon"] = {},
							["peelochaussures"] = {}
						}
						
						for _, v in pairs(currentClothes) do
							for k, _ in pairs(slidemax) do 
								if v.type == k then 
									table.insert(slidemax[v.type], v.nom)
								end 
							end
						end 

						for k, _ in pairs(slidemax) do 
							for _, v in pairs(menu.mainClothes) do 
								if v.realName == k then 
									RageUI.List(v.name, slidemax[k], compactionIndexes[k], nil, { }, true, function(Hovered, Active, Selected, Index)
										if (compactionIndexes[k] ~= Index) then  
											compactionIndexes[k] = Index 
										end
									end)
								end 
							end
						end

						RageUI.Button("Valider", nil, { RightLabel = '→→' }, not cooldown, function(s, p, q)
							if (q) then  
							
									
								 
								 
							end   
						end)

					end)

					RageUI.IsVisible(RMenu:Get("mainClothes","main"), true, true, true,function()
						
						RageUI.Button("Sauvegarde votre tenue acctuelle", nil, { RightLabel = '~g~$200' }, not cooldown, function(s, p, q)
							if (q) then 
								ESX.TriggerServerCallback('Checkmoney', function(cb)
									if cb then 
										save() 
										savetenue()
									end    
								end, 200) 
							end  
						end)
						for k, v in pairs(menu.mainClothes) do
							RageUI.Button(k, nil, { RightLabel = v.ask }, not cooldown, function(s, p, q)
								if (q) then 
									currentSelection = k
									currentSelectionMenu = "mainClothes"
								end 
							end, RMenu:Get('subMenu', 'main'))
						end
					end)

					RageUI.IsVisible(RMenu:Get("accessories","main"), true, true, true,function()
						for k, v in pairs(menu.accessories) do 
							RageUI.Button(k, nil, { RightLabel = v.ask }, not cooldown, function(s, p, q)
								if (q) then 
									currentSelection = k
									currentSelectionMenu = "accessories"
								end 
							end, RMenu:Get('subMenu', 'main'))
						end
					end) 

					RageUI.IsVisible(RMenu:Get("publish","main"), true, true, true,function()
						for k, v in pairs(shoplunettes.Menu["Publier/liste des tenue"].b) do 
							if v.price ~= nil then 
								RageUI.Button(v.name, nil, { RightLabel = '~g~$'..v.price }, not cooldown, function(s, p, q)
									if (p) then 
										local check = true
										TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
		
											if skin["pants_1"] == v.skins["pants_1"] and skin["tshirt_2"] == v.skins["tshirt_2"] and skin["tshirt_1"] == v.skins["tshirt_1"] and skin["torso_1"] == v.skins["torso_1"] and skin["torso_2"] == v.skins["torso_2"] and skin["shoes_1"] == v.skins["shoes_1"] and skin["shoes_2"] == v.skins["shoes_2"] then
												check = false
											end 
		
											if check then 
												TriggerEvent('Sneakyskinchanger:loadClothes', skin, { 
													
													["pants_1"] = v.skins["pants_1"], 
													["pants_2"] = v.skins["pants_2"],  
													["tshirt_2"] = v.skins["tshirt_2"], 
													["tshirt_1"] = v.skins["tshirt_1"], 
													["torso_1"] = v.skins["torso_1"],
													["arms"] = v.skins["arms"],
													["arms_2"] = v.skins["arms_2"],
													["torso_2"] = v.skins["torso_2"],
													["shoes_1"] = v.skins["shoes_1"],
													["shoes_2"] = v.skins["shoes_2"]})
								
											end
										end)
									end 
									if (q) then 
										ESX.TriggerServerCallback('Checkmoney', function(cb)
											if cb then 
												save() 
												TriggerServerEvent("Neo:inserttenue", "peelotenue", Neo.name, Neo.skins) 
											end    
										end, 45)
									end 
								end)
							else
								RageUI.Button("Publier de votre tenue actuelle", nil, { RightLabel = "→→" }, not cooldown, function(s, p, q)
									if q and ESX.GetPlayerData()['group'] ~= "user" then 
										ESX.TriggerServerCallback('Sneakyesx_skin:getPlayerSkin', function(skin)
											TriggerEvent('Sneakyskinchanger:loadSkin', skin)
										end)
										local result = KeyboardInput('Nom', '', 30)
										if result ~= nil then  
											TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
												TriggerServerEvent("Neo:inserttenue", "peelopublic", ""..result.."", skin) 
												ESX.ShowNotification('Vous avez (~b~Publier~s~) votre tenue [~y~'..result..'~s~] ')
											end)
										end
									end 
								end)
							end
						end 
					end)
				
				RageUI.IsVisible(RMenu:Get("subMenu","main"), true, true, true,function()
					TriggerEvent('Sneakyskinchanger:getData', function(components, maxVals)
						for i=0, maxVals[menu[currentSelectionMenu][currentSelection].data], 1 do 
							
							local slidemax = 0
							if menu[currentSelectionMenu][currentSelection].variation2 == "texture" then 
								slidemax = GetNumberOfPedTextureVariations(PlayerPedId(),  menu[currentSelectionMenu][currentSelection].variation, i) - 1
							elseif menu[currentSelectionMenu][currentSelection].variation2 == "props" then 
								slidemax = GetNumberOfPedPropTextureVariations(PlayerPedId(),  menu[currentSelectionMenu][currentSelection].variation, i) - 1
							elseif menu[currentSelectionMenu][currentSelection].variation2 ~= "props" or menu[currentSelectionMenu][currentSelection].variation2 ~= "texture" then
								slidemax = 10
							end 
	
							local list = {}
							
							for k = 1, slidemax do 
								table.insert(list, k)
							end 
					
							if list[1] == nil then 
								list = {0}
							end 
							if not sexIndex[i] then
								sexIndex[i] = 1
							end
							RageUI.List(menu[currentSelectionMenu][currentSelection].name.." N° "..i, list, sexIndex[i], nil, { RightLabel = "~g~$"..menu[currentSelectionMenu][currentSelection].price}, true, function(Hovered, Active, Selected, Index)
							
								if (Active) then  
									local check = true
									TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
										if skin[menu[currentSelectionMenu][currentSelection].data] == i then 
											check = false 
										end 
									end) 
									if check then  
										TriggerEvent('Sneakyskinchanger:change', menu[currentSelectionMenu][currentSelection].data, i)
									end
								end  
								if (sexIndex[i] ~= Index) then  
									sexIndex[i] = Index
									TriggerEvent('Sneakyskinchanger:change',  menu[currentSelectionMenu][currentSelection].data2, sexIndex[i] - 1)
								end    
								if (Selected) then 
									ESX.TriggerServerCallback('Checkmoney', function(cb)
										if cb then 
											TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
												save()
												print('ok')
												TriggerServerEvent("Neo:insertlunettes", menu[currentSelectionMenu][currentSelection].realName, ""..menu[currentSelectionMenu][currentSelection].name.." "..i, skin[menu[currentSelectionMenu][currentSelection].data], skin[menu[currentSelectionMenu][currentSelection].data2], menu[currentSelectionMenu][currentSelection].data, menu[currentSelectionMenu][currentSelection].data2) 
											end)
										end
									end, menu[currentSelectionMenu][currentSelection].price)
								end 
							end)
							
							
						end
					end)
				end) 

				RageUI.IsVisible(RMenu:Get("masque","main"), true, true, true,function()
					TriggerEvent('Sneakyskinchanger:getData', function(components, maxVals)
						for i=0, maxVals[menu[currentSelectionMenu][currentSelection].data], 1 do 
							
							local slidemax = 0
							if menu[currentSelectionMenu][currentSelection].variation2 == "texture" then 
								slidemax = GetNumberOfPedTextureVariations(PlayerPedId(),  menu[currentSelectionMenu][currentSelection].variation, i) - 1
							elseif menu[currentSelectionMenu][currentSelection].variation2 == "props" then 
								slidemax = GetNumberOfPedPropTextureVariations(PlayerPedId(),  menu[currentSelectionMenu][currentSelection].variation, i) - 1
							elseif menu[currentSelectionMenu][currentSelection].variation2 ~= "props" or menu[currentSelectionMenu][currentSelection].variation2 ~= "texture" then
								slidemax = 10
							end 
	
							local list = {}
							
							for k = 1, slidemax do 
								table.insert(list, k)
							end 
					
							if list[1] == nil then 
								list = {0}
							end 
							if not sexIndex[i] then
								sexIndex[i] = 1
							end
							RageUI.List(menu[currentSelectionMenu][currentSelection].name.." N° "..i, list, sexIndex[i], nil, { RightLabel = "~g~$"..menu[currentSelectionMenu][currentSelection].price}, true, function(Hovered, Active, Selected, Index)
							
								if (Active) then  
									local check = true
									TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
										if skin[menu[currentSelectionMenu][currentSelection].data] == i then 
											check = false 
										end 
									end) 
									if check then  
										TriggerEvent('Sneakyskinchanger:change', menu[currentSelectionMenu][currentSelection].data, i)
									end
								end  
								if (sexIndex[i] ~= Index) then  
									sexIndex[i] = Index
									TriggerEvent('Sneakyskinchanger:change',  menu[currentSelectionMenu][currentSelection].data2, sexIndex[i] - 1)
								end    
								if (Selected) then 
									ESX.TriggerServerCallback('Checkmoney', function(cb)
										if cb then 
											TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
												save()
												print('ok')
												TriggerServerEvent("Neo:insertlunettes", menu[currentSelectionMenu][currentSelection].realName, ""..menu[currentSelectionMenu][currentSelection].name.." "..i, skin[menu[currentSelectionMenu][currentSelection].data], skin[menu[currentSelectionMenu][currentSelection].data2], menu[currentSelectionMenu][currentSelection].data, menu[currentSelectionMenu][currentSelection].data2) 
											end)
										end
									end, menu[currentSelectionMenu][currentSelection].price)
								end 
							end)
							
							
						end
					end)
				end) 
				Wait(0)
			end
		end)
	end
end

shoplunettes = {     
	Menu = { 
		["Action"] = {b = {}},
		["Publier/liste des tenue"] = { b = {} },
	} 
}   

function save()
	TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
		TriggerServerEvent('Sneakyesx_skin:save', skin)
	end)
end

function savetenue()
	TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
		local math = math.random(1, 9200)
		TriggerServerEvent("Neo:inserttenue", "peelotenue", "Tenue N°"..math.."", skin) 
		ESX.ShowNotification('Vous avez acheter/(~b~engeristrer~s~) votre tenue [~y~'..math..'~s~] ')
	end)
end


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end    
    while true do 
       time = 1000
	   local posplayer = GetEntityCoords(GetPlayerPed(-1), false)
        for k, v in pairs(Config.shops) do
            if (GetDistanceBetweenCoords(posplayer, v.pos, true) < 1.2) then
				ESX.ShowHelpNotification("Appuyez sur ~INPUT_TALK~ pour accéder au ~b~magasin de Main~w~.")
				if IsControlJustPressed(1,51) then 	
					save()
					currentshop = v.shop
					openClotheMenu() 
				end
            end
			if (GetDistanceBetweenCoords(posplayer, v.pos, true) < 20) then
				time = 1
				DrawMarker(25, v.pos.x, v.pos.y, v.pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.55, 0.55, 0.55, v.color.r, v.color.g, v.color.b, 255, false, false, 2, false, false, false, false)
			end
        end  
		Wait(time)
    end
end) 

