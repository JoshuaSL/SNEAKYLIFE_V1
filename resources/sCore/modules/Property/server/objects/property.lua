ESX = nil
TriggerEvent("Sneakyesx:getSharedObject", function(SneakyESX) ESX = SneakyESX end)

Property = {}
Property.__index = Property

setmetatable(Property, {
    __call = function(_, propertyId, ownerLicense, info, ownerInfo, inventory, keys, street)
        local self = setmetatable({}, Property)
        self.propertyId = propertyId
        self.ownerLicense = ownerLicense
        self.instance = sPropertyManager.instanceRange + propertyId
        self.players = {}
        self.info = info
        self.ownerInfo = ownerInfo
        self.inventory = inventory
        self.keys = keys
        self.allowedPlayers = {}
        self.street = street
        SetRoutingBucketPopulationEnabled(self.instance, false)
        return self
    end
})

function Property:getInstance()
    return self.instance or -1
end

function Property:getPlayers()
    return self.players
end

function Property:isOwner(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local license = xPlayer.identifier
        return license == self.ownerLicense
    end
end

function Property:getPlayersCount()
    return #self.players
end

function Property:enter(source, propertyId, isOwner)
    if source then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then

            exports.sFramework:onSavedPlayer(false, xPlayer.identifier)
            local bucket = sPropertyManager.instanceRange + propertyId
            SetPlayerRoutingBucket(source, bucket)
            
            attemp = true
            local Property = sPropertyManager.list[propertyId]
            for k,v in pairs(ConfigImmo.Batiment.Property) do
                if k == Property.info.Selected.name then 
                    PropertyInfos = v
                    attemp = false
                end
            end

            while attemp do
                Wait(50)
            end

            TriggerClientEvent("sProperty:returnEnter", xPlayer.source, xPlayer.getCoords(true), PropertyInfos, isOwner, Property, Property.inventory)
        end
    end
end
