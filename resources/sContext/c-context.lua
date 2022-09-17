ESX = nil

local pickups = {}
local entityType = 0
local toIgnore = 0
local flags = 30
local raycastLength = 50.0
local abs = math.abs
local cos = math.cos
local sin = math.sin
local pi = math.pi
local player
local playerCoords
local display = false
local z_key = 243
local startRaycast = false
local lGround = false
local ShowMenu = false
local entity =
{
    target, --Entity itself
    type, --Type: Ped, vehicle, object, 0 1 2 3
    hash, --Hash of the object
    modelName, --model name
    isPlayer, --if the entity is a player = true else = false
    coords, --In world coords
    heading, --Which way the entity is Heading/facing
    rotation -- Entity rotation
}
local previous = entity.target

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterCommand("OpenContextSneakyLife", function(source)
	display = not display
    SetDisplay(display)
end)
RegisterKeyMapping("OpenContextSneakyLife", "Ouvrir le context menu","keyboard", "F2")

--Toggles the NUI
function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

RegisterNUICallback("rightclick", function(data)
    startRaycast = true
end)

RegisterNUICallback("exit", function(data)
    clearEntityData()
    SetDisplay(false)
    startRaycast = false
    showcmenu = false
    ResetEntityAlpha(entity.target)
    ResetEntityAlpha(previous)
end)

local pickup = nil

RegisterNUICallback('info', function(data)
    pickup = data.pickup
    ESX.ShowNotification("~g~Item:\n~w~" .. pickup.label)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        player = GetPlayerPed(-1, false)
        playerCoords = GetEntityCoords(player, 1)
    
        --Disable controls when NUI is active
        if display then
            local hit, endCoords, surfaceNormal, entityHit, entityType, direction = ScreenToWorld(flags, toIgnore)
            entity.target = entityHit


            if previous ~= entity.target then
                ResetEntityAlpha(previous)
                previous = entity.target
            end

            if entity.target and not (player == entity.target) then
                SetEntityAlpha(entity.target, 200, false)
            end


            DisableControlAction(0, 1, display) -- LookLeftRight
            DisableControlAction(0, 2, display) -- LookUpDown
            DisableControlAction(0, 142, display) -- MeleeAttackAlternate
            DisableControlAction(0, 18, display) -- Enter
            DisableControlAction(0, 322, display) -- ESC
            DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
        end
        --Is true when NUI is open and the cursor has be RIGHT CLICKED
        --Shoots a ray from the ped to the cursors position in 3D space
        if startRaycast then
            local hit, endCoords, surfaceNormal, entityHit, entityType, direction = ScreenToWorld(flags, toIgnore)
            --Sets the object and type for the Global variables.
            if entityHit == 0 then --When the ray trace hit the ground or sky it wouldnt clear the type. Ground/sky is target 0. 
                showcmenu = false
                lGround = true
                entityType = 0
                startRaycast = false
            else
                lGround = false
            end
            entity.target = entityHit
            entity.type = entityType
            entity.hash = GetEntityModel(entityHit)
            entity.coords = GetEntityCoords(entityHit, 1)
            entity.heading = GetEntityHeading(entityHit)
            entity.rotation = GetEntityRotation(entityHit)

            if IsEntityAVehicle(entity.target) and not (player == entity.target) then
                SetMouseCursorSprite(4)
            else
                SetMouseCursorSprite(1)
            end

            if IsEntityAVehicle(entity.target) and startRaycast then
                if #(playerCoords - entity.coords) < 5 then
                    showcmenu = true
                    if showcmenu and lGround == false then
                         SendNUIMessage({
                            menu = "vehicle",
                            idEntity = entity.target,
                            entCoords = entity.coords
                        })
                        SetNuiFocus(true, true)
                        startRaycast = false
                    else
                        ResetEntityAlpha(entity.target)
                        ResetEntityAlpha(previous)
                    end
                end
            end

            if IsEntityAPed(entity.target)  then
                if #(playerCoords - entity.coords) < 5 then
                    if lGround == false then
                         SendNUIMessage({
                            menu = "user",
                            idEntity = entity.target,
                            entCoords = entity.coords,
                        })
                        SetNuiFocus(true, true)
                        startRaycast = false
                    else
                        ResetEntityAlpha(entity.target)
                        ResetEntityAlpha(previous)
                    end
                end
            end
        end
    end
end)

