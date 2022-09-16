local localVeh = nil
local Entity = nil

ESX = nil
function ConcessESX()
     while ESX == nil do
          TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)
          Citizen.Wait(0)
     end
     while ESX.GetPlayerData().job == nil do
          Citizen.Wait(10)
     end
     if ESX.IsPlayerLoaded() then
     ESX.PlayerData = ESX.GetPlayerData()
     end
end
SneakyEvent = TriggerServerEvent
RegisterNetEvent('Sneakyesx:playerLoaded')
AddEventHandler('Sneakyesx:playerLoaded', function(xPlayer)
     ESX.PlayerData = xPlayer
end)
local onService = false
RegisterNetEvent('Sneakyesx:setJob')
AddEventHandler('Sneakyesx:setJob', function(job)
     ESX.PlayerData.job = job
end)

local CarDealer = {
     [1] = {
          Job = "carshop",
          Society = "society_carshop",
          Label = "Concessionnaire véhicules",
          Banner = "shopui_title_legendarymotorsport",
          Positions = {
               key = vector3(-66.88444519043,72.788078308105,71.680206298828),
               caisse = vector3(-51.714347839355,76.81241607666,71.917869567871),
               catalogue = vector3(-60.428844451904,68.468330383301,71.898017883301),
               visualVeh = vector3(-59.162364959717,64.804779052734,71.548538208008),
               visualHeading = 6.816,
               spawnVeh = vector3(-66.53978729248,81.796928405762,70.973205566406),
               spawnHeading = 66.33
          },
          Vehicles = {
               [1] = {
                    Name = "compacts",
                    Label = "Compacts",
                    Desc = "Véhicules ~b~Compacts~s~",
                    List = {
                         {name = "asbo", price = 8500 },
                         {name = "blista", price = 8250 },
                         {name = "brioso", price = 4950 },
                         {name = "brioso2", price = 5180 },
                         {name = "club", price = 8850 },
                         {name = "dilettante", price = 5700 },
                         {name = "kanjo", price = 7350 },
                         {name = "issi2", price = 5300 },
                         {name = "issi3", price = 5480 },
                         {name = "panto", price = 3650 },
                         {name = "prairie", price = 8750 },
                         {name = "rhapsody", price = 8350 },
                         --{name = "weevil", price = 6280 },
                    },
               },
               [2] = {
                    Name = "coupes",
                    Label = "Coupes",
                    Desc = "Véhicules ~b~Coupes~s~",
                    List = {
                         {name = "cogcabrio", price = 10750 },
                         {name = "exemplar", price = 24500 },
                         {name = "f620", price = 26000 },
                         {name = "felon", price = 15620 },
                         {name = "felon2", price = 16750 },
                         {name = "jackal", price = 21500 },
                         {name = "oracle", price = 21500 },
                         {name = "oracle2", price = 20250 },
                         {name = "sentinel", price = 10000 },
                         {name = "sentinel2", price = 10950 },
                         {name = "windsor", price = 80000 },
                         {name = "windsor2", price = 85650 },
                         {name = "zion", price = 12400 },
                         {name = "zion2", price = 14900 },
                    },
               },
               [3] = {
                    Name = "sedans",
                    Label = "Sedans",
                    Desc = "Véhicules ~b~Sedans~s~",
                    List = {
                         {name = "asea", price = 7500 },
                         {name = "asterope", price = 8000 },
                         {name = "cog55", price = 64500 },
                         {name = "cognoscenti", price = 48000 },
                         {name = "emperor", price = 10480 },
                         {name = "emperor2", price = 9580 },
                         {name = "fugitive", price = 12450 },
                         {name = "futo2", price = 32000 },
                         {name = "glendale", price = 15700 },
                         {name = "glendale2", price = 20500 },
                         {name = "ingot", price = 10490 },
                         {name = "intruder", price = 11980 },
                         {name = "premier", price = 10480 },
                         {name = "primo", price = 11750 },
                         {name = "primo2", price = 11750 },
                         {name = "regina", price = 9400 },
                         {name = "stafford", price = 42000 },
                         {name = "stanier", price = 21460 },
                         {name = "stratum", price = 11500 },
                         {name = "superd", price = 52000 },
                         {name = "surge", price = 9500 },
                         {name = "tailgater", price = 13210 },
                         {name = "warrener", price = 11600 },
                         {name = "washington", price = 12850 },
                    },
               },
               [4] = {
                    Name = "sportsclassic",
                    Label = "Sports Classic",
                    Desc = "Véhicules ~b~Sports Classic~s~",
                    List = {
                         {name = "btype", price = 54000 },
                         {name = "btype2", price = 53000 },
                         {name = "btype3", price = 55000 },
                         {name = "casco", price = 45000 },
                         {name = "cheburek", price = 30000 },
                         {name = "cheetah2", price = 48000 },
                         {name = "coquette2", price = 53000 },
                         {name = "dynasty", price = 24000 },
                         {name = "fagaloa", price = 24500 },
                         {name = "feltzer3", price = 55000 },
                         {name = "gt500", price = 45000 },
                         {name = "infernus2", price = 62000 },
                         {name = "jb700", price = 56500 },
                         {name = "jb7002", price = 54800 },
                         {name = "mamba", price = 44000 },
                         {name = "manana", price = 12500 },
                         {name = "manana2", price = 13500 },
                         {name = "michelli", price = 32000 },
                         {name = "monroe", price = 36000 },
                         {name = "nebula", price = 34000 },
                         {name = "pigalle", price = 31160 },
                         {name = "rapidgt3", price = 29100 },
                         {name = "retinue", price = 28200 },
                         {name = "retinue2", price = 29700 },
                         {name = "savestra", price = 29050 },
                         {name = "stinger", price = 28000 },
                         {name = "stingergt", price = 33000 },
                         {name = "swinger", price = 41000 },
                         {name = "torero", price = 13650 },
                         {name = "tornado", price = 13700 },
                         {name = "tornado2", price = 11520 },
                         {name = "tornado3", price = 11520 },
                         {name = "tornado4", price = 13750 },
                         {name = "tornado5", price = 40605 },
                         {name = "tornado6", price = 15500 },
                         {name = "turismo2", price = 51000 },
                         {name = "viseris", price = 56000 },
                         {name = "z190", price = 51000 },
                         {name = "ztype", price = 57000 },
                         {name = "zion3", price = 50800 },
 
                    },
               },
               [5] = {
                    Name = "sports",
                    Label = "Sports",
                    Desc = "Véhicules ~b~Sports~s~",
                    List = {
                         {name = "alpha", price = 30000 },
                         {name = "banshee", price = 32000 },
                         {name = "bestiagts", price = 30550 },
                         {name = "blista2", price = 25000 },
                         {name = "blista3", price = 25750 },
                         {name = "buffalo", price = 20500 },
                         {name = "buffalo2", price = 27500 },
                         {name = "buffalo3", price = 25500 },
                         {name = "calico", price = 92000 },
                         {name = "carbonizzare", price = 38500 },
                         {name = "comet2", price = 44500 },
                         {name = "comet3", price = 45000 },
                         {name = "comet5", price = 47000 },
                         {name = "comet6", price = 65000 },
                         {name = "coquette", price = 38000 },
                         {name = "coquette4", price = 50000 },
                         {name = "cypher", price = 50500 },
                         {name = "drafter", price = 50100 },
                         {name = "deveste", price = 125000 },
                         {name = "dominator7", price = 55000 },
                         {name = "elegy", price = 34500 },
                         {name = "elegy2", price = 41000 },
                         {name = "euros", price = 46000 },
                         {name = "feltzer2", price = 39500 },
                         {name = "flashgt", price = 41000 },
                         {name = "furoregt", price = 38500 },
                         {name = "fusilade", price = 39000 },
                         {name = "futo", price = 35500 },
                         {name = "gb200", price = 35500 },
                         {name = "growler", price = 67000 },
                         {name = "hotring", price = 35000 },
                         {name = "komoda", price = 68000 },
                         {name = "imorgon", price = 90000 },
                         {name = "issi7", price = 40200 },
                         {name = "italigto", price = 52000 },
                         {name = "jugular", price = 75000 },
                         {name = "jester", price = 42000 },
                         {name = "jester2", price = 43000 },
                         {name = "jester3", price = 70000 },
                         {name = "khamelion", price = 41500 },
                         {name = "kuruma", price = 40731 },
                         {name = "locust", price = 61000 },
                         {name = "lynx", price = 41750 },
                         {name = "massacro", price = 42500 },
                         {name = "massacro2", price = 43000 },
                         {name = "neo", price = 45500 },
                         {name = "neon", price = 39800 },
                         {name = "ninef", price = 42500 },
                         {name = "ninef2", price = 40500 },
                         {name = "omnis", price = 39000 },
                         {name = "paragon", price = 42800 },
                         {name = "pariah", price = 49950 },
                         {name = "penumbra", price = 32000 },
                         {name = "penumbra2", price = 39000 },
                         {name = "previon", price = 47000 },
                         {name = "raiden", price = 38150 },
                         {name = "rapidgt", price = 39500 },
                         {name = "rapidgt2", price = 39750 },
                         {name = "remus", price = 58750 },
                         {name = "raptor", price = 36850 },
                         {name = "revolter", price = 43000 },
                         {name = "rt3000", price = 38500 },
                         {name = "ruston", price = 42000 },
                         {name = "schafter2", price = 30600 },
                         {name = "schafter3", price = 31500 },
                         {name = "schafter4", price = 34500 },
                         {name = "schlagen", price = 41000 },
                         {name = "schwarzer", price = 43000 },
                         {name = "sentinel3", price = 25600 },
                         {name = "seven70", price = 40500 },
                         {name = "specter", price = 42500 },
                         {name = "specter2", price = 40500 },
                         {name = "sugoi", price = 32500 },
                         {name = "sultan", price = 30500 },
                         {name = "sultan2", price = 40000 },
                         {name = "surano", price = 32000 },
                         {name = "tailgater2", price = 45000 },
                         {name = "tampa2", price = 32000 },
                         {name = "tropos", price = 34000 },
                         {name = "vectre", price = 85000 },
                         {name = "verlierer2", price = 38000 },
                         {name = "vstr", price = 60500 },
                         {name = "zr350", price = 60000 },
                    },
               },
               [6] = {
                    Name = "muscle",
                    Label = "Muscle",
                    Desc = "Véhicules ~b~Muscle~s~",
                    List = {
                         {name = "blade", price = 12500 },
                         {name = "buccaneer", price = 12500 },
                         {name = "buccaneer2", price = 13000 },
                         {name = "chino", price = 13500 },
                         {name = "chino2", price = 12000 },
                         {name = "clique", price = 12500 },
                         {name = "coquette3", price = 13000 },
                         {name = "deviant", price = 15000 },
                         {name = "dominator", price = 13000 },
                         {name = "dominator2", price = 23000 },
                         {name = "dominator3", price = 26500 },
                         {name = "dominator8", price = 31000 },
                         {name = "dukes", price = 14500 },
                         {name = "dukes3", price = 13500 },
                         {name = "faction", price = 14000 },
                         {name = "faction2", price = 19500 },
                         {name = "faction3", price = 21500 },
                         {name = "ellie", price = 16500 },
                         {name = "gauntlet", price = 14500 },
                         {name = "gauntlet2", price = 15500 },
                         {name = "gauntlet3", price = 16500 },
                         {name = "gauntlet4", price = 31500 },
                         {name = "gauntlet5", price = 27000 },
                         {name = "hermes", price = 27500 },
                         {name = "hotknife", price = 17000 },
                         {name = "hustler", price = 20000 },
                         {name = "impaler", price = 15000 },
                         {name = "imperator", price = 18000 },
                         {name = "lurcher", price = 21000 },
                         {name = "moonbeam", price = 15800 },
                         {name = "moonbeam2", price = 16250 },
                         {name = "nightshade", price = 24000 },
                         {name = "peyote", price = 16700 },
                         --{name = "peyote2", price = 13500 },
                         {name = "peyote3", price = 21250 },
                         {name = "phoenix", price = 15000 },
                         {name = "picador", price = 15000 },
                         {name = "ratloader", price = 12500 },
                         --{name = "ratloader2", price = 14500 },
                         {name = "ruiner", price = 16850 },
                         {name = "sabregt", price = 18000 },
                         {name = "sabregt2", price = 18500 },
                         {name = "slamvan", price = 17000 },
                         {name = "slamvan2", price = 18250 },
                         {name = "slamvan3", price = 21000 },
                         {name = "stalion", price = 22000 },
                         {name = "stalion2", price = 21850 },
                         {name = "tampa", price = 15500 },
                         {name = "tulip", price = 22500 },
                         {name = "vamos", price = 17000 },
                         {name = "vigero", price = 16000 },
                         {name = "virgo", price = 17500 },
                         {name = "virgo2", price = 18000 },
                         {name = "virgo3", price = 18500 },
                         {name = "voodoo", price = 21000 },
                         {name = "voodoo2", price = 22500 },
                         {name = "yosemite", price = 24000 },
                         {name = "yosemite2", price = 26000 },
                    },
               },
               [7] = {
                    Name = "vans",
                    Label = "Vans",
                    Desc = "Véhicules ~b~Vans~s~",
                    List = {
                         {name = "bison", price = 26650 },
                         {name = "bobcatxl", price = 25000 },
                         {name = "burrito3", price = 13620 },
                         {name = "gburrito", price = 16500 },
                         {name = "gburrito2", price = 16500 },
                         {name = "minivan", price = 13500 },
                         {name = "minivan2", price = 14500 },
                         {name = "paradise", price = 15600 },
                         {name = "speedo", price = 16200 },
                         {name = "speedo4", price = 16750 },
                         {name = "rumpo3", price = 32500 },
                         {name = "surfer", price = 13600 },
                         {name = "surfer2", price = 13250 },
                         {name = "youga", price = 16200 },
                         {name = "youga2", price = 16750 },
                         {name = "youga3", price = 19500 },
                    },
               },
               [8] = {
                    Name = "offroads",
                    Label = "Off-Roads",
                    Desc = "Véhicules ~b~Off-Roads~s~",
                    List = {
                         {name = "bfinjection", price = 9500 },
                         {name = "bifta", price = 10500 },
                         --{name = "bodhi2", price = 12000 },
                         {name = "brawler", price = 18000 },
                         {name = "caracara2", price = 35000 },
                         {name = "dloader", price = 10000 },
                         {name = "dubsta3", price = 38000 },
                         {name = "dune", price = 11500 },
                         {name = "everon", price = 43000 },
                         {name = "freecrawler", price = 21000 },
                         {name = "hellion", price = 31000 },
                         {name = "kalahari", price = 12500 },
                         {name = "kamacho", price = 32800 },
                         {name = "mesa3", price = 25000 },
                         {name = "rancherxl", price = 16500 },
                         {name = "rebel", price = 17500 },
                         {name = "rebel2", price = 18000 },
                         {name = "riata", price = 19000 },
                         {name = "sandking", price = 23000 },
                         {name = "sandking2", price = 24000 },
                         {name = "trophytruck", price = 24000 },
                         {name = "trophytruck2", price = 28000 },
                         {name = "vagrant", price = 18000 },
                         {name = "winky", price = 27500 },
                         {name = "tractor2", price = 12000 },
                         {name = "guardian", price = 39000 },
                         {name = "yosemite3", price = 38000 },
                    },
               },
               [9] = {
                    Name = "suvs",
                    Label = "SUVs",
                    Desc = "Véhicules ~b~SUVs~s~",
                    List = {
                         {name = "baller", price = 20000 },
                         {name = "baller2", price = 21000 },
                         {name = "baller3", price = 22000 },
                         {name = "baller4", price = 27000 },
                         {name = "bjxl", price = 20000, },
                         {name = "cavalcade", price = 15000 },
                         {name = "cavalcade2", price = 18500 },
                         {name = "contender", price = 34000 },
                         {name = "dubsta", price = 22800 },
                         {name = "dubsta2", price = 22000 },
                         {name = "fq2", price = 22500 },
                         {name = "granger", price = 24000 },
                         {name = "gresley", price = 20500 },
                         {name = "habanero", price = 13500 },
                         {name = "huntley", price = 13500 },
                         {name = "landstalker", price = 14500 },
                         {name = "landstalker2", price = 16000 },
                         {name = "mesa", price = 16500 },
                         {name = "novak", price = 78000 },
                         {name = "patriot", price = 17800 },
                         {name = "radi", price = 11500 },
                         {name = "rebla", price = 82000 },
                         {name = "rocoto", price = 13000 },
                         {name = "seminole", price = 10500 },
                         {name = "seminole2", price = 11000 },
                         {name = "serrano", price = 10000 },
                         {name = "toros", price = 57000 },
                         {name = "xls", price = 42000 },
                         {name = "streiter", price = 26000 },
                         {name = "sadler", price = 13000 },
                    },
               },
               [10] = {
                    Name = "super",
                    Label = "Super",
                    Desc = "Véhicules ~b~Super~s~",
                    List = {
                         {name = "adder", price = 95000 },
                         {name = "autarch", price = 110000 },
                         {name = "banshee2", price = 40000 },
                         {name = "bullet", price = 73000 },
                         {name = "cheetah", price = 75000 },
                         {name = "cyclone", price = 120000 },
                         {name = "entity2", price = 142000 },
                         {name = "entityxf", price = 112000 },
                         {name = "emerus", price = 155000 },
                         {name = "fmj", price = 120000 },
                         {name = "furia", price = 115000 },
                         {name = "gp1", price = 86000 },
                         {name = "infernus", price = 72000 },
                         {name = "italigtb", price = 100000 },
                         {name = "italigtb2", price = 125000 },
                         {name = "italirsx", price = 145000 },
                         {name = "krieger", price = 170000 },
                         {name = "le7b", price = 300000 },
                         {name = "nero", price = 180000 },
                         {name = "nero2", price = 210000 },
                         {name = "osiris", price = 140000 },
                         {name = "penetrator", price = 60000 },
                         {name = "pfister811", price = 72000 },
                         {name = "prototipo", price = 240000 },
                         {name = "reaper", price = 84000 },
                         {name = "s80", price = 289000 },
                         {name = "sc1", price = 103000 },
                         {name = "sheava", price = 126000 },
                         {name = "sultanrs", price = 130000 },
                         {name = "t20", price = 160000 },
                         {name = "taipan", price = 120000 },
                         {name = "tempesta", price = 125000 },
                         {name = "tezeract", price = 230000 },
                         {name = "thrax", price = 230000 },
                         {name = "tigon", price = 115000 },
                         {name = "turismor", price = 150000 },
                         {name = "tyrant", price = 132000 },
                         {name = "tyrus", price = 86000 },
                         {name = "vacca", price = 75000 },
                         {name = "vagner", price = 121000 },
                         {name = "visione", price = 133000 },
                         {name = "voltic", price = 71000 },
                         {name = "xa21", price = 143000 },
                         {name = "zentorno", price = 120000 },
                         {name = "zorrusso", price = 145000 },
                    },
               }
          },
          AnnounceState = {
               Title = "Concessionnaire véhicules",
               Subtitle = "~y~Informations~s~",
               Banner = "CHAR_CARSITE"
          },
     },
     [2] = {
          Job = "motoshop",
          Society = "society_motoshop",
          Label = "Concessionnaire moto",
          Banner = "motoshop",
          Positions = {
               key = vector3(1771.6466064453,3322.9743652344,41.438488006592),
               caisse = vector3(1769.4725341797,3323.9436035156,41.438488006592),
               catalogue = vector3(1767.6905517578,3325.4438476563,41.438480377197),
               visualVeh = vector3(1767.4362792969,3329.4677734375,40.907760620117),
               visualHeading = 357.34,
               spawnVeh = vector3(1759.6434326172,3327.2680664063,40.851947784424),
               spawnHeading = 121.48
          },
          Vehicles = {
               [1] = {
                    Name = "sports",
                    Label = "Sports",
                    Desc = "Moto de ~b~Sports~s~",
                    List = {
                         {name = "akuma", price = 20000},
                         {name = "bati", price = 30500},
                         {name = "bati2", price = 33000},
                         {name = "carbonrs", price = 23000},
                         {name = "defiler", price = 24000},
                         {name = "diablous", price = 20300},
                         {name = "diablous2", price = 23000},
                         {name = "double", price = 27500},
                         {name = "esskey", price = 24000},
                         {name = "fcr", price = 22000},
                         {name = "fcr2", price = 22500},
                         {name = "hakuchou", price = 35500},
                         {name = "hakuchou2", price = 34500},
                         {name = "lectro", price = 25000},
                         {name = "nemesis", price = 22100},
                         {name = "pcj", price = 21500},
                         {name = "thrust", price = 30000},
                         {name = "vader", price = 18500},
                         {name = "vindicator", price = 32000},
                         {name = "vortex", price = 24500},
                    },
               },
               [2] = {
                    Name = "route",
                    Label = "Route",
                    Desc = "Moto de ~b~Route~s~",
                    List = {
                         {name = "avarus", price = 17500},
                         {name = "bagger", price = 12500},
                         {name = "chimera", price = 21000},
                         {name = "daemon", price = 16500},
                         {name = "daemon2", price = 16750},
                         {name = "hexer", price = 20500},
                         {name = "innovation", price = 26500},
                         {name = "nightblade", price = 29500},
                         {name = "ratbike", price = 17500},
                         {name = "ruffian", price = 18800},
                         {name = "sanctus", price = 27000},
                         {name = "sovereign", price = 25600},
                         {name = "wolfsbane", price = 20500},
                         {name = "zombiea", price = 15800},
                         {name = "zombieb", price = 16700},
                    },
               },
               [3] = {
                    Name = "offroads",
                    Label = "Off-Roads",
                    Desc = "Moto ~b~Tout terrain~s~",
                    List = {
                         {name = "bf400", price = 30000},
                         {name = "cliffhanger", price = 22500},
                         {name = "enduro", price = 20000},
                         {name = "gargoyle", price = 22500},
                         {name = "manchez", price = 16500},
                         {name = "manchez2", price = 17500},
                         {name = "sanchez", price = 21500},
                         --{name = "sanchez2", price = 21000},
                         {name = "verus", price = 22000},
                    },
               },
               [4] = {
                    Name = "autres",
                    Label = "Autres",
                    Desc = "Autres",
                    List = {
                         {name = "faggio", price = 5500},
                         {name = "faggio2", price = 5700},
                         {name = "faggio3", price = 6000},
                         --{name = "blazer", price = 12000},
                         {name = "blazer", price = 16500},
                         {name = "blazer3", price = 15500},
                         {name = "blazer4", price = 16500},
                    },
               },
          },
          AnnounceState = {
               Title = "Concessionnaire moto",
               Subtitle = "~y~Informations~s~",
               Banner = "CHAR_SANDERS"
          },
     },
}

