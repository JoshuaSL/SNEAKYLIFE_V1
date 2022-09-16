ESX = nil
TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('Sneakyesx_phone:registerNumber', 'taxi', 'Appels Taxi', true, true)
TriggerEvent('Sneakyesx_society:registerSociety', 'taxi', 'taxi', 'society_taxi', 'society_taxi', 'society_taxi', {type = 'public'})


local lastPlayerSuccess = {}
local Announce = {
    ["open"] = {
        title = "Taxi",
        subtitle = "~y~Informations~s~",
        message=  "Nous sommes actuellement ~g~disponible~s~ ! Vous pouvez nous contacter .",
        banner = "CHAR_TAXI"
    },
    ["close"] = {
        title = "Taxi",
        subtitle = "~y~Informations~s~",
        message=  "Nous sommes actuellement ~r~indisponible~s~ !",
        banner = "CHAR_TAXI"
    }
}

RegisterNetEvent("sTaxi:addAnnounce")
AddEventHandler("sTaxi:addAnnounce", function(name)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name ~= "taxi" then return end
    if Announce[name] == nil then  return end
    local infosAnnounce = Announce[name]
    TriggerClientEvent("Sneakyesx:showAdvancedNotification", -1, infosAnnounce.title, infosAnnounce.subtitle, infosAnnounce.message, infosAnnounce.banner, 1)
end)

RegisterNetEvent('fTaxi:success')
AddEventHandler('fTaxi:success', function()
    local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name ~= "taxi" then return end

	local timeNow = os.clock()

    if not lastPlayerSuccess[source] or timeNow - lastPlayerSuccess[source] > 5 then
        lastPlayerSuccess[source] = timeNow

        math.randomseed(os.time())
        local total = math.random(75, 230)
        local societyAccount
        
        if xPlayer.job.grade == 1 then
            total = total * 1.2
        elseif xPlayer.job.grade == 2 then
            total = total * 1.4
        elseif xPlayer.job.grade == 3 then
            total = total * 1.6
        else
            total = total
        end


        TriggerEvent('Sneakyesx_addonaccount:getSharedAccount', 'society_taxi', function(account)
            societyAccount=account	
        end)
        
        if societyAccount then
    
            local playerMoney  = ESX.Math.Round(total * 0.4)
            local societyMoney = ESX.Math.Round(total * 0.6)

            xPlayer.addAccountMoney('cash', playerMoney)
            societyAccount.addMoney(societyMoney)
            TriggerClientEvent('Sneakyesx:showNotification', xPlayer.source, "Votre société a gagné "..societyMoney.."~g~$~s~\n- Vous avez gagné "..playerMoney.."~g~$~s~")
        else
            xPlayer.addAccountMoney('cash', total)
            TriggerClientEvent('Sneakyesx:showNotification', xPlayer.source, "Vous avez gagné "..total.."~g~$~s~")
        end
    end
end)