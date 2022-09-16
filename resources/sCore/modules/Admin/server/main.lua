ESX, players, items = nil, {}, {}

TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)
inService = {}
reportsTable = {}
reportsCount = 0

MySQL.ready(function()
    MySQL.Async.fetchAll("SELECT * FROM items", {}, function(result)
        for k, v in pairs(result) do
            items[k] = { label = v.label, name = v.name }
        end
    end)
end)

function GetTime()
    local date = os.date('*t')
    if date.day < 10 then date.day = '0' .. tostring(date.day) end
    if date.month < 10 then date.month = '0' .. tostring(date.month) end
    if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
    if date.min < 10 then date.min = '0' .. tostring(date.min) end
    if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
    local date = date.day .. "/" .. date.month .. "/" .. date.year .. " - " .. date.hour .. " heures " .. date.min .. " minutes " .. date.sec .. " secondes"
    return date
end

function SendLogs(Color, Title, Description,webhook)
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
		 username = "SneakyLife - Logs", 
		 embeds = {{
			  ["color"] = Color, 
			  ["author"] = {
				["name"] = "SneakyLife - Logs"
			  },
			  ["title"] = Title,
			  ["description"] = "".. Description .."",
			  ["footer"] = {
				   ["text"] = GetTime(),
				   ["icon_url"] = "https://media.discordapp.net/attachments/801565673733226496/839538608348069888/logosneaky.png?width=77&height=77",
			  },
		 }}, 
		 avatar_url = "https://media.discordapp.net/attachments/801565673733226496/839538608348069888/logosneaky.png?width=77&height=77"
	}), { 
		 ['Content-Type'] = 'application/json' 
	})
end

function SendMessage(source, message)
	if source ~= 0 then
		TriggerClientEvent('chat:addMessage', source, { args = {'^1Administration^0 : ', message} })
	else
		print(('^1Administration^0 : %s'):format(message))
	end
end

local SpectateActive = {
    onService = {}
}

RegisterNetEvent("SneakyLife:ChangeStateSpectate")
AddEventHandler("SneakyLife:ChangeStateSpectate",function(state)
    local source = source
    SpectateActive.onService[source] = state
end)

ESX.AddGroupCommand('goto', 'admin', function(source, args, user)
	local target = tonumber(args[1])

	if target and target > 0 then
		local sourceName = GetPlayerName(source)
		local targetName = GetPlayerName(target)

		if targetName then
			local plyPos = GetEntityCoords(GetPlayerPed(target))
			local namejoueur = GetPlayerName(source)
			TriggerClientEvent("SneakyAdmin:Teleport", source, "goto", plyPos.x, plyPos.y, plyPos.z)
			TriggerEvent("SneakyLog:Goto", target)
			SendMessage(source, "Vous vous êtes téléporté sur ^4".. namejoueur .."^0 !")
		else
			SendMessage(source, "ID incorrect")
		end
	else
		SendMessage(source, "ID incorrect")
	end
end, {help = "Téléporter sur un joueur", params = { {name = 'id'} }})

RegisterNetEvent("SneakyLife:RequestCoordsCam")
AddEventHandler("SneakyLife:RequestCoordsCam",function(coords)
    CamPosition = coords
end)

ESX.AddGroupCommand('bring', 'admin', function(source, args, user)
    local target = tonumber(args[1])

    if target and target > 0 then
        local sourceName = GetPlayerName(source)
        local targetName = GetPlayerName(target)

        if targetName then
            if not SpectateActive.onService[source] then
                local plyPos = GetEntityCoords(GetPlayerPed(source))
                local namejoueur = GetPlayerName(target)
                TriggerClientEvent("SneakyAdmin:Teleport", target, "bring", plyPos.x, plyPos.y, plyPos.z)
                TriggerEvent("SneakyLog:Bring", target)
                SendMessage(source, "Vous avez téléporté ^4".. namejoueur .."^0 sur vous !")
            else
                TriggerClientEvent("SneakyAdmin:RequestCoordsCamToServer", source)
				while CamPosition == nil do
                    Wait(50)
                end
				local ped = GetPlayerPed(target)
                SetEntityCoords(ped, CamPosition.x, CamPosition.y, CamPosition.z)
            end
        else
            SendMessage(source, "ID incorrect")
        end
    else
        SendMessage(source, "ID incorrect")
    end
end, {help = "Téléporter un joueur sur vous", params = { {name = 'id'}}})

ESX.AddGroupCommand('freeze', 'admin', function(source, args, user)
	local target = tonumber(args[1])

	if target and target > 0 then
		local sourceName = GetPlayerName(source)
		local targetName = GetPlayerName(target)

		if targetName then
			local namejoueur = GetPlayerName(target)
			TriggerClientEvent("SneakyLife:FreezePlayer", target)
			TriggerEvent("SneakyLog:Freeze", target)
			SendMessage(source, "Vous avez téléporté ^4".. namejoueur .."^0 sur vous !")
		else
			SendMessage(source, "ID incorrect")
		end
	else
		SendMessage(source, "ID incorrect")
	end
end, {help = "Freeze un joueur", params = { {name = 'id'}}})

RegisterNetEvent("Jojo:TeleportAdmin")
AddEventHandler("Jojo:TeleportAdmin",function(type, id)
	if source then
		local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer.getGroup() == 'user' then
			banPlayerAC(xPlayer.source, {
				name = "changestateuser",
				title = "Anticheat : téléportation",
				description = "Anticheat : téléportation"
			})
			return
		end
		local ttarget = ESX.GetPlayerFromId(id)
		if ttarget then
			if type == 'goto' then
				local plypos = GetEntityCoords(GetPlayerPed(id))
				local namejoueur = GetPlayerName(id)
				TriggerClientEvent("SneakyAdmin:Teleport", source, "goto", plypos.x, plypos.y, plypos.z)
				TriggerEvent("SneakyLog:Goto", source)
				if namejoueur ~= nil then
					SendMessage(source, "Vous vous êtes téléporté  sur ^4".. namejoueur .."^0 !")
				end
			elseif type == 'bring' then
				local plypos = GetEntityCoords(GetPlayerPed(source))
				local namejoueur = GetPlayerName(id)
				TriggerClientEvent("SneakyAdmin:Teleport", id, "bring", plypos.x, plypos.y, plypos.z)
				TriggerEvent("SneakyLog:Bring", id)
				if namejoueur ~= nil then
					SendMessage(source, "Vous avez téléporté ^4".. namejoueur .."^0 sur vous !")
				end
			elseif type == "freeze" then
				TriggerClientEvent("SneakyLife:FreezePlayer", id)
			end
		end
	end
end)

