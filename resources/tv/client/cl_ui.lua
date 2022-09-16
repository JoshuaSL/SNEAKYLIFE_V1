UI = UI or {}
UI.Entry = nil
UI.EnableFocus = false 

function UI:SetNuiFocus(bool, bool2)
	UI.EnableFocus = bool
	SetNuiFocus(bool, bool2)

	if UI.EnableFocus then
		Citizen.CreateThread(function()
			while UI.EnableFocus == true do

				for i = 30, 37 do
					DisableControlAction(0, i, true)
				end

				DisablePlayerFiring(PlayerId(), true)
				Citizen.Wait(0)
			end
		end)
	end
end

RegisterNetEvent("cTV:ToggleNui")
AddEventHandler("cTV:ToggleNui", function(data, focus, focus2, cb)
	SendNUIMessage(data)
	if focus ~= nil or focus2 ~= nil then
		UI:SetNuiFocus(focus, focus2)
	end

	if cb then UI.Entry = cb end

	local ped = GetPlayerPed(-1)
	if focus == true and not IsPedStill(ped) then 
		ForcePedMotionState(ped, "motionstate_idle") 
	end
end)

RegisterNUICallback("onEntry", function(data, cb)
	local id, inputs = data.id, data.inputs
	if id == 1 then
		if not UI.Entry then return end
		UI.Entry(inputs)
	end
	if UI.EnableFocus then 
		UI:SetNuiFocus() 
	end
	cb("ok")
end)

RegisterCommand("unfocus", function()
	UI:SetNuiFocus(false, false)
end)