ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
end)
SneakyEvent = TriggerServerEvent
local Config = {}
local onService = false
local Ambulance = {
	PositionVestiaire = {
        {coords = vector3(314.59378051758,-601.26019287109,43.292755126953-0.9)},
		{coords = vector3(313.99053955078,-603.73736572266,43.29275894165-0.9)},
		{coords = vector3(340.41015625,-582.52899169922,28.912786483765-0.9)},
		{coords = vector3(1824.7069091797,3673.0632324219,34.277366638184-0.9)},
    },
	PositionGarage = {
        {coords = vector3(330.45846557617,-571.19451904297,28.844074249268-0.9)},
    },
	PositionGarage2 = {
		{coords = vector3(1821.6105957031,3688.4858398438,34.224384307861-0.9)},
    },
	PositionGarageHelico = {
        {coords = vector3(338.53219604492,-587.08941650391,74.165565490723-0.9)},
    },
	PositionGarageHelico2 = {
		{coords = vector3(1860.4895019531,3655.4445800781,35.641658782959-0.9)},
    },
	PositionDeleteGarage = {
        {coords = vector3(328.50750732422,-559.13116455078,28.51150894165-0.9)},
		{coords = vector3(1819.1116943359,3689.2385253906,33.617748260498-0.9)},
    },
	PositionDeleteGarageHelico = {
        {coords = vector3(353.00885009766,-587.97564697266,74.553367614746-0.9)},
		{coords = vector3(1864.6551513672,3650.4067382812,36.034397125244-0.9)},
    },
	PositionVestiairePatient = {
        {coords = vector3(323.86087036133,-568.71826171875,43.281585693359-0.9)},
		{coords = vector3(1822.9411621094,3680.2514648438,34.277309417725-0.9)},
    },
}

local configambulance = {

	clothsaccessories1 = {
		men = {
			{
				grade = "Masque stérile",
				cloths = {
					['mask_1'] = 197
				},
			},
		},
		women = {
			
			{
				grade = "Masque stérile",
				cloths = {
					['mask_1'] = 197
	
				},
			},
		},
	},
}