RegisterCommand("announce",function(source, args, rawCommand)
	if source == 0 then
		if args[3] then
			local announce = table.concat(args, " ")
			TriggerClientEvent("RageUI:DrawText", -1, {message = "Annonce : ~b~"..announce, time_display = 1000*15})
		else
			print("Not 3 arguments !")
		end  
	else
		local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer.getGroup() == "user" then return TriggerClientEvent("RageUI:Popup", xPlayer.source, {message = "~r~Vous n'avez pas la permission !"}) end
		if args[3] then
			local announce = table.concat(args, " ")
			TriggerClientEvent("RageUI:DrawText", -1, {message = "Annonce : ~b~"..announce, time_display = 1000*15})
		else
			TriggerClientEvent("RageUI:Popup", xPlayer.source, {message = "~r~Vous n'avez plus de 3 arguments !"})
		end
	end
end)

local wipeThePlayer = false 

local function wipePlayer(source, targetId)
	local _src = source
	if _src then
		local xPlayer = ESX.GetPlayerFromId(_src)
		if xPlayer then
			if xPlayer.getGroup() == "user" then 
				banPlayerAC(xPlayer.source, {
					name = "changestateuser",
					title = "Tentative de Wipe",
					description = "Tentative de Wipe"
				})
				return
			end
			local tPlayer = ESX.GetPlayerFromId(targetId)
			if tPlayer then
				SendLogs(3447003,"Administration - Wipe","**"..GetPlayerName(source).."** vient de wipe le joueur (Name : "..GetPlayerName(tPlayer.source)..") \n **License** : "..xPlayer.identifier,"https://canary.discord.com/api/webhooks/844391984617619520/3rPOLVl2ZyAEzJaN47Wg3aabibFaTMTEL85U5VYDPRoo6JSVXe6JF_wRMmZyrFKmlgLG")
				TriggerClientEvent("Sneakyesx:showNotification", source, "Vous avez ~o~wipe~s~ le joueur ~b~"..GetPlayerName(tPlayer.source).."~s~ !")
				DropPlayer(tPlayer.source, "\n\nVous vous êtes fais wipe !\nFais par "..xPlayer.getName())
				MySQL.Async.execute([[
					DELETE FROM open_car WHERE owner = @identifier AND donated = @donated;
					DELETE FROM owned_vehicles WHERE owner = @identifier AND donated = @donated;
					DELETE FROM phone_users_contacts WHERE identifier = @identifier;
					DELETE FROM playerstattoos WHERE identifier = @identifier;
					DELETE FROM players_clothesitem WHERE identifier = @identifier;
					DELETE FROM user_licenses WHERE owner = @identifier;
					DELETE FROM users WHERE identifier = @identifier;					
					]], {
						['@identifier'] = tPlayer.identifier,
						['@donated'] = 0
					}, 
				function(rowsChanged)
				end)
			end
		end
	end
end

ESX.AddGroupCommand('wipe', 'admin', function(source, args, user)
	wipePlayer(source, args[1])
end, {help = "wipe", params = { {name = 'id', help = "Veuillez saisir un ID d'un joueur"} }})

RegisterServerEvent("sAdmin:wipePlayer")
AddEventHandler("sAdmin:wipePlayer", function(targetId)
	local _src = source
    TriggerEvent("ratelimit", _src, "sAdmin:wipePlayer")
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getGroup() ~= "user" then
		wipePlayer(source, targetId)
	else
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Tentative de Wipe",
			description = "Tentative de Wipe"
		})
        return
	end
end)

local function wipeOffline(license, source)
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
		local tPlayer = ESX.GetPlayerFromIdentifier(license)
		if xPlayer.getGroup() == "user" then
			banPlayerAC(xPlayer.source, {
				name = "changestateuser",
				title = "Anticheat : wipe",
				description = "Anticheat : wipe"
			})
			return
		end
		if tPlayer ~= nil then
			wipePlayer(source, tPlayer.source)
		else
			SendLogs(3447003,"Administration - Wipe","**"..GetPlayerName(source).."** vient de wipe la license "..license.." !","https://canary.discord.com/api/webhooks/844391984617619520/3rPOLVl2ZyAEzJaN47Wg3aabibFaTMTEL85U5VYDPRoo6JSVXe6JF_wRMmZyrFKmlgLG")
			TriggerClientEvent("Sneakyesx:showNotification", source, "Vous avez ~o~wipe~s~ la license ~b~"..license.."~s~ !")

			MySQL.Async.execute([[
				DELETE FROM open_car WHERE owner = @identifier AND donated = @donated;
				DELETE FROM owned_vehicles WHERE owner = @identifier AND donated = @donated;
				DELETE FROM phone_users_contacts WHERE identifier = @identifier;
				DELETE FROM playerstattoos WHERE identifier = @identifier;
				DELETE FROM players_clothesitem WHERE identifier = @identifier;
				DELETE FROM user_licenses WHERE owner = @identifier;
				DELETE FROM users WHERE identifier = @identifier;					
			]], {
				['@identifier'] = license,
				['@donated'] = 0
			})
		end
	else
		local tPlayer = ESX.GetPlayerFromIdentifier(license)
		if tPlayer ~= nil then
			wipePlayer(source, tPlayer.source)
		else
			SendLogs(3447003,"Administration - Wipe","**Console** vient de wipe la license "..license.." !","https://canary.discord.com/api/webhooks/844391984617619520/3rPOLVl2ZyAEzJaN47Wg3aabibFaTMTEL85U5VYDPRoo6JSVXe6JF_wRMmZyrFKmlgLG")
			print("Vous avez ^3wipe^0 la license ^4"..license.."^0 !")
			MySQL.Async.execute([[
				DELETE FROM open_car WHERE owner = @identifier AND donated = @donated;
				DELETE FROM owned_vehicles WHERE owner = @identifier AND donated = @donated;
				DELETE FROM phone_users_contacts WHERE identifier = @identifier;
				DELETE FROM playerstattoos WHERE identifier = @identifier;
				DELETE FROM players_clothesitem WHERE identifier = @identifier;
				DELETE FROM user_licenses WHERE owner = @identifier;
				DELETE FROM users WHERE identifier = @identifier;					
			]], {
				['@identifier'] = license,
				['@donated'] = 0
			})	
		end
	end
