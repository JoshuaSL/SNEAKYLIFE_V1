local TireSpikes = {}
local NumTireSpikes = 0
local MainThreadStatus = false

Citizen.CreateThread(function()
    TriggerServerEvent("mmtirespikes:GetMissingSpikes")
end)

RegisterNetEvent("mmtirespikes:GetMissingSpikes", function(data)
    TireSpikes = data
    for k, v in pairs(TireSpikes) do
        print(k)
        CreateSpike(k, v)
    end
end)

RegisterNetEvent("SneakyLife:useSpikes")
AddEventHandler("SneakyLife:useSpikes", function()
    TriggerEvent("mmtirespike:AddSpike")
end)

RegisterNetEvent("mmtirespike:AddSpike", function()
    local playerPed = PlayerPedId()
    _RequestAnimDict("anim@deathmatch_intros@melee@1h")
    TaskPlayAnim(playerPed, "anim@deathmatch_intros@melee@1h", "intro_male_melee_1h_c", 8.0, 3.0, -1, 1, 1, false, false, false)

    local playerCoords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
    local fCoords = (playerCoords + forward * 2.5)
    local data = GetSpikeDataForSpawn(fCoords, GetEntityHeading(playerPed))

    Citizen.Wait(800)
    TriggerServerEvent("mmtirespikes:CreateSpike", data)
    Citizen.Wait(200)
    ClearPedTasks(playerPed)
    
end)

RegisterNetEvent("mmtirespikes:RemoveSpike", function(id)
    local o = TireSpikes[id]
    if o then
        SetEntityAsMissionEntity(o.prop, true, true)
        DeleteEntity(o.prop)
        NumTireSpikes = NumTireSpikes - 1
        TireSpikes[id] = nil
    end
end)

RegisterNetEvent("mmtirespikes:CreateSpike", function(id, data)
    CreateSpike(id, data)
end)

function CreateSpike(id, data)
    NumTireSpikes = NumTireSpikes + 1
    TireSpikes[id] = data
    _RequestModel("p_ld_stinger_s")
	local obj = CreateObject("p_ld_stinger_s", data.coords.x, data.coords.y, data.coords.z, false, false, false)
    SetEntityCoords(obj, data.coords.x, data.coords.y, data.coords.z)
	SetEntityAsMissionEntity(obj, true, true)
	SetModelAsNoLongerNeeded("p_ld_stinger_s")
	SetEntityRotation(obj, data.rotation.x, data.rotation.y, data.rotation.z, 2, false)
	FreezeEntityPosition(obj, true)
    TireSpikes[id].prop = obj
    MainThread()
end

function AddLongString(txt)
	local maxLen = 100
	for i = 0, string.len(txt), maxLen do
		local sub = string.sub(txt, i, math.min(i + maxLen, string.len(txt)))
		AddTextComponentSubstringPlayerName(sub)
	end
end

function DrawTopNotification(txt, beep)
	BeginTextCommandDisplayHelp("jamyfafi")
	AddLongString(txt)
	EndTextCommandDisplayHelp(0, 0, beep, -1)
end

