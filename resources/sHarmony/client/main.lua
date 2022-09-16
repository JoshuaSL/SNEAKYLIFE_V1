ESX = nil
--local rgbArray = {}
local Vehicles = {}
local PlayerData = {}
local lsMenuIsShowed = false
local isInLSMarker = false
local myCar = {}
local vehicleClass = nil
local vehiclePrice = 150000
SneakyEvent = TriggerServerEvent
local shopProfitValue = 0
local shopProfit = 50
local shopCart = {}
local totalCartValue = 0
local canClose = false
local society = ""
local stop = false
local deleting = false

local mainMenu = nil 
local bodyMenu = nil
local extrasMenu = nil
local colorMenu = nil
local neonMenu = nil
local upgradeMenu = nil
local cartMenu = nil

local tempBodyParts = nil
local tempExtras = nil
local tempColorParts = nil
local tempNeons = nil
local tempUpgrades = nil
IsMotorCycleBikerOnly = false
IsHarmonyJobOnly = true
Zones = {
	ls1 = {
		Pos   = { x = 1174.7534179688, y = 2641.0729980469, z = 37.247253417969},
		Size  = {x = 3.0, y = 3.0, z = 0.2},
		Color = {r = 204, g = 204, b = 0},
		Marker= 27,
		Name  = "Harmony's and Repairs",
		Hint  = 'appuyez sur ~INPUT_PICKUP~ pour personnaliser le véhicule.'
	},
	ls2 = {
		Pos   = { x = 1182.1104736328, y = 2640.2131347656, z = 37.2470703125},
		Size  = {x = 3.0, y = 3.0, z = 0.2},
		Color = {r = 204, g = 204, b = 0},
		Marker= 27,
		Name  = "Harmony's and Repairs",
		Hint  = 'appuyez sur ~INPUT_PICKUP~ pour personnaliser le véhicule.'
	},
}

colorParts = {
	label = { 'Primaire', 'Secondaire', 'Nacré', 'Fenêtres'},
	mod = { 'primary', 'secondary', 'pearlescent', 'windows' },
	wheelColorPrice = 1.58,
	primaryColorPrice = 3,
	secondaryColorPrice = 2,
	pearlescentColorPrice = 2,
	customPrimaryColorPrice = 2,
	customSecondaryColorPrice = 2,
	primaryPaintFinishPrice = 3,
	secondaryPaintFinishPrice = 2,
	interiorColorPrice = 1
}

bodyParts = {
	[1] = {
		mod = 'modSpoilers',
		label = 'Aileron',
		modType = 0,
		items = {
			label = {},
			price = 2.65
		}
	},
	[2] = {
		mod = 'modFrontBumper',
		label = 'Pare-choc avant',
		modType = 1,
		items = {
			label = {},
			price = 2.12
		}
	},
	[3] = {
		mod = 'modRearBumper',
		label = 'Pare-choc arrière',
		modType = 2,
		items = {
			label = {},
			price = 2.12
		}
	},
	[4] = {
		mod = 'modSideSkirt',
		label = 'Bas de caisse',
		modType = 3,
		items = {
			label = {},
			price = 2.65
		}
	},
	[5] = {
		mod = 'modExhaust',
		label = 'Pot d\'échappement',
		modType = 4,
		items = {
			label = {},
			price = 2.12
		}
	},
	[6] = {
		mod = 'modFrame',
		label = 'Cage',
		modType = 5,
		items = {
			label = {},
			price = 2.12
		}
	},
	[7] = {
		mod = 'modGrille',
		label = 'Grille',
		modType = 6,
		items = {
			label = {},
			price = 1.72
		}
	},
	[8] = {
		mod = 'modHood',
		label = 'Capot',
		modType = 7,
		items = {
			label = {},
			price = 2.88
		}
	},
	[9] = {
		mod = 'modFender',
		label = 'Aile gauche',
		modType = 8,
		items = {
			label = {},
			price = 2.12
		}
	},
	[10] = {
		mod = 'modRightFender',
		label = 'Aile droite',
		modType = 9,
		items = {
			label = {},
			price = 2.12
		}
	},
	[11] = {
		mod = 'modRoof',
		label = 'Toit',
		modType = 10,
		items = {
			label = {},
			price = 2.58
		}
	},
	[12] = {
		mod = 'wheels',
		label = 'Types de jantes',
		items = { 'Sport', 'Muscle', 'Lowrider', 'SUV', 'Offroad', 'Tuner', 'Moto', 'High end', 'Bespokes Originals', 'Bespokes Smokes', 'Course', 'Sreet', 'Tuner'},
		modType = 23,
		wheelType = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12},
	},
	[13] = {
		mod = 'modFrontWheels',
		label = 'Roues',
		modType = 23,
		items = {
			label = {},
			price = 2.58
		}
	}
}

windowTints = { 
	mod = 'windowTint',
	label = { '[1/7]', '[2/7]', '[3/7]', '[4/7]', '[5/7]', '[6/7]', '[7/7]' },
	label1 = 'Fenêtres',
	tint = { -1, 0, 1, 2, 3, 4, 5 },
	price = 2.58
}

xenon = {
	mod = 'modXenon',
	label = 'Phares xénon',
	mod1 = 'xenonColor',
	label1 = 'xénon',
	items = {
		label = { '[1/14]', '[2/14]', '[3/14]', '[4/14]', '[5/14]', '[6/14]', '[7/14]', '[8/14]', '[9/14]', '[10/14]', '[11/14]', '[12/14]', '[13/14]', '[14/14]' },
		color = { -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 }
	},
	price = 2
}

colorPalette = {
	[1] = { 
		metallic = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 49, 50, 51, 52, 53, 54, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 112, 125, 137, 141, 142, 143, 145, 146, 150, 156 }
	},
	[2] = { 
		matte = { 12, 13, 14, 39, 40, 41, 42, 55, 82, 83, 84, 128, 129, 131, 148, 149, 151, 152, 153, 154, 155 }
	},
	[3] = { 
		util = { 15, 16, 17, 18, 19, 20, 43, 44, 45, 56, 57, 75, 76, 77, 78, 79, 80, 81, 108, 109, 110, 122 }
	},
	[4] = { 
		worn = { 21, 22, 23, 24, 25, 26, 47, 48, 58, 59, 60, 85, 86, 87, 113, 114, 115, 116, 121, 123, 124, 126, 130, 132, 133 }
	},
	[5] = { 
		brushed = { 117, 118, 119, 159 }
	},
	[6] = { 
		others = { 120, 127, 134, 135, 136, 138, 139, 140, 144, 147, 157, 158 }
	},
	[7] = {
		personalize = {  }
	},
	[8] = { 
		wheelPrice = 2.58
	}
}

paintFinish = { 0, 12, 15, 21, 117, 120 }

neons = {
	[1] = {
		mod = 'leftNeon',
		label = "Néon gauche",
		price = 2.49
	},
	[2] = {
		mod = 'rightNeon',
		label = "Néon droit",
		price = 2.49
	},
	[3] = {
		mod = 'frontNeon',
		label = "Néon avant",
		price = 2.49
	},
	[4] = {
		mod = 'backNeon',
		label = "Néon arrière",
		price = 2.49
	},
	[5] = {
		label = 'Cor neon',
		mod = 'neonColor',
		mod1 = 'neonEnabled',
		price = 2.49
	}
}

extras = {
	[1] = {
		mod = 'modPlateHolder',
		label = 'Plaque arrière',
		modType = 25,
		items = {
			label = {},
			price = 3.49
		}
	},
	[2] = {
		mod = 'modVanityPlate',
		label = 'Plaque avant',
		modType = 26,
		items = {
			label = {},
			price = 1.1
		}
	},
	[3] = {
		mod = 'modTrimA',
		label = 'Intérieur',
		modType = 27,
		items = {
			label = {},
			price = 3.98
		}
	},
	[4] = {
		mod = 'modOrnaments',
		label = 'Accessoires',
		modType = 28,
		items = {
			label = {},
			price = 0.9
		}
	},
	[5] = {
		mod = 'modDashboard',
		label = 'Tableau de bord',
		modType = 29,
		items = {
			label = {},
			price = 2.65
		}
	},
	[6] = {
		mod = 'modDial',
		label = 'Compteur de vitesse',
		modType = 30,
		items = {
			label = {},
			price = 2.19
		}
	},
	[7] = {
		mod = 'modDoorSpeaker',
		label = 'Haut-parleurs - portières',
		modType = 31,
		items = {
			label = {},
			price = 2.58
		}
	},
	[8] = {
		mod = 'modSeats',
		label = 'Sièges',
		modType = 32,
		items = {
			label = {},
			price = 2.65
		}
	},
	[9] = {
		mod = 'modSteeringWheel',
		label = 'Volant',
		modType = 33,
		items = {
			label = {},
			price = 2.19
		}
	},
	[10] = {
		mod = 'modShifterLeavers',
		label = 'Levier de vitesse',
		modType = 34,
		items = {
			label = {},
			price = 1.26
		}
	},
	[11] = {
		mod = 'modAPlate',
		label = 'Plage arrière',
		modType = 35,
		items = {
			label = {},
			price = 2.19
		}
	},
	[12] = {
		mod = 'modSpeakers',
		label = 'Haut-parleurs',
		modType = 36,
		items = {
			label = {},
			price = 2.98
		}
	},
	[13] = {
		mod = 'modTrunk',
		label = 'Coffre',
		modType = 37,
		items = {
			label = {},
			price = 2.58
		}
	},
	[14] = {
		mod = 'modHydrolic',
		label = 'Suspension hydraulique',
		modType = 38,
		items = {
			label = {},
			price = 2.12
		}
	},
	[15] = {
		mod = 'modEngineBlock',
		label = 'Bloc moteur',
		parent = 'cosmetics',
		modType = 39,
		items = {
			label = {},
			price = 2.12
		}
	},
	[16] = {
		mod = 'modAirFilter',
		label = 'Filtre à air',
		modType = 40,
		items = {
			label = {},
			price = 2.72
		}
	},
	[17] = {
		mod = 'modStruts',
		label = 'Entretoises',
		modType = 41,
		items = {
			label = {},
			price = 2.51
		}
	},
	[18] = {
		mod = 'modArchCover',
		label = 'Pare-boue des ailes',
		modType = 42,
		items = {
			label = {},
			price = 2.19
		}
	},
	[19] = {
		mod = 'modAerials',
		label = 'Antennes',
		modType = 43,
		items = {
			label = {},
			price = 1.12
		}
	},
	[20] = {
		mod = 'modTrimB',
		label = 'Ailes',
		modType = 44,
		items = {
			label = {},
			price = 2.05
		}
	},
	[21] = {
		mod = 'modTank',
		label = 'Bouchon du réservoir',
		modType = 45,
		items = {
			label = {},
			price = 2.19
		}
	},
	[22] = {
		mod = 'modWindows',
		label = 'Fenêtres',
		modType = 46,
		items = {
			label = {},
			price = 2.19
		}
	},
	[23] = {
		mod = 'modLivery',
		label = 'Autocollants',
		modType = 48,
		items = {
			label = {},
			price = 3.3
		}
	},
	[24] = {
		mod = 'modHorns',
		label = 'Klaxon',
		modType = 14,
		items = {
			label = {},
			price = 3.30
		}
	}
}

