---@class Client
local Client = {} or {};

---@type table Content category menu
local category = {} or {};

---@type table All items
local items = {} or {};

---@type table History activity
local history = {} or {};

---@type table Selected items
local selected = {} or {};

---@type number Current players points
local points = 0;
local id = 0;

local vipRank = 0

local vipExpiration = false

---@type table Shared object
ESX = {};

TriggerEvent('Sneakyesx:getSharedObject', function(obj)
    ESX = obj
end)

SneakyEvent = TriggerServerEvent
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('Sneakyesx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(10)
    end
    ESX.TriggerServerCallback("sVip:getVip", function(vip) 
        vipRank = vip
    end)
    ESX.TriggerServerCallback("sVip:CheckTimeVip", function(vipexpirate) 
        vipExpiration = vipexpirate
    end)
end)

local sBoutique = {}

function Client:onRetrieveItem(categoryId)
    ESX.TriggerServerCallback('tebex:retrieve-items', function(result)
        items = result;
    end, categoryId)
end

function Client:onRetrieveCategory()
    ESX.TriggerServerCallback('tebex:retrieve-category', function(result)
        category = result;
    end)
end

function Client:onRetrievePoints()
    ESX.TriggerServerCallback('tebex:retrieve-points', function(result)
        points = result
    end)
end

function Client:onRetrieveId()
    ESX.TriggerServerCallback('tebex:retrieve-id', function(result)
        id = result
    end)
end

function Client:onRetrieveHistory()
    ESX.TriggerServerCallback('tebex:retrieve-history', function(result)
        history = result;
    end)
end

function Client:RequestPtfx(assetName)
    RequestNamedPtfxAsset(assetName)
    if not (HasNamedPtfxAssetLoaded(assetName)) then
        while not HasNamedPtfxAssetLoaded(assetName) do
            Citizen.Wait(1.0)
        end
        return assetName;
    else
        return assetName;
    end
end

RegisterNetEvent('sVip:updateVip')
AddEventHandler('sVip:updateVip', function(rank)
    vipRank = rank
end)
local timeoutcommand = false
RegisterCommand("viptime",function()
    if not timeoutcommand then
        ESX.TriggerServerCallback("sVip:CheckTimeVip", function(vipexpirate) 
            vipExpiration = vipexpirate
        end)
        timeoutcommand = true
        SetTimeout(10000, function()
            timeoutcommand = false
        end)
    else
        ESX.ShowNotification("~r~Vous devez patienter avant d'effectuer à nouveau cette commande.")
    end
end)

RegisterNetEvent("sVip:NotifyVip")
AddEventHandler("sVip:NotifyVip",function(txtday, txthrs, txtminutes)
    if vipExpiration then
        ESX.ShowNotification("~r~Votre VIP vient d'expirer.")
    else
        ESX.ShowNotification("Il vous reste ~b~"..txtday.."~s~ jours, ~b~"..txthrs.."~s~ heures et ~b~"..txtminutes.."~s~ minutes avant l'expiration de votre VIP.")
    end
end)

