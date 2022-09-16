-- 
-- Sneaky-Corp
-- Created by Kadir#6400
-- 

openedBuyMenu = false
local buyMenu = RageUI.CreateMenu("", "KadirTheLol", 80, 95)
buyMenu.Closed = function() openedBuyMenu = false FreezeEntityPosition(PlayerPedId(), false) end
SneakyEvent = TriggerServerEvent
function openBuyMenu(table)
    if openedBuyMenu then
        openedBuyMenu = false
        RageUI.Visible(buyMenu, false)
        return
    else
        openedBuyMenu = true
        FreezeEntityPosition(PlayerPedId(), true) 
        RageUI.Visible(buyMenu, true)
        buyMenu:SetSubtitle("~y~"..table.name)
        Citizen.CreateThread(function()
            getLaboratoireESX()
            while openedBuyMenu do
                Wait(1.0)
                RageUI.IsVisible(buyMenu, false, false, true, function()
                    RageUI.Separator("Prix du ~y~"..table.name.."~s~ "..table.price.."~g~$~s~")
                    RageUI.Button("Visiter", nil, {RightLabel = "~y~Entrer~s~ →"}, true, function(_, _, Select)
                        if (Select) then
                            SneakyEvent("sLaboratoire:Visite", GetEntityCoords(PlayerPedId()), table)
                        end
                    end)
                    RageUI.Button("Acheter", "Prix "..table.price.."~g~$~s~", {RightLabel = "~g~Oui~s~ →"}, true, function(_, _, Select)
                        if (Select) then
                            SneakyEvent("sLaboratoire:buyLab", table, ESX.PlayerData.job2.name, ESX.PlayerData.job2.label)
                        end
                    end)
                end)
            end
        end)
    end
end

openedVisiteMenu = false
local visiteMenu = RageUI.CreateMenu("", "Visite : ~y~Laboratoire", 80, 95)
visiteMenu.Closed = function() openedVisiteMenu = false end
visiteMenu.Closable = false;

function openVisiteMenu(table)
    if openedVisiteMenu then
        openedVisiteMenu = false
        RageUI.Visible(visiteMenu, false)
        return
    else
        openedVisiteMenu = true
        if openedBuyMenu then
            openedBuyMenu = false
            FreezeEntityPosition(PlayerPedId(), false)
            RageUI.Visible(buyMenu, false)
        end
        RageUI.Visible(visiteMenu, true)
        Citizen.CreateThread(function()
            while openedVisiteMenu do
                Wait(1.0)
                RageUI.IsVisible(visiteMenu, false, false, true, function()
                    RageUI.Separator("Laboratoire n°~y~"..table.id)
                    RageUI.Separator("~y~"..table.name.."~s~ - "..table.price.."~g~$~s~")
                    RageUI.Button("~r~Quitter le mode visite~s~", nil, {RightLabel = "→"}, true, function(_, _, Select)
                        if (Select) then
                            if openedVisiteMenu then
                                SneakyEvent("sLaboratoire:Exit")
                                openedVisiteMenu = false
                                FreezeEntityPosition(PlayerPedId(), false)
                                RageUI.Visible(visiteMenu, false)
                                openBuyMenu(table)
                            end
                        end
                    end)
                end)
            end
        end)
    end
end


RegisterNetEvent("sLaboratoire:returnBuyLab")
AddEventHandler("sLaboratoire:returnBuyLab", function()
    if openedBuyMenu then
        openedBuyMenu = false
        RageUI.Visible(buyMenu, false)
        FreezeEntityPosition(PlayerPedId(), false)
        return
    end
end)