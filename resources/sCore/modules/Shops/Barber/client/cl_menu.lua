ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(10)
    end
end)
SneakyEvent = TriggerServerEvent
local Barber = {}
Components = {}
ComponentsMax = {}
sLoaded = nil
sData = {}
sCharEnd = true
sIdentityEnd = true


local cam, isCameraActive
local firstSpawn, zoomOffset, camOffset, heading = true, 0.0, 0.0, 90.0

sBarber = {
    "hair_1",	
    "hair_2",	
    "hair_color_1",
    "hair_color_2",
    "hair_fade",
    "beard_1",
    "beard_2",
    "beard_3",
    "beard_4",
    "eyebrows_2",
    "eyebrows_1",
    "eyebrows_3",
    "eyebrows_4",
    "makeup_1",
    "makeup_2",
    "makeup_3",
    "makeup_4",
    "lipstick_1",
    "lipstick_2",
    "lipstick_3",
    "lipstick_4",
    "blush_1",
    "blush_2",
    "blush_3",
    "complexion_1",	
    "complexion_2",	
}

function GetComponents()
	TriggerEvent('Sneakyskinchanger:getData', function(data, max)
		Components = data
		ComponentsMax = max
	end)
end

RegisterNetEvent("OpenBarberMenu")
AddEventHandler("OpenBarberMenu",function()
    OpenBarberMenu()
end)

function OpenBarberMenu()

    if Barber.Menu then 
        Barber.Menu = false 
        RageUI.Visible(RMenu:Get('barber', 'main'), false)
        sCharacter = nil
        KillCreatorCam()
        FreezeEntityPosition(GetPlayerPed(-1), true)
        return
    else
        RMenu.Add('barber', 'main', RageUI.CreateMenu("", "", 10, 140,"root_cause","shopui_title_barber")) --Menu principa
        RMenu.Add('barber', 'characteroptionshead', RageUI.CreateSubMenu(RMenu:Get("barber", "main"),"", "~y~Herr Kutz Barber"))
        RMenu.Add('barber', 'characteroptions_s', RageUI.CreateSubMenu(RMenu:Get("barber", "character"),"", "~y~Herr Kutz Barber")) -- validé
        RMenu.Add('barber', 'characteroptions_h', RageUI.CreateSubMenu(RMenu:Get("barber", "characteroptionshead"),"", "~y~Herr Kutz Barber")) -- validé
        RMenu:Get('barber', 'main'):SetSubtitle("~y~Herr Kutz Barber")
        RMenu:Get('barber', 'main').EnableMouse = false
        RMenu:Get('barber', 'main').Closable = true
        RMenu:Get('barber', 'main').Closed = function()
            Barber.Menu = false
            KillCreatorCam()
            FreezeEntityPosition(GetPlayerPed(-1), false)
            ESX.TriggerServerCallback('Sneakyesx_skin:getPlayerSkin', function(skin)
                TriggerEvent('Sneakyskinchanger:loadSkin', skin) 
            end)
        end
        GetComponents()
        CreateCreatorCam()
        sCharEnd = true
        sIdentityEnd = true
        SwitchCam(false, 'default')
        Barber.Menu = true 
        RageUI.Visible(RMenu:Get('barber', 'main'), true)
        Citizen.CreateThread(function()
			while Barber.Menu do
                RageUI.IsVisible(RMenu:Get('barber', 'main'), true, false, true, function()
                    FreezeEntityPosition(GetPlayerPed(-1), true)
                    RageUI.Button("Barbier", "~y~Herr Kutz Barber", {RightLabel = "→"}, true,function(h,a,s)
                        if s then
                            GetComponents()
                        end
                    end,RMenu:Get("barber","characteroptionshead"))
                    RageUI.Button("Valider le changement", "~y~Herr Kutz Barber", {RightLabel = "→ 100~g~$"}, true,function(h,a,s)
                        if s then
                            SneakyEvent("BarberShop:Buy")
                            TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                                SneakyEvent('Sneakyesx_skin:save', skin)
                            end)
                        end
                    end)
                end)
                RageUI.IsVisible(RMenu:Get('barber', 'characteroptionshead'), true, false, true, function()
                    FreezeEntityPosition(GetPlayerPed(-1), true)
                    for k,v in pairs(Components) do
                        for _, s_head in pairs(sBarber) do
                            if zoomOffset ~= v.zoomOffset and camOffset ~= v.camOffset then 
                                zoomOffset = v.zoomOffset
                                camOffset = v.camOffset
                            end
                            if v.name == s_head then
                                RageUI.Button(v.label, "~y~Herr Kutz Barber", {RightLabel = "→"}, true,function(h,a,s)
                                    if a then
                                        sData = v.name
                                        SwitchCam(false, v.name)
                                    end
                                end,RMenu:Get("barber","characteroptions_h"))
                            end
                        end
                    end
                end)
                RageUI.IsVisible(RMenu:Get('barber', 'characteroptions_h'), true, false, true, function()
                    FreezeEntityPosition(GetPlayerPed(-1), true)
                    for _,v in pairs(Components) do
                        if v.name == sData then
                            for i = 0, ComponentsMax[sData] do
                                RageUI.Button(v.label.." N°"..i, "~y~Herr Kutz Barber", {RightLabel = "→"}, true,function(h,a,s)
                                    if a then
                                        if sLoaded ~= i then
                                            sLoaded = i
                                            TriggerEvent('Sneakyskinchanger:change', v.name, i)
                                        end
                                    end
                                end)
                            end
                        end
                    end 
                end)
				Wait(0)
			end
		end)
	end
