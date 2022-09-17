local Accounts, SharedAccounts = {}, {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM addon_account', {}, function(result)
		for i = 1, #result, 1 do
			local name = result[i].name
			local label = result[i].label
			local shared = result[i].shared

			MySQL.Async.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @account_name', {
				['@account_name'] = name
			}, function(result2)
				if shared == 0 then
					Accounts[name] = {}

					for j = 1, #result2, 1 do
						table.insert(Accounts[name], CreateAddonAccount(name, result2[j].owner, result2[j].money))
					end
				else
					local money = nil

					if #result2 == 0 then
						MySQL.Async.execute('INSERT INTO addon_account_data (account_name, money, owner) VALUES (@account_name, @money, NULL)', {
							['@account_name'] = name,
							['@money'] = 0
						})

						money = 0
					else
						money = result2[1].money
					end

					SharedAccounts[name] = CreateAddonAccount(name, nil, money)
				end
			end)
		end
	end)
end)

function GetAccount(name, owner)
	for i = 1, #Accounts[name], 1 do
		if Accounts[name][i].owner == owner then
			return Accounts[name][i]
		end
	end

	MySQL.Async.execute('INSERT INTO addon_account_data (account_name, money, owner) VALUES (@account_name, @money, @owner)', {
		['@account_name'] = name,
		['@money'] = 0,
		['@owner'] = owner
	})

	local account = CreateAddonAccount(name, owner, 0)
	table.insert(Accounts[name], account)
	return account
end

function GetSharedAccount(name)
	return SharedAccounts[name]
end

AddEventHandler('Sneakyesx_addonaccount:getAccount', function(name, owner, cb)
	cb(GetAccount(name, owner))
end)

AddEventHandler('Sneakyesx_addonaccount:getSharedAccount', function(name, cb)
	cb(GetSharedAccount(name))
end)

Items = {}
local Inventories, SharedInventories = {}, {}, {}


MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM items', {}, function(result)
		for i = 1, #result, 1 do
			Items[result[i].name] = result[i].label
		end

		MySQL.Async.fetchAll('SELECT * FROM addon_inventory', {}, function(result2)
			for i = 1, #result2, 1 do
				local name = result2[i].name
				local label = result2[i].label
				local shared = result2[i].shared
		
				MySQL.Async.fetchAll('SELECT * FROM addon_inventory_items WHERE inventory_name = @inventory_name', {
					['@inventory_name'] = name
				}, function(result3)
					if shared == 0 then
						Inventories[name] = {}
						local items = {}

						for j = 1, #result3, 1 do
							local itemName = result3[j].name
							local itemCount = result3[j].count
							local itemOwner = result3[j].owner

							if items[itemOwner] == nil then
								items[itemOwner] = {}
							end

							table.insert(items[itemOwner], {
								name = itemName,
								count = itemCount,
								label = Items[itemName]
							})
						end

						for k, v in pairs(items) do
							table.insert(Inventories[name], CreateAddonInventory(name, k, v))
						end
					else
						local items = {}

						for j = 1, #result3, 1 do
							table.insert(items, {
								name = result3[j].name,
								count = result3[j].count,
								label = Items[result3[j].name]
							})
						end

						SharedInventories[name] = CreateAddonInventory(name, nil, items)
					end
				end)
			end
		end)
	end)
end)

function GetInventory(name, owner)
	for i = 1, #Inventories[name], 1 do
		if Inventories[name][i].owner == owner then
			return Inventories[name][i]
		end
	end

	local inventory = CreateAddonInventory(name, owner, {})
	table.insert(Inventories[name], inventory)
	return inventory
end

function GetSharedInventory(name)
	return SharedInventories[name]
end

AddEventHandler('Sneakyesx_addoninventory:getInventory', function(name, owner, cb)
	cb(GetInventory(name, owner))
end)

AddEventHandler('Sneakyesx_addoninventory:getSharedInventory', function(name, cb)
	cb(GetSharedInventory(name))
end)

local PhoneNumbers = {}

function notifyAlertSMS(number, alert, listSrc)
	if PhoneNumbers[number] ~= nil then
		local mess = 'De #' .. alert.numero  .. ' : ' .. alert.message

		if alert.coords ~= nil then
			mess = mess .. ' ' .. alert.coords.x .. ', ' .. alert.coords.y 
		end

		for k, v in pairs(listSrc) do
			getPhoneNumber(tonumber(k), function(n)
				if n ~= nil then
					TriggerEvent('phone:_internalAddMessageSneakyJob', number, n, mess, 0, function(smsMess)
						TriggerClientEvent("phone:receiveMessage", tonumber(k), smsMess)
					end)
				end
			end)
		end
	end
