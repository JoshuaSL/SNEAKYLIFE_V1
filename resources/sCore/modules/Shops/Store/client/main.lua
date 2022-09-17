-- ESX

ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        Wait(250)
        TriggerEvent("esx:getSharedObject", function(niceESX) ESX = niceESX end)
    end
end) 

-- Store

Citizen.CreateThread(function()
    while true do
        local nofps = false
        local myCoords = GetEntityCoords(PlayerPedId())

        if not openedStoreMenu then
            for i=1, #Stores, 1 do
                local allPos = Stores[i].Positions
                for k,v in pairs(allPos) do
                    if #(myCoords-v.coords) < 1.0 then
                        nofps = true
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le "..Stores[i].label)
                        if IsControlJustReleased(0, 38) then
                            lastPos = v.coords
                            openStoreMenu(Stores[i])
                        end
                    end
                end
            end
        end

        if nofps then
            Wait(1)
        else
            Wait(850)
        end

    end
end)
