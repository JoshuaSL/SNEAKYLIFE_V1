ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
        ESX.PlayerData = ESX.GetPlayerData()
    end
end)
SneakyEvent = TriggerServerEvent

local vehicle = {
    "beachp",
    "lspdb",
    "policeb",
    "police",
    "police2",
    "police3",
    "police4",
    "police42",
    "polriot",
    "polspeedo",
    "pscout",
    "emsroamer",
    "polcoquette",
    "scorcher",
    "sheriff2",
    "sheriffalamo",
    "sheriffcq4",
    "sherifffug",
    "sheriffinsurgent",
    "sheriffoss",
    "sheriffroamer",
    "sheriffrumpo",
    "sheriffscoutnew",
    "sheriffstalker",
    "sheriffthrust",
    "firetruk",
    "fbi2",
    "pressuv",
    "lspdmav",
    "sheriffmav",
    "stockade",
    "sbus",
    "busclassic",
    "pbus",
    "riot",
    'contender3',
    "policefelon",
    "polnspeedo",
    "rmodrs6police",
    "sheriffmav",
    "lssdmav",
    "ambulance",
    "ambulance2",
    "riatasr",
    "police3a",
    "police3slick",
    "police3umk",
    "polalamo",
    "polalamonew",
    "lspdgrangerk9",
    "police1k9",
    "police1k9b",
    "policek9",
    "lspdvant",
    "policefug",
    "policefug2",
    "polraiden",
    "sheriffcoqm",
    "sheriffcoqm2",
    "sheriffcoqm3",
    "sheriffcoqmumk",
    "umkscout",
}

Citizen.CreateThread(function()
    while true do
        if IsPedInAnyVehicle(PlayerPedId(), true) then
            Citizen.Wait(1)
            for i = 1, #vehicle,1 do 
                if IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), true), GetHashKey(vehicle[i])) then
                    local veh = GetVehiclePedIsUsing(GetPlayerPed(PlayerId()), false)
                    if (GetPedInVehicleSeat(veh, -1) == GetPlayerPed(PlayerId())) then
                        if ESX.PlayerData.job.name == "police" or ESX.PlayerData.job.name == "ambulance" or ESX.PlayerData.job.name == "lssd" or ESX.PlayerData.job.name == "gouvernement" then
                            SetVehicleUndriveable(veh, false)
                        else
                            ESX.ShowNotification("Un système de sécurité t'empêche de démarrer")
                            SetVehicleUndriveable(veh, true)
                        end
                    end
                end
            end
        else
            Citizen.Wait(1250)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsPedArmed(pPed, 6) then
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        else
            Wait(1250)
        end
    end
end)

pLoaded = false
skip = false

function SkipLogo()
    skip = true
end

local skipcinematic = false
if not skipcinematic then
    Citizen.CreateThread(function()
        Wait(2000)
        pPed = GetPlayerPed(-1)
        pVeh = GetVehiclePedIsIn(pPed, 0)
        pVehLast = GetVehiclePedIsIn(pPed, 1)

        StartAudioScene("MP_LEADERBOARD_SCENE")
        ActivateFrontendMenu('FE_MENU_VERSION_PRE_LOBBY', true, -1)
        local pos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, -0.5, 10.0)

        local spawnCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 0)
            
        SetCamActive(spawnCam, 1)
        SetCamCoord(spawnCam, pos.x, pos.y, pos.z)
        SetCamFov(spawnCam, 60.0)
        PointCamAtCoord(spawnCam, GetEntityCoords(GetPlayerPed(-1)))

        RenderScriptCams(1, 0, 1000, 0, 0)
        while not pLoaded do
            Wait(1)
            RageUI.Text({message = "Chargement de ton personnage ..."})
            DisableAllControlActions(1)
            local pos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, -0.5, 10.0)
            SetCamCoord(spawnCam, pos.x, pos.y, pos.z)
            PointCamAtCoord(spawnCam, GetEntityCoords(GetPlayerPed(-1)))
            pLoaded = true
            if skip then 
                break 
            end
        end

        DisableAllControlActions(0)
        StartAudioScene("MP_LEADERBOARD_SCENE")
        ActivateFrontendMenu('FE_MENU_VERSION_PRE_LOBBY', true, -1)
        Wait(1000)
        local pos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, -0.5, 10.0)

        local spawnCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 0)

        SetCamActive(spawnCam, 1)
        SetCamCoord(spawnCam, pos.x, pos.y, pos.z)
        SetCamFov(spawnCam, 60.0)
        PointCamAtCoord(spawnCam, GetEntityCoords(GetPlayerPed(-1)))

        RenderScriptCams(1, 0, 1000, 0, 0)

        RenderScriptCams(0, 1, 3500, 0, 0)
        SetCamActive(spawnCam, 0)
        Wait(1000)
        SendNUIMessage({ logo = true })

        StopAudioScenes()
        Wait(2000)
        ActivateFrontendMenu('FE_MENU_VERSION_PRE_LOBBY', false, -1)
        PlaySoundFrontend(-1, "CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
        Wait(2000)
        EnableAllControlActions(0)
        TriggerEvent("Animations:loadsave",true, true)
        StopAudioScenes()
        SetWeaponDamageModifier(133987706, 0.0)
        SetWeaponDamageModifier(-1553120962, 0.0)
    end)