upgrades = {
	[1]	= {
		mod = 'modArmor',
		label = 'Armure',
		modType = 16,
		items = {
			--[[label = {'Stock', 'Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5', 'Level 6'},--]]
			label = {},
			price = { 0, 20.77, 30.28, 50.00, 999.00, 999.00, 999.00 }
		}
	},
	[2]	= {
		mod = 'modEngine',
		label = 'Moteur',
		modType = 11,
		items = {
			--[[label = {'Stock', 'Level 1', 'Level 2', 'Level 3', 'Level 4'},--]]
			label = {},
			price = { 0, 5.00, 7.00, 10.00, 15.00, 25.00 }
		}
	},
	[3]	= {
		mod = 'modTransmission',
		label = 'Transmission',
		modType = 13,
		items = {
			--[[label = {'Stock', 'Level 1', 'Level 2', 'Level 3', 'Level 4'},--]]
			label = {},
			price = { 0, 5.00, 7.00, 10.00, 12.00, 15.00 }
		}
	},
	[4]	= {
		mod = 'modBrakes',
		label = 'Freins',
		modType = 12,
		items = {
			--[[label = {'Stock', 'Level 1', 'Level 2', 'Level 3', 'Level 4'},--]]
			label = {},
			price = { 0, 4.65, 9.3, 10.6, 13.95, 15.00, 20.00 }
		}
	},
	[5]	= {
		mod = 'modSuspension',
		label = 'Suspension',
		modType = 15,
		items = {
			--[[label = {'Stock', 'Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5'},--]]
			label = {},
			price = { 0, 3.65, 8.3, 11.6, 14.95, 15.00, 19.00 }
		}
	},
	[6]	= {
		mod = 'modTurbo',
		label = 'Turbo',
		modType = 18,
		items = {
			--[[label = {'Stock', 'Level 1'},--]]
			label = {},
			price = { 0, 30.00 }
		}
	}
}

resprayTypes = {
	[1] = {
		label = { "Métallique", "Mat","Utils", "Worn", "Brossé" , "Autres", "Personnaliser" },
		mod = { 'metallic', 'matte', 'util', 'worn', 'brushed', 'others', 'personalize' }
	},
	[2] = {
		label = { "Métallique", "Mat","Utils", "Worn", "Brossé", "Autres", "Personnaliser" },
		mod = { 'metallic', 'matte', 'util', 'worn', 'brushed', 'others', 'personalize' }
	},
	[3] = {
		label = { "Métallique", "Mat","Utils", "Worn", "Brossé", "Autres" },
		mod = { 'metallic', 'matte', 'util', 'worn', 'brushed', 'others' }
	},
	[4] = {
		label = { '[1/7]', '[2/7]', '[3/7]', '[4/7]', '[5/7]', '[6/7]', '[7/7]' },
		tint = { -1, 0, 1, 2, 3, 4, 5 },
		price = 5.58
	},
	[5] = {
		label = { 'Métallique', 'Mat', 'Utils', 'Dépensé', 'Stickers', 'Autres'},
		mod = { 'metallic', 'matte', 'util', 'worn', 'brushed', 'others', 'personalize' }
	}
}


local bodyPartIndex = {
	[1] = { modSpoilers = 1 },
	[2] = { modFrontBumper = 1 },
	[3] = { modRearBumper = 1 },
	[4] = { modSideSkirt = 1 },
	[5] = { modExhaust = 1 },
	[6] = { modGrille = 1 },
	[7] = { modHood = 1 },
	[8] = { modFender = 1 },
	[9] = { modRightFender = 1 },
	[10] = { modRoof = 1 },
	[11] = { modArmor = 1 },
	[12] = { wheels = 1 },
	[13] = { modFrontWheels = 1 },
}

local extrasIndex = {
	[1] = { modPlateHolder = 1 },
	[2] = { modVanityPlate = 1 },
	[3] = { modTrimA = 1 },
	[4] = { modOrnaments = 1 },
	[5] = { modDashboard = 1 },
	[6] = { modDial = 1 },
	[7] = { modDoorSpeaker = 1 },
	[8] = { modSeats = 1 },
	[9] = { modSteeringWheel = 1 },
	[10] = { modShifterLeavers = 1 },
	[11] = { modAPlate = 1 },
	[12] = { modSpeakers = 1 },
	[13] = { modTrunk = 1 },
	[14] = { modHydrolic = 1 },
	[15] = { modEngineBlock = 1 },
	[16] = { modAirFilter = 1 },
	[17] = { modStruts = 1 },
	[18] = { modArchCover = 1 },
	[19] = { modAerials = 1 },
	[20] = { modTrimB = 1 },
	[21] = { modTank = 1 },
	[22] = { modWindows = 1 },
	[23] = { modLivery = 1 },
	[24] = { modHorns = 1 },
}

local windowTintIndex = 1
local colorPartIndex = 1 
local colorTypeIndex = {
	[1] = 1,
	[2] = 1,
	[3] = 1,
	[5] = 1,	
}
local primaryColorIndex = 1
local secondaryColorIndex = 1
local interiorColorIndex = 1
local pearlColorIndex = 1
local primaryCustomColorIndex = { 
	[1] = { label = 'R', index = 0 }, 
	[2] = { label = 'G', index = 0 }, 
	[3] = { label = 'B', index = 0 }
}
local secondaryCustomColorIndex = { 
	[1] = { label = 'R', index = 0 }, 
	[2] = { label = 'G', index = 0 }, 
	[3] = { label = 'B', index = 0 }
}
local interiorCustomColorIndex = { 
	[1] = { label = 'R', index = 0 }, 
	[2] = { label = 'G', index = 0 }, 
	[3] = { label = 'B', index = 0 }
}
local primaryPaintFinishIndex = 1
local secondaryPaintFinishIndex = 1
local interiorPaintFinishIndex = 1
local wheelColorIndex = 1
local tyreSmokeActive = false
local smokeColorIndex = {
	[1] = { label = 'R', index = 0 }, 
	[2] = { label = 'G', index = 0 }, 
	[3] = { label = 'B', index = 0 }
}
local xenonActive = false
local xenonColorIndex = 1

local neonIndex = {
	[1] = { leftNeon = false },
	[2] = { frontNeon = false },
	[3] = { rightNeon = false },
	[4] = { backNeon = false },
	[5] = { r = 0, g = 0, b = 0 },
}
local neonIndex = { 
	[1] = { label = 'R', index = 0 }, 
	[2] = { label = 'G', index = 0 }, 
	[3] = { label = 'B', index = 0 }
}

local neon1 = false
local neon2 = false
local neon3 = false
local neon4 = false

local upgradeIndex = {
	[1] = { modArmor = 1 },
	[2] = { modEngine = 1 },
	[3] = { modTransmission = 1 },
	[4] = { modBrakes = 1 },
	[5] = { modSuspension = 1 },
	[6] = { modTurbo = false },
}

local vehPedIsIn = nil
local vehModsOld = nil
local vehModsNew = nil
local interiorColorOld = nil
local interiorColorNew = nil
local partsCart = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('Sneakyesx:playerLoaded')
AddEventHandler('Sneakyesx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer

	resetMenu() --menu startup

	ESX.TriggerServerCallback('sCustom:getVehiclesPrices', function(vehicles)
		Vehicles = vehicles
	end)
end)

RegisterNetEvent('Sneakyesx:setJob')
AddEventHandler('Sneakyesx:setJob', function(job)
	PlayerData.job = job
	resetMenu() --trigger menu restart on job change

	ESX.TriggerServerCallback('sCustom:getVehiclesPrices', function(vehicles)
		Vehicles = vehicles
	end)
end)

function resetMenu()
	if not mainMenu and PlayerData.job then
		--local resW, resH = GetResolution()
		if PlayerData.job.name == 'harmony' then
			mainMenu = RageUI.CreateMenu("", "Harmony's and Repairs",nil,nil,"root_cause","harmony")
			society = 'society_harmony'
		end

		if not mainMenu then
		else
			mainMenu.EnableMouse = false
			mainMenu.Closed = function()
				totalCartValue = 0
				shopProfitValue = 0
				lsMenuIsShowed = false
				SetVehicleDoorsShut(vehPedIsIn, false)
				SetVehicleDoorsLockedForAllPlayers(vehPedIsIn, false)
				SetVehicleDoorsLockedForPlayer(vehPedIsIn, PlayerPedId(), false)
				FreezeEntityPosition(vehPedIsIn, false)
				ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(PlayerPedId(), false), myCar)
				if not canClose then
				end
			end
		end
	end
end

function CreateLSMenu()
	if not bodyMenu then
		bodyMenu = RageUI.CreateSubMenu(mainMenu)
		bodyMenu.EnableMouse = false
		bodyMenu.Closed = function()
			--print('closed bodyMenu')
		end
	end
	if not extrasMenu then
		extrasMenu = RageUI.CreateSubMenu(mainMenu)
		extrasMenu.EnableMouse = false
		extrasMenu.Closed = function()
			--print('closed extrasMenu')
			SetVehicleDoorsShut(vehPedIsIn, false)
		end
	end
	if not colorMenu then
		colorMenu = RageUI.CreateSubMenu(mainMenu)
		colorMenu.EnableMouse = false
		colorMenu.Closed = function()
			--print('closed colorMenu')
		end
	end
	if not neonMenu then
		neonMenu = RageUI.CreateSubMenu(mainMenu)
		neonMenu.EnableMouse = false
		neonMenu.Closed = function()
			--print('closed neonMenu')
		end
	end
	if not upgradeMenu then
		upgradeMenu = RageUI.CreateSubMenu(mainMenu)
		upgradeMenu.EnableMouse = false
		upgradeMenu.Closed = function()
			--print('closed neonMenu')
		end
	end
	if not cartMenu then
		cartMenu = RageUI.CreateSubMenu(mainMenu)
		cartMenu.EnableMouse = false
		cartMenu.Closed = function()
			--print('closed cartMenu')
		end
	end
end

-- Draw Text 
function DrawTextScreen(Text,Text3,Taille,Text2,Font,Justi,havetext) -- Créer un text 2D a l'écran
    SetTextFont(Font)
    SetTextScale(Taille,Taille)
    SetTextColour(255,255,255,255)
    SetTextJustification(Justi or 1)
    SetTextEntry("STRING")
    if havetext then 
        SetTextWrap(Text,Text+.1)
    end;
    AddTextComponentString(Text2)
    DrawText(Text,Text3)
end


function getCarPrice()
	if vehPedIsIn then
		for i = 1, #Vehicles, 1 do
			if GetEntityModel(vehPedIsIn) == GetHashKey(Vehicles[i].model) then
				vehiclePrice = Vehicles[i].price
				break
			end
		end
	end
end

--REFRESH INDEXES
function RefreshBodyPartIndex()
	for k, v in pairs(vehModsOld) do
		--print("k: " .. k)
		for i = 1, #tempBodyParts, 1 do
			if k == tempBodyParts[i]['mod'] then
				--print("config: " .. tempBodyParts[i]['mod'])
				bodyPartIndex[i][k] = v + (tempBodyParts[i]['mod'] ~= 'wheels' and 2 or 1)
				break
			end
		end
	end
end

function RefreshExtrasIndex()
	for k, v in pairs(vehModsOld) do
		for i = 1, #tempExtras, 1 do
			if k == tempExtras[i]['mod'] then
				extrasIndex[i][k] = v + 2
				break
			end
		end
	end
