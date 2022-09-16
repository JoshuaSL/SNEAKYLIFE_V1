-- 
-- Created by Kadir#6400
-- 
SneakyEvent = TriggerServerEvent
local ActionsAnnonce = {
    "~g~Ouverture~s~",
    "~r~Fermeture~s~"
}
local ActionsAnnonceIndex = 1

RegisterNetEvent('announce:burgershot')
AddEventHandler('announce:burgershot', function(announce)
    if announce == 'ouvert' then
        ESX.ShowAdvancedNotification("Burger Shot", '~y~Informations', "- Burger Shot ~g~ouvert~s~~n~- Horaire : ~g~Maintenant", "CHAR_BURGERSHOT", 1)
    elseif announce == 'fermeture' then
        ESX.ShowAdvancedNotification("Burger Shot", '~y~Informations', "- Burger Shot ~r~fermé~s~~n~- Horaire : ~g~Maintenant", "CHAR_BURGERSHOT", 1)
    end
end)
function openCaisseMenu()
    local mainMenu = RageUI.CreateMenu("", "~r~Caisse~s~",nil,nil,"root_cause","burgershot") 

     RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

     while mainMenu do
        Wait(1)
        RageUI.IsVisible(mainMenu, true, true, false, function()
            if not playerInService then
                RageUI.List("Annonce", ActionsAnnonce, ActionsAnnonceIndex, nil, {}, true, function(Hovered, Active, Selected, Index) 
                    if (Selected) then 
                        if Index == 1 then 
                            local announce = 'ouvert'
                            SneakyEvent('burgershot:announce', announce)
                        elseif Index == 2 then
                            local announce = 'fermeture'
                            SneakyEvent('burgershot:announce', announce)
                        end 
                    end 
                    ActionsAnnonceIndex = Index 
                end)
                RageUI.Button("Attribuer une facture", nil, {RightLabel = "→"}, true,function(h,a,s)
                    if s then
                        RageUI.CloseAll()
                        TriggerEvent("sBill:CreateBill","society_burgershot")
                    end
                end)
            else
                RageUI.Separator("")
                RageUI.Separator("Vous n'êtes pas en service")
                RageUI.Separator("")
            end
        end)

        if not RageUI.Visible(mainMenu) then
            mainMenu = RMenu:DeleteType("menu", true)
        end
     end
end
