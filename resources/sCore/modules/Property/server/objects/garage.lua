ESX = nil
TriggerEvent("esx:getSharedObject", function(SneakyESX) ESX = SneakyESX end)

Garage = {}
Garage.__index = Garage

setmetatable(Garage, {
    __call = function(_, garageId, ownerLicense, info, ownerInfo, vehicles, street)
        local self = setmetatable({}, Garage)
        self.garageId = garageId
        self.ownerLicense = ownerLicense
        self.instance = sGarageManager.instanceRange + garageId
        self.players = {}
        self.info = info
        self.ownerInfo = ownerInfo
        self.vehicles = vehicles
        self.allowedPlayers = {}
        self.street = street
        SetRoutingBucketPopulationEnabled(self.instance, false)
        return self
    end
})

function Garage:getInstance()
    return self.instance or -1
end

function Garage:getPlayers()
    return self.players
end

function Garage:isOwner(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local license = xPlayer.identifier
        return license == self.ownerLicense
    end
end

function Garage:getPlayersCount()
    return #self.players
end

function Garage:enter(source, garageId, isOwner)
    if source then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then

            while sGarageManager.list[garageId] == nil do
                Wait(50)
            end
            
            local bucket = sGarageManager.instanceRange + garageId
            SetPlayerRoutingBucket(source, bucket)
            exports.sFramework:onSavedPlayer(false, xPlayer.identifier)

            attemp = true
            local garage = sGarageManager.list[garageId]
            for k,v in pairs(ConfigImmo.Batiment.Garage) do
                if v.name == garage.info.Selected.name then
                    garageInfos = v
                    attemp = false
                end
            end

            while attemp do
                Wait(50)
            end

            TriggerClientEvent("sGarage:returnEnter", xPlayer.source, xPlayer.getCoords(true), garageInfos, isOwner, garage, garage.vehicles)
        end
    end
end