end

ESX.AddGroupCommand('wipeoffline', 'admin', function(source, args, user)
	wipeOffline(args[1], source)
end, {help = "wipeoffline", params = { {name = 'license', help = "Veuillez saisir la license d'un joueur"} }})

ESX.AddGroupCommand('sc', 'admin', function(source, args, user)
	local message = table.concat(args, " ", 1)
	local players = ESX.GetPlayers()
	for i = 1, #players do
		local xPlayer = ESX.GetPlayerFromId(players[i])
		if xPlayer.getGroup() == "user" then return end
		TriggerClientEvent('chat:addMessage', -1, { args = {'Message ^4staff^0 ('..GetPlayerName(source)..') : ', message} })
	end
end, {help = "sc", params = { {name = 'msg', help = "Veuillez saisir un message pour envoyer au staff !"} }})

RegisterNetEvent("sAdmin:CheckGroup")
AddEventHandler("sAdmin:CheckGroup",function(group)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getGroup() == "user" then
		return
		banPlayerAC(xPlayer.source, {
			name = "changestateuser",
			title = "Changement de groupe : "..group,
			description = "Changement de groupe : "..group
		})
	end
end)

RegisterServerEvent('SneakyLife:AdminRevive')
AddEventHandler('SneakyLife:AdminRevive', function(target)
    TriggerEvent("ratelimit", source, "SneakyLife:AdminRevive")
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "user" then 
        banPlayerAC(xPlayer.source, {
            name = "changestateuser",
            title = "Anticheat : revive",
            description = "Anticheat : revive"
        })
        return
    end
	if target ~= -1 then
        TriggerClientEvent('SneakyLife:RevivePlayerStaff', target)
    end
end)

RegisterNetEvent("core:Message")
AddEventHandler("core:Message", function(id, type)
    TriggerEvent("ratelimit", source, "core:Message")
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "user" then 
        banPlayerAC(xPlayer.source, {
            name = "changestateuser",
            title = "Anticheat : message",
            description = "Anticheat : message"
        })
        return
    end
    sendToDiscord("SneakyLife RP", "[STAFF] Message à "..GetPlayerName(id).. " avec comme message : "..type, 47103, "https://discord.com/api/webhooks/807720138341220404/z4qtwdguTgglbkSWEMSrTXilma-udXQSnImZUE-mjOq8dVtGIRXeUo_w17jbd_URJWu6" )
	TriggerClientEvent("core:envoyer", id, GetPlayerName(source), type)
    SendMessage(source, "Message envoyé à "..GetPlayerName(id).." ! (^3"..type.."^0)")
end)

RegisterServerEvent('SneakyAdmin:setjob')
AddEventHandler('SneakyAdmin:setjob', function(id, job, grade)
    TriggerEvent("ratelimit", source, "SneakyAdmin:setjob")
    local xTarget = ESX.GetPlayerFromId(id)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == "user" then 
        banPlayerAC(xPlayer.source, {
            name = "changestateuser",
            title = "Anticheat : attribution d'un métier",
            description = "Anticheat : attribution d'un métier"
        })
        return
    end
    xTarget.setJob(job, grade)
    TriggerClientEvent('Sneakyesx:showNotification', xTarget.source, "Vous venez d'obtenir le métier : ~b~<C>"..job.."<C> ("..grade..")~s~")
end)

RegisterServerEvent('SneakyAdmin:setjob2')
AddEventHandler('SneakyAdmin:setjob2', function(id, job2, grade2)
    TriggerEvent("ratelimit", source, "SneakyAdmin:setjob2")
    local xTarget = ESX.GetPlayerFromId(id)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == "user" then 
        banPlayerAC(xPlayer.source, {
            name = "changestateuser",
            title = "Anticheat : attribution d'un groupe",
            description = "Anticheat : attribution d'un groupe"
        })
        return
    end
    xTarget.setJob2(job2, grade2)
    TriggerClientEvent('Sneakyesx:showNotification', xTarget.source, "Vous venez d'obtenir le groupe : ~b~<C>"..job2.."<C> ("..grade2..")~s~")
end)

RegisterServerEvent('SneakysMenu:GiveMoney')
AddEventHandler('SneakysMenu:GiveMoney', function(amount, idjoueur)
    TriggerEvent("ratelimit", source, "SneakysMenu:GiveMoney")
	local xTarget = ESX.GetPlayerFromId(idjoueur)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer.getGroup() == "user" then
        banPlayerAC(xPlayer.source, {
            name = "changestateuser",
            title = "Anticheat : give d'argent",
            description = "Anticheat : give d'argent"
        })
        return
    end
    xTarget.addAccountMoney('cash', amount)
end)

RegisterServerEvent('SneakysMenu:GiveBankMoney')
AddEventHandler('SneakysMenu:GiveBankMoney', function(amount, idjoueur)
    TriggerEvent("ratelimit", source, "SneakysMenu:GiveBankMoney")
    local xTarget = ESX.GetPlayerFromId(idjoueur)
	local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == "user" then
        banPlayerAC(xPlayer.source, {
            name = "changestateuser",
            title = "Anticheat : give d'argent banque",
            description = "Anticheat : give d'argent banque"
        })
        return
    end
	xTarget.addAccountMoney('bank', amount)
end)

RegisterServerEvent('SneakysMenu:GiveDirtyMoney')
AddEventHandler('SneakysMenu:GiveDirtyMoney', function(amount, idjoueur)
    TriggerEvent("ratelimit", source, "SneakysMenu:GiveDirtyMoney")
    local xTarget = ESX.GetPlayerFromId(idjoueur)
	local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == "user" then
        banPlayerAC(xPlayer.source, {
            name = "changestateuser",
            title = "Anticheat : give d'argent sale",
            description = "Anticheat : give d'argent sale"
        })
        return
    end
	xTarget.addAccountMoney('dirtycash', amount)
end)

