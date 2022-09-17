ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
end)
cooldown = false

local ConfigLocation = {
    Positions  = {

        -- Vehicle

        {
            name = "Location véhicules n°1",
            pos = vector3(5117.9995117188,-5190.8530273438,2.3830344676971),
            zone = 1,
            banner = "shopui_title_heist",
            spawnVeh = vector3(5113.8310546875,-5189.6127929688,2.3841414451599),
            headingVeh = 189.56,
            Vehicles = {
                {label = "Rumpo Custom", model = "rumpo3", price = 250 },
                {label = "Youga 4x4", model = "youga3", price = 250 },
                {label = "Manchez", model = "manchez2", price = 150 },
                {label = "Sanchez", model = "sanchez2", price = 250 },
                {label = "Comet Safari", model = "comet4", price = 400 },
                {label = "Seminole Frontier", model = "seminole2", price = 350 },
                {label = "Hellion", model = "hellion", price = 450 },
                {label = "Verus", model = "verus", price = 250 },
                {label = "Kalahari", model = "kalahari", price = 150 },
                {label = "Outlaw ", model = "outlaw", price = 550 },
                {label = "Winky", model = "winky", price = 350 },
                {label = "Yosemite Rancher", model = "yosemite3", price = 325 },
            },
        },
        {
            name = "Location véhicules n°2",
            pos = vector3(5054.3408203125,-4597.2045898438,2.8794636726379),
            zone = 1,
            banner = "shopui_title_heist",
            spawnVeh = vector3(5050.134765625,-4599.1162109375,2.9035685062408),
            headingVeh = 143.35,
            Vehicles = {
                {label = "Rumpo Custom", model = "rumpo3", price = 250 },
                {label = "Youga 4x4", model = "youga3", price = 250 },
                {label = "Manchez", model = "manchez2", price = 150 },
                {label = "Sanchez", model = "sanchez2", price = 250 },
                {label = "Comet Safari", model = "comet4", price = 400 },
                {label = "Seminole Frontier", model = "seminole2", price = 350 },
                {label = "Hellion", model = "hellion", price = 450 },
                {label = "Verus", model = "verus", price = 250 },
                {label = "Kalahari", model = "kalahari", price = 150 },
                {label = "Outlaw ", model = "outlaw", price = 550 },
                {label = "Winky", model = "winky", price = 350 },
                {label = "Yosemite Rancher", model = "yosemite3", price = 325 },
            },
        },
        {
            name = "Location véhicules n°3",
            pos = vector3(4502.6494140625,-4540.6435546875,4.1091642379761),
            zone = 1,
            banner = "shopui_title_heist",
            spawnVeh = vector3(4499.3754882812,-4539.0380859375,4.1474990844727),
            headingVeh = 296.45,
            Vehicles = {
                {label = "Rumpo Custom", model = "rumpo3", price = 250 },
                {label = "Youga 4x4", model = "youga3", price = 250 },
                {label = "Manchez", model = "manchez2", price = 150 },
                {label = "Sanchez", model = "sanchez2", price = 250 },
                {label = "Comet Safari", model = "comet4", price = 400 },
                {label = "Seminole Frontier", model = "seminole2", price = 350 },
                {label = "Hellion", model = "hellion", price = 450 },
                {label = "Verus", model = "verus", price = 250 },
                {label = "Kalahari", model = "kalahari", price = 150 },
                {label = "Outlaw ", model = "outlaw", price = 550 },
                {label = "Winky", model = "winky", price = 350 },
                {label = "Yosemite Rancher", model = "yosemite3", price = 325 },
            },
        },
        {
            name = "Location véhicules n°4",
            pos = vector3(-867.38940429688,-436.6012878418,36.765110015869),
            zone = 1,
            banner = "shopui_title_heist",
            spawnVeh = vector3(-859.29022216797,-431.40963745117,36.63990020752),
            headingVeh = 256.51,
            Vehicles = {
                {label = "Fixter", model = "fixter", price =  15}
            },
        },

        -- Boat

        {
            name = "Location bateaux n°1",
            pos = vector3(4771.3422851562,-4771.8676757812,4.855170249939),
            zone = 2,
            banner = "shopui_title_docktease",
            spawnVeh = vector3(4767.041015625,-4764.2504882812,-0.47437983751297),
            headingVeh = 334.10,
            Vehicles = {
                {label = "Jetski", model = "seashark", price = 250 },
                {label = "Jetmax", model = "jetmax", price = 500 },
                {label = "Speeder", model = "speeder", price = 900 },
                {label = "Squalo", model = "squalo", price = 800 },
                {label = "Suntrap", model = "suntrap", price = 400 },
                {label = "Toro", model = "toro", price = 1100 },
                {label = "Toro noir", model = "toro2", price = 1100 },
                {label = "Tropic", model = "tropic", price = 550 },
                {label = "Tropic 2", model = "tropic2", price = 550 }
            },
        },

        {
            name = "Location bateaux n°2",
            pos = vector3(-1604.5867919922,5256.6557617188,2.0742933750153),
            zone = 2,
            banner = "shopui_title_docktease",
            spawnVeh = vector3(-1600.2327880859,5260.6791992188,-0.47476971149445),
            headingVeh = 205.12,
            Vehicles = {
                {label = "Jetski", model = "seashark", price = 250 },
                {label = "Jetmax", model = "jetmax", price = 500 },
                {label = "Speeder", model = "speeder", price = 900 },
                {label = "Squalo", model = "squalo", price = 800 },
                {label = "Suntrap", model = "suntrap", price = 400 },
                {label = "Toro", model = "toro", price = 1100 },
                {label = "Toro noir", model = "toro2", price = 1100 },
                {label = "Tropic", model = "tropic", price = 550 },
                {label = "Tropic 2", model = "tropic2", price = 550 }
            },
        },

        {
            name = "Location bateaux n°3",
            pos = vector3(3859.9118652344,4465.4848632812,2.7424740791321),
            zone = 2,
            banner = "shopui_title_docktease",
            spawnVeh = vector3(3862.5405273438,4472.4145507812,-0.47478523850441),
            headingVeh = 272.31,
            Vehicles = {
                {label = "Jetski", model = "seashark", price = 250 },
                {label = "Jetmax", model = "jetmax", price = 500 },
                {label = "Speeder", model = "speeder", price = 900 },
                {label = "Squalo", model = "squalo", price = 800 },
                {label = "Suntrap", model = "suntrap", price = 400 },
                {label = "Toro", model = "toro", price = 1100 },
                {label = "Toro noir", model = "toro2", price = 1100 },
                {label = "Tropic", model = "tropic", price = 550 },
                {label = "Tropic 2", model = "tropic2", price = 550 }
            },
        },

        {
            name = "Location bateaux n°4",
            pos = vector3(-718.69055175781,-1327.7019042969,1.5962892770767),
            zone = 2,
            banner = "shopui_title_docktease",
            spawnVeh = vector3(-726.65869140625,-1326.8469238281,-0.47475722432137),
            headingVeh = 229.18,
            Vehicles = {
                {label = "Jetski", model = "seashark", price = 250 },
                {label = "Jetmax", model = "jetmax", price = 500 },
                {label = "Speeder", model = "speeder", price = 900 },
                {label = "Squalo", model = "squalo", price = 800 },
                {label = "Suntrap", model = "suntrap", price = 400 },
                {label = "Toro", model = "toro", price = 1100 },
                {label = "Toro noir", model = "toro2", price = 1100 },
                {label = "Tropic", model = "tropic", price = 550 },
                {label = "Tropic 2", model = "tropic2", price = 550 }
            },
        },

        {
            name = "Location bateaux n°5",
            pos = vector3(4902.79296875,-5178.9291992188,2.5016989707947),
            zone = 2,
            banner = "shopui_title_docktease",
            spawnVeh = vector3(4911.56640625,-5177.193359375,-0.37958565354347),
            headingVeh = 337.43,
            Vehicles = {
                {label = "Jetski", model = "seashark", price = 250 },
                {label = "Jetmax", model = "jetmax", price = 500 },
                {label = "Speeder", model = "speeder", price = 900 },
                {label = "Squalo", model = "squalo", price = 800 },
                {label = "Suntrap", model = "suntrap", price = 400 },
                {label = "Toro", model = "toro", price = 1100 },
                {label = "Toro noir", model = "toro2", price = 1100 },
                {label = "Tropic", model = "tropic", price = 550 },
                {label = "Tropic 2", model = "tropic2", price = 550 }
            },
        },

        {
            name = "Location bateaux n°6",
            pos = vector3(5118.83984375,-4631.443359375,1.4057340621948),
            zone = 2,
            banner = "shopui_title_docktease",
            spawnVeh = vector3(5113.080078125,-4634.3725585938,-0.47463163733482),
            headingVeh = 161.51,
            Vehicles = {
                {label = "Jetski", model = "seashark", price = 250 },
                {label = "Jetmax", model = "jetmax", price = 500 },
                {label = "Speeder", model = "speeder", price = 900 },
                {label = "Squalo", model = "squalo", price = 800 },
                {label = "Suntrap", model = "suntrap", price = 400 },
                {label = "Toro", model = "toro", price = 1100 },
                {label = "Toro noir", model = "toro2", price = 1100 },
                {label = "Tropic", model = "tropic", price = 550 },
                {label = "Tropic 2", model = "tropic2", price = 550 }
            },
        },

    },
}

