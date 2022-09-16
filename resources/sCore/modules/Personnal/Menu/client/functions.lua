ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLength)

	AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

function CustomAmount()
    local montant = nil
    AddTextEntry("BANK_CUSTOM_AMOUNT", "Entrez le montant")
    DisplayOnscreenKeyboard(1, "BANK_CUSTOM_AMOUNT", '', "", '', '', '', 15)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        montant = GetOnscreenKeyboardResult()
        Citizen.Wait(1)
    else
        Citizen.Wait(1)
    end
    return tonumber(montant)
end

pedanimals = {
    -- Animaux :
    {label = "Sanglier", model = "a_c_boar"},
    {label = "Chat", model = "a_c_cat_01"},
    {label = "Chimpanzé", model = "a_c_chimp"},
    {label = "Vache", model = "a_c_cow"},
    {label = "Coyote", model = "a_c_coyote"},
    {label = "Biche", model = "a_c_deer"},
    {label = "Poule", model = "a_c_hen"},
    {label = "Husky", model = "a_c_husky"},
    {label = "Lion", model = "a_c_mtlion"},
    {label = "Cochon", model = "a_c_pig"},
    {label = "Caniche", model = "a_c_poodle"},
    {label = "Carlin", model = "a_c_pug"},
    {label = "Lapin", model = "a_c_rabbit_01"},
    {label = "Retriever", model = "a_c_retriever"},
    {label = "Rhésus", model = "a_c_rhesus"},
    {label = "Rottweiler", model = "a_c_chop"},
    {label = "Berger", model = "a_c_shepherd"},
    {label = "Westy", model = "a_c_westy"},
}