end



local Faq = {}

local Faqmenu = {

    {
        pos = vector3(-870.46606445313,-430.01095581055,36.639907836914),
    },
}

RMenu.Add('faq', 'main', RageUI.CreateMenu("", "~b~Sneaky~s~Life", 0, 200,"root_cause","sneakylife"))
RMenu:Get('faq', 'main').EnableMouse = false
RMenu:Get('faq', 'main').Closed = function() Faq.Menu = false FreezeEntityPosition(GetPlayerPed(-1), false) end
function OpenFaqRageUIMenu()

    if Faq.Menu then
        Faq.Menu = false
    else
        Faq.Menu = true
        RageUI.Visible(RMenu:Get('faq', 'main'), true)
        FreezeEntityPosition(GetPlayerPed(-1), true)

        Citizen.CreateThread(function()
			while Faq.Menu do
                RageUI.IsVisible(RMenu:Get('faq', 'main'), true, false, true, function()
                    RageUI.Separator("FAQ ~b~Sneaky~s~Life")
                    RageUI.Button("Envie d'un véhicule ?", "Vous pouvez louer une voiture à mon collègue juste à droite", {}, true, function(_,_,s)
                    end)
                    RageUI.Button("Gagner votre premier salaire", "Pour commencer à te faire de l'argent, diriges-toi au PostOP sur les docks ou encore auprès des restaurants qui recrutent.", {}, true, function(_,_,s)
                    end)
                    RageUI.Separator("discord.gg/sneakylife")
                end)
				Wait(0)
			end
		end)
	end
end


Citizen.CreateThread(function()
    while true do
        att = 850
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs(Faqmenu) do
            local mPos = #(pCoords-v.pos)
            if not Faq.Menu then
                if mPos <= 10.0 then
                    att = 1
                    if mPos <= 1.5 then
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour interagir")
                        if IsControlJustPressed(0, 51) then
                            OpenFaqRageUIMenu()
                        end
                    end
                end
            end
        end
        Citizen.Wait(att)
    end
end)

local peds = {}
local GetGameTimer = GetGameTimer
local function draw3dText(coords, text)
    local camCoords = GetGameplayCamCoord()
    local dist = #(coords - camCoords)
    local scale = 200 / (GetGameplayCamFov() * dist)

    SetTextColour(230, 230, 230, 255)
    SetTextScale(0.0, 0.5 * scale)
    SetTextFont(4)
    SetTextDropshadow(0, 0, 0, 0, 55)
    SetTextDropShadow()
    SetTextCentre(true)

    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(coords, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()

end
local function displayText(ped, text)
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    local targetPos = GetEntityCoords(ped)
    local dist = #(playerPos - targetPos)
    local los = HasEntityClearLosToEntity(playerPed, ped, 17)

    if dist <= 250 and los then
        local exists = peds[ped] ~= nil

        peds[ped] = {
            time = GetGameTimer() + 5000,
            text = text
        }

        if not exists then
            local display = true

            while display do
                Wait(0)
                local pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, 1.0)
                draw3dText(pos, peds[ped].text)
                display = GetGameTimer() <= peds[ped].time
            end

            peds[ped] = nil
        end

    end
end

local function onShareDisplay(text, target)
    local player = GetPlayerFromServerId(target)
    if player ~= -1 or target == GetPlayerServerId(PlayerId()) then
        local ped = GetPlayerPed(player)
        displayText(ped, text)
    end
end

RegisterNetEvent('3dme:shareDisplay', onShareDisplay)

TriggerEvent('chat:addSuggestion', '/' .. 'me', 'Affiche une action au dessus de votre tête.', {{ name = 'action', help = '"se gratte le nez" par exemple.'}})