end

RegisterNetEvent('BarberShop:CheckBuy')
AddEventHandler('BarberShop:CheckBuy', function(check)
	if check ==  'yes' then
        TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
            SneakyEvent('Sneakyesx_skin:save', skin)
        end)
        Barber.Menu = false
        KillCreatorCam()
        FreezeEntityPosition(GetPlayerPed(-1), false)
	end
end)

local BarberShop = {

    {
        pos = vector3(137.09083557129,-1708.1477050781,29.291622161865-0.98),
        blip = {
            label = "Barbier", 
            ID = 71, 
            Color = 51
        },
    },
    {
        pos = vector3(-810.96441650391,-184.06790161133,37.568992614746-0.98),
        blip = {
            label = "Barbier", 
            ID = 71, 
            Color = 51
        },
    },
    {
        pos = vector3(-1280.9237060547,-1116.8645019531,6.9901103973389-0.98),
        blip = {
            label = "Barbier", 
            ID = 71, 
            Color = 51
        },
    },
    {
        pos = vector3(1929.7789306641,3732.8803710938,32.844417572021-0.98),
        blip = {
            label = "Barbier", 
            ID = 71, 
            Color = 51
        },
    },
    {
        pos = vector3(1214.7652587891,-473.13641357422,66.207984924316-0.98),
        blip = {
            label = "Barbier", 
            ID = 71, 
            Color = 51
        },
    },
    {
        pos = vector3(-33.455024719238,-154.7061920166,57.076484680176-0.98),
        blip = {
            label = "Barbier", 
            ID = 71, 
            Color = 51
        },
    },
    {
        pos = vector3(-275.92349243164,6226.2612304688,31.695512771606-0.98),
        blip = {
            label = "Barbier", 
            ID = 71, 
            Color = 51
        },
    },
}


Citizen.CreateThread(function()
    while true do
        att = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs(BarberShop) do
            local mPos = #(pCoords-v.pos)
            if not Barber.Menu then
                if mPos <= 10.0 then
                    DrawMarker(1, v.pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 158, 0, 170, 0, 0, 0, 1, nil, nil, 0)
                    att = 1
                    if mPos <= 1.4 then
                        ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour interagir avec le barbier")
                        if IsControlJustPressed(0, 51) then
                            ESX.TriggerServerCallback('Sneakyesx_skin:getPlayerSkin', function(skin)
                                TriggerEvent('Sneakyskinchanger:loadSkin', skin) 
                            end)
                            OpenBarberMenu()
                        end
                    end
                end
            end
        end
        Citizen.Wait(att)
    end
end)


