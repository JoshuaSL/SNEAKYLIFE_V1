ESX = nil

TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)


local TICK = {
    COMMANDS = 0,
    SHARE_ACCOUNTS = 0
}

local ACCOUNTS = {}

Account = {}
Account.__index = Account

setmetatable(Account, {
    __call = function(_, steam, fivem, vip, points)
        local self = setmetatable({}, Account)

        self.steam = steam
        self.fivem = fivem
        self.vip = vip
        self.points = tonumber(points)
        self.source = nil
        self.gameTimer = 0

        if ACCOUNTS[self.steam] ~= nil then
            print("attempt to replace existing account with id " .. tostring(steam))
        end
        ACCOUNTS[self.steam] = self

        return self
    end
})

Tebex = {}

Citizen.CreateThread(function()
    MySQL.Async.fetchAll('SELECT * FROM tebex_accounts', {}, function(result)
        if result[1] ~= nil then
            for _, data in pairs(result) do
                Account(data.steam, data.fivem, data.vip, data.expiration)
            end
        end
    end)
end)


function TebexSendWebhook(steam, message, transaction)
    xPlayer = ESX.GetPlayerFromId(source)
    SendLogs(15105570,"Boutique - Achat","**"..GetPlayerName(source).."** vient d'acheter une ***"..message.."*** avec comme transaction : ***"..transaction.."***\n **License** : "..xPlayer.identifier,"https://canary.discord.com/api/webhooks/851712677353095189/qIgZGkHBp0LoJFgkvCPn3qvk7Sage_mvF8zTso6E6hLpA3_N-832_6rOCoHjxjjDxZjy")
end

function Switch(condition, args)
    if type(args) == "table" then
        local fn = args[condition] or args["default"]
        if fn and type(fn) == "function" then fn() end
    end
end