local handsup = false
local dict = "missminuteman_1ig_2"
RegisterCommand('+handsup', function()
    if not exports.inventaire:GetStateInventory() and not GetStateFishing() then 
        if not handsup then
            TaskPlayAnim(PlayerPedId(), dict, "handsup_enter", 8.0, 8.0, -1, 50, 0, false, false, false)
            handsup = true
        else
            handsup = false
            ClearPedTasks(PlayerPedId())
        end
    end
end, false)
RegisterKeyMapping('+handsup', 'Lever les mains', 'keyboard', 'l')
Citizen.CreateThread(function()
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(100)
	end
end) 

RegisterCommand("heading", function()
    print(GetEntityHeading(PlayerPedId()))
end)

function DrawTopNotification(txt, beep)
	BeginTextCommandDisplayHelp("jamyfafi")
	AddLongString(txt)
	EndTextCommandDisplayHelp(0, 0, beep, -1)
end

Ragdoll = false
RegisterCommand('+ragdoll', function()
    if not exports.inventaire:GetStateInventory() and not GetStateFishing() then
        Ragdoll = not Ragdoll
    end
end)

WeaponNames = {
	[tostring(GetHashKey('WEAPON_UNARMED'))] = 'Unarmed',
	[tostring(GetHashKey('GADGET_PARACHUTE'))] = 'Parachute',
	[tostring(GetHashKey('WEAPON_KNIFE'))] = 'Knife',
	[tostring(GetHashKey('WEAPON_NIGHTSTICK'))] = 'Nightstick',
	[tostring(GetHashKey('WEAPON_HAMMER'))] = 'Hammer',
	[tostring(GetHashKey('WEAPON_BAT'))] = 'Baseball Bat',
	[tostring(GetHashKey('WEAPON_CROWBAR'))] = 'Crowbar',
	[tostring(GetHashKey('WEAPON_GOLFCLUB'))] = 'Golf Club',
	[tostring(GetHashKey('WEAPON_BOTTLE'))] = 'Bottle',
	[tostring(GetHashKey('WEAPON_DAGGER'))] = 'Antique Cavalry Dagger',
	[tostring(GetHashKey('WEAPON_HATCHET'))] = 'Hatchet',
	[tostring(GetHashKey('WEAPON_KNUCKLE'))] = 'Knuckle Duster',
	[tostring(GetHashKey('WEAPON_MACHETE'))] = 'Machete',
	[tostring(GetHashKey('WEAPON_FLASHLIGHT'))] = 'Flashlight',
	[tostring(GetHashKey('WEAPON_SWITCHBLADE'))] = 'Switchblade',
	[tostring(GetHashKey('WEAPON_BATTLEAXE'))] = 'Battleaxe',
	[tostring(GetHashKey('WEAPON_POOLCUE'))] = 'Poolcue',
	[tostring(GetHashKey('WEAPON_PIPEWRENCH'))] = 'Wrench',
	[tostring(GetHashKey('WEAPON_STONE_HATCHET'))] = 'Stone Hatchet',

	[tostring(GetHashKey('WEAPON_PISTOL'))] = 'Pistol',
	[tostring(GetHashKey('WEAPON_PISTOL_MK2'))] = 'Pistol Mk2',
	[tostring(GetHashKey('WEAPON_COMBATPISTOL'))] = 'Combat Pistol',
	[tostring(GetHashKey('WEAPON_PISTOL50'))] = 'Pistol .50	',
	[tostring(GetHashKey('WEAPON_SNSPISTOL'))] = 'SNS Pistol',
	[tostring(GetHashKey('WEAPON_SNSPISTOL_MK2'))] = 'SNS Pistol Mk2',
	[tostring(GetHashKey('WEAPON_HEAVYPISTOL'))] = 'Heavy Pistol',
	[tostring(GetHashKey('WEAPON_VINTAGEPISTOL'))] = 'Vintage Pistol',
	[tostring(GetHashKey('WEAPON_MARKSMANPISTOL'))] = 'Marksman Pistol',
	[tostring(GetHashKey('WEAPON_REVOLVER'))] = 'Heavy Revolver',
	[tostring(GetHashKey('WEAPON_REVOLVER_MK2'))] = 'Heavy Revolver Mk2',
	[tostring(GetHashKey('WEAPON_DOUBLEACTION'))] = 'Double-Action Revolver',
	[tostring(GetHashKey('WEAPON_APPISTOL'))] = 'AP Pistol',
	[tostring(GetHashKey('WEAPON_STUNGUN'))] = 'Stun Gun',
	[tostring(GetHashKey('WEAPON_FLAREGUN'))] = 'Flare Gun',
	[tostring(GetHashKey('WEAPON_RAYPISTOL'))] = 'Up-n-Atomizer',

	[tostring(GetHashKey('WEAPON_MICROSMG'))] = 'Micro SMG',
	[tostring(GetHashKey('WEAPON_MACHINEPISTOL'))] = 'Machine Pistol',
	[tostring(GetHashKey('WEAPON_MINISMG'))] = 'Mini SMG',
	[tostring(GetHashKey('WEAPON_SMG'))] = 'SMG',
	[tostring(GetHashKey('WEAPON_SMG_MK2'))] = 'SMG Mk2	',
	[tostring(GetHashKey('WEAPON_ASSAULTSMG'))] = 'Assault SMG',
	[tostring(GetHashKey('WEAPON_COMBATPDW'))] = 'Combat PDW',
	[tostring(GetHashKey('WEAPON_MG'))] = 'MG',
	[tostring(GetHashKey('WEAPON_COMBATMG'))] = 'Combat MG	',
	[tostring(GetHashKey('WEAPON_COMBATMG_MK2'))] = 'Combat MG Mk2',
	[tostring(GetHashKey('WEAPON_GUSENBERG'))] = 'Gusenberg Sweeper',
	[tostring(GetHashKey('WEAPON_RAYCARBINE'))] = 'Unholy Deathbringer',

	[tostring(GetHashKey('WEAPON_ASSAULTRIFLE'))] = 'Assault Rifle',
	[tostring(GetHashKey('WEAPON_ASSAULTRIFLE_MK2'))] = 'Assault Rifle Mk2',
	[tostring(GetHashKey('WEAPON_CARBINERIFLE'))] = 'Carbine Rifle',
	[tostring(GetHashKey('WEAPON_CARBINERIFLE_MK2'))] = 'Carbine Rifle Mk2',
	[tostring(GetHashKey('WEAPON_ADVANCEDRIFLE'))] = 'Advanced Rifle',
	[tostring(GetHashKey('WEAPON_SPECIALCARBINE'))] = 'Special Carbine',
	[tostring(GetHashKey('WEAPON_SPECIALCARBINE_MK2'))] = 'Special Carbine Mk2',
	[tostring(GetHashKey('WEAPON_BULLPUPRIFLE'))] = 'Bullpup Rifle',
	[tostring(GetHashKey('WEAPON_BULLPUPRIFLE_MK2'))] = 'Bullpup Rifle Mk2',
	[tostring(GetHashKey('WEAPON_COMPACTRIFLE'))] = 'Compact Rifle',

	[tostring(GetHashKey('WEAPON_SNIPERRIFLE'))] = 'Sniper Rifle',
	[tostring(GetHashKey('WEAPON_HEAVYSNIPER'))] = 'Heavy Sniper',
	[tostring(GetHashKey('WEAPON_HEAVYSNIPER_MK2'))] = 'Heavy Sniper Mk2',
	[tostring(GetHashKey('WEAPON_MARKSMANRIFLE'))] = 'Marksman Rifle',
	[tostring(GetHashKey('WEAPON_MARKSMANRIFLE_MK2'))] = 'Marksman Rifle Mk2',

	[tostring(GetHashKey('WEAPON_GRENADE'))] = 'Grenade',
	[tostring(GetHashKey('WEAPON_STICKYBOMB'))] = 'Sticky Bomb',
	[tostring(GetHashKey('WEAPON_PROXMINE'))] = 'Proximity Mine',
	[tostring(GetHashKey('WAPAON_PIPEBOMB'))] = 'Pipe Bomb',
	[tostring(GetHashKey('WEAPON_SMOKEGRENADE'))] = 'Tear Gas',
	[tostring(GetHashKey('WEAPON_BZGAS'))] = 'BZ Gas',
	[tostring(GetHashKey('WEAPON_MOLOTOV'))] = 'Molotov',
	[tostring(GetHashKey('WEAPON_FIREEXTINGUISHER'))] = 'Fire Extinguisher',
	[tostring(GetHashKey('WEAPON_PETROLCAN'))] = 'Jerry Can',
	[tostring(GetHashKey('WEAPON_BALL'))] = 'Ball',
	[tostring(GetHashKey('WEAPON_SNOWBALL'))] = 'Snowball',
	[tostring(GetHashKey('WEAPON_FLARE'))] = 'Flare',

	[tostring(GetHashKey('WEAPON_GRENADELAUNCHER'))] = 'Grenade Launcher',
	[tostring(GetHashKey('WEAPON_RPG'))] = 'RPG',
	[tostring(GetHashKey('WEAPON_MINIGUN'))] = 'Minigun',
	[tostring(GetHashKey('WEAPON_FIREWORK'))] = 'Firework Launcher',
	[tostring(GetHashKey('WEAPON_RAILGUN'))] = 'Railgun',
	[tostring(GetHashKey('WEAPON_HOMINGLAUNCHER'))] = 'Homing Launcher',
	[tostring(GetHashKey('WEAPON_COMPACTLAUNCHER'))] = 'Compact Grenade Launcher',
	[tostring(GetHashKey('WEAPON_RAYMINIGUN'))] = 'Widowmaker',

	[tostring(GetHashKey('WEAPON_PUMPSHOTGUN'))] = 'Pump Shotgun',
	[tostring(GetHashKey('WEAPON_PUMPSHOTGUN_MK2'))] = 'Pump Shotgun Mk2',
	[tostring(GetHashKey('WEAPON_SAWNOFFSHOTGUN'))] = 'Sawed-off Shotgun',
	[tostring(GetHashKey('WEAPON_BULLPUPSHOTGUN'))] = 'Bullpup Shotgun',
	[tostring(GetHashKey('WEAPON_ASSAULTSHOTGUN'))] = 'Assault Shotgun',
	[tostring(GetHashKey('WEAPON_MUSKET'))] = 'Musket',
	[tostring(GetHashKey('WEAPON_HEAVYSHOTGUN'))] = 'Heavy Shotgun',
	[tostring(GetHashKey('WEAPON_DBSHOTGUN'))] = 'Double Barrel Shotgun',
	[tostring(GetHashKey('WEAPON_SWEEPERSHOTGUN'))] = 'Sweeper Shotgun',

	[tostring(GetHashKey('WEAPON_REMOTESNIPER'))] = 'Remote Sniper',
	[tostring(GetHashKey('WEAPON_GRENADELAUNCHER_SMOKE'))] = 'Smoke Grenade Launcher',
	[tostring(GetHashKey('WEAPON_PASSENGER_ROCKET'))] = 'Passenger Rocket',
	[tostring(GetHashKey('WEAPON_AIRSTRIKE_ROCKET'))] = 'Airstrike Rocket',
	[tostring(GetHashKey('WEAPON_STINGER'))] = 'Stinger [Vehicle]',
	[tostring(GetHashKey('OBJECT'))] = 'Object',
	[tostring(GetHashKey('VEHICLE_WEAPON_TANK'))] = 'Tank Cannon',
	[tostring(GetHashKey('VEHICLE_WEAPON_SPACE_ROCKET'))] = 'Rockets',
	[tostring(GetHashKey('VEHICLE_WEAPON_PLAYER_LASER'))] = 'Laser',
	[tostring(GetHashKey('AMMO_RPG'))] = 'Rocket',
	[tostring(GetHashKey('AMMO_TANK'))] = 'Tank',
	[tostring(GetHashKey('AMMO_SPACE_ROCKET'))] = 'Rocket',
	[tostring(GetHashKey('AMMO_PLAYER_LASER'))] = 'Laser',
	[tostring(GetHashKey('AMMO_ENEMY_LASER'))] = 'Laser',
	[tostring(GetHashKey('WEAPON_RAMMED_BY_CAR'))] = 'Rammed by Car',
	[tostring(GetHashKey('WEAPON_FIRE'))] = 'Fire',
	[tostring(GetHashKey('WEAPON_HELI_CRASH'))] = 'Heli Crash',
	[tostring(GetHashKey('WEAPON_RUN_OVER_BY_CAR'))] = 'Run over by Car',
	[tostring(GetHashKey('WEAPON_HIT_BY_WATER_CANNON'))] = 'Hit by Water Cannon',
	[tostring(GetHashKey('WEAPON_EXHAUSTION'))] = 'Exhaustion',
	[tostring(GetHashKey('WEAPON_EXPLOSION'))] = 'Explosion',
	[tostring(GetHashKey('WEAPON_ELECTRIC_FENCE'))] = 'Electric Fence',
	[tostring(GetHashKey('WEAPON_BLEEDING'))] = 'Bleeding',
	[tostring(GetHashKey('WEAPON_DROWNING_IN_VEHICLE'))] = 'Drowning in Vehicle',
	[tostring(GetHashKey('WEAPON_DROWNING'))] = 'Drowning',
	[tostring(GetHashKey('WEAPON_BARBED_WIRE'))] = 'Barbed Wire',
	[tostring(GetHashKey('WEAPON_VEHICLE_ROCKET'))] = 'Vehicle Rocket',
	[tostring(GetHashKey('VEHICLE_WEAPON_ROTORS'))] = 'Rotors',
	[tostring(GetHashKey('WEAPON_AIR_DEFENCE_GUN'))] = 'Air Defence Gun',
	[tostring(GetHashKey('WEAPON_ANIMAL'))] = 'Animal',
	[tostring(GetHashKey('WEAPON_COUGAR'))] = 'Cougar'
}

