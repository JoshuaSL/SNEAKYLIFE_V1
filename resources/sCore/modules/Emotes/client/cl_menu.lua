ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        Wait(10)
        TriggerEvent("esx:getSharedObject", function(niceESX) ESX = niceESX end)
    end
end)
local function GetPlayers()
	local players = {}

	for _,player in ipairs(GetActivePlayers()) do
		if DoesEntityExist(GetPlayerPed(player)) then
			table.insert(players, player)
		end
	end

	return players
end
ShowNotification = function(e)
    SetNotificationTextEntry('STRING')
    AddTextComponentSubstringPlayerName(e)
    DrawNotification(false, true)
end;
local filterArray = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" }
local filter = 1
local function starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end
local f = true;
local function GetClosestPlayer(distance)
    for k, v in pairs(GetPlayers()) do
        local target = GetPlayerPed(v)

        if target ~= PlayerPedId() and GetDistanceBetweenCoords(GetEntityCoords(target), GetEntityCoords(PlayerPedId())) <= distance and IsEntityVisible(target) then
            return v
        end
    end

    return false
end
local l, m, n = {}, {}, {}
local o = false;
local function p() if #m > 0 then for c, j in pairs(m) do DeleteEntity(j) end end end
local function q(r, s, t, u, v, w, x, y)
    local z = GetHashKey(r)
    while not HasModelLoaded(z) do
        RequestModel(z)
        Wait(10)
    end
    prop = CreateObject(z, GetEntityCoords(PlayerPedId()), true, true, true)
    SetEntityAsMissionEntity(prop, true, false)
    AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), s),t, u, v, w, x, y, true, true, false, true, 1, true)
    table.insert(m, prop)
    SetModelAsNoLongerNeeded(z)
end
local function A()
    o = false;
    p()
end
local function B(C, D, E, F, G, H, I, J, K, L, M, N)
    o = true;
    while o do
        Wait(5)
        if IsControlPressed(0, 47) then
            while not HasNamedPtfxAssetLoaded(E) do
                RequestNamedPtfxAsset(E)
                Wait(10)
            end
            UseParticleFxAssetNextCall(E)
            local O = StartNetworkedParticleFxLoopedOnEntityBone(F, G and PlayerPedId() or prop, H, I, J, K, L, M,GetEntityBoneIndexByName(F, "VFX"),1065353216, 0,0, 0,1065353216,1065353216,1065353216, 0)
            SetParticleFxLoopedColour(O, 1.0, 1.0, 1.0)
            table.insert(n, O)
            Wait(C)
            for P, Q in pairs(n) do
                StopParticleFxLooped(Q, false)
                table.remove(n, P)
            end
        else
            ESX.ShowHelpNotification(D)
        end
    end
end

function TaskPlayAnimToPlayer(a, b, c, d, e)
    if type(a) ~= "table" then a = {a} end
    d, c = d or GetPlayerPed(-1), c and tonumber(c) or false;
    if not a or not a[1] or string.len(a[1]) < 1 then return end
    if IsEntityPlayingAnim(d, a[1], a[2], 3) or IsPedActiveInScenario(d) then
        ClearPedTasks(d)
        return
    end
    Citizen.CreateThread(function()
        TaskForceAnimPlayer(a, c, {ped = d, time = b, pos = e})
    end)
