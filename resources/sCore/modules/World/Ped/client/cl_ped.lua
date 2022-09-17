ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
end)
local coordonate = {
  {330.79385375977,-570.380859375,28.810031890869-1.0, "sécurité", 161.17, "", "cs_josef", "",  scenario = nil, lib = nil, anim = nil},
  {305.0498046875,-598.29693603516,43.292797088623-1.0, "docteur", 71.72, "", "s_f_y_scrubs_01", "",   scenario = nil, lib = nil, anim = nil},
  {1822.0568847656,3688.0224609375,34.224430084229-1.0, "docteur sandyshores", 30.567, "", "s_f_y_scrubs_01", "",   scenario = nil, lib = nil, anim = nil},
  {1859.6735839844,3654.9694824219,35.641689300537-1.0, "docteur sandyshores hélico", 296.02, "", "s_f_y_scrubs_01", "",   scenario = nil, lib = nil, anim = nil},
  {1822.5372314453,3680.7993164062,34.277305603027-1.0, "docteur sandyshores patient", 215.155, "", "s_f_y_scrubs_01", "",   scenario = nil, lib = nil, anim = nil},
  {-1097.0129394531,-818.44134521484,19.036159515381-1.0, "cop", 298.72, "", "s_f_y_cop_01", "",   scenario = nil, lib = nil, anim = nil},
  {-1067.2030029297,-847.67364501953,5.0429563522339-1.0, "cop", 213.84, "", "s_m_y_cop_01", "",   scenario = nil, lib = nil, anim = nil},
  {-1072.5059814453,-831.19451904297,5.4797034263611-1.0, "cop", 305.67, "", "s_m_y_cop_01", "",   scenario = nil, lib = nil, anim = nil},
  {-1107.6418457031,-840.89080810547,26.986713409424-1.0, "sport", 117.90, "", "a_m_y_runner_01", "",   scenario = nil, lib = nil, anim = nil},
  {-1104.8623046875,-844.39398193359,26.984954833984-1.0, "grosse cochone", 119.58, "", "ig_maude", "",   scenario = nil, lib = nil, anim = nil},
  {-1063.6392822266,-819.17352294922,27.033557891846-1.0, "grosse chienne", 117.57, "", "a_c_rottweiler", "",   scenario = nil, lib = nil, anim = nil},
  {-1100.0633544922,-824.93688964844,14.282784461975-1.0, "cop", 215.59, "", "s_f_y_cop_01", "",   scenario = nil, lib = nil, anim = nil},
  {-1107.7092285156,-824.36987304688,14.282787322998-1.0, "cop", 246.20, "", "s_m_y_cop_01", "",   scenario = nil, lib = nil, anim = nil},
  {-1094.7222900391,-830.21899414062,10.276346206665-1.0, "scientifique", 127.74, "", "s_m_m_scientist_01", "",   scenario = nil, lib = nil, anim = nil},
  {-1086.091796875,-828.98944091797,5.4796848297119-1.0, "cop", 210.89, "", "s_m_y_cop_01", "",   scenario = nil, lib = nil, anim = nil},
  {-1096.3699951172,-824.71356201172,5.4797368049622-1.0, "prisonier", 310.75, "", "ig_rashcosvki", "",   scenario = nil, lib = nil, anim = nil},
  {-1113.8161621094,-826.056640625,19.316879272461-1.0, "cop", 37.47, "", "s_m_y_cop_01", "",   scenario = nil, lib = nil, anim = nil},
  {-1092.0308837891,-839.24310302734,37.700634002686-1.0, "cophelico", 127.298, "", "s_m_y_cop_01", "",   scenario = nil, lib = nil, anim = nil},
  {472.63641357422, -996.20074462891, 30.689764022827-1.0, "swat", 293.71, "", "s_m_y_swat_01", "",   scenario = nil, lib = nil, anim = nil},
  {486.73971557617, -992.72326660156, 30.689764022827-1.0, "doc", 199.95, "", "s_m_m_scientist_01", "",   scenario = nil, lib = nil, anim = nil},
  {485.84509277344, -987.94445800781, 30.689750671387-1.0, "doc", 120.65, "", "s_m_m_scientist_01", "",   scenario = nil, lib = nil, anim = nil},
  {478.77597045898, -980.32086181641, 30.747953414917-1.0, "douche", 203.87, "", "a_f_y_topless_01", "",   scenario = nil, lib = nil, anim = nil},
  {323.19958496094,-568.25579833984,43.281585693359-1.0, "doc blouse", 235.21, "", "s_f_y_scrubs_01", "",   scenario = nil, lib = nil, anim = nil},
  {337.84136962891,-586.99761962891,74.165649414062-1.0, "sécurité hélico", 255.196, "", "s_m_m_security_01", "",   scenario = nil, lib = nil, anim = nil},
  {-190.91947937012,-1309.4466552734,31.296104431152-1.0, "mecano", 5.46, "", "ig_benny", "",   scenario = nil, lib = nil, anim = nil},
  {-193.67718505859,-1294.5738525391,31.295980453491-1.0, "bennys", 179.24, "", "u_m_y_smugmech_01", "",   scenario = nil, lib = nil, anim = nil},
  {-1459.3381347656,-413.54287719727,35.750816345215-1.0, "pawnshop", 167.95, "", "ig_mrk", "",   scenario = nil, lib = nil, anim = nil},
  {241.2,-1378.91,33.74-1.0, "auto ecole", 141.54, "", "a_f_y_business_01", "",   scenario = nil}, lib = nil, anim = nil,
  {22.62,-1105.55,29.8-1.0, "armurier", 159.22, "", "mp_m_exarmy_01", "",   scenario = nil, lib = nil, anim = nil},
  {-1121.4,-1437.1,5.23-1.0, "doc", 133.62, "", "ig_claypain", "",   scenario = nil, lib = nil, anim = nil},
  {-1127.34,-1439.21,5.23-1.0, "doc", 310.92, "", "a_m_m_soucent_03", "",   scenario = nil, lib = nil, anim = nil},
  {-2187.73,4249.27,48.94-1.0, "homme zizi", 11.96, "", "a_m_m_acult_01", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
  {5117.9995117188,-5190.8530273438,2.3830344676971-1.0, "location_1", 92.13, "", "a_m_y_beach_01", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
  {5054.3408203125,-4597.2045898438,2.8794636726379-1.0, "location_2", 162.48, "", "a_m_y_beach_02", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
  {4502.6494140625,-4540.6435546875,4.1091642379761-1.0, "location_3", 20.88, "", "a_m_y_beachvesp_02", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
  {4771.3422851562,-4771.8676757812,4.855170249939-1.0, "location_boat_1", 44.73, "", "a_m_y_beachvesp_02", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
  {-1604.5867919922,5256.6557617188,2.0742933750153-1.0, "location_boat_2", 25.19, "", "a_m_y_beachvesp_02", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
  {3859.9118652344,4465.4848632812,2.7424740791321-1.0, "location_boat_3", 178.20, "", "a_m_y_beachvesp_02", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
  {-718.69055175781,-1327.7019042969,1.5962892770767-1.0, "location_boat_4", 46.75, "", "a_m_y_beachvesp_02", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
  {4902.79296875,-5178.9291992188,2.5016989707947-1.0, "location_boat_5", 249.83, "", "a_m_y_beachvesp_02", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
  {5118.83984375,-4631.443359375,1.4057340621948-1.0, "location_boat_6", 77.37, "", "a_m_y_beachvesp_02", "",   scenario = nil, lib = nil, lib = nil, anim = nil},
  {-869.48175048828,-429.43237304688,36.639865875244-1.0, "faqsneakylife", 117.67, "", "a_m_y_busicas_01", "",   scenario = "WORLD_HUMAN_CLIPBOARD"},
  {107.19481658936,-1290.171875,29.249691009521-1.0, "striptiseuse", 117.67, "", "mp_f_stripperlite", "",   scenario = nil, lib = "mini@strip_club@private_dance@part3", anim = 'priv_dance_p3'},
  {103.58868408203,-1292.4168701172,29.249706268311-1.0, "striptiseuse", 117.67, "", "s_f_y_stripper_01", "",   scenario = nil, lib = "mp_safehouse", anim = 'lap_dance_girl'},
  {120.66506195068,-1297.4426269531,29.269330978394-1.0, "striptiseuse", 26.69, "", "s_f_y_stripper_01", "",   scenario = nil, lib = "timetable@ron@ig_3_couch", anim = 'base'},
  {113.35870361328,-1303.0964355469,29.892965316772-1.0, "striptiseuse", 355.18, "", "s_f_y_stripper_01", "",   scenario = nil, lib = "mp_safehouse", anim = 'lap_dance_girl'},
  --[[ {-4.8209004402161,-1671.9680175781,29.291397094727-1.0, "boxe", 298.54, "", "ig_tylerdix", "",   scenario = nil, lib = "timetable@ron@ig_3_couch", anim = 'base'}, ]]
  {1712.4272460938,4790.740234375,41.988807678223-1.0, "receleur", 3.30, "", "g_m_m_chicold_01", "",   scenario = "WORLD_HUMAN_CLIPBOARD"},
  {-867.41790771484,-437.10614013672,36.765110015869-1.0, "faq2", 0.87, "", "a_m_m_tourist_01", "",   scenario = "WORLD_HUMAN_CLIPBOARD"},
  {69.110374450684,127.63303375244,79.212127685547-1.0, "gopostal", 161.141, "", "s_m_m_postal_02", "",   scenario = "WORLD_HUMAN_CLIPBOARD"},
  {65.52473449707,128.53393554688,79.201126098633-1.0, "gopostal vestiaire", 169.055, "", "s_m_m_postal_01", "",   scenario = "WORLD_HUMAN_CLIPBOARD"},
  {1860.5733642578,3686.1838378906,34.268821716309-1.0, "sheriff", 216.56, "", "s_f_y_sheriff_01", "",   scenario = "WORLD_HUMAN_CLIPBOARD"},
  {1852.1494140625,3687.8979492188,34.270107269287-1.0, "sheriff2", 213.167, "", "s_m_y_sheriff_01", "",   scenario = nil},
  {1860.1541748047,3690.5034179688,34.270107269287-1.0, "sheriff3", 54.49, "", "s_f_y_sheriff_01", "",   scenario = nil},
  {1849.2052001953,3695.8579101562,34.270114898682-1.0, "sheriff4", 207.13, "", "s_m_y_sheriff_01", "",   scenario = nil, lib = "timetable@ron@ig_3_couch", anim = 'base'},
  {1863.1003417969,3656.8505859375,35.641696929932-1.0, "sheriffhelico", 115.93, "", "s_f_y_sheriff_01", "",   scenario = nil},
  {-458.92327880859,-2274.5456542969,8.5158185958862-1.0, "opium", 270.029, "", "csb_bogdan", "",   scenario = nil},
  {1113.5806884766,207.1716003418,-49.440132141113-1.0, "casino1", 246.48, "", "s_f_y_hooker_01", "",   scenario = nil},
  {1112.0411376953,209.94494628906,-49.440128326416-1.0, "casino2", 355.73, "", "s_m_m_highsec_01", "",   scenario = nil},
  {1110.3591308594,206.97146606445,-49.440124511719-1.0, "casino2", 114.31, "", "u_f_y_spyactress", "",   scenario = nil},
  {-1004.9962158203,-1397.0472412109,1.5953923463821-1.0, "garage bat 1", 205.31, "", "cs_jimmyboston", "",   scenario = nil},
  {-163.22871398926,-2130.1435546875,16.705018997192-1.0, "karting", 199.084, "", "a_m_y_motox_01", "",   scenario = nil},
  {-570.23876953125,-171.1466217041,38.18909072876-1.0, "gouvernementgarage", 24.52, "", "s_m_m_highsec_02", "",   scenario = nil},
  {-1178.2296142578,-891.68725585938,13.75848865509-1.0, "burgershotgarage", 304.52, "", "u_m_y_burgerdrug_01", "",   scenario = nil},
  {284.72619628906,-963.55706787109,29.418684005737-1.0, "pizzagarage", 356.57, "", "csb_chef", "",   scenario = nil},
  {2001.79296875,3050.7121582031,47.214134216309-1.0, "yellowjackgarage", 3.69, "", "csb_money", "",   scenario = nil},
  {-1221.7916259766,-1494.8013916016,4.3392429351807-1.0, "location vélo", 147.53, "", "u_m_m_bikehire_01", "",   scenario = nil},
  {58.141819000244,2783.7145996094,57.878837585449-1.0, "concess moto clés", 168.39, "", "a_m_y_cyclist_01", "",   scenario = nil},
  {59.761173248291,2787.6831054688,57.891445159912-1.0, "concess moto catalogue", 54.67, "", "a_m_y_hippy_01", "",   scenario = nil},
  {894.90771484375,-179.14970397949,74.700340270996-1.0, "taxi sortie de véhicule", 238.67, "", "a_m_y_genstreet_02", "",   scenario = nil},
  {1169.9489746094,2644.6015625,37.809593200684-1.0, "kit de réparation harmony", 94.27, "", "a_m_m_mexlabor_01", "",   scenario = nil},
  {1171.2497558594,2632.9978027344,37.809593200684-1.0, "garage harmony", 182.12, "", "a_m_m_salton_02", "",   scenario = nil},
  {316.46826171875,-587.10327148438,43.292808532715-1.0, "vendeur souvenir pillbox", 182.69, "", "cs_mrsphillips", "",   scenario = nil},
  {309.45794677734,-596.5810546875,43.29275894165-1.0, "accueil pillbox", 347.82, "", "s_f_y_scrubs_01", "",   scenario = nil},
  {343.54473876953,-582.91052246094,28.898622512817-1.0, "accueil pillbox", 284.366, "", "s_f_y_scrubs_01", "",   scenario = nil},
  {341.66137695312,-587.73687744141,28.89861869812-1.0, "accueil pillbox", 219.260, "", "s_f_y_scrubs_01", "",   scenario = nil},
  {321.83001708984,-558.86926269531,28.743432998657-1.0, "garage hopital", 21.81, "", "s_m_m_security_01", "",   scenario = nil},
  {-551.46630859375,-190.04840087891,38.223075866699-1.0, "acceuil gouvernement", 177.153, "", "s_m_m_security_01", "",   scenario = nil},
  {-1201.1643066406,-1157.4796142578,7.7200345993042-1.0, "garage noodle", 116.53, "", "a_m_m_ktown_01", "",   scenario = nil},
  {-728.06042480469,-907.06494140625,19.013912200928-1.0, "garage ltd sud", 187.52, "", "a_m_m_ktown_01", "",   scenario = nil},
  {1702.1494140625,4934.875,42.078174591064-1.0, "garage ltd nord", 64.12, "", "a_m_m_hillbilly_02", "",   scenario = nil},
  {-1357.0679931641,125.85764312744,56.238689422607-1.0, "golf", 302.55, "", "a_m_y_golfer_01", "",   scenario = nil},
  {1074.5051269531,-2008.796875,32.084980010986-1.0, "vente de pépite d'or", 88.87, "", "s_m_y_construct_01", "",   scenario = "WORLD_HUMAN_CLIPBOARD"},
  {891.6, -2538.2, 28.44-1.0, "mss 1", 172.99, "", "s_m_y_dealer_01", "",   scenario = nil},
  {414.44, 343.92, 102.44-1.0, "mss 2", 172.99, "", "s_m_y_dealer_01", "",   scenario = nil},
  {-444.96, 1598.36, 358.2-1.0, "mss 3", 172.99, "", "s_m_y_dealer_01", "",   scenario = nil},
  {1520.76, 6317.68, 24.08-1.0, "mss 4", 89.5, "", "s_m_y_robber_01", "",   scenario = nil},
}
function LoadDict(lib)
  RequestAnimDict(lib)
while not HasAnimDictLoaded(lib) do
    Citizen.Wait(10)
  end
end
function startDansePed(lib, anim)
	TaskPlayAnim(ped, lib, anim, 8.0, -8.0, -1, 1, 0.0, false, false, false)
end
Citizen.CreateThread(function()
  for _,v in pairs(coordonate) do
    RequestModel(GetHashKey(v[7]))
    while not HasModelLoaded(GetHashKey(v[7])) do
      Wait(1)
    end
    ped =  CreatePed(4, GetHashKey(v[7]),v[1],v[2],v[3], 3374176, false, true)
    TaskSetBlockingOfNonTemporaryEvents(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    if v.scenario ~= nil then
      TaskStartScenarioInPlace(ped, v.scenario, -1, true)
    end
    if v.lib ~= nil and v.anim ~= nil then
      LoadDict(v.lib)
      startDansePed(v.lib, v.anim)
    end
    SetEntityHeading(ped, v[5])
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
  end
end)

RegisterCommand('infoperso', function(source, args)
  local plyData = ESX.GetPlayerData()
	if plyData and plyData.job and plyData.job.label and plyData.job.grade_label then
    ESX.ShowNotification("ID : ~g~"..GetPlayerServerId(NetworkGetPlayerIndexFromPed(PlayerPedId())).."\n~s~Métier : ~g~"..plyData.job.label.."~s~\nGrade : ~g~"..plyData.job.grade_label.."~s~\nOrganisation : ~g~"..plyData.job2.label.."~s~\nNom FiveM : ~g~" .. GetPlayerName(PlayerId()))
	else 
    ESX.ShowNotification("~r~Données introuvables.")
	end
end)