end

AddEventHandler('Sneakyesx_phone:registerNumber', function(number, type, sharePos, hasDispatch, hideNumber, hidePosIfAnon)
	local hideNumber = hideNumber or false
	local hidePosIfAnon = hidePosIfAnon or false

	PhoneNumbers[number] = {
		type = type,
		sources = {},
		alerts = {}
	}
end)

AddEventHandler('esx:setJob', function(source, job, lastJob)
	if PhoneNumbers[lastJob.name] ~= nil then
		TriggerEvent('Sneakyesx_addons_gcphone:removeSource', lastJob.name, source)
	end

	if PhoneNumbers[job.name] ~= nil then
		TriggerEvent('Sneakyesx_addons_gcphone:addSource', job.name, source)
	end
end)

AddEventHandler('Sneakyesx_addons_gcphone:addSource', function(number, source)
	PhoneNumbers[number].sources[tostring(source)] = true
end)

AddEventHandler('Sneakyesx_addons_gcphone:removeSource', function(number, source)
	PhoneNumbers[number].sources[tostring(source)] = nil
end)

RegisterServerEvent('SneakygcPhone:sendMessage')
AddEventHandler('SneakygcPhone:sendMessage', function(number, message)
	local _src = source
	TriggerEvent("ratelimit", _src, "SneakygcPhone:sendMessage")
	if PhoneNumbers[number] ~= nil then
		getPhoneNumber(source, function(phone) 
			notifyAlertSMS(number, {
				message = message,
				numero = phone,
			}, PhoneNumbers[number].sources)
		end)
	end
end)

RegisterServerEvent('Sneakyesx_addons_gcphone:startCall')
AddEventHandler('Sneakyesx_addons_gcphone:startCall', function(number, message, coords)
	local _src = source
	TriggerEvent("ratelimit", _src, "Sneakyesx_addons_gcphone:startCall")
	if PhoneNumbers[number] ~= nil then
		print('= WARNING = Appels sur un service enregistre => numero : ' .. number)
		getPhoneNumber(source, function(phone) 
			notifyAlertSMS(number, {
				message = message, 
				coords = coords,
				numero = phone,
			}, PhoneNumbers[number].sources)
		end)
	else
		print('= WARNING = Appels sur un service non enregistre => numero : ' .. number)
	end
end)

AddEventHandler('esx:playerLoaded', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',{
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local phoneNumber = result[1].phone_number
		xPlayer.set('phoneNumber', phoneNumber)

		if PhoneNumbers[xPlayer.job.name] ~= nil then
			TriggerEvent('Sneakyesx_addons_gcphone:addSource', xPlayer.job.name, source)
		end
	end)
end)

AddEventHandler('esx:playerDropped', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if PhoneNumbers[xPlayer.job.name] ~= nil then
		TriggerEvent('Sneakyesx_addons_gcphone:removeSource', xPlayer.job.name, source)
	end
end)

function getPhoneNumber(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',{
			['@identifier'] = xPlayer.identifier
		}, function(result)
			cb(result[1].phone_number)
		end)
	else
		cb(nil)
	end
end

RegisterServerEvent('Sneakyesx_phone:send')
AddEventHandler('Sneakyesx_phone:send', function(number, message, _, coords)
	local _src = source
	TriggerEvent("ratelimit", _src, "Sneakyesx_phone:send")
	if PhoneNumbers[number] ~= nil then
		getPhoneNumber(source, function(phone)
			notifyAlertSMS(number, {
				message = message,
				coords = coords,
				numero = phone,
			}, PhoneNumbers[number].sources)
		end)
	end
end)