end
local f = {"WORLD_HUMAN_MUSICIAN", "WORLD_HUMAN_CLIPBOARD"}
local g = {
    ["WORLD_HUMAN_BUM_WASH"] = {"amb@world_human_bum_wash@male@high@idle_a", "idle_a"},
    ["WORLD_HUMAN_SIT_UPS"] = {"amb@world_human_sit_ups@male@idle_a", "idle_a"},
    ["WORLD_HUMAN_PUSH_UPS"] = {"amb@world_human_push_ups@male@base", "base"},
    ["WORLD_HUMAN_BUM_FREEWAY"] = {"amb@world_human_bum_freeway@male@base", "base"},
    ["WORLD_HUMAN_CLIPBOARD"] = {"amb@world_human_clipboard@male@base", "base"},
    ["WORLD_HUMAN_VEHICLE_MECHANIC"] = {"amb@world_human_vehicle_mechanic@male@base", "base"}
}
function TaskForceAnimPlayer(a, c, h)
    c, h = c and tonumber(c) or false, h or {}
    local d, b, i, j, k, l = h.ped or GetPlayerPed(-1), h.time, h.clearTasks,
                             h.pos, h.ang;
    if IsPedInAnyVehicle(d) and (not c or c < 40) then return end
    if not i then ClearPedTasks(d) end
    if not a[2] and g[a[1]] and GetEntityModel(d) == -1667301416 then
        a = g[a[1]]
    end
    if a[2] and not HasAnimDictLoaded(a[1]) then
        if not DoesAnimDictExist(a[1]) then return end
        RequestAnimDict(a[1])
        while not HasAnimDictLoaded(a[1]) do Citizen.Wait(10) end
    end
    if not a[2] then
        ClearAreaOfObjects(GetEntityCoords(d), 1.0)
        TaskStartScenarioInPlace(d, a[1], -1, not TableHasValue(f, a[1]))
    else
        if not j then
            TaskPlayAnim(d, a[1], a[2], 8.0, -8.0, -1, c or 44, 1, 0, 0, 0, 0)
        else
            TaskPlayAnimAdvanced(d, a[1], a[2], j.x, j.y, j.z, k.x, k.y, k.z,
                                 8.0, -8.0, -1, 1, 1, 0, 0, 0)
        end
    end
    if b and type(b) == "number" then
        Citizen.Wait(b)
        ClearPedTasks(d)
    end
    if not h.dict then RemoveAnimDict(a[1]) end
end
function TableHasValue(m, n, o)
    if not m or not n or type(m) ~= "table" then return end
    for p, q in pairs(m) do
        if o and q[o] == n or q == n then return true, p end
    end
end


local function R(Infos)
    if Infos ~= false then
        local S, T = 0, -1;
        local U, V, W = table.unpack(Infos)
        A()
        if U == "Expression" then
            SetFacialIdleAnimOverride(PlayerPedId(), V, 0)
            TriggerEvent("Animations:upFacial",true,V)
            if V == "default" then
                TriggerEvent("Animations:upFacial",true,"default")
                ClearFacialIdleAnimOverride(PlayerPedId())
            end
            return
        end
        if (U == "MaleScenario" or "Scenario") and
            not IsPedInAnyVehicle(PlayerPedId(), false) then
            if U == "MaleScenario" then
                if GetEntityModel(PlayerPedId()) ==
                    GetHashKey("mp_m_freemode_01") then
                    TaskPlayAnimToPlayer(V, nil, 0)
                else
                    ShowNotification("~r~Cet emote est réservé aux hommes.")
                end
                return
            elseif U == "ScenarioObject" then
                TaskStartScenarioAtPosition(PlayerPedId(), V,GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0 - 0.5,-0.5),GetEntityHeading(PlayerPedId()), 0,1, false)
                return
            elseif U == "Scenario" then
                TaskPlayAnimToPlayer(V, nil, 0)
                return
            end
        end
        while not HasAnimDictLoaded(U) do
            RequestAnimDict(U)
            Wait(10)
        end
        if Infos.AnimationOptions then
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                S = 51
            elseif Infos.AnimationOptions.EmoteMoving then
                S = 51
            elseif Infos.AnimationOptions.EmoteLoop then
                S = 1
            elseif Infos.AnimationOptions.EmoteStuck then
                S = 50
            end
            if Infos.AnimationOptions.EmoteDuration ~= nil then
                T = Infos.AnimationOptions.EmoteDuration
            end
        end
        local X = {U, V}
        TaskPlayAnimToPlayer(X, nil, S)
        RemoveAnimDict(U)
        if Infos.AnimationOptions then
            if Infos.AnimationOptions.Prop then
                Wait(T)
                q(Infos.AnimationOptions.Prop, Infos.AnimationOptions.PropBone,
                  table.unpack(Infos.AnimationOptions.PropPlacement))
                if Infos.AnimationOptions.SecondProp then
                    q(Infos.AnimationOptions.SecondProp,
                      Infos.AnimationOptions.SecondPropBone,
                      table.unpack(Infos.AnimationOptions.SecondPropPlacement))
                end
            end
            if Infos.AnimationOptions.PtfxAsset then
                Wait(1000)
                B(Infos.AnimationOptions.PtfxWait,
                  Infos.AnimationOptions.PtfxInfo,
                  Infos.AnimationOptions.PtfxAsset,
                  Infos.AnimationOptions.PtfxName,
                  Infos.AnimationOptions.PtfxNoProp,
                  table.unpack(Infos.AnimationOptions.PtfxPlacement))
            end
        end
    end