local openedMenu = false
local Announce = {
     "Ouvert",
     "Fermer",
     "Réduction",
     Index = 1
},

Citizen.CreateThread(function()

     RMenu.Add('cardealer', 'main', RageUI.CreateMenu("", "Desc", 80, 95))
     RMenu:Get("cardealer", "main").Closed = function()
          FreezeEntityPosition(PlayerPedId(), false)
          openedMenu = false
     end
     
     RMenu.Add('cardealer', 'main-key', RageUI.CreateMenu("", "Desc", 80, 95))
     RMenu:Get("cardealer", "main-key").Closed = function()
          FreezeEntityPosition(PlayerPedId(), false)
          openedMenu = false
     end

     RMenu.Add('cardealer', 'cardealer-gestion', RageUI.CreateMenu("", "Gestion des véhicules", 80, 95))
     RMenu:Get("cardealer", "cardealer-gestion").Closed = function()
          FreezeEntityPosition(PlayerPedId(), false)
          openedMenu = false
     end

     RMenu.Add('cardealer', 'main-vehicles', RageUI.CreateSubMenu(RMenu:Get("cardealer", "cardealer-gestion"), "", "Liste des véhicules", 80, 95))

     RMenu.Add('cardealer', 'main-catalogue', RageUI.CreateMenu("", "Desc", 80, 95))
     RMenu:Get("cardealer", "main-catalogue").Closed = function()
          FreezeEntityPosition(PlayerPedId(), false)
          openedMenu = false
     end

     for k,v in pairs(CarDealer) do
          for i=1, #v.Vehicles, 1 do
               RMenu.Add('cardealer', v.Vehicles[i].Name, RageUI.CreateSubMenu(RMenu:Get("cardealer", "main-catalogue"), "", v.Vehicles[i].Desc))
               RMenu:Get("cardealer", v.Vehicles[i].Name).Closed = function()
                    Citizen.SetTimeout(2500, function()
                         cooldownCarDealer = false
                    end)
                    if localVeh ~= lastName then 
                         TriggerEvent('persistent-vehicles/forget-vehicle', Entity)
                         DeleteEntity(Entity) 
                         headingobject = false
                    end
               end
          end
     end

     localVeh = nil

end)

