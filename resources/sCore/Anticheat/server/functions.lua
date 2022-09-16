ESX = nil
TriggerEvent('Sneakyesx:getSharedObject', function(obj) ESX = obj end)

GetIdentifiersServer = function(source)
    local identifiers = {}
    local playerIdentifiers = GetPlayerIdentifiers(source)
    for _, v in pairs(playerIdentifiers) do
        local before, after = playerIdentifiers[_]:match("([^:]+):([^:]+)")
        identifiers[before] = playerIdentifiers[_]
    end
    return identifiers
end

sendLogs = function(webhook, title, message)
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        username = "Sneaky AC - Log", 
        embeds = {{
            ["title"] = title,
            ["description"] = "".. message .."",
            ["footer"] = {
                ["text"] = "Sneaky AC • "..os.date("%x %X %p"),
            },
        }}, 
    }), { 
        ['Content-Type'] = 'application/json' 
    })
end


HaveWeaponInLoadout = function(xPlayer, weapon)
    for i, v in pairs(xPlayer.loadout) do
        if (GetHashKey(v.name) == weapon) then
            return true;
        end
    end
    return false;
end

GetBannerTimer = function(seconds)
	local days = seconds / 86400
	local hours = (days - math.floor(days)) * 24
	local minutes = (hours - math.floor(hours)) * 60
	seconds = (minutes - math.floor(minutes)) * 60
	return ('%s jours %s heures %s minutes %s secondes'):format(math.floor(days), math.floor(hours), math.floor(minutes), math.floor(seconds))
end

sendLogsAC = function(source, execution)
    local license, licenseid = GetIdentifiersServer(source)["license"]:match("([^:]+):([^:]+)")
    if webhooksAC[execution.name] ~= nil then sendLogs(webhooksAC[execution.name], execution.title, execution.description.."\nNom : "..GetPlayerName(source).."\nLicense : "..licenseid) end
end 
function banPlayerAC(source, execution)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer ~= "user" then
        return
    end
	if GetIdentifiersServer(source) == nil or GetIdentifiersServer(source)["license"] == nil then return end
    local license, licenseid = GetIdentifiersServer(source)["license"]:match("([^:]+):([^:]+)")
    if webhooksAC[execution.name] ~= nil then sendLogs(webhooksAC[execution.name], execution.title, execution.description.."\nNom : "..GetPlayerName(source).."\nLicense : "..licenseid) end
    TriggerEvent('Initiate:BanSql', GetIdentifiersServer(source)["license"], source, execution.title, "Anticheat", 0, 1)
end