local Clothsambulance = {

	clothspatient = {
		men = {
			{
				grade = "Blouse Patient",
				cloths = {
					['tshirt_1'] = 15,  ['tshirt_2'] = 0,
					['torso_1'] = 448,   ['torso_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 15,
					['pants_1'] = 145,   ['pants_2'] = 0,
					['shoes_1'] = 34,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 0,    ['chain_2'] = 0,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['mask_1'] = 0,     ['mask_2'] = 0,
					['bags_1'] = 0,     ['bags_2'] = 0,
					['bproof_1'] = 0,     ['bproof_2'] = 0
				},
			},
		},
		women = {
			
			{
				grade = "Blouse Patient",
				cloths = {
					['tshirt_1'] = 14,  ['tshirt_2'] = 0,
					['torso_1'] = 451,   ['torso_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 4,
					['pants_1'] = 151,   ['pants_2'] = 0,
					['shoes_1'] = 35,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 0,    ['chain_2'] = 1,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['mask_1'] = 0,     ['mask_2'] = 0,
					['bags_1'] = 0,     ['bags_2'] = 0,
					['bproof_1'] = 0,     ['bproof_2'] = 0
	
				},
			},
		},
	},
	
    clothsrecrueml = {
		men = {
			{
				grade = "Tenue Recrue", -- que pour recrue
				cloths = {
					['tshirt_1'] = 230,  ['tshirt_2'] = 0,
					['torso_1'] = 433,   ['torso_2'] = 6,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 86,
					['pants_1'] = 148,   ['pants_2'] = 0,
					['shoes_1'] = 54,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 126,    ['chain_2'] = 0,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['mask_1'] = 0,     ['mask_2'] = 0,
					['bags_1'] = 0,     ['bags_2'] = 0,
					['bproof_1'] = 61,     ['bproof_2'] = 0
				},
			},
		},
		women = {
			
			{
				grade = "Tenue Recrue", -- que pour recrue
				cloths = {
					['tshirt_1'] = 250,  ['tshirt_2'] = 0,
					['torso_1'] = 434,   ['torso_2'] = 6,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 101,
					['pants_1'] = 152,   ['pants_2'] = 0,
					['shoes_1'] = 52,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 96,    ['chain_2'] = 1,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['mask_1'] = 0,     ['mask_2'] = 0,
					['bags_1'] = 0,     ['bags_2'] = 0,
					['bproof_1'] = 61,     ['bproof_2'] = 0
	
				},
			},
		},
	},
	
	clothsceremonie = {
		men = {
			{
				grade = "Tenue Cérémonie", -- pour tous les grades
				cloths = {
					['tshirt_1'] = 230,  ['tshirt_2'] = 0,
					['torso_1'] = 437,   ['torso_2'] = 6,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 83,
					['pants_1'] = 25,   ['pants_2'] = 5,
					['shoes_1'] = 54,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 0,    ['chain_2'] = 0,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['mask_1'] = 0,     ['mask_2'] = 0,
					['bags_1'] = 0,     ['bags_2'] = 0,
					['bproof_1'] = 0,     ['bproof_2'] = 0
				},
			},
		},	
		women = {
			
			{
				grade = "Tenue Cérémonie", -- pour tous les grades
				cloths = {
					['tshirt_1'] = 250,  ['tshirt_2'] = 0,
					['torso_1'] = 438,   ['torso_2'] = 6,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 88,
					['pants_1'] = 23,   ['pants_2'] = 0,
					['shoes_1'] = 52,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 0,    ['chain_2'] = 1,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['mask_1'] = 0,     ['mask_2'] = 0,
					['bags_1'] = 0,     ['bags_2'] = 0,
					['bproof_1'] = 0,     ['bproof_2'] = 0
	
				},
			},
		},
	},	
 	clothsgilet = {
		men = {
			{
				grade = "Tenue Gilet", -- pour urgentiste
				cloths = {
					['tshirt_1'] = 15,  ['tshirt_2'] = 0,
					['torso_1'] = 418,   ['torso_2'] = 5,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 86,
					['pants_1'] = 148,   ['pants_2'] = 0,
					['shoes_1'] = 54,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 0,    ['chain_2'] = 0,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['mask_1'] = 0,     ['mask_2'] = 0,
					['bags_1'] = 0,     ['bags_2'] = 0,
					['bproof_1'] = 63,     ['bproof_2'] = 0
				},
			},
		},
		women = {
			
			{
				grade = "Tenue Gilet", -- pour urgentiste
				cloths = {
					['tshirt_1'] = 14,  ['tshirt_2'] = 0,
					['torso_1'] = 427,   ['torso_2'] = 3,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 98,
					['pants_1'] = 152,   ['pants_2'] = 0,
					['shoes_1'] = 52,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 0,    ['chain_2'] = 1,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['mask_1'] = 0,     ['mask_2'] = 0,
					['bags_1'] = 0,     ['bags_2'] = 0,
					['bproof_1'] = 73,     ['bproof_2'] = 0
	
				},
			},
		},
	},	
	clothsvestechaude = {
		men = {
				{
					grade = "Tenue Veste Chaude", -- pour urgentiste
					cloths = {
						['tshirt_1'] = 15,  ['tshirt_2'] = 0,
						['torso_1'] = 432,   ['torso_2'] = 0,
						['decals_1'] = 147,   ['decals_2'] = 0,
						['arms'] = 93,
						['pants_1'] = 148,   ['pants_2'] = 0,
						['shoes_1'] = 54,   ['shoes_2'] = 0,
						['helmet_1'] = -1,  ['helmet_2'] = 0,
						['chain_1'] = 126,    ['chain_2'] = 0,
						['ears_1'] = -1,     ['ears_2'] = 0,
						['mask_1'] = 0,     ['mask_2'] = 0,
						['bags_1'] = 0,     ['bags_2'] = 0,
						['bproof_1'] = 0,     ['bproof_2'] = 0
					},
				},
			},	
		women = {
				
				{
					grade = "Tenue Veste Chaude", -- pour urgentiste
					cloths = {
						['tshirt_1'] = 14,  ['tshirt_2'] = 0,
						['torso_1'] = 433,   ['torso_2'] = 6,
						['decals_1'] = 154,   ['decals_2'] = 0,
						['arms'] = 101,
						['pants_1'] = 152,   ['pants_2'] = 0,
						['shoes_1'] = 52,   ['shoes_2'] = 0,
						['helmet_1'] = -1,  ['helmet_2'] = 0,
						['chain_1'] = 96,    ['chain_2'] = 1,
						['ears_1'] = -1,     ['ears_2'] = 0,
						['mask_1'] = 0,     ['mask_2'] = 0,
						['bags_1'] = 0,     ['bags_2'] = 0,
						['bproof_1'] = 0,     ['bproof_2'] = 0
		
					},
				},
			},
		},
 	clothsmanchelongue = {
		men = {
			{
				grade = "Tenue Manche Longue", -- pour urgentiste
				cloths = {
					['tshirt_1'] = 230,  ['tshirt_2'] = 0,
					['torso_1'] = 433,   ['torso_2'] = 6,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 86,
					['pants_1'] = 148,   ['pants_2'] = 0,
					['shoes_1'] = 54,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 126,    ['chain_2'] = 0,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['mask_1'] = 0,     ['mask_2'] = 0,
					['bags_1'] = 0,     ['bags_2'] = 0,
					['bproof_1'] = 61,     ['bproof_2'] = 0
				},
			},
		},
		women = {
			
			{
				grade = "Tenue Manche Longue", -- pour urgentiste
				cloths = {
					['tshirt_1'] = 250,  ['tshirt_2'] = 0,
					['torso_1'] = 434,   ['torso_2'] = 6,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 101,
					['pants_1'] = 152,   ['pants_2'] = 0,
					['shoes_1'] = 52,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 96,    ['chain_2'] = 1,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['mask_1'] = 0,     ['mask_2'] = 0,
					['bags_1'] = 0,     ['bags_2'] = 0,
					['bproof_1'] = 61,     ['bproof_2'] = 0
	
				},
			},
		},
	},		
	clothsinfirmier = {
		men = {
			{
				grade = "Tenue Manche Courte", -- que pour infirmier
				cloths = {
					['tshirt_1'] = 230,  ['tshirt_2'] = 0,
					['torso_1'] = 430,   ['torso_2'] = 6,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 92,
					['pants_1'] = 148,   ['pants_2'] = 0,
					['shoes_1'] = 54,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 126,    ['chain_2'] = 0,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['mask_1'] = 0,     ['mask_2'] = 0,
					['bags_1'] = 0,     ['bags_2'] = 0,
					['bproof_1'] = 61,     ['bproof_2'] = 0
				},
			},
		},
		women = {
			
			{
				grade = "Tenue Manche Courte", -- que pour infirmier
				cloths = {
					['tshirt_1'] = 250,  ['tshirt_2'] = 0,
					['torso_1'] = 432,   ['torso_2'] = 6,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 106,
					['pants_1'] = 152,   ['pants_2'] = 0,
					['shoes_1'] = 52,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 96,    ['chain_2'] = 0,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['mask_1'] = 0,     ['mask_2'] = 0,
					['bags_1'] = 0,     ['bags_2'] = 0,
					['bproof_1'] = 61,     ['bproof_2'] = 0
	
				},
			},
		},
	},
	
	
	clothsop = {
        men = {
            {
                grade = "Opération",
                cloths = {
                    ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                    ['torso_1'] = 425,   ['torso_2'] = 2,
                    ['decals_1'] = 0,   ['decals_2'] = 0,
                    ['arms'] = 92,
                    ['pants_1'] = 45,   ['pants_2'] = 2,
                    ['shoes_1'] = 42,   ['shoes_2'] = 0,
                    ['helmet_1'] = 14,  ['helmet_2'] = 2,
                    ['chain_1'] = 127,    ['chain_2'] = 0,
                    ['ears_1'] = -1,     ['ears_2'] = 0,
                    ['mask_1'] = 197,     ['mask_2'] = 2,
                    ['bags_1'] = 0,     ['bags_2'] = 0,
                    ['bproof_1'] = 0,     ['bproof_2'] = 0
                },
            },
        },
        women = {

            {
                grade = "Opération",
                cloths = {
                    ['tshirt_1'] = 14,  ['tshirt_2'] = 0,
                    ['torso_1'] = 411,   ['torso_2'] = 2,
                    ['decals_1'] = 0,   ['decals_2'] = 0,
                    ['arms'] = 98,
                    ['pants_1'] = 47,   ['pants_2'] = 2,
                    ['shoes_1'] = 1,   ['shoes_2'] = 0,
                    ['helmet_1'] = -1,  ['helmet_2'] = 0,
                    ['chain_1'] = 130,    ['chain_2'] = 0,
                    ['ears_1'] = -1,     ['ears_2'] = 0,
                    ['mask_1'] = 197,     ['mask_2'] = 2,
                    ['bags_1'] = 0,     ['bags_2'] = 0,
                    ['bproof_1'] = 0,     ['bproof_2'] = 0

                },
            },
        },
    },
	
	clothsmedecin = {
		men = {
			{
				grade = "Polo Rouge Médecin", -- que pour médecin
				cloths = {
					['tshirt_1'] = 230,  ['tshirt_2'] = 0,
					['torso_1'] = 454,   ['torso_2'] = 24,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 85,
					['pants_1'] = 148,   ['pants_2'] = 0,
					['shoes_1'] = 54,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 126,    ['chain_2'] = 0,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['mask_1'] = 0,     ['mask_2'] = 0,
					['bags_1'] = 0,     ['bags_2'] = 0,
					['bproof_1'] = 0,     ['bproof_2'] = 0
				},
			},
		},
		women = {
			
			{
				grade = "Polo Rouge Médecin", -- que pour médecin 
				cloths = {
					['tshirt_1'] = 250,  ['tshirt_2'] = 0,
					['torso_1'] = 442,   ['torso_2'] = 24,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 109,
					['pants_1'] = 152,   ['pants_2'] = 0,
					['shoes_1'] = 52,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 96,    ['chain_2'] = 0,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['mask_1'] = 0,     ['mask_2'] = 0,
					['bags_1'] = 0,     ['bags_2'] = 0,
					['bproof_1'] = 0,     ['bproof_2'] = 0
	
				},
			},
		},
	},
	
	
	
	
	
	clothsmedecinchef = {
		men = {
			{
				grade = "Polo Rouge Médecin-Chef", -- que pour médecin-chef
				cloths = {
					['tshirt_1'] = 230,  ['tshirt_2'] = 0,
					['torso_1'] = 454,   ['torso_2'] = 24,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 85,
					['pants_1'] = 148,   ['pants_2'] = 0,
					['shoes_1'] = 54,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 126,    ['chain_2'] = 0,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['mask_1'] = 0,     ['mask_2'] = 0,
					['bags_1'] = 0,     ['bags_2'] = 1,
					['bproof_1'] = 0,     ['bproof_2'] = 0
				},
			},
		},
		women = {
			
			{
				grade = "Polo Rouge Médecin-Chef", -- que pour médecin-chef
				cloths = {
					['tshirt_1'] = 250,  ['tshirt_2'] = 0,
					['torso_1'] = 442,   ['torso_2'] = 24,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 109,
					['pants_1'] = 152,   ['pants_2'] = 0,
					['shoes_1'] = 52,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 96,    ['chain_2'] = 0,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['mask_1'] = 0,     ['mask_2'] = 0,
					['bags_1'] = 0,     ['bags_2'] = 0,
					['bproof_1'] = 0,     ['bproof_2'] = 0
	
				},
			},
		},
	},
	clothssupervisor = {
		men = {
			{
				grade = "Polo Rouge Supervisor", -- que pour supervisor
				cloths = {
					['tshirt_1'] = 230,  ['tshirt_2'] = 0,
					['torso_1'] = 454,   ['torso_2'] = 23,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 0,
					['pants_1'] = 148,   ['pants_2'] = 0,
					['shoes_1'] = 54,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 126,    ['chain_2'] = 0,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['mask_1'] = 0,     ['mask_2'] = 0,
					['bags_1'] = 0,     ['bags_2'] = 0,
					['bproof_1'] = 61,     ['bproof_2'] = 0
				},
			},
		},
		women = {
			
			{
				grade = "Polo Rouge Supervisor", -- que pour supervisor
				cloths = {
					['tshirt_1'] = 250,  ['tshirt_2'] = 0,
					['torso_1'] = 442,   ['torso_2'] = 23,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 14,
					['pants_1'] = 152,   ['pants_2'] = 0,
					['shoes_1'] = 52,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 96,    ['chain_2'] = 0,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['mask_1'] = 0,     ['mask_2'] = 0,
					['bags_1'] = 0,     ['bags_2'] = 0,
					['bproof_1'] = 61,     ['bproof_2'] = 0
	
				},
			},
		},
	},
	
	
	
	clothsadd = {
		men = {
			{
			grade = "Assistant de Direction",
			cloths = {
					['tshirt_1'] = 230,  ['tshirt_2'] = 0,
					['torso_1'] = 454,   ['torso_2'] = 23,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 0,
					['pants_1'] = 148,   ['pants_2'] = 0,
					['shoes_1'] = 54,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 126,    ['chain_2'] = 0,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['mask_1'] = 0,     ['mask_2'] = 0,
					['bags_1'] = 0,     ['bags_2'] = 0,
					['bproof_1'] = 61,     ['bproof_2'] = 0
				},
			},
		},
		women = {
			
			{
				grade = "Assistante de Direction",
				cloths = {
			['tshirt_1'] = 250,  ['tshirt_2'] = 0,
                        ['torso_1'] = 442,   ['torso_2'] = 23,
                        ['decals_1'] = 0,   ['decals_2'] = 0,
                        ['arms'] = 14,
                        ['pants_1'] = 152,   ['pants_2'] = 0,
                        ['shoes_1'] = 52,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,  ['helmet_2'] = 0,
                        ['chain_1'] = 96,    ['chain_2'] = 0,
                        ['ears_1'] = -1,     ['ears_2'] = 0,
                        ['mask_1'] = 0,     ['mask_2'] = 0,
                        ['bags_1'] = 0,     ['bags_2'] = 0,
                        ['bproof_1'] = 61,     ['bproof_2'] = 0
	
				},
			},
		},
	},

	clothssousdirect = {
		men = {
			{
				grade = "Sous Direction",
				cloths = {
                        ['tshirt_1'] = 230,  ['tshirt_2'] = 0,
                        ['torso_1'] = 437,   ['torso_2'] = 6,
                        ['decals_1'] = 0,   ['decals_2'] = 0,
                        ['arms'] = 86,
                        ['pants_1'] = 148,   ['pants_2'] = 0,
                        ['shoes_1'] = 54,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,  ['helmet_2'] = 0,
                        ['chain_1'] = 126,    ['chain_2'] = 0,
                        ['ears_1'] = -1,     ['ears_2'] = 0,
                        ['mask_1'] = 0,     ['mask_2'] = 0,
                        ['bags_1'] = 0,     ['bags_2'] = 0,
                        ['bproof_1'] = 61,     ['bproof_2'] = 0
					},
				},
		},
		women = {
			
			{
				grade = "Sous Direction",
				cloths = {
					['tshirt_1'] = 250,  ['tshirt_2'] = 0,
					['torso_1'] = 438,   ['torso_2'] = 6,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['arms'] = 101,
					['pants_1'] = 152,   ['pants_2'] = 0,
					['shoes_1'] = 52,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 96,    ['chain_2'] = 0,
					['ears_1'] = -1,     ['ears_2'] = 0,
					['mask_1'] = 0,     ['mask_2'] = 0,
					['bags_1'] = 0,     ['bags_2'] = 0,
					['bproof_1'] = 61,     ['bproof_2'] = 0
				},
			},
		},
	},
}

AmbulanceVestiaire = {}
RMenu.Add('ambulancevestiaire', 'main', RageUI.CreateMenu("", "",nil,nil,"root_cause","ambulance"))
RMenu.Add('ambulancevestiaire', 'tenues', RageUI.CreateSubMenu(RMenu:Get('ambulancevestiaire', 'main'), "", "~g~Los Santos Medical Center"))
RMenu.Add('ambulancevestiaire', 'accessories', RageUI.CreateSubMenu(RMenu:Get('ambulancevestiaire', 'main'), "", "~g~Los Santos Medical Center"))
RMenu:Get('ambulancevestiaire', 'main'):SetSubtitle("~g~Los Santos Medical Center")
RMenu:Get('ambulancevestiaire', 'main').EnableMouse = false
RMenu:Get('ambulancevestiaire', 'main').Closed = function()
    AmbulanceVestiaire.Menu = false
end

function OpenAmbulanceVestiaireRageUIMenu()

    if AmbulanceVestiaire.Menu then
        AmbulanceVestiaire.Menu = false
    else
        AmbulanceVestiaire.Menu = true
        RageUI.Visible(RMenu:Get('ambulancevestiaire', 'main'), true)

        Citizen.CreateThread(function()
            while AmbulanceVestiaire.Menu do
				RageUI.IsVisible(RMenu:Get('ambulancevestiaire', 'main'), true, false, true, function()
                    RageUI.Button("Tenues", nil, {RightLabel = "→"}, true, function(h,a,s)
                    end,RMenu:Get("ambulancevestiaire","tenues"))
                    RageUI.Button("Accessoires", nil, {RightLabel = "→"}, true, function(h,a,s)
                    end,RMenu:Get("ambulancevestiaire","accessories"))
                end)
                RageUI.IsVisible(RMenu:Get('ambulancevestiaire', 'tenues'), true, false, true, function()
                    ESX.PlayerData = ESX.GetPlayerData()
                    pGrade = ESX.GetPlayerData().job.grade_label
                    RageUI.Button("Tenue Civil", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            ESX.TriggerServerCallback('Sneakyesx_skin:getPlayerSkin', function(skin)
                                TriggerEvent('Sneakyskinchanger:loadSkin', skin)
								onService = false
                            end)
                        end
                    end)
                    if GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01") then
                        if pGrade == "Recrue" then
                            for k,v in pairs(Clothsambulance.clothsrecrueml.men) do
                                RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
                                    if s then
                                        TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                                            TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                                            onService = true
                                        end)
                                    end
                                end)
                            end
                        end
                        if pGrade == "Urgentiste" then
                            for k,v in pairs(Clothsambulance.clothsgilet.men) do
                                RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
                                    if s then
                                        TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                                            TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                                            onService = true
                                        end)
                                    end
                                end)
                            end
                            for k,v in pairs(Clothsambulance.clothsvestechaude.men) do
                                RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
                                    if s then
                                        TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                                            TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                                            onService = true
                                        end)
                                    end
                                end)
                            end
                            for k,v in pairs(Clothsambulance.clothsmanchelongue.men) do
                                RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
                                    if s then
                                        TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                                            TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                                            onService = true
                                        end)
                                    end
                                end)
                            end
                        end
                        if pGrade == "Infirmier" then
                            for k,v in pairs(Clothsambulance.clothsinfirmier.men) do
                                RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
                                    if s then
                                        TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                                            TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                                            onService = true
                                        end)
                                    end
                                end)
                            end
                        end
                        if pGrade == "Médecin" then
                            for k,v in pairs(Clothsambulance.clothsmedecin.men) do
                                RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
                                    if s then
                                        TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                                            TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                                            onService = true
                                        end)
                                    end
                                end)
                            end
                        end
                        if pGrade == "Médecin en chef" then
                            for k,v in pairs(Clothsambulance.clothsmedecinchef.men) do
                                RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
                                    if s then
                                        TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                                            TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                                            onService = true
                                        end)
                                    end
                                end)
                            end
                        end
                        if pGrade == "Superviseur" then
                            for k,v in pairs(Clothsambulance.clothssupervisor.men) do
                                RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
                                    if s then
                                        TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                                            TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                                            onService = true
                                        end)
                                    end
                                end)
                            end
                        end
                        if pGrade == "Assistant de direction" then
                            for k,v in pairs(Clothsambulance.clothsadd.men) do
                                RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
                                    if s then
                                        TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                                            TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                                            onService = true
                                        end)
                                    end
                                end)
                            end
                        end
                        if pGrade == "Sous directeur" then
                            for k,v in pairs(Clothsambulance.clothssousdirect.men) do
                                RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
                                    if s then
                                        TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                                            TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                                            onService = true
                                        end)
                                    end
                                end)
                            end
                        end
                        for k,v in pairs(Clothsambulance.clothsceremonie.men) do
                            RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
                                if s then
                                    TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                                        TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                                        onService = true
                                    end)
                                end
                            end)
                        end
                        for k,v in pairs(Clothsambulance.clothsop.men) do
                            RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
                                if s then
                                    TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                                        TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                                        onService = true
                                    end)
                                end
                            end)
                        end
                    else
                        if pGrade == "Recrue" then
                            for k,v in pairs(Clothsambulance.clothsrecrueml.women) do
                                RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
                                    if s then
                                        TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                                            TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                                            onService = true
                                        end)
                                    end
                                end)
                            end
                        end
                        if pGrade == "Urgentiste" then
                            for k,v in pairs(Clothsambulance.clothsgilet.women) do
                                RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
                                    if s then
                                        TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                                            TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                                            onService = true
                                        end)
                                    end
                                end)
                            end
                            for k,v in pairs(Clothsambulance.clothsvestechaude.women) do
                                RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
                                    if s then
                                        TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                                            TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                                            onService = true
                                        end)
                                    end
                                end)
                            end
                            for k,v in pairs(Clothsambulance.clothsmanchelongue.women) do
                                RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
                                    if s then
                                        TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                                            TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                                            onService = true
                                        end)
                                    end
                                end)
                            end
                        end
                        if pGrade == "Infirmier" then
                            for k,v in pairs(Clothsambulance.clothsinfirmier.women) do
                                RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
                                    if s then
                                        TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                                            TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                                            onService = true
                                        end)
                                    end
                                end)
                            end
                        end
                        if pGrade == "Médecin" then
                            for k,v in pairs(Clothsambulance.clothsmedecin.women) do
                                RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
                                    if s then
                                        TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                                            TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                                            onService = true
                                        end)
                                    end
                                end)
                            end
                        end
                        if pGrade == "Médecin en chef" then
                            for k,v in pairs(Clothsambulance.clothsmedecinchef.women) do
                                RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
                                    if s then
                                        TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                                            TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                                            onService = true
                                        end)
                                    end
                                end)
                            end
                        end
                        if pGrade == "Superviseur" then
                            for k,v in pairs(Clothsambulance.clothssupervisor.women) do
                                RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
                                    if s then
                                        TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                                            TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                                            onService = true
                                        end)
                                    end
                                end)
                            end
                        end
                        if pGrade == "Assistant de direction" then
                            for k,v in pairs(Clothsambulance.clothsadd.women) do
                                RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
                                    if s then
                                        TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                                            TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                                            onService = true
                                        end)
                                    end
                                end)
                            end
                        end
                        if pGrade == "Sous directeur" then
                            for k,v in pairs(Clothsambulance.clothssousdirect.women) do
                                RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
                                    if s then
                                        TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                                            TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                                            onService = true
                                        end)
                                    end
                                end)
                            end
                        end
                        for k,v in pairs(Clothsambulance.clothsceremonie.women) do
                            RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
                                if s then
                                    TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                                        TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                                        onService = true
                                    end)
                                end
                            end)
                        end
                        for k,v in pairs(Clothsambulance.clothsop.women) do
                            RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
                                if s then
                                    TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                                        TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                                        onService = true
                                    end)
                                end
                            end)
                        end
                    end
                end)
				RageUI.IsVisible(RMenu:Get('ambulancevestiaire', 'accessories'), true, false, true, function()
                    if GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01") then
						for k,v in pairs(configambulance.clothsaccessories1.men) do
							RageUI.Button("Accessoire : ~b~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
								if s then
									TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
										TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
									end)
								end
							end)
						end
                    else
						for k,v in pairs(configambulance.clothsaccessories1.women) do
							RageUI.Button("Accessoire : ~g~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
								if s then
									TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
										TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
									end)
								end
							end)
						end
                    end
                end)
				Wait(0)
			end
		end)
	end