function spawnVehicle(table, label, name, price)
    if openedLocation then
        openedLocation = false
        RageUI.CloseAll()
        FreezeEntityPosition(PlayerPedId(), false)
    end
    FreezeEntityPosition(PlayerPedId(), false)
    local model = GetHashKey(name)
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(10) end
    local locationVeh = CreateVehicle(model, table.spawnVeh, table.headingVeh, true, false)
    SetVehicleNumberPlateText(locationVeh, "Loc"..math.random(1,100))
    SetVehicleFixed(locationVeh)
    SetVehicleDirtLevel(locationVeh, 0.0)
    local plate = GetVehicleNumberPlateText(locationVeh)
    TriggerServerEvent("Sneakyesx_vehiclelock:givekey","no",plate)
    TriggerEvent('persistent-vehicles/register-vehicle', locationVeh)
    lastveh = locationVeh
    lastplate = GetVehicleNumberPlateText(locationVeh)
    TaskWarpPedIntoVehicle(PlayerPedId(), locationVeh, -1)
    RageUI.Popup({message = "Vous avez bien reçu votre ~b~"..label.."~s~ pour "..price.."~g~$~s~ !"})
end

RMenu.Add('location', 'main', RageUI.CreateMenu("", "Location", 0, 200))
RMenu:Get('location', 'main').EnableMouse = false