pedmale = {
    -- Ambient male :
    {label = "H Acult 1", model = "a_m_m_acult_01"},
    {label = "H Acult 2", model = "a_m_y_acult_01"},
    {label = "H Acult 3", model = "a_m_y_acult_02"},
    {label = "H Afriamer", model = "a_m_m_afriamer_01"},
    {label = "H Beach 1", model = "a_m_m_beach_01"},
    {label = "H Beach 2", model = "a_m_m_beach_02"},
    {label = "H Beach 3", model = "a_m_o_beach_01"},
    {label = "H Beach 4", model = "a_m_y_beach_01"},
    {label = "H Beach 5", model = "a_m_y_beach_02"},
    {label = "H Beach 6", model = "a_m_y_beach_03"},
    {label = "H BevHills 1", model = "a_m_m_bevhills_01"},
    {label = "H BevHills 2", model = "a_m_m_bevhills_02"},
    {label = "H Business", model = "a_m_m_business_01"},
    {label = "H EastSA 1", model = "a_m_m_eastsa_01"},
    {label = "H EastSA 2", model = "a_m_m_eastsa_02"},
    {label = "H EastSA 3", model = "a_m_y_eastsa_01"},
    {label = "H EastSA 4", model = "a_m_y_eastsa_02"},
    {label = "H Farmer", model = "a_m_m_farmer_01"},
    {label = "H FatLatin", model = "a_m_m_fatlatin_01"},
    {label = "H GenFat 1", model = "a_m_m_genfat_01"},
    {label = "H GenFat 2", model = "a_m_m_genfat_02"},
    {label = "H Golfer 1", model = "a_m_m_golfer_01"},
    {label = "H Golfer 2", model = "a_m_y_golfer_01"},
    {label = "H Hasjew 1", model = "a_m_m_hasjew_01"},
    {label = "H Hasjew 2", model = "a_m_y_hasjew_01"},
    {label = "H HillBill 1", model = "a_m_m_hillbilly_01"},
    {label = "H HillBill 2", model = "a_m_m_hillbilly_02"},
    {label = "H Indian 1", model = "a_m_m_indian_01"},
    {label = "H Indian 2", model = "a_m_y_indian_01"},
    {label = "H Ktown 1", model = "a_m_m_ktown_01"},
    {label = "H Ktown 2", model = "a_m_y_ktown_01"},
    {label = "H Ktown 3", model = "a_m_y_ktown_02"},
    {label = "H Malibu", model = "a_m_m_malibu_01"},
    {label = "H MexCntry", model = "a_m_m_mexcntry_01"},
    {label = "H MexLabor", model = "a_m_m_mexlabor_01"},
    {label = "H Paparazzi", model = "a_m_m_paparazzi_01"},
    {label = "H Polynesian 1", model = "a_m_m_polynesian_01"},
    {label = "H Polynesian 2", model = "a_m_y_polynesian_01"},
    {label = "H ProlHost", model = "a_m_m_prolhost_01"},
    {label = "H RunMeth", model = "a_m_m_rurmeth_01"},
    {label = "H Salton 1", model = "a_m_m_salton_01"},
    {label = "H Salton 2", model = "a_m_m_salton_02"},
    {label = "H Salton 3", model = "a_m_m_salton_03"},
    {label = "H Salton 4", model = "a_m_m_salton_04"},
    {label = "H Salton 5", model = "a_m_o_salton_01"},
    {label = "H Salton 6", model = "a_m_y_salton_01"},
    {label = "H Skater 1", model = "a_m_m_skater_01"},
    {label = "H Skater 2", model = "a_m_y_skater_01"},
    {label = "H Skater 3", model = "a_m_y_skater_02"},
    {label = "H Skidrow", model = "a_m_m_skidrow_01"},
    {label = "H SocenLat", model = "a_m_m_socenlat_01"},
    {label = "H Soucent 1", model = "a_m_m_soucent_01"},
    {label = "H Soucent 2", model = "a_m_m_soucent_02"},
    {label = "H Soucent 3", model = "a_m_m_soucent_03"},
    {label = "H Soucent 4", model = "a_m_m_soucent_04"},
    {label = "H Soucent 5", model = "a_m_o_soucent_01"},
    {label = "H Soucent 6", model = "a_m_o_soucent_02"},
    {label = "H Soucent 7", model = "a_m_o_soucent_03"},
    {label = "H Soucent 8", model = "a_m_y_soucent_01"},
    {label = "H Soucent 9", model = "a_m_y_soucent_02"},
    {label = "H Soucent 9", model = "a_m_y_soucent_03"},
    {label = "H Soucent 9", model = "a_m_y_soucent_04"},
    {label = "H Stalt", model = "a_m_m_stlat_02"},
    {label = "H Tennis", model = "a_m_m_tennis_01"},
    {label = "H Tourist", model = "a_m_m_tourist_01"},
    {label = "H Tramp 1", model = "a_m_m_tramp_01"},
    {label = "H Tramp 2", model = "a_m_o_tramp_01"},
    {label = "H TrampBeac", model = "a_m_m_trampbeac_01"},
    {label = "H Tranvest 1", model = "a_m_m_tranvest_01"},
    {label = "H Tranvest 2", model = "a_m_m_tranvest_02"},
    {label = "H Acult 1", model = "a_m_o_acult_01"},
    {label = "H Acult 2", model = "a_m_o_acult_02"},
    {label = "H BeachVesp 1", model = "a_m_y_beachvesp_01"},
    {label = "H BeachVesp 2", model = "a_m_y_beachvesp_02"},
    {label = "H BreakDance", model = "a_m_y_breakdance_01"},
    {label = "H Busicas", model = "a_m_y_busicas_01"},
    {label = "H Business 1", model = "a_m_y_business_01"},
    {label = "H Business 2", model = "a_m_y_business_02"},
    {label = "H Business 3", model = "a_m_y_business_03"},
    {label = "H ClubCust 1", model = "a_m_y_clubcust_01"},
    {label = "H ClubCust 2", model = "a_m_y_clubcust_02"},
    {label = "H ClubCust 3", model = "a_m_y_clubcust_03"},
    {label = "H Cyclist", model = "a_m_y_cyclist_01"},
    {label = "H DHill", model = "a_m_y_dhill_01"},
    {label = "H Downtown", model = "a_m_y_downtown_01"},
    {label = "H Epsilon 1", model = "a_m_y_epsilon_01"},
    {label = "H Epsilon 2", model = "a_m_y_epsilon_02"},
    {label = "H Gay 1", model = "a_m_y_gay_01"},
    {label = "H Gay 2", model = "a_m_y_gay_02"},
    {label = "H Hiker", model = "a_m_y_hiker_01"},
    {label = "H Hippy", model = "a_m_y_hippy_01"},
    {label = "H Hipster 1", model = "a_m_y_hipster_01"},
    {label = "H Hipster 2", model = "a_m_y_hipster_02"},
    {label = "H Hipster 3", model = "a_m_y_hipster_03"},
    {label = "H GenStreet 1", model = "a_m_o_genstreet_01"},
    {label = "H GenStreet 2", model = "a_m_y_genstreet_01"},
    {label = "H GenStreet 3", model = "a_m_y_genstreet_02"},
    {label = "H JetSki", model = "a_m_y_jetski_01"},
    {label = "H Juggalo", model = "a_m_y_juggalo_01"},
    {label = "H Latino", model = "a_m_y_latino_01"},
    {label = "H Meth", model = "a_m_y_methhead_01"},
    {label = "H MexThug", model = "a_m_y_mexthug_01"},
    {label = "H Motox 1", model = "a_m_y_motox_01"},
    {label = "H Motox 2", model = "a_m_y_motox_02"},
    {label = "H MusclBeac 1", model = "a_m_y_musclbeac_01"},
    {label = "H MusclBeac 2", model = "a_m_y_musclbeac_02"},
    {label = "H Polynesian", model = "a_m_y_polynesian_01"},
    {label = "H RoadCyc", model = "a_m_y_roadcyc_01"},
    {label = "H Runner 1", model = "a_m_y_runner_01"},
    {label = "H Runner 2", model = "a_m_y_runner_02"},
    {label = "H STWhi 1", model = "a_m_y_stwhi_01"},
    {label = "H STWhi 2", model = "a_m_y_stwhi_02"},
    {label = "H Sunbathe", model = "a_m_y_sunbathe_01"},
    {label = "H Surfer", model = "a_m_y_surfer_01"},
    {label = "H Vindouche", model = "a_m_y_vindouche_01"},
    {label = "H Vinewood 1", model = "a_m_y_vinewood_01"},
    {label = "H Vinewood 2", model = "a_m_y_vinewood_02"},
    {label = "H Vinewood 3", model = "a_m_y_vinewood_03"},
    {label = "H Vinewood 4", model = "a_m_y_vinewood_04"},
    {label = "H Yoga", model = "a_m_y_yoga_01"},
    {label = "H MLCrisis", model = "a_m_m_mlcrisis_01"},
    {label = "H Gencaspat", model = "a_m_y_gencaspat_01"},
    {label = "H SmartCaspat", model = "a_m_y_smartcaspat_01"},
    {label = "H STBla 1", model = "a_m_y_stbla_01"},
    {label = "H STBla 2", model = "a_m_y_stbla_02"},
    {label = "H STLat", model = "a_m_y_stlat_01"},

    -- Gang male :
    {label = "H ImportExport", model = "g_m_importexport_01"},
    {label = "H ArmBoss", model = "g_m_m_armboss_01"},
    {label = "H ArmGon", model = "g_m_m_armgoon_01"},
    {label = "H Armlieut", model = "g_m_m_armlieut_01"},
    {label = "H Chemwork", model = "g_m_m_chemwork_01"},
    {label = "H Chicold", model = "g_m_m_chicold_01"},
    {label = "H Chigoon 1", model = "g_m_m_chigoon_01"},
    {label = "H Chigoon 2", model = "g_m_m_chigoon_02"},
    {label = "H KorBoss", model = "g_m_m_korboss_01"},
    {label = "H MexBoss 1", model = "g_m_m_mexboss_01"},
    {label = "H MexBoss 2", model = "g_m_m_mexboss_02"},
    {label = "H ArmGoon", model = "g_m_y_armgoon_02"},
    {label = "H Aztecas 1", model = "g_m_y_azteca_01"},
    {label = "H Aztecas 2", model = "g_m_y_salvagoon_01"},
    {label = "H Aztecas 3", model = "g_m_y_salvagoon_02"},
    {label = "H Aztecas 4", model = "ig_ortega"},
    {label = "H Aztecas 5", model = "csb_oscar"},
    {label = "H Ballas 1", model = "g_m_y_ballaeast_01"},
    {label = "H Ballas 2", model = "g_m_y_ballaorig_01"},
    {label = "H Ballas 3", model = "g_m_y_ballasout_01"},
    {label = "H Ballas 4", model = "ig_ballasog"},
    {label = "H Families 1", model = "g_m_y_famca_01"},
    {label = "H Families 2", model = "g_m_y_famdnf_01"},
    {label = "H Families 3", model = "g_m_y_famfor_01"},
    {label = "H Families 4", model = "csb_g"},
    {label = "H Families 5", model = "ig_lamardavis"},
    {label = "H Korean 1", model = "g_m_y_korean_01"},
    {label = "H Korean 2", model = "g_m_y_korean_02"},
    {label = "H Korean 3", model = "g_m_y_korlieut_01"},
    {label = "H Lost 1", model = "g_m_y_lost_01"},
    {label = "H Lost 2", model = "g_m_y_lost_02"},
    {label = "H Lost 3", model = "g_m_y_lost_03"},
    {label = "H MexGang", model = "g_m_y_mexgang_01"},
    {label = "H MexGon 1", model = "g_m_y_mexgoon_01"},
    {label = "H MexGon 2", model = "g_m_y_mexgoon_02"},
    {label = "H MexGon 3", model = "g_m_y_mexgoon_03"},
    {label = "H VagFun", model = "mp_m_g_vagfun_01"},
    {label = "H VagSpeak", model = "ig_vagspeak"},
    {label = "H Pologoon 1", model = "g_m_y_pologoon_01"},
    {label = "H Pologoon 2", model = "g_m_y_pologoon_02"},
    {label = "MexThug", model = "a_m_y_mexthug_01"},
    {label = "H SalvaBoss", model = "g_m_y_salvaboss_01"},
    {label = "H CasRN", model = "g_m_m_casrn_01"},
    {label = "H Madrazo", model = "u_m_m_partytarget"},
    {label = "H Hao", model = "ig_hao"},
    {label = "H ChengSR", model = "ig_chengsr"},
    {label = "H Old man 1", model = "ig_old_man1a"},
    {label = "H Old man 2", model = "ig_old_man2"},
    {label = "H Omega", model = "ig_omega"},
    {label = "H O'neil", model = "ig_oneil"},
}