end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while true do
        att = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        for k,v in pairs(Ambulance.PositionVestiaire) do
            local mPos = #(v.coords-pCoords)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then
                if not AmbulanceVestiaire.Menu then
                    if mPos <= 4.0 then
                        att = 1
                        DrawText3D(v.coords.x, v.coords.y, v.coords.z+1, "Appuyez sur ~g~E~s~ pour accéder au ~g~vestiaire~s~.", 9)
                        if mPos <= 2.0 then
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au ~g~vestiaire~s~.")
                            if IsControlJustPressed(0, 51) then
                                ESX.PlayerData = ESX.GetPlayerData()
                                pGrade = ESX.GetPlayerData().job.grade_label
                                OpenAmbulanceVestiaireRageUIMenu()
                            end
                        end
                    end
                end
            end
        end
        for k,v in pairs(Ambulance.PositionVestiairePatient) do
            local mPos = #(v.coords-pCoords)
            if not AmbulanceVestiairePatient.Menu then
                if mPos <= 10.0 then
                    att = 1
					if mPos <= 3.5 then
                    	DrawText3D(v.coords.x, v.coords.y, v.coords.z+1, "Appuyez sur ~g~E~s~ pour prendre une ~g~blouse~s~.", 9)
					end
					if mPos <= 1.5 then
						ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au ~g~blouses~s~.")
						if IsControlJustPressed(0, 51) then
							ESX.PlayerData = ESX.GetPlayerData()
							pGrade = ESX.GetPlayerData().job.grade_label
							OpenAmbulanceVestiairePatientRageUIMenu()
						end
					end
                end
            end
        end
        for k,v in pairs(Ambulance.PositionGarage) do
            local mPos = #(v.coords-pCoords)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then
                if not AmbulanceGarage.Menu then
                    if mPos <= 10.0 then
                        att = 1
                        
                        if mPos <= 1.5 then
							if onService then
								DrawText3D(v.coords.x, v.coords.y, v.coords.z+1, "Appuyez sur ~g~E~s~ pour accéder au ~g~garage~s~.", 9)
								ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au ~g~garage~s~.")
								if IsControlJustPressed(0, 51) then
									OpenAmbulanceGarageRageUIMenu()
								end
							else
								ESX.ShowHelpNotification("Merci de prendre votre ~r~service~s~.")
							end
                        end
                    end
                end
            end
        end
		for k,v in pairs(Ambulance.PositionGarage2) do
            local mPos = #(v.coords-pCoords)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then
                if not AmbulanceGarage.Menu then
                    if mPos <= 10.0 then
                        att = 1
                        
                        if mPos <= 1.5 then
							if onService then
								DrawText3D(v.coords.x, v.coords.y, v.coords.z+1, "Appuyez sur ~g~E~s~ pour accéder au ~g~garage~s~.", 9)
								ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au ~g~garage~s~.")
								if IsControlJustPressed(0, 51) then
									OpenAmbulanceGarageRageUIMenu2()
								end
							else
								ESX.ShowHelpNotification("Merci de prendre votre ~r~service~s~.")
							end
                        end
                    end
                end
            end
        end
		for k,v in pairs(Ambulance.PositionGarageHelico) do
            local mPos = #(v.coords-pCoords)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then
                if not AmbulanceGarageHelico.Menu then
                    if mPos <= 10.0 then
                        att = 1
                        
                        if mPos <= 1.5 then
							if onService then
								ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au ~g~garage~s~.")
								if IsControlJustPressed(0, 51) then
									OpenAmbulanceGarageHelicoRageUIMenu()
								end
							else
								ESX.ShowHelpNotification("Merci de prendre votre ~r~service~s~.")
							end
                        end
                    end
                end
            end
        end
		for k,v in pairs(Ambulance.PositionGarageHelico2) do
            local mPos = #(v.coords-pCoords)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then
                if not AmbulanceGarageHelico.Menu then
                    if mPos <= 10.0 then
                        att = 1
                        
                        if mPos <= 1.5 then
							if onService then
								ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au ~g~garage~s~.")
								if IsControlJustPressed(0, 51) then
									OpenAmbulanceGarageHelicoRageUIMenu2()
								end
							else
								ESX.ShowHelpNotification("Merci de prendre votre ~r~service~s~.")
							end
                        end
                    end
                end
            end
        end
        for k,v in pairs(Ambulance.PositionDeleteGarage) do
            local mPos = #(v.coords-pCoords)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then
                if not AmbulanceGarage.Menu then
                    if IsPedInAnyVehicle(PlayerPedId(), true) then
                        if mPos <= 10.0 then
                            att = 1
                            if mPos <= 3.5 then
								if onService then
									DrawMarker(20, v.coords.x, v.coords.y, v.coords.z+0.9, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255, 0, 0, 255, 55555, false, true, 2, false, false, false, false)
									ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ranger le ~r~véhicule~s~.")
									if IsControlJustPressed(0, 51) then
										DelVehAmbulance()
									end
								else
									ESX.ShowHelpNotification("Merci de prendre votre ~r~service~s~.")
								end
                            end
                        end
                    end
                end
            end
        end
		for k,v in pairs(Ambulance.PositionDeleteGarageHelico) do
            local mPos = #(v.coords-pCoords)
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then
                if not AmbulanceGarage.Menu then
                    if IsPedInAnyVehicle(PlayerPedId(), true) then
                        if mPos <= 10.0 then
                            att = 1
                            if mPos <= 3.5 then
								if onService then
									DrawMarker(20, v.coords.x, v.coords.y, v.coords.z+0.9, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255, 0, 0, 255, 55555, false, true, 2, false, false, false, false)
									ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ranger le ~r~l'hélicoptère.")
									if IsControlJustPressed(0, 51) then
										DelVehAmbulanceHelico()
									end
								else
									ESX.ShowHelpNotification("Merci de prendre votre ~r~service~s~.")
								end
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(att)
    end
