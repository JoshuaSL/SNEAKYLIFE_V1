AddEventHandler('Sneakyesx:getSharedObject', function(cb)
	cb(ESX)
end)

function getSharedObject()
	return ESX
end