pedfemale = {
    -- Ambient Female :
    {label = "F Beach 1", model = "a_f_m_beach_01"},
    {label = "F Beach 2", model = "a_f_y_beach_01"},
    {label = "F Topless", model = "a_f_y_topless_01"},
    {label = "F BodyBuild", model = "a_f_m_bodybuild_01"},
    {label = "F FatCult", model = "a_f_m_fatcult_01"},
    {label = "F BayWatch", model = "s_f_y_baywatch_01"},
    {label = "F BevHills 1", model = "a_f_m_bevhills_01"},
    {label = "F BevHills 2", model = "a_f_m_bevhills_02"},
    {label = "F BevHills 3", model = "a_f_y_bevhills_01"},
    {label = "F BevHills 4", model = "a_f_y_bevhills_02"},
    {label = "F BevHills 5", model = "a_f_y_bevhills_03"},
    {label = "F BevHills 6", model = "a_f_y_bevhills_04"},
    {label = "F Downtown", model = "a_f_m_downtown_01"},
    {label = "F EastSa 1", model = "a_f_m_eastsa_01"},
    {label = "F EastSa 2", model = "a_f_m_eastsa_02"},
    {label = "F EastSa 3", model = "a_f_y_eastsa_01"},
    {label = "F EastSa 4", model = "a_f_y_eastsa_02"},
    {label = "F EastSa 5", model = "a_f_y_eastsa_03"},
    {label = "F Fatbla", model = "a_f_m_fatbla_01"},
    {label = "F FatWhite", model = "a_f_m_fatwhite_01"},
    {label = "F Ktown 1", model = "a_f_m_ktown_01"},
    {label = "F Ktown 2", model = "a_f_m_ktown_02"},
    {label = "F Ktown 3", model = "a_f_o_ktown_01"},
    {label = "F Prolhos", model = "a_f_m_prolhost_01"},
    {label = "F Salton 1", model = "a_f_m_salton_01"},
    {label = "F Salton 2", model = "a_f_o_salton_01"},
    {label = "F Skidrow", model = "a_f_m_skidrow_01"},
    {label = "F Soucent 1", model = "a_f_m_soucent_01"},
    {label = "F Soucent 2", model = "a_f_m_soucent_02"},
    {label = "F Soucent 3", model = "a_f_o_soucent_01"},
    {label = "F Soucent 4", model = "a_f_o_soucent_02"},
    {label = "F Soucent 5", model = "a_f_y_soucent_01"},
    {label = "F Soucent 6", model = "a_f_y_soucent_02"},
    {label = "F Soucent 7", model = "a_f_y_soucent_03"},
    {label = "F SoucentMC", model = "a_f_m_soucentmc_01"},
    {label = "F Tourist 1", model = "a_f_m_tourist_01"},
    {label = "F Tourist 2", model = "a_f_y_tourist_01"},
    {label = "F Tourist 3", model = "a_f_y_tourist_02"},
    {label = "F Tramp", model = "a_f_m_tramp_01"},
    {label = "F TrampBeac", model = "a_f_m_trampbeac_01"},
    {label = "F GenStreet", model = "a_f_o_genstreet_01"},
    {label = "F Indian 1", model = "a_f_o_indian_01"},
    {label = "F Indian 2", model = "a_f_y_indian_01"},
    {label = "F Busines 1", model = "a_f_y_business_01"},
    {label = "F Busines 2", model = "a_f_y_business_02"},
    {label = "F Busines 3", model = "a_f_y_business_03"},
    {label = "F Busines 4", model = "a_f_y_business_04"},
    {label = "F ClubCust 1", model = "a_f_y_clubcust_01"},
    {label = "F ClubCust 2", model = "a_f_y_clubcust_02"},
    {label = "F ClubCust 3", model = "a_f_y_clubcust_03"},
    {label = "F Epsilon", model = "a_f_y_epsilon_01"},
    {label = "F Agent", model = "a_f_y_femaleagent"},
    {label = "F Fitness 1", model = "a_f_y_fitness_01"},
    {label = "F Fitness 2", model = "a_f_y_fitness_02"},
    {label = "F GenShot", model = "a_f_y_genhot_01"},
    {label = "F Golfer", model = "a_f_y_golfer_01"},
    {label = "F Hiker", model = "a_f_y_hiker_01"},
    {label = "F Hippie", model = "a_f_y_hippie_01"},
    {label = "F Hipster 1", model = "a_f_y_hipster_01"},
    {label = "F Hipster 2", model = "a_f_y_hipster_02"},
    {label = "F Hipster 3", model = "a_f_y_hipster_03"},
    {label = "F Hipster 4", model = "a_f_y_hipster_04"},
    {label = "F Juggalo", model = "a_f_y_juggalo_01"},
    {label = "F Runner", model = "a_f_y_runner_01"},
    {label = "F RurMeth", model = "a_f_y_rurmeth_01"},
    {label = "F ScDress", model = "a_f_y_scdressy_01"},
    {label = "F Skater", model = "a_f_y_skater_01"},
    {label = "F Vinewood 1", model = "a_f_y_vinewood_01"},
    {label = "F Vinewood 2", model = "a_f_y_vinewood_02"},
    {label = "F Vinewood 3", model = "a_f_y_vinewood_03"},
    {label = "F Vinewood 4", model = "a_f_y_vinewood_04"},
    {label = "F Yoga", model = "a_f_y_yoga_01"},
    {label = "F GenCasp", model = "a_f_y_gencaspat_01"},
    {label = "F SmartCaspat", model = "a_f_y_smartcaspat_01"},

    -- Gang Female:
    {label = "Femme Vagos", model = "g_f_y_vagos_01"},
    {label = "Femme Lost", model = "g_f_y_lost_01"},
    {label = "Femme Families", model = "g_f_y_families_01"},
    {label = "Femme Ballas", model = "g_f_y_ballas_01"},
    {label = "Femme Latino", model = "g_f_importexport_01"},
}

