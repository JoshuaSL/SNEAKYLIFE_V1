SneakyEvent = TriggerServerEvent
local ActionsAnnonce = {
    "~g~Ouverture~s~",
    "~r~Fermeture~s~"
}
local ActionsAnnonceIndex = 1

RegisterNetEvent('announce:pizza')
AddEventHandler('announce:pizza', function(announce)
    if announce == 'ouvert' then
        ESX.ShowAdvancedNotification("~g~Drusilla's~s~ Pizza", '~y~Informations', "- Drusilla's Pizza ~g~ouvert~s~~n~- Horaire : ~g~Maintenant", "CHAR_PIZZA", 1)
    elseif announce == 'fermeture' then
        ESX.ShowAdvancedNotification("~g~Drusilla's~s~ Pizza", '~y~Informations', "- Drusilla's Pizza ~r~fermé~s~~n~- Horaire : ~g~Maintenant", "CHAR_PIZZA", 1)
    end
end)

function openCaisseMenuPizza()
    local mainMenu = RageUI.CreateMenu("", "~g~Caisse~s~",nil,nil,"root_cause","shopui_title_pizzathis") 

    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

    while mainMenu do
       Wait(1)
       RageUI.IsVisible(mainMenu, true, true, false, function()
            RageUI.List("Annonce", ActionsAnnonce, ActionsAnnonceIndex, nil, {}, true, function(Hovered, Active, Selected, Index) 
                if (Selected) then 
                    if Index == 1 then 
                        local announce = 'ouvert'
                        SneakyEvent('pizza:announce', announce)
                    elseif Index == 2 then
                        local announce = 'fermeture'
                        SneakyEvent('pizza:announce', announce)
                    end 
                end 
                ActionsAnnonceIndex = Index 
            end)
            RageUI.Button("Attribuer une facture", nil, {RightLabel = "→"}, true,function(h,a,s)
                if s then
                    FreezeEntityPosition(PlayerPedId(), false)
                    RageUI.CloseAll()
                    TriggerEvent("sBill:CreateBill","society_pizza")
                end
            end)
       end)

       if not RageUI.Visible(mainMenu) then
           mainMenu = RMenu:DeleteType("menu", true)
       end
    end
end
