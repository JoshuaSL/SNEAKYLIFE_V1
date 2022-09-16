ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
end)
local Garage = {}
SneakyEvent = TriggerServerEvent
local pGaragemenu = {

    {
        pos = vector3(-492.96612548828,46.558578491211,52.581588745117),
        places = {
            {pos = vector3(-496.31323242188,43.845539093018,52.157066345215),heading = 84.782,},
            {pos = vector3(-496.47894287109,40.07103729248,52.15739440918),heading = 85.742,},
            {pos = vector3(-496.45626831055,36.162197113037,52.157081604004),heading = 87.604,},
        },
        returnprice = 50,
        job = false,
    },

    {
        pos = vector3(-773.26690673828,5531.6098632812,33.4787940979),
        places = {
            {pos = vector3(-765.97906494141,5524.5263671875,32.91482925415),heading = 31.48,},
            {pos = vector3(-762.56787109375,5526.0834960938,32.919368743896),heading = 29.02,},
        },
        returnprice = 50,
        job = false,
    },

    {
        pos = vector3(275.48, -344.84, 45.17),
        places = {
            {pos = vector3(277.72, -340.2, 44.92),heading = 70.0,},
            {pos = vector3(278.94, -336.99, 44.92),heading = 70.0,},
            {pos = vector3(281.04,-330.43,44.41),heading = 69.63,},
            {pos = vector3(282.31,-327.21,44.41),heading = 70.16,},
            {pos = vector3(286.68,-332.45,44.41),heading = 249.21,},
            {pos = vector3(285.52,-335.69,44.41),heading = 248.57,},
        },
        returnprice = 50,
        job = false,
        blip = {
            label = "Garage", 
            ID = 357, 
            Color = 2
        },
    },
    {
        pos = vector3(317.68194580078,2623.5085449219,44.468318939209),
        places = {
            {pos = vector3(336.96343994141,2619.5234375,43.890041351318),heading = 24.84,},
            {pos = vector3(342.05621337891,2622.2749023438,43.901145935059),heading = 31.06,},
            {pos = vector3(348.9140625,2624.0974121094,43.893363952637),heading = 30.07,},
            {pos = vector3(354.65710449219,2627.2631835938,43.890636444092),heading = 30.84,},
            {pos = vector3(361.68795776367,2628.763671875,43.890968322754),heading = 27.83,},
            {pos = vector3(367.03283691406,2631.5461425781,43.890640258789),heading = 34.75,},
            {pos = vector3(374.45169067383,2633.3959960938,43.891342163086),heading = 30.04,},
            {pos = vector3(379.98034667969,2636.5720214844,43.889976501465),heading = 27.47,},
            {pos = vector3(386.70684814453,2638.1840820312,43.889759063721),heading = 29.47,},
            {pos = vector3(392.51583862305,2641.2253417969,43.886741638184),heading = 30.2,},
        },
        returnprice = 50,
        job = false,
        blip = {
            label = "Garage", 
            ID = 357, 
            Color = 2
        },
    },
    {
        pos = vector3(1695.5538330078,4785.23828125,41.998600006104),
        places = {
            {pos = vector3(1691.4711914062,4788.080078125,41.647735595703),heading = 89.91,},
            {pos = vector3(1691.3776855469,4782.2387695312,41.64778137207),heading = 90.73,},
            {pos = vector3(1691.2124023438,4778.3623046875,41.647750854492),heading = 91.44,},
            {pos = vector3(1691.2287597656,4774.2802734375,41.647880554199),heading = 89.32,},
            {pos = vector3(1691.2962646484,4770.2631835938,41.647914886475),heading = 90.53,},
            {pos = vector3(1691.1496582031,4766.4658203125,41.647880554199),heading = 89.41,},
            {pos = vector3(1691.5056152344,4762.501953125,41.647659301758),heading = 89.41,},
        },
        returnprice = 50,
        job = false,
        blip = {
            label = "Garage", 
            ID = 357, 
            Color = 2
        },
    },
    {
        pos = vector3(-3149.12109375,1109.1549072266,20.853740692139),
        places = {
            {pos = vector3(-3141.5126953125,1117.2106933594,20.428363800049),heading = 279.52,},
            {pos = vector3(-3143.0151367188,1113.6307373047,20.428909301758),heading = 278.96,},
            {pos = vector3(-3144.6848144531,1110.0672607422,20.430246353149),heading = 279.26,},
            {pos = vector3(-3146.2004394531,1106.6507568359,20.430940628052),heading = 279.55,},
            {pos = vector3(-3147.6789550781,1103.0970458984,20.431650161743),heading = 281.22,},
            {pos = vector3(-3149.3469238281,1099.6577148438,20.432205200195),heading = 279.16,},
            {pos = vector3(-3150.6430664062,1096.1547851562,20.432024002075),heading = 278.44,},
            {pos = vector3(-3152.2487792969,1092.6295166016,20.431972503662),heading = 280.82,},
            {pos = vector3(-3153.9514160156,1089.0263671875,20.432415008545),heading = 279.27,},
        },
        returnprice = 50,
        job = false,
        blip = {
            label = "Garage", 
            ID = 357, 
            Color = 2
        },
    },
    {
        pos = vector3(2588.4877929688,429.58520507812,108.61365509033),
        places = {
            {pos = vector3(2583.2021484375,428.23413085938,108.18199157715),heading = 180.19,},
            {pos = vector3(2579.6608886719,428.34783935547,108.18196105957),heading = 180.19,},
            {pos = vector3(2576.0263671875,428.45120239258,108.18196868896),heading = 180.19,},
            {pos = vector3(2575.9748535156,438.72094726562,108.18210601807),heading = 0.21,},
            {pos = vector3(2579.6044921875,438.67623901367,108.18200683594),heading = 0.21,},
            {pos = vector3(2583.1579589844,438.59848022461,108.18176269531),heading = 0.21,},
            {pos = vector3(2588.3552246094,443.6291809082,108.18202209473),heading = 90.05,},
            {pos = vector3(2588.4738769531,446.96200561523,108.18185424805),heading = 90.05,},
            {pos = vector3(2588.3271484375,450.30572509766,108.18202972412),heading = 90.05,},
        },
        returnprice = 50,
        job = false,
        blip = {
            label = "Garage", 
            ID = 357, 
            Color = 2
        },
    },
    {
        pos = vector3(213.74040222168,-808.92565917969,31.014890670776),
        places = {
            {pos = vector3(223.95,-799.23,30.15),heading = 248.58,},
            {pos = vector3(222.84, -801.7, 30.16),heading = 247.04,},
            {pos = vector3(221.97, -804.22, 30.17),heading = 248.16,},
            {pos = vector3(216.96, -799.13, 30.28),heading = 68.14,},
            {pos = vector3(217.98, -796.73, 30.27),heading = 68.57,},
            {pos = vector3(218.92, -794.16, 30.26),heading = 67.75,},
            {pos = vector3(232.93,-805.24,29.95),heading = 68.51,},
            {pos = vector3(234.78,-800.24,29.97),heading = 69.39,},
            {pos = vector3(210.03,-791.13,30.42),heading = 248.65,},
            {pos = vector3(210.87,-788.66,30.47),heading = 249.94,},
            {pos = vector3(211.44,-785.93,30.47),heading = 249.29,},
            {pos = vector3(212.54,-783.51,30.45),heading = 248.73,},
            {pos = vector3(213.77,-781.16,30.43),heading = 247.08,},
            {pos = vector3(222.05,-786.85,30.32),heading = 69.9,},
            {pos = vector3(222.9,-784.32,30.32),heading = 68.65,},
            {pos = vector3(223.78,-781.6,30.31),heading = 68.34,},
            {pos = vector3(224.74,-779.28,30.31),heading = 68.15,},
            {pos = vector3(225.79,-776.6,30.32),heading = 67.83,},
            {pos = vector3(217.21,-770.94,30.4),heading = 250.57,},
            {pos = vector3(230.23,-781.36,30.26),heading = 250.26,},
            {pos = vector3(231.15,-778.88,30.27),heading = 248.08,},
            {pos = vector3(242.46,-780.03,30.17),heading = 67.11,},
            {pos = vector3(232.97,-773.8,30.29),heading = 248.5,},
        },
        returnprice = 50,
        job = false,
        blip = {
            label = "Garage", 
            ID = 357, 
            Color = 2
        },
    },
    {
        pos = vector3(22.535604476929,-1102.8481445312,38.151798248291),
        places = {
            {pos = vector3(12.32,-1096.34,37.65),heading = 68.77,},
            {pos = vector3(13.18 ,-1093.66, 37.65),heading = 69.54,},
            {pos = vector3(14.69,-1087.98,37.65),heading = 69.3,},
            {pos = vector3(14.13,-1090.95,37.65),heading = 68.43,},
            {pos = vector3(25.34,-1078.9,37.65),heading = 249.26,},
            {pos = vector3(26.06,-1075.77,37.65),heading = 249.39},
        },
        returnprice = 50,
        job = false,
    },
    {
        pos = vector3(46.651126861572,-1749.4738769531,29.634466171265),
        places = {
            {pos = vector3(31.11,-1740.92,28.8),heading = 228.68,},
            {pos = vector3(29.07,-1743.43,28.8),heading = 229.42,},
            {pos = vector3(20.83,-1744.59,28.8),heading = 50.49,},
            {pos = vector3(22.86,-1742.27,28.8),heading = 49.37,},
            {pos = vector3(38.71,-1731.47,28.8),heading = 228.83,},
            {pos = vector3(40.86,-1729.3,28.8),heading = 229.84},
        },
        returnprice = 50,
        job = false,
        blip = {
            label = "Garage", 
            ID = 357, 
            Color = 2
        },
    },
    {
        pos = vector3(-1883.1860351562,-320.08096313477,49.363353729248),
        places = {
            {pos = vector3(-1900.35,-333,48.73),heading = 321.6,},
            {pos = vector3(-1894.54,-315.4,48.73),heading = 235.142,},
            {pos = vector3(-1890.92,-340.77,48.74),heading = 319.17,},
            {pos = vector3(-1894.23,-338.16,48.74),heading = 323.32,},
            {pos = vector3(-1897.48,-335.54,48.73),heading = 322.44,},
            {pos = vector3(-1878.76,-308.14,48.73),heading = 50.15},
        },
        returnprice = 50,
        job = false,
        blip = {
            label = "Garage", 
            ID = 357, 
            Color = 2
        },
    },
    {
        pos = vector3(1877.7213134766,3761.5708007812,32.949462890625),
        places = {
            {pos = vector3(1875.81,3759.23,32.46),heading = 210.67,},
            {pos = vector3(1880.72,3762.3,32.41),heading = 209.71,},
            {pos = vector3(1883.02,3770.91,32.35),heading = 210.88,},
            {pos = vector3(1886.32,3772.92,32.3),heading = 210.02,},
        },
        returnprice = 50,
        job = false,
        blip = {
            label = "Garage", 
            ID = 357, 
            Color = 2
        },
    },
    {
        pos = vector3(-234.75675964355,6198.4951171875,31.93922996521),
        places = {
            {pos = vector3(-243.19,6201.24,30.98),heading = 134.52,},
            {pos = vector3(-245.61,6203.42,30.98),heading = 134.67,},
            {pos = vector3(-247.99,6206.1,30.98),heading = 134.34,},
            {pos = vector3(-251.19,6208.96,30.98),heading = 133.46,},
            {pos = vector3(-240.99,6198.86,30.98),heading = 135.22,},
            {pos = vector3(-238.51,6196.56,30.98),heading = 134.93,},
        },
        returnprice = 50,
        job = false,
        blip = {
            label = "Garage", 
            ID = 357, 
            Color = 2
        },
    },
    {
        pos = vector3(1758.4465332031,3249.2683105469,41.727474212646),
        places = {
            {pos = vector3(1769.8240966797,3239.6437988281,42.93501663208),heading = 107.04,},
        },
        returnprice = 50,
        job = false,
        blip = {
            label = "Garage avion", 
            ID = 372, 
            Color = 2
        },
    },
    {
        pos = vector3(-1124.5469970703,-2883.9013671875,13.945912361145),
        places = {
            {pos = vector3(-1112.5582275391,-2883.9680175781,13.946006774902),heading = 328.25,},
        },
        returnprice = 50,
        job = false,
        blip = {
            label = "Garage avion", 
            ID = 372, 
            Color = 2
        },
    },
    {
        pos = vector3(-1004.821472168,-1397.5513916016,1.5953904390335),
        places = {
            {pos = vector3(-999.89849853516,-1401.689453125,0.30288219451904),heading = 19.08,},
        },
        returnprice = 50,
        job = false,
        blip = {
            label = "Garage de bateaux", 
            ID = 455, 
            Color = 2
        },
    },
    --[[ {
        pos = vector3(321.34686279297,-558.07739257812,28.743431091309),
        places = {
            {pos = vector3(335.06658935547,-541.81091308594,28.281522750854),heading = 181.263,},
            {pos = vector3(332.26794433594,-541.89630126953,28.281631469727),heading = 178.955,},
            {pos = vector3(329.3962097168,-541.80786132812,28.281129837036),heading = 179.665,},
            {pos = vector3(326.58892822266,-541.83734130859,28.280746459961),heading = 180.793,},
            {pos = vector3(323.76138305664,-541.85137939453,28.281326293945),heading = 180.700,},
            {pos = vector3(320.90982055664,-541.72454833984,28.281442642212),heading = 179.907,},
        },
        returnprice = 50,
        job = "ambulance",
    }, ]]
    {
        pos = vector3(-281.02236938477,-888.16723632812,31.318021774292),
        places = {
            {pos = vector3(-285.74691772461,-887.87890625,30.513006210327),heading = 168.09,},
            {pos = vector3(-289.36486816406,-887.05639648438,30.512832641602),heading = 167.51,},
            {pos = vector3(-292.93389892578,-886.28076171875,30.51283454895),heading = 167.94,},
            {pos = vector3(-296.5002746582,-885.38421630859,30.512786865234),heading = 167.9,},
            {pos = vector3(-300.08081054688,-884.48504638672,30.512758255005),heading = 166.72,},
            {pos = vector3(-303.80541992188,-883.62841796875,30.512742996216),heading = 167.85,},
            {pos = vector3(-307.33184814453,-882.86962890625,30.51265335083),heading = 167.85,},
        },
        returnprice = 50,
        job = false,
    },
    {
        pos = vector3(1171.6912841797,-1527.8337402344,35.050930023193),
        places = {
            {pos = vector3(1177.0206298828,-1545.5299072266,34.124923706055),heading = 0.57,},
            {pos = vector3(1180.7651367188,-1545.6148681641,34.12467956543),heading = 357.96,},
            {pos = vector3(1184.2219238281,-1545.2185058594,34.125366210938),heading = 0.78,},
            {pos = vector3(1187.6895751953,-1545.1182861328,34.124919891357),heading = 359.12,},
        },
        returnprice = 50,
        job = false,
    },
    {
        pos = vector3(-1212.2630615234,-654.24523925781,25.901279449463),
        places = {
            {pos = vector3(-1206.7604980469,-652.01483154297,25.209989547729),heading = 129.9,},
            {pos = vector3(-1204.6414794922,-654.52044677734,25.33358001709),heading = 131.10,},
            {pos = vector3(-1202.7269287109,-656.55938720703,25.333604812622),heading = 130.19,},
        },
        returnprice = 50,
        job = false,
    },
    {
        pos = vector3(4519.7509765625,-4515.27734375,4.4929695129395),
        places = {
            {pos = vector3(4515.4907226562,-4520.3178710938,3.6731142997742),heading = 22.70,},
        },
        returnprice = 50,
        job = false,
    },
    {
        pos = vector3(450.49255371094,-1981.5919189453,24.401720046997),
        places = {
            {pos = vector3(457.833984375,-1970.6651611328,22.478359222412),heading = 178.95,},
            {pos = vector3(454.02166748047,-1966.2291259766,22.46230506897),heading = 180.67,},
            {pos = vector3(449.54165649414,-1961.4420166016,22.429920196533),heading = 181.61,},
        },
        returnprice = 50,
        job = false,
    },
}