end

function RefreshPaintIndex()
	windowTintIndex = vehModsOld['windowTint'] + 2
	--colorPartIndex = 1 
	for i = 1, #colorPalette - 2, 1 do
		for k, v in pairs(colorPalette[i]) do
			for x = 1, #v, 1 do
				if vehModsOld['color1'] == v[x] then
					colorTypeIndex[1] = vehModsOld['hasCustomColorPrimary'] == 1 and 7 or i
					primaryPaintFinishIndex = i
					primaryColorIndex = x
				end
				if vehModsOld['color2'] == v[x] then
					colorTypeIndex[2] = vehModsOld['hasCustomColorSecondary'] == 1 and 7 or i
					secondaryPaintFinishIndex = i
					secondaryColorIndex = x
				end
				if vehModsOld['pearlescentColor'] == v[x] then
					colorTypeIndex[3] = i
					pearlColorIndex = x
				end
				if interiorColorOld == v[x] then
					colorTypeIndex[5] = i
					interiorColorIndex = x
				end
				if vehModsOld['wheelColor'] == v[x] then
					wheelColorIndex = x
				end
			end
		end
	end
	if vehModsOld['hasCustomColorPrimary'] == 1 then
		primaryCustomColorIndex[1]['index'] = vehModsOld['customColorPrimary'][1]
		primaryCustomColorIndex[2]['index'] = vehModsOld['customColorPrimary'][2]
		primaryCustomColorIndex[3]['index'] = vehModsOld['customColorPrimary'][3]
	end
	if vehModsOld['hasCustomColorSecondary'] == 1 then
		secondaryCustomColorIndex[1]['index'] = vehModsOld['customColorSecondary'][1]
		secondaryCustomColorIndex[2]['index'] = vehModsOld['customColorSecondary'][2]
		secondaryCustomColorIndex[3]['index'] = vehModsOld['customColorSecondary'][3]
	end
	if vehModsOld['hasCustomColorInterior'] == 1 then
		interiorCustomColorIndex[1]['index'] = vehModsOld['customColorInterior'][1]
		interiorCustomColorIndex[2]['index'] = vehModsOld['customColorInterior'][2]
		interiorCustomColorIndex[3]['index'] = vehModsOld['customColorInterior'][3]
	end
	tyreSmokeActive = vehModsOld['modSmokeEnabled'] and true or false
	if tyreSmokeActive then
		smokeColorIndex[1]['index'] = vehModsOld['tyreSmokeColor'][1]
		smokeColorIndex[2]['index'] = vehModsOld['tyreSmokeColor'][2]
		smokeColorIndex[3]['index'] = vehModsOld['tyreSmokeColor'][3]
	end
	xenonActive = vehModsOld['modXenon'] and true or false
	--[[ if xenonActive then
		xenonColorIndex = vehModsOld['xenonColor'] + 2
	end ]]
end

function RefreshNeonIndex()
	neon1 = vehModsOld['neonEnabled'][1] and true or false
	neon2 = vehModsOld['neonEnabled'][2] and true or false
	neon3 = vehModsOld['neonEnabled'][3] and true or false
	neon4 = vehModsOld['neonEnabled'][4] and true or false
	neonIndex[1]['index'] = vehModsOld['neonColor'][1]
	neonIndex[2]['index'] = vehModsOld['neonColor'][2]
	neonIndex[3]['index'] = vehModsOld['neonColor'][3]
end

function RefreshUpgradeIndex()
	for k, v in pairs(vehModsOld) do 
		for i = 1, #tempUpgrades, 1 do
			if k == tempUpgrades[i]['mod'] and tempUpgrades[i]['modType'] ~= 18 then
				upgradeIndex[i][k] = v + 2
				break
			elseif k == tempUpgrades[i]['mod'] and tempUpgrades[i]['modType'] == 18 then
				upgradeIndex[i][k] = v and true or false
				break
			end
		end
	end
end

--RESET ITEM LISTS
function ResetBodyPartItems()
	if tempBodyParts then
		for i = 1, #tempBodyParts, 1 do
			if i ~= 12 then
				for x = 1, #tempBodyParts[i]['items']['label'] do
				    tempBodyParts[i]['items']['label'][x] = nil
				end
			end
		end
	end
end

function ResetWheelItems()
	if tempBodyParts then
		for x = 1, #tempBodyParts[13]['items']['label'] do
		    tempBodyParts[13]['items']['label'][x] = nil
		end
	end
end

function ResetExtraItems()
	if tempExtras then
		for i = 1, #tempExtras, 1 do
			for x = 1, #tempExtras[i]['items']['label'] do
			    tempExtras[i]['items']['label'][x] = nil
			end
		end
	end
end

function ResetPaintItems()
	windowTintIndex = 1
	colorPartIndex = 1 
	colorTypeIndex[1] = 1
	colorTypeIndex[2] = 1
	colorTypeIndex[3] = 1
	primaryColorIndex = 1
	secondaryColorIndex = 1
	interiorColorIndex = 1
	primaryCustomColorIndex[1]['index'] = 0
	primaryCustomColorIndex[2]['index'] = 0
	primaryCustomColorIndex[3]['index'] = 0
	secondaryCustomColorIndex[1]['index'] = 0
	secondaryCustomColorIndex[2]['index'] = 0
	secondaryCustomColorIndex[3]['index'] = 0
	interiorCustomColorIndex[1]['index'] = 0
	interiorCustomColorIndex[2]['index'] = 0
	interiorCustomColorIndex[3]['index'] = 0
	primaryPaintFinishIndex = 1
	secondaryPaintFinishIndex = 1
	interiorPaintFinishIndex = 1
	pearlColorIndex = 1
	wheelColorIndex = 1
	tyreSmokeActive = false
	smokeColorIndex[1]['index'] = 0
	smokeColorIndex[2]['index'] = 0
	smokeColorIndex[3]['index'] = 0
	xenonActive = false
	xenonColorIndex = 1
end

function ResetNeonItems()
	neon1 = false
	neon2 = false
	neon3 = false
	neon4 = false
	neonIndex[1]['index'] = 0
	neonIndex[2]['index'] = 0
	neonIndex[3]['index'] = 0
end

function ResetUpgradeItems()
	if tempUpgrades then
		for i = 1, #tempUpgrades, 1 do
			for x = 1, #tempUpgrades[i]['items']['label'] do
			    tempUpgrades[i]['items']['label'][x] = nil
			end
		end
	end
end

--BUILD ITEM LISTS
function BuildBodyPartsLabel()
	local modCount = 0
	local modName = ""
	local label = ""
	for i = 1, #tempBodyParts, 1 do
		modCount = GetNumVehicleMods(vehPedIsIn, tempBodyParts[i]['modType'])
		if modCount > 0 and i < 12 then
			for x = 1, modCount, 1 do
				--[[modName = GetModTextLabel(vehPedIsIn, tempBodyParts[i]['modType'], x)
				label = GetLabelText(modName)
				if label == "NULL" then
					label = "Custom " .. tempBodyParts[i]['label']
				end
				if #label > 10 then
					label = label:sub(1, 10)
					print("label cut: " .. label)
				end--]]
				if x == 1 then
					--table.insert(tempBodyParts[i]['items']['label'], "Stock " .. label .. " [" .. x .. "/" .. modCount + 1 .. "]")
					table.insert(tempBodyParts[i]['items']['label'], "[" .. x .. "/" .. modCount + 1 .. "]")
				end
				--label = label .. " [" .. x + 1 .. "/" .. modCount + 1 .. "]"
				label = "[" .. x + 1 .. "/" .. modCount + 1 .. "]"
				table.insert(tempBodyParts[i]['items']['label'], label)
			end
		end
	end
end

function BuildWheelsLabel()
	local modCount = GetNumVehicleMods(vehPedIsIn, tempBodyParts[13]['modType'])
	if modCount > 0 then
		for x = 1, modCount, 1 do
			if x == 1 then
				table.insert(tempBodyParts[13]['items']['label'], "[" .. x .. "/" .. modCount + 1 .. "]")
			end
			label = "[" .. x + 1 .. "/" .. modCount + 1 .. "]"
			table.insert(tempBodyParts[13]['items']['label'], label)
		end
	end
end

function BuildExtrasLabel()
	local modCount = 0
	local modName = ""
	local label = ""
	for i = 1, #tempExtras, 1 do
		modCount = GetNumVehicleMods(vehPedIsIn, tempExtras[i]['modType'])
		if modCount > 0 then
			for x = 1, modCount, 1 do
				--[[modName = GetModTextLabel(vehPedIsIn, tempExtras[i]['modType'], x)
				label = GetLabelText(modName)
				if label == "NULL" then
					label = "Custom " .. tempExtras[i]['label']
				end--]]
				if x == 1 then
					--table.insert(tempExtras[i]['items']['label'], "Stock " .. label .. " [" .. x .. "/" .. modCount + 1 .. "]")
					table.insert(tempExtras[i]['items']['label'], "[" .. x .. "/" .. modCount + 1 .. "]")
				end
				--label = label .. " [" .. x + 1 .. "/" .. modCount + 1 .. "]"
				label = "[" .. x + 1 .. "/" .. modCount + 1 .. "]"
				table.insert(tempExtras[i]['items']['label'], label)
			end
		end
	end
end

function BuildUpgradesLabel()
	local modCount = 0
	local modName = ""
	local label = ""
	for i = 1, #tempUpgrades, 1 do
		modCount = GetNumVehicleMods(vehPedIsIn, tempUpgrades[i]['modType'])
		if modCount > 0 then
			for x = 1, modCount, 1 do
				--[[modName = GetModTextLabel(vehPedIsIn, tempUpgrades[i]['modType'], x)
				label = GetLabelText(modName)--]]
				--[[if label == "NULL" then
					label = "Custom " .. tempUpgrades[i]['label']
				end--]]
				if x == 1 then
					--local label1 = tempUpgrades[i]['label']
					--table.insert(tempUpgrades[i]['items']['label'], "Stock " .. label1 .. " [" .. x .. "/" .. modCount + 1 .. "]")
					table.insert(tempUpgrades[i]['items']['label'], "[" .. x .. "/" .. modCount + 1 .. "]")
				end
				--label = label .. " [" .. x + 1 .. "/" .. modCount + 1 .. "]"
				label = "[" .. x + 1 .. "/" .. modCount + 1 .. "]"
				table.insert(tempUpgrades[i]['items']['label'], label)
			end
		end
	end
end

function addToCart(label, mod, modType, index, price)
	local item = findKey(shopCart, mod)
	if item then
		shopCart[mod]['label'] = label
		shopCart[mod]['modType'] = modType
		shopCart[mod]['index'] = index
		shopCart[mod]['price'] = price
	else
		item = { label = label, modType = modType, index = index, price = price }
		shopCart[mod] = item
	end
	calcCartValue()
end

function removeFromCart(mod)
	local item = findKey(shopCart, mod)
	if item then
		shopCart[mod] = nil
		calcCartValue()
	end
end

function calcCartValue()
	shopProfitValue = 0
	totalCartValue = 0
	for k, v in pairs(shopCart) do
		--print("k: " .. k)
		--print("v['price']: " .. v['price'])
		local c = v['price'] * (shopProfit / 100)
		shopProfitValue = math.round(shopProfitValue + c)
		totalCartValue = math.round(totalCartValue + v['price'] + c)

	end
	totalCartValue = totalCartValue - shopProfitValue
