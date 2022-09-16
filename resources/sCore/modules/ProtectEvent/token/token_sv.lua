token = ""

tokenMessage = "\n\nDésynchronisation du serveur, veuillez vous reconnectez .\n\n"

local agrs = {"/","*","-","+","*","ù","%", }
GenerateToken = function()
	local fkapidp = ""
    for i = 1, 20 do
        if math.random(1,10) > 5 then
            fkapidp = fkapidp .. string.upper(string.char(math.random(97, 122))) .. math.random(1,20) .. agrs[math.random(1,#agrs)]
        else
            fkapidp = fkapidp .. string.char(math.random(97, 122)) .. math.random(1,20)
        end
	end
	return fkapidp
end

getToken = function(id, tokenOld)
    if token == tokenOld then
        return true
    else
        return false
    end
end

Citizen.CreateThread(function()
    token = GenerateToken()
    print("Token registered : "..token)
end)

RegisterServerEvent("kToken:requestCache")
AddEventHandler("kToken:requestCache", function()
    local _src = source
    if _src then
        TriggerEvent("ratelimit", _src, "kToken:requestCache")
        print(GetPlayerName(_src).." request to add token (^3"..token.."^0)")
        TriggerClientEvent("kToken:view", _src, token)
    end
end)