end)


AmbulanceVestiairePatient = {}
RMenu.Add('ambulancevestiairepatient', 'main', RageUI.CreateMenu("", "",nil,nil,"root_cause","ambulance"))
RMenu:Get('ambulancevestiairepatient', 'main'):SetSubtitle("~g~Los Santos Medical Center")
RMenu:Get('ambulancevestiairepatient', 'main').EnableMouse = false
RMenu:Get('ambulancevestiairepatient', 'main').Closed = function()
    AmbulanceVestiairePatient.Menu = false
end

function OpenAmbulanceVestiairePatientRageUIMenu()

    if AmbulanceVestiairePatient.Menu then
        AmbulanceVestiairePatient.Menu = false
    else
        AmbulanceVestiairePatient.Menu = true
        RageUI.Visible(RMenu:Get('ambulancevestiairepatient', 'main'), true)

        Citizen.CreateThread(function()
            while AmbulanceVestiairePatient.Menu do
                RageUI.IsVisible(RMenu:Get('ambulancevestiairepatient', 'main'), true, false, true, function()
                    RageUI.Button("Tenue Civil", nil, {RightLabel = "→"}, true, function(h,a,s)
                        if s then
                            ESX.TriggerServerCallback('Sneakyesx_skin:getPlayerSkin', function(skin)
                                TriggerEvent('Sneakyskinchanger:loadSkin', skin)
                            end)
                        end
                    end)
                    RageUI.Separator("~g~↓~s~ Blouse ~g~↓~s~")
                    if GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01") then
                        for k,v in pairs(Clothsambulance.clothspatient.men) do
                            RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
                                if s then
                                    TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                                        TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                                        
                                    end)
                                end
                            end)
                        end
                    else
                        for k,v in pairs(Clothsambulance.clothspatient.women) do
                            RageUI.Button("Tenue de ~b~"..v.grade, nil, {RightLabel = "→"}, true, function(h,a,s)
                                if s then
                                    TriggerEvent('Sneakyskinchanger:getSkin', function(skin)
                                        TriggerEvent('Sneakyskinchanger:loadClothes', skin, v.cloths)
                                        
                                    end)
                                end
                            end)
                        end
                    end
                end)
				Wait(0)
			end
		end)
	end