end

local dev = false
function finishPurchase()
	local vehModsNew = ESX.Game.GetVehicleProperties(vehPedIsIn)
	terminatePurchase()
end

function terminatePurchase()
	for k, v in pairs(shopCart) do
		shopCart[k] = nil
	end
	if lsMenuIsShowed then
		SetVehicleDoorsShut(vehPedIsIn, false)
		SetVehicleDoorsLockedForAllPlayers(vehPedIsIn, false)
		SetVehicleDoorsLockedForPlayer(vehPedIsIn, PlayerPedId(), false)
		FreezeEntityPosition(vehPedIsIn, false)
		RageUI.CloseAll()
	end
	lsMenuIsShowed = false
	stop = false
	vehModsOld = nil
end

function compareMods(label, mod, modType, index, price)
	local vehModsNew = ESX.Game.GetVehicleProperties(vehPedIsIn)
	local interiorColorNew = GetVehicleInteriorColour(vehPedIsIn)
	if (mod ~= 'neonColor' and mod ~= 'tyreSmokeColor' and mod ~= 'customColorPrimary' and mod ~= 'customColorSecondary' and vehModsOld[mod] ~= vehModsNew[mod]) or 
		--apenas ligar neons
		(mod == 'leftNeon' and not vehModsOld['neonEnabled'][1] and vehModsNew['neonEnabled'][1]) or 
		(mod == 'rightNeon' and not vehModsOld['neonEnabled'][2] and vehModsNew['neonEnabled'][2]) or 
		(mod == 'frontNeon' and not vehModsOld['neonEnabled'][3] and vehModsNew['neonEnabled'][3]) or 
		(mod == 'backNeon' and not vehModsOld['neonEnabled'][4] and vehModsNew['neonEnabled'][4]) or
		--mudar cor da neon
		(mod == 'neonColor' and (vehModsOld['neonColor'][1] ~= vehModsNew['neonColor'][1] or vehModsOld['neonColor'][2] ~= vehModsNew['neonColor'][2] or vehModsOld['neonColor'][3] ~= vehModsNew['neonColor'][3])) or
		(mod == 'tyreSmokeColor' and (vehModsOld['tyreSmokeColor'][1] ~= vehModsNew['tyreSmokeColor'][1] or vehModsOld['tyreSmokeColor'][2] ~= vehModsNew['tyreSmokeColor'][2] or vehModsOld['tyreSmokeColor'][3] ~= vehModsNew['tyreSmokeColor'][3])) or
		(mod == 'xenonColor' and vehModsOld['xenonColor'] ~= vehModsNew['xenonColor']) or
		(mod == 'interior' and interiorColorOld ~= interiorColorNew)
		-- (mod == 'customColorPrimary' and (vehModsOld['customColorPrimary'][1] ~= vehModsNew['customColorPrimary'][1] or 
		-- vehModsOld['customColorPrimary'][2] ~= vehModsNew['customColorPrimary'][2] or 
		-- vehModsOld['customColorPrimary'][3] ~= vehModsNew['customColorPrimary'][3])) 
		-- or 
		-- (mod == 'customColorSecondary' and (vehModsOld['customColorSecondary'][1] ~= vehModsNew['customColorSecondary'][1] or vehModsOld['customColorSecondary'][2] ~= vehModsNew['customColorSecondary'][2] or vehModsOld['customColorSecondary'][3] ~= vehModsNew['customColorSecondary'][3]))
		 then

		addToCart(label, mod, modType, index, price)
		if mod == 'customColorPrimary' then
			removeFromCart('color1')
		elseif mod == 'customColorSecondary' then
			removeFromCart('color2')
		elseif mod == 'color1' then
			removeFromCart('customColorPrimary')
		elseif mod == 'interior' then
			removeFromCart('interior')
		elseif mod == 'color2' then
			removeFromCart('customColorSecondary')
		end
	else
		--print('removed: ' .. mod)
		if (mod == 'leftNeon' and not vehModsNew['neonEnabled'][1]) and 
			(mod == 'rightNeon' and not vehModsNew['neonEnabled'][2]) and 
			(mod == 'frontNeon' and not vehModsNew['neonEnabled'][3]) and 
			(mod == 'backNeon' and not vehModsNew['neonEnabled'][4]) then

			removeFromCart('neonColor')
		elseif mod == 'modSmokeEnabled' then
			removeFromCart('tyreSmokeColor')
		elseif mod == 'modXenon' then
			removeFromCart('xenonColor')
		end
		removeFromCart(mod)
	end
end

function calcModPrice(parcel)
	local val = 0
	local basePrice = 10000
	if 50000 < vehiclePrice and vehiclePrice <= 100000 then
		basePrice = 20000
	elseif 100000 < vehiclePrice then
		basePrice = 30000
	end
	
	val = math.round((basePrice * (parcel / 100)) * 2)
	return val
end

function DeleteFromCart(k, modType)
	--print('aCustom ==> Delete')
	local vehModsNew = ESX.Game.GetVehicleProperties(vehPedIsIn)
	local interiorColorNew = GetVehicleInteriorColour(vehPedIsIn)
	if modType == -1 then
		if k == 'customColorPrimary' then
			if vehModsOld['hasCustomColorPrimary'] == 1 then
				SetVehicleCustomPrimaryColour(vehicle, vehModsOld['customColorPrimary'][1], vehModsOld['customColorPrimary'][2], vehModsOld['customColorPrimary'][3])
			else
				ClearVehicleCustomPrimaryColour(vehPedIsIn)
			end
		elseif k == 'customColorSecondary' then
			if vehModsOld['hasCustomColorSecondary'] == 1 then
				SetVehicleCustomSecondaryColour(vehicle, vehModsOld['customColorSecondary'][1], vehModsOld['customColorSecondary'][2], vehModsOld['customColorSecondary'][3])
			else
				ClearVehicleCustomSecondaryColour(vehPedIsIn)
			end
		elseif k == 'primaryPaintFinish' then
			SetVehicleColours(vehPedIsIn, vehModsOld['color1'], vehModsNew['color2'])
		elseif k == 'secondaryPaintFinish' then 
			SetVehicleColours(vehPedIsIn, vehModsNew['color1'], vehModsOld['color2'])
		elseif k == 'interiorPaintFinish' then 
			SetVehicleInteriorColour(vehPedIsIn, interiorColorNew);
		elseif k == 'color1' then
			SetVehicleColours(vehPedIsIn, vehModsOld['color1'], vehModsNew['color2'])
		elseif k == 'color2' then 
			SetVehicleColours(vehPedIsIn, vehModsNew['color1'], vehModsOld['color2'])
		elseif k == 'interior' then 
			SetVehicleInteriorColour(vehPedIsIn, interiorColorNew);
		elseif k == 'pearlescentColor' then
			SetVehicleExtraColours(vehPedIsIn, vehModsOld['pearlescentColor'], vehModsNew['wheelColor'])
		elseif k == 'wheelColor' then
			SetVehicleExtraColours(vehPedIsIn, vehModsNew['pearlescentColor'], vehModsOld['wheelColor'])
		elseif k == 'windowTint' then
			SetVehicleWindowTint(vehPedIsIn, vehModsOld['windowTint'])
		elseif k == 'tyreSmokeColor' then
			SetVehicleTyreSmokeColor(vehPedIsIn, vehModsOld['tyreSmokeColor'][1], vehModsOld['tyreSmokeColor'][2], vehModsOld['tyreSmokeColor'][3])
		elseif k == 'xenonColor' then
			SetVehicleXenonLightsColour(vehPedIsIn, vehModsOld['xenonColor'])
		elseif k == 'neonColor' then
			SetVehicleNeonLightsColour(vehPedIsIn, vehModsOld['neonColor'][1], vehModsOld['neonColor'][2], vehModsOld['neonColor'][3])
		elseif k == 'leftNeon' then
			SetVehicleNeonLightEnabled(vehPedIsIn, 0, vehModsOld['neonEnabled'][1])
		elseif k == 'rightNeon' then
			SetVehicleNeonLightEnabled(vehPedIsIn, 1, vehModsOld['neonEnabled'][2])
		elseif k == 'frontNeon' then
			SetVehicleNeonLightEnabled(vehPedIsIn, 2, vehModsOld['neonEnabled'][3])
		elseif k == 'backNeon' then
			SetVehicleNeonLightEnabled(vehPedIsIn, 3, vehModsOld['neonEnabled'][4])
		end
	else
		--[[if k == 'modTurbo' or k == 'modSmokeEnabled' or k == 'modXenon' then
			print("vehModsOld[k]: " .. tostring(vehModsOld[k]))
			print("modType: " .. modType)
			if vehModsOld[k] or vehModsOld[k] == 1 then
				ToggleVehicleMod(vehPedIsIn, modType, true)
			elseif not vehModsOld[k] or vehModsOld[k] == 0 then
				ToggleVehicleMod(vehPedIsIn, modType, false)
			end--]]
		if k == 'modTurbo' or k == 'modSmokeEnabled' or k == 'modXenon' then
			if vehModsOld[k] or vehModsOld[k] == 1 then
				ToggleVehicleMod(vehPedIsIn, modType, true)
			elseif not vehModsOld[k] or vehModsOld[k] == 0 then
				ToggleVehicleMod(vehPedIsIn, modType, false)
			end
			removeFromCart('modTurbo')
			removeFromCart('modSmokeEnabled')
			removeFromCart('modXenon')
		elseif k == 'modLivery' then
			SetVehicleMod(vehPedIsIn, modType, vehModsOld['modLivery'], false)
			SetVehicleLivery(vehPedIsIn, vehModsOld['modLivery'])
		elseif k == 'wheels' or k == 'modFrontWheels' then
			SetVehicleWheelType(vehPedIsIn, vehModsOld['wheels'])
            SetVehicleMod(vehPedIsIn, 23, vehModsOld['modFrontWheels'], false)
		else
			SetVehicleMod(vehPedIsIn, modType, vehModsOld[k], false)
		end
	end
	removeFromCart(k)
	--refresh indexes
	RefreshBodyPartIndex()
	RefreshExtrasIndex()
	RefreshPaintIndex()
	RefreshNeonIndex()
	RefreshUpgradeIndex()
	deleting = false