end
local function Y(Infos)
    RequestAnimSet(Infos[1])
    while not HasAnimSetLoaded(Infos[1]) do Citizen.Wait(1) end
    SetPedMovementClipset(PlayerPedId(), Infos[1], 0.2)
    RemoveAnimSet(Infos[1])
    TriggerEvent("Animations:upDemarche",true,Infos[1])
    if Infos[1] == "move_f@multiplayer" or Infos[1] == "move_m@multiplayer" then
        ResetPedMovementClipset(PlayerPedId(), 0)
        TriggerEvent("Animations:upDemarche",true,"default")
    end
end
local function AnimShared(Infos, ListId)
    local target = GetClosestPlayer(3)
    if target then
        TriggerServerEvent("sCore:RequestEmote", GetPlayerServerId(target), ListId, Infos[3])
    else
        ShowNotification("~b~Distance\n~w~Rapprochez-vous.")
    end
end
RegisterNetEvent("ClientEmoteRequestReceive")
AddEventHandler("ClientEmoteRequestReceive", function(a0, a1)
    PlaySound(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 0, 0, 1)
    ShowNotification("~y~X~w~ accepter, ~r~L~w~ refuser (~g~"..a1.."~w~)")
    local isRequestAnim = 1;
    while isRequestAnim <= 100 do
        Citizen.Wait(5)
        isRequestAnim = isRequestAnim + 1
        if IsControlJustPressed(1, 120) then
            TriggerServerEvent("sCore:ValidServer", GetPlayerServerId(GetClosestPlayer(3)), a0)
        elseif IsControlJustPressed(1, 182) then
            ShowNotification("~r~Emote refusée.")
        end
    end
end)
RegisterNetEvent("cAnimTaskAnimPlayer")
AddEventHandler("cAnimTaskAnimPlayer", function(a3, a4)
    local pedInFront = GetPlayerPed(GetClosestPlayer(3))
    local coords = GetOffsetFromEntityInWorldCoords(pedInFront, 0.0, 1.0, 0.0)
    if AnimList.Partage[a3].AnimationOptions.SyncOffsetFront then
        coords = GetOffsetFromEntityInWorldCoords(pedInFront, 0.0, AnimList.Partage[a3].AnimationOptions.SyncOffsetFront, 0.0)
    end
    SetEntityHeading(PlayerPedId(), GetEntityHeading(pedInFront) - 180.1)
    SetEntityCoordsNoOffset(PlayerPedId(), coords.x, coords.y, coords.z, 0)
    R(AnimList.Partage[a3])
end)
local function a7(a8, Infos)
    if not Infos then
        DeleteResourceKvp(string.format('animBind%s', a8))
    else
        SetResourceKvp(string.format('animBind%s', a8),tostring(Infos.Dict) .. "," .. tostring(Infos.ListId))
    end
    local a9 = {}
    local aa = GetResourceKvpString(string.format('animBind%s', a8))
    if aa ~= nil then
        for ab in aa:gmatch('([^,]+)') do table.insert(a9, ab) end
        if a9[1] and a9[2] then
            l[a8] = {Assign = true, Anim = AnimList[a9[1]][a9[2]]}
        else
            l[a8] = {Assign = false, Anim = false}
        end
    else
        l[a8] = {Assign = false, Anim = false}
    end