local DataStores, SharedDataStores = {}, {}

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM datastore', {}, function(result)
		for i = 1, #result, 1 do
			local name = result[i].name
			local label = result[i].label
			local shared = result[i].shared

			MySQL.Async.fetchAll('SELECT * FROM datastore_data WHERE name = @name', {
				['@name'] = name
			}, function(result2)
				if shared == 0 then
					DataStores[name] = {}

					for j = 1, #result2, 1 do
						local storeName = result2[j].name
						local storeOwner = result2[j].owner
						local storeData = (result2[j].data == nil and {} or json.decode(result2[j].data))
						local dataStore = CreateDataStore(storeName, storeOwner, storeData)

						table.insert(DataStores[name], dataStore)
					end
				else
					local data = nil

					if #result2 == 0 then
						MySQL.Async.execute('INSERT INTO datastore_data (name, owner, data) VALUES (@name, NULL, \'{}\')', {
							['@name'] = name
						})

						data = {}
					else
						data = json.decode(result2[1].data)
					end

					local dataStore = CreateDataStore(name, nil, data)
					SharedDataStores[name] = dataStore
				end
			end)
		end
	end)
end)

function GetDataStore(name, owner)
	for i = 1, #DataStores[name], 1 do
		if DataStores[name][i].owner == owner then
			return DataStores[name][i]
		end
	end

	MySQL.Async.execute('INSERT INTO datastore_data (name, owner, data) VALUES (@name, @owner, @data)', {
		['@name'] = name,
		['@owner'] = owner,
		['@data'] = '{}'
	})

	local store = CreateDataStore(name, owner, {})
	table.insert(DataStores[name], store)
	return store
end

function GetSharedDataStore(name)
	return SharedDataStores[name]
end

AddEventHandler('Sneakyesx_datastore:getDataStore', function(name, owner, cb)
	cb(GetDataStore(name, owner))
end)

AddEventHandler('Sneakyesx_datastore:getSharedDataStore', function(name, cb)
	cb(GetSharedDataStore(name))
end)

ESX.RegisterUsableItem('bread', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('bread', 1)
	TriggerClientEvent('Sneakyesx_status:add', source, 'hunger', 150000)
	TriggerClientEvent('Sneaky:addStatus', source, 132, 74, 17, "eat")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ du pain.")
end)


ESX.RegisterUsableItem('perfusion', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('perfusion', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'hunger', 50000)
	TriggerClientEvent('Sneakyesx_status:add', source, 'thirst', 50000)
	Wait(5000)
	TriggerClientEvent('Sneakyesx_status:add', source, 'hunger', 50000)
	TriggerClientEvent('Sneakyesx_status:add', source, 'thirst', 50000)
	Wait(5000)
	TriggerClientEvent('Sneakyesx_status:add', source, 'hunger', 50000)
	TriggerClientEvent('Sneakyesx_status:add', source, 'thirst', 50000)
	Wait(5000)
	TriggerClientEvent('Sneakyesx_status:add', source, 'hunger', 50000)
	TriggerClientEvent('Sneakyesx_status:add', source, 'thirst', 50000)
	Wait(5000)
	TriggerClientEvent('Sneakyesx_status:add', source, 'hunger', 50000)
	TriggerClientEvent('Sneakyesx_status:add', source, 'thirst', 50000)
	Wait(5000)
	TriggerClientEvent('Sneakyesx_status:add', source, 'hunger', 50000)
	TriggerClientEvent('Sneakyesx_status:add', source, 'thirst', 50000)
	Wait(5000)
	TriggerClientEvent('Sneakyesx_status:add', source, 'hunger', 50000)
	TriggerClientEvent('Sneakyesx_status:add', source, 'thirst', 50000)
	TriggerClientEvent('Sneaky:addStatus', source, 209, 209, 209, "drink")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ une perfusion.")
end)



ESX.RegisterUsableItem('water', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('water', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'thirst', 150000)
	TriggerClientEvent('Sneaky:addStatus', source, 0, 240, 255, "drink")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ une bouteille d'eau.")
end)

ESX.RegisterUsableItem('redbull', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('redbull', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'thirst', 100000)
	TriggerClientEvent('Sneaky:addStatus', source, 248, 255, 169, "drink")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ un redbull.")
end)

ESX.RegisterUsableItem('limonade', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('limonade', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'thirst', 100000)
	TriggerClientEvent('Sneaky:addStatus', source, 248, 255, 169, "drink")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ une limonade.")
end)

ESX.RegisterUsableItem('coca', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('coca', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'thirst', 750000)
	TriggerClientEvent('Sneaky:addStatus', source, 72, 43, 1, "drink")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ un coca.")
end)

ESX.RegisterUsableItem('cola', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('cola', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'thirst', 750000)
	TriggerClientEvent('Sneaky:addStatus', source, 72, 43, 1, "drink")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ un cola.")
end)


