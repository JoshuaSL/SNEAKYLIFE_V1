ESX = nil
zone = 0
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
end)
SneakyEvent = TriggerServerEvent
local Fleeca = {

    {
        pos = vector3(150.266, -1040.203, 29.374),
        blip = {
            label = "Banque", 
            ID = 207, 
            Color = 69
        },
    },
    {
        pos = vector3(4477.0634765625,-4464.4365234375,4.2520751953125),
        blip = {
            label = "Banque", 
            ID = 207, 
            Color = 69
        },
    },
    {
        pos = vector3(-1212.980, -330.841, 37.787),
        blip = {
            label = "Banque", 
            ID = 207, 
            Color = 69
        },
    },
    {
        pos = vector3(-2962.582, 482.627, 15.703),
        blip = {
            label = "Banque", 
            ID = 207, 
            Color = 69
        },
    },
    {
        pos = vector3(314.187, -278.621, 54.170),
        blip = {
            label = "Banque", 
            ID = 207, 
            Color = 69
        },
    },
    {
        pos = vector3(-351.534, -49.529, 49.042),
        blip = {
            label = "Banque", 
            ID = 207, 
            Color = 69
        },
    },
    {
        pos = vector3(253.44522094727,220.79937744141,106.2865524292),
        blip = {
            label = "Banque", 
            ID = 207, 
            Color = 69
        },
    },
    {
        pos = vector3(1175.064, 2706.643, 38.094),
        blip = {
            label = "Banque", 
            ID = 207, 
            Color = 69
        },
    },
}
local ATM = {
    {
        posatm = vector3(-1390.9733886719,-590.48260498047,30.319549560547),
    },
    {
        posatm = vector3(166.27542114258,6635.1469726563,31.710628509521),
    },
    {
        posatm = vector3(-468.81069946289,45.508338928223,52.414813995361),
    },
    {
        posatm = vector3(1735.4390869141,6410.9711914063,35.037220001221),
    },
    {
        posatm = vector3(1702.7735595703,4933.2119140625,42.063682556152),
    },
    {
        posatm = vector3(1967.8854980469,3743.9406738281,32.343746185303),
    },
    {
        posatm = vector3(2682.6196289063,3286.888671875,55.241123199463),
    },
    {
        posatm = vector3(-3041.2846679688,592.92938232422,7.9089312553406),
    },
    {
        posatm = vector3(540.40020751953,2670.6997070313,42.15648651123),
    },
    {
        posatm = vector3(-1826.9107666016,785.2861328125,138.29405212402),
    },
    {
        posatm = vector3(2557.9838867188,389.52868652344,108.62298583984),
    },
    {
        posatm = vector3(-717.31628417969,-915.61187744141,19.215606689453),
    },
    {
        posatm = vector3(380.90301513672,323.6911315918,103.56636047363),
    },
    {
        posatm = vector3(1154.1027832031,-326.62689208984,69.205154418945),
    },
    {
        posatm = vector3(33.239086151123,-1347.9400634766,29.497032165527),
    },
    {
        posatm = vector3(147.69183349609,-1035.6818847656,29.343011856079),
    },
    {
        posatm = vector3(1326.6162109375,-1647.9340820313,52.249046325684),
    },
    {
        posatm = vector3(-56.627853393555,-1752.2760009766,29.421005249023),
    },
    {
        posatm = vector3(-3044.087890625,595.06164550781,7.7363204956055),
    },
    {
        posatm = vector3(145.85491943359,-1035.0993652344,29.344993591309),
    },
    {
        posatm = vector3(112.82706451416,-819.38214111328,31.33659362793),
    },
    {
        posatm = vector3(111.26631164551,-775.33624267578,31.438135147095),
    },
    {
        posatm = vector3(114.3787689209,-776.41522216797,31.418004989624),
    },
    {
        posatm = vector3(299.1770324707,-588.82543945312,43.29275894165),
    },
    {
        posatm = vector3(-254.27116394043,-692.42755126953,33.611877441406),
    },
    {
        posatm = vector3(-258.76983642578,-723.35736083984,33.467834472656),
    },
    {
        posatm = vector3(-256.17449951172,-715.99975585938,33.522109985352),
    },
    {
        posatm = vector3(-1205.6140136719,-324.96905517578,37.855983734131),
    },
    {
        posatm = vector3(-1205.0242919922,-326.3010559082,37.840133666992),
    },
    {
        posatm = vector3(-2072.3603515625,-317.39266967773,13.315970420837),
    },
    {
        posatm = vector3(-710.05999755859,-818.94561767578,23.729532241821),
    },
    {
        posatm = vector3(-712.86761474609,-819.06652832031,23.729530334473),
    },
    {
        posatm = vector3(-203.8486328125,-861.38891601562,30.267627716064),
    },
    {
        posatm = vector3(236.52540588379,219.60119628906,106.28675842285),
    },
    {
        posatm = vector3(236.95637512207,218.79644775391,106.28675842285),
    },
    {
        posatm = vector3(237.36880493164,217.90293884277,106.28675842285),
    },
    {
        posatm = vector3(237.71237182617,217.07527160645,106.28675842285),
    },
    {
        posatm = vector3(238.27169799805,216.02464294434,106.28675842285),
    },
    {
        posatm = vector3(-386.78811645508,6046.0073242188,31.501714706421),
    },
    {
        posatm = vector3(155.64189147949,6642.5068359375,31.610828399658),
    },
    {
        posatm = vector3(-3241.2321777344,997.4375,12.55039691925),
    },
    {
        posatm = vector3(-2072.4555664062,-317.05703735352,13.315969467163),
    },
    {
        posatm = vector3(-660.66613769531,-854.05456542969,24.485019683838),
    },
    {
        posatm = vector3(127.39432525635,-1296.2351074219,29.269329071045),
    },
    {
        posatm = vector3(126.39643859863,-1296.8404541016,29.269329071045),
    },
}