end

local garageambulance = {

	garageambulance = {
        vehs = {
            {label = "Fourgon Ambulance", veh = "ambulance", stock = 4},
			{label = "Vapid Ambulance", veh = "ambulance2", stock = 4},
			{label = "Roamer", veh = "emsroamer", stock = 3},
        },
        pos  = {
            {pos = vector3(339.79864501953,-571.00378417969,28.557567596436), heading = 339.443},
			{pos = vector3(335.17340087891,-569.27172851562,28.557065963745), heading = 339.702},
			{pos = vector3(328.19366455078,-566.61572265625,28.562477111816), heading = 339.685},
			{pos = vector3(324.18927001953,-565.17510986328,28.559635162354), heading = 340.820},
        },
    },
}

local garageambulancehelico = {

	garageambulancehelico = {
        vehs = {
            {label = "Hélicoptère", veh = "polmav", stock = 2},
        },
        pos  = {
            {pos = vector3(353.05697631836,-587.97668457031,74.554069519043), heading = 90.60},
        },
    },
}

AmbulanceGarageHelico = {}
RMenu.Add('ambulancegaragehelico', 'main', RageUI.CreateMenu("", "",nil,nil,"root_cause","ambulance"))
RMenu:Get('ambulancegaragehelico', 'main'):SetSubtitle("~g~Los Santos Medical Center")
RMenu:Get('ambulancegaragehelico', 'main').EnableMouse = false
RMenu:Get('ambulancegaragehelico', 'main').Closed = function()
    AmbulanceGarageHelico.Menu = false