ESX.RegisterUsableItem('burger', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('burger', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'hunger', 800000)
	TriggerClientEvent('Sneaky:addStatus', source, 72, 43, 1, "eat")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ un burger.")
end)

ESX.RegisterUsableItem('sake', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('sake', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'thirst', 800000)
	TriggerClientEvent('Sneaky:addStatus', source, 72, 43, 1, "drink")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ une bouteille de saké.")
end)

ESX.RegisterUsableItem('pizza', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('pizza', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'hunger', 800000)
	TriggerClientEvent('Sneaky:addStatus', source, 255, 73, 0, "eat")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ une pizza.")
end)

-- Noodle
ESX.RegisterUsableItem('the_vert', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('the_vert', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'thirst', 800000)
	TriggerClientEvent('Sneaky:addStatus', source, 205, 255, 127, "drink")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ un thé vert.")
end)

ESX.RegisterUsableItem('jus_leechi', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('jus_leechi', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'thirst', 800000)
	TriggerClientEvent('Sneaky:addStatus', source, 205, 255, 127, "drink")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ un jus de leechi.")
end)

ESX.RegisterUsableItem('maki', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('maki', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'hunger', 800000)
	TriggerClientEvent('Sneaky:addStatus', source, 205, 255, 127, "drink")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ un maki.")
end)

ESX.RegisterUsableItem('bol_de_nouilles', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('bol_de_nouilles', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'hunger', 800000)
	TriggerClientEvent('Sneaky:addStatus', source, 255, 158, 127, "eat")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ un bol de nouilles.")
end)

ESX.RegisterUsableItem('assiette_de_sushis', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('assiette_de_sushis', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'hunger', 800000)
	TriggerClientEvent('Sneaky:addStatus', source, 255, 158, 127, "eat")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ une assiette de sushi.")
end)

ESX.RegisterUsableItem('rouleau_de_printemps', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('rouleau_de_printemps', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'hunger', 800000)
	TriggerClientEvent('Sneaky:addStatus', source, 255, 158, 127, "eat")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ un rouleau de printemps.")
end)

ESX.RegisterUsableItem('soupe_de_nouille', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('soupe_de_nouille', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'hunger', 800000)
	TriggerClientEvent('Sneaky:addStatus', source, 255, 158, 127, "eat")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ une soupe de nouille.")
end)

-- Ltd

ESX.RegisterUsableItem('sandwich', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('sandwich', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'hunger', 800000)
	TriggerClientEvent('Sneaky:addStatus', source, 121, 68, 0, "eat")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ un sandwich.")
end)

ESX.RegisterUsableItem('chips', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('chips', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'hunger', 800000)
	TriggerClientEvent('Sneaky:addStatus', source, 255, 210, 152, "eat")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ un paquet de chips.")
end)

ESX.RegisterUsableItem('hotdog', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('hotdog', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'hunger', 800000)
	TriggerClientEvent('Sneaky:addStatus', source, 255, 160, 152, "eat")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ un hotdog.")
end)

ESX.RegisterUsableItem('jus_orange', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('jus_orange', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'hunger', 800000)
	TriggerClientEvent('Sneaky:addStatus', source, 255, 166, 0, "drink")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ un jus d'orange.")
end)

ESX.RegisterUsableItem('beer_2', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('beer_2', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'hunger', 800000)
	TriggerClientEvent('Sneaky:addStatus', source, 255, 221, 158, "drink")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ une bière sans alcool.")
end)

ESX.RegisterUsableItem('chocolate', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('chocolate', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'hunger', 150000)
	TriggerClientEvent('Sneaky:addStatus', source, 69, 45, 0, "eat")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ une tablette de chocolat.")
end)

ESX.RegisterUsableItem('donut', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('donut', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'hunger', 800000)
	TriggerClientEvent('Sneaky:addStatus', source, 69, 45, 0, "eat")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ un donut.")
end)


ESX.RegisterUsableItem('spaghetti_bolognaise', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('spaghetti_bolognaise', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'hunger', 800000)
	TriggerClientEvent('Sneaky:addStatus', source, 255, 84, 84, "eat")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ des spaghettis bolognaise.")
end)


ESX.RegisterUsableItem('frites', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('frites', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'hunger', 250000)
	TriggerClientEvent('Sneaky:addStatus', source, 255, 252, 84, "eat")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ des frites.")
end)

