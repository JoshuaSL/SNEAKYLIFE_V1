-- Debut de ESX

ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
		TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
         Citizen.Wait(10)
   end
   if ESX.IsPlayerLoaded() then
         ESX.PlayerData = ESX.GetPlayerData()
   end
end)
SneakyEvent = TriggerServerEvent
RegisterNetEvent('Sneakyesx:playerLoaded')
AddEventHandler('Sneakyesx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)
RegisterNetEvent('Sneakyesx:setJob')
AddEventHandler('Sneakyesx:setJob', function(job)
    ESX.PlayerData.job = job
end)
SneakyEvent = TriggerServerEvent

local StockageEntreprise = {
    ["unicorn"] = {
        Positions = {
            enter = vector3(1240.4508056641,-3168.1667480469,7.1048555374146),
            stock = vector3(1097.8975830078,-3098.1689453125,-38.999923706055),
            exit = vector3(1087.8465576172,-3099.263671875,-38.999912261963)
        },
        Label = "Unicorn",
        Description = "Aliments du Unicorn",
        Texture = "root_cause",
        Banner = "shopui_title_vanillaunicorn",
        Bucket = 150,
        Items = {
            {label = "Whisky", name = "whisky", price = 50},
            {label = "Vodka", name = "vodka", price = 60},
            {label = "Bière", name = "beer", price = 15},
            {label = "Tequila", name = "tequila", price = 25},
            {label = "Redbull", name = "redbull", price = 6},
            {label = "Coca-Cola", name = "coca", price = 5},
            {label = "Jus d'orange", name = "orange", price = 3},
            {label = "Limonade", name = "limonade", price = 2}
        },
    },
    ["yellowjack"] = {
        Positions = {
            enter = vector3(1240.4508056641,-3168.1667480469,7.1048555374146),
            stock = vector3(1103.9982910156,-3098.8588867188,-38.999954223633),
            exit = vector3(1087.8465576172,-3099.263671875,-38.999912261963)
        },
        Label = "YellowJack",
        Description = "Aliments du YellowJack",
        Texture = "root_cause",
        Banner = "yellowjack",
        Bucket = 150,
        Items = {
            {label = "Whisky", name = "whisky", price = 50},
            {label = "Vodka", name = "vodka", price = 60},
            {label = "Bière", name = "beer", price = 15},
            {label = "Tequila", name = "tequila", price = 25},
            {label = "Redbull", name = "redbull", price = 6},
            {label = "Coca-Cola", name = "coca", price = 5},
            {label = "Jus d'orange", name = "orange", price = 3},
            {label = "Limonade", name = "limonade", price = 2}
        },
    },
    ["noodle"] = {
        Positions = {
            enter = vector3(1240.4508056641,-3168.1667480469,7.1048555374146),
            stock = vector3(1103.9982910156,-3098.8588867188,-38.999954223633),
            exit = vector3(1087.8465576172,-3099.263671875,-38.999912261963)
        },
        Label = "Noodle Exchange",
        Description = "Aliments du Noodle Exchange",
        Texture = "root_cause",
        Banner = "noodle",
        Bucket = 150,
        Items = {
            {label = "Saké", name = "sake", price = 1},
            {label = "Thé vert", name = "the_vert", price = 2},
            {label = "Jus de Leechi", name = "jus_leechi", price = 3},
            {label = "Maki", name = "maki", price = 4},
            {label = "Bol de Nouilles", name = "bol_de_nouilles", price = 5},
            {label = "Assiette de Sushis", name = "assiette_de_sushis", price = 8},
            {label = "Rouleau de Printemps", name = "rouleau_de_printemps", price = 6},
            {label = "Soupe de Nouille", name = "soupe_de_nouille", price = 8}
        },
    },
    ["ltd_nord"] = {
        Positions = {
            enter = vector3(2521.3666992188,4124.31640625,38.630710601807),
            stock = vector3(1103.9982910156,-3098.8588867188,-38.999954223633),
            exit = vector3(1087.8465576172,-3099.263671875,-38.999912261963)
        },
        Label = "Limited ~r~LTD~s~ Gasoline",
        Description = "Aliments du LTD Nord",
        Texture = "shopui_title_gasstation",
        Banner = "shopui_title_gasstation",
        Bucket = 150,
        Items = {
            {label = "Sandwich", name = "sandwich", price = 1},
            {label = "Chips", name = "chips", price = 1},
            {label = "Hot-dog", name = "hotdog", price = 1},
            {label = "Jus d'orange", name = "jus_orange", price = 1},
            {label = "Bouteille d'eau", name = "water", price = 1},
            {label = "Soda", name = "soda", price = 1},
            {label = "Bière sans alcool", name = "beer_2", price = 1},
            {label = "Tablette de chocolat", name = "chocolate", price = 1},
            {label = "Donut", name = "donut", price = 1}
        },
    },
    ["ltd_sud"] = {
        Positions = {
            enter = vector3(1240.4508056641,-3168.1667480469,7.1048555374146),
            stock = vector3(1103.9982910156,-3098.8588867188,-38.999954223633),
            exit = vector3(1087.8465576172,-3099.263671875,-38.999912261963)
        },
        Label = "Limited ~r~LTD~s~ Gasoline",
        Description = "Aliments du LTD Sud",
        Texture = "shopui_title_gasstation",
        Banner = "shopui_title_gasstation",
        Bucket = 150,
        Items = {
            {label = "Sandwich", name = "sandwich", price = 1},
            {label = "Chips", name = "chips", price = 1},
            {label = "Hot-dog", name = "hotdog", price = 1},
            {label = "Jus d'orange", name = "jus_orange", price = 1},
            {label = "Bouteille d'eau", name = "water", price = 1},
            {label = "Soda", name = "soda", price = 1},
            {label = "Bière sans alcool", name = "beer_2", price = 1},
            {label = "Tablette de chocolat", name = "chocolate", price = 1},
            {label = "Donut", name = "donut", price = 1}
        },
    },
    ["bahamas"] = {
        Positions = {
            enter = vector3(1240.4508056641,-3168.1667480469,7.1048555374146),
            stock = vector3(1103.9982910156,-3098.8588867188,-38.999954223633),
            exit = vector3(1087.8465576172,-3099.263671875,-38.999912261963)
        },
        Label = "Bahamas ~p~Mamas",
        Description = "Aliments du Bahamas",
        Texture = "root_cause",
        Banner = "bahamas",
        Bucket = 150,
        Items = {
            {label = "Whisky", name = "whisky", price = 50},
            {label = "Vodka", name = "vodka", price = 60},
            {label = "Bière", name = "beer", price = 15},
            {label = "Tequila", name = "tequila", price = 25},
            {label = "Redbull", name = "redbull", price = 6},
            {label = "Coca-Cola", name = "coca", price = 5},
            {label = "Jus d'orange", name = "orange", price = 3},
            {label = "Limonade", name = "limonade", price = 2}
        },
    },
    ["mecano"] = {
        Positions = {
            enter = vector3(1240.4508056641,-3168.1667480469,7.1048555374146),
            stock = vector3(1103.9982910156,-3098.8588867188,-38.999954223633),
            exit = vector3(1087.8465576172,-3099.263671875,-38.999912261963)
        },
        Label = "Bennys Motorworks",
        Description = "Pièces de réparation et d'entretien",
        Texture = "shopui_title_supermod",
        Banner = "shopui_title_supermod",
        Bucket = 150,
        Items = {
            {label = "Moteur", name = "engine", price = 50},
            {label = "Trousse à outils", name = "outils", price = 60},
            {label = "Roue de secours", name = "pneu", price = 15},
            {label = "Kit de lavage", name = "kit_de_lavage", price = 25},
        },
    },
    ["harmony"] = {
        Positions = {
            enter = vector3(1240.4508056641,-3168.1667480469,7.1048555374146),
            stock = vector3(1103.9982910156,-3098.8588867188,-38.999954223633),
            exit = vector3(1087.8465576172,-3099.263671875,-38.999912261963)
        },
        Label = "Harmony and Repair's",
        Description = "Pièces de réparation et d'entretien",
        Texture = "root_cause",
        Banner = "harmony",
        Bucket = 150,
        Items = {
            {label = "Moteur", name = "engine", price = 50},
            {label = "Trousse à outils", name = "outils", price = 60},
            {label = "Roue de secours", name = "pneu", price = 15},
            {label = "Kit de lavage", name = "kit_de_lavage", price = 25},
        },
    },
}

local playerEnterStock = false
local openedMenu = false
local menu = RageUI.CreateMenu("Sotckage", "Entreprise", nil, nil)
menu.Closed = function() openedMenu = false FreezeEntityPosition(PlayerPedId(), false) end

function openStockEntrepotMenu(table)
    if openedMenu then
        openedMenu = false
        RageUI.Visible(menu, false)
        return
    else
        openedMenu = true
        FreezeEntityPosition(PlayerPedId(), true)
        menu:SetTitle("")
        menu:SetSubtitle(table.Description)
        menu:SetSpriteBanner(table.Texture, table.Banner)
        RageUI.Visible(menu, true)
        Citizen.CreateThread(function()
            while openedMenu do
                Wait(1.0)
                RageUI.IsVisible(menu, true, false, true, function()
                    RageUI.Separator("Liste des ~b~aliments~s~ ↓")
                    for k,v in pairs(table.Items) do
                        RageUI.Button(v.label, nil, {RightLabel = "→ "..v.price.."~g~$"}, true, function(h, a, s)
                            if s then
                                ESX.TriggerServerCallback("kEntrepot:buyItems", function(boum)
                                end, v.name, v.price, ESX.PlayerData.job.name)
                            end
                        end)
                    end
                end)
            end
        end)
    end
end

Citizen.CreateThread(function()
    while ESX == nil do
		TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
         Citizen.Wait(10)
   end
   if ESX.IsPlayerLoaded() then
         ESX.PlayerData = ESX.GetPlayerData()
   end
    while true do
        local myCoords = GetEntityCoords(PlayerPedId())
        local nofps = false

        if StockageEntreprise[ESX.PlayerData.job.name] ~= nil then

            if #(myCoords-StockageEntreprise[ESX.PlayerData.job.name].Positions["enter"]) < 1.0 then
                nofps = true
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour entrer dans l'entrepôt")
                if IsControlJustReleased(0, 38) then
                    ESX.ShowNotification("Vous entrez dans ~b~<C>l'entrepôt<C>~s~.")
                    SneakyEvent("kEntrepot:enterStock", StockageEntreprise[ESX.PlayerData.job.name])
                end
            end

            if not openedMenu then
                if #(myCoords-StockageEntreprise[ESX.PlayerData.job.name].Positions["stock"]) < 1.0 then
                    if playerEnterStock then
                        nofps = true
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le stockage")
                        if IsControlJustReleased(0, 38) then
                            openStockEntrepotMenu(StockageEntreprise[ESX.PlayerData.job.name])
                        end     
                    end
                end
            end

            if #(myCoords-StockageEntreprise[ESX.PlayerData.job.name].Positions["exit"]) < 1.0 then
                if playerEnterStock then
                    nofps = true
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour sortir de l'entrepôt")
                    if IsControlJustReleased(0, 38) then
                        ESX.ShowNotification("Vous sortez de ~b~<C>l'entrepôt<C>~s~.")
                        SneakyEvent("kEntrepot:exitStock", StockageEntreprise[ESX.PlayerData.job.name])
                    end
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

RegisterNetEvent("kEntrepot:returnEnterStock")
AddEventHandler("kEntrepot:returnEnterStock", function(table)
    if not table or table == nil then return end
    SetEntityHeading(PlayerPedId(), 275.79)
    SetEntityCoords(PlayerPedId(), table.Positions["exit"]) 
    playerEnterStock = true
end)

RegisterNetEvent("kEntrepot:returnExitStock")
AddEventHandler("kEntrepot:returnExitStock", function(table)
    if not table or table == nil then return end
    SetEntityCoords(PlayerPedId(), table.Positions["enter"]) 
    playerEnterStock = false
end)