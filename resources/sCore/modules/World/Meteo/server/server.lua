local CurrenWeather = nil
local BlackoutOver = false
local expiration = 0.5*60*60 -- 30 minutes
local baseTime = 0
local timeOffset = 0
local wtf = os.time()+expiration

Citizen.CreateThread(function()
    SetRandomMeteo()
    while true do 
        Wait(10000)
        if wtf < os.time() then
            wtf = os.time() + expiration
            SetRandomMeteo()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local newBaseTime = os.time(os.date("!*t"))/2 + 360
        if freezeTime then
            timeOffset = timeOffset + baseTime - newBaseTime			
        end
        baseTime = newBaseTime
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        TriggerClientEvent('sMeteo:UpdateTime', -1, baseTime, timeOffset, freezeTime)
    end
end)

function SetRandomMeteo()
    local Percentage = math.random(1,100)
    if Percentage <= 50 then
        value = 'EXTRASUNNY'
    elseif Percentage >= 50 and Percentage <= 55 then 
        value = 'RAIN'
    elseif Percentage >= 55 and Percentage <= 58 then
        value = 'SMOG'
    elseif Percentage >= 58 and Percentage <= 61 then
        value = 'OVERCAST'
    elseif Percentage >= 61 and Percentage <= 64 then
        value = 'CLEAR'
    elseif Percentage >= 64 and Percentage <= 67 then
        value = 'CLOUDS'
    else
        value = 'EXTRASUNNY'
    end
    CurrenWeather = value
    TriggerClientEvent('Meteo:updateWeather', -1, CurrenWeather)
end

RegisterNetEvent('Meteo:RetrieveCurrentWeather')
AddEventHandler('Meteo:RetrieveCurrentWeather', function()
    TriggerClientEvent('Meteo:updateWeather', source, CurrenWeather)
end)

function ShiftToMinute(minute)
    timeOffset = timeOffset - ( ( (baseTime+timeOffset) % 60 ) - minute )
end

function ShiftToHour(hour)
    timeOffset = timeOffset - ( ( ((baseTime+timeOffset)/60) % 24 ) - hour ) * 60
end

license = {
    'license:38f5d72e1a1c7a00a2156a784fb1decce747e89c',
}

function isAllowed(player)
    local allowed = false
    for i,id in ipairs(license) do
        for x,pid in ipairs(GetPlayerIdentifiers(player)) do
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
    end
    return allowed
end

RegisterCommand('time', function(source, args, rawCommand)
    if source == 0 then
        if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
            local argh = tonumber(args[1])
            local argm = tonumber(args[2])
            if argh < 24 then
                ShiftToHour(argh)
            else
                ShiftToHour(0)
            end
            if argm < 60 then
                ShiftToMinute(argm)
            else
                ShiftToMinute(0)
            end
            print("Time has changed to " .. argh .. ":" .. argm .. ".")
            TriggerEvent('vSync:requestSync')
        else
            print("Invalid syntax, correct syntax is: time <hour> <minute> !")
        end
    elseif isAllowed(source) then
        if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
            local argh = tonumber(args[1])
            local argm = tonumber(args[2])
            if argh < 24 then
                ShiftToHour(argh)
            else
                ShiftToHour(0)
            end
            if argm < 60 then
                ShiftToMinute(argm)
            else
                ShiftToMinute(0)
            end
            local newtime = math.floor(((baseTime+timeOffset)/60)%24) .. ":"
            local minute = math.floor((baseTime+timeOffset)%60)
            if minute < 10 then
                newtime = newtime .. "0" .. minute
            else
                newtime = newtime .. minute
            end
            TriggerClientEvent('sMeteo:UpdateTime', -1, baseTime, timeOffset, freezeTime)
        end
    end
end)