pedall = {
    -- Cutscene :
    {label = "F Amanda", model = "g_m_importexport_01"},
    {label = "H Andreas", model = "g_m_m_armboss_01"},
    {label = "H ArmGon", model = "g_m_m_armgoon_01"},
    {label = "H Armlieut", model = "g_m_m_armlieut_01"},
    {label = "H Chemwork", model = "g_m_m_chemwork_01"},
    {label = "H Chicold", model = "g_m_m_chicold_01"},
    {label = "H Chigoon 1", model = "g_m_m_chigoon_01"},
    {label = "H Chigoon 2", model = "g_m_m_chigoon_02"},
    {label = "H KorBoss", model = "g_m_m_korboss_01"},
    {label = "H MexBoss 1", model = "g_m_m_mexboss_01"},
    {label = "H MexBoss 2", model = "g_m_m_mexboss_02"},
    {label = "H ArmGoon", model = "g_m_y_armgoon_02"},
    {label = "H Aztecas 1", model = "g_m_y_azteca_01"},
    {label = "H Aztecas 2", model = "g_m_y_salvagoon_01"},
    {label = "H Aztecas 3", model = "g_m_y_salvagoon_02"},
    {label = "H Aztecas 4", model = "ig_ortega"},
    {label = "H Aztecas 5", model = "csb_oscar"},
    {label = "H Ballas 1", model = "g_m_y_ballaeast_01"},
    {label = "H Ballas 2", model = "g_m_y_ballaorig_01"},
    {label = "H Ballas 3", model = "g_m_y_ballasout_01"},
    {label = "H Ballas 4", model = "ig_ballasog"},
    {label = "H Families 1", model = "g_m_y_famca_01"},
    {label = "H Families 2", model = "g_m_y_famdnf_01"},
    {label = "H Families 3", model = "g_m_y_famfor_01"},
    {label = "H Families 4", model = "csb_g"},
    {label = "H Families 5", model = "ig_lamardavis"},
    {label = "H Korean 1", model = "g_m_y_korean_01"},
    {label = "H Korean 2", model = "g_m_y_korean_02"},
    {label = "H Korean 3", model = "g_m_y_korlieut_01"},
    {label = "H Lost 1", model = "g_m_y_lost_01"},
    {label = "H Lost 2", model = "g_m_y_lost_02"},
    {label = "H Lost 3", model = "g_m_y_lost_03"},
    {label = "H MexGang", model = "g_m_y_mexgang_01"},
    {label = "H MexGon 1", model = "g_m_y_mexgoon_01"},
    {label = "H MexGon 2", model = "g_m_y_mexgoon_02"},
    {label = "H MexGon 3", model = "g_m_y_mexgoon_03"},
    {label = "H VagFun", model = "mp_m_g_vagfun_01"},
    {label = "H VagSpeak", model = "ig_vagspeak"},
    {label = "H Pologoon 1", model = "g_m_y_pologoon_01"},
    {label = "H Pologoon 2", model = "g_m_y_pologoon_02"},
    {label = "MexThug", model = "a_m_y_mexthug_01"},
    {label = "H SalvaBoss", model = "g_m_y_salvaboss_01"},
    {label = "H CasRN", model = "g_m_m_casrn_01"},
    {label = "H Madrazo", model = "u_m_m_partytarget"},
    {label = "H Hao", model = "ig_hao"},
    {label = "H ChengSR", model = "ig_chengsr"},
    {label = "H Old man 1", model = "ig_old_man1a"},
    {label = "H Old man 2", model = "ig_old_man2"},
    {label = "H Omega", model = "ig_omega"},
    {label = "H O'neil", model = "ig_oneil"}

    -- Multiplayer :

}