end

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do
		if (PlayerData.job and PlayerData.job.name == 'harmony') or not IsHarmonyJobOnly and not lsMenuIsShowed then
			Wait(1)
			local playerPed = PlayerPedId()

			if IsPedInAnyVehicle(playerPed, false) then
				if not vehPedIsIn and isInLSMarker then
					vehPedIsIn = GetVehiclePedIsIn(playerPed, false)
					vehModsOld = ESX.Game.GetVehicleProperties(vehPedIsIn)
					SneakyEvent('sCustom:checkVehicle', vehModsOld['plate'])
				end
				local currentZone, zone, lastZone
				local coords = GetEntityCoords(PlayerPedId())
				local playerPedId = PlayerPedId()

				if (PlayerData.job and PlayerData.job.name == 'harmony') or not IsHarmonyJobOnly and not lsMenuIsShowed then
					if GetDistanceBetweenCoords(coords, Zones['ls1']['Pos']['x'], Zones['ls1']['Pos']['y'], Zones['ls1']['Pos']['z'], true) < Zones['ls1']['Size']['x'] or
						GetDistanceBetweenCoords(coords, Zones['ls2']['Pos']['x'], Zones['ls2']['Pos']['y'], Zones['ls2']['Pos']['z'], true) < Zones['ls2']['Size']['x']
					then
						isInLSMarker  = true
						ESX.ShowHelpNotification(Zones['ls1']['Hint'])
					else
						isInLSMarker  = false
					end
				end

				if lsMenuIsShowed and not isInLSMarker then
					SetVehicleDoorsShut(vehPedIsIn, false)
					SetVehicleDoorsLockedForAllPlayers(vehPedIsIn, false)
					SetVehicleDoorsLockedForPlayer(vehPedIsIn, PlayerPedId(), false)
					FreezeEntityPosition(vehPedIsIn, false)
					RageUI.CloseAll()
					lsMenuIsShowed = false
					SetVehicleDoorsShut(vehPedIsIn, false)
					if not canClose then
					end
				end

				if IsControlJustReleased(0, 38) and not lsMenuIsShowed and isInLSMarker then
					if exports.sCore:CheckServiceHarmony() then
						if (PlayerData.job and (PlayerData.job.name == 'harmony')) or not IsHarmonyJobOnly then
							vehPedIsIn = GetVehiclePedIsIn(playerPed, false)
							terminatePurchase()
							getCarPrice()
							vehicleClass = GetVehicleClass(vehPedIsIn)
							--print("vehicleClass: " .. vehicleClass)
							if ((vehicleClass ~= 8 or not IsMotorCycleBikerOnly) and PlayerData.job.name == 'harmony') or
								(vehicleClass == 8 and PlayerData.job.name == 'soa') then

								--RageUI.CloseAll()
								vehModsOld = ESX.Game.GetVehicleProperties(vehPedIsIn)
								interiorColorOld = GetVehicleInteriorColour(vehPedIsIn)
								SetVehicleModKit(vehPedIsIn, 0)
								SneakyEvent('sCustom:saveVehicle', vehModsOld)

								--resetItems
								ResetBodyPartItems()
								ResetWheelItems()
								ResetExtraItems()
								ResetPaintItems()
								ResetNeonItems()
								ResetUpgradeItems()
								
								if not tempBodyParts then tempBodyParts = bodyParts end
								if not tempExtras then tempExtras = extras end
								if not tempColorParts then tempColorParts = colorParts end
								if not tempNeons then tempNeons = neons end
								if not tempUpgrades then tempUpgrades = upgrades end
								
								if vehicleClass == 8 and #tempBodyParts[12]['wheelType'] < 8 then
									table.insert(tempBodyParts[12]['items'], 'Jantes Moto')
									table.insert(tempBodyParts[12]['wheelType'], 6)
								elseif vehicleClass ~= 8 and #tempBodyParts[12]['wheelType'] == 8 then
									table.remove(tempBodyParts[12]['items'])
									table.remove(tempBodyParts[12]['wheelType'])
								end

								--refresh indexes
								RefreshBodyPartIndex()
								RefreshExtrasIndex()
								RefreshPaintIndex()
								RefreshNeonIndex()
								RefreshUpgradeIndex()
								--refresh item names
								BuildBodyPartsLabel()
								BuildWheelsLabel()
								BuildExtrasLabel()
								BuildUpgradesLabel()

								lsMenuIsShowed = true
								--SetVehicleDoorsLocked(vehPedIsIn, 4)
								--FreezeEntityPosition(vehPedIsIn, true)
								FreezeEntityPosition(vehPedIsIn, true)
								SetVehicleDoorsShut(vehPedIsIn, true)
								SetVehicleDoorsLockedForPlayer(vehPedIsIn, PlayerPedId(), true)
								SetVehicleDoorsLockedForAllPlayers(vehPedIsIn, true)
								CreateLSMenu()
								myCar = vehModsOld

								shopProfit = 50

								RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))
							end
						end
					else
						ESX.ShowNotification("Vous n'êtes pas en ~r~service~s~.")
					end
				end

				RageUI.IsVisible(mainMenu, true, false, true, function()
					RageUI.Separator('↓ ~b~ Customisations ~s~↓')

					RageUI.Button('Carosseries' , nil, {
							LeftBadge = nil,
							RightBadge = nil,
							RightLabel = "→→→"
						}, true, function(Hovered, Active, Selected)
							if Selected then
								--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
							end
							if Hovered then
							-- My action the Button is hovered by the mouse
							end
							if Active then
							-- My action the Button is hightlighted
							end
						end, bodyMenu)  
					RageUI.Button("Esthétiques" , nil, {
							LeftBadge = nil,
							RightBadge = nil,
							RightLabel = "→→"
						}, true, function(Hovered, Active, Selected)
							if Selected then
								--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
								SetVehicleDoorOpen(vehPedIsIn, 0, false)
								SetVehicleDoorOpen(vehPedIsIn, 1, false)
								SetVehicleDoorOpen(vehPedIsIn, 2, false)
								SetVehicleDoorOpen(vehPedIsIn, 3, false)
								SetVehicleDoorOpen(vehPedIsIn, 4, false)
								SetVehicleDoorOpen(vehPedIsIn, 5, false)
							end
							if Hovered then
							-- My action the Button is hovered by the mouse
							end
							if Active then
							-- My action the Button is hightlighted
							end
						end, extrasMenu)
					RageUI.Button('Peintures' , nil, {
							LeftBadge = nil,
							RightBadge = nil,
							RightLabel = "→→"
						}, true, function(Hovered, Active, Selected)
							if Selected then
								--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
							end
							if Hovered then
							-- My action the Button is hovered by the mouse
							end
							if Active then
							-- My action the Button is hightlighted
							end
						end, colorMenu)
					RageUI.Button('Néons' , nil, {
							LeftBadge = nil,
							RightBadge = nil,
							RightLabel = "→→"
						}, true, function(Hovered, Active, Selected)
							if Selected then
								--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
							end
							if Hovered then
							-- My action the Button is hovered by the mouse
							end
							if Active then
							-- My action the Button is hightlighted
							end
						end, neonMenu)  
					RageUI.Button('Performances' , nil, {
							LeftBadge = nil,
							RightBadge = nil,
							RightLabel = "→→"
						}, true, function(Hovered, Active, Selected)
							if Selected then
								--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
							end
							if Hovered then
							-- My action the Button is hovered by the mouse
							end
							if Active then
							-- My action the Button is hightlighted
							end
						end, upgradeMenu) 

					--[[	RageUI.CenterButton("Valider et appliquer les modifications", nil, {RightBadge = RageUI.BadgeStyle.Tick, Color = { BackgroundColor = { 0, 120, 0, 25 } }}, not stop, function(Hovered, Active, Selected)
							if Selected then
								if stop then
									return
								end
								stop = true
								finishPurchase()
							end
							if Hovered then
							-- My action the Button is hovered by the mouse
							end
							if Active then
							-- My action the Button is hightlighted
							end
						end)
				end, function()
					---Panels
				end
			)]]
			RageUI.Separator('↓ ~b~Facturation ~s~↓')
			RageUI.Button('Liste des achats' , nil, {
							LeftBadge = nil,
							RightBadge = nil,
							RightLabel = "→→"
						}, true, function(Hovered, Active, Selected)
							if Selected then
								--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
							end
							if Hovered then
							-- My action the Button is hovered by the mouse
							end
							if Active then
							-- My action the Button is hightlighted
							end
						end, cartMenu) 
						DrawTextScreen(0.5, 0.90, 1.1, "Total facture: ~b~"..totalCartValue.."$~s~. Total entreprise: ~g~"..math.round(totalCartValue - shopProfitValue).."$~s~.", 4, 0)
					end, function()
						---Panels
						end
					)
			
			RageUI.IsVisible(bodyMenu, true, false, true, function()
				local menuItemCount = 0
					for i = 1, #tempBodyParts, 1 do
						local modCount = GetNumVehicleMods(vehPedIsIn, tempBodyParts[i]['modType'])
							--print(tempBodyParts[i]['mod'] .. ' modCount: ' .. modCount)
							local bodyIndex = 1
							bodyIndex = bodyPartIndex[i][tempBodyParts[i]['mod']]
							if modCount > 0 then
								if vehicleClass ~= 8 or (tempBodyParts[i]['mod'] ~= 'wheels' and vehicleClass == 8) then
									local itemLabel = tempBodyParts[i]['label']
									if tempBodyParts[i]['mod'] ~= 'wheels' then
										itemLabel = itemLabel .. " (" .. (calcModPrice(tempBodyParts[i]['items']['price']) .. "$" or "---") .. ")" 
									end
									RageUI.List(itemLabel,
										(tempBodyParts[i]['mod'] ~= 'wheels') and tempBodyParts[i]['items']['label'] or tempBodyParts[i]['items'], 
										bodyIndex,
										nil, 
										{}, 
										true, 
										function(Hovered, Active, Selected, Index)
											if bodyPartIndex[i][tempBodyParts[i]['mod']] ~= Index and Index <= modCount + 1 then -- +1 para contar com o index da peça STOCK
												bodyPartIndex[i][tempBodyParts[i]['mod']] = Index
												if Selected then
													
												end
											end
										end,
										function(Index, CurrentItems)
										print(Index, CurrentItems)
										local itemIndex = Index - (tempBodyParts[i]['mod'] ~= 'wheels' and 2 or 1)
										if tempBodyParts[i]['mod'] ~= 'wheels' then
											SetVehicleMod(vehPedIsIn, tempBodyParts[i]['modType'], itemIndex, false)
											compareMods(tempBodyParts[i]['label'], tempBodyParts[i]['mod'], tempBodyParts[i]['modType'], itemIndex, calcModPrice(tempBodyParts[i]['items']['price']))
										elseif tempBodyParts[i]['mod'] == 'wheels' then
											bodyPartIndex[13][tempBodyParts[13]['mod']] = 1
											SetVehicleWheelType(vehPedIsIn, tempBodyParts[i]['wheelType'][Index])
											SetVehicleMod(vehPedIsIn, 23, -1, false)
											compareMods(tempBodyParts[13]['label'], tempBodyParts[13]['mod'], tempBodyParts[13]['modType'], 1, 0)
											ResetWheelItems()
											BuildWheelsLabel()
										elseif tempBodyParts[i]['mod'] == 'modFrontWheels' then
											SetVehicleMod(vehPedIsIn, 23, Index - 2, false)
											if vehicleClass == 8 then
												SetVehicleMod(vehPedIsIn, 24, Index - 2, false)
											end
											compareMods(tempBodyParts[i]['label'], tempBodyParts[i]['mod'], tempBodyParts[i]['modType'], itemIndex, calcModPrice(tempBodyParts[i]['items']['price']))
										end
									end
									)
									menuItemCount = menuItemCount + 1
								end
							end
					end
					if menuItemCount == 0 then
						RageUI.Button("Aucun article dans le panier" , nil, {
								LeftBadge = nil,
								RightBadge = nil,
								RightLabel = "Voltar atrás"
							}, true, function(Hovered, Active, Selected)
								if Selected then
									--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
								end
								if Hovered then
								-- My action the Button is hovered by the mouse
								end
								if Active then
								-- My action the Button is hightlighted
								end
							end, mainMenu)
					end
					DrawTextScreen(0.5, 0.90, 1.1, "Total facture: ~b~"..totalCartValue.."$~s~. Total entreprise: ~g~"..math.round(totalCartValue - shopProfitValue).."$~s~.", 4, 0)
					end, function()
					---Panels
					end
				)
				RageUI.IsVisible(extrasMenu, true, false, true, function()
						local menuItemCount = 0
					for i = 1, #tempExtras, 1 do
						local modCount = GetNumVehicleMods(vehPedIsIn, tempExtras[i]['modType'])
							--print(tempExtras[i]['mod'] .. ' modCount: ' .. modCount)
							local extraIndex = 1
							extraIndex = extrasIndex[i][tempExtras[i]['mod']]
							if modCount > 0 then
								local itemLabel = tempExtras[i]['label'] .. " (" .. (calcModPrice(tempExtras[i]['items']['price']) .. "$" or "---") .. ")"
								RageUI.List(itemLabel,
									tempExtras[i]['items']['label'], 
									extraIndex,
									nil, 
									{}, 
									true, 
									function(Hovered, Active, Selected, Index)
										if extrasIndex[i][tempExtras[i]['mod']] ~= Index and Index <= modCount + 1 then -- +1 para contar com o index da peça STOCK
											extrasIndex[i][tempExtras[i]['mod']] = Index
											if Selected then
										
											end
										end
									end,
									function(Index, CurrentItems)
									print(Index, CurrentItems)
									local itemIndex = Index - 2
									SetVehicleMod(vehPedIsIn, tempExtras[i]['modType'], itemIndex, false)
									if tempExtras[i]['mod'] == 'modLivery' then
										SetVehicleLivery(vehPedIsIn, itemIndex)
									end
									compareMods(tempExtras[i]['label'], tempExtras[i]['mod'], tempExtras[i]['modType'], itemIndex, calcModPrice(tempExtras[i]['items']['price']))
								end
								)
								menuItemCount = menuItemCount + 1
							end
					end
					if menuItemCount == 0 then
						RageUI.Button("Aucun article dans le panier" , nil, {
								LeftBadge = nil,
								RightBadge = nil,
								RightLabel = "test nehco"
							}, true, function(Hovered, Active, Selected)
								if Selected then
									--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
								end
								if Hovered then
								-- My action the Button is hovered by the mouse
								end
								if Active then
								-- My action the Button is hightlighted
								end
							end, mainMenu)
					end
					DrawTextScreen(0.5, 0.90, 1.1, "Total facture: ~b~"..totalCartValue.."$~s~. Total entreprise: ~g~"..math.round(totalCartValue - shopProfitValue).."$~s~.", 4, 0)
					end, function()
					---Panels
					end
				)
				RageUI.IsVisible(colorMenu, true, false, true, function()
						if bodyPartIndex[13]['modFrontWheels'] ~= 1 then
							local item = findItem(tempColorParts['label'], 'roues')
							local itemPos = item and item or 0
							if itemPos == 0 then
								table.insert(tempColorParts['label'], 'roues')
								table.insert(tempColorParts['mod'], 'wheels')
							end
						else
							local item = findItem(tempColorParts['label'], 'roues')
							local itemPos = item and item or 0
							if itemPos > 1 then
								tempColorParts['label'][itemPos] = nil
								tempColorParts['mod'][itemPos] = nil
								colorPartIndex = 1
							end
						end
						RageUI.Checkbox(xenon['label'] .. " (" .. (calcModPrice(xenon['price']) .. "$" or "---") .. ")", 
							nil, 
							xenonActive, 
							{ }, 
							function(Hovered, Selected, Active, Checked)
								if Active then
									xenonActive = Checked and true or false
									if xenonActive then
										local item = findItem(tempColorParts['label'], 'phares')
										local itemPos = item and item or 0
										if itemPos == 0 then
											table.insert(tempColorParts['label'], 'phares')
											table.insert(tempColorParts['mod'], 'headlights')
										end
									else
										local item = findItem(tempColorParts['label'], 'phares')
										local itemPos = item and item or 0
										if itemPos > 1 then
											tempColorParts['label'][itemPos] = nil
											tempColorParts['mod'][itemPos] = nil
											colorPartIndex = 1
										end
									end
									ToggleVehicleMod(vehPedIsIn, 22, xenonActive)
									compareMods(xenon['label'], xenon['mod'], 22, xenonActive, ((xenonActive and vehModsOld['modXenon']) or (not xenonActive and vehModsOld['modXenon'])) and 0 or calcModPrice(xenon['price']))
								end
							end
						)
						RageUI.List('Partie à peindre',
							tempColorParts['label'], 
							colorPartIndex,
							nil, 
							{}, 
							true, 
							function(Hovered, Active, Selected, Index)
							end,
							function(Index, CurrentItems)
							print(Index, CurrentItems)
								colorPartIndex = Index
						end
						)
						if colorPartIndex <= 3 or colorPartIndex == 5 then
							RageUI.List('Type de peinture',
								resprayTypes[colorPartIndex]['label'], 
								colorTypeIndex[colorPartIndex],
								nil, 
								{}, 
								true, 
								function(Hovered, Active, Selected, Index)
								end,
								function(Index, CurrentItems)
								print(Index, CurrentItems)
									colorTypeIndex[colorPartIndex] = Index
									if tempColorParts['mod'][colorPartIndex] == 'primary' then
										primaryColorIndex = 1
										ClearVehicleCustomPrimaryColour(vehPedIsIn)
									elseif tempColorParts['mod'][colorPartIndex] == 'secondary' then
										secondaryColorIndex = 1
										ClearVehicleCustomSecondaryColour(vehPedIsIn)
									elseif tempColorParts['mod'][colorPartIndex] == 'interior' then
										interiorColorIndex = 1
									elseif tempColorParts['mod'][colorPartIndex] == 'pearlescent' then
										pearlColorIndex = 1
									end
							end
							)
							if tempColorParts['mod'][colorPartIndex] == 'primary' then
								if resprayTypes[1]['mod'][colorTypeIndex[1]] == "personalize" then
									RageUI.Slider(primaryCustomColorIndex[1]['label'] .. " (" .. primaryCustomColorIndex[1]['index'] .. ")", primaryCustomColorIndex[1]['index'], 255, nil, false, {}, true,
										function(Hovered, Selected, Active, Index)
											if (primaryCustomColorIndex[1]['index'] == 255 and Index == 1) or 
												(primaryCustomColorIndex[1]['index'] == 1 and Index == 255) then
												Index = 0
											end
											if primaryCustomColorIndex[1]['index'] ~= Index then
												primaryCustomColorIndex[1]['index'] = Index
												SetVehicleCustomPrimaryColour(vehPedIsIn, primaryCustomColorIndex[1]['index'], primaryCustomColorIndex[2]['index'], primaryCustomColorIndex[3]['index'])
												compareMods('Primaire Personnalisé', 'customColorPrimary', -1, Index, calcModPrice(colorParts['customPrimaryColorPrice']))
											end
										end
									)
									RageUI.Slider(primaryCustomColorIndex[2]['label'] .. " (" .. primaryCustomColorIndex[2]['index'] .. ")", primaryCustomColorIndex[2]['index'], 255, nil, false, {}, true,
										function(Hovered, Selected, Active, Index)
											if (primaryCustomColorIndex[2]['index'] == 255 and Index == 1) or 
												(primaryCustomColorIndex[2]['index'] == 1 and Index == 255) then
												Index = 0
											end
											if primaryCustomColorIndex[2]['index'] ~= Index then
												primaryCustomColorIndex[2]['index'] = Index
												SetVehicleCustomPrimaryColour(vehPedIsIn, primaryCustomColorIndex[1]['index'], primaryCustomColorIndex[2]['index'], primaryCustomColorIndex[3]['index'])
												compareMods('Primaire Personnalisé', 'customColorPrimary', -1, Index, calcModPrice(colorParts['customPrimaryColorPrice']))
											end
										end
									)
									RageUI.Slider(primaryCustomColorIndex[3]['label'] .. " (" .. primaryCustomColorIndex[3]['index'] .. ")", primaryCustomColorIndex[3]['index'], 255, nil, false, {}, true,
										function(Hovered, Selected, Active, Index)
											if (primaryCustomColorIndex[3]['index'] == 255 and Index == 1) or 
												(primaryCustomColorIndex[3]['index'] == 1 and Index == 255) then
												Index = 0
											end
											if primaryCustomColorIndex[3]['index'] ~= Index then
												primaryCustomColorIndex[3]['index'] = Index
												SetVehicleCustomPrimaryColour(vehPedIsIn, primaryCustomColorIndex[1]['index'], primaryCustomColorIndex[2]['index'], primaryCustomColorIndex[3]['index'])
												compareMods('Primaire Personnalisé', 'customColorPrimary', -1, Index, calcModPrice(colorParts['customPrimaryColorPrice']))
											end
										end
									)	
									RageUI.Slider('Finition primaire' .. " (" .. primaryPaintFinishIndex .. ")", primaryPaintFinishIndex, #paintFinish, nil, false, {}, true,
										function(Hovered, Selected, Active, Index)
											if primaryPaintFinishIndex ~= Index then
												primaryPaintFinishIndex = Index
												SetVehicleColours(vehPedIsIn, paintFinish[primaryPaintFinishIndex], paintFinish[secondaryPaintFinishIndex])
												compareMods('Finition primaire', 'primaryPaintFinish', -1, Index, calcModPrice(colorParts['primaryPaintFinishPrice']))
											end
										end
									)
								else
									RageUI.Slider('Primaire' .. " (" .. primaryColorIndex .. ")", primaryColorIndex, #colorPalette[colorTypeIndex[1]][resprayTypes[1]['mod'][colorTypeIndex[1]]], nil, false, {}, true,
										function(Hovered, Selected, Active, Index)
											if primaryColorIndex ~= Index then
												primaryColorIndex = Index
												SetVehicleColours(vehPedIsIn, colorPalette[colorTypeIndex[1]][resprayTypes[1]['mod'][colorTypeIndex[1]]][primaryColorIndex], colorPalette[colorTypeIndex[2]][resprayTypes[2]['mod'][colorTypeIndex[2]]][secondaryColorIndex])
												compareMods('Primaire', 'color1', -1, Index, calcModPrice(colorParts['primaryColorPrice']))
											end
										end
									)
								end
							elseif tempColorParts['mod'][colorPartIndex] == 'secondary' then
								--ClearVehicleCustomSecondaryColour
								if resprayTypes[2]['mod'][colorTypeIndex[2]] == "personalize" then
									RageUI.Slider(secondaryCustomColorIndex[1]['label'] .. " (" .. secondaryCustomColorIndex[1]['index'] .. ")", secondaryCustomColorIndex[1]['index'], 255, nil, false, {}, true,
										function(Hovered, Selected, Active, Index)
											if (secondaryCustomColorIndex[1]['index'] == 255 and Index == 1) or 
												(secondaryCustomColorIndex[1]['index'] == 1 and Index == 255) then
												Index = 0
											end
											if secondaryCustomColorIndex[1]['index'] ~= Index then
												secondaryCustomColorIndex[1]['index'] = Index
												SetVehicleCustomSecondaryColour(vehPedIsIn, secondaryCustomColorIndex[1]['index'], secondaryCustomColorIndex[2]['index'], secondaryCustomColorIndex[3]['index'])
												compareMods('Secondaire Personnalisé', 'customColorSecondary', -1, Index, calcModPrice(colorParts['customSecondaryColorPrice']))
											end
										end
									)
									RageUI.Slider(secondaryCustomColorIndex[2]['label'] .. " (" .. secondaryCustomColorIndex[2]['index'] .. ")", secondaryCustomColorIndex[2]['index'], 255, nil, false, {}, true,
										function(Hovered, Selected, Active, Index)
											if (secondaryCustomColorIndex[2]['index'] == 255 and Index == 1) or 
												(secondaryCustomColorIndex[2]['index'] == 1 and Index == 255) then
												Index = 0
											end
											if secondaryCustomColorIndex[2]['index'] ~= Index then
												secondaryCustomColorIndex[2]['index'] = Index
												SetVehicleCustomSecondaryColour(vehPedIsIn, secondaryCustomColorIndex[1]['index'], secondaryCustomColorIndex[2]['index'], secondaryCustomColorIndex[3]['index'])
												compareMods('Secondaire Personnalisé', 'customColorSecondary', -1, Index, calcModPrice(colorParts['customSecondaryColorPrice']))
											end
										end
									)
									RageUI.Slider(secondaryCustomColorIndex[3]['label'] .. " (" .. secondaryCustomColorIndex[3]['index'] .. ")", secondaryCustomColorIndex[3]['index'], 255, nil, false, {}, true,
										function(Hovered, Selected, Active, Index)
											if (secondaryCustomColorIndex[3]['index'] == 255 and Index == 1) or 
												(secondaryCustomColorIndex[3]['index'] == 1 and Index == 255) then
												Index = 0
											end
											secondaryCustomColorIndex[3]['index'] = Index
											SetVehicleCustomSecondaryColour(vehPedIsIn, secondaryCustomColorIndex[1]['index'], secondaryCustomColorIndex[2]['index'], secondaryCustomColorIndex[3]['index'])
											compareMods('Secondaire Personnalisé', 'customColorSecondary', -1, Index, calcModPrice(colorParts['customSecondaryColorPrice']))
										end
									)	
									RageUI.Slider('Finition Secondaire' .. " (" .. secondaryPaintFinishIndex .. ")", secondaryPaintFinishIndex, #paintFinish, nil, false, {}, true,
										function(Hovered, Selected, Active, Index)
											secondaryPaintFinishIndex = Index
											if secondaryPaintFinishIndex ~= Index then
												SetVehicleColours(vehPedIsIn, paintFinish[primaryPaintFinishIndex], paintFinish[secondaryPaintFinishIndex])
												compareMods('Finition Secondaire', 'secondaryPaintFinish', -1, Index, calcModPrice(colorParts['secondaryPaintFinishPrice']))
											end
										end
									)
								else
									RageUI.Slider('Secondaire' .. " (" .. secondaryColorIndex .. ")", secondaryColorIndex, #colorPalette[colorTypeIndex[2]][resprayTypes[2]['mod'][colorTypeIndex[2]]], nil, false, {}, true,
										function(Hovered, Selected, Active, Index)
											if secondaryColorIndex ~= Index then
												secondaryColorIndex = Index
												SetVehicleColours(vehPedIsIn, colorPalette[colorTypeIndex[1]][resprayTypes[1]['mod'][colorTypeIndex[1]]][primaryColorIndex], colorPalette[colorTypeIndex[2]][resprayTypes[2]['mod'][colorTypeIndex[2]]][secondaryColorIndex])
												compareMods('Secondaire', 'color2', -1, Index, calcModPrice(colorParts['secondaryColorPrice']))
											end
										end
									)
								end
							--elseif tempColorParts['mod'][colorPartIndex] == 'interior' then
								--ClearVehicleCustomInteriorColour
								RageUI.Slider('Intérieur' .. " (" .. interiorColorIndex .. ")", interiorColorIndex, #colorPalette[colorTypeIndex[5]][resprayTypes[5]['mod'][colorTypeIndex[5]]], nil, false, {}, true,
									function(Hovered, Selected, Active, Index)
										if interiorColorIndex ~= Index then
											interiorColorIndex = Index
											SetVehicleInteriorColour(vehPedIsIn, colorPalette[colorTypeIndex[5]][resprayTypes[5]['mod'][colorTypeIndex[5]]][interiorColorIndex])
											compareMods('Intérieur', 'interior', -1, Index, calcModPrice(colorParts['interiorColorPrice']))
										end
									end
								)
							elseif tempColorParts['mod'][colorPartIndex] == 'pearlescent' then
								RageUI.Slider('Nacré' .. " (" .. pearlColorIndex .. ")", pearlColorIndex, #colorPalette[colorTypeIndex[3]][resprayTypes[3]['mod'][colorTypeIndex[3]]], nil, false, {}, true,
									function(Hovered, Selected, Active, Index)
										if pearlColorIndex ~= Index then
											pearlColorIndex = Index
											SetVehicleExtraColours(vehPedIsIn, colorPalette[colorTypeIndex[3]][resprayTypes[3]['mod'][colorTypeIndex[3]]][pearlColorIndex], colorPalette[1]['metallic'][wheelColorIndex])
											compareMods('Nacré', 'pearlescentColor', -1, Index, calcModPrice(colorParts['pearlescentColorPrice']))
										end
									end
								)
							end
						elseif colorPartIndex == 4 then
							RageUI.List('Fenêtres',resprayTypes[colorPartIndex]['label'], windowTintIndex,nil, {}, true, function(Hovered, Active, Selected, Index)
								end,function(Index, CurrentItems)
								local itemIndex = windowTintIndex - 2
								windowTintIndex = Index
								compareMods(windowTints['label'], windowTints['mod'], -1, itemIndex, calcModPrice(windowTints['price']))
								SetVehicleWindowTint(vehPedIsIn, windowTintIndex - 2)
							end)
						--elseif tempColorParts['mod'][colorPartIndex] == 'wheels' then
							RageUI.Slider('Couleurs jantes'.. " (" .. (colorPalette[8]['wheelPrice'] .. "$" or "---") .. ")",
								wheelColorIndex, #colorPalette[1]['metallic'], nil, false, {}, true,
								function(Hovered, Selected, Active, Index)
									if wheelColorIndex ~= Index then
										wheelColorIndex = Index
										SetVehicleExtraColours(vehPedIsIn, colorPalette[colorTypeIndex[3]][resprayTypes[3]['mod'][colorTypeIndex[3]]][pearlColorIndex], colorPalette[1]['metallic'][wheelColorIndex])
										compareMods('Couleurs jantes', 'wheelColor', -1, Index, calcModPrice(colorParts['wheelColorPrice']))
									end
								end
							)
						elseif tempColorParts['mod'][colorPartIndex] == 'headlights' then
							RageUI.Slider('Phares',
								xenonColorIndex, #xenon['items']['color'], nil, false, {}, true,
								function(Hovered, Selected, Active, Index)
									xenonColorIndex = Index
									if vehModsOld['modXenon'] then
										SetVehicleXenonLightsColour(vehPedIsIn, xenon['items']['color'][xenonColorIndex])
										compareMods(xenon['label1'], xenon['mod1'], -1, Index, calcModPrice(xenon['price']))
									end
								end
							)
						end
						DrawTextScreen(0.5, 0.90, 1.1, "Total facture: ~b~"..totalCartValue.."$~s~. Total entreprise: ~g~"..math.round(totalCartValue - shopProfitValue).."$~s~.", 4, 0)
					end, function()
						---Panels
					end
				)
				RageUI.IsVisible(neonMenu, true, false, true, function()
						RageUI.Checkbox(tempNeons[1]['label'] .. " (" .. (calcModPrice(tempNeons[1]['price']) .. "$" or "---") .. ")", 
							nil, 
							neon1, 
							{ }, 
							function(Hovered, Selected, Active, Checked)
								if Active then
									neon1 = Checked and true or false
									SetVehicleNeonLightEnabled(vehPedIsIn, 0, neon1)
									compareMods(neons[1]['label'], neons[1]['mod'], -1, neon1, ((neon1 and vehModsOld['neonEnabled'][1]) or (not neon1 and vehModsOld['neonEnabled'][1])) and 0 or calcModPrice(tempNeons[1]['price']))
								end
							end
						)
						RageUI.Checkbox(tempNeons[2]['label'] .. " (" .. (calcModPrice(tempNeons[2]['price']) .. "$" or "---") .. ")", 
							nil, 
							neon2, 
							{ }, 
							function(Hovered, Selected, Active, Checked)
								if Active then
									neon2 = Checked and true or false
									SetVehicleNeonLightEnabled(vehPedIsIn, 1, neon2)
									compareMods(neons[2]['label'], neons[2]['mod'], -1, neon2, ((neon2 and vehModsOld['neonEnabled'][3]) or (not neon2 and vehModsOld['neonEnabled'][3])) and 0 or calcModPrice(tempNeons[2]['price']))
								end
							end
						)
						RageUI.Checkbox(tempNeons[3]['label'] .. " (" .. (calcModPrice(tempNeons[3]['price']) .. "$" or "---") .. ")", 
							nil, 
							neon3, 
							{ }, 
							function(Hovered, Selected, Active, Checked)
								if Active then
									neon3 = Checked and true or false
									SetVehicleNeonLightEnabled(vehPedIsIn, 2, neon3)
									compareMods(neons[3]['label'], neons[3]['mod'], -1, neon3, ((neon3 and vehModsOld['neonEnabled'][2]) or (not neon3 and vehModsOld['neonEnabled'][2])) and 0 or calcModPrice(tempNeons[3]['price']))
								end
							end
						)
						RageUI.Checkbox(tempNeons[4]['label'] .. " (" .. (calcModPrice(tempNeons[4]['price']) .. "$" or "---") .. ")", 
							nil, 
							neon4, 
							{ }, 
							function(Hovered, Selected, Active, Checked)
								if Active then
									neon4 = Checked and true or false
									SetVehicleNeonLightEnabled(vehPedIsIn, 3, neon4)
									compareMods(neons[4]['label'], neons[4]['mod'], -1, neon4, ((neon4 and vehModsOld['neonEnabled'][4]) or (not neon4 and vehModsOld['neonEnabled'][4])) and 0 or calcModPrice(tempNeons[4]['price']))
								end
							end
						)
						if neon1 or neon2 or neon3 or neon4 then
							RageUI.Slider(neonIndex[1]['label'] .. " (" .. neonIndex[1]['index'] .. ")", neonIndex[1]['index'], 255, nil, false, {}, true,
								function(Hovered, Selected, Active, Index)
									if (neonIndex[1]['index'] == 255 and Index == 1) or 
										(neonIndex[1]['index'] == 1 and Index == 255) then
										Index = 0
									end
									if neonIndex[1]['index'] ~= Index then
										neonIndex[1]['index'] = Index
										SetVehicleNeonLightsColour(vehPedIsIn, neonIndex[1]['index'], neonIndex[2]['index'], neonIndex[3]['index'])
										if vehModsOld['neonEnabled'][1] or vehModsOld['neonEnabled'][2] or vehModsOld['neonEnabled'][3] or vehModsOld['neonEnabled'][4] then
											compareMods(neons[5]['label'], neons[5]['mod'], -1, Index, calcModPrice(neons[5]['price']))
										end
									end
								end
							)
							RageUI.Slider(neonIndex[2]['label'] .. " (" .. neonIndex[2]['index'] .. ")", neonIndex[2]['index'], 255, nil, false, {}, true,
								function(Hovered, Selected, Active, Index)
									if (neonIndex[2]['index'] == 255 and Index == 1) or 
										(neonIndex[2]['index'] == 1 and Index == 255) then
										Index = 0
									end
									if neonIndex[2]['index'] ~= Index then
										neonIndex[2]['index']= Index
										SetVehicleNeonLightsColour(vehPedIsIn, neonIndex[1]['index'], neonIndex[2]['index'], neonIndex[3]['index'])
										if vehModsOld['neonEnabled'][1] or vehModsOld['neonEnabled'][2] or vehModsOld['neonEnabled'][3] or vehModsOld['neonEnabled'][4] then
											compareMods(neons[5]['label'], neons[5]['mod'], -1, Index, calcModPrice(neons[5]['price']))
										end
									end
								end
							)
							RageUI.Slider(neonIndex[3]['label'] .. " (" .. neonIndex[3]['index'] .. ")", neonIndex[3]['index'], 255, nil, false, {}, true,
								function(Hovered, Selected, Active, Index)
									if (neonIndex[3]['index'] == 255 and Index == 1) or 
										(neonIndex[3]['index'] == 1 and Index == 255) then
										Index = 0
									end
									if neonIndex[3]['index'] ~= Index then
										neonIndex[3]['index'] = Index
										SetVehicleNeonLightsColour(vehPedIsIn, neonIndex[1]['index'], neonIndex[2]['index'], neonIndex[3]['index'])
										if vehModsOld['neonEnabled'][1] or vehModsOld['neonEnabled'][2] or vehModsOld['neonEnabled'][3] or vehModsOld['neonEnabled'][4] then
											compareMods(neons[5]['label'], neons[5]['mod'], -1, Index, calcModPrice(neons[5]['price']))
										end
									end
								end
							)
						end
						DrawTextScreen(0.5, 0.90, 1.1, "Total facture: ~b~"..totalCartValue.."$~s~. Total entreprise: ~g~"..math.round(totalCartValue - shopProfitValue).."$~s~.", 4, 0)
					end, function()
					---Panels
					end
				)
				RageUI.IsVisible(upgradeMenu, true, false, true, function()
						local menuItemCount = 0
						for i = 1, #tempUpgrades, 1 do
							local modCount = GetNumVehicleMods(vehPedIsIn, tempUpgrades[i]['modType'])
							local upgIndex = 1
							if tempUpgrades[i]['mod'] == 'modTurbo' then
								upgIndex = upgradeIndex[i][tempUpgrades[i]['mod']] and true or false
								local itemLabel = tempUpgrades[i]['label'] .. " (" .. (not upgIndex and (calcModPrice(tempUpgrades[i]['items']['price'][2]) or 0) .. "$" or "0$") .. ")"
								RageUI.Checkbox(itemLabel, nil, upgIndex, {}, function(Hovered, Selected, Active, Checked)
										if Active then
											upgradeIndex[i][tempUpgrades[i]['mod']] = Checked and true or false
											ToggleVehicleMod(vehPedIsIn, tempUpgrades[i]['modType'], upgradeIndex[i][tempUpgrades[i]['mod']])
											compareMods(tempUpgrades[i]['label'], tempUpgrades[i]['mod'], tempUpgrades[i]['modType'], upgradeIndex[i][tempUpgrades[i]['mod']], Checked and calcModPrice(tempUpgrades[i]['items']['price'][2]) or 0)
										end
									end
								)
								menuItemCount = menuItemCount + 1
							elseif modCount > 0 then
								upgIndex = upgradeIndex[i][tempUpgrades[i]['mod']]
								local itemLabel = tempUpgrades[i]['label'] .. " (" .. (calcModPrice(tempUpgrades[i]['items']['price'][upgIndex]) .. "$" or "---") .. ")"
								RageUI.List(itemLabel,
									tempUpgrades[i]['items']['label'], 
									upgIndex,
									nil, 
									{}, 
									true, 
									function(Hovered, Active, Selected, Index)
										if upgradeIndex[i][tempUpgrades[i]['mod']] ~= Index and Index <= modCount + 1 then -- +1 para contar com o index da peça STOCK
											upgradeIndex[i][tempUpgrades[i]['mod']] = Index
											if Selected then
										
											end
										end
									end,
									function(Index, CurrentItems)
									print(Index, CurrentItems)
									local itemIndex = Index - 2
									SetVehicleMod(vehPedIsIn, tempUpgrades[i]['modType'], Index - 2, false)
									compareMods(tempUpgrades[i]['label'], tempUpgrades[i]['mod'], tempUpgrades[i]['modType'], itemIndex, calcModPrice(tempUpgrades[i]['items']['price'][Index]))
								end
								)
								menuItemCount = menuItemCount + 1
							end
						end
						if menuItemCount == 0 then
						RageUI.Button("Aucun article dans le panier" , nil, {
								LeftBadge = nil,
								RightBadge = nil,
								RightLabel = nil
							}, true, function(Hovered, Active, Selected)
								if Selected then
									--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
								end
								if Hovered then
								-- My action the Button is hovered by the mouse
								end
								if Active then
								-- My action the Button is hightlighted
								end
							end, mainMenu)
					end
					DrawTextScreen(0.5, 0.90, 1.1, "Total facture: ~b~"..totalCartValue.."$~s~. Total entreprise: ~g~"..math.round(totalCartValue - shopProfitValue).."$~s~.", 4, 0)
					end, function()
						---Panels
					end
				)
				RageUI.IsVisible(cartMenu, true, false, true, function()
					local menuItemCount = 0
					for k, v in pairs(shopCart) do 
						RageUI.Button(shopCart[k]['label'], "", {
								LeftBadge = nil,
								RightBadge = nil,
								RightLabel = shopCart[k]['price'] .. " $"
							}, not deleting, function(Hovered, Active, Selected)
								if Selected then
									--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
								end
								if Hovered then
								-- My action the Button is hovered by the mouse
								end
								if Active then
								-- My action the Button is hightlighted
									if IsControlJustReleased(0, 22) then
										if deleting then
											return
										end
										deleting = true
										DeleteFromCart(k, shopCart[k]['modType'])
									end
								end
						end)
						menuItemCount = menuItemCount + 1
					end
					if menuItemCount == 0 then
						RageUI.Button('Liste des achats est vide !' , nil, {
							LeftBadge = nil,
							RightBadge = nil,
							RightLabel = nil
						}, true, function(Hovered, Active, Selected)
							if Selected then
								--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
							end
							if Hovered then
							-- My action the Button is hovered by the mouse
							end
							if Active then
							-- My action the Button is hightlighted
							end
						end, mainMenu)
						DrawTextScreen(0.5, 0.90, 1.1, "Total facture: ~b~"..totalCartValue.."$~s~. Total entreprise: ~g~"..math.round(totalCartValue - shopProfitValue).."$~s~.", 4, 0)
					else
						RageUI.Button('Montant total des bénéfices:' , 'Montant à retirer du compte d\'entreprise:', {
								LeftBadge = nil,
								RightBadge = nil,
								RightLabel = shopProfitValue .. " $"
							}, true, function(h, a, s)
								if s then
									--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
								end
								if h then
								-- My action the Button is hovered by the mouse
								end
								if a then
								-- My action the Button is hightlighted
								end
						end)
						RageUI.Button('Coût pour l\'entreprise:' , 'Montant à retirer de la société:', {
								LeftBadge = nil,
								RightBadge = nil,
								RightLabel = math.round(totalCartValue - shopProfitValue) .. " $"
							}, true, function(h, a, s)
								if s then
									--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
								end
								if h then
								-- My action the Button is hovered by the mouse
								end
								if a then
								-- My action the Button is hightlighted
								end
						end)
						RageUI.Button('Montant à recevoir:' , 'Montant à payer par le client:', {LeftBadge = nil,RightBadge = nil,RightLabel = totalCartValue .. " $"}, true, function()
						end)
						RageUI.Button("Valider et facturer la personne", nil, {RightBadge = RageUI.BadgeStyle.Tick, Color = { BackgroundColor = { 0, 120, 0, 25 } }}, not stop, function(h, a, s)
							if a then
								MarquerJoueur()
							end
							if s then
								local player, distance = ESX.Game.GetClosestPlayer()
								if player ~= -1 and distance <= 3.0 then
									if PlayerData.job.name == "harmony" then
										society_label = "society_harmony"
									end
									TriggerEvent("sBill:CreateBill",society_label)
									SneakyEvent("sCustom:buyModHarmony", math.round(totalCartValue - shopProfitValue))
									finishPurchase()
								else
									ESX.ShowNotification("~r~Aucun joueur à proximitée")
									local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
									ESX.Game.SetVehicleProperties(vehicle, myCar)
									RageUI.CloseAll()
									if stop then
										return
									end
								stop = true
								finishPurchase()
								end
							end
						end)
						DrawTextScreen(0.5, 0.90, 1.1, "Total facture: ~b~"..totalCartValue.."$~s~. Total entreprise: ~g~"..math.round(totalCartValue - shopProfitValue).."$~s~.", 4, 0)
					end
					end, function()
					end
				)
			else
				vehPedIsIn = nil
				terminatePurchase()
			end
		else
			Wait(1)
		end
	end
