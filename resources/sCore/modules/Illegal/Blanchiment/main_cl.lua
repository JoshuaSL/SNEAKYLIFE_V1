ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        Wait(10)
        TriggerEvent("esx:getSharedObject", function(niceESX) ESX = niceESX end)
    end
    while ESX.GetPlayerData().job2 == nil do
        Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then
        ESX.PlayerData = ESX.GetPlayerData()
    end
end)
SneakyEvent = TriggerServerEvent
local Blanchiments = {
    [1] = {
        texture = "root_cause",
        banner = "cartelcoronado",
        label = "Blanchiment - Cartel del Coronado",
        job = "coronado",
        pos = vector3(5195.1376953125,-5136.744140625,3.3472304344177)
    },
}

local openedMenu = false

Citizen.CreateThread(function()
    
    RMenu.Add("blanchiment", "main", RageUI.CreateMenu("", "Name", 80, 90))
    RMenu:Get("blanchiment", "main").Closed = function()
        openedMenu = false
        FreezeEntityPosition(PlayerPedId(), false)
    end

end)

function blanchimentInput(entryTitle, textEntry, inputText, maxLength)
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

local selectMoney = 0
local niceMoney = 0

local function openMenu(blanch)
    if openedMenu then
        openedMenu = false
        FreezeEntityPosition(PlayerPedId(), false)
        RageUI.Visible(RMenu:Get("blanchiment", "main"), false)
        return
    else
        openedMenu = true
        FreezeEntityPosition(PlayerPedId(), true)
        RMenu:Get("blanchiment", "main"):SetSubtitle(blanch.label)
        RMenu:Get("blanchiment", "main"):SetSpriteBanner(blanch.texture, blanch.banner)
        RageUI.Visible(RMenu:Get("blanchiment", "main"), true)
        Citizen.CreateThread(function()
            while openedMenu do
                Wait(1.0)
                RageUI.IsVisible(RMenu:Get("blanchiment", "main"), true, false, false, function()
                    if selectMoney >= 1500 then
                        RageUI.Separator("Argent que vous allez recevoir "..ESX.Math.GroupDigits(ESX.Math.Round(niceMoney)).."~r~$~s~")
                    end

                    RageUI.Button("Argent à blanchir", nil, {RightLabel = ESX.Math.GroupDigits(ESX.Math.Round(selectMoney)).."~r~$~s~"}, true, function(h, a, s)
                        if s then
                            local result = blanchimentInput("BLANCH_MONEY", "Veuillez sélectionner un montant :", "", 7)
                            if result == "" or result == nil then
                                return ESX.ShowNotification("~r~Valeur invalide !")
                            else
                                if tonumber(result) then
                                    if tonumber(result) >= 1500 then
                                        selectMoney = tonumber(result)
                                        niceMoney = selectMoney*0.80
                                    else
                                        ESX.ShowNotification("Veuillez entrer une valeur plus haut que 1500~r~$~s~")
                                    end
                                else
                                    ESX.ShowNotification("~r~Veuillez saisir un nombre !")
                                end
                            end
                        end
                    end)

                    if selectMoney >= 1500 then
                        RageUI.Button("Confirmer le ~r~blanchiment~s~", "Argent que vous allez gagner "..ESX.Math.GroupDigits(ESX.Math.Round(niceMoney)).."~r~$~s~", {}, true, function(h, a ,s)
                            if s then
                                SneakyEvent("kBlanch:transformMoney", serverToken, selectMoney)
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
        Wait(10)
        TriggerEvent("esx:getSharedObject", function(niceESX) ESX = niceESX end)
    end

    while ESX.GetPlayerData().job2 == nil do
        Citizen.Wait(10)
    end

    if ESX.IsPlayerLoaded() then
        ESX.PlayerData = ESX.GetPlayerData()
    end

    while true do
        local myCoords = GetEntityCoords(PlayerPedId())
        local nofps = false

        if not openedMenu then
            for k,v in pairs(Blanchiments) do
                if ESX.PlayerData.job2.name == v.job then
                    if #(v.pos-myCoords) < 1.0 then
                        nofps = true
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour acceder au blanchiment")
                        if IsControlJustReleased(0, 38) then
                            openMenu(v)
                        end
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