RMenu:Get('location', 'main').Closed = function()
    openedLocation = false
    FreezeEntityPosition(PlayerPedId(), false)
end

function openLocation(table)
    if openedLocation then
        openedLocation = false
    else
        openedLocation = true
        RageUI.Visible(RMenu:Get('location', 'main'), true)
        if table.zone == 1 then
            RMenu:Get('location', 'main'):SetSpriteBanner("root_cause","shopui_title_heist")
            RMenu:Get('location', 'main'):SetSubtitle("Location : ~b~Véhicules~s~")
        else
            RMenu:Get('location', 'main'):SetSpriteBanner("root_cause","shopui_title_docktease")
            RMenu:Get('location', 'main'):SetSubtitle("Location : ~b~Bateaux~s~")
        end
        FreezeEntityPosition(PlayerPedId(), true)
        Citizen.CreateThread(function()
            while openedLocation do
                RageUI.IsVisible(RMenu:Get('location', 'main'), true, false, true, function()
                    if table.zone == 1 then
                        RageUI.Separator("~b~↓~s~ Voitures à louer ~b~↓~s~")
                        for k,v in pairs(table.Vehicles) do
                            RageUI.Button(v.label, table.name, {RightLabel = "Louer → "..v.price.."~g~$"}, true, function(h,a,s)
                                if s then
                                    ESX.TriggerServerCallback("Faille:duBanquierLol", function(ok)
                                        if ok then
                                            spawnVehicle(table, v.label, v.model, v.price)
                                            cooldown = true
                                            Citizen.SetTimeout(1000*60*3, function()
                                                    cooldown = false
                                            end)
                                        else
                                            ESX.ShowNotification("~r~Vous n'avez pas assez d'argent")
                                        end
                                    end, v.price)
                                end
                            end)
                        end
                    else
                        RageUI.Separator("~b~↓~s~ Bateaux à louer ~b~↓~s~")
                        for k,v in pairs(table.Vehicles) do
                            RageUI.Button(v.label, table.name, {RightLabel = "Louer → "..v.price.."~g~$"}, true, function(h,a,s)
                                if s then
                                    if not ESX.Game.IsSpawnPointClear(table.spawnVeh, 2.5) then
                                        ESX.ShowNotification("~r~Impossible, la place n'est pas libre !")
                                    else
                                        ESX.TriggerServerCallback("Faille:duBanquierLol", function(ok)
                                            if ok then
                                                spawnVehicle(table, v.label, v.model, v.price)
                                                cooldown = true
                                                Citizen.SetTimeout(1000*60*3, function()
                                                    cooldown = false
                                                end)
                                            else
                                                ESX.ShowNotification("~r~Vous n'avez pas assez d'argent")
                                            end
                                        end, v.price)
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

Citizen.CreateThread(function()
    while true do 
        local myCoords = GetEntityCoords(PlayerPedId())
        local nofps = false

        if not cooldown then
            if not openedLocation then
                for k,v in pairs(ConfigLocation.Positions) do
                    if #(myCoords-v.pos) < 1.0 then
                        nofps = true
                        if v.zone == 1 then
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir la location de véhicules")
                        else
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir la location de bateaux")
                        end
                        if IsControlJustReleased(0, 38) then
                            openLocation(v)
                        end
                    end
                end
            end
        end

        if nofps then
            Wait(0)
        else
            Wait(850)
        end
    end
end)