PropsList = {
    PropsWhitelisted = {
        "prop_gas_pump_1a",
        "prop_cs_hand_radio",
        "prop_worklight_01a",
        "prop_roadcone02a",
        "prop_barrier_work05",
        "prop_gazebo_02",
        "bkr_prop_coke_fullscoop_01a",
        "bkr_prop_coke_box_01a",
        "bkr_prop_meth_sacid",
        "bkr_prop_fakeid_clipboard_01a",
        "bkr_prop_fakeid_penclipboard",
        "prop_boxing_glove_01",
        "xm_prop_body_bag",
        "xm_prop_smug_crate_s_medical",
        "xm_prop_x17_bag_med_01a",
        "prop_cs_burger_01",
        "prop_food_chips",
        "prop_ecola_can",
        "ng_proc_sodabot_01a",
        "ng_proc_sodacan_01b",
        "prop_ld_flow_bottle",
        "v_ret_247_bread1",
        "v_ilev_gb_vauldr",
        "v_ilev_gb_vaubar",
        "v_ilev_gb_teldr",
        "p_ld_id_card_01",
        "hei_prop_hei_cash_trolly_01",
        "hei_prop_hei_cash_trolly_03",
        "hei_prop_heist_cash_pile",
        "hei_prop_hei_cash_trolly_03",
        "hei_p_m_bag_var22_arm_s",
        "vw_prop_vw_luckywheel_02a",
        "vw_prop_vw_luckywheel_01a",
        "vw_prop_vw_jackpot_on",
        "vw_prop_vw_casino_podium_01a",
        "vw_prop_vw_coin_01a",
        "vw_prop_chip_10dollar_x1",
        "vw_prop_chip_50dollar_x1",
        "vw_prop_chip_100dollar_x1",
        "vw_prop_chip_500dollar_x1",
        "vw_prop_chip_1kdollar_x1",
        "vw_prop_plaq_10kdollar_x1",
        "vw_prop_vw_chips_pile_01a",
        "vw_prop_vw_chips_pile_02a",
        "vw_prop_vw_chips_pile_03a",
        "vw_prop_casino_roulette_01",
        "vw_prop_roulette_ball",
        "ba_prop_battle_glowstick_01",
        "ba_prop_battle_hobby_horse",
        "p_amb_brolly_01",
        "prop_notepad_01",
        "prop_pencil_01",
        "hei_prop_heist_box",
        "prop_single_rose",
        "hei_heist_sh_bong_01",
        "prop_police_id_board",
        "prop_drink_whisky",
        "prop_amb_beer_bottle",
        "prop_plastic_cup_02",
        "prop_drink_redwine",
        "prop_champ_flute",
        "prop_drink_champ",
        "prop_acc_guitar_01",
        "prop_el_guitar_01",
        "prop_el_guitar_03",
        "prop_novel_01",
        "prop_snow_flower_02",
        "v_ilev_mr_rasberryclean",
        "p_michael_backpack_s",
        "p_amb_clipboard_01",
        "prop_tourist_map_01",
        "prop_beggers_sign_03",
        "prop_anim_cash_pile_01",
        "prop_pap_camera_01",
        "ba_prop_battle_champ_open",
        "prop_cs_tablet",
        "prop_npc_phone_02",
        "prop_sponge_01",
        "vw_prop_casino_slot_01a",
        "vw_prop_casino_slot_01a_reels",
        "vw_prop_casino_slot_01b_reels",
        "vw_prop_casino_slot_02a",
        "vw_prop_casino_slot_02a_reels",
        "vw_prop_casino_slot_02b_reels",
        "vw_prop_casino_slot_03a",
        "vw_prop_casino_slot_03a_reels",
        "vw_prop_casino_slot_03b_reels",
        "vw_prop_casino_slot_04a",
        "vw_prop_casino_slot_04a_reels",
        "vw_prop_casino_slot_04b_reels",
        "vw_prop_casino_slot_05a",
        "vw_prop_casino_slot_05a_reels",
        "vw_prop_casino_slot_05b_reels",
        "vw_prop_casino_slot_06a",
        "vw_prop_casino_slot_06a_reels",
        "vw_prop_casino_slot_06b_reels",
        "vw_prop_casino_slot_07a",
        "vw_prop_casino_slot_07a_reels",
        "vw_prop_casino_slot_07b_reels",
        "vw_prop_casino_slot_08a",
        "vw_prop_casino_slot_08a_reels",
        "vw_prop_casino_slot_08b_reels",
        "prop_cs_heist_bag_02",
        "hei_prop_heist_drill",
        "hei_p_m_bag_var22_arm_s",
        "prop_v_m_phone_01",
        "prop_weed_02",
        "prop_weed_block_01",
        "prop_coke_block_half_b",
        "p_meth_bag_01_s",
        "prop_smug_crate_s_medical",
        "prop_chair_08",
        "prop_dock_bouy_1",
        "prop_road_memorial_02",
        "prop_barrier_work06a",
        "v_club_vu_deckcase",
        "prop_studio_light_01",
        "prop_offroad_bale03",
        "prop_offroad_bale02",
        "prop_runlight_r",
        "bkr_prop_weed_chair_01a",
        "prop_gun_case_01",
        "bkr_prop_meth_pseudoephedrine",
        "bkr_prop_meth_openbag_01a",
        "bkr_prop_meth_bigbag_04a",
        "bkr_prop_weed_bigbag_03a",
        "bkr_prop_weed_01_small_01a",
        "bkr_prop_weed_dry_02b",
        "prop_sol_chair",
        "bkr_prop_weed_table_01a",
        "hei_prop_cash_crate_half_full",
        "prop_cash_case_02",
        "prop_cash_crate_01",
        "prop_cs_dumpster_01a",
        "v_tre_sofa_mess_c_s",
        "v_res_tre_sofa_mess_a",
        "bkr_prop_bkr_cashpile_04",
        "bkr_prop_bkr_cashpile_05",
        "bkr_prop_coke_block_01a",
        "bkr_prop_coke_bottle_01a",
        "bkr_prop_coke_cut_01",
        "bkr_prop_coke_fullmetalbowl_02",
        "bkr_prop_coke_block_01a",
        "bkr_prop_coke_block_01a",
        "bkr_prop_coke_pallet_01a",
        "bkr_prop_coke_scale_01",
        "bkr_prop_coke_spatula_04",
        "bkr_prop_coke_table01a",
        "bkr_prop_crate_set_01a",
        "bkr_prop_fertiliser_pallet_01a",
        "bkr_prop_fertiliser_pallet_01b",
        "bkr_prop_fertiliser_pallet_01c",
        "bkr_prop_fertiliser_pallet_01d",
        "bkr_prop_meth_acetone",
        "bkr_prop_meth_ammonia",
        "bkr_prop_meth_bigbag_01a",
        "bkr_prop_meth_bigbag_02a",
        "bkr_prop_meth_bigbag_03a",
        "bkr_prop_meth_lithium",
        "bkr_prop_meth_phosphorus",
        "bkr_prop_weed_bigbag_open_01a",
        "bkr_prop_weed_bucket_01d",
        "bkr_prop_weed_drying_01a",
        "hei_prop_heist_weed_pallet",
        "imp_prop_impexp_boxcoke_01",
        "bkr_prop_biker_gcase_s",
        "ex_office_swag_guns04",
        "ex_prop_crate_ammo_bc",
        "ex_prop_crate_ammo_sc",
        "ex_prop_adv_case_sm_03",
        "ex_prop_adv_case_sm_flash",
        "ex_prop_crate_expl_bc",
        "ex_prop_crate_expl_sc",
        "gr_prop_gr_crate_mag_01a",
        "gr_prop_gr_crates_rifles_01a",
        "gr_prop_gr_crates_weapon_mix_01a",
        "prop_table_04",
        "xm_v_club_roc_micstd",
        "prop_speaker_07",
        "prop_table_para_comb_05",
        "bkr_prop_meth_smashedtray_01",
        "bkr_prop_money_counter",
        "bkr_prop_weed_01_small_01b",
        "bkr_prop_weed_lrg_01b",
        "bkr_prop_weed_med_01b",
        "apa_mp_h_din_chair_12",
        "prop_cs_trolley_01",
        "prop_cardbordbox_04a",
        "prop_carcreeper",
        "apa_mp_h_din_table_06",
        "bkr_prop_clubhouse_chair_01",
        "bkr_prop_clubhouse_laptop_01a",
        "bkr_prop_clubhouse_offchair_01a",
        "gr_prop_bunker_bed_01",
        "gr_prop_gr_campbed_01",
        "hei_prop_hei_skid_chair",
        "p_parachute1_mp_s",
        "p_syringe_01_s",
        "v_ilev_fos_mic",
        "prop_tri_start_banner",
        "prop_tv_cam_02",
        "prop_barier_conc_05c",
        "v_med_bed2",
        "prop_carjack",
        "prop_cs_spray_can",
        "bkr_prop_coke_bakingsoda_o",
        "prop_cs_credit_card",
        "bkr_prop_coke_doll",
        "bkr_prop_coke_boxedDoll",
        "bkr_prop_coke_dollCast",
        "bkr_prop_coke_dollmould",
        "bkr_prop_coke_press_01b",
        "bkr_prop_coke_dollboxfolded",
        "bkr_prop_meth_openbag_02",
        "bkr_prop_meth_scoop_01a",
        "bkr_prop_weed_dry_01a",
        "bkr_prop_weed_leaf_01a",
        "bkr_prop_weed_bag_01a",
        "bkr_prop_weed_bud_02b",
        "bkr_prop_weed_bud_02a",
        "bkr_prop_weed_bag_pile_01a",
        "bkr_prop_weed_bucket_open_01a",
        "prop_wheelchair_01",
        "v_med_emptybed",
        "v_med_bed2",
        "prop_sacktruck_02b",
        "prop_cs_cardbox_01",
        "prop_cardbordbox_02a",
        "prop_tool_pickaxe",
        "csx_rvrbldr_meda_",
        "csx_rvrbldr_medb_",
        "csx_rvrbldr_medc_",
        "csx_rvrbldr_medd_",
        "csx_rvrbldr_mede_",
        "csx_rvrbldr_smla_",
        "csx_rvrbldr_smlb_",
        "csx_rvrbldr_smlc_",
        "csx_rvrbldr_smld_",
        "csx_rvrbldr_smle_",
        "prop_golfflag",
        "prop_golf_bag_01b",
        "prop_golf_tee",
        "prop_golf_marker_01",
        "prop_golf_iron_01",
        "prop_golf_wood_01",
        "prop_golf_putter_01",
        "prop_golf_ball",
        "prop_golf_ball_p2",
        "prop_golf_ball_p3",
        "prop_golf_ball_p4",
        "prop_kitch_pot_lrg",
        "prop_ld_shovel",
        "prop_dock_float_1b",
        "prop_fishing_rod_01",
        "prop_poly_bag_01",
        "prop_till_01",
        "prop_till_01_dam",
        "prop_bong_01",
        "prop_bong_02",
        "prop_sh_bong_01",
        "hei_heist_sh_bong_01",
        "p_wine_glass_s",
        "prop_drink_champ",
        "prop_drink_redwine",
        "prop_drink_whtwine",
        "prop_drink_whisky",
        "prop_whiskey_01",
        "p_whiskey_bottle_s",
        "prop_whiskey_bottle",
        "p_whiskey_notop_empty",
        "prop_cs_whiskey_bottle",
        "p_w_grass_gls_s",
        "prop_wheat_grass_glass",
        "prop_wheat_grass_half",
        "prop_tool_box_02",
        "prop_tool_box_04",
        "prop_cs_wrench",
        "prop_binoc_01",
        "p_parachute_s",
        "p_parachute_s_shop",
        "pil_p_para_bag_pilot_s",
        "p_ld_stinger_s",
    }
}

checkWhitelistProps = function(props)
    for a,b in pairs(PropsList.PropsWhitelisted) do 
        if props == GetHashKey(b) then 
            return true 
        end
    end
end

AddEventHandler('entityCreating', function(entity) 
    local entity_model = GetEntityModel(entity) 
    local check_props = checkWhitelistProps(entity_model) 

    if GetEntityType(entity) == 3 then 
        if not check_props then 
            CancelEvent()
        end
    end
end)