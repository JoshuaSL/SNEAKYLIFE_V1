EventStop = false


RegisterNetEvent("RS_AutoEvents_SendEvent")
AddEventHandler("RS_AutoEvents_SendEvent", function(data, zone)
    PlaySoundFrontend(-1, "5s_To_Event_Start_Countdown", "GTAO_FM_Events_Soundset", 1)
    Wait(5000)
    PlaySoundFrontend(-1, "5_Second_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 1)
    EventStop = false
    if data.type == "money" then
        moneyEvent(data, zone)
    elseif data.type == "avion" then
        avionEvent(data, zone)
    end
end)


RegisterNetEvent("RS_AutoEvents_StopEvent")
AddEventHandler("RS_AutoEvents_StopEvent", function(data, zone)
    PlaySoundFrontend(-1, "Criminal_Damage_High_Value", "Criminal_Damage_High_Value", 1)
    PlaySoundFrontend(-1, "Criminal_Damage_High_Value", "Criminal_Damage_High_Value", 1)
    PlaySoundFrontend(-1, "Criminal_Damage_High_Value", "Criminal_Damage_High_Value", 1)
    PlaySoundFrontend(-1, "Checkpoint_Cash_Hit", "GTAO_FM_Events_Soundset", 1)
    ShowAdvancedNotification("Joaquìn Hernàndez", "~r~Event illégal", "Terminé! Tu n'étais pas encore arrivé? Rien à foutre vient plus rapidement la prochaine fois!", "CHAR_ORTEGA",1)
    EventStop = true
    removeBlips()
end)

function RemoveObj(id)
    local entity = id
    SetEntityAsMissionEntity(entity, true, true)
    
    local timeout = 2000
    while timeout > 0 and not IsEntityAMissionEntity(entity) do
        Wait(100)
        timeout = timeout - 100
    end

    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
    
    if (DoesEntityExist(entity)) then 
        DeleteEntity(entity)
    end 
end

function Popup(txt)
    ClearPrints()
    SetNotificationBackgroundColor(140)
    SetNotificationTextEntry("Auto_event_popup")
    AddTextEntry('Auto_event_popup', txt)
    DrawNotification(false, true)
end

function ShowAdvancedNotification(sender, subject, msg, textureDict, iconType)
    SetAudioFlag("LoadMPData", 1)
	AddTextEntry('AutoEventAdvNotif', msg)
	BeginTextCommandThefeedPost('AutoEventAdvNotif')
	EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
end