end)

RegisterNetEvent('sCustom:installMod')
AddEventHandler('sCustom:installMod', function()
	myCar = ESX.Game.GetVehicleProperties(GetVehiclePedIsIn(PlayerPedId(), false))
	SneakyEvent('sCustom:refreshOwnedVehicle', myCar)
end)

RegisterNetEvent('sCustom:cancelInstallMod')
AddEventHandler('sCustom:cancelInstallMod', function()
	ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(PlayerPedId(), false), myCar)
end)


function MarquerJoueur()
		local ped = GetPlayerPed(ESX.Game.GetClosestPlayer())
		local pos = GetEntityCoords(ped)
		local target, distance = ESX.Game.GetClosestPlayer()
		if distance <= 4.0 then
		DrawMarker(22, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 0, 0, 255, 0, 1, 2, 1, nil, nil, 0)
	end
end


-- Prevent Free Tunning Bug
Citizen.CreateThread(function()
	while true do
		if lsMenuIsShowed then
			Wait(0)
			DisableControlAction(2, 288, true)
			DisableControlAction(2, 289, true)
			DisableControlAction(2, 170, true)
			DisableControlAction(2, 167, true)
			DisableControlAction(2, 168, true)
			DisableControlAction(2, 23, true)
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		else
			Wait(250)
		end
	end
end)

RegisterNetEvent('sCustom:cantBill')
AddEventHandler('sCustom:cantBill', function(amount, targetId)
	--print("cancelled")
	terminatePurchase()
end)

RegisterNetEvent('sCustom:canBill')
AddEventHandler('sCustom:canBill', function(amount, targetId)
	terminatePurchase()
end)

RegisterNetEvent('sCustom:getVehicle')
AddEventHandler('sCustom:getVehicle', function()
	SneakyEvent('sCustom:refreshOwnedVehicle', ESX.Game.GetVehicleProperties(vehPedIsIn))
end)