local function openCarDealerMenu(table)
     local mainMenu = RageUI.CreateMenu("", table.Label, 0, 0, "root_cause",table.Banner)

     RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

     while mainMenu do
        Wait(1)
        RageUI.IsVisible(mainMenu, true, true, false, function()
          if onService then
               RageUI.Button("Stopper son ~r~service~s~", nil, {RightLabel = "→"}, onService, function(a,h,s)
                    if s then
                         onService = false
                    end
               end)
               RageUI.List("Annonce", Announce, Announce.Index, nil, {}, onService, function(h, a, s, i)
                    Announce.Index = i
                    if s then
                         if i == 1 then
                              typeAnnounce = 'open'
                              SneakyEvent('sCardealer:announce', table.Job, table.AnnounceState.Title, table.AnnounceState.Subtitle, table.AnnounceState.Banner, typeAnnounce)
                         elseif i == 2 then
                              typeAnnounce = 'close'
                              SneakyEvent('sCardealer:announce', table.Job, table.AnnounceState.Title, table.AnnounceState.Subtitle, table.AnnounceState.Banner, typeAnnounce)
                         elseif i == 3 then
                              typeAnnounce = 'reduc'
                              SneakyEvent('sCardealer:announce', table.Job, table.AnnounceState.Title, table.AnnounceState.Subtitle, table.AnnounceState.Banner, typeAnnounce)
                         end
                    end
               end)

               RageUI.Button("Attribuer une facture", nil, {RightLabel = "→"}, true,function(h,a,s)
                    if s then
                         RageUI.CloseAll()
                         FreezeEntityPosition(PlayerPedId(), false)
                         TriggerEvent("sBill:CreateBill",table.Society)
                    end
               end)
          else
               RageUI.Button("Prendre son ~g~service~s~", nil, {RightLabel = "→"}, not onService, function(a,h,s)
                    if s then
                         onService = true
                    end
               end)
          end
        end)

        if not RageUI.Visible(mainMenu) then
            mainMenu = RMenu:DeleteType("menu", true)
        end
     end
