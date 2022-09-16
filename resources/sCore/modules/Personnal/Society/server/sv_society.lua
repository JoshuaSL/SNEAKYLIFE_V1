ESX = nil
local Jobs = {}
local RegisteredSocieties = {}

TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)

function GetSociety(name)
	for i=1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			return RegisteredSocieties[i]
		end
	end
end

function getMaximumGrade(jobname)
	local queryDone, queryResult = false, nil

	MySQL.Async.fetchAll('SELECT * FROM job_grades WHERE job_name = @jobname ORDER BY `grade` DESC ;', {
		['@jobname'] = jobname
	}, function(result)
		queryDone, queryResult = true, result
	end)

	while not queryDone do
		Citizen.Wait(10)
	end

	if queryResult[1] then
		return queryResult[1].grade
	end

	return nil
end

MySQL.ready(function()
	local result = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})

	for i=1, #result, 1 do
		Jobs[result[i].name]        = result[i]
		Jobs[result[i].name].grades = {}
	end

	local result2 = MySQL.Sync.fetchAll('SELECT * FROM job_grades', {})

	for i=1, #result2, 1 do
		Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
	end
end)

RegisterServerEvent('pSociety:registerSociety')
AddEventHandler('pSociety:registerSociety', function(name, label, account, datastore, inventory, data)
	local _src = source
	TriggerEvent("ratelimit", _src, "pSociety:registerSociety")
	local found = false

	local society = {
		name      = name,
		label     = label,
		account   = account,
		datastore = datastore,
		inventory = inventory,
		data      = data
	}

	for i=1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			found = true
			RegisteredSocieties[i] = society
			break
		end
	end

	if not found then
		table.insert(RegisteredSocieties, society)
	end
end)

AddEventHandler('pSociety:getSocieties', function(cb)
	cb(RegisteredSocieties)
end)

AddEventHandler('pSociety:getSociety', function(name, cb)
	cb(GetSociety(name))
end)

