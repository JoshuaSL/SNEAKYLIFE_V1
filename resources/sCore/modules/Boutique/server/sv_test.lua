ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

---@class sBoutique
sBoutique = sBoutique or {};

---@class sBoutique.Cache
sBoutique.Cache = sBoutique.Cache or {}

---@class sBoutique.Cache.Case
sBoutique.Cache.Case = sBoutique.Cache.Case or {}

function sBoutique:HasValue(tab, val)
    for i = 1, #tab do
        if tab[i] == val then
            return true
        end
    end
    return false
end

local characters = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" }

Server = {};

function Server:GetIdentifiers(source)
    if (source ~= nil) then
        local identifiers = {}
        local playerIdentifiers = GetPlayerIdentifiers(source)
        for _, v in pairs(playerIdentifiers) do
            local before, after = playerIdentifiers[_]:match("([^:]+):([^:]+)")
            identifiers[before] = playerIdentifiers[_]
        end
        return identifiers
    else
        error("source is nil")
    end
end

function CreateRandomPlateText()
    local plate = ""
    math.randomseed(GetGameTimer())
    for i = 1, 3 do
        plate = plate .. characters[math.random(1, #characters)]
    end
    plate = plate .. ""
    for i = 1, 3 do
        plate = plate .. math.random(1, 9)
    end
    return plate
end

function Server:OnProcessCheckout(source, price, transaction, onAccepted, onRefused)
    local identifier = Server:GetIdentifiers(source);
    if (identifier['fivem']) then
        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
        MySQL.Async.fetchAll("SELECT SUM(points) FROM tebex_players_wallet WHERE identifiers = @identifiers", {
            ['@identifiers'] = after
        }, function(result)
            local current = tonumber(result[1]["SUM(points)"]);
            if (current ~= nil) then
                if (current >= price) then
                    LiteMySQL:Insert('tebex_players_wallet', {
                        identifiers = after,
                        transaction = transaction,
                        price = '0',
                        currency = 'Points',
                        points = -price,
                    });
                    onAccepted();
                else
                    onRefused();
                    xPlayer.showNotification('Vous ne procédez pas les points nécessaires pour votre achat visité notre boutique.')
                end
            else
                onRefused();
                print('[Info] retrieve points nil')
            end
        end);
    else
        onRefused();
        --print('[Error] Failed to retrieve fivem identifier')
    end
end

function Server:Giving(xPlayer, identifier, item)
    local content = json.decode(item.action);

    if (content.vehicles) then
        for key, value in pairs(content.vehicles) do
        end
    end

    if (content.items) then
        for key, value in pairs(content.items) do
            xPlayer.addInventoryItem(value.name, value.count)
        end
    end
 
    if (content.roue) then
        for key, value in pairs(content.roue) do

        end
    end

    if (content.items) then
        for key, value in pairs(content.items) do
            xPlayer.addInventoryItem(value.name, value.count)
        end
    end

    if (content.bank) then
        for key, value in pairs(content.bank) do
            xPlayer.addAccountMoney('bank', value.count)
        end
    end
end

RegisterServerEvent('SneakyLife:process_checkout')
AddEventHandler('SneakyLife:process_checkout', function(itemId)
    local _src = source
    TriggerEvent("ratelimit", _src, "SneakyLife:process_checkout")
    local source = source;
    if (source) then
        local identifier = Server:GetIdentifiers(source);
        local xPlayer = ESX.GetPlayerFromId(source)
        if (xPlayer) then
            local count, content = LiteMySQL:Select('tebex_boutique'):Where('id', '=', itemId):Get();
            local item = content[1];
            if (item) then
                Server:OnProcessCheckout(source, item.price, string.format("Achat package %s", item.name), function()
                    Server:Giving(xPlayer, identifier, item);
                    SendLogs(15105570,"Boutique - Achat","**"..GetPlayerName(source).."** vient d'acheter une ***"..item.name.."***\n **License** : "..xPlayer.identifier,"https://canary.discord.com/api/webhooks/851712677353095189/qIgZGkHBp0LoJFgkvCPn3qvk7Sage_mvF8zTso6E6hLpA3_N-832_6rOCoHjxjjDxZjy")
                end, function()
                    xPlayer.showNotification("~r~Vous ne posséder pas les points nécessaires")
                end)
            else
                print('[[Error] Failed to retrieve boutique item')
            end
        else
            print('[Error] Failed to retrieve ESX player')
        end
    else
        print('[Error] Failed to retrieve source')
    end
end)

local function random(x, y)
    local u = 0;
    u = u + 1
    if x ~= nil and y ~= nil then
        return math.floor(x + (math.random(math.randomseed(os.time() + u)) * 999999 % y))
    else
        return math.floor((math.random(math.randomseed(os.time() + u)) * 100))
    end
end

local function GenerateLootbox(source, box, list)
    local chance = random(1, 100)
    local gift = { category = 1, item = 1 }
    local minimalChance = 4

    local identifier = Server:GetIdentifiers(source);
    minimalChance = 3
    if (sBoutique.Cache.Case[source] == nil) then
        sBoutique.Cache.Case[source] = {};
        if (sBoutique.Cache.Case[source][box] == nil) then
            sBoutique.Cache.Case[source][box] = {};
        end
    end
    if chance <= minimalChance then
        local rand = random(1, #list[3])
        sBoutique.Cache.Case[source][box][3] = list[3][rand]
        gift.category = 3
        gift.item = list[3][rand]
    elseif (chance > minimalChance and chance <= 30) or (chance > 80 and chance <= 100) then
        local rand = random(1, #list[2])
        sBoutique.Cache.Case[source][box][2] = list[2][rand]
        gift.category = 2
        gift.item = list[2][rand]
    else
        local rand = random(1, #list[1])
        sBoutique.Cache.Case[source][box][1] = list[1][rand]
        gift.category = 1
        gift.item = list[1][rand]
    end
    local finalList = {}
    for _, category in pairs(list) do
        for _, item in pairs(category) do
            local result = { name = item, time = 150 }
            table.insert(finalList, result)
        end
    end
    table.insert(finalList, { name = gift.item, time = 5000 })
    return finalList, gift.item
end

local reward = {
    -- Caisse gold
    ["money_6000"] = { type = "money", message = "Félicitation, vous avez gagner 6000$." },
    ["sanchez2"] = { type = "vehicle", message = "Félicitation, vous avez gagner une Sanchez 2." },
    ["pigth"] = { type = "vehicle", message = "Félicitation, vous avez gagner une Pigth." },
    ["remusvert"] = { type = "vehicle", message = "Félicitation, vous avez gagner une Remus Cabrio." },
    ["vetog"] = { type = "vehicle", message = "Félicitation, vous avez gagner un Vetog." },
    ["weapon_battleaxe"] = { type = "weapon", message = "Félicitation, vous avez gagner une Hache de Guerre." },
    ["weapon_dagger"] = { type = "weapon", message = "Félicitation, vous avez gagner un Karambit." },
    ["blazer"] = { type = "vehicle", message = "Félicitation, vous avez gagner un Blazer." },
    ["patriot2"] = { type = "vehicle", message = "Félicitation, vous avez gagner un Hummer Patriot." },
    ["seashark3"] = { type = "vehicle", message = "Félicitation, vous avez gagner un Jet-ski." },
    ["avisa"] = { type = "vehicle", message = "Félicitation, vous avez gagner un Avisa." },
    ["sneakycoins_800"] = { type = "SneakyCoins", message = "Félicitation, vous avez gagner 800 SneakyCoins." },
    ["money_13500"] = { type = "money", message = "Félicitation, vous avez gagner 13500$." },
    ["havok"] = { type = "vehicle", message = "Félicitation, vous avez gagner un Havok." },
    ["rs3sedan"] = { type = "vehicle", message = "Félicitation, vous avez gagner une RS3 Sedan." },

    -- Caisse Diamond
    ["journeys"] = { type = "vehicle", message = "Félicitation, vous avez gagner un Journeys." },
    ["penne"] = { type = "vehicle", message = "Félicitation, vous avez gagner une Penne." },
    ["primov12"] = { type = "vehicle", message = "Félicitation, vous avez gagner une Primo V12." },
    ["strombergsu"] = { type = "vehicle", message = "Félicitation, vous avez gagner une Stromberg Su." },
    ["rrocket"] = { type = "vehicle", message = "Félicitation, vous avez gagner un Rrocket." },
    ["sneakycoins_1000"] = { type = "SneakyCoins", message = "Félicitation, vous avez gagner 1000 SneakyCoins." },
    ["weapon_bat"] = { type = "weapon", message = "Félicitation, vous avez gagner une Batte lucile." },
    ["weapon_knife"] = { type = "weapon", message = "Félicitation, vous avez gagner un Bayonett." },
    ["money_12500"] = { type = "money", message = "Félicitation, vous avez gagner 12500$." },
    ["stryder"] = { type = "vehicle", message = "Félicitation, vous avez gagner un Stryder." },
    ["mule3"] = { type = "vehicle", message = "Félicitation, vous avez gagner une Mule." },
    ["money_18500"] = { type = "money", message = "Félicitation, vous avez gagner 18500$." },
    ["longfin"] = { type = "vehicle", message = "Félicitation, vous avez gagner un Longfin." },
    ["dodo"] = { type = "vehicle", message = "Félicitation, vous avez gagner un Avion Dodo." },
    ["buzzard2"] = { type = "vehicle", message = "Félicitation, vous avez gagner un Buzzard." }, 
    ["gtr"] = { type = "vehicle", message = "Félicitation, vous avez gagner une Nissan GTR." },

    -- Caisse Race

    ["2f2fgtr34"] = { type = "vehicle", message = "Félicitation, vous avez gagner une Voiture race." },
    ["2f2fgts"] = { type = "vehicle", message = "Félicitation, vous avez gagner une Voiture race." },
    ["2f2fmk4"] = { type = "vehicle", message = "Félicitation, vous avez gagner une Voiture race." },
    ["2f2fmle7"] = { type = "vehicle", message = "Félicitation, vous avez gagner une Voiture race." },
    ["ff4wrx"] = { type = "vehicle", message = "Félicitation, vous avez gagner une Voiture race." },
    ["fnf4r34"] = { type = "vehicle", message = "Félicitation, vous avez gagner une Voiture race." },
    ["fnflan"] = { type = "vehicle", message = "Félicitation, vous avez gagner une Voiture race." },
    ["fnfmits"] = { type = "vehicle", message = "Félicitation, vous avez gagner une Voiture race." },
    ["fnfrx7"] = { type = "vehicle", message = "Félicitation, vous avez gagner une Voiture race." },
    ["money_18500"] = { type = "money", message = "Félicitation, vous avez gagner 18500$." },
}

local box = {
    [1] = {
        [3] = {
            "rs3sedan",
            "havok",
            "sneakycoins_800",
            "pigth",
            "vetog",
        },
        [2] = {
            "money_13500",
            "avisa",
            "seashark3",
            "weapon_dagger",
            "remusvert",
        },
        [1] = {
            "money_13500",
            "weapon_battleaxe",
            "sanchez2",
            "seashark3",
            "blazer",
        },
    }
}

local box2 = {
    [1] = {
        [3] = {
            "gtr",
            "buzzard2",
            "dodo",
            "strombergsu",
        },
        [2] = {
            "primov12",
            "longfin",
            "money_18500",
            "mule3",
            "journeys",
            "penne",
        },
        [1] = {
            "stryder",
            "money_12500",
            "weapon_knife",
            "weapon_bat",
            "sneakycoins_1000",
            "rrocket",
        },
    }
}

local box3 = {
    [1] = {
        [3] = {
            "2f2fgtr34",
            "2f2fgts",
            "2f2fmk4",
            "2f2fmle7",
            "ff4wrx",
            "fnf4r34",
            "fnflan",
            "fnfmits",
            "fnfrx7",
            "money_18500"
        },
        [2] = {
            "2f2fgtr34",
            "2f2fgts",
            "2f2fmk4",
            "2f2fmle7",
            "ff4wrx",
            "fnf4r34",
            "fnflan",
            "fnfmits",
            "fnfrx7",
            "money_18500"
        },
        [1] = {
            "2f2fgtr34",
            "2f2fgts",
            "2f2fmk4",
            "2f2fmle7",
            "ff4wrx",
            "fnf4r34",
            "fnflan",
            "fnfmits",
            "fnfrx7",
            "money_18500"
        },
    }
}
local labeltype = nil
RegisterServerEvent('SneakyLife:process_checkout_case')
AddEventHandler('SneakyLife:process_checkout_case', function(type)
    local _src = source
    TriggerEvent("ratelimit", _src, "SneakyLife:process_checkout_case")
    local source = source;
    if (source) then
        local identifier = Server:GetIdentifiers(source);
        local xPlayer = ESX.GetPlayerFromId(source)
        if type == "case_1" then
            labeltype = "Caisse gold"
        elseif type == "case_2" then
            labeltype = "Caisse diamond"
        elseif type == "case_3" then
            labeltype = "Caisse race"
        end
        SendLogs(15105570,"Boutique - Achat","**"..GetPlayerName(source).."** vient d'acheter une ***"..labeltype.."***\n **License** : "..xPlayer.identifier,"https://canary.discord.com/api/webhooks/851712677353095189/qIgZGkHBp0LoJFgkvCPn3qvk7Sage_mvF8zTso6E6hLpA3_N-832_6rOCoHjxjjDxZjy")
        if (xPlayer) then
            if type == "case_1" then
                Server:OnProcessCheckout(source, 300, "Achat d'une caisse (SneakyLife - Gold)", function()

                    local boxId = 1;
                    local lists, result = GenerateLootbox(source, boxId, box[boxId])
                    local giveReward = {
                        ["SneakyCoins"] = function(_s, license, player)
                            local before, after = result:match("([^_]+)_([^_]+)")
                            local quantity = tonumber(after)
                            if (identifier['fivem']) then
                                local _, fivemid = identifier['fivem']:match("([^:]+):([^:]+)")
                                LiteMySQL:Insert('tebex_players_wallet', {
                                    identifiers = fivemid,
                                    transaction = "Gain dans la boîte SneakyCoins",
                                    price = '0',
                                    currency = 'Points',
                                    points = quantity,
                                });
                            end
                        end,
                        ["weapon"] = function(_s, license, player)
                            xPlayer.addWeapon(result, 150)
                        end,
                        ["money"] = function(_s, license, player)
                            local before, after = result:match("([^_]+)_([^_]+)")
                            local quantity = tonumber(after)
                            player.addAccountMoney('bank', quantity)
                        end,
                        ["vehicle"] = function(_s, license, player)
                            local plate = CreateRandomPlateText()
                            LiteMySQL:Insert('owned_vehicles', {
                                owner = xPlayer.identifier,
                                plate = plate,
                                model = result,
                                props = '{"fuelLevel":100.0}',
                                parked = 1,
                                label = "",
                                donated = 1,
                                garage_private = 0
                            })
                            LiteMySQL:Insert('open_car', {
                                owner = xPlayer.identifier,
                                plate = plate,
                                NB = 1,
                                donated = 1
                            });
                        end,
                    }

                    local r = reward[result];
                    if (r ~= nil) then
                        if (giveReward[r.type]) then
                            giveReward[r.type](source, identifier['license'], xPlayer);
                        end
                    end
                    if (identifier['fivem']) then
                        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
                        LiteMySQL:Insert('tebex_players_wallet', {
                            identifiers = after,
                            transaction = r.message,
                            price = '0',
                            currency = 'Box',
                            points = 0,
                        });
                    end
                    print(result)
                    SendLogs(15105570,"Boutique - Achat","**"..GetPlayerName(source).."** vient de gagner : ***"..result.."***\n **License** : "..xPlayer.identifier,"https://canary.discord.com/api/webhooks/851712677353095189/qIgZGkHBp0LoJFgkvCPn3qvk7Sage_mvF8zTso6E6hLpA3_N-832_6rOCoHjxjjDxZjy")
                    TriggerClientEvent('tebex:on-open-case', source, lists, result, r.message)
                    end, function()
                    xPlayer.showNotification("~r~Vous ne posséder pas les points nécessaires")
                end)
            elseif type == "case_2" then
                Server:OnProcessCheckout(source, 800, "Achat d'une caisse (SneakyLife - Diamond)", function()

                    local boxId = 1;
                    local lists, result = GenerateLootbox(source, boxId, box2[boxId])
                    local giveReward = {
                        ["SneakyCoins"] = function(_s, license, player)
                            local before, after = result:match("([^_]+)_([^_]+)")
                            local quantity = tonumber(after)
                            if (identifier['fivem']) then
                                local _, fivemid = identifier['fivem']:match("([^:]+):([^:]+)")
                                LiteMySQL:Insert('tebex_players_wallet', {
                                    identifiers = fivemid,
                                    transaction = "Gain dans la boîte SneakyCoins",
                                    price = '0',
                                    currency = 'Points',
                                    points = quantity,
                                });
                            end
                        end,
                        ["weapon"] = function(_s, license, player)
                            xPlayer.addWeapon(result, 150)
                        end,
                        ["money"] = function(_s, license, player)
                            local before, after = result:match("([^_]+)_([^_]+)")
                            local quantity = tonumber(after)
                            player.addAccountMoney('bank', quantity)
                        end,
                        ["vehicle"] = function(_s, license, player)
                            local plate = CreateRandomPlateText()
                            LiteMySQL:Insert('owned_vehicles', {
                                owner = xPlayer.identifier,
                                plate = plate,
                                model = result,
                                props = '{"fuelLevel":100.0}',
                                parked = 1,
                                label = "",
                                donated = 1,
                                garage_private = 0
                            })
                            LiteMySQL:Insert('open_car', {
                                owner = xPlayer.identifier,
                                plate = plate,
                                NB = 1,
                                donated = 1
                            });
                        end,
                    }
                    local r = reward[result];
                    if (r ~= nil) then
                        if (giveReward[r.type]) then
                            giveReward[r.type](source, identifier['license'], xPlayer);
                        end
                    end
                    if (identifier['fivem']) then
                        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
                        LiteMySQL:Insert('tebex_players_wallet', {
                            identifiers = after,
                            transaction = r.message,
                            price = '0',
                            currency = 'Box',
                            points = 0,
                        });
                    end
                    print(result)
                    SendLogs(15105570,"Boutique - Achat","**"..GetPlayerName(source).."** vient de gagner : ***"..result.."***\n **License** : "..xPlayer.identifier,"https://canary.discord.com/api/webhooks/851712677353095189/qIgZGkHBp0LoJFgkvCPn3qvk7Sage_mvF8zTso6E6hLpA3_N-832_6rOCoHjxjjDxZjy")
                    TriggerClientEvent('tebex:on-open-case', source, lists, result, r.message)
                    end, function()
                    xPlayer.showNotification("~r~Vous ne posséder pas les points nécessaires")
                end)
            elseif type == "case_3" then
                Server:OnProcessCheckout(source, 3000, "Achat d'une caisse (SneakyLife - Race)", function()

                    local boxId = 1;
                    local lists, result = GenerateLootbox(source, boxId, box3[boxId])
                    local giveReward = {
                        ["SneakyCoins"] = function(_s, license, player)
                            local before, after = result:match("([^_]+)_([^_]+)")
                            local quantity = tonumber(after)
                            if (identifier['fivem']) then
                                local _, fivemid = identifier['fivem']:match("([^:]+):([^:]+)")
                                LiteMySQL:Insert('tebex_players_wallet', {
                                    identifiers = fivemid,
                                    transaction = "Gain dans la boîte SneakyCoins",
                                    price = '0',
                                    currency = 'Points',
                                    points = quantity,
                                });
                            end
                        end,
                        ["weapon"] = function(_s, license, player)
                            xPlayer.addWeapon(result, 150)
                        end,
                        ["money"] = function(_s, license, player)
                            local before, after = result:match("([^_]+)_([^_]+)")
                            local quantity = tonumber(after)
                            player.addAccountMoney('bank', quantity)
                        end,
                        ["vehicle"] = function(_s, license, player)
                            local plate = CreateRandomPlateText()
                            LiteMySQL:Insert('owned_vehicles', {
                                owner = xPlayer.identifier,
                                plate = plate,
                                model = result,
                                props = '{"fuelLevel":100.0}',
                                parked = 1,
                                label = "",
                                donated = 1,
                                garage_private = 0
                            })
                            LiteMySQL:Insert('open_car', {
                                owner = xPlayer.identifier,
                                plate = plate,
                                NB = 1,
                                donated = 1
                            });
                        end,
                    }
                    local r = reward[result];
                    if (r ~= nil) then
                        if (giveReward[r.type]) then
                            giveReward[r.type](source, identifier['license'], xPlayer);
                        end
                    end
                    if (identifier['fivem']) then
                        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
                        LiteMySQL:Insert('tebex_players_wallet', {
                            identifiers = after,
                            transaction = r.message,
                            price = '0',
                            currency = 'Box',
                            points = 0,
                        });
                    end
                    SendLogs(15105570,"Boutique - Achat","**"..GetPlayerName(source).."** vient de gagner : ***"..result.."***\n **License** : "..xPlayer.identifier,"https://canary.discord.com/api/webhooks/851712677353095189/qIgZGkHBp0LoJFgkvCPn3qvk7Sage_mvF8zTso6E6hLpA3_N-832_6rOCoHjxjjDxZjy")
                    TriggerClientEvent('tebex:on-open-case', source, lists, result, r.message)
                    end, function()
                    xPlayer.showNotification("~r~Vous ne posséder pas les points nécessaires")
                end)
            end
        else
            print('[Error] Failed to retrieve ESX player')
        end
    else
        print('[Error] Failed to retrieve source')
    end
end)

ESX.RegisterServerCallback('tebex:retrieve-category', function(source, callback)
    local count, result = LiteMySQL:Select('tebex_boutique_category'):Where('is_enabled', '=', true):Get();
    if (result ~= nil) then
        callback(result)
    else
        print('[Error] retrieve category is nil')
        callback({ })
    end
end)

ESX.RegisterServerCallback('tebex:retrieve-items', function(source, callback, category)
    local count, result = LiteMySQL:Select('tebex_boutique'):Wheres({
        { column = 'is_enabled', operator = '=', value = true },
        { column = 'category', operator = '=', value = category },
    })                             :Get();
    if (result ~= nil) then
        callback(result)
    else
        print('[Error] retrieve category is nil')
        callback({ })
    end
end)

ESX.RegisterServerCallback('tebex:retrieve-history', function(source, callback)
    local identifier = Server:GetIdentifiers(source);
    if (identifier['fivem']) then
        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
        local count, result = LiteMySQL:Select('tebex_players_wallet'):Where('identifiers', '=', after):Get();
        if (result ~= nil) then
            callback(result)
        else
            print('[Error] retrieve category is nil')
            callback({ })
        end
    end
end)

ESX.RegisterServerCallback('tebex:retrieve-points', function(source, callback)

    local identifier = Server:GetIdentifiers(source);
    if (identifier['fivem']) then
        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")

        MySQL.Async.fetchAll("SELECT SUM(points) FROM tebex_players_wallet WHERE identifiers = @identifiers", {
            ['@identifiers'] = after
        }, function(result)
            if (result[1]["SUM(points)"] ~= nil) then
                callback(result[1]["SUM(points)"])
            else
                print('[Info] retrieve points nil')
                callback(0)
            end
        end);
    else
        callback(0)
    end

end)

AddEventHandler('playerSpawned', function()
    local source = source;
    local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer) then
        local fivem = Server:GetIdentifiers(source)['fivem'];
        if (fivem) then
            local license = Server:GetIdentifiers(source)['license'];
            if (license) then
                TriggerClientEvent("esx:showNotification",source,'~g~Vous pouvez faire des achats dans notre boutique pour nous soutenir. Votre compte FiveM attaché à votre jeux a été mis à jour.')
            end
        else
            TriggerClientEvent("esx:showNotification",source,'~r~Vous n\'avez pas d\'identifiant FiveM associé à votre compte, reliez votre profil à partir de votre jeux pour recevoir vos achats potentiel sur notre boutique.')
        end
    end 
end)

ESX.RegisterServerCallback('tebex:retrieve-id', function(source, callback)
    local source = source;
    local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer) then
        local identifier = Server:GetIdentifiers(source);
        if (identifier['fivem']) then
            local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
            if after ~= nil then
                local license = identifier['license']
                if (license) then
                    callback(after)
                else
                    callback(0)
                end
            else
                callback(0)
            end
        else
            callback(0)
        end
    end 
end)

RegisterCommand("fivemid", function(source)
    local source = source;
    local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer) then
        local fivem = Server:GetIdentifiers(source)['fivem'];
        if (fivem) then
            local license = Server:GetIdentifiers(source)['license'];
            if (license) then
				xPlayer.showNotification("Votre ID est : ~b~"..source)
                xPlayer.showNotification('Votre FiveM ID est : ~b~'..fivem)
            else
				xPlayer.showNotification("~r~Erreur~s~ vous n'avez pas d'identifiant")
            end
        else
            xPlayer.showNotification('~r~Vous n\'avez pas d\'identifiant FiveM associé à votre compte, reliez votre profil à partir de votre jeux pour recevoir vos achats potentiel sur notre boutique.')
        end
    else
        print('[Error] ESX Get players form ID not found.')
    end 
end)


RegisterCommand("givecoins", function(source, args) 
    if source ~= 0 then return end
    local id = args[1]
    local coins = args[2]
    if id then
        local tPlayer = ESX.GetPlayerFromId(id)
        if tPlayer then
            local _, fivemid = Server:GetIdentifiers(id)['fivem']:match("([^:]+):([^:]+)")
            if (fivemid) then
                local license = Server:GetIdentifiers(id)['license'];
                if (license) then
                    tPlayer.showNotification('Chargement de la requête...')
                    if tonumber(coins) then
                        LiteMySQL:Insert('tebex_players_wallet', {
                            identifiers = fivemid,
                            transaction = "Give point(s) : "..coins,
                            price = '0',
                            currency = 'Points',
                            points = coins,
                        }, function()
                            print("Coins envoyé à "..tPlayer.getName().." !")
                        end);    
                        tPlayer.showNotification('Coins reçu : ~b~'..coins)                  
                    end
                end
            end
        end
    end
end) 

RegisterNetEvent("sCore:deletecoins")
AddEventHandler("sCore:deletecoins", function(vehicle, price, name)
    local xPlayer = ESX.GetPlayerFromId(source)
    local plate = CreateRandomPlateText()
    Server:OnProcessCheckout(source, price, string.format("Achat package %s", name), function()
        local plate = CreateRandomPlateText()
        LiteMySQL:Insert('owned_vehicles', {
            owner = xPlayer.identifier,
            plate = plate,
            model = vehicle,
            props = '{"fuelLevel":100.0}',
            parked = 1,
            label = name,
            donated = 1,
            garage_private = 0
        })
        LiteMySQL:Insert('open_car', {
            owner = xPlayer.identifier,
            plate = plate,
            NB = 1,
            donated = 1
        });
    end, function()
        xPlayer.showNotification("~r~Vous ne posséder pas les points nécessaires")
        return
    end)
    SendLogs(15105570,"Boutique - Achat","**"..GetPlayerName(source).."** vient d'acheter' : ***"..name.."*** pour ***"..price.."***\n **License** : "..xPlayer.identifier,"https://canary.discord.com/api/webhooks/851712677353095189/qIgZGkHBp0LoJFgkvCPn3qvk7Sage_mvF8zTso6E6hLpA3_N-832_6rOCoHjxjjDxZjy")
    --SunriseLogs('https://discord.com/api/webhooks/862647433863626782/02a1fO8VCvtaGzzQM6Y_TS2BeFH-szbx1rffC0R-Q9CCctuXRag0Lfdr8mg4eZu7IWvn', "Boutique - Achat","**"..GetPlayerName(source).."** vient d'acheter une ***"..LERESULTAT3FDP.."***\n**License** : "..xPlayer.identifier.. '\nPrix de l\'achat : ['..LERESULTAT2FDP..'] SeaCoins', 56108)
end)