end

function OpenAmbulanceGarageHelicoRageUIMenu()

    if AmbulanceGarageHelico.Menu then
        AmbulanceGarageHelico.Menu = false
    else
        AmbulanceGarageHelico.Menu = true
        RageUI.Visible(RMenu:Get('ambulancegaragehelico', 'main'), true)

        Citizen.CreateThread(function()
            while AmbulanceGarageHelico.Menu do
                RageUI.IsVisible(RMenu:Get('ambulancegaragehelico', 'main'), true, false, true, function()
                    for k,v in pairs(garageambulancehelico.garageambulancehelico.vehs) do
                        RageUI.Button(v.label, nil, {RightLabel = "Stock: (~g~"..v.stock.."~s~)"}, v.stock > 0, function(h,a,s)
                            if s then
                                local pos = FoundClearSpawnPoint(garageambulancehelico.garageambulancehelico.pos)
                                if pos ~= false then
                                    LoadModel(v.veh)
                                    local veh = CreateVehicle(GetHashKey(v.veh), pos.pos, pos.heading, true, false)
                                    SetVehicleLivery(veh, 1)
                                    SetEntityAsMissionEntity(veh, 1, 1)
                                    SetVehicleDirtLevel(veh, 0.0)
                                    ShowLoadingMessage("Véhicule de service sortie.", 2, 2000)
                                    SneakyEvent('Sneakyesx_vehiclelock:givekey', 'no', GetVehicleNumberPlateText(veh))
									TriggerEvent('persistent-vehicles/register-vehicle', veh)
                                    garageambulancehelico.garageambulancehelico.vehs[k].stock = garageambulancehelico.garageambulancehelico.vehs[k].stock - 1
                                    Wait(350)
                                else
                                    ESX.ShowNotification("Aucun point de sortie disponible")
                                end
                            end
                        end)
                    end
                end)
				Wait(0)
			end
		end)
	end

