-- 
-- Sneaky-Corp
-- Created by Kadir#6400
-- 

local function TransformPos(pos)
    return {x = pos.x, y = pos.y, z = pos.z}
end

local function createdLabInput( textEntry, inputText, maxLength)
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

local createLab = {
    List = {
        "lab_weed",
        "lab_coke",
        "lab_meth"
    },
    Index = 1,
    selectLabo = false,
    selectLaboName = "",
    selectLaboLabel = "",
    price = 0,
    pos = ""
}

local openedCreatedMenu = false
local createdMenu = RageUI.CreateMenu("", "Laboratoire", 80, 95)
local createdSubMenu = RageUI.CreateSubMenu(createdMenu, "", "Liste laboratoires", 80, 95)
local createdViewMenu = RageUI.CreateSubMenu(createdSubMenu, "", "", 80, 95)
SneakyEvent = TriggerServerEvent
createdMenu.Closed = function() 
    openedCreatedMenu = false 
    createLab.selectLabo = false
    createLab.selectLaboName = ""
    createLab.selectLaboLabel = ""
    createLab.price = 0
    createLab.pos = ""
    if posSelect then
        posSelect = false
    end
end
local function openCreatedMenu()
    if openedCreatedMenu then
        openedCreatedMenu = false
        RageUI.Visible(createdMenu, false)
        return
    else
        getLaboratoireESX()
        openedCreatedMenu = true
        RageUI.Visible(createdMenu, true)
        Citizen.CreateThread(function()
            while openedCreatedMenu do
                Wait(1.0)
                RageUI.IsVisible(createdMenu, false, false, true, function()
                    RageUI.Button("Liste des laboratoires", nil, {RightLabel = "~y~Voir~s~ →"}, true, function(_, _, Select)
                        if (Select) then
                            ESX.TriggerServerCallback("sLaboratoire:getLab", function(ok)
                                resultLab = ok
                            end)
                        end
                    end, createdSubMenu)
                    RageUI.Separator("")
                    RageUI.Separator("↓ Création d'un ~y~laboratoire~s~ ↓")
                    if not createLab.selectLabo then
                        RageUI.List("Laboratoire", createLab.List, createLab.Index, nil, {}, true, function(_,_,Select, Index)
                            if (Select) then
                                createLab.selectLaboName = createLab.List[Index]
                                createLab.selectLaboLabel = Laboratoire[createLab.List[Index]].Name
                                createLab.selectLabo = true
                            end
                            createLab.Index = Index
                        end)
                    else
                        RageUI.Separator("Laboratoire choisi ~y~"..createLab.selectLaboLabel)
                    end
                    RageUI.Button("Prix", nil, {RightLabel = "→ "..createLab.price.."~g~$"}, createLab.selectLabo, function(_, _, Select)
                        if (Select) then
                            local amount = createdLabInput("Veuillez saisir un prix :", "", 6)
                            if tonumber(amount) then
                                if tonumber(amount) >= 1500 then
                                    ESX.ShowNotification("Prix fixé sur "..amount.."~g~$~s~ !")
                                    createLab.price = tonumber(amount)
                                else
                                    ESX.ShowNotification("Veuillez entrer un nombre plus haut que 1 500~g~$~s~ !")
                                end
                            else
                                ESX.ShowNotification("Veuillez saisir un nombre (~c~Maximum 6 chiffres~s~)")
                            end
                        end
                    end)
                    RageUI.Button("Position", nil, {RightLabel = "Prendre →"}, createLab.selectLabo and not posSelect, function(_, _, Select)
                        if (Select) then
                            createLab.pos = TransformPos(GetEntityCoords(PlayerPedId()))
                            ESX.ShowNotification("Position fixé sur votre position actuelle !")
                            posSelect = true
                        end
                    end)
                    RageUI.Button("Confirmer", nil, {RightLabel = "Créer →"}, createLab.selectLabo, function(_, _, Select)
                        if (Select) then
                            if createLab.selectLaboName == "" or createLab.selectLaboLabel == "" or createLab.price == 0 or createLab.price < 1500 or createLab.pos == "" then
                                ESX.ShowNotification("Vérifier vous valeurs !")
                            else
                                createdLab(createLab.selectLaboName, createLab.selectLaboLabel, createLab.price, createLab.pos)
                                createLab.selectLabo = false
                                createLab.selectLaboName = ""
                                createLab.selectLaboLabel = ""
                                createLab.price = 0
                                createLab.pos = ""
                                if posSelect then
                                    posSelect = false
                                end
                            end
                        end
                    end)
                end)
                RageUI.IsVisible(createdSubMenu, false, false, true, function()
                    if resultLab == nil then
                        RageUI.Separator("")
                        RageUI.Separator("~c~Chargement ...")
                        RageUI.Separator("")
                    else
                        if #resultLab == 0 then
                            RageUI.Separator("")
                            RageUI.Separator("~c~Aucun laboratoire")
                            RageUI.Separator("")
                        else
                            RageUI.Separator("↓ Laboratoires ↓")
                            for k,v in pairs(resultLab) do
                                if v.owner == nil then
                                    ownerName = "à ~r~Personne~s~"
                                else
                                    ownerName = "au ~b~"..v.ownerName.."~s~"
                                end
                                RageUI.Button(v.name.." - "..v.price.."~g~$~s~", "Appartenant "..ownerName..", laboratoire n°"..v.id, {RightLabel = "~y~Voir~s~ →"}, true, function(_, _, Select)
                                    if (Select) then
                                        createdViewMenu:SetSubtitle(v.name)
                                        selectLab = v
                                    end
                                end, createdViewMenu)
                            end
                        end
                    end
                end)

                RageUI.IsVisible(createdViewMenu, false, false, true, function()
                    RageUI.Separator("Laboratoire n°~y~"..selectLab.id)
                    RageUI.Separator("Type de laboratoire ~y~"..selectLab.type)
                    if selectLab.ownerName ~= nil then
                        RageUI.Separator("Appartenant "..selectLab.ownerName)
                    else
                        RageUI.Separator("Appartenant "..ownerName)
                    end
                    RageUI.Separator("Prix du laboratoire "..selectLab.price.."~g~$~s~")
                    RageUI.Button("Se téléporter", "~r~Attention~s~ : Pas de retour possible !", {RightLabel = "~g~Oui~s~ →"}, true, function(_, _, Select)
                        if (Select) then 
                            local pos = json.decode(selectLab.pos)
                            SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z-1.0)
                            ESX.ShowNotification("Vous vous êtes bien ~b~téléporté~s~ au ~y~"..selectLab.name.."~s~ n°~y~"..selectLab.id.."~s~ !")
                            RageUI.CloseAll()
                            openedCreatedMenu = false
                        end
                    end)
                    if selectLab.owner ~= nil then
                        RageUI.Button("Dissocier le laboratoire des ~b~"..selectLab.ownerName, "~r~Attention~s~ : Pas de retour possible !", {RightLabel = "~g~Oui~s~ →"}, true, function(_, _, Select)
                            if (Select) then 
                                SneakyEvent("sLaboratoire:removeOwner", selectLab, selectLab.owner, selectLab.ownerName)
                                RageUI.GoBack()
                            end
                        end)    
                    end
                    RageUI.Button("Supprimer le laboratoire", "~r~Attention~s~ : Pas de retour possible !", {RightLabel = "~r~Supprimer~s~ →"}, true, function(_, _, Select)
                        if (Select) then 
                            deletedLab(selectLab.type, selectLab.name, selectLab.id)
                            RageUI.CloseAll()
                            openedCreatedMenu = false
                        end
                    end)
                end)

            end
        end)
    end
end

RegisterNetEvent("sLaboratoire:openCreateMenu")
AddEventHandler("sLaboratoire:openCreateMenu", function()
    if not openedCreatedMenu then
        openCreatedMenu()
    end
end)
