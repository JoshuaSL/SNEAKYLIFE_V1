ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then
        ESX.PlayerData = ESX.GetPlayerData()
    end
end)
local HelicoOption = false
local HeliDispo = {
    GetHashKey("lspdmav"),
    GetHashKey("lssdmav")
}

function tableHasValue(tbl, value, k)
	if not tbl or not value or type(tbl) ~= "table" then return end
	for _,v in pairs(tbl) do
		if k and v[k] == value or v == value then return true, _ end
	end
end

RegisterCommand("helicolight",function()
    if IsPedSittingInAnyVehicle(PlayerPedId()) then
        if tableHasValue(HeliDispo,GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false))) and ESX.PlayerData.job.name == "police" or ESX.PlayerData.job.name == "lssd" then 
            HelicoOption = not HelicoOption
        end
    end
end)
RegisterKeyMapping('helicolight', 'Ouvrir les options hélico', 'keyboard', 'E')

local Light=false

Citizen.CreateThread(function()
    while true do
        if HelicoOption then
            if IsPedSittingInAnyVehicle(PlayerPedId()) then
                Wait(1)
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                if not Light then
                    label = "~g~allumer"
                else
                    label = "~r~éteindre"
                end
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_VEH_HEADLIGHT~ pour "..label.."~s~ la lumière.")
                if IsControlJustPressed(0, 74) then
                    Light = not Light
                    if Light then 
                        SetVehicleSearchlight(veh,true)
                    elseif not Light and IsVehicleSearchlightOn(veh) then 
                        SetVehicleSearchlight(veh,false)
                    end
                end
            else
                HelicoOption = false
            end
        else
            Wait(850)
        end
    end
end)