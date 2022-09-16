ESX = nil
TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)

local cacheIdentity = {}

RegisterServerEvent("sIdentity:requestIdentity")
AddEventHandler("sIdentity:requestIdentity", function()
	local _src = source
	TriggerEvent("ratelimit", _src, "sIdentity:requestIdentity")
	if source then
		local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer then
			MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
				['@identifier'] = xPlayer.identifier
			}, function(result)
				if result[1] ~= nil then
					local identityTable = {
						firstname = result[1].firstname,
						lastname = result[1].lastname,
						birthday = result[1].birthday,
						sex = result[1].sex,
						height = result[1].height
					}
					MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @identifier', {
						['@identifier'] = xPlayer.identifier
					}, function(result)
						if result[1] ~= nil then
							licensesTable = result[1]
						else
							licensesTable = {}
						end
					end)
					cacheIdentity[xPlayer.identifier] = {identity = {}, licenses = {}}
					cacheIdentity[xPlayer.identifier].identity = identityTable
					cacheIdentity[xPlayer.identifier].licenses = licensesTable
					TriggerClientEvent("sIdentity:resultRequest", xPlayer.source, cacheIdentity[xPlayer.identifier].identity)
				end
			end)		
		end
	end
end)

RegisterServerEvent('Sneakyjsfour-idcard:open')
AddEventHandler('Sneakyjsfour-idcard:open', function(src, target)
	local _src = source
	TriggerEvent("ratelimit", _src, "Sneakyjsfour-idcard:open")
	local xPlayer = ESX.GetPlayerFromId(src)
	local xPlayerTarget = ESX.GetPlayerFromId(target)
	if cacheIdentity[xPlayer.identifier] == nil then return end 
	TriggerClientEvent("Sneakylife:ShowCard", xPlayerTarget.source, cacheIdentity[xPlayer.identifier].identity, cacheIdentity[xPlayer.identifier].licenses)
end)

function GetIdentityServer(license)
	if license == nil then return end
	if cacheIdentity[license] == nil then return end
	return cacheIdentity[license].identity
end 

function UpdateIdentity(license, newIdentity)
	if license == nil then return end
	if cacheIdentity[license] == nil then return end
	cacheIdentity[license].identity = newIdentity
end

function GetIdentityPlayer(license)
	if license == nil then return end
	if cacheIdentity[license] == nil then return end
	return cacheIdentity[license].identity.firstname.." "..cacheIdentity[license].identity.lastname
end