function MainThread()
	if not MainThreadStatus then
		MainThreadStatus = true
		Citizen.CreateThread(function()
			while NumTireSpikes > 0 do
				local playerPed = PlayerPedId()
				local coords = GetEntityCoords(playerPed)
				local letSleep = true
                local vehicle = GetVehiclePedIsIn(playerPed, false)
                local isInVeh = false
                if DoesEntityExist(vehicle) then
                    if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                        isInVeh = true
                    else
                        isInVeh = false
                    end
                end

                local cDistance = 99999.0
                local cSpike = nil
                local cSpikeIndex = ""

                for k,v in pairs(TireSpikes) do
                    local distance = #(coords - v.coords)
                    if cDistance > distance then
                        cDistance = distance
                        cSpike = v
                        cSpikeIndex = k
                    end
                    if distance < 5 then		
                        if IsPedOnFoot(playerPed) then
                            letSleep = false
                            DrawTopNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~retirer~s~ la herse.")
                            if IsControlPressed(0, 38) then   
                                _RequestAnimDict("pickup_object")
                                TaskPlayAnim(playerPed, "pickup_object", "pickup_low", 8.0, 3.0, -1, 1, 1, false, false, false)
                                Citizen.Wait(800)
                                TriggerServerEvent('mmtirespikes:RemoveSpike', k)
                                Citizen.Wait(300)
                                ClearPedTasks(playerPed)
                            end
                        end
                    end		
                end

                if cSpike ~= nil then
                    if isInVeh then
                        local front_right_d_1, front_right_d_2, front_right_d_3, front_left_d_1, front_left_d_2, front_left_d_3, back_right_d_1, back_right_d_2, back_right_d_3, back_left_d_1, back_left_d_2, back_left_d_3
                        local f_r = GetEntityBoneIndexByName(vehicle, "wheel_rf")
                        local f_l = GetEntityBoneIndexByName(vehicle, "wheel_lf")
                        local b_r = GetEntityBoneIndexByName(vehicle, "wheel_rr")
                        local b_l = GetEntityBoneIndexByName(vehicle, "wheel_lr")
                        
                        local radius = 0.7

                        if f_r ~= -1 then
                            local pos_f_r = GetWorldPositionOfEntityBone(vehicle, f_r) - vector3(0.0, 0.0, GetVehicleWheelTireColliderWidth(vehicle, 0))
                            front_right_d_1 = #(pos_f_r - cSpike.coords_2)
                            front_right_d_2 = #(pos_f_r - cSpike.coords)
                            front_right_d_3 = #(pos_f_r - cSpike.coords_3)
                        end
        
                        if f_l ~= -1 then
                            local pos_f_l = GetWorldPositionOfEntityBone(vehicle, f_l) - vector3(0.0, 0.0, GetVehicleWheelTireColliderWidth(vehicle, 1))
                            front_left_d_1 = #(pos_f_l - cSpike.coords_2)
                            front_left_d_2 = #(pos_f_l - cSpike.coords)
                            front_left_d_3 = #(pos_f_l - cSpike.coords_3)
                        end
        
                        if b_r ~= -1 then
                            local pos_b_r = GetWorldPositionOfEntityBone(vehicle, b_r) - vector3(0.0, 0.0, GetVehicleWheelTireColliderWidth(vehicle, 2))
                            back_right_d_1 = #(pos_b_r - cSpike.coords_2)
                            back_right_d_2 = #(pos_b_r - cSpike.coords)
                            back_right_d_3 = #(pos_b_r - cSpike.coords_3)
                        end
        
                        if b_l ~= -1 then
                            local pos_b_l = GetWorldPositionOfEntityBone(vehicle, b_l) - vector3(0.0, 0.0, GetVehicleWheelTireColliderWidth(vehicle, 3))
                            back_left_d_1 = #(pos_b_l - cSpike.coords_2)
                            back_left_d_2 = #(pos_b_l - cSpike.coords)
                            back_left_d_3 = #(pos_b_l - cSpike.coords_3)
                        end
                        
                        local destroyed_tire = false

                        if front_right_d_1 ~= nil and front_right_d_1 < radius then
                            if not IsVehicleTyreBurst(vehicle, 1, true) then
                                SetVehicleTyreBurst(vehicle, 1, true, 1000)
                                destroyed_tire = true
                            end
                        elseif front_right_d_2 ~= nil and front_right_d_2 < radius then
                            if not IsVehicleTyreBurst(vehicle, 1, true) then
                                SetVehicleTyreBurst(vehicle, 1, true, 1000)
                                destroyed_tire = true
                            end
                        elseif front_right_d_3 ~= nil and front_right_d_3 < radius then
                            if not IsVehicleTyreBurst(vehicle, 1, true) then
                                SetVehicleTyreBurst(vehicle, 1, true, 1000)
                                destroyed_tire = true
                            end
                        end
        
                        if front_left_d_1 ~= nil and front_left_d_1 < radius then
                            if not IsVehicleTyreBurst(vehicle, 0, true) then
                                SetVehicleTyreBurst(vehicle, 0, true, 1000)
                                destroyed_tire = true
                            end
                        elseif front_left_d_2 ~= nil and front_left_d_2 < radius then
                            if not IsVehicleTyreBurst(vehicle, 0, true) then
                                SetVehicleTyreBurst(vehicle, 0, true, 1000)
                                destroyed_tire = true
                            end
                        elseif front_left_d_3 ~= nil and front_left_d_3 < radius then
                            if not IsVehicleTyreBurst(vehicle, 0, true) then
                                SetVehicleTyreBurst(vehicle, 0, true, 1000)
                                destroyed_tire = true
                            end
                        end
        
                        if back_right_d_1 ~= nil and back_right_d_1 < radius then
                            if not IsVehicleTyreBurst(vehicle, 5, true) then
                                SetVehicleTyreBurst(vehicle, 5, true, 1000)
                                destroyed_tire = true
                            end
                        elseif back_right_d_2 ~= nil and back_right_d_2 < radius then
                            if not IsVehicleTyreBurst(vehicle, 5, true) then
                                SetVehicleTyreBurst(vehicle, 5, true, 1000)
                                destroyed_tire = true
                            end
                        elseif back_right_d_3 ~= nil and back_right_d_3 < radius then
                            if not IsVehicleTyreBurst(vehicle, 5, true) then
                                SetVehicleTyreBurst(vehicle, 5, true, 1000)
                                destroyed_tire = true
                            end
                        end
        
                        if back_left_d_1 ~= nil and back_left_d_1 < radius then
                            if not IsVehicleTyreBurst(vehicle, 4, true) then
                                SetVehicleTyreBurst(vehicle, 4, true, 1000)
                                destroyed_tire = true
                            end
                        elseif back_left_d_2 ~= nil and back_left_d_2 < radius then
                            if not IsVehicleTyreBurst(vehicle, 4, true) then
                                SetVehicleTyreBurst(vehicle, 4, true, 1000)
                                destroyed_tire = true
                            end
                        elseif back_left_d_3 ~= nil and back_left_d_3 < radius then
                            if not IsVehicleTyreBurst(vehicle, 4, true) then
                                SetVehicleTyreBurst(vehicle, 4, true, 1000)
                                destroyed_tire = true
                            end
                        end
                    end
                end
        
                if letSleep then
                    if isInVeh then
                        if cDistance > 60.0 then
                            Citizen.Wait(500)
                        elseif cDistance > 40.0 then
                            Citizen.Wait(300)
                        elseif cDistance > 20.0 then
                            Citizen.Wait(100)
                        else
                            Citizen.Wait(0)
                        end
                    else
                        Citizen.Wait(500)
                    end
                else
                    Citizen.Wait(0)
                end
            end
			MainThreadStatus = false
		end)
	end
