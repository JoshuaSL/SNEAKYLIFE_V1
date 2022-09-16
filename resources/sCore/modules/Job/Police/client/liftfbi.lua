local lift = {
    teleport = {
        [0] =  {pos = vector3(136.20448303223,-761.73419189453,45.752052307129), name = "0 - RDC"},
        [1] =  {pos = vector3(136.0994720459,-761.72723388672,242.15205383301), name = "1 - Étage principal"},
    },
}

local function openMenu(select)
    local mainMenu = RageUI.CreateMenu("", "Ascenseur fbi", 0, 0, "root_cause","fbi")

    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

    while mainMenu do
        Wait(1)
        RageUI.IsVisible(mainMenu, true, true, false, function()
            for k,v in pairs(lift.teleport) do
                RageUI.Button(v.name, nil, {}, v.pos ~= select.pos, function(h, a, s)
                    if s then
                        SetEntityCoordsNoOffset(PlayerPedId(), v.pos)
                        SetEntityHeading(PlayerPedId(), 33.0)
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
                    openMenu(v)
                end
            end
        end

        Wait(waiting)
    end
end)