ESX.RegisterUsableItem('frites_chauffe', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('frites_chauffe', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'hunger', 250000)
	TriggerClientEvent('Sneaky:addStatus', source, 255, 252, 84, "eat")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ des frites chauffées.")
end)

ESX.RegisterUsableItem('soda', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('soda', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'thirst', 750000)
	TriggerClientEvent('Sneaky:addStatus', source, 96, 44, 0, "drink")
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ un soda.")
end)

-- Items Alcohol --
ESX.RegisterUsableItem('beer', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('beer', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'drunk', 250000)
	TriggerClientEvent('Sneaky:addStatus', source, 255, 221, 158, "drink")
	TriggerClientEvent('Sneakyesx_status:onDrinkAlcohol', source)
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ une bière.")
end)

ESX.RegisterUsableItem('tequila', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('tequila', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'drunk', 250000)
	TriggerClientEvent('Sneaky:addStatus', source, 218, 218, 218, "drink")
	TriggerClientEvent('Sneakyesx_status:onDrinkAlcohol', source)
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ une tequila.")
end)

ESX.RegisterUsableItem('vodka', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('vodka', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'drunk', 250000)
	TriggerClientEvent('Sneaky:addStatus', source, 218, 218, 218, "drink")
	TriggerClientEvent('Sneakyesx_status:onDrinkAlcohol', source)
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ une vodka.")
end)

ESX.RegisterUsableItem('whisky', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('whisky', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'drunk', 250000)
	TriggerClientEvent('Sneaky:addStatus', source, 151, 103, 0, "drink")
	TriggerClientEvent('Sneakyesx_status:onDrinkAlcohol', source)
	TriggerClientEvent('esx:showNotification', source, "Vous avez ~b~consommé(e)~s~ un whisky.")
end)

-- Items Drug --
ESX.RegisterUsableItem('weed', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('weed', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'drug', 166000)
	TriggerClientEvent('Sneakyesx_status:onWeed', source)
end)

ESX.RegisterUsableItem('meth', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('meth', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'drug', 333000)
	TriggerClientEvent('Sneakyesx_status:onMeth', source)
end)

ESX.RegisterUsableItem('coke', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('coke', 1)

	TriggerClientEvent('Sneakyesx_status:add', source, 'drug', 499000)
	TriggerClientEvent('Sneakyesx_status:onCoke', source)
end)

-- Commands --
ESX.AddGroupCommand('heal', 'admin', function(source, args, user)
	if tonumber(args[1]) then
		local target = tonumber(args[1])

		if GetPlayerName(target) then
			TriggerClientEvent('Sneakyesx_status:healPlayer', target)
		else
			TriggerClientEvent('chatMessage', source, "HEAL", {255, 0, 0}, "Player not found!")
		end
	else
		TriggerClientEvent('Sneakyesx_status:healPlayer', source)
	end
end, {help = "Heal, Nourrit et Hydrate un joueur."})

ESX.AddGroupCommand('removeheal', 'admin', function(source, args, user)
	if tonumber(args[1]) then
		local target = tonumber(args[1])

		if GetPlayerName(target) then
			TriggerClientEvent('Sneakyesx_status:removeTest', target)
		else
			TriggerClientEvent('chatMessage', source, "HEAL", {255, 0, 0}, "Player not found!")
		end
	else
		TriggerClientEvent('Sneakyesx_status:removeTest', source)
	end
end, {help = "Heal, Nourrit et Hydrate un joueur."})

RegisterServerEvent('Sneakyesx_skin:save')
AddEventHandler('Sneakyesx_skin:save', function(skin)
	local _src = source
	TriggerEvent("ratelimit", _src, "Sneakyesx_skin:save")
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET skin = @skin WHERE identifier = @identifier', {
		['@skin'] = json.encode(skin),
		['@identifier'] = xPlayer.identifier
	})
end)

RegisterServerEvent('SneakyClothesGetHairFade')
AddEventHandler('SneakyClothesGetHairFade', function()
	local _src = source
	TriggerEvent("ratelimit", _src, "SneakyClothesGetHairFade")
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
        ["@identifier"] = xPlayer.identifier
    }, function(result)
		local skin = result[1]
		if result.skin then
			skin = json.decode(result.skin)
		end
        TriggerClientEvent("SneakyClothes:RequestHairFade", _src, skin)
    end)