local Bank = {}
local soldaccount = 0
local Pourcent = 0.0
function ShowHelpNotification(msg)
    AddTextEntry('HelpNotification', msg)
	BeginTextCommandDisplayHelp('HelpNotification')
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function CheckSolde()
    SneakyEvent("SneakyLife:solde",action)
end

function Deposit()
    local amount = KeyboardInputBank("Dépot banque", "", 15)

    if amount ~= nil then
        amount = tonumber(amount)

        if type(amount) == 'number' then
            SneakyEvent('SneakyLife:deposit', amount)
            succes = 1
        else
            ESX.ShowNotification("~r~Attention~s~\nVous n'avez pas saisi de montant")
        end
    end
end	

function Withdraw()
    local amount = KeyboardInputBank("Retrait banque", "", 15)

    if amount ~= nil then
        amount = tonumber(amount)

        if type(amount) == 'number' then
            SneakyEvent('SneakyLife:withdraw', amount)
            succes = 1
        else
            ESX.ShowNotification("~r~Attention~s~\nVous n'avez pas saisi de montant")
        end
    end
end	

function KeyboardInputBank(TextEntry, ExampleText, MaxStringLenght)


    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
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

RMenu.Add('banque', 'main', RageUI.CreateMenu("", "~g~Banque", 10, 200,'root_cause',"shopui_title_fleecabank"))
RMenu:Get('banque', 'main').EnableMouse = false

RMenu:Get('banque', 'main').Closed = function() Bank.Menu = false FreezeEntityPosition(GetPlayerPed(-1), false) end

function OpenbanqueRageUIMenu()

    if Bank.Menu then
        Bank.Menu = false
    else
        Bank.Menu = true
        RageUI.Visible(RMenu:Get('banque', 'main'), true)
        FreezeEntityPosition(GetPlayerPed(-1), true)

        Citizen.CreateThread(function()
			while Bank.Menu do
                RageUI.IsVisible(RMenu:Get('banque', 'main'), true, false, true, function()
                    if zone == 1 then
                        RageUI.Separator("Solde du compte : "..soldaccount.."~g~$")
                        RageUI.Button("Ajouter de l'argent sur le compte", false, {RightLabel = "→"}, true, function(h,a,s)
                            if s then
                                Deposit()
                                ESX.SetTimeout(100, function()
                                    CheckSolde()
                                end)
                            end
                        end)

                        RageUI.Button("Retirer de l'argent de son compte", false, {RightLabel = "→"}, true, function(h,a,s)
                            if s then
                                Withdraw()
                                ESX.SetTimeout(100, function()
                                    CheckSolde()
                                end)
                            end
                        end)
                        if succes == 1 then
                            RageUI.PercentagePanel(Pourcent or 0.0, "Transaction ... (" .. math.floor(Pourcent*100) .. "%)", "", "",  function(Hovered, Active, Percent)
                                if Pourcent < 1.0 then
                                    Pourcent = Pourcent + 0.004
                                else
                                    Pourcent = 0.0
                                    connect = 0
                                    progress = 0
                                    infos = 1
                                    succes = 0
                                end
                            end)
                        end
                    elseif zone == 2 then
                        RageUI.Separator("Solde du compte : "..soldaccount.."~g~$")
                        RageUI.Button("Retirer de l'argent de son compte", false, {RightLabel = "→"}, true, function(h,a,s)
                            if s then
                                Withdraw()
                                ESX.SetTimeout(100, function()
                                    CheckSolde()
                                end)
                            end
                        end)
                        if succes == 1 then
                            RageUI.PercentagePanel(Pourcent or 0.0, "Transaction ... (" .. math.floor(Pourcent*100) .. "%)", "", "",  function(Hovered, Active, Percent)
                                if Pourcent < 1.0 then
                                    Pourcent = Pourcent + 0.004
                                else
                                    Pourcent = 0.0
                                    connect = 0
                                    progress = 0
                                    infos = 1
                                    succes = 0
                                end
                            end)
                        end
                    end
                end)
				Wait(0)
			end
		end)
	end

end

Citizen.CreateThread(function()
    while true do
        att = 500
        local myCoords = GetEntityCoords(PlayerPedId())
        for k,v in pairs(Fleeca) do
            if not Bank.Menu then
                if #(myCoords-v.pos) < 10.0 then
                    att = 1
                    if #(myCoords-v.pos) < 1.5 then
                        zone = 1
                        ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour accéder à la ~b~banque~s~.")
                        if IsControlJustPressed(0, 51) then
                            CheckSolde()
                            OpenbanqueRageUIMenu()
                        end
                    end
                end
            end
        end
        for k,v in pairs(ATM) do
            if not Bank.Menu then
                if #(myCoords-v.posatm) < 10.0 then
                    att = 1
                    if #(myCoords-v.posatm) < 1.5 then
                        zone = 2
                        ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour interagir avec l'ATM")
                        if IsControlJustPressed(0, 51) then
                            CheckSolde()
                            OpenbanqueRageUIMenu()
                        end
                    end
                end
            end
        end
        Citizen.Wait(att)
    end
end)

RegisterNetEvent("SneakyLife:GetSoldAccount")
AddEventHandler("SneakyLife:GetSoldAccount", function(money,cash)
    soldaccount = tonumber(money)
end)