end

local buttonList = {
     Array =  {
          "Voir",
          "Acheter"
     },
     Index = 1
}

local function openCarDealerMenuCatalogue(table)
     if openedMenu then
          FreezeEntityPosition(PlayerPedId(), false)
          openedMenu = false
          if ESX.PlayerData.job.name ~= table.Job then
               RageUI.Visible(RMenu:Get("cardealer", "main-catalogue"), false)
          else
               RageUI.Visible(RMenu:Get("cardealer", "cardealer-gestion"), false)
          end
     else
          FreezeEntityPosition(PlayerPedId(), true)
          openedMenu = true
          if ESX.PlayerData.job.name ~= table.Job then
               RMenu:Get("cardealer", "main-catalogue"):SetSubtitle(table.Label.." - ~b~Catalogue~s~")
               RMenu:Get("cardealer", "main-catalogue"):SetSpriteBanner("root_cause", table.Banner)
               RMenu:Get("cardealer", "main-vehicles"):SetSpriteBanner("root_cause", table.Banner)
               RageUI.Visible(RMenu:Get("cardealer", "main-catalogue"), true)
          else
               RMenu:Get("cardealer", "cardealer-gestion"):SetSpriteBanner("root_cause", table.Banner)
               RMenu:Get("cardealer", "main-catalogue"):SetSpriteBanner("root_cause", table.Banner)
               RMenu:Get("cardealer", "main-vehicles"):SetSpriteBanner("root_cause", table.Banner)
               RageUI.Visible(RMenu:Get("cardealer", "cardealer-gestion"), true)
          end
          Citizen.CreateThread(function()
               ConcessESX()
               while openedMenu do
                    Wait(1.0)
                    RageUI.IsVisible(RMenu:Get("cardealer", "cardealer-gestion"), true, false, false, function()
                         if onService then
                              RageUI.Button("Attribuer un véhicule", nil, {RightLabel = "→→"}, true, function(h, a, s)
                                   if s then
                                        ESX.TriggerServerCallback("sCardealer:getVehicles", function(result)
                                             listVehicles = result
                                        end)
                                   end
                              end, RMenu:Get("cardealer", "main-vehicles"))

                              RageUI.Button("Acceder au catalogue", nil, {RightLabel = "→→"}, true, function(h, a, s)
                                   if s then
                                        RMenu:Get("cardealer", "main-catalogue"):SetSubtitle(table.Label.." - ~b~Catalogue~s~")
                                   end
                              end, RMenu:Get("cardealer", "main-catalogue"))
                         else
                              RageUI.Separator("")
                              RageUI.Separator("Vous n'êtes pas en service.")
                              RageUI.Separator("")
                         end

                    end)

                    RageUI.IsVisible(RMenu:Get("cardealer", "main-catalogue"), true, false, false, function()
                         if not cooldownCarDealer then
                              for i=1, #table.Vehicles, 1 do
                                   RageUI.Button("Catégorie : ~b~"..table.Vehicles[i].Label, nil, {RightLabel = "→→"}, not cooldownCarDealer, function(h, a, s)
                                        if s then
                                             RMenu:Get("cardealer", table.Vehicles[i].Name):SetSpriteBanner("root_cause", table.Banner)
                                             cooldownCarDealer = true
                                        end
                                   end, RMenu:Get("cardealer", table.Vehicles[i].Name))
                              end
                         else
                              RageUI.Separator("")
                              RageUI.Separator("Veuillez attendre...")
                              RageUI.Separator("")
                         end
                    end)

                    RageUI.IsVisible(RMenu:Get("cardealer", "main-vehicles"), true, false, false, function()
                         if listVehicles ~= nil then
                              if #listVehicles == 0 then
                                   RageUI.Separator("")
                                   RageUI.Separator("~c~Aucun véhicule !")
                                   RageUI.Separator("")
                              else
                                   for k,v in pairs(listVehicles) do
                                        PU = v.price
                                        PV = v.price*1.25
                                        RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.name)).." Prix d'usine: "..ESX.Math.GroupDigits(PU).."~g~$~s~", "Prix de vente: "..ESX.Math.GroupDigits(PV).."~g~$~s~", {RightLabel = "~b~Attribuer~s~ →"}, true, function(h, a, s)
                                             if s then
                                                  local closestPly = GetNearbyPlayer(false, true)
                                                  if not closestPly then 
                                                       return
                                                  end
                                                  if not ESX.Game.IsSpawnPointClear(table.Positions.spawnVeh, 3.0) then
                                                       ESX.ShowNotification("~r~Erreur~s~~n~- Un véhicule bloque la sortie")
                                                  else
                                                       ESX.Game.SpawnVehicle(v.name, table.Positions.spawnVeh, table.Positions.spawnHeading, function(vehicle)
                                                            lastVehicle = vehicle
                                                            boucleVehicle = true
                                                            local newPlate = GeneratePlate()
                                                            local vehicleProps = pGarage.GetVehicleProperties(vehicle)
                                                            vehicleProps.plate = newPlate
                                                            SetVehicleNumberPlateText(vehicle, newPlate)
                                                            SetModelAsNoLongerNeeded(vehicle)
                                                            SetEntityAsNoLongerNeeded(vehicle)
                                                            SneakyEvent("sCardealer:sellVehicle", table.Job, v.name)
                                                            SneakyEvent("pGarage:Givecar", GetPlayerServerId(closestPly), GetLabelText(GetDisplayNameFromVehicleModel(v.name)), v.name, newPlate, vehicleProps, 0)
                                                            RageUI.Popup({message = "Véhicule "..GetLabelText(GetDisplayNameFromVehicleModel(v.name)).." [~b~"..newPlate.."~s~] atrribué à ~b~"..GetPlayerName(closestPly).."~s~ !"})
                                                            openedMenu = false
                                                            RageUI.CloseAll()
                                                            FreezeEntityPosition(PlayerPedId(), false)
                                                            TriggerEvent('persistent-vehicles/register-vehicle', vehicle)
                                                       end)
                                                  end
                                             end         
                                        end)
                                   end
                              end
                         else
                              RageUI.Separator("")
                              RageUI.Separator("~c~Chargement ...")
                              RageUI.Separator("")
                         end
                    end)
                    for k,v in pairs(table.Vehicles) do
                         RageUI.IsVisible(RMenu:Get("cardealer", v.Name), true, false, false, function()
                              for k,v in pairs(v.List) do
                                   PU = v.price
                                   PV = v.price*1.25
                                   if ESX.PlayerData.job.name == table.Job then
                                        RageUI.List(GetLabelText(GetDisplayNameFromVehicleModel(v.name)), buttonList.Array, buttonList.Index, "Prix d'usine : "..PU.."~g~$~s~\nPrix vendeur : "..PV.."~g~$~s~", {}, true, function(h, a, s, i)
                                             buttonList.Index = i
                                             if i == 1 then
                                                  if s then
                                                       if localVeh ~= GetHashKey(v.name) then
                                                            TriggerEvent('persistent-vehicles/forget-vehicle', Entity)
                                                            DeleteEntity(Entity)
                                                            local model = GetHashKey(v.name)
                                                            RequestModel(model)
                                                            while not HasModelLoaded(model) do Wait(1) end
                                                            local veh = CreateVehicle(model, table.Positions.visualVeh, table.Positions.visualHeading, 0, 0)
                                                            SetVehicleDoorsLockedForAllPlayers(veh, true)
                                                            Entity = veh
                                                            FreezeEntityPosition(veh, true)
                                                            localVeh = GetEntityModel(veh)
                                                            lastName = v.name
                                                            tournerveh = veh
                                                            headingobject = true
                                                            TriggerEvent('persistent-vehicles/register-vehicle', veh)
                                                       end
                                                  end
                                             elseif i == 2 then
                                                  if s then
                                                       SneakyEvent("sCardealer:addVehicule", table.Job, GetLabelText(GetDisplayNameFromVehicleModel(v.name)), v.name, v.price)
                                             
                                                  end
                                             end
                                        end)
                                   else
                                        RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.name)), "Prix : "..PV.."~g~$~s~", {RightLabel = "→ ~b~Voir"}, true,function(h,a,s)
                                             if s then
                                                  if localVeh ~= GetHashKey(v.name) then
                                                       TriggerEvent('persistent-vehicles/forget-vehicle', Entity)
                                                       DeleteEntity(Entity)
                                                       local model = GetHashKey(v.name)
                                                       RequestModel(model)
                                                       while not HasModelLoaded(model) do Wait(1) end
                                                       local veh = CreateVehicle(model, table.Positions.visualVeh, table.Positions.visualHeading, 0, 0)
                                                       SetVehicleDoorsLocked(veh, 2)
                                                       Entity = veh
                                                       FreezeEntityPosition(veh, true)
                                                       localVeh = GetEntityModel(veh)
                                                       lastName = v.name
                                                       tournerveh = veh
                                                       headingobject = true
                                                       TriggerEvent('persistent-vehicles/register-vehicle', veh)
                                                  end
                                             end 
                                        end)                               
                                   end
                              end
                         end)
                    end
               end
          end)
     end