RegisterServerEvent('pSociety:withdrawMoney')
AddEventHandler('pSociety:withdrawMoney', function(society, amount)
	local _src = source
	TriggerEvent("ratelimit", _src, "pSociety:withdrawMoney")
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(society)
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.job.name == society.name then
		TriggerEvent('Sneakyesx_addonaccount:getSharedAccount', society.account, function(account)
			if amount > 0 and account.money >= amount then
				account.removeMoney(amount)
				xPlayer.addAccountMoney('cash',amount)

				TriggerClientEvent("RageUI:Popup", source, {message="Société : ~b~"..society.label.."~s~ \nType : ~y~Retrait~s~\nMontant : ~g~$"..ESX.Math.GroupDigits(amount)})
			else
				TriggerClientEvent("RageUI:Popup", source, {message="~b~Action impossible"})
			end
		end)
	else
		print(('pSociety: %s attempted to call withdrawMoney!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('pSociety:depositMoney')
AddEventHandler('pSociety:depositMoney', function(society, amount)
	local _src = source
	TriggerEvent("ratelimit", _src, "pSociety:depositMoney")
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(society)
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.job.name == society.name then
		if amount > 0 and xPlayer.getAccount('cash').money >= amount then
			TriggerEvent('Sneakyesx_addonaccount:getSharedAccount', society.account, function(account)
				xPlayer.removeAccountMoney('cash', amount)
				account.addMoney(amount)
			end)

			TriggerClientEvent("RageUI:Popup", source, {message="Société : ~b~"..society.label.."~s~ \nType : ~y~Dépôt~s~\nMontant : ~g~$"..ESX.Math.GroupDigits(amount)})

		else
			TriggerClientEvent("RageUI:Popup", source, {message="~b~Action impossible"})
		end
	else
		print(('pSociety: %s attempted to call depositMoney!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('pSociety:washMoney')
AddEventHandler('pSociety:washMoney', function(society, amount)
	local _src = source
	TriggerEvent("ratelimit", _src, "pSociety:washMoney")
	local xPlayer = ESX.GetPlayerFromId(source)
	local societyy = GetSociety(society)
	local account = xPlayer.getAccount('dirtycash').money
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.job.name == society then
		if amount and amount > 0 and account >= amount then
			TriggerEvent('Sneakyesx_addonaccount:getSharedAccount', societyy.account, function(sctyacc)
				xPlayer.removeAccountMoney('dirtycash', amount)
				sctyacc.addMoney(amount)
				TriggerClientEvent("RageUI:Popup", source, {message="~r~Vous avez blanchis :~s~ \n$"..ESX.Math.GroupDigits(amount)})
			end)
		else
			TriggerClientEvent("RageUI:Popup", source, {message="~b~Action impossible"})
		end
	else
		print(('pSociety: %s attempted to call washMoney!'):format(xPlayer.identifier))
	end
end)

ESX.RegisterServerCallback('pSociety:getSocietyMoney', function(source, cb, societyName)
	local society = GetSociety(societyName)

	if society then
		TriggerEvent('Sneakyesx_addonaccount:getSharedAccount', society.account, function(account)
			cb(account.money)
		end)
	else
		cb(0)
	end
end)

ESX.RegisterServerCallback('pSociety:getEmployees', function(source, cb, society)

	MySQL.Async.fetchAll('SELECT firstname, lastname, identifier, job, job_grade FROM users WHERE job = @job ORDER BY job_grade DESC', {
		['@job'] = society
	}, function (results)
		local employees = {}
		local lbl = nil

		for i=1, #results, 1 do
			if results[i].firstname == nil or results[i].lastname == nil then lbl = results[i].name else lbl = results[i].firstname .. ' ' .. results[i].lastname end
			table.insert(employees, {
				name       = lbl,
				identifier = results[i].identifier,
				job = {
					name        = results[i].job,
					label       = Jobs[results[i].job].label,
					grade       = results[i].job_grade,
					grade_name  = Jobs[results[i].job].grades[tostring(results[i].job_grade)].name,
					grade_label = Jobs[results[i].job].grades[tostring(results[i].job_grade)].label
				}
			})
		end

		cb(employees)
	end)
end)

ESX.RegisterServerCallback('pSociety:getJob', function(source, cb, society)
	local job    = json.decode(json.encode(Jobs[society]))
	local grades = {}

	for k,v in pairs(job.grades) do
		table.insert(grades, v)
	end

	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)

	job.grades = grades

	cb(job)
end)

ESX.RegisterServerCallback('pSociety:setJob', function(source, cb, identifier, job, grade)
	local xPlayer = ESX.GetPlayerFromId(source)
	local isBoss = xPlayer.job.grade_name == 'boss'

	if isBoss then
		local xTarget = ESX.GetPlayerFromIdentifier(identifier)

		if grade ~= tonumber(getMaximumGrade(job)) or job == "unemployed" then
			if xTarget then
				xTarget.setJob(job, grade)

				TriggerClientEvent("RageUI:Popup", xTarget, {message="~b~Votre profession à évoluée"})
				TriggerClientEvent("RageUI:Popup", source, {message="~b~Profession modifiée !"})

				cb()
			else
				MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier', {
					['@job']        = job,
					['@job_grade']  = grade,
					['@identifier'] = identifier
				}, function(rowsChanged)
					TriggerClientEvent("RageUI:Popup", source, {message="~b~Profession modifiée !"})
					cb()
				end)
			end
		else
			TriggerClientEvent("RageUI:Popup", source, {message="~r~Vous ne pouvez pas attribuer cette profession !"})
			cb(false)
		end
	else
		print(('pSociety: %s attempted to setJob'):format(xPlayer.identifier))
		cb()
	end
end)

--[[ ESX.RegisterServerCallback('pSociety:setJobSalary', function(source, cb, job, grade, salary)
	local isBoss = isPlayerBoss(source, job)
	local identifier = GetPlayerIdentifier(source, 0)

	if isBoss then
		if salary <= 9999 then
			MySQL.Async.execute('UPDATE job_grades SET salary = @salary WHERE job_name = @job_name AND grade = @grade', {
				['@salary']   = salary,
				['@job_name'] = job,
				['@grade']    = grade
			}, function(rowsChanged)
				Jobs[job].grades[tostring(grade)].salary = salary
				local xPlayers = ESX.GetPlayers()

				for i=1, #xPlayers, 1 do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

					if xPlayer.job.name == job and xPlayer.job.grade == grade then
						xPlayer.setJob(job, grade)
					end
				end

				cb()
			end)
		else
			print(('pSociety: %s attempted to setJobSalary over config limit!'):format(identifier))
			cb()
		end
	else
		print(('pSociety: %s attempted to setJobSalary'):format(identifier))
		cb()
	end
end) ]]

ESX.RegisterServerCallback('pSociety:isBoss', function(source, cb, job)
	cb(isPlayerBoss(source, job))
end)

function isPlayerBoss(playerId, job)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer.job.name == job and xPlayer.job.grade_name == 'boss' then
		return true
	else
		print(('pSociety: %s attempted open a society boss menu!'):format(xPlayer.identifier))
		return false
	end
end

RegisterServerEvent("pSociety:RequestSetRecruit")
AddEventHandler("pSociety:RequestSetRecruit", function(target, job)
	local _src = source
	TriggerEvent("ratelimit", _src, "pSociety:RequestSetRecruit")
	local xPlayer = ESX.GetPlayerFromId(source)
	local Player = ESX.GetPlayerFromId(ply)
	local society = GetSociety(job)

	if xPlayer.job.grade_name == 'boss' then
		TriggerClientEvent("pSociety:SendRequestRecruit", target, society.label, job)
		TriggerClientEvent("RageUI:Popup", source, {message="~b~Demande envoyée."})
	end
end)

RegisterServerEvent("pSociety:SetJob")
AddEventHandler("pSociety:SetJob", function(job, grade)
	local _src = source
	TriggerEvent("ratelimit", _src, "pSociety:SetJob")
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.setJob(job, grade)
	TriggerClientEvent("RageUI:Popup", source, {message="~b~Votre profession à évoluée"})
end)