end
RegisterNetEvent('cAnim:CanAnimBind')
AddEventHandler('cAnim:CanAnimBind', function(ac) f = ac end)
local function ad()
    for ae = 1, 9 do
        local a9 = {}
        local aa = GetResourceKvpString(string.format('animBind%s', ae))
        if aa ~= nil then
            for ab in aa:gmatch('([^,]+)') do table.insert(a9, ab) end
            if a9[1] and a9[2] then
                a7(ae, {Dict = a9[1], ListId = a9[2]})
            else
                a7(ae, false)
            end
        else
            a7(ae, false)
        end
        RegisterKeyMapping(string.format('animBind%s', ae),string.format("Jouer l'animation n°%s", ae),"keyboard", string.format("NUMPAD%s", ae))
        RegisterCommand(string.format('animBind%s', ae), function()
            if not exports.inventaire:GetStateInventory() and not GetStateFishing() then
                if l[ae].Assign then
                    if l[ae].Anim.Dict == "Demarches" then
                        Y(l[ae].Anim)
                    else
                        local af = l[ae].Anim;
                        local S, T = 0, -1;
                        local U, V, W = table.unpack(af)
                        if not f then return end
                        if U == "Expression" then
                            SetFacialIdleAnimOverride(PlayerPedId(), V, 0)
                            return
                        end
                        if (U == "MaleScenario" or "Scenario") and
                            not IsPedInAnyVehicle(PlayerPedId(), false) then
                            if U == "MaleScenario" then
                                if GetEntityModel(PlayerPedId()) ==
                                    GetHashKey("mp_m_freemode_01") then
                                    TaskPlayAnimToPlayer(V, nil, 0)
                                else
                                    ShowNotification("~r~Cet emote est réservé aux hommes.")
                                end
                                return
                            elseif U == "ScenarioObject" then
                                TaskStartScenarioAtPosition(PlayerPedId(), V,GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0,0 - 0.5, -0.5),GetEntityHeading(PlayerPedId()), 0,1, false)
                                return
                            elseif U == "Scenario" then
                                TaskPlayAnimToPlayer(V, nil, 0)
                                return
                            end
                        end
                        if af.AnimationOptions then
                            if IsPedInAnyVehicle(PlayerPedId(), false) then
                                S = 51
                            elseif af.AnimationOptions.EmoteMoving then
                                S = 51
                            elseif af.AnimationOptions.EmoteLoop then
                                S = 1
                            elseif af.AnimationOptions.EmoteStuck then
                                S = 50
                            end
                            if af.AnimationOptions.EmoteDuration ~= nil then
                                T = af.AnimationOptions.EmoteDuration
                            end
                        end
                        local X = {U, V}
                        TaskPlayAnimToPlayer(X, nil, S)
                    end
                end
            end
        end)
    end
end

local Animations = {}

RMenu.Add('animation', 'main', RageUI.CreateMenu("", "~b~Animations", 0, 0,'root_cause',"sneakylife"))
RMenu.Add('animation', 'ai', RageUI.CreateSubMenu(RMenu:Get('animation', 'main'), "", "~b~Animations"))
RMenu.Add('animation', 'aj', RageUI.CreateSubMenu(RMenu:Get('animation', 'ai'), "", "~b~Animations"))
RMenu:Get('animation', 'main').EnableMouse = false
local al = {
    {name = "Jouer l'animation", submenu = false},
    {name = "Annuler l'animation", submenu = false},
    {name = "Bind l'animation", submenu = ak},
    {name = "Supprimer l'animation des binds", submenu = ak}
}
RMenu:Get('animation', 'main').Closed = function() 
    Animations.Menu = false 
end

