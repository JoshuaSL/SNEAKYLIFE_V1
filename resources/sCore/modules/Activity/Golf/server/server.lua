ESX = nil

TriggerEvent('Sneakyesx:getSharedObject',function(obj)
    ESX = obj
end)

ESX.RegisterUsableItem('golf',function(source)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        TriggerClientEvent('avGolf:spawnBall', xPlayer.source, 'prop_golf_ball')
    end
end)

ESX.RegisterUsableItem('golf_yellow',function(source)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        TriggerClientEvent('avGolf:spawnBall', xPlayer.source, 'prop_golf_ball_p2')
    end
end)

ESX.RegisterUsableItem('golf_green',function(source)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        TriggerClientEvent('avGolf:spawnBall', xPlayer.source, 'prop_golf_ball_p3')
    end
end)

ESX.RegisterUsableItem('golf_pink',function(source)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        TriggerClientEvent('avGolf:spawnBall', xPlayer.source, 'prop_golf_ball_p4')
    end
end)