end

function _RequestModel(model)
	RequestModel(model)
	local _init = GetGameTimer()
	while not HasModelLoaded(model) and GetGameTimer() - _init < 500 do
		Citizen.Wait(0)
	end
end

function _RequestAnimDict(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(0)
	end
end

function _ShowNotification(text)
	SetNotificationTextEntry("CELL_EMAIL_BCON")
	AddTextComponentSubstringPlayerName(text)
	DrawNotification(false, true)
end

function GetSpikeDataForSpawn(coords, heading)
	_RequestModel("p_ld_stinger_s")
	local obj = CreateObject("p_ld_stinger_s", coords.x, coords.y, coords.z, false, false, false)
	SetEntityAsMissionEntity(obj, true, true)
	SetModelAsNoLongerNeeded("p_ld_stinger_s")
	SetEntityHeading(obj, heading)
	PlaceObjectOnGroundProperly(obj)
	FreezeEntityPosition(obj, true)
    Citizen.Wait(0)
	local retun_data = {
		coords = GetEntityCoords(obj),
        coords_2 = GetOffsetFromEntityInWorldCoords(obj, 0.0, 1.2, 0.0),
		coords_3 = GetOffsetFromEntityInWorldCoords(obj, 0.0, -1.2, 0.0),
		rotation = GetEntityRotation(obj)
	}
	DeleteEntity(obj)
	return retun_data
end