local CamOffset = {
	{item = "default", 		cam = {0.0, 3.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "default_face", cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 35.0},
	{item = "face",			cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 20.0},
	{item = "skin", 		cam = {0.0, 2.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 30.0},
	{item = "tshirt_1", 	cam = {0.0, 2.0, 0.35}, lookAt = {0.0, 0.0, 0.35}, fov = 30.0},
	{item = "tshirt_2", 	cam = {0.0, 2.0, 0.35}, lookAt = {0.0, 0.0, 0.35}, fov = 30.0},
	{item = "torso_1", 		cam = {0.0, 2.0, 0.35}, lookAt = {0.0, 0.0, 0.35}, fov = 30.0},
	{item = "torso_2", 		cam = {0.0, 2.0, 0.35}, lookAt = {0.0, 0.0, 0.35}, fov = 30.0},
	{item = "decals_1", 	cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "decals_2", 	cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "arms", 		cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "arms_2", 		cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "pants_1", 		cam = {0.0, 2.0, -0.35}, lookAt = {0.0, 0.0, -0.4}, fov = 35.0},
	{item = "pants_2", 		cam = {0.0, 2.0, -0.35}, lookAt = {0.0, 0.0, -0.4}, fov = 35.0},
	{item = "shoes_1", 		cam = {0.0, 2.0, -0.5}, lookAt = {0.0, 0.0, -0.6}, fov = 40.0},
	{item = "shoes_2", 		cam = {0.0, 2.0, -0.5}, lookAt = {0.0, 0.0, -0.6}, fov = 25.0},
	{item = "age_1",			cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "age_2",			cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "beard_1", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "beard_2", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "beard_3", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "beard_4", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "hair_1",		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "hair_2",		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
    {item = "hair_fade",	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "hair_color_1",	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "hair_color_2",	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "eye_color", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "eyebrows_1", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "eyebrows_2", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "eyebrows_3", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "eyebrows_4", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "makeup_1", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "makeup_2", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "makeup_3", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "makeup_4", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "lipstick_1", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "lipstick_2", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "lipstick_3", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "lipstick_4", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "blemishes_1",	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "blemishes_2",	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "blush_1", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "blush_2", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "blush_3", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "complexion_1",	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "complexion_2",	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "sun_1", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "sun_2", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "moles_1", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "moles_2", 		cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "chest_1", 		cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "chest_2", 		cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "chest_3", 		cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "bodyb_1", 		cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "bodyb_2", 		cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "ears_1", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 35.0},
	{item = "ears_2", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 35.0},
	{item = "mask_1", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 20.0},
	{item = "mask_2", 		cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 20.0},
	{item = "bproof_1", 	cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "bproof_2", 	cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "chain_1", 		cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "chain_2", 		cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "bags_1", 		cam = {0.0, -2.0, 0.35}, lookAt = {0.0, 0.0, 0.35}, fov = 30.0},
	{item = "bags_2", 		cam = {0.0, -2.0, 0.35}, lookAt = {0.0, 0.0, 0.35}, fov = 30.0},
	{item = "helmet_1", 	cam = {0.0, 1.0, 0.73}, lookAt = {0.0, 0.0, 0.68}, fov = 20.0},
	{item = "helmet_2", 	cam = {0.0, 1.0, 0.73}, lookAt = {0.0, 0.0, 0.68}, fov = 20.0},
	{item = "glasses_1", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "glasses_2", 	cam = {0.0, 1.0, 0.7}, lookAt = {0.0, 0.0, 0.65}, fov = 25.0},
	{item = "watches_1", 	cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "watches_2", 	cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "bracelets_1",	cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
	{item = "bracelets_2",	cam = {0.0, 2.0, 0.0}, lookAt = {0.0, 0.0, 0.0}, fov = 40.0},
}

function GetCamOffset(type)
	for k,v in pairs(CamOffset) do
		if v.item == type then
			return v
		end
	end
end

function CreateCreatorCam()
    Citizen.CreateThread(function()
        local pPed = GetPlayerPed(-1)
        local offset = GetCamOffset("default")
        local pos = GetOffsetFromEntityInWorldCoords(pPed, offset.cam[1], offset.cam[2], offset.cam[3])
        local posLook = GetOffsetFromEntityInWorldCoords(pPed, offset.lookAt[1], offset.lookAt[2], offset.lookAt[3])

        CreatorCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 0)
        
        SetCamActive(CreatorCam, 1)
        SetCamCoord(CreatorCam, pos.x, pos.y, pos.z)
        SetCamFov(CreatorCam, offset.fov)
        PointCamAtCoord(CreatorCam, posLook.x, posLook.y, posLook.z)

        RenderScriptCams(1, 1, 1000, 0, 0)
    end)
end

function SwitchCam(backto, type)
    if not DoesCamExist(cam2) then cam2 = CreateCam("DEFAULT_SCRIPTED_CAMERA", 0) end
    Citizen.CreateThread(function()
        local pPed = GetPlayerPed(-1)
        local offset = GetCamOffset(type)
        if offset == nil then
            offset = GetCamOffset("default")
        end
        local pos = GetOffsetFromEntityInWorldCoords(pPed, offset.cam[1], offset.cam[2], offset.cam[3])
        local posLook = GetOffsetFromEntityInWorldCoords(pPed, offset.lookAt[1], offset.lookAt[2], offset.lookAt[3])

        if backto then
            SetCamActive(CreatorCam, 1)

            SetCamCoord(CreatorCam, pos.x, pos.y, pos.z)
            SetCamFov(CreatorCam, offset.fov)
            PointCamAtCoord(CreatorCam, posLook.x, posLook.y, posLook.z)
            SetCamActiveWithInterp(CreatorCam, cam2, 1000, 1, 1)
            Wait(1000)
            
        else
            SetCamActive(cam2, 1)

            SetCamCoord(cam2, pos.x, pos.y, pos.z)
            SetCamFov(cam2, offset.fov)
            PointCamAtCoord(cam2, posLook.x, posLook.y, posLook.z)
            SetCamDofMaxNearInFocusDistance(cam2, 1.0)
            SetCamDofStrength(cam2, 500.0)
            SetCamDofFocalLengthMultiplier(cam2, 500.0)
            SetCamActiveWithInterp(cam2, CreatorCam, 1000, 1, 1)
            Wait(1000)
        end
    end)
end

function KillCreatorCam()
    RenderScriptCams(0, 1, 1000, 0, 0)
    SetCamActive(CreatCam, 0)
    SetCamActive(cam2, 0)
    ClearPedTasks(GetPlayerPed(-1))
end