local VehTab = {}
local carInstance = {}
local VehCam = nil
local vehSelected = nil

RMenu.Add('garage', 'main', RageUI.CreateMenu("", "~b~Garage", 0, 0,"root_cause","garage"))
RMenu:Get('garage', 'main').EnableMouse = false

RMenu.Add('garage', 'submycars', RageUI.CreateSubMenu(RMenu:Get('garage', 'main'), "", "~b~Garage"))
RMenu.Add('garage', 'suboption', RageUI.CreateSubMenu(RMenu:Get('garage', 'submycars'), "", "~b~Garage"))
RMenu.Add('garage', 'subranger', RageUI.CreateSubMenu(RMenu:Get('garage', 'main'), "", "~b~Garage"))
RMenu.Add('garage', 'subplace', RageUI.CreateSubMenu(RMenu:Get('garage', 'suboption'), "", "~b~Garage"))

RMenu:Get('garage', 'main').Closed = function() Garage.Menu = false FreezeEntityPosition(GetPlayerPed(-1), false) end
RMenu:Get("garage", "subranger").Closed = function() pGarage.CamManager("delete") end
RMenu:Get("garage", "subplace").Closed = function() pGarage.CamManager("delete") end

function OpenGarageRageUIMenu(places, prc)

    if Garage.Menu then
        Garage.Menu = false
    else
        Garage.Menu = true
        RageUI.Visible(RMenu:Get('garage', 'main'), true)
        FreezeEntityPosition(GetPlayerPed(-1), true)

        Citizen.CreateThread(function()
			while Garage.Menu do
                RageUI.IsVisible(RMenu:Get('garage', 'main'), true, false, true, function()

                    RageUI.Button("Mes véhicules", false, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            VehTab = {}
                            Vehicle_RefreshTable()
                        end
                    end, RMenu:Get('garage', 'submycars'))

                    RageUI.Button("Ranger un véhicule", false, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    end, RMenu:Get('garage', 'subranger'))
                end)

                RageUI.IsVisible(RMenu:Get('garage', 'submycars'), true, false, true, function()

                    if #VehTab ~= 0 then
                        for i = 1 , #VehTab,1 do
                            local itm = VehTab[i]
                            local vehlbl = GetLabelText(GetDisplayNameFromVehicleModel(itm.model))
                            local vehplace = GetVehicleModelNumberOfSeats(itm.model)

                            state = ""
                            if itm.parked == "1" or itm.parked == 1 then state = "~g~Rentrer" else state = "~r~Sortie" end
                            if itm.label == "NULL" or itm.label == NULL or itm.label == vehlbl then itm.label = vehlbl else itm.label = itm.label end
                            --if itm.garage_private == 1 then garageLabel = "~r~Garage privé" elseif itm.garage_private == 0 then garageLabel = "~b~Garage publique" end

                            --[[ RageUI.Button(itm.label.." (~g~"..itm.plate.."~s~)", "Emplacement : "..garageLabel.."~s~\nNombre de place : "..vehplace.."\nVéhicule : "..vehlbl, {RightLabel = state}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    vehSelected = itm
                                end
                            end, RMenu:Get('garage', 'suboption')) ]]
                            RageUI.Button(itm.label.." (~HUD_COLOUR_BLUELIGHT~"..itm.plate.."~s~)", "Nombre de place : "..vehplace.."\nVéhicule : "..vehlbl, {RightLabel = state}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    vehSelected = itm
                                end
                            end, RMenu:Get('garage', 'suboption'))
                        end
                    else
                        RageUI.Separator("~r~Vous n'avez pas de véhicule.")
                    end

                end)

                RageUI.IsVisible(RMenu:Get('garage', 'suboption'), true, false, true, function()
                    local c = vehSelected
                    RageUI.Separator("↓ ~HUD_COLOUR_BLUELIGHT~"..c.label.."~s~ ↓")
                    --[[ if c.parked == "1" or c.parked == 1 and c.garage_private == 0 or c.garage_private == "0" then ]]
                    if c.parked == "1" or c.parked == 1 then
                        RageUI.Button("Sortir", false, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        end, RMenu:Get('garage', 'subplace'))
                    elseif c.parked == "0" or c.parked == 0 then
                        RageUI.Button("Sortir", false, {}, false, function(Hovered, Active, Selected)
                        end)

                        if not DoesBlipExist(PersoCarblip) then
                            RageUI.Button("Rappeler le véhicule", false, {RightLabel = "~g~$"..prc}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    SneakyEvent("pGarage:UpdateParkedStatus", c.plate, prc)
                                    RageUI.GoBack()
                                    ESX.SetTimeout(100, function()
                                        Vehicle_RefreshTable()
                                    end)
                                end
                            end)
                        end
                    end

                    RageUI.Button("Renommer", false, {}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local name = KeyboardInput("entryname", "~g~Renommer", c.label, 25)
                            if name ~= nil then
                                SneakyEvent("pGarare:RenameVeh", c.plate, name)
                                RageUI.Visible(RMenu:Get('garage', 'suboption'), false)
                                RageUI.Visible(RMenu:Get('garage', 'main'), true)
                                RageUI.Popup({message="Véhicule ~g~renommé~s~."})
                            else
                                RageUI.Popup({message="~r~Veuillez insérer du texte."})
                            end
                        end
                    end)
                end)

                RageUI.IsVisible(RMenu:Get('garage', 'subplace'), true, true, false, function()
                    local c = vehSelected
                    RageUI.Separator("↓ ~HUD_COLOUR_BLUELIGHT~"..c.label.."~s~ ↓")
                    RageUI.Separator("↓ ~HUD_COLOUR_BLUELIGHT~Choisir une place de parking~s~ ↓")
                    for k,v in pairs(places) do
                        local pointclear = ESX.Game.IsSpawnPointClear(v.pos, 3.0)
                        if pointclear then
                            RageUI.Button("Place #"..k, false, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    for k,v in pairs(ESX.Game.GetVehicles()) do
                                        local plate = GetVehicleNumberPlateText(v)
                                        if plate == c.plate then
                                            return ESX.ShowNotification("~r~Erreur~s~~n~Vous ne pouvez pas dupliquer sur ce serveur.")
                                        end
                                    end
                                    SneakyEvent("pGarage:RequestSpawn", c.plate, vector3(v.pos.x, v.pos.y, v.pos.z), v.heading)
                                end
                                if Active then
                                    pGarage.CamManager("create", vector3(v.pos.x-6.0, v.pos.y-3.0, v.pos.z +1.5), vector3(v.pos.x, v.pos.y, v.pos.z))
                                    DrawMarker(1, v.pos.x, v.pos.y, v.pos.z-0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 3.0, 255, 255, 255, 150, 0, 0, 2, 0, nil, nil, 0)
                                end
                            end)
                        else
                            local veh = ESX.Game.GetClosestVehicle(v.pos)
                            local plate = GetVehicleNumberPlateText(veh)
                            RageUI.Button("~c~Place #"..k, false, {RightBadge = RageUI.BadgeStyle.Lock}, true, function(Hovered, Active, Selected)
                                if Active then
                                    pGarage.CamManager("create", vector3(v.pos.x-6.0, v.pos.y-3.0, v.pos.z +1.5), vector3(v.pos.x, v.pos.y, v.pos.z))
                                    DrawMarker(1, v.pos.x, v.pos.y, v.pos.z-0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 3.0, 255, 50, 50, 150, 0, 0, 2, 0, nil, nil, 0)
                                end
                            end)
                        end
                    end
                end)

                RageUI.IsVisible(RMenu:Get('garage', 'subranger'), true, true, false, function()
                    RageUI.Separator("↓ ~HUD_COLOUR_BLUELIGHT~Place de parking~s~ ↓")
                    for k,v in pairs(places) do
                        local veh = ESX.Game.GetClosestVehicle(v.pos)
                        local plate = GetVehicleNumberPlateText(veh)
                        local pointclear = ESX.Game.IsSpawnPointClear(v.pos, 2.0)
                        if pointclear then
                            RageUI.Button("Place #"..k, false, {RightLabel = "~g~Libre"}, true, function(Hovered, Active, Selected)
                                if Active then
                                    pGarage.CamManager("create", vector3(v.pos.x-6.0, v.pos.y-3.0, v.pos.z +1.5), vector3(v.pos.x, v.pos.y, v.pos.z))
                                    DrawMarker(1, v.pos.x, v.pos.y, v.pos.z-0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 3.0, 255, 255, 255, 150, 0, 0, 2, 0, nil, nil, 0)
                                end
                            end)
                        else
                            RageUI.Button("Place #"..k.." - ~HUD_COLOUR_BLUELIGHT~("..plate..")", false, {RightLabel = "~r~Ranger →"}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    if veh == nil and not veh and not DoesEntityExist(veh) then
                                        ESX.ShowNotification("~r~Erreur~s~~n~Veuillez ressayer plus tard !")
                                    else
                                        local vehProps  = pGarage.GetVehicleProperties(veh)
                                        ESX.TriggerServerCallback('pGarage:StockVehicle',function(valid)
                                            if(valid) then
                                                if not DoesEntityExist(veh) then return end
                                                if DoesEntityExist(veh) then
                                                    TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                                                    ESX.Game.DeleteVehicle(veh)
                                                end
                                                for k,v in pairs (carInstance) do
                                                    if ESX.Math.Trim(v.plate) == ESX.Math.Trim(vehProps.plate) then
                                                        table.remove(carInstance, k)
                                                    end
                                                end
                                                SneakyEvent("pGarage:UpdateParkedStatus", vehProps.plate)
                                                RageUI.Popup({message="Véhicule ~g~rangé~s~."})
                                            else
                                                RageUI.Popup({message="~r~Ce véhicule n'est pas le tiens."})
                                            end
                                        end,vehProps)
                                    end
                                end
                                if Active then
                                    pGarage.CamManager("create", vector3(v.pos.x-6.0, v.pos.y-3.0, v.pos.z +1.5), vector3(v.pos.x, v.pos.y, v.pos.z))
                                    DrawMarker(1, v.pos.x, v.pos.y, v.pos.z-0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 3.0, 255, 50, 50, 150, 0, 0, 2, 0, nil, nil, 0)
                                end
                            end)
                        end
                    end
                end)

				Wait(0)
			end
            
            FreezeEntityPosition(GetPlayerPed(-1), false)
		end)
	end

