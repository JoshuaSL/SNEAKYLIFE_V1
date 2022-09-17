if not ConfigAC.Activate then 
	return print("[Anti-Cheat]: ^1The Anti-Cheat is disable !^0") 
else 
	print("[Anti-Cheat]: ^3The Anti-Cheat is enable !^0") 
end

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

webhooksAC = {
	["startresource"] = "https://canary.discord.com/api/webhooks/846057466554613780/hEAeh1CHKQ06tYucZo2qngRcxVvQazFw9MjTbTjRB6VKYa6GH_-H_9B5ZinoqXsh5Jbl",
	["stopresource"] = "https://canary.discord.com/api/webhooks/846057543368704100/hV15ionW8oMtRaifgwdTwiqMl25YSQIAiwg0ozZRTBeypQvGQAkzEQbXvrxQmj-vE_Tq",
	["explosion"] = "https://canary.discord.com/api/webhooks/846057606443040809/u-3kNC9VbUY7ClDFDypXyCoRWBMByl5wh7-3WmAWFs1gSoBtNRKktKLIapaMi507RUZv",
	["createentity"] = "https://canary.discord.com/api/webhooks/846057688239833109/B_JU5YvuMNQL3J2UFlWS5PEQZTzjtd90z6IuRDDuwDojGjLI-IbVT1laNZhinN7rFGpC",
	["createweapon"] = "https://canary.discord.com/api/webhooks/846061041645518869/8DLtag06wtdPRW_9tFZguugrwGAFPvB5ufmdL8GD8buFzdeuv0V21A-sWZH0RZ9YNspw",
	["executemenu"] = "https://canary.discord.com/api/webhooks/851768539828060180/90LBRdbRl1RqOFzn3SZW4xrRBVpMRp8n0tUz2-NNY7DHiO7U7HpDjSV28SnaEpjPuU2q",
	["changestateuser"] = "https://canary.discord.com/api/webhooks/870364034107572335/sr27StXS3aux1IJ7FXAKyDAVL2W0N-OFZ9cvTwBA09cG9ttMbRNbWeQUSL04d52xj8wx",
	["vehiclechangemmodifier"] = "https://canary.discord.com/api/webhooks/870364128361971772/C1SCs6O7EGNdy-5BKLLl3PD7s9uK72NEhzMO7DsBRg_oluFnvYO95iYLmEK7m0-7kqSG",
	["clearPedTasksEvent"] = "https://discord.com/api/webhooks/870552538133463080/TH61m6mO1mL1rwxyv8FuM-QUqtD_BcsR2CfciX_qWp0Dqg_GX2Dvun7AtoeXLeTwLSV9"
}

RegisterNetEvent("sAc:banPlayer")
AddEventHandler("sAc:banPlayer", function(execution)
    local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer == "user" then
		banPlayerAC(source, execution)
	end
end)


RegisterNetEvent("sAc:checkWeapon")
AddEventHandler("sAc:checkWeapon", function(weapon)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	if ConfigAC.WeaponsList.intHash[weapon] == nil and ConfigAC.WeaponsList.uintHash[weapon] == nil then
		if weapon ~= 2931720192 and weapon ~= -495648874 and weapon ~= 94548753 and weapon ~= -188319074 and weapon ~= 1161062353 and weapon ~= 955837630 and weapon ~= -440934790 and weapon ~= 148160082 and weapon ~= 1205296881 and weapon ~= -1148198339 and weapon ~= -1501041657 and weapon ~= -100946242 and weapon ~= 1983905792 and weapon ~= -1466123874 then
			banPlayerAC(xPlayer.source, {
				name = "createweapon",
				title = "Arme blacklist 2 ("..weapon..")",
				description = "Attribuation d'une arme blacklist 2 ("..weapon..")"
			})
		end
	end
end)

