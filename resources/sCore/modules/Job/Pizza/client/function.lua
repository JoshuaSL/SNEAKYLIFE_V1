


PlayAnim = function(animDict, animName, duration)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Wait(0) end
    TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
    RemoveAnimDict(animDict)
end

PizzaInput = function( textEntry, inputText, maxLength)
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
