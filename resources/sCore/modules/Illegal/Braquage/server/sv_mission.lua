local MissionStatus = {}
local ESX = nil

TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)

peds = {
    {
        id = "dealer",
        ped = GetHashKey("s_m_y_dealer_01"),
        coords = vector3(891.6, -2538.2, 28.44),
        heading = 172.99,
    },
    {
        id = "lamar",
        ped = GetHashKey("s_m_y_dealer_01"),
        coords = vector3(414.44, 343.92, 102.44),
        heading = 172.99,
    },
    {
        id = "marchandise",
        ped = GetHashKey("s_m_y_dealer_01"),
        coords = vector3(-444.96, 1598.36, 358.2),
        heading = 172.99,
    },
    {
        id = "braquo",
        ped = GetHashKey("s_m_y_robber_01"),
        coords = vector3(1520.76, 6317.68, 24.08),
        heading = 89.5,
    },
}

mission = {
    {
        ped = "lamar",
        id = 1,
        type = "voleVehiculeLamar",
        Titre = "Voler le véhicule une Faction Donk (~r~1000$~s~)",
        Desc = "Nous avons trouvé un véhicule rare qui se revend bien en pièces détachés. Attention, c'est un mafieu !",
        LongText = "Je t'es indiqué le lieu, je te laisse y aller. Dépêche !",
        vehicule = GetHashKey("faction3"),
        possibleSpawn = {
            {pos = vector3(-1569.72, -1038.6, 13.0-0.95),heading = 254.60,},
            {pos = vector3(1733.68, 4635.08, 43.24-0.95),heading = 297.07,},
            {pos = vector3(487.44, -1334.0, 29.32-0.95),heading = 26.34,},
            {pos = vector3(895.48, 3575.4, 33.48-0.95),heading = 91.39,},
            {pos = vector3(871.56, 2868.48, 56.88-0.95),heading = 205.54,},
        },
        stop = vector3(209.32, 376.16, 107.04),
        prix = 1000,
    },
    {
        ped = "lamar",
        id = 2,
        type = "voleVehiculeLamar",
        Titre = "Voler le véhicule une Virgo (~r~1000$~s~)",
        Desc = "Hum il me semble avoir un camion déposé quelque part, je te laisse aller le chercher mais fais attention !",
        LongText = "Je t'es indiqué le lieu, je te laisse y aller. Dépêche !",
        vehicule = GetHashKey("virgo2"),
        possibleSpawn = {
            {pos = vector3(-1569.72, -1038.6, 13.0-0.95),heading = 254.60,},
            {pos = vector3(1733.68, 4635.08, 43.24-0.95),heading = 297.07,},
            {pos = vector3(487.44, -1334.0, 29.32-0.95),heading = 26.34,},
            {pos = vector3(895.48, 3575.4, 33.48-0.95),heading = 91.39,},
            {pos = vector3(871.56, 2868.48, 56.88-0.95),heading = 205.54,},
        },
        stop = vector3(204.72, 377.2, 107.24),
        prix = 1000,
    },

    {
        ped = "dealer",
        id = 3,
        type = "voleVehicule",
        Titre = "Voler le véhicule une Windsor (~r~1500$~s~)",
        Desc = "Nous avons trouvé un véhicule type 'Windsor' de luxe, nous aimerons que tu la ramène.",
        LongText = "Je t'es indiqué le lieu, je te laisse y aller. Dépêche !",
        vehicule = GetHashKey("windsor"),
        possibleSpawn = {
            {pos = vector3(-1665.8, 391.76, 89.2-0.95),heading = 15.18,},
            {pos = vector3(-218.4, 6381.0, 31.6-0.95),heading = 43.42,},
            {pos = vector3(215.52, 758.36, 204.64-0.95),heading = 48.62,},
            {pos = vector3(1835.8, 3908.48, 33.16-0.95),heading = 195.40,},
            {pos = vector3(-3196.96, 1160.28, 9.64-0.95),heading = 248.81,},
        },
        stop = vector3(1088.32, -2289.4, 30.16),
        prix = 1500,
    },
    {
        ped = "dealer",
        id = 4,
        type = "voleVehicule",
        Titre = "Voler le véhicule un Mesa (~r~1500$~s~)",
        Desc = "Nous avons trouvé un véhicule type 'Mesa', nous aimerons que tu la ramène.",
        LongText = "Je t'es indiqué le lieu, je te laisse y aller. Dépêche !",
        vehicule = GetHashKey("mesa"),
        possibleSpawn = {
            {pos = vector3(-1665.8, 391.76, 89.2-0.95),heading = 15.18,},
            {pos = vector3(-218.4, 6381.0, 31.6-0.95),heading = 43.42,},
            {pos = vector3(215.52, 758.36, 204.64-0.95),heading = 48.62,},
            {pos = vector3(1835.8, 3908.48, 33.16-0.95),heading = 195.40,},
            {pos = vector3(-3196.96, 1160.28, 9.64-0.95),heading = 248.81,},
        },
        stop = vector3(1087.64, -2300.56, 30.16),
        prix = 1500,
    },

    {
        ped = "marchandise",
        id = 5,
        type = "voleMarchandise",
        Titre = "Ramener une cargaison de drogues",
        Desc = "Un camion rempli de drogues est stationné depuis plusieurs jours, je t'engage pour aller le récupérer !",
        LongText = "Le lieu t'a été donné, vas récupéré le camion et méfie toi !",
        vehicule = GetHashKey("mule3"),
        possibleSpawn = {
            {pos = vector3(1233.48, -3330.8, 5.72-0.95),heading = 181.67,},
            {pos = vector3(-1131.32, -2225.4, 13.2-0.95),heading = 332.96,},
            {pos = vector3(-1575.0, 5166.84, 19.56-0.95),heading = 149.09,},
            {pos = vector3(-194.68, 6536.08, 11.08-0.95),heading = 41.25,},
            {pos = vector3(3695.76, 4557.4, 25.48-0.95),heading = 183.09,},
        },
        stop = vector3(373.2, 787.92, 186.88),
        prix = 1500,
    },

    {
        ped = "braquo",
        id = 6,
        type = "braquo",
        Titre = "Mission Bugstars",
        Desc = "On vas organiser un petit braquage mais qui nécéssite une préparation et un assez gros danger !",
        LongText = "Vas chercher le véhicule.",
        pedWalk = vector3(885.32, -1656.045, 29.28),
        vehicule = GetHashKey("burrito2"),
        spawnVeh = vector3(1541.28, 6335.72, 24.08-0.50),
        headingStart = 58.24,
        stopVehicule = vector3(1396.56, 3595.36, 34.92-0.30),
        headingStop = 110.86,
        ChangementDeTenu = vector3(1399.96, 3596.68, 34.88-0.40),
        possibleVole = {
            {pos = vector3(1390.72, 3608.56, 35.0),heading = 17.97,},
            {pos = vector3(1388.92, 3603.72, 35.0),heading = 105.61,},
            {pos = vector3(1389.2, 3602.2, 35.0),heading = 110.18,},
            {pos = vector3(1390.68, 3601.12, 35.0),heading = 110.05,},
            {pos = vector3(1395.96, 3601.88, 35.0),heading = 198.47,},
            {pos = vector3(1398.52, 3602.72, 35.0),heading = 197.99,},
            {pos = vector3(1397.12, 3607.36, 35.0),heading = 21.72,},
            {pos = vector3(1399.0, 3605.52, 35.0),heading = 294.20,},
            {pos = vector3(1396.08, 3604.4, 35.0),heading = 196.30,}, 
        },
        Caisse = {
            {pos = vector3(1392.88, 3606.4, 35.0),heading = 199.87,},
            {pos = vector3(1391.24, 3605.84, 35.0),heading = 200.4,},
        },
        stop = vector3(-93.72, 2809.64, 53.32),
        prix = 100,
    },
}

