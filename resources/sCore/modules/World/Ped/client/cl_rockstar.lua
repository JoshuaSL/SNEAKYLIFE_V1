local Rockstar = {}
function AddLongString(txt)
	local maxLen = 100
	for i = 0, string.len(txt), maxLen do
		local sub = string.sub(txt, i, math.min(i + maxLen, string.len(txt)))
		AddTextComponentString(sub)
	end
end

function ShowAboveRadarMessage(message, back)
	if back then ThefeedNextPostBackgroundColor(back) end
	SetNotificationTextEntry("jamyfafi")
	AddLongString(message)
	return DrawNotification(0, 1)
end
RMenu.Add('rockstar', 'main', RageUI.CreateMenu("", "Rockstar ~y~editor~s~", 0, 0,"root_cause","sneakylife"))
RMenu:Get('rockstar', 'main').EnableMouse = false
RMenu:Get('rockstar', 'main').Closed = function() Rockstar.Menu = false end
function OpenRockstarEditorMenu()

    if Rockstar.Menu then
        Rockstar.Menu = false
    else
        Rockstar.Menu = true
        RageUI.Visible(RMenu:Get('rockstar', 'main'), true)

        Citizen.CreateThread(function()
			while Rockstar.Menu do
                RageUI.IsVisible(RMenu:Get('rockstar', 'main'), true, false, true, function()
                    RageUI.Button("Lancer un enregistrement", "Lancer une séquence.", {}, true, function(h,a,s)
                        if s then
                            if IsRecording() then
                                ShowAboveRadarMessage("You are already recording a clip, you need to stop recording first before you can start recording again!")
                            else
                                StartRecording(1)
                            end 
                        end
                    end)
                    RageUI.Button("Sauvegarder un enregistrement", "Lancer une séquence.", {}, true, function(h,a,s)
                        if s then
                            if IsRecording() then
                                StartRecording(0)
                                StopRecordingAndSaveClip()
                            else
                                ShowAboveRadarMessage("You are already recording a clip, you need to stop recording first before you can start recording again!")
                            end 
                        end
                    end)
                    RageUI.Button("Effacer l'enregistrement", "Arrêter la séquence." , {}, true, function(h,a,s)
                        if s then
                            if not IsRecording() then
                                ShowAboveRadarMessage("You are currently NOT recording a clip, you need to start recording first before you can stop and save a clip.")
                            else
                                StopRecordingAndDiscardClip()
                            end 
                        end
                    end)
                    RageUI.Button("Lancer le rockstar éditor", "Éditer une séquence.", {}, true, function(h,a,s)
                        if s then 
                            NetworkSessionLeaveSinglePlayer()
			                ActivateRockstarEditor()
                        end
                    end)
                end)
				Wait(0)
			end
		end)
	end
end

RegisterKeyMapping("stream","Rockstar Éditor","keyboard","F3")
RegisterCommand("stream",function()
    OpenRockstarEditorMenu()
end)