function hashToWeapon(hash)
	return weapons[hash]
end

function IsMelee(Weapon)
	local Weapons = {'WEAPON_UNARMED', 'WEAPON_CROWBAR', 'WEAPON_BAT', 'WEAPON_GOLFCLUB', 'WEAPON_HAMMER', 'WEAPON_NIGHTSTICK'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsTorch(Weapon)
	local Weapons = {'WEAPON_MOLOTOV'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsKnife(Weapon)
	local Weapons = {'WEAPON_DAGGER', 'WEAPON_KNIFE', 'WEAPON_SWITCHBLADE', 'WEAPON_HATCHET', 'WEAPON_BOTTLE'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsPistol(Weapon)
	local Weapons = {'WEAPON_SNSPISTOL', 'WEAPON_HEAVYPISTOL', 'WEAPON_VINTAGEPISTOL', 'WEAPON_PISTOL', 'WEAPON_APPISTOL', 'WEAPON_COMBATPISTOL'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsSub(Weapon)
	local Weapons = {'WEAPON_MICROSMG', 'WEAPON_SMG'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsRifle(Weapon)
	local Weapons = {'WEAPON_CARBINERIFLE', 'WEAPON_MUSKET', 'WEAPON_ADVANCEDRIFLE', 'WEAPON_ASSAULTRIFLE', 'WEAPON_SPECIALCARBINE', 'WEAPON_COMPACTRIFLE', 'WEAPON_BULLPUPRIFLE'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsLight(Weapon)
	local Weapons = {'WEAPON_MG', 'WEAPON_COMBATMG'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsShotgun(Weapon)
	local Weapons = {'WEAPON_BULLPUPSHOTGUN', 'WEAPON_ASSAULTSHOTGUN', 'WEAPON_DBSHOTGUN', 'WEAPON_PUMPSHOTGUN', 'WEAPON_HEAVYSHOTGUN', 'WEAPON_SAWNOFFSHOTGUN'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsSniper(Weapon)
	local Weapons = {'WEAPON_MARKSMANRIFLE', 'WEAPON_SNIPERRIFLE', 'WEAPON_HEAVYSNIPER', 'WEAPON_ASSAULTSNIPER', 'WEAPON_REMOTESNIPER'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsHeavy(Weapon)
	local Weapons = {'WEAPON_GRENADELAUNCHER', 'WEAPON_RPG', 'WEAPON_FLAREGUN', 'WEAPON_HOMINGLAUNCHER', 'WEAPON_FIREWORK', 'VEHICLE_WEAPON_TANK'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsMinigun(Weapon)
	local Weapons = {'WEAPON_MINIGUN'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsBomb(Weapon)
	local Weapons = {'WEAPON_GRENADE', 'WEAPON_PROXMINE', 'WEAPON_EXPLOSION', 'WEAPON_STICKYBOMB'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsVeh(Weapon)
	local Weapons = {'VEHICLE_WEAPON_ROTORS'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsVK(Weapon)
	local Weapons = {'WEAPON_RUN_OVER_BY_CAR', 'WEAPON_RAMMED_BY_CAR'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

Citizen.CreateThread(function()
    local DeathReason, Killer, DeathCauseHash, Weapon
	while true do
        if IsEntityDead(GetPlayerPed(PlayerId())) then
			Citizen.Wait(0)
			local PedKiller = GetPedSourceOfDeath(GetPlayerPed(PlayerId()))
			local killername = GetPlayerName(PedKiller)
			DeathCauseHash = GetPedCauseOfDeath(GetPlayerPed(PlayerId()))
			Weapon = WeaponNames[tostring(DeathCauseHash)]

			if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then
				Killer = NetworkGetPlayerIndexFromPed(PedKiller)
			elseif IsEntityAVehicle(PedKiller) and IsEntityAPed(GetPedInVehicleSeat(PedKiller, -1)) and IsPedAPlayer(GetPedInVehicleSeat(PedKiller, -1)) then
				Killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(PedKiller, -1))
			end

			if (Killer == PlayerId()) then
				DeathReason = 'committed suicide'
			elseif (Killer == nil) then
				DeathReason = 'died'
			else
				if IsMelee(DeathCauseHash) then
					DeathReason = 'murdered'
				elseif IsTorch(DeathCauseHash) then
					DeathReason = 'torched'
				elseif IsKnife(DeathCauseHash) then
					DeathReason = 'knifed'
				elseif IsPistol(DeathCauseHash) then
					DeathReason = 'pistoled'
				elseif IsSub(DeathCauseHash) then
					DeathReason = 'riddled'
				elseif IsRifle(DeathCauseHash) then
					DeathReason = 'rifled'
				elseif IsLight(DeathCauseHash) then
					DeathReason = 'machine gunned'
				elseif IsShotgun(DeathCauseHash) then
					DeathReason = 'pulverized'
				elseif IsSniper(DeathCauseHash) then
					DeathReason = 'sniped'
				elseif IsHeavy(DeathCauseHash) then
					DeathReason = 'obliterated'
				elseif IsMinigun(DeathCauseHash) then
					DeathReason = 'shredded'
				elseif IsBomb(DeathCauseHash) then
					DeathReason = 'bombed'
				elseif IsVeh(DeathCauseHash) then
					DeathReason = 'mowed over'
				elseif IsVK(DeathCauseHash) then
					DeathReason = 'flattened'
				else
					DeathReason = 'killed'
				end
			end

			if DeathReason == 'committed suicide' or DeathReason == 'died' then
				TriggerServerEvent('playerDied',1,GetPlayerServerId(PlayerId()),0,DeathReason,Weapon)
			else
				TriggerServerEvent('playerDied',2,GetPlayerServerId(PlayerId()),GetPlayerServerId(Killer),DeathReason,Weapon)
			end
			Killer = nil
			DeathReason = nil
			DeathCauseHash = nil
			Weapon = nil
		end
		local players = GetActivePlayers()
        SetScenarioPedDensityMultiplierThisFrame(1.0, 1.0)
        SetPedDensityMultiplierThisFrame(0.7)
        SetPedCanBeDraggedOut(PlayerPedId(), false)
        if IsPedInAnyVehicle(PlayerPedId()) and #players >= 15 then
            SetVehicleDensityMultiplierThisFrame(0.0)
            SetRandomVehicleDensityMultiplierThisFrame(0.0)
            SetParkedVehicleDensityMultiplierThisFrame(0.0)
        else
            SetVehicleDensityMultiplierThisFrame(0.2)
            SetRandomVehicleDensityMultiplierThisFrame(0.2)
            SetParkedVehicleDensityMultiplierThisFrame(0.2)
        end
        SetEntityProofs(PlayerPedId(), false, false, false, true, false, false, false, false)
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
        ResetPlayerStamina(PlayerId())
        SetMaxHealthHudDisplay(199)
        Citizen.InvokeNative(0x2F794A877ADD4C92, true)
        ClearAmbientZoneState("AZ_COUNTRYSIDE_PRISON_01_ANNOUNCER_GENERAL", 0, 0)
        ClearAmbientZoneState("AZ_COUNTRYSIDE_PRISON_01_ANNOUNCER_WARNING", 0, 0)
        SetPedParachuteTintIndex(PlayerPedId(), 3)
        SetPlayerParachuteSmokeTrailColor(PlayerId(), 0, 255, 0)
		SetPedSuffersCriticalHits(PlayerPedId(), false)
        SetPlayerVehicleDamageModifier(PlayerPedId(),0.1)
        SetPedConfigFlag(PlayerPedId(),34)
        SetPedConfigFlag(PlayerPedId(), 35)
		SetPedConfigFlag(PlayerPedId(), 149)
		SetPedConfigFlag(PlayerPedId(), 438)
        DisablePlayerVehicleRewards(PlayerId())
		SetPlayerHealthRechargeMultiplier(PlayerPedId(), 0.0)
		SetRunSprintMultiplierForPlayer(PlayerPedId(), 1.0)
		SetSwimMultiplierForPlayer(PlayerPedId(), 1.0)
		RestorePlayerStamina(GetPlayerIndex(), 1.0)
		if GetPlayerWantedLevel(GetPlayerIndex()) ~= 0 then
			ClearPlayerWantedLevel(GetPlayerIndex())
		end
        RemoveVehiclesFromGeneratorsInArea(2828.6281738281 - 90.0, 2791.5888671875 - 90.0, 57.682197570801 - 90.0, 2828.6281738281 + 90.0, 2791.5888671875 + 90.0, 57.682197570801 + 90.0)
		if IsControlPressed(0, 25) then 
            DisableControlAction(0, 22, true)
		end
        if Ragdoll then
            SetPedToRagdoll(PlayerPedId(),1000, 1000, 0, 0, 0, 0)
            ResetPedRagdollTimer(PlayerPedId())
            DrawTopNotification("Appuyez sur ~INPUT_CONTEXT~ ou ~INPUT_JUMP~ pour ~b~vous relever~w~.")
            if IsControlJustPressed(1, 51) or IsControlJustPressed(1, 22) then
                Ragdoll = not Ragdoll
            end
        end
        Wait(1)
	end
	for i = 1,15 do
        EnableDispatchService(i, false)
    end
    for ped in EnumeratePeds() do
        if not IsEntityDead(ped) then
            SetPedDropsWeaponsWhenDead(ped, false)
        end
    end
end)

function RequestAndWaitSet(setName)
	if setName and not HasAnimSetLoaded(setName) then
		RequestAnimSet(setName)

		local startTime = GetGameTimer()
		while not HasAnimSetLoaded(setName) and startTime + 3000 > GetGameTimer() do Citizen.Wait(100) end
	end
end

Crouch = false
RegisterCommand('+crouch', function()
    if not exports.inventaire:GetStateInventory() and not GetStateFishing() then
        if Crouch then
            ClearPedTasks(PlayerPedId())
            RemoveAnimSet("move_ped_crouched")
            ResetPedMovementClipset(PlayerPedId(), 1.0)
            Wait(500)
            TriggerEvent("Animations:loadsave",true, true)
        else
            RequestAndWaitSet("move_ped_crouched")
            SetPedMovementClipset(PlayerPedId(), "move_ped_crouched", 1.0)
        end
        Crouch = not Crouch
    end
end)
RegisterKeyMapping('+crouch', 'S\'accroupir', 'keyboard', 'LMENU')
RegisterKeyMapping('+ragdoll', 'S\'endormir / se réveiller', 'keyboard', 'j')

local function AddTextEntry(key, value)
    Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

Citizen.CreateThread(function()
    local playerName, playerId = "Invalid", 0
    while true do
        local waiting = 250
        if IsPauseMenuActive() then
            waiting = 1
            playerName, playerId = GetPlayerName(PlayerId()), GetPlayerServerId(PlayerId())
            N_0xb9449845f73f5e9c("SHIFT_CORONA_DESC")
            PushScaleformMovieFunctionParameterBool(true)
            PopScaleformMovieFunction()
            N_0xb9449845f73f5e9c("SET_HEADER_TITLE")
            PushScaleformMovieFunctionParameterString("~b~"..playerName.."~w~ [~b~"..playerId.."~w~] | discord.gg/sneakylife")
            PushScaleformMovieFunctionParameterBool(true)
            PushScaleformMovieFunctionParameterString("~b~Sneaky~s~Life")
            PushScaleformMovieFunctionParameterBool(true)
            PopScaleformMovieFunctionVoid()
        end
        Wait(waiting)
    end
end)

Citizen.CreateThread(function()
	SetDiscordAppId(806262457932316693)
	SetDiscordRichPresenceAsset('discord')
	SetRichPresence(("%s - %s"):format(GetPlayerName(PlayerId()), GetPlayerServerId(PlayerId())))
end)

Buttons = {
    {index = 0,name = 'Boutique',url = 'https://sneakylife-store.tebex.io'},
    {index = 1,name = 'Rejoindre',url = 'fivem://connect/46.105.139.134:30120'}
}

local firstSpawn = true
AddEventHandler('playerSpawned', function()
    if firstSpawn then
        for _, v in pairs(Buttons) do
            SetDiscordRichPresenceAction(v.index, v.name, v.url)
        end
        firstSpawn = false
    end
end)

function TriggerPlayerEvent(name, source, r, a)
    TriggerServerEvent("sCore:PlayerEvent", name, source, r, a, b, c, d)
end

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	for k,v in ipairs(ESX.PlayerData.accounts) do
		if v.name == account.name then
			ESX.PlayerData.accounts[k] = account
			break
		end
	end

	ESX.SetPlayerData('accounts', ESX.PlayerData.accounts)
	
	ESX.PlayerData = ESX.GetPlayerData()
	
	for i = 1, #ESX.PlayerData.accounts, 1 do
		if ESX.PlayerData.accounts[i].name == 'cash' then
			StatSetInt("MP0_WALLET_BALANCE", ESX.PlayerData.accounts[i].money, true)
		end 
	end 
end)