function GetAllSourceIdentifiers(src)
    local steam, fivem = "0", "0"
    local ste, fiv = "license:", "fivem:"
    for _, v in pairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len(ste)) == ste then
            steam = string.sub(v, #ste + 1)
        end
        if string.sub(v, 1, string.len(fiv)) == fiv then
            fivem = string.sub(v, #fiv + 1)
        end
    end
    return steam, fivem
end

function Tebex:getAccountBySource(source)
    for _, account in pairs(ACCOUNTS) do
        if account.source == source then
            return account
        end
    end
    return nil
end

function Tebex:getAccountByFivem(fivem)
    for _, account in pairs(ACCOUNTS) do
        if account.fivem == fivem then
            return account
        end
    end
    return nil
end

RegisterNetEvent('Sneakyesx:playerLoaded')
AddEventHandler('Sneakyesx:playerLoaded', function(source)
    local src = source
    local steam, fivem = GetAllSourceIdentifiers(src)

    if ACCOUNTS[steam] == nil then
        local account = Account(steam, fivem, 0, 0)
        account.source = src
        account.gameTimer = GetGameTimer()
        MySQL.Async.execute('INSERT INTO tebex_accounts (steam, fivem) VALUES (@steam, @fivem)', {
            ['@steam'] = steam,
            ['@fivem'] = fivem,
        })
        return
    end
    local account = ACCOUNTS[steam]
    if account.gameTimer + 7500 > GetGameTimer() then return end
    account.gameTimer = GetGameTimer()
    account.source = src
    if (fivem ~= "0" and account.fivem == "0") then
        account.fivem = fivem
        MySQL.Async.execute('UPDATE tebex_accounts SET `fivem` = @fivem WHERE steam = @steam', {
            ['@steam'] = steam,
            ['@fivem'] = fivem,
        })
    end
    TriggerClientEvent('sVip:updateVip', source, account.vip)
    TriggerClientEvent('sVip:updatePoints', source, account.points)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2500)
        local timer = GetGameTimer()
        if TICK.COMMANDS + 14743 < timer then
            TICK.COMMANDS = timer + 1000000000
            Tebex:tickCommands()
        end
        if TICK.SHARE_ACCOUNTS + 23412 < timer then
            TICK.SHARE_ACCOUNTS = timer + 1000000000
            Tebex:tickShareAccounts()
        end
    end
end)

function Tebex:tickShareAccounts()
    local data = {}
    for _, account in pairs(ACCOUNTS) do
        if account.source ~= nil then
            data[account.source] = {
                vip = account.vip,
                points = account.points
            }
        end
    end
    TriggerEvent('sVip:shareAccounts', data)
    TriggerClientEvent('sVip:updatePlayersVip', -1, data)
    TICK.SHARE_ACCOUNTS = GetGameTimer()
end

function Tebex:tickCommands()
    MySQL.Async.fetchAll('SELECT * FROM tebex_commands', {}, function(result)
        if result[1] ~= nil then
            for _, data in pairs(result) do
                MySQL.Async.execute('DELETE FROM tebex_commands WHERE id = @id', {
                    ['@id']  = data.id,
                }, function(rowsChanged)
                    self:executeCommand(data)
                end)
            end
        end
    end)
    TICK.COMMANDS = GetGameTimer()
end

function Tebex:executeCommand(data)
    local id, fivem, command, argument, transaction = data.id, data.fivem, data.command, data.argument, data.transaction
    local account = self:getAccountByFivem(fivem)
    local steam, source, points = account.steam, account.source, account.points
    Citizen.CreateThread(function()
        Switch(command, {
            ['addVip'] = function()
                local rank = tonumber(argument)
                MySQL.Async.fetchAll('SELECT * FROM tebex_accounts WHERE steam = @steam',{
                    ['@steam'] = steam
                }, function(result)
                    print("Vip actuel".. json.encode(result))
                    if result[1].vip == 0 then
                        expiration = (31 * 86400)
                        expirationvip = expiration
                        if expirationvip < os.time() then
                            expirationvip = os.time() + expirationvip
                        end
                        print("Debug vip : 1")
                    else
                        expirationactual = result[1].expiration
                        expiration = (31 * 86400)
                        expirationvip = expirationactual + expiration
                        if expirationvip < os.time() then
                            expirationvip = os.time() + expirationvip
                        end
                        print("Debug vip : 2")
                    end
                end)
                while expirationvip == nil do
                    Wait(150)
                end
                print("Expiration de l'achat : "..expirationvip)
                MySQL.Async.execute('UPDATE tebex_accounts SET `vip` = @vip, `expiration` = @expiration WHERE steam = @steam', {
                    ['@vip'] = rank,
                    ['@steam'] = steam,
                    ['@expiration'] = expirationvip,
                }, function()
                    print("Expiration après bdd "..expirationvip)
                    account.vip = rank
                    if source ~= nil then
                        TriggerClientEvent('sVip:updateVip', source, rank)
                    end
                end)
                print("Debug vip : 3")
            end,
            ['removeVip'] = function()
                local rank = tonumber(argument)
                MySQL.Async.execute('UPDATE tebex_accounts SET `vip` = @vip, `expiration` = @expiration WHERE steam = @steam', {
                    ['@vip'] = 0,
                    ['@steam'] = steam,
                    ['@expiration'] = 0,
                }, function()
                    account.vip = 0
                    if source ~= nil then
                        TriggerClientEvent('sVip:updateVip', source, 0)
                    end
                end)
            end,
        })
    end)
end

ESX.RegisterServerCallback("sVip:getVip", function(source, cb)
    if source then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            local license, fivem = GetAllSourceIdentifiers(xPlayer.source)
            MySQL.Async.fetchAll('SELECT * FROM tebex_accounts WHERE steam = @steam',{
                ['@steam'] = license
            }, function(result)
                if result[1] then
                    cb(result[1].vip)
                end
            end)
        end
    end
end)

function GetVIP(source)
    if source then
        returnVip = nil
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            local license, fivem = GetAllSourceIdentifiers(xPlayer.source)
            MySQL.Async.fetchAll('SELECT * FROM tebex_accounts WHERE steam = @steam',{
                ['@steam'] = license
            }, function(result)
                if result[1] then
                    returnVip = result[1].vip
                end
            end)

            while returnVip == nil do
                Wait(150)
            end

            return returnVip
        end
    end
end

ESX.RegisterServerCallback('sVip:CheckTimeVip', function(source, cb, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local steam, fivem = GetAllSourceIdentifiers(source)
    MySQL.Async.fetchScalar('SELECT expiration FROM tebex_accounts WHERE steam = @steam', {
        ['@steam'] = steam
    }, function(result)
        if result then
            if tonumber(result) ~= 0 then
                if tonumber(result) <= os.time() then
                    TriggerEvent("sBoutique:RemoveVip",source)
                    cb(true)
                else
                    local tempsrestant = (((tonumber(result)) - os.time())/60)
                    local day        = (tempsrestant / 60) / 24
                    local hrs        = (day - math.floor(day)) * 24
                    local minutes    = (hrs - math.floor(hrs)) * 60
                    local txtday     = math.floor(day)
                    local txthrs     = math.floor(hrs)
                    local txtminutes = math.ceil(minutes)
                    TriggerClientEvent("sVip:NotifyVip", source, txtday, txthrs, txtminutes)
                    cb(false)
                end
            else
                TriggerClientEvent("Sneakyesx:showNotification", source, "~r~Vous ne possédez aucun VIP.")
            end
        end
    end)
end)

RegisterCommand('addVip', function(source, args)
    if source ~= 0 then return print("Not access !") end
    local online = false
    local fivem = args[1]
    local vipRank = tonumber(args[2])
    if vipRank == 0 then return end
    local transaction = args[3] 
    Citizen.CreateThread(function()
        MySQL.Async.execute('INSERT INTO tebex_commands (fivem, command, argument, transaction) VALUES (@fivem, @command, @argument, @transaction)', {
            ['@fivem'] = fivem,
            ['@command'] = 'addVip',
            ['@argument'] = vipRank,
            ['@transaction'] = transaction
        })
        MySQL.Async.execute('INSERT INTO tebex_logs_commands (fivem, command, argument, transaction) VALUES (@fivem, @command, @argument, @transaction)', {
            ['@fivem'] = fivem,
            ['@command'] = 'addVip', 
            ['@argument'] = vipRank,
            ['@transaction'] = transaction
        })
        if vipRank == 1 then vipLabel = "VIP ~y~Gold~s~." money = 15000 elseif vipRank == 2 then vipLabel = "VIP ~b~Diamond~s~." money = 30000 end
        local xPlayers   = ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local steamplayer, fivemPlayer = GetAllSourceIdentifiers(xPlayers[i])
            if fivem == fivemPlayer then
                local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "Vous avez reçu le "..vipLabel)
                exports.sCore:SendLogs(1752220,"Vip - Ajout",""..xPlayer.name.." vient de prendre son "..vipLabel.." \n License : "..xPlayer.identifier,"https://discord.com/api/webhooks/878621536062418944/P2kHniA9ViyjFV372uljvQssfn_99ziy6TSS0V_fuMNerScvwA0gFP-zlSOjd2kyfwef")
                TriggerClientEvent('sVip:updateVip', xPlayer.source, vipRank)
                xPlayer.addAccountMoney('bank', money)
                online = true
            else
                online = false
            end
        end  
        if not online then
            MySQL.Async.fetchAll('SELECT * FROM account_info WHERE fivem = @fivem',{
                ['@fivem'] = "fivem:"..fivem
            }, function(result)
                if result[1] then
                    print("Request to "..result[1].license.." for recompense vip !")
                    exports.sCore:SendLogs(1752220,"Vip - Ajout Offline",""..result[1].name.." vient de prendre son "..vipLabel.." \n License : "..result[1].license,"https://discord.com/api/webhooks/878621536062418944/P2kHniA9ViyjFV372uljvQssfn_99ziy6TSS0V_fuMNerScvwA0gFP-zlSOjd2kyfwef")
                    playerLicense = result[1].license
                    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',{
                        ['@identifier'] = playerLicense
                    }, function(result)
                        local formattedAccounts = json.decode(result[1].accounts) or {}
                        for k,v in pairs(formattedAccounts) do
                            if v.name == "bank" then
                                v.money = v.money+money
                            end
                        end
                        MySQL.Async.execute('UPDATE `users` SET `accounts` = @accounts WHERE `identifier` = @identifier',
                        {
                            ['@identifier'] = playerLicense,
                            ["@accounts"] = json.encode(formattedAccounts)
                        })
                    end)
                end
            end)
        end
    end)
