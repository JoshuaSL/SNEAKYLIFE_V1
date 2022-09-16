function findItem(arr, itemToFind)
	local foundIt = false
	local index = nil
	for i = 1, #arr, 1 do
		if arr[i] == itemToFind then
			foundIt = true
			index = i
			break
		end
	end
	if not foundIt then
		return foundIt
	else
		return index
	end
end

function findKey(obj, keyToFind)
	local foundIt = false
	local key = nil
	for k, v in pairs(obj) do
		if k == keyToFind then
			foundIt = true
			key = k
			break
		end
	end
	if not foundIt then
		return foundIt
	else
		return key
	end
end