ESX.RegisterServerCallback("SneakyGetHistoWarn",function(source,callback,param)
    local src = param
    local steam64 = GetPlayerIdentifiers(src)[1]

	local steam_name = GetPlayerName(src)
	local rockstar = nil
	local ipv4 = nil
    for _, foundID in ipairs(GetPlayerIdentifiers(src)) do
		if string.match(foundID, "license:") then
			rockstar = string.sub(foundID, 9)
		elseif string.match(foundID, "ip:") then
			ipv4 = string.sub(foundID, 4)
		elseif string.match(foundID, "steam:") then
			steam64 = foundID
		end
    end
    MySQL.Async.fetchAll('SELECT * FROM players_warns WHERE identifier=@identifier', {
        ["@identifier"] = steam64
    }, function(result)
        for i = 1 , #result , 1 do
            result[i].date = os.date("%d/%m/%Y à %X",result[i].date)

        end
        callback(result)
    end)
end)

ESX.RegisterServerCallback("SneakyGetHistoBan",function(source,callback,param)
    local src = param
    local steam64 = GetPlayerIdentifiers(src)[1]

	local steam_name = GetPlayerName(src)
	local rockstar = nil
	local ipv4 = nil
    for _, foundID in ipairs(GetPlayerIdentifiers(src)) do
		if string.match(foundID, "license:") then
			rockstar = string.sub(foundID, 9)
		elseif string.match(foundID, "ip:") then
			ipv4 = string.sub(foundID, 4)
		elseif string.match(foundID, "steam:") then
			steam64 = foundID
		end
    end
    MySQL.Async.fetchAll('SELECT * FROM players_banhistory WHERE identifier=@identifier', {
        ["@identifier"] = steam64
    }, function(result)
        for i = 1 , #result , 1 do
            result[i].date = os.date("%d/%m/%Y %X",result[i].date)
            result[i].unbandate = os.date("%d/%m/%Y %X",result[i].unbandate)
        end
        callback(result)
    end)
end)

RegisterServerEvent('SneakywarnPlayer')
AddEventHandler('SneakywarnPlayer', function(target, msg,time)
    TriggerEvent("ratelimit", source, "SneakywarnPlayer")
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "user" then
        banPlayerAC(xPlayer.source, {
            name = "changestateuser",
            title = "Anticheat : warn",
            description = "Anticheat : warn"
        })
        return
    end
    local now = os.time() 
    WarnPlayer(target,msg,source)
end)

RegisterServerEvent('sAdmin:deleteWarnPlayer')
AddEventHandler('sAdmin:deleteWarnPlayer', function(warning)
    TriggerEvent("ratelimit", source, "sAdmin:deleteWarnPlayer")
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "user" then
        banPlayerAC(xPlayer.source, {
            name = "changestateuser",
            title = "Anticheat :  delete warn",
            description = "Anticheat : delete warn"
        })
        return
    end
    MySQL.Async.fetchAll('SELECT * FROM players_warns WHERE id = @id', {
        ["@id"] = warning.id
    }, function(result)
        if result[1] then
            MySQL.Async.execute('DELETE FROM players_warns WHERE id = @id', {['@id'] = warning.id})
            TriggerClientEvent('Sneakyesx:showNotification', xPlayer.source, "Le warn pour avec comme raison ~c~"..warning.reason.."~s~ à bien été supprimé !")
        end
    end)
end)


function WarnPlayer(src,reason,_source)
    local steam64 = GetPlayerIdentifiers(src)[1]

	local steam_name = GetPlayerName(src)
	local rockstar = nil
	local ipv4 = nil
    for _, foundID in ipairs(GetPlayerIdentifiers(src)) do
		if string.match(foundID, "license:") then
			rockstar = string.sub(foundID, 9)
		elseif string.match(foundID, "ip:") then
			ipv4 = string.sub(foundID, 4)
		elseif string.match(foundID, "steam:") then
			steam64 = foundID
		end
    end


    MySQL.Async.execute(
        'INSERT INTO players_warns (identifier,date,reason,moderator) VALUES(@identifier,@date,@reason,@banfrom)',
        {
             ['@identifier']   = steam64,
             ['@unbandate'] = timestamp,
             ['@reason'] = reason,
             ['@banfrom'] = GetPlayerName(_source),
             ['@date'] = os.time() 
        }
    )
end

RegisterServerEvent("SneakyLog:StaffActivé")
AddEventHandler("SneakyLog:StaffActivé",function()
    local _src = source
    sendToDiscord("SneakyLife RP", "[STAFF] Activé", 47103, "https://discord.com/api/webhooks/807593443840098305/dLYAx2uqgF9FtNbAeMWJkoRkiJq2xvJSYSNdqjL_lsnYD8dwZlTWINlg6E1qsyMX47cG")
end)
RegisterServerEvent("SneakyLog:StaffDesactivé")
AddEventHandler("SneakyLog:StaffDesactivé",function()
    local _src = source
    sendToDiscord("SneakyLife RP", "[STAFF] Désactivé", 16711680, "https://discord.com/api/webhooks/807593443840098305/dLYAx2uqgF9FtNbAeMWJkoRkiJq2xvJSYSNdqjL_lsnYD8dwZlTWINlg6E1qsyMX47cG" )
end)

RegisterServerEvent("SneakyLog:Goto")
AddEventHandler("SneakyLog:Goto",function(IdSelected)
    local _src = source
    TriggerEvent("ratelimit", _src, "SneakyLog:Goto")
    local namestaff = GetPlayerName(source)
    if IdSelected == nil or namestaff == nil then return end
    sendToDiscord("SneakyLife RP", "[STAFF] Goto sur "..GetPlayerName(IdSelected), 47103, "https://discord.com/api/webhooks/807725937034395648/EyDJwUCBwT3ld73r1Eyp5uNy6n4-pSrMt5YuNvLeH7xkCBiGBUhoUIcHWe-JITSBiYVN")
end)

RegisterServerEvent("SneakyLog:Freeze")
AddEventHandler("SneakyLog:Freeze",function(IdSelected)
    local _src = source
    TriggerEvent("ratelimit", _src, "SneakyLog:Freeze")
    local namestaff = GetPlayerName(source)
    if IdSelected == nil or namestaff == nil then return end
    sendToDiscord("SneakyLife RP", "[STAFF] Freeze sur "..GetPlayerName(IdSelected), 47103, "https://canary.discord.com/api/webhooks/861459002834813002/5WghzjEd-oUGhQs-FWu1_-BzmSskUVzbyYthegg7n9FnE_Ezvix_OSIiDrJSIuc9g_-q")
end)

