ESX = nil
TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
    local Trig={}
    AddEventHandler('ratelimit',function(a,b)
        local c=source;
        local d="unknown"
        local e="unknown"
        local f="unknown"
        local g="unknown"
        local h="unknown"
        local i="unknown"
        local j="unknown"
        for k,l in ipairs(GetPlayerIdentifiers(a))do 
            if l:match("steam")then 
                d=l elseif 
                l:match("discord")then 
                    e=l:gsub("discord:","")elseif 
                    l:match("license")then f=l 
                    elseif l:match("live")then g=l elseif 
                        l:match("xbl")then 
                            i=l 
                        elseif l:match("ip")then 
                            j=l:gsub("ip:","")
                        end 
                    end;
                    local m=GetPlayerName(a)
                    if Trig[a]~=nil then 
                        local xPlayer = ESX.GetPlayerFromId(a)
                        if Trig[a]~='off'then 
                            if Trig[a]==ConfigEventProtect.RateLimit then 
                                --print("Le joueur "..GetPlayerName(xPlayer.source).." vient de se faire détecter pour spam trigger : "..b)
                                Trig[a]='off'
                            else 
                                Trig[a]=Trig[a]+1 
                            end 
                        else 
                            --print("Le joueur "..GetPlayerName(xPlayer.source).." vient de se faire détecter pour spam trigger : "..b)
                        end 
                    else 
                        Trig[a]=1 
                    end 
                end)
        CountTrig()
    end)

    function CountTrig()
        Trig={}
        SetTimeout(ConfigEventProtect.ResetRateLimit,CountTrig)
    end