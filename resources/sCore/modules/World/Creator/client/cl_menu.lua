ESX = nil;
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('Sneakyesx:getSharedObject', function(a)
            ESX = a
        end)
        Citizen.Wait(10)
    end
end)
local b = {}
Components = {}
ComponentsMax = {}
sLoaded = nil;
sData = {}
sCharEnd = true;
sIdentityEnd = true;
sIndexSex = 1;
sDataIdentity = {}
sDataIdentity = {
    lastname = "",
    firstname = "",
    height = "",
    birthday = "",
    sex = ""
}
local c, d;
local e, f, g, h = true, 0.0, 0.0, 90.0;
sMain = {"chest_1", "chest_2", "chest_3", "age_1", "age_2", "blemishes_1", "blemishes_2"}
sHead = {"face", "skin", "hair_1", "hair_2", "hair_color_1", "hair_color_2", "beard_1", "beard_2", "beard_3", "beard_4",
         "eye_color", "eyebrows_2", "eyebrows_1", "eyebrows_3", "eyebrows_4", "makeup_1", "makeup_2", "makeup_3",
         "makeup_4", "lipstick_1", "lipstick_2", "lipstick_3", "lipstick_4", "blush_1", "blush_2", "blush_3",
         "complexion_1", "complexion_2", "sun_1", "sun_2", "moles_1", "moles_2"}
sClothes = {"arms", "arms_2", "tshirt_1", "tshirt_2", "torso_1", "torso_2", "decals_1", "decals_2", "pants_1",
            "pants_2", "shoes_1", "shoes_2", "bproof_1", "bproof_2"}
sAccessories = {"chain_1", "chain_2", "helmet_1", "helmet_2", "glasses_1", "glasses_2", "watches_1", "watches_2",
                "bracelets_1", "bracelets_2", "ears_1", "ears_2"}
function GetComponents()
    TriggerEvent('Sneakyskinchanger:getData', function(i, j)
        Components = i;
        ComponentsMax = j
    end)