RegisterServerEvent("SneakyLife:Kick")
AddEventHandler("SneakyLife:Kick",function(target, reason)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    if xPlayer.getGroup() == "user" then 
        banPlayerAC(xPlayer.source, {
            name = "changestateuser",
            title = "Anticheat : kick",
            description = "Anticheat : kick"
        })
        return
    end
    kickPlayer(_src, target, reason)
end)

RegisterServerEvent("SneakyAdmin:Tpamoi")
AddEventHandler("SneakyAdmin:Tpamoi", function(Target, gx, gy, gz)
    local _src = source
    TriggerEvent("ratelimit", _src, "SneakyAdmin:Tpamoi")
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
    if playerGroup ~= "user" then
        TriggerClientEvent("SneakyAdmin:Teleport", "bring", Target, gx, gy, gz)
    else
        banPlayerAC(xPlayer.source, {
            name = "changestateuser",
            title = "Anticheat : bring",
            description = "Anticheat : bring"
        })
        return
    end
end)

RegisterServerEvent("SneakyLog:Bring")
AddEventHandler("SneakyLog:Bring",function(id)
    local _src = source
    TriggerEvent("ratelimit", _src, "SneakyLog:Bring")
    local namestaff = GetPlayerName(source)
    if id == nil or namestaff == nil then return end
    sendToDiscord("SneakyLife RP", "[STAFF] Bring du joueur "..GetPlayerName(id), 47103, "https://discord.com/api/webhooks/807741469888479303/bIFwcSSjzXN7tsx03-MowUIzu5SkRBfvXDt93_mySWoIlra8LmqtkaQRFWOkDc0D1Bnc")
end)

RegisterServerEvent("SneakyLog:Changerlejob")
AddEventHandler("SneakyLog:Changerlejob",function(IdSelected, job, k)
    local _src = source
    TriggerEvent("ratelimit", _src, "SneakyLog:Changerlejob")
    local namestaff = GetPlayerName(source)
    sendToDiscord("SneakyLife RP", "[STAFF] Setjob de "..GetPlayerName(IdSelected).. " en " ..job.. " avec comme grade :  " ..k.." "..namestaff, 47103, "https://discord.com/api/webhooks/807750376946139177/hzLcFbmIPy0ef2av9S_l6H00FKE2B0ibpRhMI9eYSrINWET5To9XKVOfyM0TwmiGxyU2")
end)

RegisterServerEvent("SneakyLog:Changerlegroup")
AddEventHandler("SneakyLog:Changerlegroup",function(IdSelected, job, k)
    local _src = source
    TriggerEvent("ratelimit", _src, "SneakyLog:Changerlegroup")
    local namestaff = GetPlayerName(source)
    sendToDiscord("SneakyLife RP", "[STAFF] Setgroup de "..GetPlayerName(IdSelected).. " en " ..job.. " avec comme grade :  " ..k.." "..namestaff, 47103, "https://discord.com/api/webhooks/807750761697378325/JBTI-WWpxZj4Z2EyOVY092XuvpaIc1q1jqCor9CIB6pQvleO6MVNJp2issk3vaeDtt0m")
end)

RegisterServerEvent("SneakyLog:Voirinventaire")
AddEventHandler("SneakyLog:Voirinventaire",function(IdSelected)
    local _src = source
    TriggerEvent("ratelimit", _src, "SneakyLog:Voirinventaire")
    local namestaff = GetPlayerName(source)
    if IdSelected == nil or namestaff == nil then return end
    sendToDiscord("SneakyLife RP", "[STAFF] À vu l'inventaire de "..GetPlayerName(IdSelected), 47103, "https://discord.com/api/webhooks/807752802754887731/hULDygHeBU3-yzW4ycIVmA7T-iv_RYdUNjsXCwLAonjcC5rAtuMy2ebEcvm1JukQSewC")
end)
RegisterServerEvent("SneakyLog:Givecash")
AddEventHandler("SneakyLog:Givecash",function(IdSelected,montant)
    local _src = source
    TriggerEvent("ratelimit", _src, "SneakyLog:Givecash")
    local namestaff = GetPlayerName(source)
    sendToDiscord("SneakyLife RP", "[STAFF] À donner de l'argent à "..GetPlayerName(IdSelected).." d'un montant de : "..montant, 47103, "https://discord.com/api/webhooks/807753410760671292/zG92NewGEWSpu4EvBudC-PCclKzAX3e_a0iRgNtdILDmfRrOXzM9bCb5lIQ3MMXGobF6")
end)
RegisterServerEvent("SneakyLog:Givebank")
AddEventHandler("SneakyLog:Givebank",function(IdSelected,montant)
    local _src = source
    TriggerEvent("ratelimit", _src, "SneakyLog:Givebank")
    local namestaff = GetPlayerName(source)
    sendToDiscord("SneakyLife RP", "[STAFF] À donner de l'argent en banque à "..GetPlayerName(IdSelected).." d'un montant de : "..montant, 47103, "https://discord.com/api/webhooks/807756120743215144/voUpQRkLF4zrdsnldhcU2iovBrY8IC-GUq-GLbITWfSGNCSI-WCdg45iDMrWkgEl_5CJ")
end)
RegisterServerEvent("SneakyLog:Givedirty")
AddEventHandler("SneakyLog:Givedirty",function(IdSelected,montant)
    local _src = source
    TriggerEvent("ratelimit", _src, "SneakyLog:Givedirty")
    local namestaff = GetPlayerName(source)
    sendToDiscord("SneakyLife RP", "[STAFF] À donner de l'argent sale à "..GetPlayerName(IdSelected).." d'un montant de : "..montant, 47103, "https://discord.com/api/webhooks/807756965500944465/P_snXwZhXG1cP5rU0Llg5G7e0kzlkyKXO2XFw146P4_abC3kLOKp2348S_rzC17LjJ0m")
end)
RegisterServerEvent("SneakyLog:Giveitem")
AddEventHandler("SneakyLog:Giveitem",function(IdSelected,nomitem,amount)
    local _src = source
    TriggerEvent("ratelimit", _src, "SneakyLog:Giveitem")
    sendToDiscord("SneakyLife RP", "[STAFF] À donner un item : "..nomitem.."("..amount..") à "..GetPlayerName(IdSelected), 47103, "https://discord.com/api/webhooks/807757885513531473/x3qiZlQA95i1ks_TMtkLgO8CCaT73o5LKQ7QqXsr5CPSsH5_X6DABB4u8jO5sHvb0O7x")
end)
RegisterServerEvent("SneakyLog:Avertissement")
AddEventHandler("SneakyLog:Avertissement",function(IdSelected,reason)
    local _src = source
    TriggerEvent("ratelimit", _src, "SneakyLog:Avertissement")
    sendToDiscord("SneakyLife RP", "[STAFF] À averti un joueur : "..GetPlayerName(IdSelected).." avec comme raison "..reason, 47103, "https://discord.com/api/webhooks/807763251756269598/lbm0JOCx7hQB41qi0MEOYYaACyC1pTClFVUBbGJD6ChziafLnHfTn2Z_4WyBrgjn6BOS")
end)