RegisterNetEvent('jMenu:requestClothes')
AddEventHandler('jMenu:requestClothes', function(clothesType)
    if clothesType == "haut" then
        ESX.TriggerServerCallback('Sneakyesx_skin:getPlayerSkin', function(skina)
            TriggerEvent('Sneakyskinchanger:getSkin', function(skinb)
                local lib, anim = 'clothingtie', 'try_tie_neutral_a'
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                end)
                Citizen.Wait(1000)
                ClearPedTasks(PlayerPedId())
    
                if skina.torso_1 ~= skinb.torso_1 then
                    vethaut = true
                    TriggerEvent('Sneakyskinchanger:loadClothes', skinb, {['torso_1'] = skina.torso_1, ['torso_2'] = skina.torso_2, ['tshirt_1'] = skina.tshirt_1, ['tshirt_2'] = skina.tshirt_2, ['arms'] = skina.arms})
                else
                    TriggerEvent('Sneakyskinchanger:loadClothes', skinb, {['torso_1'] = 15, ['torso_2'] = 0, ['tshirt_1'] = 15, ['tshirt_2'] = 0, ['arms'] = 15})
                    vethaut = false
                end
    
            end)
        end)    
    elseif clothesType == "bas" then
        ESX.TriggerServerCallback('Sneakyesx_skin:getPlayerSkin', function(skina)
            TriggerEvent('Sneakyskinchanger:getSkin', function(skinb)
                local lib, anim = 'clothingtrousers', 'try_trousers_neutral_c'
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                end)
                Citizen.Wait(1000)
                ClearPedTasks(PlayerPedId())
    
                if skina.pants_1 ~= skinb.pants_1 then
                    TriggerEvent('Sneakyskinchanger:loadClothes', skinb, {['pants_1'] = skina.pants_1, ['pants_2'] = skina.pants_2})
                    vetbas = true
                else
                    vetbas = false
                    if skina.sex == 1 then
                        TriggerEvent('Sneakyskinchanger:loadClothes', skinb, {['pants_1'] = 15, ['pants_2'] = 0})
                    else
                        TriggerEvent('Sneakyskinchanger:loadClothes', skinb, {['pants_1'] = 14, ['pants_2'] = 0})
                    end
                end
            end)
        end)
    elseif clothesType == "chaussures" then
        ESX.TriggerServerCallback('Sneakyesx_skin:getPlayerSkin', function(skina)
            TriggerEvent('Sneakyskinchanger:getSkin', function(skinb)
                local lib, anim = 'clothingshoes', 'try_shoes_positive_a'
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                end)
                Citizen.Wait(1000)
                ClearPedTasks(PlayerPedId())
    
                if skina.shoes_1 ~= skinb.shoes_1 then
                    TriggerEvent('Sneakyskinchanger:loadClothes', skinb, {['shoes_1'] = skina.shoes_1, ['shoes_2'] = skina.shoes_2})
                    vetch = true
                else
                    vetch = false
                    if skina.sex == 1 then
                        TriggerEvent('Sneakyskinchanger:loadClothes', skinb, {['shoes_1'] = 41, ['shoes_2'] = 0})
                    else
                        TriggerEvent('Sneakyskinchanger:loadClothes', skinb, {['shoes_1'] = 43, ['shoes_2'] = 0})
                    end
                end
            end)
        end)
    elseif clothesType == "sac" then
        ESX.TriggerServerCallback('Sneakyesx_skin:getPlayerSkin', function(skina)
            TriggerEvent('Sneakyskinchanger:getSkin', function(skinb)
                local lib, anim = 'clothingtie', 'try_tie_neutral_a'
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                end)
                Citizen.Wait(1000)
                ClearPedTasks(PlayerPedId())
    
                if skina.bags_1 ~= skinb.bags_1 then
                    TriggerEvent('Sneakyskinchanger:loadClothes', skinb, {['bags_1'] = skina.bags_1, ['bags_2'] = skina.bags_2})
                    vetsac = true
                else
                    TriggerEvent('Sneakyskinchanger:loadClothes', skinb, {['bags_1'] = 0, ['bags_2'] = 0})
                    vetsac = false
                end
            end)
        end)    
    elseif clothesType == "gilet" then
        ESX.TriggerServerCallback('Sneakyesx_skin:getPlayerSkin', function(skina)
            TriggerEvent('Sneakyskinchanger:getSkin', function(skinb)
                local lib, anim = 'clothingtie', 'try_tie_neutral_a'
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                end)
                Citizen.Wait(1000)
                ClearPedTasks(PlayerPedId())
    
                if skina.bproof_1 ~= skinb.bproof_1 then
                    TriggerEvent('Sneakyskinchanger:loadClothes', skinb, {['bproof_1'] = skina.bproof_1, ['bproof_2'] = skina.bproof_2})
                    vetgilet = true
                else
                    TriggerEvent('Sneakyskinchanger:loadClothes', skinb, {['bproof_1'] = 0, ['bproof_2'] = 0})
                    vetgilet = false
                end
            end)
        end)    
    end
end)
