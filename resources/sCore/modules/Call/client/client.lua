
ESX = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

Call = Call or {}
Call.blip = nil
Call.calls = {}
Call.notif = nil
Call.notif1 = nil

local buttonList = {
    Array =  {"~b~Prendre~s~","~r~Supprimer~s~"},
    Index = 1
}

Jobs = {
	{ name = "ambulance", label = "Los Santos Medical Center", image = "CHAR_CALL911", msg = "~r~Appel d'urgence"},
	{ name = "police", label = "Los Santos Police Department", image = "CHAR_CALL911", msg = "~r~Appel d'urgence"},
    { name = "lssd", label = "Los Santos Sheriff Department", image = "CHAR_CALL911", msg = "~r~Appel d'urgence"},
}

function CreateBlips(vector3Pos, intSprite, intColor, stringText, boolRoad, floatScale)
	local blip = AddBlipForCoord(vector3Pos.x, vector3Pos.y, vector3Pos.z)
    PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 1)
	SetBlipSprite(blip, intSprite)
	SetBlipAsShortRange(blip, true)
	if intColor then 
		SetBlipColour(blip, intColor) 
	end
	if floatScale then 
		SetBlipScale(blip, floatScale) 
	end
	if boolRoad then 
		SetBlipRoute(blip, boolRoad) 
	end
	if intDisplay then 
		SetBlipDisplay(blip, intDisplay) 
	end
	if intAlpha then 
		SetBlipAlpha(blip, intAlpha) 
	end
	if stringText and (not intDisplay or intDisplay ~= 8) then
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(stringText)
		EndTextCommandSetBlipName(blip)
	end
    if Title then
        SetBlipInfoTitle(blip, Title, false)
    end
    if Image then
        RequestStreamedTextureDict(Image[1], 1)
        while not HasStreamedTextureDictLoaded(Image[1]) do
            Wait(0)
        end
    
        SetBlipInfoImage(blip, Image[1], Image[2])
    end
    if InfoName then
        AddBlipInfoName(blip, InfoName[1], InfoName[2])
    end
    if Texts then
        for k, v in pairs (Texts) do
            AddBlipInfoText(blip, v[1], v[2])
        end
    end
    if InfoText then
        AddBlipInfoText(blip, InfoText)
    end
    if Header then
        AddBlipInfoHeader(blip, "") 
    end
	return blip
end


RegisterNetEvent("sCall:TookCall")
AddEventHandler("sCall:TookCall", function(pos)
    local pPed = PlayerPedId()
    local pPos = GetEntityCoords(pPed)
    local dist = math.floor(Vdist(pPos, pos))
    ShowAboveRadarMessage("Votre appel a été enregistré. (~b~"..dist.."m~s~)")
end)

RegisterNetEvent("sCall:SendMessageCall")
AddEventHandler("sCall:SendMessageCall", function(msg, coords, job, source, tel)
    if CheckServiceLspdLssd() or CheckServiceAmbulance() then
        local pPed = PlayerPedId()
        local pPos = GetEntityCoords(pPed)
        local multiplier = math.random(50, 100)
        coords = tel and coords or vector3(coords.x + multiplier, coords.y + multiplier, coords.z)
        Call.calls[#Call.calls+1] = { name = "Appel N°" .. #Call.calls+1, coords = coords, player = source, Description = msg, tel = tel }
        local dist = math.floor(Vdist(pPos, coords))
        local namestreet = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z)).." ("..math.ceil(dist).."m)"
        msg = "Rue: ~b~"..namestreet.."~s~.\nSujet: ~b~"..msg.."~s~."
        for k,v in pairs(Jobs) do 
            if v.name == job then 
                if Call.notif then RemoveNotification(Call.notif) end
                Call.notif = ShowAdvancedAboveRadarMessage(v.label, v.smg or "Dispatch", msg, v.image or "CHAR_CALL911", 1)
            end
        end
        if Call.notif then RemoveNotification(Call.notif) end
        Call.notif = ShowAboveRadarMessage("Accepter: ~b~W~s~. Refuser: ~r~X~s~.")

        Citizen.CreateThread(function()
            time = 4000
            while true do
                breakThread = nil
                Wait(5)
                time = time - 5
                pPos = GetEntityCoords(PlayerPedId())

                if IsControlJustPressed(0, 20) then
                    if Call.blip then
                        RemoveBlip(Call.blip)
                        Call.blip = nil
                    end
                    if Call.notif1 then RemoveNotification(Call.notif1) end
                    Call.notif1 = ShowAboveRadarMessage("~g~Vous avez accepté l'appel.")
                    if tel then
                        TriggerPlayerEvent("sCall:TookCall", source, pPos)
                    end
                    TriggerServerEvent("sCall:TookCallName") 
                    Call.blip = CreateBlips(coords, 4, 66, "Appel en cours", true, 0.2)
                    while Call.blip do
                        local dist = Vdist(pPos, coords)
                        pPos = GetEntityCoords(PlayerPedId())
                        local size = IsPedSittingInAnyVehicle(PlayerPedId()) and 50.0 or 25.0

                        if dist < size then
                            if Call.notif1 then RemoveNotification(Call.notif1) end
                            Call.notif1 = ShowAboveRadarMessage("~g~Vous êtes arrivé à destination.")
                            RemoveBlip(Call.blip)
                            Call.blip = nil    
                            break
                        end
                        Wait(500)
                    end
                    break
                end

                if IsControlJustPressed(0, 252) then
                    if Call.notif1 then RemoveNotification(Call.notif1) end
                    Call.notif1 = ShowAboveRadarMessage("~r~Vous avez refusé l'appel.")
                    break
                end

                if time <= 0 then
                    if Call.notif1 then RemoveNotification(Call.notif1) end
                    Call.notif1 = ShowAboveRadarMessage("~r~Vous avez refusé l'appel.")
                    breakThread = true
                    break
                end

                if breakThread then
                    if Call.notif1 then RemoveNotification(Call.notif1) end
                    Call.notif1 = ShowAboveRadarMessage("~r~Vous avez refusé l'appel.")
                    breakThread = false
                    break
                end
            end
        end)
    end
