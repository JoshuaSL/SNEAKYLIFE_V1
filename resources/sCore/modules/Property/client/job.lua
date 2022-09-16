ESX = nil

Citizen.CreateThread(function()
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
end)

RegisterNetEvent('Sneakyesx:playerLoaded')
AddEventHandler('Sneakyesx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)
RegisterNetEvent('Sneakyesx:setJob')
AddEventHandler('Sneakyesx:setJob', function(job)
    ESX.PlayerData.job = job
end)
local onService = false
-- Menu (Gérer les propriétés)

local announce = {
    list = {
        "Ouvert",
        "Fermer"
    },
    index = 1,
    type = ""
}

local function openManagementProperty()
    local mainMenu = RageUI.CreateMenu("", "Propriétés",0,0,"root_cause","shopui_title_dynasty8")

    local gestionProperties = RageUI.CreateSubMenu(mainMenu, "Propriétés", "Liste")
    local gestionGarages = RageUI.CreateSubMenu(mainMenu, "Garages", "Liste")

    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

    while mainMenu do
        Wait(1)
        
        RageUI.IsVisible(mainMenu, true, true, true, function()
            if onService then
                RageUI.Button("Stopper son ~r~service", nil, {RightLabel = "→"}, onService, function(h,a,s)
                    if s then
                        onService = false
                    end
                end)
                RageUI.List("Annonce", announce.list, announce.index, "~r~Information~s~ : faites '~b~ENTER~s~' pour passer l'annonce !", {}, true, function(h, a, s, i)
                    announce.index = i
                    if s then
                        announce.type = ""
                        if i == 1 then
                            announce.type = "open"
                        elseif i == 2 then
                            announce.type = "close"
                        end
                        TriggerServerEvent("sProperty:sendAnnounce", announce.type)
                    end
                end)
                RageUI.Button("Gérer les propriétés", nil, {RightLabel = "Voir →"}, true, function(h, a, s)
                end, gestionProperties)

                RageUI.Button("Gérer les garages", nil, {RightLabel = "Voir →"}, true, function(h, a, s)
                end, gestionGarages)
            else
                RageUI.Button("Prendre son ~g~service", nil, {RightLabel = "→"}, not onService, function(h,a,s)
                    if s then
                        onService = true
                    end
                end)
            end

        end)

        RageUI.IsVisible(gestionProperties, true, true, true, function()
            RageUI.Separator("↓ Liste des ~b~propriétés~s~ ↓")
            for k,v in pairs(listProperties) do
                local infos = v.info
                if v.ownerLicense ~= "none" then  
                    RageUI.Button(infos.name, "Modèle : ~o~"..infos.Selected.label.."~s~\nAppartenant à une personne : ~g~Oui~s~\nNom de la personne : "..v.ownerInfo, {RightLabel = "~r~Distituer~s~ →"}, true, function(h, a, s)
                        if s then
                            TriggerServerEvent("sProperty:distitueProperty", v.ownerLicense, v.propertyId)
                        end
                    end)
                else 
                    RageUI.Button(infos.name, "Modèle : ~o~"..infos.Selected.label.."~s~\nAppartenant à une personne : ~r~Non~s~", {RightLabel = "~g~Attribuer~s~ →"}, true, function(h, a, s)
                        if s then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestPlayer ~= -1 and closestDistance <= 3.0 then
                                TriggerServerEvent("sProperty:attributeProperty", GetPlayerServerId(closestPlayer), v.propertyId)
                            else
                                ESX.ShowNotification("~r~Erreur~s~~n~Personne à proximiter !")
                            end
                        end
                    end)
                end
            end
        end)

        RageUI.IsVisible(gestionGarages, true, true, true, function()
                RageUI.Separator("↓ Liste des ~o~garages~s~ ↓")
                for k,v in pairs(listGarages) do
                    local infos = v.info
                    if v.ownerLicense ~= "none" then  
                        RageUI.Button(infos.name, "Modèle : ~o~"..infos.Selected.label.."~s~\nAppartenant à une personne : ~g~Oui~s~\nNom de la personne : "..v.ownerInfo, {RightLabel = "~r~Distituer~s~ →"}, true, function(h, a, s)
                            if s then
                                TriggerServerEvent("sGarage:distitueGarage", v.ownerLicense, v.garageId)
                            end
                        end)
                    else 
                        RageUI.Button(infos.name, "Modèle : ~o~"..infos.Selected.label.."~s~\nAppartenant à une personne : ~r~Non~s~", {RightLabel = "~g~Attribuer~s~ →"}, true, function(h, a, s)
                            if s then
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                if closestPlayer ~= -1 and closestDistance <= 3.0 then
                                    TriggerServerEvent("sGarage:attributeGarage", GetPlayerServerId(closestPlayer), v.garageId)
                                else
                                    ESX.ShowNotification("~r~Erreur~s~~n~Personne à proximiter !")
                                end                                
                            end
                        end)
                    end
                end
        end)

        if not RageUI.Visible(mainMenu) and not RageUI.Visible(gestionProperties) and not RageUI.Visible(gestionGarages) then
            mainMenu = RMenu:DeleteType('menu', true)
        end

    end
end

-- Boucle

Citizen.CreateThread(function()

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

    while true do
        local myCoords = GetEntityCoords(PlayerPedId())
        local nofps = false
        local job = ESX.PlayerData.job.name == ConfigImmo.job

        if job then
            if #(myCoords-ConfigImmo.Pos.Interaction) < 1.5 then
                nofps = true
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour gérer ~b~l'entreprise~s~.")
                if IsControlJustReleased(0, 54) then
                    openManagementProperty()
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

local Dynasty8ActionMenu = {}
function OpenDynasty8ActionMenuRageUIMenu()

    if Dynasty8ActionMenu.Menu then 
        Dynasty8ActionMenu.Menu = false 
        RageUI.Visible(RMenu:Get('dynasty8', 'main'), false)
        return
    else
        RMenu.Add('dynasty8', 'main', RageUI.CreateMenu("", "", 0, 0,"root_cause","shopui_title_dynasty8"))
        RMenu:Get('dynasty8', 'main'):SetSubtitle("~y~Dynasty 8")
        RMenu:Get('dynasty8', 'main').EnableMouse = false
        RMenu:Get('dynasty8', 'main').Closed = function()
            Dynasty8ActionMenu.Menu = false
        end
        Dynasty8ActionMenu.Menu = true 
        RageUI.Visible(RMenu:Get('dynasty8', 'main'), true)
        Citizen.CreateThread(function()
			while Dynasty8ActionMenu.Menu do
                RageUI.IsVisible(RMenu:Get('dynasty8', 'main'), true, false, true, function()
                    RageUI.Button("Créer une propriétée", nil, {RightLabel = "Créer →"}, true, function(h, a, s)
                        if s then
                            TriggerEvent("sProperty:openCreateMenu")
                        end
                    end)
                    RageUI.Button("Créer un garage", nil, {RightLabel = "Créer →"}, true, function(h, a, s)
                        if s then
                            TriggerEvent("sGarage:openCreateMenu")
                        end
                    end)
                end)
			Wait(0)
			end
		end)
	end
end

function CheckServiceImmo()
    return onService
end