end)

RegisterNetEvent("sBoutique:RemoveVip")
AddEventHandler("sBoutique:RemoveVip",function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local license, fivem = GetAllSourceIdentifiers(src)
    local vipRank = 2
    local transaction = "Expiration VIP"
    Citizen.CreateThread(function()
        MySQL.Async.execute('INSERT INTO tebex_commands (fivem, command, argument, transaction) VALUES (@fivem, @command, @argument, @transaction)', {
            ['@fivem'] = fivem,
            ['@command'] = 'removeVip',
            ['@argument'] = vipRank,
            ['@transaction'] = transaction
        })
        MySQL.Async.execute('INSERT INTO tebex_logs_commands (fivem, command, argument, transaction) VALUES (@fivem, @command, @argument, @transaction)', {
            ['@fivem'] = fivem,
            ['@command'] = 'removeVip',
            ['@argument'] = vipRank,
            ['@transaction'] = transaction
        })
        local xPlayers   = ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local licensePlayer, fivemPlayer = GetAllSourceIdentifiers(xPlayers[i])
            if fivem == fivemPlayer then
                local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "~r~Votre VIP à expiré !")
                TriggerClientEvent('sVip:updateVip', xPlayer.source, 0)
                exports.sCore:SendLogs(1752220,"Vip - Remove",""..xPlayer.name.." vient de perdre son VIP \n License : "..xPlayer.identifier,"https://discord.com/api/webhooks/878621536062418944/P2kHniA9ViyjFV372uljvQssfn_99ziy6TSS0V_fuMNerScvwA0gFP-zlSOjd2kyfwef")
            end
        end
    end)
    exports.sCore:SendLogs(1752220,"Vip - Remove",""..fivem.." vient de perdre son VIP : **"..vipRank.."**","https://discord.com/api/webhooks/878621536062418944/P2kHniA9ViyjFV372uljvQssfn_99ziy6TSS0V_fuMNerScvwA0gFP-zlSOjd2kyfwef")
