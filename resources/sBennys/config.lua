Config                   = {}
Config.DrawDistance      = 15.0
Config.Locale            = 'fr'
Config.IsMecanoJobOnly = true
Config.IsMotorCycleBikerOnly = false

Config.shopProfit = 50

Config.Zones = {
	ls1 = {
		Pos   = { x = -238.24150085449, y = -1324.7150878906, z = 30.382925033569},
		Size  = {x = 3.0, y = 3.0, z = 0.2},
		Color = {r = 204, g = 204, b = 0},
		Marker= 27,
		Name  = "Benny's Original Motor Works",
		Hint  = 'appuyez sur ~INPUT_PICKUP~ pour personnaliser le véhicule.'
	},
	ls2 = {
		Pos   = { x = -238.89431762695, y = -1317.8510742188, z = 30.382766723633},
		Size  = {x = 3.0, y = 3.0, z = 0.2},
		Color = {r = 204, g = 204, b = 0},
		Marker= 27,
		Name  = "Benny's Original Motor Works",
		Hint  = 'appuyez sur ~INPUT_PICKUP~ pour personnaliser le véhicule.'
	},
	ls3 = {
		Pos   = { x = -192.61793518066, y = -1319.5057373047, z = 30.389398574829},
		Size  = {x = 3.0, y = 3.0, z = 0.2},
		Color = {r = 204, g = 204, b = 0},
		Marker= 27,
		Name  = "Benny's Original Motor Works",
		Hint  = 'appuyez sur ~INPUT_PICKUP~ pour personnaliser le véhicule.'
	},
}


function GetPlatesName(index)
	if (index == 0) then
		return 'bleu sur fond Blanc 1'
	elseif (index == 1) then
		return 'jaune sur fond Noir'
	elseif (index == 2) then
		return 'jaune sur fond Bleu'
	elseif (index == 3) then
		return 'bleu sur fond Blanc 2'
	elseif (index == 4) then
		return 'bleu sur fond Blanc 3'
	end
end

Config.bodyParts = {
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

Config.windowTints = { 
	mod = 'windowTint',
	label = { '[1/7]', '[2/7]', '[3/7]', '[4/7]', '[5/7]', '[6/7]', '[7/7]' },
	label1 = 'Fenêtres',
	tint = { -1, 0, 1, 2, 3, 4, 5 },
	price = 2.58
}

Config.colorParts = {
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

Config.resprayTypes = {
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

Config.xenon = {
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

Config.colorPalette = {
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

Config.paintFinish = { 0, 12, 15, 21, 117, 120 }

Config.neons = {
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
Config.extras = {
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
Config.upgrades = {
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