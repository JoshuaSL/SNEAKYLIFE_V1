-- Debut de ESX

ESX = nil
TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)

-- Debut du Config

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

-- Debut des events

RegisterNetEvent("kEntrepot:enterStock")
AddEventHandler("kEntrepot:enterStock", function(table)
    local xPlayer = ESX.GetPlayerFromId(source)
    if StockageEntreprise[xPlayer.job.name] == nil then
        banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : enter entrepôt",
			description = "Anticheat : enter entrepôt"
		})
		return 
    end

    if not table or table == nil then return end
    exports["pma-voice"]:updateRoutingBucket(source,table.Bucket)
    exports.sFramework:onSavedPlayer(false, xPlayer.identifier)
    TriggerClientEvent("kEntrepot:returnEnterStock", source, table)
end)

RegisterNetEvent("kEntrepot:exitStock")
AddEventHandler("kEntrepot:exitStock", function(table)
    local xPlayer = ESX.GetPlayerFromId(source)
    if StockageEntreprise[xPlayer.job.name] == nil then
        banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Anticheat : achat item entrepôt",
			description = "Anticheat : achat item entrepôt"
		})
		return 
    end

    if not table or table == nil then return end
    exports["pma-voice"]:updateRoutingBucket(source,0)
    exports.sFramework:onSavedPlayer(true, xPlayer.identifier)
    TriggerClientEvent("kEntrepot:returnExitStock", source, table)
end)

ESX.RegisterServerCallback("kEntrepot:buyItems", function(source, cb, item, price, job)
    if source then
        local xPlayer = ESX.GetPlayerFromId(source)
        if StockageEntreprise[xPlayer.job.name] == nil or StockageEntreprise[job] == nil then
            banPlayerAC(xPlayer.source, {
                name = "changestateuser",
                title = "Anticheat : achat item entrepôt",
                description = "Anticheat : achat item entrepôt"
            })
            return 
        end
        if job ~= xPlayer.job.name then
            banPlayerAC(xPlayer.source, {
                name = "changestateuser",
                title = "Anticheat : achat item entrepôt",
                description = "Anticheat : achat item entrepôt"
            })
            return  
        end
        if xPlayer.getAccount("cash").money >= price then
            cb("money")
            TriggerClientEvent("Sneakyesx:showNotification", source, "Vous venez d'acheter ~b~<C>1x "..ESX.GetItemLabel(item).."~s~ pour "..price.."~g~$<C>~s~ !")
            xPlayer.removeAccountMoney("cash", price)
            xPlayer.addInventoryItem(item, 1)
            exports.sCore:SendLogs(1752220,"Achat d'item (entrepôt)",""..GetPlayerName(source).." vient d'acheter "..count.." de "..ESX.GetItemLabel(item).." avec l'entreprise : "..job.." \n License de la source : "..xPlayer.identifier,"https://discord.com/api/webhooks/878607410447663114/LKTG2QJJNKZB7X87kT_HE0My15V1BsOBsBb4A0seDOM_LB0hPvgUARAYKi0KxtgdxesG")
        else
            TriggerClientEvent("Sneakyesx:showNotification", source, "~r~Vous n'avez pas assez d'argent !")
            cb("pasmoney")
        end
    end
end)