AddEventHandler("giveWeaponEvent", function(src, h)
	if h.givenAsPickup == false then
		banPlayerAC(src, {
			name = "createentity",
			title = "Try to give weapons",
			description = "Try to give weapons"
		})
		CancelEvent()
	end
end)
AddEventHandler("RemoveWeaponEvent", function(sender, data)
	banPlayerAC(source, {
		name = "createentity",
		title = "Try to remove weapons",
		description = "Try to remove weapons" 
	})
	CancelEvent()
end)
AddEventHandler("removeAllWeaponsEvent", function(sender, data)
	banPlayerAC(source, {
		name = "createentity",
		title = "Try to remove all weapons",
		description = "Try to remove all weapons"
	})
	CancelEvent()
end)

AddEventHandler("explosionEvent", function()
    CancelEvent()
end)

AddEventHandler('explosionEvent', function(sender, data)
	if data.posX == 0.0 or data.posY == 0.0 or data.posZ == 0.0 or data.posZ == -1700.0 or (data.cameraShake == 0.0 and data.damageScale == 0.0 and data.isAudible == false and data.isInvisible == false) then
		CancelEvent()
		return
	else
		if data.explosionType == 13 then
			return
		end
		if ConfigAC.Explosion[data.explosionType] == nil then return end
		if ConfigAC.Explosion[data.explosionType].ban then
			banPlayerAC(sender, {
				name = "explosion",
				title = "Création de explosion non autorisé",
				description = "Création de explosion non autorisé "..ConfigAC.Explosion[data.explosionType].name
			})
			CancelEvent()
		else
			sendLogsAC(sender, {
				name = "explosion",
				title = "Création de explosion non autorisé",
				description = "Création de explosion non autorisé "..ConfigAC.Explosion[data.explosionType].name
			})
			CancelEvent()
		end
	end
end)

AddEventHandler("fireEvent", function()
    CancelEvent()
end)

Citizen.CreateThread(function()
    vehCreator = {}
    pedCreator = {}
    entityCreator = {}
	particlesSpawned = {}
    while true do
        Citizen.Wait(2500)
        vehCreator = {}
        pedCreator = {}
        entityCreator = {}
		particlesSpawned = {}
    end
end)

BlacklistedModels = { -- only peds/vehicles
	"firetruck",
	"bus",
	"airbus",
	"pbus2",
	"bulldozer",
	"cutter",
	"dump",
	"dune2",
	"dune4",
	"dune5",
	"phantom2",
	"insurgent2",
	"insurgent3",
	"nightshark",
	"ruiner2",
	"ruiner3",
	"wastelander",
	"trailerlarge",
	"barracks2",
	"barracks3",
	"rhino",
	"trailersmall2",
	"besra",
	"blimp",
	"blimp2",
	"blimp3",
	"oppressor",
	"oppressor2",
	"ardent",
	"cargoplane",
	"molotok",
	"tula",
	"hydra",
	"starling",
	"terbyte",
	"tug",
	"jet",
	"strikeforce",
	"lazer",
	"cerberus",
	"cerberus2",
	"cerberus3",
	"scarab",
	"scarab2",
	"scarab3",
	"bombushka",
	"mogul",
	"zr380",
	"zr3802",
	"zr3803",
	"barrage",
	"chernobog",
	"deluxo",
	"avenger",
	"avenger2",
	"thruster",
	"stromberg",
	"khanjali",
	"menacer",
	"volatol",
	"vigilante",
	"brickade",
	"armytanker",
	"armytrailer",
	"armytrailer2",
	"baletrailer",
	"boattrailer",
	"cablecar",
	"docktrailer",
	"graintrailer",
	"proptrailer",
	"submersible",
	"submersible2",
	"rogue",
	"viseris"
}

function inTable(tbl, item)
    for key, value in pairs(tbl) do
        if value == item then return key end
    end
    return false
end