end

Citizen.CreateThread(function()
    while true do
        att = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs(pGaragemenu) do
            local mPos = #(pCoords-v.pos)

            if not Garage.Menu then
                if mPos <= 10.0 then
                    att = 1
                    DrawMarker(1, v.pos.x, v.pos.y, v.pos.z-0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 150, 200, 170, 0, 0, 0, 1, nil, nil, 0)
                
                    if mPos <= 1.5 then
                        ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour interagir")
                        if IsControlJustPressed(0, 51) then
                            if v.job == false then
                                OpenGarageRageUIMenu(v.places, v.returnprice)
                            --[[ elseif v.job == ESX.PlayerData.job.name then
                                OpenGarageRageUIMenu(v.places, v.returnprice)
                            end ]]
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(att)
    end
end)

function Vehicle_RefreshTable()
    VehTab = {}
    ESX.TriggerServerCallback("pGarage:GetOwnVehicle", function(data) 
        VehTab = data
    end)
end
local spamveh = false
RegisterNetEvent("pGarage:SpawnVeh")
AddEventHandler('pGarage:SpawnVeh', function(vh,pos,heading)
    PlaySoundFrontend(-1, "Put_Away", "Phone_SoundSet_Michael", 1)
    if not spamveh then
        ESX.Game.SpawnVehicle(vh.model, pos, heading, function(callback_vehicle)
            currentVehicle = vehicle
            TriggerEvent('persistent-vehicles/register-vehicle', callback_vehicle)
            spawnveh = true
            pGarage.SetVehicleProperties(callback_vehicle, json.decode(vh.props))
            --TriggerEvent('persistent-vehicles/register-vehicle', callback_vehicle)
            SetModelAsNoLongerNeeded(json.decode(vh.props)["model"])
            SetVehicleNumberPlateTextIndex(callback_vehicle,0)
            SetVehicleNumberPlateText(callback_vehicle, vh.plate)
            print(vh.plate)
            local vehlbl = GetLabelText(GetDisplayNameFromVehicleModel(vh.model))
            if vh.label == "NULL" or vh.label == NULL or vh.label == vehlbl then vh.label = vehlbl else vh.label = vh.label end
            PersoCarblip = AddBlipForEntity(callback_vehicle)
            SetBlipSprite(PersoCarblip, 225)
            ShowHeadingIndicatorOnBlip(PersoCarblip, true)
            SetBlipRotation(PersoCarblip, math.ceil(GetEntityHeading(callback_vehicle)))
            SetBlipScale(PersoCarblip, 0.65)
            SetBlipShrink(PersoCarblip, true)
            ShowFriendIndicatorOnBlip(PersoCarblip, true)
            BeginTextCommandSetBlipName("STRING")
            if GetVehicleClass(callback_vehicle) ~= 14 and GetVehicleClass(callback_vehicle) ~= 15 and GetVehicleClass(callback_vehicle) ~= 16 then
                SetVehicleDoorsLocked(callback_vehicle, 2)
            end
            AddTextComponentString(vh.label)
            EndTextCommandSetBlipName(PersoCarblip)
            table.insert(carInstance, {vehicleentity = callback_vehicle, plate = vh.plate})
        end)
        ESX.SetTimeout(300, function()
            Wait(10)
            Vehicle_RefreshTable()
            spamveh = false
        end)
    end
end)