function agggg()

    if Animations.Menu then
        Animations.Menu = false
    else
        Animations.Menu = true
        RageUI.Visible(RMenu:Get('animation', 'main'), true)

        Citizen.CreateThread(function()
			while Animations.Menu do
                RageUI.IsVisible(RMenu:Get('animation', 'main'), true, false, true, function()
                    RageUI.Button("Annuler l'animation", false, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            ClearPedTasks(GetPlayerPed(-1))
                            o = false;
                            p()
                        end
                    end)
                    for am, an in pairs(AnimList) do
                        RageUI.Button(am, nil, {RightLabel = "→"}, true,function(h,a,s)
                            if s then
                                filterString = nil
                                Infos = {Dict = am}
                            end
                        end,RMenu:Get("animation","ai"))
                    end
                end)
                RageUI.IsVisible(RMenu:Get('animation', 'ai'), true, false, true, function()
                    RageUI.List("Filtre:", filterArray, filter, nil, {}, true, function(_, _, _, i)
                        filter = i
                    end)
                    if Infos ~= nil then
                        for ao, ap in pairs(AnimList[Infos.Dict]) do
                            if Infos.Dict ~= "Expressions" and Infos.Dict ~= "Demarches" then
                                if starts(ap[3]:lower(), filterArray[filter]:lower()) then
                                    RageUI.Button((Infos.Dict == "Expressions" or Infos.Dict == "Demarches") and ao or ap[3], ao, {RightLabel = "→"},true, function(h,a,s)
                                        if s then
                                            Infos = {
                                                Dict = Infos.Dict,
                                                ListId = ao,
                                                infos = AnimList[Infos.Dict][ao]
                                            }
                                            mainAJ = true
                                        end
                                    end,RMenu:Get("animation","aj"))
                                end
                            else
                                if starts(ao:lower(), filterArray[filter]:lower()) then
                                    RageUI.Button((Infos.Dict == "Expressions" or Infos.Dict == "Demarches") and ao or ap[3], ao, {RightLabel = "→"},true, function(h,a,s)
                                        if s then
                                            Infos = {
                                                Dict = Infos.Dict,
                                                ListId = ao,
                                                infos = AnimList[Infos.Dict][ao]
                                            }
                                            mainAJ = true
                                        end
                                    end,RMenu:Get("animation","aj"))
                                end
                            end
                        end
                    end
                end)
                RageUI.IsVisible(RMenu:Get('animation', 'aj'), true, false, true, function()
                    if mainAJ then
                        for aq, ar in pairs(al) do
                            RageUI.Button(ar.name, ar.name, {RightLabel = "→"}, true,function(h,a,s)
                                if s then
                                    if ar.name == "Annuler l'animation" then
                                        ClearPedTasks(GetPlayerPed(-1))
                                        o = false;
                                        p()
                                        if Infos.Dict == "Demarches" then
                                            ResetPedMovementClipset(PlayerPedId(), 0)
                                        elseif Infos.Dict == "Expression" then
                                            ClearFacialIdleAnimOverride(PlayerPedId())
                                        end
                                    elseif ar.name == "Jouer l'animation" then
                                        if Infos.Dict == "Demarches" then
                                            Y(Infos.infos)
                                        elseif Infos.Dict == "Partage" then
                                            AnimShared(Infos.infos, Infos.ListId)
                                        else
                                            R(Infos.infos)
                                        end
                                    else
                                        Infos = {
                                            NameMenu = ar.name,
                                            Dict = Infos.Dict,
                                            ListId = Infos.ListId,
                                            infos = Infos.infos,
                                        }
                                        mainAJ = false
                                    end
                                end
                            end)
                        end
                    else
                        for a8, ar in ipairs(l) do
                            if Infos.NameMenu == "Bind l'animation" and not ar.Assign then
                                RageUI.Button("Touches n°" .. a8,"Assigner l'animation à cette touche",{RightLabel = "→"}, true, function(h,a,s)
                                    if s then
                                        RageUI.GoBack()
                                        ShowNotification("Vous avez bind l'animations: ~b~" ..Infos.ListId .. "~s~ sur la touche: ~b~" ..a8 .. "~s~.")
                                        a7(a8, {Dict = Infos.Dict, ListId = Infos.ListId})
                                    end
                                end)
                            elseif Infos.NameMenu == "Supprimer l'animation des binds" and ar.Assign then
                                RageUI.Button("Touches n°" .. a8,"Supprimer l'animation à cette touche",{RightLabel = "→"}, true, function(h,a,s)
                                    if s then
                                        ShowNotification("~r~Vous avez supprimé une animations sur la touche: ~b~" ..a8 .. "~s~.")
                                        a7(a8, false)
                                    end
                                end)
                            end
                        end    
                    end
                end)
				Wait(0)
			end
		end)
	end
end



function KeyboardInputEmotes(TextEntry, ExampleText, MaxStringLength)

	AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end


RegisterKeyMapping("animmenu", "Ouvrir le menu des animations (Bind)","keyboard", "K")
RegisterCommand("animmenu", function() 
    if not exports.inventaire:GetStateInventory() and not GetStateFishing() then
        agggg() 
    end
end)
ad()

RegisterNetEvent('Animations:loadsave')
AddEventHandler('Animations:loadsave', function(demarche, humeur)
	local demarcheAncien = GetResourceKvpString(string.format("demarcheAo"))
	local humeurAncien = GetResourceKvpString(string.format("humeurAo"))
	if demarche and demarcheAncien ~= "default" then
        RequestAnimSet(demarcheAncien)
        while not HasAnimSetLoaded(demarcheAncien) do 
            Citizen.Wait(1) 
        end
		SetPedMovementClipset(GetPlayerPed(-1),demarcheAncien,0)
	end
	if humeur and humeurAncien ~= "default" then 
		SetFacialIdleAnimOverride(GetPlayerPed(-1),humeurAncien,0)
	end
end)

RegisterNetEvent('Animations:upDemarche')
AddEventHandler('Animations:upDemarche', function(demarche,hm01)
	if demarche and hm01 ~= "default" then 
		SetResourceKvp("demarcheAo", hm01)
	end
	if hm01 == "default" then 
		SetResourceKvp("demarcheAo", "default")
	end
end)

RegisterNetEvent('Animations:upFacial')
AddEventHandler('Animations:upFacial', function(humeur,hm02)
	if humeur and hm02 ~= "default" then 
		SetResourceKvp("humeurAo", hm02)
	end
	if hm02 == "default" then 
		SetResourceKvp("humeurAo", "default")
	end
end)