end


local garageambulancehelico2 = {

	garageambulancehelico2 = {
        vehs = {
            {label = "Hélicoptère", veh = "lsfdmav", stock = 2},
        },
        pos  = {
            {pos = vector3(1864.5755615234,3650.0571289062,36.033184051514), heading = 208.595},
        },
    },
}

AmbulanceGarageHelico2 = {}
RMenu.Add('ambulancegaragehelico2', 'main', RageUI.CreateMenu("", "",nil,nil,"root_cause","ambulance"))
RMenu:Get('ambulancegaragehelico2', 'main'):SetSubtitle("~g~Los Santos Medical Center")
RMenu:Get('ambulancegaragehelico2', 'main').EnableMouse = false
RMenu:Get('ambulancegaragehelico2', 'main').Closed = function()
    AmbulanceGarageHelico2.Menu = false
end

function OpenAmbulanceGarageHelicoRageUIMenu2()

    if AmbulanceGarageHelico2.Menu then
        AmbulanceGarageHelico2.Menu = false
    else
        AmbulanceGarageHelico2.Menu = true
        RageUI.Visible(RMenu:Get('ambulancegaragehelico2', 'main'), true)

        Citizen.CreateThread(function()
            while AmbulanceGarageHelico2.Menu do
                RageUI.IsVisible(RMenu:Get('ambulancegaragehelico2', 'main'), true, false, true, function()
                    for k,v in pairs(garageambulancehelico2.garageambulancehelico2.vehs) do
                        RageUI.Button(v.label, nil, {RightLabel = "Stock: (~g~"..v.stock.."~s~)"}, v.stock > 0, function(h,a,s)
                            if s then
                                local pos = FoundClearSpawnPoint(garageambulancehelico2.garageambulancehelico2.pos)
                                if pos ~= false then
                                    LoadModel(v.veh)
                                    local veh = CreateVehicle(GetHashKey(v.veh), pos.pos, pos.heading, true, false)
                                    SetVehicleLivery(veh, 1)
                                    SetEntityAsMissionEntity(veh, 1, 1)
                                    SetVehicleDirtLevel(veh, 0.0)
                                    ShowLoadingMessage("Véhicule de service sortie.", 2, 2000)
                                    SneakyEvent('Sneakyesx_vehiclelock:givekey', 'no', GetVehicleNumberPlateText(veh))
									TriggerEvent('persistent-vehicles/register-vehicle', veh)
                                    garageambulancehelico2.garageambulancehelico2.vehs[k].stock = garageambulancehelico2.garageambulancehelico2.vehs[k].stock - 1
                                    Wait(350)
                                else
                                    ESX.ShowNotification("Aucun point de sortie disponible")
                                end
                            end
                        end)
                    end
                end)
				Wait(0)
			end
		end)
	end

end



function CheckServiceAmbulance()
	return onService
end

AmbulanceGarage = {}
RMenu.Add('ambulancegarage', 'main', RageUI.CreateMenu("", "",nil,nil,"root_cause","ambulance"))
RMenu:Get('ambulancegarage', 'main'):SetSubtitle("~g~Los Santos Medical Center")
RMenu:Get('ambulancegarage', 'main').EnableMouse = false
RMenu:Get('ambulancegarage', 'main').Closed = function()
    AmbulanceGarage.Menu = false
end

function OpenAmbulanceGarageRageUIMenu()

    if AmbulanceGarage.Menu then
        AmbulanceGarage.Menu = false
    else
        AmbulanceGarage.Menu = true
        RageUI.Visible(RMenu:Get('ambulancegarage', 'main'), true)

        Citizen.CreateThread(function()
            while AmbulanceGarage.Menu do
                RageUI.IsVisible(RMenu:Get('ambulancegarage', 'main'), true, false, true, function()
                    for k,v in pairs(garageambulance.garageambulance.vehs) do
                        RageUI.Button(v.label, nil, {RightLabel = "Stock: (~g~"..v.stock.."~s~)"}, v.stock > 0, function(h,a,s)
                            if s then
                                local pos = FoundClearSpawnPoint(garageambulance.garageambulance.pos)
                                if pos ~= false then
                                    LoadModel(v.veh)
                                    local veh = CreateVehicle(GetHashKey(v.veh), pos.pos, pos.heading, true, false)
                                    --SetVehicleLivery(veh, 2)
                                    SetEntityAsMissionEntity(veh, 1, 1)
                                    SetVehicleDirtLevel(veh, 0.0)
                                    ShowLoadingMessage("Véhicule de service sortie.", 2, 2000)
                                    SneakyEvent('Sneakyesx_vehiclelock:givekey', 'no', GetVehicleNumberPlateText(veh))
									TriggerEvent('persistent-vehicles/register-vehicle', veh)
                                    garageambulance.garageambulance.vehs[k].stock = garageambulance.garageambulance.vehs[k].stock - 1
                                    Wait(350)
                                else
                                    ESX.ShowNotification("Aucun point de sortie disponible")
                                end
                            end
                        end)
                    end
                end)
				Wait(0)
			end
		end)
	end

end

local garageambulance2 = {

	garageambulance2 = {
        vehs = {
            {label = "Fourgon Ambulance", veh = "ambulance", stock = 4},
			{label = "Vapid Ambulance", veh = "ambulance2", stock = 6},
			{label = "Roamer", veh = "emsroamer", stock = 3},
        },
        pos  = {
            {pos = vector3(1819.1116943359,3689.2385253906,33.617748260498), heading = 299.995},
        },
    },
}

