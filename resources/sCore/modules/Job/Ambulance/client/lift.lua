local lift = {
    teleport = {
        [0] =  {pos = vector3(335.80844116211,-580.31396484375,28.901124954224), name = "1 - Accident et Urgence", heading = 161.45},
        [1] =  {pos = vector3(335.69741821289,-580.28271484375,43.290969848633), name = "4 - RDC", heading = 160.90},
        [2] =  {pos = vector3(335.76223754883,-580.34716796875,48.24089050293), name = " 5 - Laboratoire et salle de classe", heading = 161.58},
        [3] =  {pos = vector3(335.77548217773,-580.28582763672,74.070449829102), name = " 10 - Héliport", heading = 162.28},
    },
}

local function openMenuLift(select)
    local mainMenu = RageUI.CreateMenu("", "Ascenseur pillbox hill", 0, 0, "root_cause","ambulance")

    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

    while mainMenu do
        Wait(1)
        RageUI.IsVisible(mainMenu, true, true, false, function()
            for k,v in pairs(lift.teleport) do
                RageUI.Button(v.name, nil, {}, v.pos ~= select.pos, function(h, a, s)
                    if s then
                        SetEntityCoordsNoOffset(PlayerPedId(), v.pos)
                        SetEntityHeading(PlayerPedId(), v.heading)
                        ESX.ShowNotification("Vous êtes bien arrivé a l'étage ~b~"..v.name.."~s~.")
                        RageUI.CloseAll()
                    end
                end)
            end
        end)

        if not RageUI.Visible(mainMenu) then
            mainMenu = RMenu:DeleteType("menu", true)
        end
    end
end

CreateThread(function()
    while true do
        local waiting = 250
        local myCoords = GetEntityCoords(PlayerPedId())
        for k,v in pairs(lift.teleport) do
            if #(myCoords-v.pos) < 1.0 then
                waiting = 1
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~choisir votre étage~s~.")
                if IsControlJustReleased(0, 54) then
                    openMenuLift(v)
                end
            end
        end
        Wait(waiting)
    end
end)