end

local function openCarDealerMenuKey(table)
     if openedMenu then
          openedMenu = false
          RageUI.Visible(RMenu:Get("cardealer", "main-key"), false)
          return
     else
          CarDealerGetVehicleNoKey()
          FreezeEntityPosition(PlayerPedId(), true)
          openedMenu = true
          RMenu:Get("cardealer", "main-key"):SetSubtitle(table.Label..' - ~b~Clés~s~')
          RMenu:Get("cardealer", "main-key"):SetSpriteBanner("root_cause", table.Banner)
          RageUI.Visible(RMenu:Get("cardealer", "main-key"), true)
          Citizen.CreateThread(function()
               while openedMenu do
                    Wait(1.0)
                    RageUI.IsVisible(RMenu:Get("cardealer", "main-key"), true, false, false, function()
                         if #getkeys == 0 then
                              RageUI.Separator("")
                              RageUI.Separator("~c~Aucun véhicule sans clés !")
                              RageUI.Separator("")
                         else
                              for k,v in pairs(getkeys) do
                                   
                                   if v.donated == 1 then
                                        donatedLabel = "[~o~Boutique~s~] "
                                   else
                                        donatedLabel = ""
                                   end

                                   RageUI.Button(donatedLabel..v.label, nil, {RightLabel = "~b~Créer~s~ →"}, true, function(h, a, s)
                                        if s then
                                             SneakyEvent('Sneakyesx_vehiclelock:registerkey', v.value, v.donated, 'no')
                                             Citizen.SetTimeout(150, function()
                                                  CarDealerGetVehicleNoKey()
                                             end)
                                        end
                                   end)
                              end
                         end
                    end)
               end
          end)
     end
