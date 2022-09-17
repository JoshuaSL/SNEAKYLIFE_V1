SneakyEvent = TriggerServerEvent


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local Components = {
	{label = 'Sexe',						name = 'sex',				value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = 'Visage',					name = 'face',				value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = 'Peau',					name = 'skin',				value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = 'Cheveux 1',					name = 'hair_1',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = 'Cheveux 2',					name = 'hair_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof = 'hair_1'},
	{label = 'Couleur cheveux 1',			name = 'hair_color_1',		value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = 'Couleur cheveux 2',			name = 'hair_color_2',		value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = 'T-Shirt 1',				name = 'tshirt_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = 'T-Shirt 2',				name = 'tshirt_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof = 'tshirt_1'},
	{label = 'Torse 1',					name = 'torso_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = 'Torse 2',					name = 'torso_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof = 'torso_1'},
	{label = 'Calques 1',				name = 'decals_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = 'Calques 2',				name = 'decals_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof = 'decals_1'},
	{label = 'Bras',					name = 'arms',				value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = 'Bras 2',					name = 'arms_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = 'Jambes 1',					name = 'pants_1',			value = 0,		min = 0,	zoomOffset = 0.8,		camOffset = -0.5},
	{label = 'Jambes 2',					name = 'pants_2',			value = 0,		min = 0,	zoomOffset = 0.8,		camOffset = -0.5,	textureof = 'pants_1'},
	{label = 'Chaussures 1',					name = 'shoes_1',			value = 0,		min = 0,	zoomOffset = 0.8,		camOffset = -0.8},
	{label = 'Chaussures 2',					name = 'shoes_2',			value = 0,		min = 0,	zoomOffset = 0.8,		camOffset = -0.8,	textureof = 'shoes_1'},
	{label = 'Masque 1',					name = 'mask_1',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = 'Masque 2',					name = 'mask_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof = 'mask_1'},
	{label = 'Gilet pare-balle 1',				name = 'bproof_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = 'Gilet pare-balle 2',				name = 'bproof_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof = 'bproof_1'},
	{label = 'Chaine 1',					name = 'chain_1',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = 'Chaine 2',					name = 'chain_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof = 'chain_1'},
	{label = 'Casque 1',				name = 'helmet_1',			value = -1,		min = -1,	zoomOffset = 0.6,		camOffset = 0.65,	componentId	= 0},
	{label = 'Casque 2',				name = 'helmet_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof = 'helmet_1'},
	{label = 'Lunettes 1',				name = 'glasses_1',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = 'Lunettes 2',				name = 'glasses_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof = 'glasses_1'},
	{label = 'Montre 1',				name = 'watches_1',			value = -1,		min = -1,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = 'Montre 2',				name = 'watches_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof = 'watches_1'},
	{label = 'Bracelet 1',				name = 'bracelets_1',		value = -1,		min = -1,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = 'Bracelet 2',				name = 'bracelets_2',		value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof = 'bracelets_1'},
	{label = 'Sac',						name = 'bags_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = 'Couleur sac',				name = 'bags_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof = 'bags_1'},
	{label = 'Lentilles colorées',				name = 'eye_color',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Taille sourcils',			name = 'eyebrows_2',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Type sourcils',			name = 'eyebrows_1',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Couleur sourcils 1',			name = 'eyebrows_3',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Couleur sourcils 2',			name = 'eyebrows_4',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Type maquillage',				name = 'makeup_1',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Épaisseur maquillage',		name = 'makeup_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Couleur maquillage 1',			name = 'makeup_3',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Couleur maquillage 2',			name = 'makeup_4',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Type lipstick',			name = 'lipstick_1',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Épaisseur lipstick',		name = 'lipstick_2',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Couleur lipstick 1',		name = 'lipstick_3',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Couleur lipstick 2',		name = 'lipstick_4',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Accessoire oreilles',			name = 'ears_1',			value = -1,		min = -1,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Couleur accessoire',	name = 'ears_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65,	textureof = 'ears_1'},
	{label = 'Pillositée torse',				name = 'chest_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = 'Opacité pillositée',			name = 'chest_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = 'Couleur pillositée',				name = 'chest_3',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = 'Imperfections',					name = 'bodyb_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = 'Imperfections taille',				name = 'bodyb_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = 'Rides',				name = 'age_1',				value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Épaisseur rides',		name = 'age_2',				value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Boutons',				name = 'blemishes_1',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Opacité des boutons',			name = 'blemishes_2',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Rougeur',					name = 'blush_1',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Opacité rougeur',					name = 'blush_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Couleur rougeur',				name = 'blush_3',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Teint',				name = 'complexion_1',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Opacité teint',			name = 'complexion_2',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Dommages UV',						name = 'sun_1',				value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Opacité dommages UV',					name = 'sun_2',				value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Taches de rousseur',				name = 'moles_1',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Opacité rousseur',				name = 'moles_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Type barbe',				name = 'beard_1',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Taille barbe',				name = 'beard_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Couleur barbe 1',			name = 'beard_3',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = 'Couleur barbe 2',			name = 'beard_4',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65}
}

local LastSex = -1
local LoadSkin = nil
local LoadClothes = nil
local Character = {}

for i = 1, #Components, 1 do
	Character[Components[i].name] = Components[i].value
end

function LoadDefaultModel(malePed, cb)
	local playerPed = PlayerPedId()
	local characterModel

	if malePed then
		characterModel = `mp_m_freemode_01`
	else
		characterModel = `mp_f_freemode_01`
	end

	Citizen.CreateThread(function()
		ESX.Streaming.RequestModel(characterModel, function()
			if IsModelInCdimage(characterModel) and IsModelValid(characterModel) then
				SetPlayerModel(PlayerId(), characterModel)
				SetPedDefaultComponentVariation(playerPed)
			end

			SetModelAsNoLongerNeeded(characterModel)

			if cb then
				cb()
			end

			TriggerEvent('Sneakyskinchanger:modelLoaded')
		end)
	end)
end

local HairsMale = {
    [0] = {
        name = "Rasé de près",
        collection = "mpbeach_overlays",
        overlay = "FM_Hair_Fuzz"
    },
    [38] = {
        name = "Faux Hawk",
        collection = "multiplayer_overlays",
        overlay = "NG_M_Hair_002"
    },
    [39] = {
        name = "Hipster",
        collection = "multiplayer_overlays",
        overlay = "NG_M_Hair_003"
    },
    [40] = {
        name = "Side Parting",
        collection = "multiplayer_overlays",
        overlay = "NG_M_Hair_004"
    },
    [41] = {
        name = "Shorter Cut",
        collection = "multiplayer_overlays",
        overlay = "NG_M_Hair_005"
    },
    [42] = {
        name = "Biker",
        collection = "multiplayer_overlays",
        overlay = "NG_M_Hair_006"
    },
    [43] = {
        name = "Ponytail",
        collection = "multiplayer_overlays",
        overlay = "NG_M_Hair_007"
    },
    [44] = {
        name = "Cornrows",
        collection = "multiplayer_overlays",
        overlay = "NG_M_Hair_008"
    },
    [45] = {
        collection = "multiplayer_overlays",
        overlay = "NG_M_Hair_009"
    },
    [46] = {
        name = "Short Brushed",
        collection = "multiplayer_overlays",
        overlay = "NG_M_Hair_013"
    },
    [47] = {
        name = "Spikey",
        collection = "multiplayer_overlays",
        overlay = "NG_M_Hair_002"
    },
    [48] = {
        name = "Caesar",
        collection = "multiplayer_overlays",
        overlay = "NG_M_Hair_011"
    },
    [49] = {
        name = "Chopped",
        collection = "multiplayer_overlays",
        overlay = "NG_M_Hair_012"
    },
    [50] = {
        name = "Dreads",
        collection = "multiplayer_overlays",
        overlay = "NG_M_Hair_014"
    },
    [51] = {
        name = "Long Hair",
        collection = "multiplayer_overlays",
        overlay = "NG_M_Hair_015"
    },
    [52] = {
        name = "Shaggy Curls",
        collection = "multiplayer_overlays",
        overlay = "NGBea_M_Hair_000"
    },
    [53] = {
        name = "Surfer Dude",
        collection = "multiplayer_overlays",
        overlay = "NGBea_M_Hair_001"
    },
    [54] = {
        name = "Short Side Part",
        collection = "multiplayer_overlays",
        overlay = "NGBus_M_Hair_000"
    },
    [55] = {
        name = "High Slicked Sides",
        collection = "multiplayer_overlays",
        overlay = "NGBus_M_Hair_001"
    },
    [56] = {
        name = "Long Slicked",
        collection = "multiplayer_overlays",
        overlay = "NGHip_M_Hair_000"
    },
    [57] = {
        name = "Hipster Youth",
        collection = "multiplayer_overlays",
        overlay = "NGHip_M_Hair_001"
    },
    [58] = {
        name = "Mullet",
        collection = "multiplayer_overlays",
        overlay = "NGInd_M_Hair_000"
    },
    [59] = {
        name = "Classic Cornrows",
        collection = "mplowrider_overlays",
        overlay = "LR_M_Hair_000"
    },
    [60] = {
        name = "Palm Cornrows",
        collection = "mplowrider_overlays",
        overlay = "LR_M_Hair_001"
    },
    [61] = {
        name = "Lightning Cornrows",
        collection = "mplowrider_overlays",
        overlay = "LR_M_Hair_002"
    },
    [62] = {
        name = "Whipped Cornrows",
        collection = "mplowrider_overlays",
        overlay = "LR_M_Hair_003"
    },
    [63] = {
        name = "Zig Zag Cornrows",
        collection = "mplowrider2_overlays",
        overlay = "LR_M_Hair_004"
    },
    [64] = {
        name = "Snail Cornrows",
        collection = "mplowrider2_overlays",
        overlay = "LR_M_Hair_005"
    },
    [65] = {
        name = "Hightop",
        collection = "mplowrider2_overlays",
        overlay = "LR_M_Hair_006"
    },
    [66] = {
        name = "Loose Swept Back",
        collection = "mpbiker_overlays",
        overlay = "MP_Biker_Hair_000_M"
    },
    [67] = {
        name = "Undercut Swept Back",
        collection = "mpbiker_overlays",
        overlay = "MP_Biker_Hair_001_M"
    },
    [68] = {
        name = "Undercut Swept Side",
        collection = "mpbiker_overlays",
        overlay = "MP_Biker_Hair_002_M"
    },
    [69] = {
        name = "Spiked Mohawk",
        collection = "mpbiker_overlays",
        overlay = "MP_Biker_Hair_003_M"
    },
    [70] = {
        name = "Mod",
        collection = "mpbiker_overlays",
        overlay = "MP_Biker_Hair_004_M"
    },
    [71] = {
        name = "Layered Mod",
        collection = "mpbiker_overlays",
        overlay = "MP_Biker_Hair_005_M"
    },
    [72] = {
        name = "Flattop",
        collection = "mpgunrunning_overlays",
        overlay = "MP_Gunrunning_Hair_M_000_M"
    },
    [73] = {
        name = "Military Buzzcut",
        collection = "mpgunrunning_overlays",
        overlay = "MP_Gunrunning_Hair_M_001_M"
    },
    [74] = {
        name = "Banane",
        collection = "mpgunrunning_overlays",
        overlay = "MP_Gunrunning_Hair_M_001_M"
    },
    [75] = {
        name = "Longue queue",
        collection = "mpbeach_overlays",
        overlay = "FM_Hair_Fuzz"
    },
    [76] = {
        name = "Chignon",
        collection = "mpbeach_overlays",
        overlay = "FM_Hair_Fuzz"
    },
    [77] = {
        name = "Queue courte",
        collection = "mpbeach_overlays",
        overlay = "FM_Hair_Fuzz"
    },
    [78] = {
        name = "Biker",
        collection = "mpbeach_overlays",
        overlay = "FM_Hair_Fuzz"
    },
    [79] = {
        name = "Pecno",
        collection = "mpbeach_overlays",
        overlay = "FM_Hair_Fuzz"
    },
    [80] = {
        name = "Trunks",
        collection = "multiplayer_overlays",
        overlay = "NG_M_Hair_012"
    },
    [81] = {
        name = "Buzz",
        collection = "mpbeach_overlays",
        overlay = "FM_Hair_Fuzz"
    },
    [82] = {
        name = "Sage",
        collection = "mpbeach_overlays",
        overlay = "FM_Hair_Fuzz"
    },
    [83] = {
        name = "Boucle",
        collection = "mpbeach_overlays",
        overlay = "FM_Hair_Fuzz"
    },
}

local HairsFemale = {
    [1] = {
		name = "Crâne rasé",
		collection = "mpbeach_overlays",
		overlay = "FM_Hair_Fuzz"
    },
    [39] = {
		name = "Short",
		collection = "multiplayer_overlays",
		overlay = "NG_F_Hair_001"
    },
	[40] = {
		name = "Layered Bob",
		collection = "multiplayer_overlays",
		overlay = "NG_F_Hair_002"
    },
	[41] = {
		name = "Pigtails",
		collection = "multiplayer_overlays",
		overlay = "NG_F_Hair_003"
    },
	[42] = {
		name = "Ponytail",
		collection = "multiplayer_overlays",
		overlay = "NG_F_Hair_004"
    },
	[43] = {
		name = "Braided Mohawk",
		collection = "multiplayer_overlays",
		overlay = "NG_F_Hair_005"
    },
	[44] = {
		name = "Braids",
		collection = "multiplayer_overlays",
		overlay = "NG_F_Hair_006"
    },
	[45] = {
		name = "Bob",
		collection = "multiplayer_overlays",
		overlay = "NG_F_Hair_007"
    },
	[46] = {
		name = "Faux Hawk",
		collection = "multiplayer_overlays",
		overlay = "NG_F_Hair_008"
    },
	[47] = {
		name = "French Twist",
		collection = "multiplayer_overlays",
		overlay = "NG_F_Hair_009"
    },
	[48] = {
		name = "Long Bob",
		collection = "multiplayer_overlays",
		overlay = "NG_F_Hair_010"
    },
	[49] = {
		name = "Loose Tied",
		collection = "multiplayer_overlays",
		overlay = "NG_F_Hair_011"
    },
	[50] = {
		name = "Pixie",
		collection = "multiplayer_overlays",
		overlay = "NG_F_Hair_012"
    },
	[51] = {
		name = "Shaved Bangs",
		collection = "multiplayer_overlays",
		overlay = "NG_F_Hair_013"
    },
	[52] = {
		name = "Top Knot",
		collection = "multiplayer_overlays",
		overlay = "NG_M_Hair_014"
    },
	[53] = {
		name = "Wavy Bob",
		collection = "multiplayer_overlays",
		overlay = "NG_M_Hair_015"
    },
	[54] = {
		name = "Messy Bun",
		collection = "multiplayer_overlays",
		overlay = "NGBea_F_Hair_000"
    },
	[55] = {
		name = "Pin Up Girl",
		collection = "multiplayer_overlays",
		overlay = "NGBea_F_Hair_001"
    },
	[56] = {
		name = "Tight Bun",
		collection = "multiplayer_overlays",
		overlay = "NG_F_Hair_007"
    },
	[57] = {
		name = "Twisted Bob",
		collection = "multiplayer_overlays",
		overlay = "NGBus_F_Hair_000"
    },
	[58] = {
		name = "Flapper Bob",
		collection = "multiplayer_overlays",
		overlay = "NGBus_F_Hair_001"
    },
	[59] = {
		name = "Big Bangs",
		collection = "multiplayer_overlays",
		overlay = "NGBea_F_Hair_001"
    },
	[60] = {
		name = "Braided Top Knot",
		collection = "multiplayer_overlays",
		overlay = "NGHip_F_Hair_000"
    },
	[61] = {
		name = "Mullet",
		collection = "multiplayer_overlays",
		overlay = "NGInd_F_Hair_000"
    },
	[62] = {
		name = "Pinched Cornrows",
		collection = "mplowrider_overlays",
		overlay = "LR_F_Hair_000"
    },
	[63] = {
		name = "Leaf Cornrows",
		collection = "mplowrider_overlays",
		overlay = "LR_F_Hair_001"
    },
	[64] = {
		name = "Zig Zag Cornrows",
		collection = "mplowrider_overlays",
		overlay = "LR_F_Hair_002"
    },
	[65] = {
		name = "Pigtail Bangs",
		collection = "mplowrider2_overlays",
		overlay = "LR_F_Hair_003"
    },
	[66] = {
		name = "Wave Braids",
		collection = "mplowrider2_overlays",
		overlay = "LR_F_Hair_003"
    },
	[67] = {
		name = "Coil Braids",
		collection = "mplowrider2_overlays",
		overlay = "LR_F_Hair_004"
    },
	[68] = {
		name = "Rolled Quiff",
		collection = "mplowrider2_overlays",
		overlay = "LR_F_Hair_006"
    },
	[69] = {
		name = "Loose Swept Back",
		collection = "mpbiker_overlays",
		overlay = "MP_Biker_Hair_000_F"
    },
	[70] = {
		name = "Undercut Swept Back",
		collection = "mpbiker_overlays",
		overlay = "MP_Biker_Hair_001_F"
    },
	[71] = {
		name = "Undercut Swept Side",
		collection = "mpbiker_overlays",
		overlay = "MP_Biker_Hair_002_F"
    },
	[72] = {
		name = "Spiked Mohawk",
		collection = "mpbiker_overlays",
		overlay = "MP_Biker_Hair_003_F"
    },
	[73] = {
		name = "Bandana and Braid",
		collection = "multiplayer_overlays",
		overlay = "NG_F_Hair_003"
    },
	[74] = {
		name = "Layered Mod",
		collection = "mpbiker_overlays",
		overlay = "MP_Biker_Hair_006_F"
    },
	[75] = {
		name = "Skinbyrd",
		collection = "mpbiker_overlays",
		overlay = "MP_Biker_Hair_004_F"
    },
	[76] = {
		name = "Neat Bun",
		collection = "mpgunrunning_overlays",
		overlay = "MP_Gunrunning_Hair_F_000_F"
    },
	[77] = {
		name = "Short Bob",
		collection = "mpgunrunning_overlays",
		overlay = "MP_Gunrunning_Hair_F_001_F"
    },
	[78] = {
		name = "Banane",
		collection = "mpgunrunning_overlays",
		overlay = "MP_Gunrunning_Hair_M_001_M"
    },
	[79] = {
		name = "Long",
		collection = "mpbeach_overlays",
		overlay = "FM_Hair_Fuzz"
    },
	[80] = {
		name = "Pony tails",
		collection = "mpbeach_overlays",
		overlay = "FM_Hair_Fuzz"
    },
	[81] = {
		name = "Court",
		collection = "mpbeach_overlays",
		overlay = "FM_Hair_Fuzz"
    },
	[82] = {
		name = "Long épaule",
		collection = "mpbeach_overlays",
		overlay = "FM_Hair_Fuzz"
    },
	[83] = {
		name = "Simpliste",
		collection = "mpbeach_overlays",
		overlay = "FM_Hair_Fuzz"
    },
	[84] = {
		name = "Cube",
		collection = "mpbeach_overlays",
		overlay = "FM_Hair_Fuzz"
    },
	[85] = {
		name = "Dread",
		collection = "mpbeach_overlays",
		overlay = "FM_Hair_Fuzz"
    },
	[86] = {
		name = "Classique"
    },
	[87] = {
		name = "Coiffure 09",
		collection = "mpbeach_overlays",
		overlay = "FM_Hair_Fuzz"
    },
	[88] = {
		name = "Coiffure 10",
		collection = "mpbeach_overlays",
		overlay = "FM_Hair_Fuzz"
    },
	[89] = {
		name = "Coiffure 11",
		collection = "mpbeach_overlays",
		overlay = "FM_Hair_Fuzz"
    },
	[90] = {
		name = "Coiffure 12",
		collection = "mpbeach_overlays",
		overlay = "FM_Hair_Fuzz"
    },
	[91] = {
		name = "Coiffure 13",
		collection = "mpbeach_overlays",
		overlay = "FM_Hair_Fuzz"
    },
	[92] = {
		name = "Coiffure 14",
		collection = "mpbeach_overlays",
		overlay = "FM_Hair_Fuzz"
    },
	[93] = {
		name = "Coiffure 15",
		collection = "mpbeach_overlays",
		overlay = "FM_Hair_Fuzz"
    },
	[84] = {
		name = "Coiffure 16",
		collection = "mpbeach_overlays",
		overlay = "FM_Hair_Fuzz"
    },
}

function GetMaxVals()
	local playerPed = PlayerPedId()

	local data = {
		sex = 1,
		face = 45,
		skin = 45,
		age_1 = GetNumHeadOverlayValues(3) - 1,
		age_2 = 10,
		beard_1 = GetNumHeadOverlayValues(1) - 1,
		beard_2 = 10,
		beard_3 = GetNumHairColors() - 1,
		beard_4 = GetNumHairColors() - 1,
		hair_1 = GetNumberOfPedDrawableVariations(playerPed, 2) - 1,
		hair_2 = GetNumberOfPedTextureVariations(playerPed, 2, Character['hair_1']) - 1,
		hair_color_1 = GetNumHairColors() - 1,
		hair_color_2 = GetNumHairColors() - 1,
		eye_color = 31,
		eyebrows_1 = GetNumHeadOverlayValues(2) - 1,
		eyebrows_2 = 10,
		eyebrows_3 = GetNumHairColors() - 1,
		eyebrows_4 = GetNumHairColors() - 1,
		makeup_1 = GetNumHeadOverlayValues(4) - 1,
		makeup_2 = 10,
		makeup_3 = GetNumHairColors() - 1,
		makeup_4 = GetNumHairColors() - 1,
		lipstick_1 = GetNumHeadOverlayValues(8) - 1,
		lipstick_2 = 10,
		lipstick_3 = GetNumHairColors() - 1,
		lipstick_4 = GetNumHairColors() - 1,
		blemishes_1 = GetNumHeadOverlayValues(0) - 1,
		blemishes_2 = 10,
		blush_1 = GetNumHeadOverlayValues(5) - 1,
		blush_2 = 10,
		blush_3 = GetNumHairColors() - 1,
		complexion_1 = GetNumHeadOverlayValues(6) - 1,
		complexion_2 = 10,
		sun_1 = GetNumHeadOverlayValues(7) - 1,
		sun_2 = 10,
		moles_1 = GetNumHeadOverlayValues(9) - 1,
		moles_2 = 10,
		chest_1 = GetNumHeadOverlayValues(10) - 1,
		chest_2 = 10,
		chest_3 = GetNumHairColors() - 1,
		bodyb_1 = GetNumHeadOverlayValues(11) - 1,
		bodyb_2 = 10,
		ears_1 = GetNumberOfPedPropDrawableVariations(playerPed, 1) - 1,
		ears_2 = GetNumberOfPedPropTextureVariations(playerPed, 1, Character['ears_1']) - 1,
		tshirt_1 = GetNumberOfPedDrawableVariations(playerPed, 8) - 1,
		tshirt_2 = GetNumberOfPedTextureVariations(playerPed, 8, Character['tshirt_1']) - 1,
		torso_1 = GetNumberOfPedDrawableVariations(playerPed, 11) - 1,
		torso_2 = GetNumberOfPedTextureVariations(playerPed, 11, Character['torso_1']) - 1,
		decals_1 = GetNumberOfPedDrawableVariations(playerPed, 10) - 1,
		decals_2 = GetNumberOfPedTextureVariations(playerPed, 10, Character['decals_1']) - 1,
		arms = GetNumberOfPedDrawableVariations(playerPed, 3) - 1,
		arms_2 = 10,
		pants_1 = GetNumberOfPedDrawableVariations(playerPed, 4) - 1,
		pants_2 = GetNumberOfPedTextureVariations(playerPed, 4, Character['pants_1']) - 1,
		shoes_1 = GetNumberOfPedDrawableVariations(playerPed, 6) - 1,
		shoes_2 = GetNumberOfPedTextureVariations(playerPed, 6, Character['shoes_1']) - 1,
		mask_1 = GetNumberOfPedDrawableVariations(playerPed, 1) - 1,
		mask_2 = GetNumberOfPedTextureVariations(playerPed, 1, Character['mask_1']) - 1,
		bproof_1 = GetNumberOfPedDrawableVariations(playerPed, 9) - 1,
		bproof_2 = GetNumberOfPedTextureVariations(playerPed, 9, Character['bproof_1']) - 1,
		chain_1 = GetNumberOfPedDrawableVariations(playerPed, 7) - 1,
		chain_2 = GetNumberOfPedTextureVariations(playerPed, 7, Character['chain_1']) - 1,
		bags_1 = GetNumberOfPedDrawableVariations(playerPed, 5) - 1,
		bags_2 = GetNumberOfPedTextureVariations(playerPed, 5, Character['bags_1']) - 1,
		helmet_1 = GetNumberOfPedPropDrawableVariations(playerPed, 0) - 1,
		helmet_2 = GetNumberOfPedPropTextureVariations(playerPed, 0, Character['helmet_1']) - 1,
		glasses_1 = GetNumberOfPedPropDrawableVariations(playerPed, 1) - 1,
		glasses_2 = GetNumberOfPedPropTextureVariations(playerPed, 1, Character['glasses_1'] - 1),
		watches_1 = GetNumberOfPedPropDrawableVariations(playerPed, 6) - 1,
		watches_2 = GetNumberOfPedPropTextureVariations(playerPed, 6, Character['watches_1']) - 1,
		bracelets_1 = GetNumberOfPedPropDrawableVariations(playerPed, 7) - 1,
		bracelets_2 = GetNumberOfPedPropTextureVariations(playerPed, 7, Character['bracelets_1']) - 1
	}

	return data
end

function ApplySkin(skin, clothes)
	local playerPed = PlayerPedId()

	for k, v in pairs(skin) do
		Character[k] = v
	end

	if clothes ~= nil then
		for k, v in pairs(clothes) do
			if
				k ~= 'sex' and
				k ~= 'face' and
				k ~= 'skin' and
				k ~= 'age_1' and
				k ~= 'age_2' and
				k ~= 'eye_color' and
				k ~= 'beard_1' and
				k ~= 'beard_2' and
				k ~= 'beard_3' and
				k ~= 'beard_4' and
				k ~= 'hair_1' and
				k ~= 'hair_2' and
				k ~= 'hair_color_1' and
				k ~= 'hair_color_2' and
				k ~= 'eyebrows_1' and
				k ~= 'eyebrows_2' and
				k ~= 'eyebrows_3' and
				k ~= 'eyebrows_4' and
				k ~= 'makeup_1' and
				k ~= 'makeup_2' and
				k ~= 'makeup_3' and
				k ~= 'makeup_4' and
				k ~= 'lipstick_1' and
				k ~= 'lipstick_2' and
				k ~= 'lipstick_3' and
				k ~= 'lipstick_4' and
				k ~= 'blemishes_1' and
				k ~= 'blemishes_2' and
				k ~= 'blush_1' and
				k ~= 'blush_2' and
				k ~= 'blush_3' and
				k ~= 'complexion_1' and
				k ~= 'complexion_2' and
				k ~= 'sun_1' and
				k ~= 'sun_2' and
				k ~= 'moles_1' and
				k ~= 'moles_2' and
				k ~= 'chest_1' and
				k ~= 'chest_2' and
				k ~= 'chest_3' and
				k ~= 'bodyb_1' and
				k ~= 'bodyb_2'
			then
				Character[k] = v
			end
		end
	end

	SetPedHeadBlendData(playerPed, Character['face'], Character['face'], Character['face'], Character['skin'], Character['skin'], Character['skin'], 1.0, 1.0, 1.0, true)

	SetPedHairColor(playerPed, Character['hair_color_1'], Character['hair_color_2']) -- Hair Color
	SetPedHeadOverlay(playerPed, 3, Character['age_1'], (Character['age_2'] / 10) + 0.0) -- Age + opacity
	SetPedHeadOverlay(playerPed, 1, Character['beard_1'], (Character['beard_2'] / 10) + 0.0) -- Beard + opacity
	SetPedEyeColor(playerPed, Character['eye_color'], 0, 1) -- Eyes color
	SetPedHeadOverlay(playerPed, 2, Character['eyebrows_1'], (Character['eyebrows_2'] / 10) + 0.0) -- Eyebrows + opacity
	SetPedHeadOverlay(playerPed, 4, Character['makeup_1'], (Character['makeup_2'] / 10) + 0.0) -- Makeup + opacity
	SetPedHeadOverlay(playerPed, 8, Character['lipstick_1'], (Character['lipstick_2'] / 10) + 0.0) -- Lipstick + opacity
	SetPedComponentVariation(playerPed, 2, Character['hair_1'], Character['hair_2'], 2) -- Hair
	SetPedHeadOverlayColor(playerPed, 1, 1,	Character['beard_3'], Character['beard_4']) -- Beard Color
	SetPedHeadOverlayColor(playerPed, 2, 1,	Character['eyebrows_3'], Character['eyebrows_4']) -- Eyebrows Color
	SetPedHeadOverlayColor(playerPed, 4, 1,	Character['makeup_3'], Character['makeup_4']) -- Makeup Color
	SetPedHeadOverlayColor(playerPed, 8, 1,	Character['lipstick_3'], Character['lipstick_4']) -- Lipstick Color
	SetPedHeadOverlay(playerPed, 5, Character['blush_1'], (Character['blush_2'] / 10) + 0.0) -- Blush + opacity
	SetPedHeadOverlayColor(playerPed, 5, 2,	Character['blush_3']) -- Blush Color
	SetPedHeadOverlay(playerPed, 6, Character['complexion_1'], (Character['complexion_2'] / 10) + 0.0) -- Complexion + opacity
	SetPedHeadOverlay(playerPed, 7, Character['sun_1'], (Character['sun_2'] / 10) + 0.0) -- Sun Damage + opacity
	SetPedHeadOverlay(playerPed, 9, Character['moles_1'], (Character['moles_2'] / 10) + 0.0) -- Moles/Freckles + opacity
	SetPedHeadOverlay(playerPed, 10, Character['chest_1'], (Character['chest_2'] / 10) + 0.0) -- Chest Hair + opacity
	SetPedHeadOverlayColor(playerPed, 10, 1, Character['chest_3']) -- Torso Color
	SetPedHeadOverlay(playerPed, 11, Character['bodyb_1'], (Character['bodyb_2'] / 10) + 0.0) -- Body Blemishes + opacity

	if Character['ears_1'] == -1 then
		ClearPedProp(playerPed, 2)
	else
		SetPedPropIndex(playerPed, 2, Character['ears_1'], Character['ears_2'], 2) -- Ears Accessories
	end

	SetPedComponentVariation(playerPed, 8, Character['tshirt_1'], Character['tshirt_2'], 2) -- Tshirt
	SetPedComponentVariation(playerPed, 11, Character['torso_1'], Character['torso_2'], 2) -- torso parts
	SetPedComponentVariation(playerPed, 3, Character['arms'], Character['arms_2'], 2) -- Arms
	SetPedComponentVariation(playerPed, 10, Character['decals_1'], Character['decals_2'], 2) -- decals
	SetPedComponentVariation(playerPed, 4, Character['pants_1'], Character['pants_2'], 2) -- pants
	SetPedComponentVariation(playerPed, 6, Character['shoes_1'], Character['shoes_2'], 2) -- shoes
	SetPedComponentVariation(playerPed, 1, Character['mask_1'], Character['mask_2'], 2) -- mask
	SetPedComponentVariation(playerPed, 9, Character['bproof_1'], Character['bproof_2'], 2) -- bulletproof
	SetPedComponentVariation(playerPed, 7, Character['chain_1'], Character['chain_2'], 2) -- chain
	SetPedComponentVariation(playerPed, 5, Character['bags_1'], Character['bags_2'], 2) -- Bag

	if Character['helmet_1'] == -1 then
		ClearPedProp(playerPed, 0)
	else
		SetPedPropIndex(playerPed, 0, Character['helmet_1'], Character['helmet_2'], 2) -- Helmet
	end

	if Character['glasses_1'] == -1 then
		ClearPedProp(playerPed, 1)
	else
		SetPedPropIndex(playerPed, 1, Character['glasses_1'], Character['glasses_2'], 2) -- Glasses
	end

	if Character['watches_1'] == -1 then
		ClearPedProp(playerPed, 6)
	else
		SetPedPropIndex(playerPed, 6, Character['watches_1'], Character['watches_2'], 2) -- Watches
	end

	if Character['bracelets_1'] == -1 then
		ClearPedProp(playerPed,	7)
	else
		SetPedPropIndex(playerPed, 7, Character['bracelets_1'], Character['bracelets_2'], 2) -- Bracelets
	end

	if Character['bproof_1'] == 0 then
		SetPedArmour(playerPed, 0)
	else
		SetPedArmour(playerPed, 0)
	end
	if (GetEntityModel(PlayerPedId()) == GetHashKey('mp_m_freemode_01')) then
		if HairsMale[Character['hair_1']] == nil then
			return
		else
			ClearPedDecorations(PlayerPedId())
			AddPedDecorationFromHashes(PlayerPedId(), HairsMale[Character['hair_1']].collection, HairsMale[Character['hair_1']].overlay)
		end
    else
		if HairsFemale[Character['hair_1']] == nil then
			return
		else
			ClearPedDecorations(PlayerPedId())
			AddPedDecorationFromHashes(PlayerPedId(), HairsFemale[Character['hair_1']].collection, HairsFemale[Character['hair_1']].overlay)
		end
    end
end
RegisterNetEvent("SneakyClothes:RequestHairFade")
AddEventHandler("SneakyClothes:RequestHairFade",function(skin)
	local table = json.decode(skin.skin)
	print(table.hair_1)
	if (GetEntityModel(PlayerPedId()) == GetHashKey('mp_m_freemode_01')) then
		if HairsMale[table.hair_1] == nil then
			return
		else
			ClearPedDecorations(PlayerPedId())
			AddPedDecorationFromHashes(PlayerPedId(), HairsMale[table.hair_1].collection, HairsMale[table.hair_1].overlay)
		end
	else
		if HairsFemale[table.hair_1] == nil then
			return
		else
			ClearPedDecorations(PlayerPedId())
			AddPedDecorationFromHashes(PlayerPedId(), HairsFemale[table.hair_1].collection, HairsFemale[table.hair_1].overlay)
		end
	end
end)

AddEventHandler('Sneakyskinchanger:loadDefaultModel', function(loadMale, cb)
	LoadDefaultModel(loadMale, cb)
end)


RegisterCommand("clearjojo",function()
	ClearPedDecorations(PlayerPedId())
end)

AddEventHandler('Sneakyskinchanger:getData', function(cb)
	local components = json.decode(json.encode(Components))

	for k, v in pairs(Character) do
		for i = 1, #components, 1 do
			if k == components[i].name then
				components[i].value = v
			end
		end
	end

	cb(components, GetMaxVals())
end)

AddEventHandler('Sneakyskinchanger:change', function(key, val)
	Character[key] = val

	if key == 'sex' then
		TriggerEvent('Sneakyskinchanger:loadSkin', Character)
	else
		ApplySkin(Character)
	end
end)

AddEventHandler('Sneakyskinchanger:getSkin', function(cb)
	cb(Character)
end)

AddEventHandler('Sneakyskinchanger:modelLoaded', function()
	ClearPedProp(PlayerPedId(), 0)

	if LoadSkin ~= nil then
		ApplySkin(LoadSkin)
		LoadSkin = nil
	end

	if LoadClothes ~= nil then
		ApplySkin(LoadClothes.playerSkin, LoadClothes.clothesSkin)
		LoadClothes = nil
	end
end)

RegisterNetEvent('Sneakyskinchanger:loadSkin')
AddEventHandler('Sneakyskinchanger:loadSkin', function(skin, cb)
	if skin['sex'] ~= LastSex then
		LoadSkin = skin

		if skin['sex'] == 0 then
			TriggerEvent('Sneakyskinchanger:loadDefaultModel', true, cb)
		else
			TriggerEvent('Sneakyskinchanger:loadDefaultModel', false, cb)
		end
	else
		ApplySkin(skin)

		if cb then
			cb()
		end
	end

	LastSex = skin['sex']
end)

RegisterNetEvent('Sneakyskinchanger:loadClothes')
AddEventHandler('Sneakyskinchanger:loadClothes', function(playerSkin, clothesSkin)
	if playerSkin['sex'] ~= LastSex then
		LoadClothes = {
			playerSkin = playerSkin,
			clothesSkin = clothesSkin
		}

		if playerSkin['sex'] == 0 then
			TriggerEvent('Sneakyskinchanger:loadDefaultModel', true)
		else
			TriggerEvent('Sneakyskinchanger:loadDefaultModel', false)
		end
	else
		ApplySkin(playerSkin, clothesSkin)
	end

	LastSex = playerSkin['sex']
end)