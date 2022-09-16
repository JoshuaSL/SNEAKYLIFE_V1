local NumberCharset = {}
local Charset = {}

for i = 48, 57 do table.insert(NumberCharset, string.char(i)) end
for i = 65, 90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GeneratePlate()
    local generatedPlate
    local doBreak = false
    while boucleVehicle do
        Citizen.Wait(2)
        math.randomseed(GetGameTimer())
        generatedPlate = string.upper(GetRandomLetter(3)..' '..GetRandomNumber(3))
        ESX.TriggerServerCallback('sCardealer:isPlateTaken', function (isPlateTaken)
            if not isPlateTaken then
                doBreak = true
                boucleVehicle = false
            end
        end, generatedPlate)
        if doBreak then
            break
            boucleVehicle = false
        end
    end
    return generatedPlate
end


function IsPlateTaken(plate)
    local callback = 'waiting'
    ESX.TriggerServerCallback('sCardealer:isPlateTaken', function(isPlateTaken)
        callback = isPlateTaken
    end, plate)
    while type(callback) == 'string' do
        Citizen.Wait(0)
    end
    return callback
end


function GetRandomNumber(length)
    Citizen.Wait(1)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
    else
        return ''
    end
end


function GetRandomLetter(length)
    Citizen.Wait(1)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
    else
        return ''
    end
end


function getVehicleType(model)
    return 'car'
end

function CarDealerGetVehicleSale()
    tagetVehicle = {}
    ESX.TriggerServerCallback("sCardealer:getListVehicles", function(getVehicles) 
         for k,v in pairs(getVehicles) do
             table.insert(tagetVehicle,  {label = v.label, name = v.vehicle, price = v.price}) 
         end
     end)
end

function CarDealerGetVehicleNoKey()
    getkeys = {}
    ESX.TriggerServerCallback("Sneakyesx_vehiclelock:getVehiclesnokey", function(Vehicles2) 
        if Vehicles2 == nil then return end
        for i = 1, #Vehicles2, 1 do
            model = Vehicles2[i].model
            modelname = GetDisplayNameFromVehicleModel(model)
            Vehicles2[i].model = GetLabelText(modelname)
        end
        for i = 1, #Vehicles2, 1 do
            table.insert(getkeys,{label = Vehicles2[i].model .. ' [~o~' .. Vehicles2[i].plate .. '~s~]', donated = Vehicles2[i].donated, value = Vehicles2[i].plate}) 
        end
    end)
end

function camCardealer(pos)
    camCardealer = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
    SetCamActive(camCardealer, true)
    SetCamParams(camCardealer, pos, -20.367, 0.0, 112.69622802734, 20.0, 0, 1, 1, 2)
    SetCamFov(camCardealer, 70.0)
    RenderScriptCams(true, false, 2200, 1, 1)
end
function deleteCamCardealer()
    RenderScriptCams(0, 0, 0, 0, 0)
    headingobject = false
end