RegisterServerEvent("SneakyLog:ReportTake")
AddEventHandler("SneakyLog:ReportTake",function(index,id)
    local _src = source
    TriggerEvent("ratelimit", _src, "SneakyLog:ReportTake")
    local xTarget = ESX.GetPlayerFromId(id)
    TriggerClientEvent("SneakyReport:SendMsg", id)
    sendToDiscord("SneakyLife RP", "[STAFF] À prit le report n°"..index, 47103, "https://discord.com/api/webhooks/807789727885295687/MMQ2MvDKvtptbQQ4PJgsvUiumRCRQJzi5rkhxaMa3lVBo0T7sqFVuA2q6o2NyyfYosnc")
end)
function sendToDiscord(name, message, color, webhook)
    local name = GetPlayerName(source)

    local connect = {
          {
            ["color"] = color,
            ["footer"] = {
            ["text"] = "SneakyLife",
            ["icon_url"] = "https://media.discordapp.net/attachments/801134675274891294/807596988144287764/logo-discord.png",
            },
            ["fields"] = {
                {
                    ["name"] = "Pseudo",
                    ["value"] = name,
                    ["inline"] = true
                },
                {
                    ["name"] = "Infos",
                    ["value"] = message,
                    ["inline"] = true
                }
            },
          }
      }
    local DISCORD_WEBHOOK = webhook
    local DISCORD_NAME = "SneakyLife RP"
    local DISCORD_IMAGE = "https://media.discordapp.net/attachments/801134675274891294/807596988144287764/logo-discord.png"
    PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('Sneakysetgroup')
AddEventHandler('Sneakysetgroup', function(target, command, param)
    local _src = source
    TriggerEvent("ratelimit", _src, "Sneakysetgroup")
	local xPlayer, xPlayerTarget = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(target)
    if xPlayer.getGroup() == "user" then
        banPlayerAC(xPlayer.source, {
            name = "changestateuser",
            title = "Anticheat : set group",
            description = "Anticheat : set group"
        })
        return
    end
	if command == "group" then
		if xPlayerTarget == nil then
			TriggerClientEvent('chatMessage', xPlayer.source, 'SYSTEM', {255, 0, 0}, "Player not found")
		else
			ESX.GroupCanTarget(xPlayer.getGroup(), param, function(canTarget)
				if canTarget then
					xPlayerTarget.setGroup(param)
					TriggerClientEvent('chatMessage', xPlayer.source, "SYSTEME", {0, 0, 0}, "Group of ^2^*" .. xPlayerTarget.getName() .. "^r^0 has been set to ^2^*" .. param)
				else
					TriggerClientEvent('chatMessage', xPlayer.source, 'SYSTEME', {255, 0, 0}, "Invalid group or insufficient group.")
				end
			end)
		end
	end
end)

RegisterServerEvent('Sneakysetperms')
AddEventHandler('Sneakysetperms', function(target, command, param)
    local _src = source
    TriggerEvent("ratelimit", _src, "Sneakysetperms")
	local xPlayer, xPlayerTarget = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(target)
    if xPlayer.getGroup() == "user" then
        banPlayerAC(xPlayer.source, {
            name = "changestateuser",
            title = "Anticheat : set perms",
            description = "Anticheat : set perms"
        })
        return
    end
	if command == "level" then
		if xPlayerTarget == nil then
			TriggerClientEvent('chatMessage', xPlayer.source, 'SYSTEM', {255, 0, 0}, "Player not found")
		else
			param = tonumber(param)
			if param ~= nil and param >= 0 then
				if xPlayer.getLevel() >= param then
					xPlayerTarget.setLevel(param)
					TriggerClientEvent('chatMessage', xPlayer.source, "SYSTEME", {0, 0, 0}, "Permission level of ^2" .. xPlayerTarget.getName() .. "^0 has been set to ^2 " .. tostring(param))
				else
					TriggerClientEvent('chatMessage', xPlayer.source, 'SYSTEME', {255, 0, 0}, "Insufficient level.")
				end
			else
				TriggerClientEvent('chatMessage', xPlayer.source, 'SYSTEME', {255, 0, 0}, "Invalid level.")
			end
		end
	end
end)

RegisterCommand("setgroup", function(source, args)
    if source ~= 0 then return TriggerClientEvent("Sneakyesx:showNotification", source, "~r~Vous n'avez pas la permission d'effectuer cette commande !") end
    local id = args[1]
    if id then
        local target = ESX.GetPlayerFromId(id)
        if target then
            param = args[2]
			if param ~= nil then
                target.setGroup(param)
                TriggerClientEvent('chatMessage', target.source, "SYSTEME", {0, 0, 0}, "Group of ^2^*" .. target.getName() .. "^r^0 has been set to ^2^*" .. param)
            else
				TriggerClientEvent('chatMessage', target.source, 'SYSTEME', {255, 0, 0}, "Invalid level.")
			end
        end
    end
end) 

RegisterNetEvent("SneakyLife:ClearAreaFromObjects")
AddEventHandler("SneakyLife:ClearAreaFromObjects", function(coords, players)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "user" then
        banPlayerAC(xPlayer.source, {
            name = "changestateuser",
            title = "Anticheat : clear la map",
            description = "Anticheat : clear la map"
        })
        return
    end
    for k,v in pairs(players) do
        TriggerClientEvent("SneakyLife:ClearAreaFromObjects", v, coords)
    end
end)

