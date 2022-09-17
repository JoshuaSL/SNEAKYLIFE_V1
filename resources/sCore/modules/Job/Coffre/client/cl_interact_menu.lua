ESX = nil
opened = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job2 == nil or ESX.GetPlayerData().job == nil do Citizen.Wait(10) end
    ESX.PlayerData = ESX.GetPlayerData()
    ESX.WeaponList = ESX.GetWeaponList()

    for i = 1, #ESX.WeaponList, 1 do
        if ESX.WeaponList[i].name == 'WEAPON_UNARMED' then
            ESX.WeaponList[i] = nil
        else
            ESX.WeaponList[i].hash = GetHashKey(ESX.WeaponList[i].name)
        end
    end
end)
SneakyEvent = TriggerServerEvent
local Coffreorga = {

    {
        pos = vector3(129.05120849609,-1281.2406005859,29.26932144165),
        job = true,
        name = "unicorn",
        label = " Vanilla unicorn",
        texturedict = "root_cause",
        texturename = "shopui_title_vanillaunicorn",
		marker = {
			["R"] = 119,
			["G"] = 119,
			["B"] = 119,
		},
		color = "~y~",
    },
    {
        pos = vector3(1707.50390625,4918.7622070312,42.063682556152),
        job = true,
        name = "ltd_nord",
        label = " LTD Nord",
        texturedict = "shopui_title_gasstation",
        texturename = "shopui_title_gasstation",
		marker = {
			["R"] = 0,
			["G"] = 0,
			["B"] = 255,
		},
		color = "~b~",
    },
    {
        pos = vector3(-708.15997314453,-903.71704101562,19.215599060059),
        job = true,
        name = "ltd_sud",
        label = " LTD Sud",
        texturedict = "shopui_title_gasstation",
        texturename = "shopui_title_gasstation",
		marker = {
			["R"] = 0,
			["G"] = 0,
			["B"] = 255,
		},
		color = "~b~",
    },
    {
        pos = vector3(365.49725341797,-1608.9156494141,29.292057037354),
        job = true,
        name = "lssd",
        label = "Los Santos Sheriff's Department",
        texturedict = "root_cause",
        texturename = "lssd",
		marker = {
			["R"] = 119,
			["G"] = 119,
			["B"] = 119,
		},
		color = "~c~",
    },
    {
        pos = vector3(1765.0749511719,3331.6469726563,41.438484191895),
        job = true,
        name = "motoshop",
        label = "Concessionnaire Moto",
        texturedict = "root_cause",
        texturename = "motoshop",
		marker = {
			["R"] = 119,
			["G"] = 119,
			["B"] = 119,
		},
		color = "~c~",
    },
    {
        pos = vector3(-70.722587585449,68.441513061523,75.83528137207),
        job = true,
        name = "carshop",
        label = "Concessionnaire",
        texturedict = "root_cause",
        texturename = "shopui_title_legendarymotorsport",
		marker = {
			["R"] = 119,
			["G"] = 119,
			["B"] = 119,
		},
		color = "~c~",
    },
    {
        pos = vector3(307.47210693359,-601.89898681641,43.29275894165),
        job = true,
        name = "ambulance",
        label = "Ambulance",
        texturedict = "root_cause",
        texturename = "ambulance",
		marker = {
			["R"] = 119,
			["G"] = 119,
			["B"] = 119,
		},
		color = "~c~",
    },
    {
        pos = vector3(-1083.2739257812,-811.03552246094,11.03736782074),
        job = true,
        name = "police",
        label = "Los Santos Police Department",
        texturedict = "root_cause",
        texturename = "police",
		marker = {
			["R"] = 119,
			["G"] = 119,
			["B"] = 119,
		},
		color = "~c~",
    },
    {
        pos = vector3(-716.34442138672,266.71295166016,84.100997924805),
        job = true,
        name = "agentimmo",
        label = "Dynasty 8",
        texturedict = "root_cause",
        texturename = "shopui_title_dynasty8",
		marker = {
			["R"] = 159,
			["G"] = 255,
			["B"] = 123,
		},
		color = "~g~",
    },
    {
        pos = vector3(-203.23342895508,-1340.7426757812,30.89044380188),
        job = true,
        name = "mecano",
        label = "Benny's",
        texturedict = "shopui_title_supermod",
        texturename = "shopui_title_supermod",
		marker = {
			["R"] = 119,
			["G"] = 119,
			["B"] = 119,
		},
		color = "~r~",
    },
    {
        pos = vector3(1982.4357910156,3052.74609375,47.215034484863),
        job = true,
        name = "yellowjack",
        label = "YellowJack",
        texturedict = "root_cause",
        texturename = "yellowjack",
		marker = {
			["R"] = 255,
			["G"] = 251,
			["B"] = 0,
		},
		color = "~y~",
    },
    {
        pos = vector3(-534.89660644531,-192.34661865234,47.423046112061-0.2),
        job = true,
        name = "gouvernement",
        label = "Gouvernement",
        texturedict = "root_cause",
        texturename = "gouvernement",
		marker = {
			["R"] = 119,
			["G"] = 119,
			["B"] = 119,
		},
		color = "~c~",
    },
    { 
        pos = vector3(1188.6098632812,2640.9079589844,38.401977539062-0.2),
        job = true,
        name = "harmony",
        label = "Harmony Repair & Custom",
        texturedict = "root_cause",
        texturename = "harmony",
		marker = {
			["R"] = 119,
			["G"] = 119,
			["B"] = 119,
		},
		color = "~c~",
    },
    { 
        pos = vector3(-1184.1192626953,-1157.0349121094,7.6679792404175-0.2),
        job = true,
        name = "noodle",
        label = "Noodle Exchange",
        texturedict = "root_cause",
        texturename = "noodle",
		marker = {
			["R"] = 119,
			["G"] = 119,
			["B"] = 119,
		},
		color = "~c~",
    },
    { 
        pos = vector3(-1378.1103515625,-630.18231201172,30.819589614868-0.2),
        job = true,
        name = "bahamas",
        label = "Bahamas ~p~Mamas",
        texturedict = "root_cause",
        texturename = "bahamas",
		marker = {
			["R"] = 119,
			["G"] = 119,
			["B"] = 119,
		},
		color = "~c~",
    },
}


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
    ESX.PlayerData.job2 = job2
end)

Citizen.CreateThread(function()
    while true do
        att = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        if Coffreorga ~= nil and ESX ~= nil then
            for k,v in pairs(Coffreorga) do
                if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.name == v.name or ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == v.name then
                    if v.pos ~= nil then
                        local mPos = #(pCoords-v.pos)
                        if mPos <= 10.0 then
                            att = 1
                            DrawMarker(1, v.pos.x, v.pos.y, v.pos.z-0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, v.marker["R"], v.marker["G"], v.marker["B"], 170, 0, 0, 0, 1, nil, nil, 0)
                        
                            if mPos <= 1.5 then
                                ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour interagir")
                                if IsControlJustPressed(0, 51) then
                                    if v.job then
                                        TriggerEvent("esx_inventoryhud:openStorageInventory",ESX.PlayerData.job.name)
                                    else
                                        TriggerEvent("esx_inventoryhud:openStorageInventory",ESX.PlayerData.job2.name)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(att)
    end
end)