function OpenBoutiqueMenuRageUIMenu()

    if sBoutique.Menu then 
        sBoutique.Menu = false 
        RageUI.Visible(RMenu:Get('boutique', 'main'), false)
        return
    else
        RMenu.Add('boutique', 'main', RageUI.CreateMenu("", "", 0, 0,"root_cause","sneakylife"))
        RMenu.Add('boutique', 'history', RageUI.CreateSubMenu(RMenu:Get("boutique", "main"),"", "Boutique de ~b~Sneaky~s~Life"))
        RMenu.Add('boutique', 'itemmenu', RageUI.CreateSubMenu(RMenu:Get("boutique", "main"),"", "Boutique de ~b~Sneaky~s~Life"))
        RMenu:Get('boutique', 'main'):SetSubtitle("Boutique de ~b~Sneaky~s~Life")
        RMenu:Get('boutique', 'main').EnableMouse = false
        RMenu:Get('boutique', 'main').Closed = function()
            sBoutique.Menu = false
        end
        sBoutique.Menu = true 
        RageUI.Visible(RMenu:Get('boutique', 'main'), true)
        Citizen.CreateThread(function()
			while sBoutique.Menu do
                RageUI.IsVisible(RMenu:Get('boutique', 'main'), true, false, true, function()
                    if id == 0 then
                        RageUI.Separator("Votre ~b~ID Boutique~s~ : ~r~Compte FiveM non lié")
                    else
                        RageUI.Separator("Votre ~b~ID Boutique~s~ : "..id)
                    end
                    RageUI.Separator("Vos ~b~SneakyCoins~s~ : "..points)
                    if vipRank == 0 then
                        vipText = "Aucun"
                    elseif vipRank == 1 then
                        vipText = "~y~Gold~s~"
                    elseif vipRank == 2 then
                        vipText = "~b~Diamond~s~"
                    end
                    RageUI.Separator("VIP : "..vipText)
                    RageUI.Button("Transactions", "Historique de vos achats sur la boutique en jeux", {RightLabel = "→ ~y~Regarder ",RightBadge = RageUI.BadgeStyle.Coins}, true, function(h,a,s)
                        if s then
                            Client:onRetrieveHistory()
                        end
                    end,RMenu:Get("boutique","history"))
                    if (#category > 0) then
                        for i, v in pairs(category) do
                            RageUI.Button(v.name, v.descriptions, {RightLabel = "→ ~y~Acheter ",RightBadge = RageUI.BadgeStyle.Coins}, true, function(h,a,s)
                                if s then
                                    Client:onRetrieveItem(v.id)
                                end
                            end,RMenu:Get("boutique","itemmenu"))
                        end
                    else
                        RageUI.Separator("Aucune package disponible.")
                    end
                end)
                RageUI.IsVisible(RMenu:Get('boutique', 'itemmenu'), true, false, true, function()
                    if (#items > 0) then
                        for i, v in pairs(items) do
                            if v.category == 2 then
                                RageUI.Button(v.name, nil, { RightLabel = string.format("~y~%s", v.price),RightBadge = RageUI.BadgeStyle.Coins }, true, function(h,a,s)
                                    if s then
                                        if not (points >= v.price) then
                                            Subtitle("~r~Vous ne posséder pas les points nécessaire", 5000)
                                        end
                                        if (points >= v.price) then
                                            Client:onRetrievePoints();
                                            RageUI.GoBack()
                                            TriggerServerEvent("sCore:deletecoins",v.descriptions, v.price, v.name)
                                            ESX.ShowNotification(string.format("~g~Félicitation vous avez acheté une %s", v.name))
                                        end
                                    end
                                    if a then
                                        local action = json.decode(v.action)
                                        if (action.vehicles ~= nil) then
                                            for i, v in pairs(action.vehicles) do
                                                --RageUI.RenderSprite("case", v.name)
                                                RageUI.RenderVehicle("case", v.name)
                                            end  
                                        end
                                    end
                                end)
                            elseif v.category == 3 then
                                RageUI.Button(v.name, nil, { RightLabel = string.format("~y~%s", v.price),RightBadge = RageUI.BadgeStyle.Coins}, true, function(h,a,s)
                                    if s then
                                        if not (points >= v.price) then
                                            Subtitle("~r~Vous ne posséder pas les points nécessaire", 5000)
                                        end
                                        if (points >= v.price) then
                                            Client:onRetrievePoints();
                                            RageUI.CloseAll()
                                            sBoutique.Menu = false
                                            if not HasStreamedTextureDictLoaded("case") then
                                                RequestStreamedTextureDict("case", true)
                                            end
                                            local action = json.decode(v.action)
                                            SneakyEvent('SneakyLife:process_checkout_case',action.case[1].type)
                                            ESX.ShowNotification(string.format("~g~Félicitation vous avez acheté une %s", v.name))
                                        end
                                    end
                                    if a then
                                        local action = json.decode(v.action)
                                        if (action.case ~= nil) then
                                            for i, v in pairs(action.case) do
                                                --RageUI.RenderSprite("case", v.name)
                                                RageUI.RenderCaisse("case", v.name)
                                            end  
                                        end
                                    end
                                end)
                            end
                        end
                    else
                        RageUI.Separator("Aucun package disponible.")
                    end
                end)
                RageUI.IsVisible(RMenu:Get('boutique', 'history'), true, false, true, function()
                    if (#history > 0) then
                        RageUI.Separator("↓ ~b~Votre historique~s~ ↓")
                        for i, v in pairs(history) do
                            local label;
                            if (tonumber(v.price) == 0) then
                                label = string.format("%s ~b~coins", v.points)
                            else
                                label = string.format("%s (%s%s) ~b~coins", v.points, v.price, v.currency);
                            end
                            RageUI.Button(v.transaction, nil, {RightLabel = label}, true, function()
                            end)
        
                        end
                    else
                        RageUI.Separator("")
                        RageUI.Separator("~c~Aucune transactions effectues.")
                        RageUI.Separator("")
                    end
                end)
				Wait(0)
			end
		end)
	end
end

function Subtitle(text, time)
    ClearPrints()
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandPrint(time and math.ceil(time) or 0, true)
end

Keys.Register('F1','OpenBoutiqueMenuRageUIMenu', 'Boutique ~b~Sneaky~s~Life', function()
    if not exports.inventaire:GetStateInventory() and not GetStateFishing() then 
        if sBoutique.Menu then 
            return 
        end
        if not toucheBloqueKadir then
            Client:onRetrieveCategory();
            Client:onRetrievePoints();
            Client:onRetrieveId();
            OpenBoutiqueMenuRageUIMenu()
        end
    end
end)

function GetVIP()
    return vipRank
end