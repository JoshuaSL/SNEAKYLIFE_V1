-- 
-- Created by Kadir#6400
-- 
ESX = nil
SneakyEvent = TriggerServerEvent
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('Sneakyesx:getSharedObject', function(obj)
            ESX = obj
        end)
        ESX.PlayerData = ESX.GetPlayerData()
        Citizen.Wait(10)
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

openedMenu = false

local chasseMenu = RageUI.CreateMenu("Grossiste", "", nil, nil,"root_cause","boucherie")
local itemsMenu = RageUI.CreateSubMenu(chasseMenu, "", "~r~Viande~s~", nil, nil)
local items2Menu = RageUI.CreateSubMenu(chasseMenu, "", "~b~Pêche~s~", nil, nil)
chasseMenu.Closed = function() FreezeEntityPosition(PlayerPedId(), false) openedMenu = false hasChasse = nil end

function openMenu(chasse)
    if openedMenu then
        openedMenu = false
        RageUI.Visible(chasseMenu, false)
        return
    else
        openedMenu = true
        chasseMenu:SetTitle("")
        chasseMenu:SetSpriteBanner("root_cause",'chasse')
        chasseMenu:SetSubtitle("~c~Chasse")
        hasChasse = nil
        RageUI.Visible(chasseMenu, true)
        FreezeEntityPosition(PlayerPedId(), true)
        Citizen.CreateThread(function()
            while openedMenu  and hasChasse == nil do
                Wait(250)
                ESX.TriggerServerCallback('sChasse:check', function(returnChasse)
                    hasChasse = returnChasse
                end, GetEntityCoords(PlayerPedId()))
            end
        end)
        Citizen.CreateThread(function()
            while ESX.GetPlayerData().job == nil do
                Citizen.Wait(10)
            end
            if ESX.IsPlayerLoaded() then
                ESX.PlayerData = ESX.GetPlayerData()
            end
            while openedMenu do
                Wait(1.0)
                RageUI.IsVisible(chasseMenu, true, false, true, function()
                    RageUI.Separator("~c~↓~s~ Actions disponible ~c~↓~s~")
                    RageUI.Separator("")
                    if hasChasse == nil then
                        RageUI.Separator("")
                        RageUI.Separator("~c~Chargement ...")
                        RageUI.Separator("")
                    else
                        if not hasChasse then
                            RageUI.Button("Commencer la chasse", nil, {RightLabel = "→→"}, true, function(h, a ,s)
                                if s then
                                    SneakyEvent("sChasse:start", GetEntityCoords(PlayerPedId()), chasse)
                                end
                            end)
                        else
                            RageUI.Button("Arrêter la chasse", nil, {RightLabel = "→→"}, true, function(h, a ,s)
                                if s then
                                    if not exports.inventaire:GetFastWeaponsChasse() then
                                        SneakyEvent("sChasse:stop", true, GetEntityCoords(PlayerPedId()), chasse)
                                    else
                                        ESX.ShowNotification("~r~Merci d'enlever le mousquet de votre inventaire (slots d'arme).")
                                    end
                                end
                            end)
                        end
                    end
                end)
            end
        end)
    end
end

RegisterNetEvent("sChasse:addCount")
AddEventHandler("sChasse:addCount", function(name, count)
    for k,v in pairs(KadirChasse.Boucherie.Items) do
        if v.itemViande == name or v.itemMorviande == name then
            v.count = v.count+count
        end
    end
end)

RegisterNetEvent("sChasse:removeCount")
AddEventHandler("sChasse:removeCount", function(name, count)
    for k,v in pairs(KadirChasse.Boucherie.Items) do
        if v.itemViande == name or v.itemMorviande == name then
            v.count = v.count-count
        end
    end
end)

RegisterNetEvent("core:addCountFish")
AddEventHandler("core:addCountFish", function(name, count)
    for k,v in pairs(KadirChasse.Poissonnerie.Items) do
        if v.itemFish == name or v.itemMorfish == name then
            v.count = v.count+count
        end
    end
end)

RegisterNetEvent("core:removeCountFish")
AddEventHandler("core:removeCountFish", function(name, count)
    for k,v in pairs(KadirChasse.Poissonnerie.Items) do
        if v.itemFish == name or v.itemMorfish == name then
            v.count = v.count-count
        end
    end
end)

function sChasseInput(textEntry, inputText, maxLength)
    AddTextEntry('FMMC_KEY_TIP1', textEntry)
    DisplayOnscreenKeyboard(1, 'FMMC_KEY_TIP1',  '', inputText, '', '', '', maxLength)
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