AmbulanceGarage2 = {}
RMenu.Add('ambulancegarage2', 'main', RageUI.CreateMenu("", "",nil,nil,"root_cause","ambulance"))
RMenu:Get('ambulancegarage2', 'main'):SetSubtitle("~g~Los Santos Medical Center")
RMenu:Get('ambulancegarage2', 'main').EnableMouse = false
RMenu:Get('ambulancegarage2', 'main').Closed = function()
    AmbulanceGarage2.Menu = false
end

function OpenAmbulanceGarageRageUIMenu2()

    if AmbulanceGarage2.Menu then
        AmbulanceGarage2.Menu = false
    else
        AmbulanceGarage2.Menu = true
        RageUI.Visible(RMenu:Get('ambulancegarage2', 'main'), true)

        Citizen.CreateThread(function()
            while AmbulanceGarage2.Menu do
                RageUI.IsVisible(RMenu:Get('ambulancegarage2', 'main'), true, false, true, function()
                    for k,v in pairs(garageambulance2.garageambulance2.vehs) do
                        RageUI.Button(v.label, nil, {RightLabel = "Stock: (~g~"..v.stock.."~s~)"}, v.stock > 0, function(h,a,s)
                            if s then
                                local pos = FoundClearSpawnPoint(garageambulance2.garageambulance2.pos)
                                if pos ~= false then
                                    LoadModel(v.veh)
                                    local veh = CreateVehicle(GetHashKey(v.veh), pos.pos, pos.heading, true, false)
                                    --SetVehicleLivery(veh, 2)
                                    SetEntityAsMissionEntity(veh, 1, 1)
                                    SetVehicleDirtLevel(veh, 0.0)
                                    ShowLoadingMessage("Véhicule de service sortie.", 2, 2000)
                                    SneakyEvent('Sneakyesx_vehiclelock:givekey', 'no', GetVehicleNumberPlateText(veh))
									TriggerEvent('persistent-vehicles/register-vehicle', veh)
                                    garageambulance2.garageambulance2.vehs[k].stock = garageambulance2.garageambulance2.vehs[k].stock - 1
                                    Wait(350)
                                else
                                    ESX.ShowNotification("Aucun point de sortie disponible")
                                end
                            end
                        end)
                    end
                end)
				Wait(0)
			end
		end)
	end
end





function ShowLoadingMessage(text, spinnerType, timeMs)
	Citizen.CreateThread(function()
		BeginTextCommandBusyspinnerOn("STRING")
		AddTextComponentSubstringPlayerName(text)
		EndTextCommandBusyspinnerOn(spinnerType)
		Wait(timeMs)
		RemoveLoadingPrompt()
	end)
end

function DelVehAmbulance()
	local pPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(pPed, false) then
		local pVeh = GetVehiclePedIsIn(pPed, false)
		local model = GetEntityModel(pVeh)
		Citizen.CreateThread(function()
			ShowLoadingMessage("Rangement du véhicule ...", 1, 2500)
		end)
		local vehicle = GetVehiclePedIsIn(PlayerPedId(),  false)
        local plate = GetVehicleNumberPlateText(vehicle)
        SneakyEvent('Sneakyesx_vehiclelock:deletekeyjobs', 'no', plate)
		TaskLeaveAnyVehicle(pPed, 1, 1)
		Wait(2500)
		while IsPedInAnyVehicle(pPed, false) do
			TaskLeaveAnyVehicle(pPed, 1, 1)
			ShowLoadingMessage("Rangement du véhicule ...", 1, 300)
			Wait(200)
		end
		TriggerEvent('persistent-vehicles/forget-vehicle', pVeh)
	    DeleteEntity(pVeh)
		for k,v in pairs(garageambulance.garageambulance.vehs) do
			if model == GetHashKey(v.veh) then
				garageambulance.garageambulance.vehs[k].stock = garageambulance.garageambulance.vehs[k].stock + 1
			end
		end
	else
		ShowNotification("Vous devez être dans un véhicule.")
	end
end

function DelVehAmbulanceHelico()
	local pPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(pPed, false) then
		local pVeh = GetVehiclePedIsIn(pPed, false)
		local model = GetEntityModel(pVeh)
		Citizen.CreateThread(function()
			ShowLoadingMessage("Rangement du véhicule ...", 1, 2500)
		end)
		local vehicle = GetVehiclePedIsIn(PlayerPedId(),  false)
        local plate = GetVehicleNumberPlateText(vehicle)
        SneakyEvent('Sneakyesx_vehiclelock:deletekeyjobs', 'no', plate)
		TaskLeaveAnyVehicle(pPed, 1, 1)
		Wait(2500)
		while IsPedInAnyVehicle(pPed, false) do
			TaskLeaveAnyVehicle(pPed, 1, 1)
			ShowLoadingMessage("Rangement du véhicule ...", 1, 300)
			Wait(200)
		end
		TriggerEvent('persistent-vehicles/forget-vehicle', pVeh)
	    DeleteEntity(pVeh)
		for k,v in pairs(garageambulancehelico.garageambulancehelico.vehs) do
			if model == GetHashKey(v.veh) then
				garageambulancehelico.garageambulancehelico.vehs[k].stock = garageambulancehelico.garageambulancehelico.vehs[k].stock + 1
			end
		end
	else
		ShowNotification("Vous devez être dans un véhicule.")
	end
end

function LoadModel(model)
	local oldName = model
	local model = GetHashKey(model)
	if IsModelInCdimage(model) then
		RequestModel(model)
		while not HasModelLoaded(model) do Wait(1) end
	else
		ShowNotification("~r~ERREUR: ~s~Modèle inconnu.\nMerci de report le problème au dev. (Modèle: "..oldName.." #"..model..")")
	end
end

function FoundClearSpawnPoint(zones)
	local found = false
	local count = 0
	for k,v in pairs(zones) do
		local clear = IsSpawnPointClear(v.pos, 2.0)
		if clear then
			found = v
			break
		end
	end
	return found
end

function IsSpawnPointClear(coords, radius)
	local vehicles = GetVehiclesInArea(coords, radius)

	return #vehicles == 0
end

function GetVehiclesInArea (coords, area)
	local vehicles       = GetVehicles()
	local vehiclesInArea = {}

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if distance <= area then
			table.insert(vehiclesInArea, vehicles[i])
		end
	end

	return vehiclesInArea
end

function GetVehicles()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end