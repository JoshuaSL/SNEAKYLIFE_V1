ESX = {};

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)
SneakyEvent = TriggerServerEvent
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(10)
    end
end)

local picture;
local openedVisualCase = false
RMenu.Add('case', 'main', RageUI.CreateMenu("", "", 0, 0,"root_cause","sneakylife"))
RMenu:Get('case', 'main'):SetSubtitle("Caisse de ~b~Sneaky~s~Life")
RMenu:Get('case', 'main').Closed = function()
    openedVisualCase = false
    picture = nil
end

RegisterNetEvent('tebex:on-open-case')
AddEventHandler('tebex:on-open-case', function(animations, name, message)
    openVisualCase()
    Citizen.CreateThread(function()
        Citizen.Wait(250)
        for k, v in pairs(animations) do
            picture = v.name
            RageUI.PlaySound("HUD_FREEMODE_SOUNDSET", "NAV_UP_DOWN")
            if v.time == 5000 then
                RageUI.PlaySound("HUD_AWARDS", "FLIGHT_SCHOOL_LESSON_PASSED")
                ESX.ShowAdvancedNotification('Boutique', 'Informations', message, 'CHAR_SNEAKY', 6, 2)
                Wait(4000)
            end
            Citizen.Wait(v.time)
        end
    end)
    --[[ if name == "sanchez2" or name == "blazer" or name == "patriot2" or name == "seashark3" or name == "avisa" or name == "havok" or name == "rs3sedan" or name == "rrocket" or name == "stryder" or name == "mule3" or name == "longfin" or name == "dodo" or name == "buzzard2" or name == "gtr" or name == "2f2fgtr34" or name == "2f2fgts" or name == "2f2fmk4" or name == "2f2fmle7" or name == "ff4wrx" or name == "fnf4r34" or name == "fnflan" or name == "fnfmits" or name == "fnfrx7" or name == "journeys" or name == "penne" or name == "pigth" or name == "primov12" or name == "remusvert" or name == "strombergsu" or name == "vetog" then
        TriggerEvent("core:RequestGivecar",name)
    end ]]
end)
function openVisualCase()
    if openedVisualCase then
        RageUI.Visible(RMenu:Get('case', 'main'), false)
        openedVisualCase = false
        return
    else
        openedVisualCase = true
        RageUI.Visible(RMenu:Get('case', 'main'), true)
        Citizen.CreateThread(function()
            while openedVisualCase do
                Citizen.Wait(1.0)
                RageUI.IsVisible(RMenu:Get('case', 'main'), true, false, true, function()
                    if (picture) then
                        RageUI.RenderSprite("case", picture)
                    end
                end)
            end
        end)
    end
end


--[[ RegisterNetEvent("core:RequestGivecar")
AddEventHandler("core:RequestGivecar", function(vehicle)
    plate = GeneratePlate()
    props = ESX.Game.GetVehicleProperties(vehicle)
    local props = {
		fuelLevel = 100.0
	}
	ESX.Game.SetVehicleProperties(vehicle, props)
    SneakyEvent("core:Givecar", vehicle, plate, props)
end) ]]