AddEventHandler("entityCreating",function(entity)
    if DoesEntityExist(entity) then
        local src = NetworkGetEntityOwner(entity)
        local model = GetEntityModel(entity)
        local blacklistedPropsArray = {}
        local WhitelistedPropsArray = {}
        local eType = GetEntityPopulationType(entity)

        if src == nil then
            CancelEvent()
        end

        for bl_k, bl_v in pairs(BlacklistedModels) do
            table.insert(blacklistedPropsArray, GetHashKey(bl_v))
        end
        
		if GetEntityType(entity) == 2 then
			if eType == 6 or eType == 7 then
				print(GetCurrentResourceName().." : Le Joueur [^5".. src .. "^0 | ^5"..GetPlayerName(src).. "^0] à crée un véhicule [^5"..entity.." ^0| ^5" ..model.."^0]")
				if inTable(blacklistedPropsArray, model) ~= false then
					if model ~= 0 then
						sendLogsAC(src, {
							name = "createentity",
							title = "Anticheat : Création de véhicule : "..model,
							description = "Anticheat : Création de véhicule : "..model
						})
						CancelEvent()
					end
				end
				vehCreator[src] = (vehCreator[src] or 0) + 1
				if vehCreator[src] > 10 then
					banPlayerAC(src, {
						name = "createentity",
						title = "Anticheat : Création de véhicule en masse",
						description = "Anticheat : Création de véhicule en masse"
					})
				end
			end
		elseif GetEntityType(entity) == 1 then
			if eType == 6 or eType == 7 then
				print(GetCurrentResourceName().." : Le Joueur [^5".. src .. "^0 | ^5"..GetPlayerName(src).. "^0] à crée un ped [^5"..entity.." ^0| ^5" ..model.."^0]")
				if inTable(blacklistedPropsArray, model) ~= false then
					if model ~= 0 or model ~= 225514697 then
						sendLogsAC(src, {
							name = "createentity",
							title = "Anticheat : Création de ped non autorisé : "..model,
							description = "Anticheat : Création de ped non autorisé : "..model
						})
						CancelEvent()
					end
				end
				pedCreator[src] = (pedCreator[src] or 0) + 1
				if pedCreator[src] > 20 then
					banPlayerAC(src, {
						name = "createentity",
						title = "Anticheat : Création de ped en masse",
						description = "Anticheat : Création de ped en masse"
					})
				end
			end
		end
    end
end)

Particles = {
    AntiParticles = true,
    WhitelistParticles = true,
    ListParticles = {
        [GetHashKey('water_splash_plane_trail')] = true
    },
    BanActive = true
}

if Particles.AntiParticles then
    AddEventHandler("ptFxEvent", function(sender,a)
        CancelEvent()
        if Particles.WhitelistParticles then
            if Particles.ListParticles[a.assetHash] == nil then
                if Particles.BanActive then
					banPlayerAC(sender, {
						name = "createentity",
						title = "Anticheat : Create particules "..a.assetHash,
						description = "Anticheat : Create particules "..a.assetHash
					})
                end
            end
        end
    end)
end

AddEventHandler("clearPedTasksEvent", function(source, data)
	if data.immediately then
		CancelEvent()
	else
		CancelEvent()
	end
	local entity = NetworkGetEntityFromNetworkId(data.pedId)
	local sender = tonumber(source)
	if DoesEntityExist(entity) then
		local owner = NetworkGetEntityOwner(entity)
		if owner ~= sender then
			CancelEvent()
		end
	end
end)

RegisterNetEvent("sCore:Stop")
AddEventHandler("sCore:Stop",function()
	local src = source
	banPlayerAC(src, {
		name = "stopresource",
		title = "Anticheat : Stop resource",
		description = "Anticheat : Stop resource"
	})
end)

local function getAllLicense(source)
    for k,v in pairs(GetPlayerIdentifiers(source))do
    end
end

local function getPlayerLicense(source)
    getAllLicense(source)
    for k,v in pairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            return v
        end
    end
end

AddEventHandler('playerDropped', function(raison)
    if raison == "Exiting" then
        raison = "F8 QUIT/ALT F4"
    end
    local name = GetPlayerName(source)
    local identifier = getPlayerLicense(source)
    SendLogs(15158332,"Serveur - Déconnexion","**"..name.."** vient de se déconnecter raison : ***"..raison.."***\n **License** : "..identifier,"https://discord.com/api/webhooks/841179533965393920/hQxVi3C7A23F5SrcSdHwAvDuUZ89xq688lnfHUIbkHzQMNBozy4W64NXEkusL8nzM8Sl")
    RconPrint("^2["..GetCurrentResourceName().."] ^0: ^1Déconnexion^0 du joueur : ^5"..name.."^0 raison : ^5"..raison.."\n")
end)