RegisterNetEvent("DeleteEntityTable")
AddEventHandler("DeleteEntityTable", function(list)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "user" then
        banPlayerAC(xPlayer.source, {
            name = "changestateuser",
            title = "Anticheat : delete entity",
            description = "Anticheat : delete entity"
        })
        return
    end
    for k,v in pairs(list) do
        local entity = NetworkGetEntityFromNetworkId(v)
        Citizen.InvokeNative(`DELETE_ENTITY` & 0xFFFFFFFF, entity)
    end
end)

RegisterNetEvent("SneakyLife:Repair")
AddEventHandler("SneakyLife:Repair", function(veh, id)
    TriggerClientEvent("SneakyLife:Repair", id, veh)
end)

RegisterNetEvent("SneakyLife:RepairMoteur")
AddEventHandler("SneakyLife:RepairMoteur", function(veh, id)
    TriggerClientEvent("SneakyLife:RepairMoteur", id, veh)
end)

RegisterNetEvent("SneakyLife:RepairDeformations")
AddEventHandler("SneakyLife:RepairDeformations", function(veh, id)
    TriggerClientEvent("SneakyLife:RepairDeformations", id, veh)
end)

RegisterNetEvent("SneakyLife:Delete")
AddEventHandler("SneakyLife:Delete", function(veh, id)
    TriggerClientEvent("SneakyLife:Delete", id, veh)
end)

local function getLicense(source)
    if (source ~= nil) then
        local identifiers = {}
        local playerIdentifiers = GetPlayerIdentifiers(source)
        for _, v in pairs(playerIdentifiers) do
            local before, after = playerIdentifiers[_]:match("([^:]+):([^:]+)")
            identifiers[before] = playerIdentifiers
        end
        return identifiers
    end
end

local function isStaff(source)
    return players[source].rank ~= "user"
end

RegisterNetEvent("Sneaky:GiveItem")
AddEventHandler("Sneaky:GiveItem", function(target, itemName, qty)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "user" then
        banPlayerAC(xPlayer.source, {
            name = "changestateuser",
            title = "Anticheat : give item",
            description = "Anticheat : give item"
        })
        return
    end
    local xTarget = ESX.GetPlayerFromId(tonumber(target))
    if xTarget then
        xTarget.addInventoryItem(itemName, tonumber(qty))
    else
        TriggerClientEvent("Sneakyesx:showNotification", source, "~r~Ce joueur n'est plus connecté")
    end
end)


RegisterServerEvent('Sneakyesx:playerLoaded')
AddEventHandler('Sneakyesx:playerLoaded', function(source, xPlayer)
    local source = source
    if players[source] then
        return
    end
    local firstname = nil
    local lastname = nil
    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if result[1] ~= nil then
            firstnamedb = result[1].firstname
            lastnamedb = result[1].lastname
        else
            firstnamedb = "Aucun" 
            lastnamedb = "Aucun"
        end
    end)
    Wait(500)
    players[source] = {
        timePlayed = { 0, 0 },
        rank = xPlayer.getGroup(),
        name = GetPlayerName(source),
        license = xPlayer.identifier,
	    firstname = firstnamedb,
        lastname = lastnamedb,
        vip = exports.sCore:GetVIP(source)
    } 
   
    if players[source].rank ~= "user" then
        TriggerClientEvent("SneakyLife:cbItemsList", source, items)
        TriggerClientEvent("SneakyLife:ReportTable", source, reportsTable)
        TriggerClientEvent("SneakyLife:updatePlayers", source, players)
    end
end)

RegisterCommand("insert",function(source)
    TriggerEvent("Sneakyesx:playerLoaded",source, ESX.GetPlayerFromId(source))
end)

AddEventHandler("playerDropped", function(reason)
    local source = source
    players[source] = nil
    reportsTable[source] = nil
    updateReportsForStaff()
    local ip, guid = GetPlayerEP(source), GetPlayerGuid(source)
    os.execute("ipset del wlip " .. ip)
end)

RegisterNetEvent("SneakyLife:StaffState")
AddEventHandler("SneakyLife:StaffState", function(state, sneaky)
    local source = source
    local byState = {
        [true] = "[~b~Staff~s~]~n~~c~%s ~s~est désormais ~g~actif ~s~en mode staff.",
        [false] = "[~b~Staff~s~]~n~~c~%s ~s~a ~r~désactivé ~s~son mode staff."
    }
    if state then
        inService[source] = true
    else
        inService[source] = nil
    end
    if not sneaky then
        for k,player in pairs(players) do
            if player.rank ~= "user" and inService[k] ~= nil then
                TriggerClientEvent("Sneakyesx:showNotification", k, byState[state]:format(GetPlayerName(source)))
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(15000)
        for source, player in pairs(players) do
            if isStaff(source) then
                TriggerClientEvent("SneakyLife:updatePlayers", source, players)
                TriggerClientEvent("SneakyLife:ReportTable", source, reportsTable)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000 * 60)
        for k, v in pairs(players) do
            players[k].timePlayed[1] = players[k].timePlayed[1] + 1
            if players[k].timePlayed[1] > 60 then
                players[k].timePlayed[1] = 0
                players[k].timePlayed[2] = players[k].timePlayed[2] + 1
            end
        end
        for k, v in pairs(reportsTable) do
            reportsTable[k].timeElapsed[1] = reportsTable[k].timeElapsed[1] + 1
            if reportsTable[k].timeElapsed[1] > 60 then
                reportsTable[k].timeElapsed[1] = 0
                reportsTable[k].timeElapsed[2] = reportsTable[k].timeElapsed[2] + 1
            end
        end
    end
end)