end
RegisterNetEvent("OpenCreatorMenu")
AddEventHandler("OpenCreatorMenu", function()
    TriggerServerEvent('instancecreator:set')
    OpenCreatorMenu()
end)
function OpenCreatorMenu()
    if b.Menu then
        b.Menu = false;
        RageUI.Visible(RMenu:Get('creator', 'main'), false)
        sCreator = nil;
        sIdentity = nil;
        sCharacter = nil;
        KillCreatorCam()
        FreezeEntityPosition(GetPlayerPed(-1), true)
        return
    else
        RMenu.Add('creator', 'main', RageUI.CreateMenu("", "", 10, 140, "root_cause", "sneakylife"))
        RMenu.Add('creator', 'identity',
            RageUI.CreateSubMenu(RMenu:Get("creator", "main"), "", "Création d'identité de ~b~Sneaky~s~Life."))
        RMenu.Add('creator', 'character',
            RageUI.CreateSubMenu(RMenu:Get("creator", "main"), "", "Création d'identité de ~b~Sneaky~s~Life."))
        RMenu.Add('creator', 'characteroptionsmain', RageUI.CreateSubMenu(RMenu:Get("creator", "character"), "",
            "Création d'identité de ~b~Sneaky~s~Life."))
        RMenu.Add('creator', 'characteroptionshead', RageUI.CreateSubMenu(RMenu:Get("creator", "character"), "",
            "Création d'identité de ~b~Sneaky~s~Life."))
        RMenu.Add('creator', 'characteroptionsclothes', RageUI.CreateSubMenu(RMenu:Get("creator", "character"), "",
            "Création d'identité de ~b~Sneaky~s~Life."))
        RMenu.Add('creator', 'characteroptionsaccessories', RageUI.CreateSubMenu(RMenu:Get("creator", "character"), "",
            "Création d'identité de ~b~Sneaky~s~Life."))
        RMenu.Add('creator', 'characteroptions_s', RageUI.CreateSubMenu(RMenu:Get("creator", "character"), "",
            "Création d'identité de ~b~Sneaky~s~Life."))
        RMenu.Add('creator', 'characteroptions_m', RageUI.CreateSubMenu(RMenu:Get("creator", "characteroptionsmain"),
            "", "Création d'identité de ~b~Sneaky~s~Life."))
        RMenu.Add('creator', 'characteroptions_h', RageUI.CreateSubMenu(RMenu:Get("creator", "characteroptionshead"),
            "", "Création d'identité de ~b~Sneaky~s~Life."))
        RMenu.Add('creator', 'characteroptions_c', RageUI.CreateSubMenu(RMenu:Get("creator", "characteroptionsclothes"),
            "", "Création d'identité de ~b~Sneaky~s~Life."))
        RMenu.Add('creator', 'characteroptions_a',
            RageUI.CreateSubMenu(RMenu:Get("creator", "characteroptionsaccessories"), "",
                "Création d'identité de ~b~Sneaky~s~Life."))
        RMenu:Get('creator', 'main'):SetSubtitle("Création d'identité de ~b~Sneaky~s~Life.")
        RMenu:Get('creator', 'main').EnableMouse = false;
        RMenu:Get('creator', 'main').Closable = false;
        RMenu:Get('creator', 'main').Closed = function()
            b.Menu = false
        end;
        GetComponents()
        CreateCreatorCam()
        sCharEnd = true;
        sIdentityEnd = true;
        SwitchCam(false, 'default')
        b.Menu = true;
        RageUI.Visible(RMenu:Get('creator', 'main'), true)
        Citizen.CreateThread(function()
            while b.Menu do
                RageUI.IsVisible(RMenu:Get('creator', 'main'), true, false, true, function()
                    FreezeEntityPosition(GetPlayerPed(-1), true)
                    if sIdentityEnd then
                        RageUI.Button("Créer son identité.", "~b~Sneaky~s~Life.", {
                            RightLabel = "→"
                        }, true, function(k, l, m)
                        end, RMenu:Get("creator", "identity"))
                    else
                        RageUI.Button("Vous avez terminé votre identité.",
                            "Prénom : " .. sDataIdentity.firstname .. "~n~Nom : " .. sDataIdentity.lastname .. "~n~Taille : " ..
                                sDataIdentity.height .. "~n~Date de naissance : " .. sDataIdentity.birthday, {
                                RightLabel = "→"
                            }, false, function()
                            end)
                    end
                    if sCharEnd then
                        RageUI.Button("Créer son personnage.", "~b~Sneaky~s~Life.", {
                            RightLabel = "→"
                        }, true, function(k, l, m)
                        end, RMenu:Get("creator", "character"))
                    else
                        RageUI.Button("Vous avez terminé votre personnage.", "~b~Sneaky~s~Life.", {
                            RightLabel = "→"
                        }, false, function()
                        end)
                    end
                    if not sIdentityEnd and not sCharEnd then
                        RageUI.Button("Commencer l'aventure.", "~b~Sneaky~s~Life.", {
                            RightLabel = "→",
                            Color = {
                                HightLightColor = {0, 158, 255, 160},
                                BackgroundColor = {0, 178, 255, 160}
                            }
                        }, true, function(k, l, m)
                            if m then
                                TriggerEvent('Sneakyskinchanger:getSkin', function(n)
                                    TriggerServerEvent('Sneakyesx_skin:save', n)
                                end)
                                KillCreatorCam()
                                RageUI.Visible(RMenu:Get('creator', 'main'), false)
                                sOpen = false;
                                Wait(500)
                                FreezeEntityPosition(GetPlayerPed(-1), false)
                                StartCreatorEndCinematic()
                            end
                        end)
                    else
                        RageUI.Button("Commencer l'aventure.", "~b~Sneaky~s~Life.", {
                            RightLabel = "→",
                            Color = {
                                HightLightColor = {0, 158, 255, 160},
                                BackgroundColor = {0, 178, 255, 160}
                            }
                        }, false, function()
                        end)
                    end
                end)
                RageUI.IsVisible(RMenu:Get('creator', 'identity'), true, false, true, function()
                    FreezeEntityPosition(GetPlayerPed(-1), true)
                    RageUI.Button("Prénom", "~b~Sneaky~s~Life.", {
                        RightLabel = sDataIdentity.firstname
                    }, true, function(k, l, m)
                        if m then
                            local o = sKeyboardInput("Prénom", "", 20)
                            if o ~= nil then
                                sDataIdentity.firstname = o
                            end
                        end
                    end)
                    RageUI.Button("Nom", "~b~Sneaky~s~Life.", {
                        RightLabel = sDataIdentity.lastname
                    }, true, function(k, l, m)
                        if m then
                            local p = sKeyboardInput("Nom", "", 20)
                            if p ~= nil then
                                sDataIdentity.lastname = p
                            end
                        end
                    end)
                    RageUI.Button("Taille", "~b~Sneaky~s~Life.", {
                        RightLabel = sDataIdentity.height
                    }, true, function(k, l, m)
                        if m then
                            local q = sKeyboardInput("Taille", "", 20)
                            if q ~= nil then
                                sDataIdentity.height = q
                            end
                        end
                    end)
                    RageUI.Button("Date de naissance", "~b~Sneaky~s~Life.", {
                        RightLabel = sDataIdentity.birthday
                    }, true, function(k, l, m)
                        if m then
                            local r = sKeyboardInput("Date de naissance", "", 20)
                            if r ~= nil then
                                sDataIdentity.birthday = r
                            end
                        end
                    end)
                    RageUI.List("Sexe", {{
                        Name = "Homme",
                        Value = 1
                    }, {
                        Name = "Femme",
                        Value = 2
                    }}, sIndexSex, nil, {}, true, function(s, t, u, v)
                        if u then
                            local w = IdSelected;
                            if v == 1 then
                                sDataIdentity.sex = "Homme"
                            else
                                sDataIdentity.sex = "Femme"
                            end
                        end
                        sIndexSex = v
                    end)
                    if sDataIdentity.lastname ~= "" and sDataIdentity.firstname ~= "" and sDataIdentity.height ~= "" and
                        sDataIdentity.birthday ~= "" then
                        RageUI.Button("Confirmer son identité.", "~b~Sneaky~s~Life.", {
                            RightLabel = "→",
                            Color = {
                                HightLightColor = {0, 158, 255, 160},
                                BackgroundColor = {0, 178, 255, 160}
                            }
                        }, true, function(k, l, m)
                            if m then
                                sIdentityEnd = false;
                                RageUI.GoBack()
                                TriggerServerEvent('core:CreateIdentity', sDataIdentity)
                                ESX.ShowNotification("~b~Sneaky~s~Life~n~Identité créer avec succès.")
                            end
                        end)
                    end
                end)
                RageUI.IsVisible(RMenu:Get('creator', 'character'), true, false, true, function()
                    FreezeEntityPosition(GetPlayerPed(-1), true)
                    for x, y in pairs(Components) do
                        if y.name == 'sex' then
                            RageUI.Button(y.label, "~b~Sneaky~s~Life.", {
                                RightLabel = "→"
                            }, true, function(k, l, m)
                                if l then
                                    f = y.zoomOffset;
                                    g = y.camOffset;
                                    sData = y.name;
                                    SwitchCam(false, y.name)
                                end
                            end, RMenu:Get("creator", "characteroptions_s"))
                        end
                    end
                    RageUI.Button("Visage", "~b~Sneaky~s~Life.", {
                        RightLabel = "→"
                    }, true, function(k, l, m)
                        if m then
                            GetComponents()
                        end
                    end, RMenu:Get("creator", "characteroptionshead"))
                    RageUI.Button("Apparence", "~b~Sneaky~s~Life.", {
                        RightLabel = "→"
                    }, true, function(k, l, m)
                        if m then
                            GetComponents()
                        end
                    end, RMenu:Get("creator", "characteroptionsmain"))
                    RageUI.Button("Vetements", "~b~Sneaky~s~Life.", {
                        RightLabel = "→"
                    }, true, function(k, l, m)
                        if m then
                            GetComponents()
                        end
                    end, RMenu:Get("creator", "characteroptionsclothes"))
                    RageUI.Button("Accessoires", "~b~Sneaky~s~Life.", {
                        RightLabel = "→"
                    }, true, function(k, l, m)
                        if m then
                            GetComponents()
                        end
                    end, RMenu:Get("creator", "characteroptionsaccessories"))
                    RageUI.Button("Terminer son personnage.", "~b~Sneaky~s~Life.", {
                        RightLabel = "→",
                        Color = {
                            HightLightColor = {0, 158, 255, 160},
                            BackgroundColor = {0, 178, 255, 160}
                        }
                    }, true, function(k, l, m)
                        if m then
                            sCharEnd = false;
                            RageUI.GoBack()
                        end
                    end)
                end)
                RageUI.IsVisible(RMenu:Get('creator', 'characteroptionsmain'), true, false, true, function()
                    FreezeEntityPosition(GetPlayerPed(-1), true)
                    for x, y in pairs(Components) do
                        for z, A in pairs(sMain) do
                            if y.name == A then
                                if f ~= y.zoomOffset and g ~= y.camOffset then
                                    f = y.zoomOffset;
                                    g = y.camOffset
                                end
                                RageUI.Button(y.label, "~b~Sneaky~s~Life.", {
                                    RightLabel = "→"
                                }, true, function(k, l, m)
                                    if l then
                                        sData = y.name;
                                        GetComponents()
                                        SwitchCam(false, y.name)
                                    end
                                end, RMenu:Get("creator", "characteroptions_m"))
                            end
                        end
                    end
                end)
                RageUI.IsVisible(RMenu:Get('creator', 'characteroptions_s'), true, false, true, function()
                    FreezeEntityPosition(GetPlayerPed(-1), true)
                    for z, y in pairs(Components) do
                        if y.name == sData then
                            for B = 0, ComponentsMax[sData] do
                                RageUI.Button(y.label .. " N°" .. B, "~b~Sneaky~s~Life.", {
                                    RightLabel = "→"
                                }, true, function(k, l, m)
                                    if l then
                                        if sLoaded ~= B then
                                            sLoaded = B;
                                            TriggerEvent('Sneakyskinchanger:change', y.name, B)
                                        end
                                    end
                                end)
                            end
                        end
                    end
                end)
                RageUI.IsVisible(RMenu:Get('creator', 'characteroptions_m'), true, false, true, function()
                    FreezeEntityPosition(GetPlayerPed(-1), true)
                    for z, y in pairs(Components) do
                        if y.name == sData then
                            for B = 0, ComponentsMax[sData] do
                                RageUI.Button(y.label .. " N°" .. B, "~b~Sneaky~s~Life.", {
                                    RightLabel = "→"
                                }, true, function(k, l, m)
                                    if l then
                                        if sLoaded ~= B then
                                            sLoaded = B;
                                            TriggerEvent('Sneakyskinchanger:change', y.name, B)
                                        end
                                    end
                                end)
                            end
                        end
                    end
                end)
                RageUI.IsVisible(RMenu:Get('creator', 'characteroptionshead'), true, false, true, function()
                    FreezeEntityPosition(GetPlayerPed(-1), true)
                    for x, y in pairs(Components) do
                        for z, C in pairs(sHead) do
                            if f ~= y.zoomOffset and g ~= y.camOffset then
                                f = y.zoomOffset;
                                g = y.camOffset
                            end
                            if y.name == C then
                                RageUI.Button(y.label, "~b~Sneaky~s~Life.", {
                                    RightLabel = "→"
                                }, true, function(k, l, m)
                                    if l then
                                        sData = y.name;
                                        SwitchCam(false, y.name)
                                    end
                                end, RMenu:Get("creator", "characteroptions_h"))
                            end
                        end
                    end
                end)
                RageUI.IsVisible(RMenu:Get('creator', 'characteroptions_h'), true, false, true, function()
                    FreezeEntityPosition(GetPlayerPed(-1), true)
                    for z, y in pairs(Components) do
                        if y.name == sData then
                            for B = 0, ComponentsMax[sData] do
                                RageUI.Button(y.label .. " N°" .. B, "~b~Sneaky~s~Life.", {
                                    RightLabel = "→"
                                }, true, function(k, l, m)
                                    if l then
                                        if sLoaded ~= B then
                                            sLoaded = B;
                                            TriggerEvent('Sneakyskinchanger:change', y.name, B)
                                        end
                                    end
                                end)
                            end
                        end
                    end
                end)
                RageUI.IsVisible(RMenu:Get('creator', 'characteroptionsclothes'), true, false, true, function()
                    FreezeEntityPosition(GetPlayerPed(-1), true)
                    for x, y in pairs(Components) do
                        for z, D in pairs(sClothes) do
                            if f ~= y.zoomOffset and g ~= y.camOffset then
                                f = y.zoomOffset;
                                g = y.camOffset
                            end
                            if y.name == D then
                                RageUI.Button(y.label, "~b~Sneaky~s~Life.", {
                                    RightLabel = "→"
                                }, true, function(k, l, m)
                                    if l then
                                        sData = y.name;
                                        SwitchCam(false, y.name)
                                    end
                                end, RMenu:Get("creator", "characteroptions_c"))
                            end
                        end
                    end
                end)
                RageUI.IsVisible(RMenu:Get('creator', 'characteroptions_c'), true, false, true, function()
                    FreezeEntityPosition(GetPlayerPed(-1), true)
                    for z, y in pairs(Components) do
                        if y.name == sData then
                            for B = 0, ComponentsMax[sData] do
                                RageUI.Button(y.label .. " N°" .. B, "~b~Sneaky~s~Life.", {
                                    RightLabel = "→"
                                }, true, function(k, l, m)
                                    if l then
                                        if sLoaded ~= B then
                                            sLoaded = B;
                                            TriggerEvent('Sneakyskinchanger:change', y.name, B)
                                        end
                                    end
                                    if m then
                                        GetComponents()
                                    end
                                end)
                            end
                        end
                    end
                end)
                RageUI.IsVisible(RMenu:Get('creator', 'characteroptionsaccessories'), true, false, true, function()
                    FreezeEntityPosition(GetPlayerPed(-1), true)
                    for x, y in pairs(Components) do
                        for z, E in pairs(sAccessories) do
                            if f ~= y.zoomOffset and g ~= y.camOffset then
                                f = y.zoomOffset;
                                g = y.camOffset
                            end
                            if y.name == E then
                                RageUI.Button(y.label, "~b~Sneaky~s~Life.", {
                                    RightLabel = "→"
                                }, true, function(k, l, m)
                                    if l then
                                        sData = y.name;
                                        SwitchCam(false, y.name)
                                    end
                                    if m then
                                        GetComponents()
                                    end
                                end, RMenu:Get("creator", "characteroptions_a"))
                            end
                        end
                    end
                end)
                RageUI.IsVisible(RMenu:Get('creator', 'characteroptions_a'), true, false, true, function()
                    FreezeEntityPosition(GetPlayerPed(-1), true)
                    for z, y in pairs(Components) do
                        if y.name == sData then
                            for B = 0, ComponentsMax[sData] do
                                RageUI.Button(y.label .. " N°" .. B, "~b~Sneaky~s~Life.", {
                                    RightLabel = "→"
                                }, true, function(k, l, m)
                                    if l then
                                        if sLoaded ~= B then
                                            sLoaded = B;
                                            TriggerEvent('Sneakyskinchanger:change', y.name, B)
                                        end
                                    end
                                    if m then
                                        GetComponents()
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

function verifyName(name)
	local nameLength = string.len(name)

	if nameLength > 25 or nameLength < 2 then
		return 'Votre nom est trop court ou trop long.'
	end

	local count = 0

	for i in name:gmatch('[abcdefghijklmnopqrstuvwxyzåäöABCDEFGHIJKLMNOPQRSTUVWXYZÅÄÖ0123456789 -]') do
		count = count + 1
	end

	if count ~= nameLength then
		return 'Your player name contains special characters that are not allowed on this server.'
	end

	local spacesInName = 0
	local spacesWithUpper = 0

	for word in string.gmatch(name, '%S+') do
		if string.match(word, '%u') then
			spacesWithUpper = spacesWithUpper + 1
		end

		spacesInName = spacesInName + 1
	end

	if spacesInName > 2 then
		return 'Votre nom contient plus de deux espaces'
	end
	
	if spacesWithUpper ~= spacesInName then
		return 'votre nom doit commencer par une lettre majuscule.'
	end

	return
end



function sKeyboardInput(F, G, H)
    AddTextEntry('FMMC_KEY_TIP1', F)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", G, "", "", "", H)
    blockinput = true;
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local I = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false;
        return I
    else
        Citizen.Wait(500)
        blockinput = false;
        return nil
    end
end
local J = {{
    item = "default",
    cam = {0.0, 3.0, 0.0},
    lookAt = {0.0, 0.0, 0.0},
    fov = 40.0
}, {
    item = "default_face",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 35.0
}, {
    item = "face",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 20.0
}, {
    item = "skin",
    cam = {0.0, 2.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 30.0
}, {
    item = "tshirt_1",
    cam = {0.0, 2.0, 0.35},
    lookAt = {0.0, 0.0, 0.35},
    fov = 30.0
}, {
    item = "tshirt_2",
    cam = {0.0, 2.0, 0.35},
    lookAt = {0.0, 0.0, 0.35},
    fov = 30.0
}, {
    item = "torso_1",
    cam = {0.0, 2.0, 0.35},
    lookAt = {0.0, 0.0, 0.35},
    fov = 30.0
}, {
    item = "torso_2",
    cam = {0.0, 2.0, 0.35},
    lookAt = {0.0, 0.0, 0.35},
    fov = 30.0
}, {
    item = "decals_1",
    cam = {0.0, 2.0, 0.0},
    lookAt = {0.0, 0.0, 0.0},
    fov = 40.0
}, {
    item = "decals_2",
    cam = {0.0, 2.0, 0.0},
    lookAt = {0.0, 0.0, 0.0},
    fov = 40.0
}, {
    item = "arms",
    cam = {0.0, 2.0, 0.0},
    lookAt = {0.0, 0.0, 0.0},
    fov = 40.0
}, {
    item = "arms_2",
    cam = {0.0, 2.0, 0.0},
    lookAt = {0.0, 0.0, 0.0},
    fov = 40.0
}, {
    item = "pants_1",
    cam = {0.0, 2.0, -0.35},
    lookAt = {0.0, 0.0, -0.4},
    fov = 35.0
}, {
    item = "pants_2",
    cam = {0.0, 2.0, -0.35},
    lookAt = {0.0, 0.0, -0.4},
    fov = 35.0
}, {
    item = "shoes_1",
    cam = {0.0, 2.0, -0.5},
    lookAt = {0.0, 0.0, -0.6},
    fov = 40.0
}, {
    item = "shoes_2",
    cam = {0.0, 2.0, -0.5},
    lookAt = {0.0, 0.0, -0.6},
    fov = 25.0
}, {
    item = "age_1",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "age_2",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "beard_1",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "beard_2",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "beard_3",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "beard_4",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "hair_1",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "hair_2",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "hair_color_1",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "hair_color_2",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "eye_color",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "eyebrows_1",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "eyebrows_2",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "eyebrows_3",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "eyebrows_4",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "makeup_1",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "makeup_2",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "makeup_3",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "makeup_4",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "lipstick_1",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "lipstick_2",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "lipstick_3",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "lipstick_4",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "blemishes_1",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "blemishes_2",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "blush_1",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "blush_2",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "blush_3",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "complexion_1",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "complexion_2",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "sun_1",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "sun_2",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "moles_1",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "moles_2",
    cam = {0.0, 2.0, 0.0},
    lookAt = {0.0, 0.0, 0.0},
    fov = 40.0
}, {
    item = "chest_1",
    cam = {0.0, 2.0, 0.0},
    lookAt = {0.0, 0.0, 0.0},
    fov = 40.0
}, {
    item = "chest_2",
    cam = {0.0, 2.0, 0.0},
    lookAt = {0.0, 0.0, 0.0},
    fov = 40.0
}, {
    item = "chest_3",
    cam = {0.0, 2.0, 0.0},
    lookAt = {0.0, 0.0, 0.0},
    fov = 40.0
}, {
    item = "bodyb_1",
    cam = {0.0, 2.0, 0.0},
    lookAt = {0.0, 0.0, 0.0},
    fov = 40.0
}, {
    item = "bodyb_2",
    cam = {0.0, 2.0, 0.0},
    lookAt = {0.0, 0.0, 0.0},
    fov = 40.0
}, {
    item = "ears_1",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 35.0
}, {
    item = "ears_2",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 35.0
}, {
    item = "mask_1",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 20.0
}, {
    item = "mask_2",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 20.0
}, {
    item = "bproof_1",
    cam = {0.0, 2.0, 0.0},
    lookAt = {0.0, 0.0, 0.0},
    fov = 40.0
}, {
    item = "bproof_2",
    cam = {0.0, 2.0, 0.0},
    lookAt = {0.0, 0.0, 0.0},
    fov = 40.0
}, {
    item = "chain_1",
    cam = {0.0, 2.0, 0.0},
    lookAt = {0.0, 0.0, 0.0},
    fov = 40.0
}, {
    item = "chain_2",
    cam = {0.0, 2.0, 0.0},
    lookAt = {0.0, 0.0, 0.0},
    fov = 40.0
}, {
    item = "bags_1",
    cam = {0.0, -2.0, 0.35},
    lookAt = {0.0, 0.0, 0.35},
    fov = 30.0
}, {
    item = "bags_2",
    cam = {0.0, -2.0, 0.35},
    lookAt = {0.0, 0.0, 0.35},
    fov = 30.0
}, {
    item = "helmet_1",
    cam = {0.0, 1.0, 0.73},
    lookAt = {0.0, 0.0, 0.68},
    fov = 20.0
}, {
    item = "helmet_2",
    cam = {0.0, 1.0, 0.73},
    lookAt = {0.0, 0.0, 0.68},
    fov = 20.0
}, {
    item = "glasses_1",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "glasses_2",
    cam = {0.0, 1.0, 0.7},
    lookAt = {0.0, 0.0, 0.65},
    fov = 25.0
}, {
    item = "watches_1",
    cam = {0.0, 2.0, 0.0},
    lookAt = {0.0, 0.0, 0.0},
    fov = 40.0
}, {
    item = "watches_2",
    cam = {0.0, 2.0, 0.0},
    lookAt = {0.0, 0.0, 0.0},
    fov = 40.0
}, {
    item = "bracelets_1",
    cam = {0.0, 2.0, 0.0},
    lookAt = {0.0, 0.0, 0.0},
    fov = 40.0
}, {
    item = "bracelets_2",
    cam = {0.0, 2.0, 0.0},
    lookAt = {0.0, 0.0, 0.0},
    fov = 40.0
}}
function GetCamOffset(K)
    for x, y in pairs(J) do
        if y.item == K then
            return y
        end
    end
end
function CreateCreatorCam()
    Citizen.CreateThread(function()
        local L = GetPlayerPed(-1)
        local M = GetCamOffset("default")
        local N = GetOffsetFromEntityInWorldCoords(L, M.cam[1], M.cam[2], M.cam[3])
        local O = GetOffsetFromEntityInWorldCoords(L, M.lookAt[1], M.lookAt[2], M.lookAt[3])
        CreatorCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 0)
        SetCamActive(CreatorCam, 1)
        SetCamCoord(CreatorCam, N.x, N.y, N.z)
        SetCamFov(CreatorCam, M.fov)
        PointCamAtCoord(CreatorCam, O.x, O.y, O.z)
        RenderScriptCams(1, 1, 1000, 0, 0)
    end)
end
function SwitchCam(P, K)
    if not DoesCamExist(cam2) then
        cam2 = CreateCam("DEFAULT_SCRIPTED_CAMERA", 0)
    end
    Citizen.CreateThread(function()
        local L = GetPlayerPed(-1)
        local M = GetCamOffset(K)
        if M == nil then
            M = GetCamOffset("default")
        end
        local N = GetOffsetFromEntityInWorldCoords(L, M.cam[1], M.cam[2], M.cam[3])
        local O = GetOffsetFromEntityInWorldCoords(L, M.lookAt[1], M.lookAt[2], M.lookAt[3])
        if P then
            SetCamActive(CreatorCam, 1)
            SetCamCoord(CreatorCam, N.x, N.y, N.z)
            SetCamFov(CreatorCam, M.fov)
            PointCamAtCoord(CreatorCam, O.x, O.y, O.z)
            SetCamActiveWithInterp(CreatorCam, cam2, 1000, 1, 1)
            Wait(1000)
        else
            SetCamActive(cam2, 1)
            SetCamCoord(cam2, N.x, N.y, N.z)
            SetCamFov(cam2, M.fov)
            PointCamAtCoord(cam2, O.x, O.y, O.z)
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
function StartCreatorEndCinematic()
    local L = GetPlayerPed(-1)
    DoScreenFadeOut(1000)
    local Q = true;
    DisplayRadar(false)
    PlayUrl("cin_music", "https://www.youtube.com/watch?v=gMotH6XH2tQ", 0.1, false)
    Citizen.CreateThread(function()
        while Q do
            DisableControlAction(1, 1, true)
            DisableControlAction(1, 2, true)
            DisableControlAction(1, 4, true)
            DisableControlAction(1, 6, true)
            DisableControlAction(1, 270, true)
            DisableControlAction(1, 271, true)
            DisableControlAction(1, 272, true)
            DisableControlAction(1, 273, true)
            DisableControlAction(1, 282, true)
            DisableControlAction(1, 283, true)
            DisableControlAction(1, 284, true)
            DisableControlAction(1, 285, true)
            DisableControlAction(1, 286, true)
            DisableControlAction(1, 290, true)
            DisableControlAction(1, 291, true)
            Wait(1)
            for y in EnumeratePeds() do
                if y ~= L then
                    SetEntityAlpha(y, 0, 0)
                    SetEntityNoCollisionEntity(L, y, false)
                    NetworkConcealPlayer(NetworkGetPlayerIndexFromPed(y), true, 1)
                end
            end
        end
        for y in EnumeratePeds() do
            if y ~= L then
                ResetEntityAlpha(y)
                SetEntityNoCollisionEntity(y, L, true)
                NetworkConcealPlayer(NetworkGetPlayerIndexFromPed(y), false, 1)
            end
        end
    end)
    Wait(2000)
    NetworkOverrideClockTime(18, 00, 0)
    --SetOverrideWeather("EXTRASUNNY")
    SetEntityCoordsNoOffset(L, -878.88, -439.03, 39.6, 0.0, 0.0, 0.0)
    SetEntityHeading(L, 292.98)
    local cam2 = CreateCam("DEFAULT_SCRIPTED_CAMERA", 0)
    local R = CreateCam("DEFAULT_SCRIPTED_CAMERA", 0)
    local N = GetOffsetFromEntityInWorldCoords(L, 1.0, 1.0, -1.0)
    local O = GetOffsetFromEntityInWorldCoords(L, 0.0, 0.0, 0.7)
    SetCamActive(R, 1)
    SetCamCoord(R, N.x, N.y, N.z)
    SetCamFov(R, 75.0)
    PointCamAtCoord(R, O.x, O.y, O.z)
    RenderScriptCams(1, 1, 0, 0, 0)
    TaskStartScenarioInPlace(L, "CODE_HUMAN_CROSS_ROAD_WAIT", -1, 0)
    DoScreenFadeIn(1500)
    local N = GetOffsetFromEntityInWorldCoords(L, -1.0, 1.0, 1.2)
    local O = GetOffsetFromEntityInWorldCoords(L, 0.0, 0.0, 0.7)
    SetCamActive(cam2, 1)
    SetCamCoord(cam2, N.x, N.y, N.z)
    SetCamFov(cam2, 20.0)
    PointCamAtCoord(cam2, O.x, O.y, O.z)
    SetCamActiveWithInterp(cam2, R, 12000, 1, 1)
    Wait(11500)
    local N = vector3(-870.78, -422.1, 36.64)
    SetCamCoord(cam2, N.x, N.y, N.z)
    PointCamAtEntity(cam2, L, 1.0, 1.0, 1.0, 0)
    SetCamFov(cam2, 15.0)
    ClearPedTasks(L)
    TaskGoToCoordAnyMeans(L, -867.95, -432.98, 36.64, 1.0, 0, 0, 786603, 0)
    Wait(7000)
    local N = vector3(-859.03, -424.48, 36.64)
    SetCamCoord(cam2, N.x, N.y, N.z)
    PointCamAtEntity(cam2, L, 1.0, 1.0, 1.0, 0)
    SetCamFov(cam2, 35.0)
    RenderScriptCams(0, 1, 12000, 0, 0)
    Wait(11000)
    Q = false;
    DisplayRadar(true)
    local S = 1.0;
    while S > 0.0 do
        S = getVolume("cin_music") - 0.02;
        setVolume("cin_music", S)
        Wait(500)
    end
    Destroy("cin_music")
    TriggerServerEvent('instancecreator:reset', 0)
end
local function T(U, V, W)
    return coroutine.wrap(function()
        local X, Y = U()
        if not Y or Y == 0 then
            W(X)
            return
        end
        local Z = {
            handle = X,
            destructor = W
        }
        setmetatable(Z, entityEnumerator)
        local _ = true;
        repeat
            coroutine.yield(Y)
            _, Y = V(X)
        until not _;
        Z.destructor, Z.handle = nil, nil;
        W(X)
    end)
end
function EnumeratePeds()
    return T(FindFirstPed, FindNextPed, EndFindPed)
end