local showcmenu = false

--Clearing the entity data to make sure its overwriten on the next menu call.
function clearEntityData()
    entity.target = nil
    entity.type = nil
    entity.hash = nil
    entity.coords = nil
    entity.heading = nil
    entity.rotation = nil
end

--Get closest player
--For anything related to other players the only way to interact with other players using this menu
--is to compare coords with the entity ingame as anything Entity related has nothing to do with other players just a projection of their model/entity.
--E.g If the entity.type is a PED do a coord comparison vs all the players on the server. Then find the closest within maybe a small margin of error.
--IS entity.coords == GetEntityCoords(GetPlayerPed(X), 0) (X being the a player from the GetPlayers() list)
function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)

    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(target, 0)
            --local distance = GetDistanceBetweenCoords(targetCoords['x'], targetCoords['y'], targetCoords['z'], plyCoords['x'], plyCoords['y'], plyCoords['z'], true)
            local distance = #(targetCoords - plyCoords)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end

    return closestPlayer, closestDistance
end

function ScreenToWorld(flags, toIgnore)
    local camRot = GetGameplayCamRot(0)
    local camPos = GetGameplayCamCoord()
    local posX = GetControlNormal(0, 239)
    local posY = GetControlNormal(0, 240)
    local cursor = vector2(posX, posY)
    local cam3DPos, forwardDir = ScreenRelToWorld(camPos, camRot, cursor)
    local direction = camPos + forwardDir * raycastLength
    local rayHandle = StartShapeTestRay(cam3DPos, direction, flags, toIgnore, 0)
    local _, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
    if entityHit >= 1 then
        entityType = GetEntityType(entityHit)
    end
    return hit, endCoords, surfaceNormal, entityHit, entityType, direction
end
 
function ScreenRelToWorld(camPos, camRot, cursor)
    local camForward = RotationToDirection(camRot)
    local rotUp = vector3(camRot.x + 1.0, camRot.y, camRot.z)
    local rotDown = vector3(camRot.x - 1.0, camRot.y, camRot.z)
    local rotLeft = vector3(camRot.x, camRot.y, camRot.z - 1.0)
    local rotRight = vector3(camRot.x, camRot.y, camRot.z + 1.0)
    local camRight = RotationToDirection(rotRight) - RotationToDirection(rotLeft)
    local camUp = RotationToDirection(rotUp) - RotationToDirection(rotDown)
    local rollRad = -(camRot.y * pi / 180.0)
    local camRightRoll = camRight * cos(rollRad) - camUp * sin(rollRad)
    local camUpRoll = camRight * sin(rollRad) + camUp * cos(rollRad)
    local point3DZero = camPos + camForward * 1.0
    local point3D = point3DZero + camRightRoll + camUpRoll
    local point2D = World3DToScreen2D(point3D)
    local point2DZero = World3DToScreen2D(point3DZero)
    local scaleX = (cursor.x - point2DZero.x) / (point2D.x - point2DZero.x)
    local scaleY = (cursor.y - point2DZero.y) / (point2D.y - point2DZero.y)
    local point3Dret = point3DZero + camRightRoll * scaleX + camUpRoll * scaleY
    local forwardDir = camForward + camRightRoll * scaleX + camUpRoll * scaleY
    return point3Dret, forwardDir
end
 
function RotationToDirection(rotation)
    local x = rotation.x * pi / 180.0
    --local y = rotation.y * pi / 180.0
    local z = rotation.z * pi / 180.0
    local num = abs(cos(x))
    return vector3((-sin(z) * num), (cos(z) * num), sin(x))
end
 
function World3DToScreen2D(pos)
    local _, sX, sY = GetScreenCoordFromWorldCoord(pos.x, pos.y, pos.z)
    return vector2(sX, sY)
end