local Mission = {
    onService = {}
}

RegisterNetEvent("sMission:ChangeState")
AddEventHandler("sMission:ChangeState",function(state)
    local source = source
    Mission.onService[source] = state
end)

RegisterNetEvent("sMission:SetStatus")
AddEventHandler("sMission:SetStatus", function(id)
    local steam = GetPlayerIdentifier(source, 1)
    local data = {}
    local exist = false
    for k,v in pairs(MissionStatus) do
        if v.id == steam then
            data = v
            exist = true
            table.remove(MissionStatus, k)
        end
    end
    if not exist then
        data = {
            id = steam,
            mission = {},
        }
    end
    table.insert(data.mission, id)
    table.insert(MissionStatus, data)
    TriggerClientEvent("sMission:status", source, data.mission)
end)

RegisterNetEvent("sMission:GetData")
AddEventHandler("sMission:GetData", function()
    TriggerClientEvent("sMission:GetData", source, peds, mission)
end)
RegisterNetEvent("sMission:status")
AddEventHandler("sMission:status", function()
    local steam = GetPlayerIdentifier(source, 1)
    local data = {}
    local exist = false
    for k,v in pairs(MissionStatus) do
        if v.id == steam then
            data = v
            exist = true
        end
    end
    if not exist then
        data = {
            id = steam,
            mission = {},
        }
    end
    TriggerClientEvent("sMission:status", source, data.mission)
end)

RegisterNetEvent("sMission:Gain")
AddEventHandler("sMission:Gain", function(amount)
    local xPlayer = ESX.GetPlayerFromId(source) 
    if not Mission.onService[source] then
        banPlayerAC(xPlayer.source, {
			name = "createentity",
			title = "Give d'argent : "..amount,
			description = "Give d'argent : "..amount
		})
        return 
    end
    xPlayer.addAccountMoney('dirtycash', amount)
end)

ESX.RegisterServerCallback('sMissionCheck2', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getInventoryItem("kit_de_crochetage").count >= 2 then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('sMissionCheck1', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getInventoryItem("kit_de_crochetage").count >= 1 then
		cb(true)
	else
		cb(false)
	end
end)

RegisterNetEvent("sMission:GiveDrugs")
AddEventHandler("sMission:GiveDrugs", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source) 
    local chance = math.random(0, 99);
    if not Mission.onService[source] then
        banPlayerAC(xPlayer.source, {
			name = "createentity",
			title = "Give d'argent : "..amount,
			description = "Give d'argent : "..amount
		})
        return 
    end
    if chance >= 0 and chance <= 33 then
        xPlayer.addInventoryItem("coke", 20)
    elseif chance >= 33 and chance <= 66 then
        xPlayer.addInventoryItem("weed", 20)
    elseif chance >= 66 then
        xPlayer.addInventoryItem("meth", 20)
    end
end)

local braquageEnCours = false
local min = 60*1000
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if braquageEnCours then
            Wait(30*min)
            braquageEnCours = false
        end
    end
end)

RegisterNetEvent("sMission:SetStatus")
AddEventHandler("sMission:SetStatus", function()
    braquageEnCours = true
end)

RegisterNetEvent("sMission:CanDoIt")
AddEventHandler("sMission:CanDoIt", function()
    if braquageEnCours then
        TriggerClientEvent("sMission:CanDoIt", source, false)
    else
        TriggerClientEvent("sMission:CanDoIt", source, true)
    end
end)