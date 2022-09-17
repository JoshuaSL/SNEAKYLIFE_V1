ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        player = ESX.GetPlayerData()
        Citizen.Wait(10)
    end
end)

local Test = {}
SneakyEvent = TriggerServerEvent
local filterArray = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" }
local filter = 1
Staff = {
    Active = false
}
local AdminInSpectateMode = false
local zonechecked = false
local gamertagschecked = false
local rpnames = false
local blipschecked = false
local function starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end
localReportsTable, reportCount, take = {},0,0
localPlayers, connecteds, staff, items = {},0,0, {}
selectedReport = nil

local function generateTakenBy(reportID)
    if localReportsTable[reportID].taken then
        return "~s~ | Pris par: ~o~" .. localReportsTable[reportID].takenBy
    else
        return ""
    end
end

RegisterNetEvent("SneakyLife:updatePlayers")
AddEventHandler("SneakyLife:updatePlayers", function(table)
    localPlayers = table
    local count, sCount = 0, 0
    for source, player in pairs(table) do
        count = count + 1
        if player.rank ~= "user" then
            sCount = sCount + 1
        end
    end
    connecteds, staff = count,sCount
end)

local ranksInfos = {
    [1] = { label = "Joueur", rank = "user" },
    [2] = { label = "Modérateur", rank = "admin" },
    [3] = { label = "Administrateur", rank = "superadmin" },
    [4] = { label = "Responsable", rank = "gs" },
    [4] = { label = "Fondateur", rank = "_dev" }
}

function getRankDisplay(rank)
    local ranks = {
        ["_dev"] = "~b~Fondateur~s~",
        ["gs"] = "~r~Responsable~s~",
        ["superadmin"] = "~o~Administrateur~s~",
        ["admin"] = "~y~Modérateur~s~",
    }
    return ranks[rank] or ""
end

RegisterNetEvent("SneakyLife:cbItemsList")
AddEventHandler("SneakyLife:cbItemsList", function(table)
    items = table
end)

local wList = {}
local bList = {}
local treport = {}
local isHudEnabled = false
local blipsstaffactive = false
local joueursblips = false
local hours = {"1 heure","2 heures","4 heures","5 heures","10 heures","24 heures","2 jours","1 semaine","Permanent"}
local group = {"Aucun","Modérateur","Administrateur","Responsable","Fondateur"}
local information = {"License","Argent","Argent sale","Argent en banque","Métier","Organisation","Crew"}
local perms = {"0","1","2","3","4"}
local hoursindex = 1
local groupindex = 1
local informationindex = 1
local permsindex = 1