end

Citizen.CreateThread(function()
     ConcessESX()
     while true do
          local myCoords = GetEntityCoords(PlayerPedId())
          local nofps = false

          for k,v in pairs(CarDealer) do
               local caissePos = v.Positions.caisse
               local cataloguePos = v.Positions.catalogue
               local keyPos = v.Positions.key

               if not openedMenu then

                    if ESX.PlayerData.job.name == v.Job then

                         if #(myCoords-caissePos) < 1.0 then
                              nofps = true
                              ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir la caisse .")
                              if IsControlJustReleased(0, 38) then
                                   openCarDealerMenu(v)
                              end
                         elseif #(myCoords-caissePos) < 4.5 then
                              nofps = true
                              DrawMarker(21, caissePos, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 0, 255, 236, 150, true, true, p19, true)
                         end 
                         
                    end

                    if #(myCoords-cataloguePos) < 1.0 then
                         nofps = true
                         ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le catalogue .")
                         if IsControlJustReleased(0, 38) then
                              openCarDealerMenuCatalogue(v)
                         end
                    elseif #(myCoords-cataloguePos) < 4.5 then
                         nofps = true
                         DrawMarker(21, cataloguePos, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 0, 255, 236, 150, true, true, p19, true)
                    end  

                    if #(myCoords-keyPos) < 1.0 then
                         nofps = true
                         ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour faire ses clés .")
                         if IsControlJustReleased(0, 38) then
                              openCarDealerMenuKey(v)
                         end
                    elseif #(myCoords-keyPos) < 4.5 then
                         nofps = true
                         DrawMarker(21, keyPos, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 0, 255, 236, 150, true, true, p19, true)
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


local ConcessActionMenu = {}
function OpenConcessActionMenuRageUIMenu()

    if ConcessActionMenu.Menu then 
        ConcessActionMenu.Menu = false 
        RageUI.Visible(RMenu:Get('concessactionmenu', 'main'), false)
        return
    else
        RMenu.Add('concessactionmenu', 'main', RageUI.CreateMenu("", "", 0, 0,"root_cause","shopui_title_legendarymotorsport"))
	   RMenu.Add('concessactionmenu', 'action', RageUI.CreateSubMenu(RMenu:Get("concessactionmenu", "main"),"", "~b~Legendary Motorsport"))
        RMenu.Add('concessactionmenu', 'facture', RageUI.CreateSubMenu(RMenu:Get("concessactionmenu", "action"),"", "~b~Legendary Motorsport"))
        RMenu:Get('concessactionmenu', 'main'):SetSubtitle("~b~Legendary Motorsport")
        RMenu:Get('concessactionmenu', 'main').EnableMouse = false
        RMenu:Get('concessactionmenu', 'main').Closed = function()
          ConcessActionMenu.Menu = false
        end
        ConcessActionMenu.Menu = true 
        RageUI.Visible(RMenu:Get('concessactionmenu', 'main'), true)
        Citizen.CreateThread(function()
			while ConcessActionMenu.Menu do
                    RageUI.IsVisible(RMenu:Get('concessactionmenu', 'main'), true, false, true, function()
                         local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
                         if #(pCoords-vector3(-791.96704101562,-218.05763244629,37.414203643799)) < 40.0 then
                              RageUI.Button("Fourrière", nil, { RightLabel = "→" },true, function(h,a,s)
                                   if s then
                                        local vehicle = ESX.Game.GetVehicleInDirection()
                                        if not impound then
                                             impound = true
                                             impoundtask = ESX.SetTimeout(10000,function()
                                                  ClearPedTasks(PlayerPedId())
                                                  local ServerID = GetPlayerServerId(NetworkGetEntityOwner(vehicle))
                                                  SneakyEvent("SneakyLife:Delete", VehToNet(vehicle), ServerID)
                                                  ESX.ShowHelpNotification("Mise en fourrière ~g~réussi~s~.")
                                             end)
                                             ESX.ShowHelpNotification("Vous êtes en train de mettre en fourrière le ~b~véhicule~s~.")
                                             TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
                                        end
                                        Citizen.CreateThread(function()
                                             while impound do
                                                  Citizen.Wait(1000)
                                                  local coords = GetEntityCoords(PlayerPedId())
                                                  vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
                                                  if not DoesEntityExist(vehicle) and impound then
                                                       ESX.ShowHelpNotification("Mise en fourrière annulée.")
                                                       ESX.ClearTimeout(impoundtask)
                                                       ClearPedTasks(PlayerPedId())
                                                       impound = false
                                                       break
                                                  end
                                             end
                                        end)
                                   end
                              end)
                         else
                              RageUI.Separator("")
                              RageUI.Separator("~c~Trop loin du concessionnaire...")
                              RageUI.Separator("")
                         end
                    end)
			     Wait(0)
			end
		end)
	end
end

function CheckServiceConcess()
	return onService
end

tournerveh = nil
CreateThread(function() 
	while true do
        if headingobject then
            Wait(1)
        if tournerveh ~= nil then
            _heading = GetEntityHeading(tournerveh)
            _z = _heading - 0.10
            SetEntityHeading(tournerveh, _z)
        end
    else
        Wait(1500)
        end
    end
end)