end)

local function openCallMenu(job)
    if job == "police" then
        banner = "police"
    elseif job == "lssd" then
        banner = "lssd"
    elseif job == "ambulance" then
        banner = "ambulance"
    end
    local mainMenu = RageUI.CreateMenu("", "Liste des appels", 0, 0, "root_cause",banner)

    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

    while mainMenu do
        Wait(1)
        RageUI.IsVisible(mainMenu, true, false, false, function()
            RageUI.Button("~r~Annuler l'appel en cours", nil, {}, true, function(h,a,s)
                if s then
                    if Call.blip then 
                        RemoveBlip(Call.blip)
                        Call.blip = nil  
                        ShowAboveRadarMessage("~r~Vous avez annulé l'appel.")
                    else
                        ShowAboveRadarMessage("~r~Vous n'avez aucun appel en cours.")
                    end
                end
            end)
            RageUI.Button("~r~Vider les appels", nil, {}, true, function(h,a,s)
                if s then
                    breakThread = true
                    if Call.notif then RemoveNotification(Call.notif) end
                    Call.calls = {}
                end
            end)
            if Call.calls ~= nil then
                for k,v in pairs(Call.calls) do
                    RageUI.List(v.name.." - "..v.Description, buttonList.Array, buttonList.Index, nil, {}, true, function(h, a, s, i)
                        buttonList.Index = i
                        if i == 1 then
                            if s then
                                if Call.blip then
                                    ShowAboveRadarMessage("~r~Vous devez annuler votre appel en cours.")
                                else
                                    Citizen.CreateThread(function()
                                        if v.tel then 
                                            TriggerPlayerEvent("sCall:TookCall", v.player, GetEntityCoords(PlayerPedId()))
                                        end
                                        Call.blip = CreateBlips(v.coords, 4, 66, "Appel en cours", true, 0.2)
                                        while Call.blip do
                                            local pPed = PlayerPedId()
                                            local pPos = GetEntityCoords(pPed)
                                            local dist = Vdist2(pPos, v.coords)
                    
                                            if dist < 50.0 then
                                                if Call.notif1 then RemoveNotification(Call.notif1) end
                                                Call.notif1 = ShowAboveRadarMessage("~g~Vous êtes arrivé à destination")
                                                RemoveBlip(Call.blip)
                                                Call.blip = nil    
                                                break
                                            end
                                            Wait(500)
                                        end
                                    end)
                                    table.remove(Call.calls,k)
                                end
                            end
                        elseif i == 2 then
                            if s then
                                table.remove(Call.calls,k)
                            end
                        end
                    end)   
                end
            end
        end)

        if not RageUI.Visible(mainMenu) then
            mainMenu = RMenu:DeleteType("menu", true)
        end
    end
end

RegisterNetEvent("sCall:OpenCallMenu")
AddEventHandler("sCall:OpenCallMenu",function()
    job = ESX.PlayerData.job.name
    if job == "police" or job == "lssd" or job == "ambulance" then
        openCallMenu(job)
    end
end)

RegisterNetEvent("sCall:SendCallerNameService")
AddEventHandler("sCall:SendCallerNameService",function(msg)
    if CheckServiceLspdLssd() or CheckServiceAmbulance() then
        ShowAboveRadarMessage(msg)
    end
end)