local function EnumerateEntitiesAdmin(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateObjectsAdmin()
	return EnumerateEntitiesAdmin(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePedsAdmin()
	return EnumerateEntitiesAdmin(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehiclesAdmin()
	return EnumerateEntitiesAdmin(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

RegisterNetEvent("SneakyLife:ReportTable")
AddEventHandler("SneakyLife:ReportTable", function(table)
    reportCount = 0
    take = 0
    for source,report in pairs(table) do
        reportCount = reportCount + 1
        if report.taken then 
            take = take + 1 
        end
    end
    localReportsTable = table
end)

RegisterNetEvent("sAdmin:transmiteinformation")
AddEventHandler("sAdmin:transmiteinformation", function(index,informations)
    if index >= 2 and index <= 4 then
        ESX.ShowNotification("Informations : "..informations.."~g~$~s~.")
    else
        ESX.ShowNotification("Informations : ~b~"..informations.."~s~.")
    end
end)

local function colorByState(bool)
    if bool then
        return "~g~"
    else
        return "~s~"
    end
end
local function getIsTakenDisplay(bool)
    if bool then
        return "✅"
    else
        return "❌"
    end
end


function GetPlayersInScope()
	local players = {}
	local active = GetActivePlayers()
	for k,v in pairs(active) do
		table.insert(players, GetPlayerServerId(v))
	end
	return players
end

local labelSpect = "~g~Regarder~s~"
local spectState = false
local filterString = nil
function OpenTestRageUIMenu()

    if Test.Menu then 
        Test.Menu = false
        RageUI.Visible(RMenu:Get('staff', 'main'), false)
        return
    else
        RMenu.Add('staff', 'main', RageUI.CreateMenu("", "", 0, 0,"root_cause","sneakylife"))
        RMenu.Add('staff', 'stafflist', RageUI.CreateSubMenu(RMenu:Get("staff", "main"),"", "~b~Menu administration"))
        RMenu.Add('staff', 'playerslist', RageUI.CreateSubMenu(RMenu:Get("staff", "main"),"", "~b~Menu administration"))
        RMenu.Add('staff', 'playersaction', RageUI.CreateSubMenu(RMenu:Get("staff", "playerslist"),"", "~b~Menu administration"))
        RMenu.Add('staff', 'optionsplayer', RageUI.CreateSubMenu(RMenu:Get("staff", "playersaction"),"", "~b~Menu administration"))
        RMenu.Add('staff', 'joblist', RageUI.CreateSubMenu(RMenu:Get("staff", "optionsplayer"),"", "~b~Menu administration"))
        RMenu.Add('staff', 'grouplist', RageUI.CreateSubMenu(RMenu:Get("staff", "optionsplayer"),"", "~b~Menu administration"))
        RMenu.Add('staff', 'remboursement', RageUI.CreateSubMenu(RMenu:Get("staff", "optionsplayer"),"", "~b~Menu administration"))
        RMenu.Add('staff', 'itemlist', RageUI.CreateSubMenu(RMenu:Get("staff", "remboursement"),"", "~b~Menu administration"))
        RMenu.Add('staff', 'warnlist', RageUI.CreateSubMenu(RMenu:Get("staff", "playersaction"),"", "~b~Menu administration"))
        RMenu.Add('staff', 'banlist', RageUI.CreateSubMenu(RMenu:Get("staff", "playersaction"),"", "~b~Menu administration"))
        RMenu.Add('staff', 'vehiclemain', RageUI.CreateSubMenu(RMenu:Get("staff", "main"),"", "~b~Menu administration"))
        RMenu.Add('staff', 'diversmain', RageUI.CreateSubMenu(RMenu:Get("staff", "main"),"", "~b~Menu administration"))
        RMenu.Add('staff', 'reportsmain', RageUI.CreateSubMenu(RMenu:Get("staff", "main"),"", "~b~Menu administration"))
        RMenu.Add('staff', 'reportsaction', RageUI.CreateSubMenu(RMenu:Get("staff", "reportsmain"),"", "~b~Menu administration"))
        RMenu:Get('staff', 'main'):SetSubtitle("~b~Menu administration")
        RMenu:Get('staff', 'main').EnableMouse = false
        RMenu:Get('staff', 'main').Closed = function()
            filterstringstaff = ""
            Test.Menu = false
            TriggerServerEvent("SneakyLife:StaffState", false)
        end
        Test.Menu = true
        TriggerServerEvent("SneakyLife:StaffState", true) 
        RageUI.Visible(RMenu:Get('staff', 'main'), true)
        Citizen.CreateThread(function()
			while Test.Menu do
                RageUI.IsVisible(RMenu:Get('staff', 'main'), true, false, true, function()
                    RageUI.Button("Liste des joueurs", nil, {RightLabel = "→"}, true,function(h,a,s)
                    end,RMenu:Get("staff","playerslist"))
                    RageUI.Button("Liste des staffs", nil, {RightLabel = "→"}, true,function(h,a,s)
                    end,RMenu:Get("staff","stafflist"))
                    RageUI.Button("Liste des reports", nil, {RightLabel = "→"}, true,function(h,a,s)
                    end,RMenu:Get("staff","reportsmain"))
                    RageUI.Button("Action sur véhicules", nil, {RightLabel = "→"}, true,function(h,a,s)
                    end,RMenu:Get("staff","vehiclemain"))
                    RageUI.Button("Autre options", nil, {RightLabel = "→"}, true,function(h,a,s)
                    end,RMenu:Get("staff","diversmain"))
                end)
                RageUI.IsVisible(RMenu:Get('staff', 'reportsmain'), true, false, true, function()
                    RageUI.Checkbox(colorByState(hideTakenReports) .. "Afficher les reports non pris", nil, hideTakenReports, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                        hideTakenReports = Checked;
                    end, function()
                    end)
                    if not NamesRp then
                        for sender, infos in pairs(localReportsTable) do
                            if infos.taken then
                                if hideTakenReports == false then
                                    RageUI.Button(getIsTakenDisplay(infos.taken).." "..infos.id .." - "..infos.name,"~b~Pris en charge par :~s~ "..infos.takenBy.."~n~~b~Motif :~s~ "..infos.reason.."~n~~b~Date : ~s~"..infos.timeElapsed[2].."h"..infos.timeElapsed[1].."m", { RightLabel = "→" }, true, function(_, _, s)
                                        if s then
                                            selectedReport = sender
                                        end
                                    end,RMenu:Get("staff","reportsaction"))
                                end
                            else
                                RageUI.Button(getIsTakenDisplay(infos.taken).." "..infos.id.." - "..infos.name,"~b~Pris en charge par :~s~ Personne~n~~b~Motif :~s~ "..infos.reason.."~n~~b~Date : ~s~"..infos.timeElapsed[2].."h"..infos.timeElapsed[1].."m", { RightLabel = "→" }, true, function(_, _, s)
                                    if s then
                                        selectedReport = sender
                                    end
                                end,RMenu:Get("staff","reportsaction"))
                            end
                        end
                    else
                        for sender, infos in pairs(localReportsTable) do
                            if localPlayers[infos.id].firstname == nil then
                                localPlayers[infos.id].firstname = "Aucun"
                            elseif localPlayers[infos.id].lastname == nil then
                                localPlayers[infos.id].lastname = "Aucun"
                            end
                            local identityrp = localPlayers[infos.id].firstname.. " "..localPlayers[infos.id].lastname
                            if infos.taken then
                                if hideTakenReports == false then
                                    RageUI.Button(getIsTakenDisplay(infos.taken).." "..infos.id .." - "..identityrp,"~b~Pris en charge par :~s~ "..infos.takenBy.."~n~~b~Motif :~s~ "..infos.reason.."~n~~b~Date : ~s~"..infos.timeElapsed[2].."h"..infos.timeElapsed[1].."m", { RightLabel = "→" }, true, function(_, _, s)
                                        if s then
                                            selectedReport = sender
                                        end
                                    end,RMenu:Get("staff","reportsaction"))
                                end
                            else
                                RageUI.Button(getIsTakenDisplay(infos.taken).." "..infos.id.." - "..identityrp,"~b~Pris en charge par :~s~ Personne~n~~b~Motif :~s~ "..infos.reason.."~n~~b~Date : ~s~"..infos.timeElapsed[2].."h"..infos.timeElapsed[1].."m", { RightLabel = "→" }, true, function(_, _, s)
                                    if s then
                                        selectedReport = sender
                                    end
                                end,RMenu:Get("staff","reportsaction"))
                            end
                        end
                    end
                end)
                RageUI.IsVisible(RMenu:Get('staff', 'reportsaction'), true, false, true, function()
                    if localReportsTable[selectedReport] ~= nil then
                        local infos = localReportsTable[selectedReport]
                        if not localReportsTable[selectedReport].taken then
                            RageUI.Button("Prendre le ticket", nil, {}, true, function(_, _, s)
                                if s then
                                    TriggerServerEvent("SneakyLife:takeReport", selectedReport)
                                    SneakyEvent("Jojo:TeleportAdmin", 'goto', selectedReport)
                                end
                            end)
                        end
                        RageUI.Button("Envoyer un message", nil, {}, true, function(h, a, s)
                            if s then
                                local msg = KeyboardInputAdmin("Message", "", 100)
                
                                msg = tostring(msg)
                                if msg ~= nil and msg ~= '' and msg ~= 'nil' then
                                    SneakyEvent("core:Message", selectedReport, msg)
                                else
                                    ESX.ShowNotification("~r~Erreur\n~s~Merci d'écrire le message correctement")
                                end
                            end
                        end)
                        RageUI.Button('Revive le joueur' , nil, {},true, function(h, a, s)
                            if s then
                                SneakyEvent('SneakyLife:AdminRevive', selectedReport)
                            end
                        end)
                        RageUI.Button('Heal le joueur', nil, {},true, function(h, a, s)
                            if s then
                                ExecuteCommand("heal "..selectedReport)
                                ESX.ShowNotification("(~b~Staff~s~)\nVous venez de heal le joueur "..selectedReport)
                            end
                        end)
                        RageUI.Button('Goto', nil, {},true, function(h, a, s)
                            if s then
                                SneakyEvent("Jojo:TeleportAdmin", 'goto', selectedReport)
                            end
                        end)
                        RageUI.Button('Bring', nil, {},true, function(h, a, s)
                            if s then
                                SneakyEvent("Jojo:TeleportAdmin", 'bring', selectedReport)
                            end
                        end)
                        RageUI.Button("Clôturer le ticket", nil, {}, true, function(_, _, s)
                            if s then
                                TriggerServerEvent("SneakyLife:CloseReport", selectedReport)
                            end
                        end)
                    else
                        RageUI.Separator("")
                        RageUI.Separator("~c~Le ticket n'est plus valide !")
                        RageUI.Separator("")
                    end
                end)
                RageUI.IsVisible(RMenu:Get('staff', 'playerslist'), true, false, true, function()
                    if IsControlJustPressed(0, 22) then
                        filterstringstaff = Rechercher("entysearch", "~b~Rechercher", "", 50)
                    end
                    RageUI.Separator("Joueur(s) en ligne ~b~ " ..connecteds)
                    RageUI.Checkbox("Filtrer par zone", false, zonechecked, {Style = RageUI.CheckboxStyle.Tick}, function(Hovered, Active, Selected, Checked)
                        zonechecked = Checked
                        if Checked then
                            if Selected then
                                EnableZonePlayer = true
                            end
                        else
                            if Selected then
                                EnableZonePlayer = false
                            end
                        end
                    end)
                    if EnableZonePlayer then
                        if not NamesRp then
                            for k,v in pairs(GetActivePlayers()) do
                                RageUI.Button("("..GetPlayerServerId(v)..") - "..GetPlayerName(v), nil, {RightLabel = ""}, true, function(h,a,s)
                                    if s then
                                        IdSelected = GetPlayerServerId(v)
                                        NameSelected = GetPlayerName(v)
                                    end
                                end, RMenu:Get('staff', "playersaction"))
                            end
                        else
                            for k,v in pairs(GetActivePlayers()) do
                                local PlayerServerId, PlayerPed = GetPlayerServerId(v), GetPlayerPed(v)
                                if localPlayers[PlayerServerId].firstname == nil and localPlayers[PlayerServerId].lastname == nil then
                                    identityrp = "Aucun"
                                else
                                    identityrp = localPlayers[PlayerServerId].firstname.. " "..localPlayers[PlayerServerId].lastname
                                end
                                RageUI.Button("("..GetPlayerServerId(v)..") - "..identityrp, nil, {RightLabel = ""}, true, function(h,a,s)
                                    if s then
                                        IdSelected = GetPlayerServerId(v)
                                        NameSelected = identityrp
                                    end
                                end, RMenu:Get('staff', "playersaction"))
                            end
                        end
                    else
                        if not NamesRp then
                            for source, player in pairs(localPlayers) do
                                if filterstringstaff == nil or string.find(source, filterstringstaff) then
                                    if player.name == nil then
                                        player.name = "Invalide"
                                    end
                                    RageUI.Button("("..source..") - "..player.name, nil, { RightLabel = "" }, true , function(_, _, s)
                                        if s then
                                            IdSelected = source
                                            NameSelected = player.name
                                        end
                                    end, RMenu:Get('staff', "playersaction"))
                                end
                            end
                        else
                            for source, player in pairs(localPlayers) do
                                if player.firstname == nil then
                                    player.firstname = "Aucun"
                                elseif player.lastname == nil then
                                    player.lastname = "Aucun"
                                end
                                local identityrp = player.firstname.. " "..player.lastname
                                if filterstringstaff == nil or string.find(source, filterstringstaff) then
                                    RageUI.Button("("..source..") - "..identityrp, nil, { RightLabel = "" }, true , function(_, _, s)
                                        if s then
                                            IdSelected = source
                                            NameSelected = identityrp
                                        end
                                    end, RMenu:Get('staff', "playersaction"))
                                end
                            end
                        end
                    end
                end)
                local labelright = ""
                RageUI.IsVisible(RMenu:Get('staff', 'playersaction'), true, false, true, function()
                    RageUI.Button('~r~('..IdSelected..') - '..NameSelected, nil, {},true, function()
                    end)
                    RageUI.Button("Envoyer un message privé", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            local msg = KeyboardInputAdmin("Message", "", 100)
                            idjoueur = IdSelected
            
                            msg = tostring(msg)
                            if msg ~= nil and msg ~= '' and msg ~= 'nil' then
                                SneakyEvent("core:Message", idjoueur, msg)
                            else
                                ESX.ShowNotification("~r~Erreur\n~s~Merci d'écrire le message correctement")
                            end
                        end
                    end)
                    RageUI.Button('Se téléporter sur le joueur', nil, {},true, function(h, a, s)
                        if s then
                            SneakyEvent("Jojo:TeleportAdmin", 'goto', IdSelected)
                        end
                    end)
            
                    RageUI.Button("Téléporter le joueur sur vous", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            SneakyEvent("Jojo:TeleportAdmin", 'bring', IdSelected)
                        end
                    end)
                    RageUI.List("Informations", information, informationindex, nil, {}, true, function(Hovered, Active, Selected, Index) 
                        if (Selected) then 
                            local idjoueur = IdSelected
                            TriggerServerEvent('Sneakygetinformation', idjoueur, Index)
                        end 
                        informationindex = Index 
                    end)
                    RageUI.Button('Réanimer' , nil, {},true, function(h, a, s)
                        if s then
                            SneakyEvent('SneakyLife:AdminRevive', IdSelected)
                        end
                    end)
                    RageUI.Button("Avertissement", nil, { RightLabel = ""}, true, function(h,a,s)
                        if s then
                            local Reason = KeyboardInputAdmin("Raison", "", 100)
                            if Reason == "" or Reason == nil then
                                ESX.ShowNotification("~r~Valeurs invalide !")
                            else
                                local idjoueur = IdSelected
                                ESX.ShowNotification("~b~Sneakylife~s~\nVous venez de warn ~c~"..GetPlayerName(GetPlayerFromServerId(idjoueur)).."~s~ avec comme raison : ~y~"..Reason)
                                SneakyEvent("SneakywarnPlayer", idjoueur, Reason)
                                SneakyEvent("SneakyLog:Avertissement", idjoueur, Reason)
                            end
                        end
                    end)
                    RageUI.Button("Liste des avertissements", nil, { RightLabel = ""}, true, function(h,a,s)
                        if s then
                            local idjoueur = IdSelected
                            ESX.TriggerServerCallback('SneakyGetHistoWarn', function(warns)
                                wList = warns
                            end,idjoueur)
                        end
                    end, RMenu:Get("staff", "warnlist"))
                    RageUI.Button("Liste des bans", nil, { RightLabel = ""}, true, function(h,a,s)
                        if s then
                            local idjoueur = IdSelected
                            ESX.TriggerServerCallback('SneakyGetHistoBan', function(ban)
                                bList = ban
                            end,idjoueur)
                        end
                    end, RMenu:Get("staff", "banlist"))
                    RageUI.Button("Kick", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            local reason = KeyboardInputAdmin("~b~Raison :", "", 100)
                            idjoueur = IdSelected
            
                            reason = tostring(reason)
                            if reason ~= nil and reason ~= '' and reason ~= 'nil' then
                                SneakyEvent("SneakyLife:Kick", idjoueur, reason)
                            else
                                ESX.ShowNotification("~r~Erreur\n~s~Merci d'écrire la raison correctement")
                            end
                        end
                    end)
                    RageUI.Button('Freeze', nil, {},true, function(h, a, s)
                        if s then
                            SneakyEvent("Jojo:TeleportAdmin", 'freeze', IdSelected)
                        end
                    end)
                    RageUI.Button("Voir l'inventaire", nil, {RightLabel = ""}, true,function(h,a,s)
                        if s then
                            RageUI.CloseAll()
                            TriggerServerEvent("sStaff:OpenPlayerInventory",IdSelected)
                        end
                    end)
                    if (ESX.GetPlayerData()['group']) == "_dev" or (ESX.GetPlayerData()['group']) == "gs" or (ESX.GetPlayerData()['group']) == "superadmin" then
                        RageUI.Button('Screenshot', nil, {},true, function(h, a, s)
                            if s then
                                ExecuteCommand("screen "..IdSelected)
                            end
                        end)
                    end
                    RageUI.Button("~r~Options", nil, {RightLabel = ""}, true,function(h,a,s)
                        if s then
                        end
                    end,RMenu:Get("staff","optionsplayer"))
                end)
                RageUI.IsVisible(RMenu:Get('staff', 'optionsplayer'), true, false, true, function()
                    if (ESX.GetPlayerData()['group']) == "_dev" or (ESX.GetPlayerData()['group']) == "gs" or (ESX.GetPlayerData()['group']) == "superadmin" then
                        RageUI.Button("Changer le métier", nil, {RightLabel = ""}, true,function(h,a,s)
                            if s then
                            end
                        end,RMenu:Get("staff","joblist"))

                        RageUI.Button("Changer le groupe", nil, {RightLabel = ""}, true,function(h,a,s)
                            if s then
                            end
                        end,RMenu:Get("staff","grouplist"))
                    end
                    if (ESX.GetPlayerData()['group']) == "_dev" or (ESX.GetPlayerData()['group']) == "gs" or (ESX.GetPlayerData()['group']) == "superadmin" then
                        RageUI.Button("Remboursement", nil, {RightLabel = ""}, true,function(h,a,s)
                            if s then
                            end
                        end,RMenu:Get("staff","remboursement"))
                    end
                    RageUI.Button("Wipe", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            local message = KeyboardInputAdmin("Etes vous sûr? (oui/non)", "", 3)
                            if message == "oui" then
                                SneakyEvent("sAdmin:wipePlayer", IdSelected)
                            end
                        end
                    end)
                    if (ESX.GetPlayerData()['group']) == "_dev" or (ESX.GetPlayerData()["group"]) == "gs" then
                        RageUI.List("Changer le rang", group, groupindex, nil, {}, true, function(Hovered, Active, Selected, Index) 
                            if (Selected) then 
                                local idjoueur = IdSelected
                                if Index == 1 then 
                                    SneakyEvent('Sneakysetgroup', idjoueur, "group", "user")
                                elseif Index == 2 then
                                    SneakyEvent('Sneakysetgroup', idjoueur, "group", "admin")
                                elseif Index == 3 then
                                    SneakyEvent('Sneakysetgroup', idjoueur, "group", "superadmin")
                                elseif Index == 4 then
                                    SneakyEvent('Sneakysetgroup', idjoueur, "group", "gs")
                                elseif Index == 5 then
                                    if (ESX.GetPlayerData()['group']) == "_dev" then
                                        SneakyEvent('Sneakysetgroup', idjoueur, "group", "_dev")
                                    end
                                end 
                            end 
                            groupindex = Index 
                        end)
                        RageUI.List("Changer les permissions", perms, permsindex, nil, {}, true, function(Hovered, Active, Selected, Index) 
                            if (Selected) then 
                                local idjoueur = IdSelected
                                if Index == 1 then 
                                    SneakyEvent('Sneakysetperms', idjoueur, "level", "0")
                                elseif Index == 2 then
                                    SneakyEvent('Sneakysetperms', idjoueur, "level", "1")
                                elseif Index == 3 then
                                    SneakyEvent('Sneakysetperms', idjoueur, "level", "2")
                                elseif Index == 4 then
                                    SneakyEvent('Sneakysetperms', idjoueur, "level", "3")
                                elseif Index == 5 then
                                    SneakyEvent('Sneakysetperms', idjoueur, "level", "4")
                                end 
                            end 
                            permsindex = Index 
                        end)
                    end
                end)
                RageUI.IsVisible(RMenu:Get('staff', 'remboursement'), true, false, true, function()

                    RageUI.Button("Donner de l'argent", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            local amount = CustomAmount2()
                            local idjoueur = IdSelected
                            if amount ~= nil and amount > 0 then
                                SneakyEvent('SneakysMenu:GiveMoney', amount, idjoueur)
                                SneakyEvent("SneakyLog:Givecash", IdSelected, amount)
                            else
                                ESX.ShowNotification("~r~Erreur\n~s~Le montant est incorrect")
                            end
                        end
                    end)
            
                    RageUI.Button("Donner de l'argent en banque", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            local amount = CustomAmount2()
                            local idjoueur = IdSelected
                            if amount ~= nil and amount > 0 then
                                SneakyEvent('SneakysMenu:GiveBankMoney', amount, idjoueur)
                                SneakyEvent("SneakyLog:Givebank", IdSelected, amount)
                            else
                                ESX.ShowNotification("~r~Erreur\n~s~Le montant est incorrect")
                            end
                        end
                    end)
            
                    RageUI.Button("Donner de l'argent sale", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            local amount = CustomAmount2()
                            local idjoueur = IdSelected
                            if amount ~= nil and amount > 0 then
                                SneakyEvent('SneakysMenu:GiveDirtyMoney', amount, idjoueur)
                                SneakyEvent("SneakyLog:Givedirty", IdSelected, amount)
                            else
                                ESX.ShowNotification("~r~Erreur\n~s~Le montant est incorrect")
                            end
                        end
                    end)
            
                    RageUI.Button("Donner un item", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                    end, RMenu:Get("staff", "itemlist"))
                end)
                RageUI.IsVisible(RMenu:Get('staff', 'itemlist'), true, false, true, function()
                    RageUI.List("Filtre:", filterArray, filter, nil, {}, true, function(_, _, _, i)
                        filter = i
                    end)
                    RageUI.Separator("↓ ~c~Items disponibles ~s~↓")
                    for id, itemInfos in pairs(items) do
                        if starts(itemInfos.label:lower(), filterArray[filter]:lower()) then
                            RageUI.Button(itemInfos.label.." - ~c~"..itemInfos.name, nil, { RightLabel = "→" }, true, function(_, _, s)
                                if s then
                                    idjoueur = IdSelected
                                    local amount = CustomAmount2()
                                    if amount ~= nil and amount > 0 then
                                        TriggerServerEvent("Sneaky:GiveItem", idjoueur, itemInfos.name, amount)
                                    end
                                end
                            end)
                        end
                    end
                end)
                RageUI.IsVisible(RMenu:Get('staff', 'warnlist'), true, false, true, function()
                    if wList == nil or #wList == 0 then
                        RageUI.Button("(Vide)",nil,{RightLabel = ""},true,function()
                        end)
                    end
                    for i = 1, #wList, 1 do
                        local v = wList[i]
                        RageUI.Button("Raison : ~b~"..v.reason,"Par : ~y~".. v.moderator.."~s~ le "..v.date,{RightLabel = "~r~Supprimer~s~ →"},true,function(_, _, Selected)
                            if Selected then
                                if (ESX.GetPlayerData()['group']) == "_dev" then
                                    SneakyEvent("sAdmin:deleteWarnPlayer", v)
                                    RageUI.GoBack()
                                else
                                    ESX.ShowNotification("~r~Vous n'avez pas la permission de faire ça.")
                                end
                            end
                        end)
                    end
                end)
            
                RageUI.IsVisible(RMenu:Get('staff', 'banlist'), true, false, true, function()
                    if bList == nil or #bList == 0 then
                        RageUI.Button("(Vide)",nil,{RightLabel = ""},true,function()
                        end)
                    end
                    for i = 1, #bList, 1 do
                        local v = bList[i]
                        RageUI.Button("Raison : ~b~"..v.reason,"Par : ~y~".. v.moderator.."~s~ le "..v.date,{RightLabel = ""},true,function(_, _, Selected)
                        end)
                    end
                end)
                RageUI.IsVisible(RMenu:Get('staff', 'joblist'), true, false, true, function()
                    RageUI.Button("~y~Filtrer",nil,{RightLabel = "🔍"},true,function(_, _, Selected)
                        if Selected then
                            filterString = KeyboardInputAdmin("Filtre", nil, 25)
                        end
                    end)
                    for _,v in pairs(jobList) do
                        if filterString == nil or string.find(v.name, filterString) or string.find(_, filterString) then
                            for k,i in pairs(v.grade) do
                                RageUI.Button(v.name.." - ~c~["..k.."] "..i.label, nil, {RightLabel = ""}, true,function(h,a,s)
                                    if s then
                                        idjoueur = IdSelected
                                        ESX.ShowNotification("Vous avez séléctionné le job ~b~"..v.name.." ~s~avec le grade ~c~"..k)
                                        SneakyEvent("SneakyAdmin:setjob",idjoueur, v.name, k)
                                        SneakyEvent('SneakyLog:Changerlejob', IdSelected, v.name, k)
                                    end
                                end)
                            end
                        end
                    end
                end)
                RageUI.IsVisible(RMenu:Get('staff', 'grouplist'), true, false, true, function()
                    RageUI.Button("~y~Filtrer",nil,{RightLabel = "🔍"},true,function(_, _, Selected)
                        if Selected then
                            filterString = KeyboardInputAdmin("Filtre", nil, 25)
                        end
                    end)
                    for _,v in pairs(groupList) do
                        if filterString == nil or string.find(v.name, filterString) or string.find(_, filterString) then
                            for k,i in pairs(v.grade) do
                                RageUI.Button(v.name.." - ~c~["..k.."] "..i.label, nil, {RightLabel = ""}, true,function(h,a,s)
                                    if s then
                                        idjoueur = IdSelected
                                        ESX.ShowNotification("Vous avez séléctionné le groupe ~b~"..v.name.." ~s~avec le grade ~c~"..k)
                                        SneakyEvent("SneakyAdmin:setjob2",idjoueur, v.name, k)
                                        SneakyEvent('SneakyLog:Changerlegroup', IdSelected, v.name, k)
                                    end
                                end)
                            end
                        end
                    end
                end)
                RageUI.IsVisible(RMenu:Get('staff', 'stafflist'), true, false, true, function()
                    for source, player in pairs(localPlayers) do
                        if player.rank ~= "user" then
                            if player.name == nil then
                                player.name =  "Pseudo invalide"
                            end
                            RageUI.Button("(" .. source .. ") - "..player.name, nil, { RightLabel = "Rang : "..getRankDisplay(player.rank) }, true , function(_, _, s)
                            end)
                        end
                    end
                end)
                RageUI.IsVisible(RMenu:Get('staff', 'vehiclemain'), true, false, true, function()
                    RageUI.Button("Créer un véhicule", nil, {}, true, function(h,a,s)
                        if s then
                            local ModelName = KeyboardInputAdmin("Véhicule", "", 100)
                            local ped = GetPlayerPed(-1)
                            if ModelName and IsModelValid(ModelName) and IsModelAVehicle(ModelName) then
                                RequestModel(ModelName)
                                while not HasModelLoaded(ModelName) do
                                    Citizen.Wait(0)
                                end
                                    local ped = GetPlayerPed(-1)
                                    ESX.Game.SpawnVehicle(ModelName, GetOffsetFromEntityInWorldCoords(ped, 1.0, 0.0, 0.0), GetEntityHeading(GetPlayerPed(-1)), function(vehicle)
                                        TriggerEvent('persistent-vehicles/register-vehicle', vehicle)
                                    end)
                            else
                                ESX.ShowNotification("~b~Menu staff\n~s~Le nom du véhicule est incorrect ~b~¦")
                            end
                        end
                    end)

                    RageUI.Button("Réparer le moteur du véhicule", nil, {  }, true, function(h,a,s)
                        local pos = GetEntityCoords(PlayerPedId())
                        local veh, dst = ESX.Game.GetClosestVehicle({x = pos.x, y = pos.y, z = pos.z})
                        if a then 
                            pos = GetEntityCoords(veh)
                            DrawMarker(2, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 170, 0, 1, 2, 0, nil, nil, 0)
                        end
                        if s then
                            local veh = ESX.Game.GetClosestVehicle(GetEntityCoords(GetPlayerPed(-1)), nil)
                            local ServerID = GetPlayerServerId(NetworkGetEntityOwner(veh))
                            SneakyEvent("SneakyLife:RepairMoteur", VehToNet(veh), ServerID)
                        end
                    end)

                    RageUI.Button("Corriger les déformations du véhicule", nil, {  }, true, function(h,a,s)
                        local pos = GetEntityCoords(PlayerPedId())
                        local veh, dst = ESX.Game.GetClosestVehicle({x = pos.x, y = pos.y, z = pos.z})
                        if a then 
                            pos = GetEntityCoords(veh)
                            DrawMarker(2, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 170, 0, 1, 2, 0, nil, nil, 0)
                        end
                        if s then
                            local veh = ESX.Game.GetClosestVehicle(GetEntityCoords(GetPlayerPed(-1)), nil)
                            local ServerID = GetPlayerServerId(NetworkGetEntityOwner(veh))
                            SneakyEvent("SneakyLife:RepairDeformations", VehToNet(veh), ServerID)
                        end
                    end)

                    RageUI.Button("Réparer le véhicule entièrement", nil, {  }, true, function(h,a,s)
                        local pos = GetEntityCoords(PlayerPedId())
                        local veh, dst = ESX.Game.GetClosestVehicle({x = pos.x, y = pos.y, z = pos.z})
                        if a then 
                            pos = GetEntityCoords(veh)
                            DrawMarker(2, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 170, 0, 1, 2, 0, nil, nil, 0)
                        end
                        if s then
                            local veh = ESX.Game.GetClosestVehicle(GetEntityCoords(GetPlayerPed(-1)), nil)
                            local ServerID = GetPlayerServerId(NetworkGetEntityOwner(veh))
                            SneakyEvent("SneakyLife:Repair", VehToNet(veh), ServerID)
                        end
                    end)
            
            
                    RageUI.Button("Laver le véhicule", nil, {  }, true, function(h,a,s)
                        local pos = GetEntityCoords(PlayerPedId())
                        local veh, dst = ESX.Game.GetClosestVehicle({x = pos.x, y = pos.y, z = pos.z})
                        if a then 
                            pos = GetEntityCoords(veh)
                            DrawMarker(2, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 170, 0, 1, 2, 0, nil, nil, 0)
                        end
                        if s then
                            local co = GetEntityCoords(PlayerPedId())
                            local veh, dst = ESX.Game.GetClosestVehicle({x = co.x, y = co.y, z = co.z})
                            if veh ~= nil then 
                                SetVehicleDirtLevel(veh, 0)
                            end
                        end
                    end)

                    RageUI.Button("Supprimer le véhicule", nil, {  }, true, function(h,a,s)
                        local pos = GetEntityCoords(PlayerPedId())
                        local veh, dst = ESX.Game.GetClosestVehicle({x = pos.x, y = pos.y, z = pos.z})
                        if a then 
                            pos = GetEntityCoords(veh)
                            DrawMarker(2, pos.x, pos.y, pos.z+1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 170, 0, 1, 2, 0, nil, nil, 0)
                        end
                        if s then
                            local attempt = 0
                            local co = GetEntityCoords(PlayerPedId())
                            local veh, dst = ESX.Game.GetClosestVehicle({x = co.x, y = co.y, z = co.z})
                            while not NetworkHasControlOfEntity(veh) and attempt < 100 and DoesEntityExist(veh) do
                                NetworkRequestControlOfEntity(veh)
                                attempt = attempt + 1
                            end
            
                            if DoesEntityExist(veh) and NetworkHasControlOfEntity(veh) then
                                TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                                ESX.Game.DeleteVehicle(veh)
                                DeleteEntity(veh)
                            end
                        end
                    end)
                end)
                RageUI.IsVisible(RMenu:Get('staff', 'diversmain'), true, false, true, function()
                    RageUI.Checkbox("Afficher les gamertags", false, gamertagschecked, {Style = RageUI.CheckboxStyle.Tick}, function(Hovered, Active, Selected, Checked)
                        gamertagschecked = Checked
                        if Checked then
                            if Selected then
                                if rpnames then
                                    NamesRp = false
                                    showNamesRp(false)
                                    rpnames = false
                                end
                                NamesRp = false
                                showNames(true)
                            end
                        else
                            if Selected then
                                NamesRp = false
                                showNames(false)
                            end
                        end
                    end)
                    RageUI.Checkbox("Afficher les gamertags (identité)", false, rpnames, {Style = RageUI.CheckboxStyle.Tick}, function(Hovered, Active, Selected, Checked)
                        rpnames = Checked
                        if Checked then
                            if Selected then
                                if gamertagschecked then
                                    showNames(false)
                                    gamertagschecked = false
                                end
                                NamesRp = true
                                showNamesRp(true)
                            end
                        else
                            if Selected then
                                NamesRp = false
                                showNamesRp(false)
                            end
                        end
                    end)
                    RageUI.Checkbox("Afficher les blips", false, blipschecked, {Style = RageUI.CheckboxStyle.Tick}, function(Hovered, Active, Selected, Checked)
                        blipschecked = Checked
                        if Checked then
                            if Selected then
                                blipsstaffactive = true
                                joueursblips = true
                            end
                        else
                            if Selected then
                                blipsstaffactive = false
                                joueursblips = false
                            end
                        end
                    end)
                    RageUI.Button("Téléporter sur un point", nil, { RightLabel = "→" }, true, function(h,a,s)
                        if s then 
                            local waypointHandle = GetFirstBlipInfoId(8)

                            if DoesBlipExist(waypointHandle) then
                                Citizen.CreateThread(function()
                                    local waypointCoords = GetBlipInfoIdCoord(waypointHandle)
                                    local foundGround, zCoords, zPos = false, -500.0, 0.0

                                    while not foundGround do
                                        zCoords = zCoords + 10.0
                                        RequestCollisionAtCoord(waypointCoords.x, waypointCoords.y, zCoords)
                                        Citizen.Wait(0)
                                        foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords.x, waypointCoords.y, zCoords)

                                        if not foundGround and zCoords >= 2000.0 then
                                            foundGround = true
                                        end
                                    end
                                    plyPed = PlayerPedId()
                                    SetPedCoordsKeepVehicle(plyPed, waypointCoords.x, waypointCoords.y, zPos)
                                    ESX.ShowNotification('~b~<C>TP~s~ Effectuer<C>~s~.')
                                end)
                            else
                                ESX.ShowNotification('Aucun ~b~<C>marqueur !~s~<C>')
                            end
                        end
                    end)
                    RageUI.Button("Clear la zone", nil, { RightLabel = "→" }, true, function(h,a,s)
                        if s then 
                            local players = GetPlayersInScope()
                            SneakyEvent("SneakyLife:ClearAreaFromObjects",GetEntityCoords(PlayerPedId()), players)
                        end
                    end)
                    RageUI.Button("Clear les props de la zone", nil, { RightLabel = "→" }, true, function(_,_,s)
                        if s then
                            local props = {}
                            for v in EnumerateObjectsAdmin() do
                                if NetworkGetEntityIsNetworked(v) then
                                    table.insert(props, ObjToNet(v))
                                else
                                    DeleteEntity(v)
                                end
                            end
                            SneakyEvent("DeleteEntityTable",props)
                        end
                    end)
                    RageUI.Button("Clear les pnj de la zone", nil, { RightLabel = "→" }, true, function(_,_,s)
                        if s then
                            local props = {}
                            for v in EnumeratePedsAdmin() do
                                if not IsPedAPlayer(v) then
                                    if NetworkGetEntityIsNetworked(v) then
                                        table.insert(props, ObjToNet(v))
                                        if IsPedInAnyVehicle(v, false) then
                                            table.insert(props, ObjToNet(GetVehiclePedIsIn(v, false)))
                                        end
                                    else
                                        DeleteEntity(v)
                                    end
                                end
                            end
                            SneakyEvent("DeleteEntityTable",props)
                        end
                    end)
                end)
				Wait(0)
			end
		end)
	end
end

Citizen.CreateThread(function()
    while true do
        if blipsstaffactive then
            if (ESX.GetPlayerData()['group'] == "_dev") or (ESX.GetPlayerData()['group']) == "gs" or (ESX.GetPlayerData()['group'] == "superadmin") or (ESX.GetPlayerData()['group'] == "admin") then
                Wait(0)
                if joueursblips then
                    for _, player in pairs(GetActivePlayers()) do
                        local found = false
                        if player ~= PlayerId() then
                            local ped = GetPlayerPed(player)
                            local blip = GetBlipFromEntity( ped )
                            if not DoesBlipExist( blip ) then
                                blip = AddBlipForEntity(ped)
                                SetBlipCategory(blip, 7)
                                SetBlipScale( blip,  0.85 )
                                ShowHeadingIndicatorOnBlip(blip, true)
                                SetBlipSprite(blip, 1)
                                SetBlipColour(blip, 0)
                            end
                            
                            SetBlipNameToPlayerName(blip, player)
                            
                            local veh = GetVehiclePedIsIn(ped, false)
                            local blipSprite = GetBlipSprite(blip)
                            
                            if IsEntityDead(ped) then
                                if blipSprite ~= 303 then
                                    SetBlipSprite( blip, 303 )
                                    SetBlipColour(blip, 1)
                                    ShowHeadingIndicatorOnBlip( blip, false )
                                end
                            elseif veh ~= nil then
                                if IsPedInAnyBoat( ped ) then
                                    if blipSprite ~= 427 then
                                        SetBlipSprite( blip, 427 )
                                        SetBlipColour(blip, 0)
                                        ShowHeadingIndicatorOnBlip( blip, false )
                                    end
                                elseif IsPedInAnyHeli( ped ) then
                                    if blipSprite ~= 43 then
                                        SetBlipSprite( blip, 43 )
                                        SetBlipColour(blip, 0)
                                        ShowHeadingIndicatorOnBlip( blip, false )
                                    end
                                elseif IsPedInAnyPlane( ped ) then
                                    if blipSprite ~= 423 then
                                        SetBlipSprite( blip, 423 )
                                        SetBlipColour(blip, 0)
                                        ShowHeadingIndicatorOnBlip( blip, false )
                                    end
                                elseif IsPedInAnyPoliceVehicle( ped ) then
                                    if blipSprite ~= 137 then
                                        SetBlipSprite( blip, 137 )
                                        SetBlipColour(blip, 0)
                                        ShowHeadingIndicatorOnBlip( blip, false )
                                    end
                                elseif IsPedInAnySub( ped ) then
                                    if blipSprite ~= 308 then
                                        SetBlipSprite( blip, 308 )
                                        SetBlipColour(blip, 0)
                                        ShowHeadingIndicatorOnBlip( blip, false )
                                    end
                                elseif IsPedInAnyVehicle( ped ) then
                                    if blipSprite ~= 225 then
                                        SetBlipSprite( blip, 225 )
                                        SetBlipColour(blip, 0)
                                        ShowHeadingIndicatorOnBlip( blip, false )
                                    end
                                else
                                    if blipSprite ~= 1 then
                                        SetBlipSprite(blip, 1)
                                        SetBlipColour(blip, 0)
                                        ShowHeadingIndicatorOnBlip( blip, true )
                                    end
                                end
                            else
                                if blipSprite ~= 1 then
                                    SetBlipSprite( blip, 1 )
                                    SetBlipColour(blip, 0)
                                    ShowHeadingIndicatorOnBlip( blip, true )
                                end
                            end
                            if veh then
                                SetBlipRotation( blip, math.ceil( GetEntityHeading( veh ) ) )
                            else
                                SetBlipRotation( blip, math.ceil( GetEntityHeading( ped ) ) )
                            end
                        end
                    end
                else
                    for _, player in pairs(GetActivePlayers()) do
                        local blip = GetBlipFromEntity( GetPlayerPed(player) )
                        if blip ~= nil then
                            RemoveBlip(blip)
                        end
                    end
                end
            else
                Wait(3000)
            end
        else
            Wait(1500)
        end
    end
end)

Keys.Register('F10','F10', 'Menu Administrateur ', function()
    if not exports.inventaire:GetStateInventory() and not GetStateFishing() then
        if (ESX.GetPlayerData()['group'] == "_dev") or (ESX.GetPlayerData()['group']) == "gs" or (ESX.GetPlayerData()['group'] == "superadmin") or (ESX.GetPlayerData()['group'] == "admin") then
            TriggerServerEvent("sAdmin:CheckGroup",ESX.GetPlayerData()['group']) 
            OpenTestRageUIMenu()
        end
    end
end)

RegisterNetEvent("SneakyLife:ClearAreaFromObjects")
AddEventHandler("SneakyLife:ClearAreaFromObjects", function(coords)
    ClearAreaOfObjects(coords, 50.0, 0)
    ClearAreaOfEverything(coords,50.0,true,true,true,true)
    ClearArea(coords,50.0,true,true,true,false)
end)

RegisterNetEvent("core:envoyer")
AddEventHandler("core:envoyer", function(namestaff, msg)
	PlaySoundFrontend(-1, "CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
	ESX.ShowAdvancedNotification('Message Staff', '~b~Informations~s~ (~c~<C>'..namestaff..'~s~<C>)', msg, "CHAR_SNEAKY", 1)
end)

RegisterNetEvent("SneakyLife:Repair")
AddEventHandler("SneakyLife:Repair", function(net)
    local veh = NetworkGetEntityFromNetworkId(net)
    NetworkRequestControlOfEntity(veh)
    local timer = GetGameTimer()
    while not NetworkHasControlOfEntity(veh) and timer + 2000 > GetGameTimer() do
        Citizen.Wait(0)
    end
    SetVehicleFixed(veh)
    SetVehicleDeformationFixed(veh)
    SetVehicleEngineHealth(veh, 1000.0)
end)

RegisterNetEvent("SneakyLife:RepairMoteur")
AddEventHandler("SneakyLife:RepairMoteur", function(net)
    local veh = NetworkGetEntityFromNetworkId(net)
    NetworkRequestControlOfEntity(veh)
    local timer = GetGameTimer()
    while not NetworkHasControlOfEntity(veh) and timer + 2000 > GetGameTimer() do
        Citizen.Wait(0)
    end
    SetVehicleEngineHealth(veh, 1000.0)
end)

RegisterNetEvent("SneakyLife:RepairDeformations")
AddEventHandler("SneakyLife:RepairDeformations", function(net)
    local veh = NetworkGetEntityFromNetworkId(net)
    NetworkRequestControlOfEntity(veh)
    local timer = GetGameTimer()
    while not NetworkHasControlOfEntity(veh) and timer + 2000 > GetGameTimer() do
        Citizen.Wait(0)
    end
    SetVehicleDeformationFixed(veh)
end)

IsFrozen = false
RegisterNetEvent("SneakyLife:FreezePlayer")
AddEventHandler("SneakyLife:FreezePlayer", function()
    local pPed = PlayerPedId()
    if not IsFrozen then 
        FreezeEntityPosition(pPed, true)
        IsFrozen = true 
    elseif IsFrozen then 
        FreezeEntityPosition(pPed, false)
        IsFrozen = false
    end
end)

RegisterNetEvent("SneakyLife:Delete")
AddEventHandler("SneakyLife:Delete", function(net)
    local veh = NetworkGetEntityFromNetworkId(net)
    local attempt = 0
    local co = GetEntityCoords(PlayerPedId())
    local veh, dst = ESX.Game.GetClosestVehicle({x = co.x, y = co.y, z = co.z})
    while not NetworkHasControlOfEntity(veh) and attempt < 100 and DoesEntityExist(veh) do
        NetworkRequestControlOfEntity(veh)
        attempt = attempt + 1
    end

    if DoesEntityExist(veh) and NetworkHasControlOfEntity(veh) then
        TriggerEvent('persistent-vehicles/forget-vehicle', veh)
        ESX.Game.DeleteVehicle(veh)
        DeleteEntity(veh)
    end
end)


RegisterNetEvent("SneakyAdmin:Teleport")
AddEventHandler("SneakyAdmin:Teleport", function(type, px, py, pz)
    if type == "goto" then
        if not GetSpecateBoolStaff() then
            SetEntityCoords(PlayerPedId(), px, py, pz -1, 0.0, 0.0, 0.0, true)
        else
            SetCamCoord(Admin.Cam, px, py, pz)
        end
    elseif type == "bring" then
        SetEntityCoords(PlayerPedId(), px, py, pz -1, 0.0, 0.0, 0.0, true)
    end
end)

RegisterNetEvent("SneakyAdmin:TeleportSpectate")
AddEventHandler("SneakyAdmin:TeleportSpectate", function(coords)
    print(coords)
    local pos = 
    SetEntityCoords(PlayerPedId(), coords, -1, 0.0, 0.0, 0.0, true)
end)

RegisterNetEvent("SneakyAdmin:RequestCoordsCamToServer")
AddEventHandler("SneakyAdmin:RequestCoordsCamToServer", function()
    if GetSpecateBoolStaff() then
        local CamCoords = GetCamCoord(Admin.Cam)
        TriggerServerEvent("SneakyLife:RequestCoordsCam",CamCoords)
    end
end)

function Rechercher(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)

    while (UpdateOnscreenKeyboard() ~= 1) and (UpdateOnscreenKeyboard() ~= 2) do
        DisableAllControlActions(0)
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        return GetOnscreenKeyboardResult()
    else
        return nil
    end
end

function KeyboardInputAdmin(TextEntry, ExampleText, MaxStringLength)

	AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

function CustomAmount2()
    local montant = nil
    AddTextEntry("BANK_CUSTOM_AMOUNT", "Entrez le montant")
    DisplayOnscreenKeyboard(1, "BANK_CUSTOM_AMOUNT", '', "", '', '', '', 15)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        montant = GetOnscreenKeyboardResult()
        Citizen.Wait(1)
    else
        Citizen.Wait(1)
    end
    return tonumber(montant)
end

AddEventHandler("onResourceStop", function(name)
    if name == "sCore" then
        blipsstaffactive = false
        joueursblips = false
        for _, id in ipairs(GetActivePlayers()) do
            ped = GetPlayerPed(id)
            blip = GetBlipFromEntity(ped)
            if DoesBlipExist(blip) then
                RemoveBlip(blip)
            end
        end 
        SetEntityInvincible(PlayerPedId(), false)
        FreezeEntityPosition(PlayerPedId(), false)
        SetEntityCollision(PlayerPedId(), true, true)
        SetEntityVisible(PlayerPedId(), true, false)
        SetEveryoneIgnorePlayer(PlayerId(), false)
        SetPoliceIgnorePlayer(PlayerId(), false)
    end
end)

Admin = Admin or {}
Admin.PlyGroup = nil
Admin.tId = nil
Admin.Cam = nil 
Admin.InSpec = false
Admin.SpeedNoclip = 0.6
Admin.CamCalculate = nil
Admin.Timer = 0
Admin.Timer2 = 0
Admin.CamTarget = {}
Admin.GetGamerTag = {}
Admin.Menu = {}
Admin.Scalform = nil 
Admin.NameTarget = nil
Admin.NameBanned = nil 

Admin.Players = {}
Admin.Banned = {}
Admin.ListBanned = {}

Admin.DetailsScalform = {
    speed = {
        control = 178,
        label = "Vitesse du noclip"
    },
    spectateplayer = {
        control = 24,
        label = "Spectate le joueur"
    },
    gotopos = {
        control = 51,
        label = "Revenir ici"
    },
    sprint = {
        control = 21,
        label = "Rapide"
    },
    slow = {
        control = 36,
        label = "Lent"
    },
}

Admin.DetailsInSpec = {
    exit = {
        control = 45,
        label = "Sortir du mode"
    },
    openmenu = {
        control = 51,
        label = "Ouvrir le menu"
    },
}

-- Scalforms
function SetScaleformParams(scaleform, data) -- Set des éléments dans un scalform
	data = data or {}
	for k,v in pairs(data) do
		PushScaleformMovieFunction(scaleform, v.name)
		if v.param then
			for _,par in pairs(v.param) do
				if math.type(par) == "integer" then
					PushScaleformMovieFunctionParameterInt(par)
				elseif type(par) == "boolean" then
					PushScaleformMovieFunctionParameterBool(par)
				elseif math.type(par) == "float" then
					PushScaleformMovieFunctionParameterFloat(par)
				elseif type(par) == "string" then
					PushScaleformMovieFunctionParameterString(par)
				end
			end
		end
		if v.func then v.func() end
		PopScaleformMovieFunctionVoid()
	end
end
function CreateScaleform(name, data) -- Créer un scalform
	if not name or string.len(name) <= 0 then return end
	local scaleform = RequestScaleformMovie(name)

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end

	SetScaleformParams(scaleform, data)
	return scaleform
end

-- Active Scalform
function Admin:ActiveScalform(bool)
    local dataSlots = {
        {
            name = "CLEAR_ALL",
            param = {}
        }, 
        {
            name = "TOGGLE_MOUSE_BUTTONS",
            param = { 0 }
        },
        {
            name = "CREATE_CONTAINER",
            param = {}
        } 
    }
    local dataId = 0
    for k, v in pairs(bool and Admin.DetailsInSpec or Admin.DetailsScalform) do
        dataSlots[#dataSlots + 1] = {
            name = "SET_DATA_SLOT",
            param = {dataId, GetControlInstructionalButton(2, v.control, 0), v.label}
        }
        dataId = dataId + 1
    end
    dataSlots[#dataSlots + 1] = {
        name = "DRAW_INSTRUCTIONAL_BUTTONS",
        param = { -1 }
    }
    return dataSlots
end

function Admin:ControlInCam()
    local p10, p11 = IsControlPressed(1, 10), IsControlPressed(1, 11)
    local pSprint, pSlow = IsControlPressed(1, Admin.DetailsScalform.sprint.control), IsControlPressed(1, Admin.DetailsScalform.slow.control)
    if p10 or p11 then
        Admin.SpeedNoclip = math.max(0, math.min(100, round(Admin.SpeedNoclip + (p10 and 0.01 or -0.01), 2)))
    end
    if Admin.CamCalculate == nil then
        if pSprint then
            Admin.CamCalculate = Admin.SpeedNoclip * 2.0
        elseif pSlow then
            Admin.CamCalculate = Admin.SpeedNoclip * 0.1
        end
    elseif not pSprint and not pSlow then
        if Admin.CamCalculate ~= nil then
            Admin.CamCalculate = nil
        end
    end
    if IsControlJustPressed(0, Admin.DetailsScalform.speed.control) then
        DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", Admin.SpeedNoclip, "", "", "", 5)
        while UpdateOnscreenKeyboard() == 0 do
            Citizen.Wait(10)
            if UpdateOnscreenKeyboard() == 1 and GetOnscreenKeyboardResult() and string.len(GetOnscreenKeyboardResult()) >= 1 then
                Admin.SpeedNoclip = tonumber(GetOnscreenKeyboardResult()) or 1.0
                break
            end
        end
    end
end

-- Manage pos cam
function Admin:ManageCam()
    local p32, p33, p35, p34 = IsControlPressed(1, 32), IsControlPressed(1, 33), IsControlPressed(1, 35), IsControlPressed(1, 34)
    local g220, g221 = GetDisabledControlNormal(0, 220), GetDisabledControlNormal(0, 221)
    if g220 ~= 0.0 or g221 ~= 0.0 then
        local cRot = GetCamRot(Admin.Cam, 2)
        new_z = cRot.z + g220 * -1.0 * 10.0;
        new_x = cRot.x + g221 * -1.0 * 10.0
        SetCamRot(Admin.Cam, new_x, 0.0, new_z, 2)
        SetEntityHeading(PlayerPedId(), new_z)
    end
    if p32 or p33 or p35 or p34 then
        local rightVector, forwardVector, upVector = GetCamMatrix(Admin.Cam)
        local cPos = (GetCamCoord(Admin.Cam)) + ((p32 and forwardVector or p33 and -forwardVector or vector3(0.0, 0.0, 0.0)) + (p35 and rightVector or p34 and -rightVector or vector3(0.0, 0.0, 0.0))) * (Admin.CamCalculate ~= nil and Admin.CamCalculate or Admin.SpeedNoclip)
        SetCamCoord(Admin.Cam, cPos)
        SetEntityCoords(PlayerPedId(),cPos)
        SetFocusPosAndVel(cPos)
    end
end

-- Stop spectate
function Admin:ExitSpectate()
    local pPed = PlayerPedId()
    if DoesEntityExist(Admin.CamTarget.PedHandle) then
        SetCamCoord(Admin.Cam, GetEntityCoords(Admin.CamTarget.PedHandle))
    end
    NetworkSetInSpectatorMode(0, pPed)
    SetCamActive(Admin.Cam, true)
    RenderScriptCams(true, false, 0, true, true)
    Admin.CamTarget = {}
    SetScaleformParams(Admin.Scalform, Admin:ActiveScalform(false))
end

function Admin:ScalformSpectate()
    if IsControlJustPressed(0, Admin.DetailsInSpec.exit.control) then
        Admin:ExitSpectate()
    end
    if IsControlJustPressed(0, Admin.DetailsInSpec.openmenu.control) then
        Admin.tId = GetPlayerServerId(Admin.CamTarget.id)
        if Admin.tId and Admin.tId > 0 then
            OpenTestRageUIMenu()
        end
    end
    if GetGameTimer() > Admin.Timer then
        Admin.Timer = GetGameTimer() + 1000
        SetFocusPosAndVel(GetEntityCoords(GetPlayerPed(Admin.CamTarget.id)))
    end
end

function Admin:SpecAndPos()
    if not Admin.CamTarget.id and IsControlJustPressed(0, Admin.DetailsScalform.spectateplayer.control) then
        local qTable = {}
        local CamCoords = GetCamCoord(Admin.Cam)
        local pId = PlayerId()
        for k, v in pairs(GetActivePlayers()) do
            local vPed = GetPlayerPed(v)
            local vPos = GetEntityCoords(vPed)
            local vDist = GetDistanceBetweenCoords(vPos, CamCoords)
            if v ~= pId and vPed and vDist <= 20 and (not qTable.pos or GetDistanceBetweenCoords(qTable.pos, CamCoords) > vDist) then
                qTable = {
                    id = v,
                    pos = vPos
                }
            end
        end
        if qTable and qTable.id then
            Admin:StartSpectate(qTable)
        end
    end
    if IsControlJustPressed(1, Admin.DetailsScalform.gotopos.control) then
        local camActive = GetCamCoord(Admin.Cam)
        Admin:Spectate(camActive)
    end
end

-- Render Cam
function Admin:RenderCam()
    if not NetworkIsInSpectatorMode() then
        Admin:ControlInCam()
        Admin:ManageCam()
        Admin:SpecAndPos()
    else
        Admin:ScalformSpectate()
    end
    if Admin.Scalform then
        DrawScaleformMovieFullscreen(Admin.Scalform, 255, 255, 255, 255, 0)
    end
    if GetGameTimer() > Admin.Timer2 then
        Admin.Timer2 = GetGameTimer() + 15000
    end
end

-- Start spectate
function Admin:StartSpectate(player)
    Admin.CamTarget = player
    Admin.CamTarget.PedHandle = GetPlayerPed(player.id)
    if not DoesEntityExist(Admin.CamTarget.PedHandle) then
        ESX.ShowNotification("~r~Vous etes trop loin de la cible.")
        return
    end
    NetworkSetInSpectatorMode(1, Admin.CamTarget.PedHandle)
    SetCamActive(Admin.Cam, false)
    RenderScriptCams(false, false, 0, false, false)
    SetScaleformParams(Admin.Scalform, Admin:ActiveScalform(true))
    ClearFocus()
end

-- Create Cam
function Admin:CreateCam()
    Admin.Cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamActive(Admin.Cam, true)
    RenderScriptCams(true, false, 0, true, true)
    Admin.Scalform = CreateScaleform("INSTRUCTIONAL_BUTTONS", Admin:ActiveScalform())
end

-- Destroy Cam
function Admin:DestroyCam()
    DestroyCam(Admin.Cam)
    RenderScriptCams(false, false, 0, false, false)
    ClearFocus()
    SetScaleformMovieAsNoLongerNeeded(Admin.Scalform)
    if NetworkIsInSpectatorMode() then
        NetworkSetInSpectatorMode(false, Admin.CamTarget.id and GetPlayerPed(Admin.CamTarget.id) or 0)
    end
    Admin.Scalform = nil
    Admin.Cam = nil
    lockEntity = nil
    Admin.CamTarget = {}
end

function Admin:Spectate(pPos)
    local player = PlayerPedId()
    local pPed = player
    Admin.InSpec = not Admin.InSpec
    Wait(0)
    if not Admin.InSpec then
        TriggerServerEvent("SneakyLife:ChangeStateSpectate",false)
        AdminInSpectateMode = false
        Admin:DestroyCam()
        SetEntityVisible(pPed, true, true)
        SetEntityInvincible(pPed, false)
        SetEntityCollision(pPed, true, true)
        FreezeEntityPosition(pPed, false)
        if pPos then
            SetEntityCoords(pPed, pPos)
        end
    else
        AdminInSpectateMode = true
        Admin:CreateCam()
        TriggerServerEvent("SneakyLife:ChangeStateSpectate",true)
        SetEntityVisible(pPed, false, false)
        SetEntityInvincible(pPed, true)
        SetEntityCollision(pPed, false, false)
        FreezeEntityPosition(pPed, true)
        SetCamCoord(Admin.Cam, GetEntityCoords(player))
        CreateThread(function()
            while Admin.InSpec do
                Wait(0)
                Admin:RenderCam()
            end
        end)
        CreateThread(function()
            while AdminInSpectateMode do
                Wait(0)
                DrawMissionText("~b~Invincible",500)
            end
        end)
    end
end

function DrawMissionText(msg, time)
    ClearPrints()
    SetTextEntry_2('STRING')
    AddTextComponentString(msg)
    DrawSubtitleTimed(time, 1)
end

function onPlayerDropped(data)
    local datas = Admin.GetGamerTag[data]
    if datas then
        local tags = datas.tag
        RemoveMpGamerTag(tags)
        Admin.GetGamerTag[data] = nil
    end
    if Admin.CamTarget and Admin.CamTarget.id == data then
        Admin:ExitSpectate()
    end
end

RegisterKeyMapping("spectate", "Mode Spectate", "keyboard", "O")
RegisterCommand("spectate", function()
    if not exports.inventaire:GetStateInventory() and not GetStateFishing() then 
        if (ESX.GetPlayerData()['group'] == "_dev") or (ESX.GetPlayerData()["group"] == "gs") or (ESX.GetPlayerData()['group'] == "superadmin") or (ESX.GetPlayerData()['group'] == "admin") then
            Admin:Spectate()
        end
    end
end)

function GetSpecateBoolStaff()
    return AdminInSpectateMode
end

RegisterCommand("msg", function(source, args)
    local id = args[1]
    local msg = table.concat(args, ' ', 2)
    if msg ~= nil and msg ~= '' and msg ~= 'nil' then
        TriggerServerEvent("core:Message", id, msg)
    end
end)