RegisterCommand("report", function(source, args)
    if source == 0 then
        return
    end
    if reportsTable[source] ~= nil then
        TriggerClientEvent("Sneakyesx:showNotification", source, "~b~[Report]~s~~n~Vous avez déjà un report actif.")
        return
    end
    reportsCount = reportsCount + 1
    reportsTable[source] = { timeElapsed = {0,0}, uniqueId = reportsCount, id = source, name = GetPlayerName(source), reason = table.concat(args, " "), taken = false, createdAt = os.date('%c'), takenBy = nil }
    notifyActiveStaff("[~b~Report~s~]~n~Un nouveau report a été reçu. ID Unique: ~y~" .. reportsCount)
    TriggerClientEvent("Sneakyesx:showNotification", source, "[~b~Report~s~]~n~Votre report a été envoyé ! Vous serez informé quand il sera pris en charge et / ou cloturé.")
    updateReportsForStaff()
end, false)

RegisterNetEvent("SneakyLife:takeReport")
AddEventHandler("SneakyLife:takeReport", function(reportId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "user" then
        banPlayerAC(xPlayer.source, {
            name = "changestateuser",
            title = "Anticheat : take report",
            description = "Anticheat : take report"
        })
        return
    end
    if not reportsTable[reportId] then
        TriggerClientEvent("Sneakyesx:showNotification", source, "[~b~Report~s~]~n~Ce report n'est plus en attente de prise en charge.")
        return
    end
    reportsTable[reportId].takenBy = GetPlayerName(source)
    reportsTable[reportId].taken = true
    if players[reportId] ~= nil then
        TriggerClientEvent("Sneakyesx:showNotification", reportId, "[~b~Report~s~]~n~Votre report à été pris en charge par le staff ~c~"..GetPlayerName(source).."~s~.")
    end
    notifyActiveStaff("[~b~Report~s~]~n~Le staff ~c~"..GetPlayerName(source).."~s~ a pris en charge le report ~y~n°"..reportsTable[reportId].uniqueId)
    exports.sCore:SendLogs(1752220,"Report pris",""..GetPlayerName(source).." vient de prendre le report : **"..reportsTable[reportId].uniqueId.."** \n License : "..xPlayer.identifier,"https://discord.com/api/webhooks/878621626596470814/N_C1jeKBBaUj250LSIEeQGnKXYlc5J5MCCLXyrlGX-wJqxf0NDczad25DDpPls-nW6GK")
    updateReportsForStaff()
end)

RegisterNetEvent("SneakyLife:CloseReport")
AddEventHandler("SneakyLife:CloseReport", function(reportId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "user" then
        banPlayerAC(xPlayer.source, {
            name = "changestateuser",
            title = "Anticheat : close report",
            description = "Anticheat : close report"
        })
        return
    end
    if not reportsTable[reportId] then
        TriggerClientEvent("Sneakyesx:showNotification", source, "[~b~Report~s~]~n~Ce report n'est plus valide.")
        return
    end
    if players[reportId] ~= nil then
        TriggerClientEvent("Sneakyesx:showNotification", reportId, "[~b~Report~s~]~n~Votre report à été cloturé. N'hésitez pas à nous recontacter en cas de besoin.")
    end
    notifyActiveStaff("[~b~Report~s~]~n~Le staff ~c~"..GetPlayerName(source).."~s~ à cloturé~s~ le report ~y~n°"..reportsTable[reportId].uniqueId)
    reportsTable[reportId] = nil
    updateReportsForStaff()
end)

function updateReportsForStaff()
    for k, player in pairs(players) do
        if player.rank ~= "user" then
            TriggerClientEvent("SneakyLife:ReportTable", k, reportsTable)
        end
    end
end

function notifyActiveStaff(message)
    for k, player in pairs(players) do
        if player.rank ~= "user" then
            if inService[k] ~= nil then
                TriggerClientEvent("Sneakyesx:showNotification", k, message)
            end
        end
    end
end

RegisterNetEvent("Sneakygetinformation")
AddEventHandler("Sneakygetinformation", function(playerid,index)
    local xPlayer = ESX.GetPlayerFromId(source)
    local tPlayer = ESX.GetPlayerFromId(playerid)
    if xPlayer.getGroup() == "user" then return end
    if index == 1 then
        informations = tPlayer.identifier
    elseif index == 2 then
        informations = tPlayer.getAccount("cash").money
    elseif index == 3 then
        informations = tPlayer.getAccount("dirtycash").money
    elseif index == 4 then
        informations = tPlayer.getAccount("bank").money
    elseif index == 5 then
        informations = tPlayer.job.label
    elseif index == 6 then
        informations = tPlayer.job2.label
    elseif index == 7 then
        informations = "Indefini"
    end
    TriggerClientEvent("sAdmin:transmiteinformation",source, index, informations)
end)


RegisterCommand('sc', function(source,args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= "user" then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.getGroup() ~= ' user' then
            local xPlayers = ESX.GetPlayers()
            for i=1, #xPlayers, 1 do
                local xPlayers = ESX.GetPlayerFromId(xPlayers[i])
                if xPlayers.getGroup() ~= 'user' then
                    TriggerClientEvent('chatMessage', xPlayers.source, "^5Staff ^0", {255, 0, 0}, "^5" .. GetPlayerName(source) .." ("..source..") ^0| " .. table.concat(args, " "))
                end
            end
        end
    end
end)

RegisterCommand("pedfor",function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "gs" or xPlayer.getGroup() == "_dev" then
        local id = args[1]
        local modelped = args[2]
        if id ~= -1 then
            TriggerClientEvent("sCore:TransformPed",id,modelped)
        end
    end
end)

RegisterCommand("resetped",function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "gs" or xPlayer.getGroup() == "_dev" then
        local id = args[1]
        if id ~= -1 then
            TriggerClientEvent("sCore:ResetPed",id)
        end
    end
end)

RegisterNetEvent('SneakyLife:CreateNewItem')
AddEventHandler('SneakyLife:CreateNewItem', function(src, name, label, weight)
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.getGroup() == '_dev' then
        if ESX.Items[name] then
            xPlayer.showNotification("~r~L'item existe déjà.")
        else
            ESX.Items[name] = {
                label = label,
                weight = tonumber(weight),
                rare = 0,
                canRemove = 1
            }
            MySQL.Async.execute("INSERT INTO `items` (`name`, `label`, `weight`) VALUES (@name, @label, @weight) ", {
                ['@name'] = name,
                ['@label'] = label,
                ['@weight'] = tonumber(weight)
            })
        end
    end
end)

RegisterCommand('createitem', function(source,args)
    TriggerEvent('SneakyLife:CreateNewItem', source, args[1], args[2], args[3])
end)