end)

ESX.RegisterServerCallback('Sneakyesx_skin:getPlayerSkin', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(users)
		local user, skin = users[1]

		local jobSkin = {
			skin_male = xPlayer.job.skin_male,
			skin_female = xPlayer.job.skin_female
		}

		if user.skin then
			skin = json.decode(user.skin)
		end

		cb(skin, jobSkin)
	end)
end)

function AddLicense(target, type, cb)
	local xPlayer = ESX.GetPlayerFromId(target)
	MySQL.Async.execute('INSERT INTO user_licenses (type, owner) VALUES (@type, @owner)', {
		['@type'] = type,
		['@owner'] = xPlayer.identifier
	}, function(rowsChanged)
		if cb then
			cb()
		end
	end)
end

function RemoveLicense(target, type, cb)
	local xPlayer = ESX.GetPlayerFromId(target)
	MySQL.Async.execute('DELETE FROM user_licenses WHERE type = @type AND owner = @owner', {
		['@type'] = type,
		['@owner'] = xPlayer.identifier
	}, function(rowsChanged)
		if cb then
			cb()
		end
	end)
end

function GetLicense(type, cb)
	MySQL.Async.fetchAll('SELECT * FROM licenses WHERE type = @type', {
		['@type'] = type
	}, function(result)
		local data = {
			type = type,
			label = result[1].label
		}

		cb(data)
	end)
end

function GetLicenses(target, cb)
	local xPlayer = ESX.GetPlayerFromId(target)
	MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @owner', {
		['@owner'] = xPlayer.identifier
	}, function(result)
		local licenses = {}
		local asyncTasks = {}

		for i = 1, #result, 1 do
			local scope = function(type)
				table.insert(asyncTasks, function(cb)
					MySQL.Async.fetchAll('SELECT * FROM licenses WHERE type = @type', {
						['@type'] = type
					}, function(result2)
						table.insert(licenses, {
							type = type,
							label = result2[1].label
						})

						cb()
					end)
				end)
			end

			scope(result[i].type)
		end

		Async.parallel(asyncTasks, function(results)
			cb(licenses)
		end)
	end)
end

function CheckLicense(target, type, cb)
	local xPlayer = ESX.GetPlayerFromId(target)
	MySQL.Async.fetchAll('SELECT COUNT(*) as count FROM user_licenses WHERE type = @type AND owner = @owner', {
		['@type'] = type,
		['@owner'] = xPlayer.identifier
	}, function(result)
		if tonumber(result[1].count) > 0 then
			cb(true)
		else
			cb(false)
		end
	end)
end

function GetLicensesList(cb)
	MySQL.Async.fetchAll('SELECT * FROM licenses', {
		['@type'] = type
	}, function(result)
		local licenses = {}

		for i = 1, #result, 1 do
			table.insert(licenses, {
				type = result[i].type,
				label = result[i].label
			})
		end

		cb(licenses)
	end)
end

RegisterNetEvent('Sneakyesx_license:addLicense')
AddEventHandler('Sneakyesx_license:addLicense', function(target, type, cb)
	AddLicense(target, type, cb)
end)

RegisterNetEvent('Sneakyesx_license:removeLicense')
AddEventHandler('Sneakyesx_license:removeLicense', function(target, type, cb)
	RemoveLicense(target, type, cb)
end)

AddEventHandler('Sneakyesx_license:getLicense', function(type, cb)
	GetLicense(type, cb)
end)

AddEventHandler('Sneakyesx_license:getLicenses', function(target, cb)
	GetLicenses(target, cb)
end)

AddEventHandler('Sneakyesx_license:checkLicense', function(target, type, cb)
	CheckLicense(target, type, cb)
end)

AddEventHandler('Sneakyesx_license:getLicensesList', function(cb)
	GetLicensesList(cb)
end)

ESX.RegisterServerCallback('Sneakyesx_license:getLicense', function(source, cb, type)
	GetLicense(type, cb)
end)

ESX.RegisterServerCallback('Sneakyesx_license:getLicenses', function(source, cb, target)
	GetLicenses(target, cb)
end)

ESX.RegisterServerCallback('Sneakyesx_license:checkLicense', function(source, cb, target, type)
	CheckLicense(target, type, cb)
end)

ESX.RegisterServerCallback('Sneakyesx_license:getLicensesList', function(source, cb)
	GetLicensesList(cb)
end)