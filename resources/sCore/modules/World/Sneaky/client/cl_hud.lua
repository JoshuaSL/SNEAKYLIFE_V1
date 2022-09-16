function DrawNiceText(xL7OTb, w8T3f, K, qL, vfIyB, quNsijN, QUh2tc)
    SetTextFont(vfIyB)
    SetTextScale(K, K)
    SetTextColour(255, 255, 255, 255)
    SetTextJustification(quNsijN or 1)
    BeginTextCommandDisplayText("STRING")
    if QUh2tc then
        SetTextWrap(xL7OTb, xL7OTb + .1)
    end
    AddTextComponentSubstringPlayerName(qL)
    EndTextCommandDisplayText(xL7OTb, w8T3f)
end

function RegisterControlKey(strKeyName, strDescription, strKey, cbPress, cbRelease)
    RegisterKeyMapping("+" .. strKeyName, strDescription, "keyboard", strKey)

	RegisterCommand("+" .. strKeyName, function()
		if not cbPress or UpdateOnscreenKeyboard() == 0 then return end
        cbPress()
    end, false)

    RegisterCommand("-" .. strKeyName, function()
        if not cbRelease or UpdateOnscreenKeyboard() == 0 then return end
        cbRelease()
    end, false)
end

function GetVehicleHealth(entityVeh)
	return math.floor( math.max(0, math.min(100, GetVehicleEngineHealth(entityVeh) / 10 ) ) )
end

local HudState = false

Citizen.CreateThread(function()
    while true do 
        Initialize()
        if IsPedInAnyVehicle(PlayerPedId()) then
            DrawHudVehicle()
        end
        Wait(1)
    end
end)


function Initialize()
    RegisterControlKey("vehicleHUD","Afficher l'HUD véhicule","F9",function()
        HudState = true
    end,function()
        HudState = false
    end)
end
function DrawHudVehicle()
    local pVeh = GetVehiclePedIsIn(PlayerPedId())
    if pVeh and DoesEntityExist(pVeh) then
        local GetVehicleSpeed = GetEntitySpeed(pVeh) * 3.6
        if GetVehicleSpeed > 40 then
            DisableControlAction(1, 75, true)
        end
    end
    if HudState and IsPedInAnyVehicle(PlayerPedId()) then
        local pCoords = GetEntityCoords(PlayerPedId())
        local _ = GetStreetNameAtCoord(pCoords.x, pCoords.y, pCoords.z, 0, 0)
        local GetNameFromCoords = GetStreetNameFromHashKey(_)
        DrawNiceText(0.45, 0.0, 0.75, "~HUD_COLOUR_BLUELIGHT~" .. GetNameFromCoords, 4)
        if pVeh and GetPedInVehicleSeat(pVeh, -1) == PlayerPedId() then
            local E, yPosition = .0600, .4
            DrawRect(E, yPosition + .005, .125, .10, 0, 0, 0, 140)
            DrawNiceText(E - .0575, yPosition - .045, 0.4, "État moteur", 6)
            DrawNiceText(E + .04, yPosition - .045, 0.4, "~HUD_COLOUR_BLUELIGHT~" .. math.ceil(GetVehicleEngineHealth(pVeh) / 10) .. "%", 6, true)
            DrawNiceText(E - .0575, yPosition - .015, 0.4, "État véhicule", 6)
            DrawNiceText(E + .04, yPosition - .015, 0.4, "~HUD_COLOUR_BLUELIGHT~" .. GetVehicleHealth(pVeh) .. "%", 6, true)
            yPosition = yPosition + .03
            DrawNiceText(E - .0575, yPosition - .015, 0.4, "Essence", 6)
            DrawNiceText(E + .0425, yPosition - .015, 0.4, "~HUD_COLOUR_BLUELIGHT~" .. math.floor(GetVehicleFuelLevel(pVeh)) .. " L", 6, true)
            DrawRect(E, yPosition + .0125, .1175, .0035, 0, 255, 224, 255)
        end
    end
end