end)

RegisterCommand('removeVip', function(source, args)
    if source ~= 0 then return print("Not access !") end
    local fivem = args[1]
    local vipRank = tonumber(args[2])
    local transaction = args[3]
    Citizen.CreateThread(function()
        MySQL.Async.execute('INSERT INTO tebex_commands (fivem, command, argument, transaction) VALUES (@fivem, @command, @argument, @transaction)', {
            ['@fivem'] = fivem,
            ['@command'] = 'removeVip',
            ['@argument'] = vipRank,
            ['@transaction'] = transaction
        })
        MySQL.Async.execute('INSERT INTO tebex_logs_commands (fivem, command, argument, transaction) VALUES (@fivem, @command, @argument, @transaction)', {
            ['@fivem'] = fivem,
            ['@command'] = 'removeVip',
            ['@argument'] = vipRank,
            ['@transaction'] = transaction
        })
        local xPlayers   = ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local steamplayer, fivemPlayer = GetAllSourceIdentifiers(xPlayers[i])
            if fivem == fivemPlayer then
                local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                TriggerClientEvent("Sneakyesx:showNotification", xPlayer.source, "~r~Votre VIP à expiré !")
                TriggerClientEvent('sVip:updateVip', xPlayer.source, 0)
                exports.sCore:SendLogs(1752220,"Vip - Remove",""..xPlayer.name.." vient de perdre son VIP \n License : "..xPlayer.identifier,"https://discord.com/api/webhooks/878621536062418944/P2kHniA9ViyjFV372uljvQssfn_99ziy6TSS0V_fuMNerScvwA0gFP-zlSOjd2kyfwef")
            end
        end
    end)
    exports.sCore:SendLogs(1752220,"Vip - Remove",""..fivem.." vient de perdre son VIP : **"..vipRank.."**","https://discord.com/api/webhooks/878621536062418944/P2kHniA9ViyjFV372uljvQssfn_99ziy6TSS0V_fuMNerScvwA0gFP-zlSOjd2kyfwef")
end)