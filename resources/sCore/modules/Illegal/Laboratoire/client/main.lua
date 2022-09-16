local notifAttackTimeRemaining = false
onFarming = false
local TimeAttack = 60 * 1000 * 45.0;
local lablist = {}
local spamtrigger = false
local foundPlayers = false
local cooldownattack = false
local notarmed = false
local cancelattack = false
local stopattackdead = false
local cooldowndrugs = false
function DrawCenterText()
    ClearPrints()
    SetTextEntry_2("jamyfafi")
    AddTextComponentString(p)
    DrawSubtitleTimed(q and math.ceil(q) or 0, true)
end

RegisterNetEvent('Sneakyesx:playerLoaded')
AddEventHandler('Sneakyesx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)
RegisterNetEvent('Sneakyesx:setJob')
AddEventHandler('Sneakyesx:setJob', function(job)
    ESX.PlayerData.job = job
end)

Labo = Labo or {}
Labo.Zone = {
	{pos = vector3(1038.14, -3205.45, -38.16), labocolor = "~g~", itemwin = "weed", itemcountwin = 5, itemrequired = "weed_graine", itemcountrequired = 5, itemrequired2 = "weed_fertiligene", itemcountrequired2 = 5, progress = {duration = 3200, name = "Traitement de votre weed", r = 0, g = 253, b = 93}, notif = "Appuyez sur ~INPUT_CONTEXT~ pour ~g~traiter votre weed~s~.", animID = 2, size = 2.5},

	{pos = vector3(978.17633056641,-146.64123535156,-48.9), labocolor = "~b~", itemwin = "meth", itemcountwin = 10, itemrequired = "meth_lode", itemcountrequired = 5, itemrequired2 = "meth_phosphore", itemcountrequired2 = 5, progress = {duration = 3200, name = "Traitement de votre meth", r = 0, g = 141, b = 223}, notif = "Appuyez sur ~INPUT_CONTEXT~ pour ~b~traiter votre meth~s~.", animID = 5, size = 2.5},
	{pos = vector3(985.88610839844,-141.49186706543,-48.999626159668), labocolor = "~b-~", itemwin = "meth_pooch", itemcountwin = 10, itemrequired = "meth", itemcountrequired = 10, progress = {duration = 3200, name = "Conditionnement de votre meth", r = 0, g = 141, b = 223}, notif = "Appuyez sur ~INPUT_CONTEXT~ pour ~b~conditionner votre meth~s~.", animID = 6, size = 2.5},

	{pos = vector3(1093.18, -3194.925, -39.60), labocolor = "~y~", itemwin = "coke", itemcountwin = 10, itemrequired = "coca_feuille", itemcountrequired = 5, itemrequired2 = "coca_acide", itemcountrequired2 = 5, progress = {duration = 3200, name = "Traitement de votre coke", r = 248, g = 226, b = 0}, notif = "Appuyez sur ~INPUT_CONTEXT~ pour ~y~traiter votre coke~s~.", animID = 3, size = 2.5},
	{pos = vector3(1101.245, -3198.82, -39.60), labocolor = "~y~", itemwin = "coke_pooch", itemcountwin = 10, itemrequired = "coke", itemcountrequired = 10, progress = {duration = 3200, name = "Conditionnement de votre coke", r = 248, g = 226, b = 0}, notif = "Appuyez sur ~INPUT_CONTEXT~ pour ~y~conditionner votre coke~s~.", animID = 4, size = 2.5},
}


local Scenes = {}
Scenes.Synchronised = {}

function SynchronisedScene()
    return Scenes.Synchronised 
end

function ReleaseModel(model)
    local hash = (type(model) == "number" and model or GetHashKey(model))
    if HasModelLoaded(hash) then
        SetModelAsNoLongerNeeded(hash)
    end
end

function ReleaseAnimDict(dict)
    if HasAnimDictLoaded(dict) then
        SetAnimDictAsNoLongerNeeded(dict)
    end
end

function RequestAndWaitModel(modelName) -- Request un modèle de véhicule
	if modelName and IsModelInCdimage(modelName) and not HasModelLoaded(modelName) then
		RequestModel(modelName)
		while not HasModelLoaded(modelName) do
            Citizen.Wait(100) 
        end
	end
end

if not Citizen then
    NetworkCreateSynchronisedScene      = function(...)   return ...            end
    NetworkAddPedToSynchronisedScene    = function(...)   return ...            end
    NetworkAddEntityToSynchronisedScene = function(...)   return ...            end
    NetworkStartSynchronisedScene       = function(...)   return ...            end
    NetworkStopSynchronisedScene        = function(...)   return ...            end
    vector3                             = function(x,y,z) return {x=x,y=y,z=z}  end
end

Scenes.Synchronised = {
    Defaults = {
        SceneConfig = {
          position      = vector3(0.0,0.0,0.0),
          rotation      = vector3(0.0,0.0,0.0),
          rotOrder      = 2,
          useOcclusion  = false,
          loop          = false,
          unk1          = 1.0,
          animTime      = 0,
          animSpeed     = 1.0, 
        },
  
        PedConfig = {
            blendIn       = 1.0,
            blendOut      = 1.0,
            duration      = 0,
            flag          = 0,
            speed         = 1.0,
            unk1          = 0,
        },
  
        EntityConfig = {
            blendIn       = 1.0,
            blendOut      = 1.0,
            flags         = 1,
        }
    },


    Create = function(sceneConfig)    
        return NetworkCreateSynchronisedScene(sceneConfig.position,sceneConfig.rotation,sceneConfig.rotOrder,sceneConfig.useOcclusion,sceneConfig.loop,sceneConfig.unk1,sceneConfig.animTime,sceneConfig.animSpeed)
    end,
    
    SceneConfig = function(pos,rot,rotOrder,useOcclusion,loop,unk1,animTime,animSpeed)
    
        local _D = function(v1,v2) if v1 ~= nil then return v1 else return Scenes.Synchronised.Defaults["SceneConfig"][v2]; end; end
    
        local conObj = {}
        conObj.position     = _D(pos,"position")
        conObj.rotation     = _D(rot,"rotation")
        conObj.rotOrder     = _D(rotOrder,"rotOrder")
        conObj.useOcclusion = _D(useOcclusion,"useOcclusion")
        conObj.loop         = _D(loop,"loop")
        conObj.unk1         = _D(p9,"unk1")
        conObj.animTime     = _D(animTime,"animTime")
        conObj.animSpeed    = _D(animSpeed,"animSpeed")
        return conObj
    end,
    
    AddPed = function(pedConfig)
        return NetworkAddPedToSynchronisedScene(pedConfig.ped,pedConfig.scene,pedConfig.animDict,pedConfig.animName,pedConfig.blendIn,pedConfig.blendOut,pedConfig.duration,pedConfig.flag,pedConfig.speed,pedConfig.unk1)
    end,
    
    PedConfig = function(ped,scene,animDict,animName,blendIn,blendOut,duration,flag,speed,unk1)

        local _D = function(v1,v2) if v1 ~= nil then return v1 else return Scenes.Synchronised.Defaults["PedConfig"][v2]; end; end

        local conObj = {}
        conObj.ped          = ped
        conObj.scene        = scene
        conObj.animDict     = animDict
        conObj.animName     = animName
        conObj.blendIn      = _D(blendIn,"blendIn")
        conObj.blendOut     = _D(blendOut,"blendOut")
        conObj.duration     = _D(duration,"duration")
        conObj.flag         = _D(flag,"flag")
        conObj.speed        = _D(speed,"speed")
        conObj.unk1         = _D(unk1,"unk1")
        return conObj
    end,
    
    AddEntity = function(entityConfig)
        return NetworkAddEntityToSynchronisedScene(entityConfig.entity,entityConfig.scene,entityConfig.animDict,entityConfig.animName,entityConfig.blendIn,entityConfig.blendOut,entityConfig.flags)
    end,
    
    EntityConfig = function(entity,scene,animDict,animName,blendIn,blendOut,flags)

        local _D = function(v1,v2) if v1 ~= nil then return v1 else return Scenes.Synchronised.Defaults["EntityConfig"][v2]; end; end

        local conObj = {}
        conObj.entity       = entity
        conObj.scene        = scene
        conObj.animDict     = animDict
        conObj.animName     = animName
        conObj.blendIn      = _D(blendIn,"blendIn")
        conObj.blendOut     = _D(blendOut,"blendOut")
        conObj.flags        = _D(flags,"flags")
        return conObj
    end,

    Start = function(scene)
        NetworkStartSynchronisedScene(scene)
    end,

    Stop = function(scene)
        NetworkStopSynchronisedScene(scene)
    end,
}

local sceneObjects  = {}
local Scenes = SynchronisedScene()
local startTime
function SceneHandler(action, pos)
    local plyPed = PlayerPedId()
    local pPos = GetEntityCoords(plyPed)
    action.location = pos
    local sceneType = action.act
    local doScene = action.scene
    local actPos = action.location - action.offset
    local actRot = action.rotation
    local animDict = SceneDicts[sceneType][doScene]
    local actItems = SceneItems[sceneType][doScene]
    local actAnims = SceneAnims[sceneType][doScene]
    local plyAnim = PlayerAnims[sceneType][doScene]
    while not HasAnimDictLoaded(animDict) do 
        RequestAnimDict(animDict)
        Wait(0)
    end
    local count = 1
    local objectCount = 0
    for k,v in pairs(actItems) do
        local hash = GetHashKey(v)
        while not HasModelLoaded(hash) do RequestModel(hash)
            Wait(0) 
        end
        sceneObjects[k] = CreateObject(hash,actPos,true)
        SetModelAsNoLongerNeeded(hash)
        objectCount = objectCount + 1
        while not DoesEntityExist(sceneObjects[k]) do 
            Wait(0)
        end
        SetEntityCollision(sceneObjects[k],false,false)
    end
    local scenes = {}
    local sceneConfig = Scenes.SceneConfig(actPos,actRot,2,false,false,1.0,0,1.0)
    for i=1,math.max(1,math.ceil(objectCount/3)),1 do
      scenes[i] = Scenes.Create(sceneConfig)
    end
    local pedConfig = Scenes.PedConfig(plyPed,scenes[1],animDict,plyAnim)
    Scenes.AddPed(pedConfig)
    for k,animation in pairs(actAnims) do      
      local targetScene = scenes[math.ceil(count/3)]
      local entConfig = Scenes.EntityConfig(sceneObjects[k],targetScene,animDict,animation)
      Scenes.AddEntity(entConfig)
      count = count + 1
    end
    local extras = {}
    if action.extraProps then
      for k,v in pairs(action.extraProps) do
        RequestAndWaitModel(v.model)
        local obj = CreateObject(GetHashKey(v.model), actPos + v.pos, true,true,true)
        while not DoesEntityExist(obj) do Wait(0); end
        SetEntityRotation(obj,v.rot)
        FreezeEntityPosition(obj,true)
        extras[#extras+1] = obj
      end
    end
    startTime = GetGameTimer()
    for i=1,#scenes,1 do
      Scenes.Start(scenes[i])
    end
    Wait(action.time)
    for i=1,#scenes,1 do
      Scenes.Stop(scenes[i])
    end
    for k,v in pairs(extras) do
      DeleteObject(v)
    end
    RemoveAnimDict(animDict)
    for k,v in pairs(sceneObjects) do 
        NetworkFadeOutEntity(v, false, false)
    end
end

Labo = Labo or {}

SceneDicts = {
    Cocaine = {
        [1] = 'anim@amb@business@coc@coc_unpack_cut_left@',
        [2] = 'anim@amb@business@coc@coc_packing_hi@',
    },
    Meth = {
        [1] = 'anim@amb@business@meth@meth_monitoring_cooking@cooking@',
        [2] = 'anim@amb@business@meth@meth_smash_weight_check@',
    },
    Weed = {
        [1] = 'anim@amb@business@weed@weed_inspecting_lo_med_hi@',
        [2] = 'anim@amb@business@weed@weed_sorting_seated@',
    },
    Money = {
        [1] = 'anim@amb@business@cfm@cfm_counting_notes@',
        [2] = 'anim@amb@business@cfm@cfm_cut_sheets@',
        [3] = 'anim@amb@business@cfm@cfm_drying_notes@',
    }
}

PlayerAnims = {
    Cocaine = {
        [1] = 'coke_cut_v5_coccutter',
        [2] = 'full_cycle_v3_pressoperator'
    },
    Meth = {
        [1] = 'chemical_pour_short_cooker',
        [2] = 'break_weigh_v3_char01',
    },
    Weed = {
        [1] = 'weed_spraybottle_crouch_spraying_02_inspector',
        [2] = "sorter_right_sort_v3_sorter02",
    },
    Money = {
        [1] = 'note_counting_v2_counter',
        [2] = 'extended_load_tune_cut_billcutter',
        [3] = 'loading_v3_worker',
    }
}

SceneAnims = {
    Cocaine = {
        [1] = {
            bakingsoda = 'coke_cut_v5_bakingsoda',
            creditcard1 = 'coke_cut_v5_creditcard',
            creditcard2 = 'coke_cut_v5_creditcard^1',
        },
        [2] = {
            scoop = 'full_cycle_v3_scoop',
            box1 = 'full_cycle_v3_FoldedBox',
            dollmold = 'full_cycle_v3_dollmould',
            dollcast1 = 'full_cycle_v3_dollcast',
            dollcast2 = 'full_cycle_v3_dollCast^1',
            dollcast3 = 'full_cycle_v3_dollCast^2',
            dollcast4 = 'full_cycle_v3_dollCast^3',
            press = 'full_cycle_v3_cokePress',
            doll = 'full_cycle_v3_cocdoll',
            bowl = 'full_cycle_v3_cocbowl',
            boxed = 'full_cycle_v3_boxedDoll',
        },
    },
    Meth = {
        [1] = {
            ammonia = 'chemical_pour_short_ammonia',
            clipboard = 'chemical_pour_short_clipboard',
            pencil = 'chemical_pour_short_pencil',
            sacid = 'chemical_pour_short_sacid',
        },
        [2] = {
            box1 = 'break_weigh_v3_box01',
            box2 = 'break_weigh_v3_box01^1',
            clipboard = 'break_weigh_v3_clipboard',
            methbag1 = 'break_weigh_v3_methbag01',
            methbag2 = 'break_weigh_v3_methbag01^1',
            methbag3 = 'break_weigh_v3_methbag01^2',
            methbag4 = 'break_weigh_v3_methbag01^3',
            methbag5 = 'break_weigh_v3_methbag01^4',
            methbag6 = 'break_weigh_v3_methbag01^5',
            methbag7 = 'break_weigh_v3_methbag01^6',
            pen = 'break_weigh_v3_pen',
            scale = 'break_weigh_v3_scale',
            scoop = 'break_weigh_v3_scoop',
        },
    },
    Weed = {
        [1] = {},
        [2] = {
            weeddry1 = 'sorter_right_sort_v3_weeddry01a',
            weeddry2 = 'sorter_right_sort_v3_weeddry01a^1',
            weedleaf1 = 'sorter_right_sort_v3_weedleaf01a',
            weedleaf2 = 'sorter_right_sort_v3_weedleaf01a^1',
            weedbag = 'sorter_right_sort_v3_weedbag01a',
            weedbud1a = 'sorter_right_sort_v3_weedbud02b',
            weedbud2a = 'sorter_right_sort_v3_weedbud02b^1',
            weedbud3a = 'sorter_right_sort_v3_weedbud02b^2',
            weedbud4a = 'sorter_right_sort_v3_weedbud02b^3',
            weedbud5a = 'sorter_right_sort_v3_weedbud02b^4',
            weedbud6a = 'sorter_right_sort_v3_weedbud02b^5',
            weedbud1b = 'sorter_right_sort_v3_weedbud02a',
            weedbud2b = 'sorter_right_sort_v3_weedbud02a^1',
            weedbud3b = 'sorter_right_sort_v3_weedbud02a^2',
            bagpile = 'sorter_right_sort_v3_weedbagpile01a',
            weedbuck = 'sorter_right_sort_v3_bucket01a',
            weedbuck = 'sorter_right_sort_v3_bucket01a^1',
        },
    },
    Money = {
        [1] = {
            binmoney = 'note_counting_v2_binmoney',
            moneybin = 'note_counting_v2_moneybin',
            money1 = 'note_counting_v2_moneyunsorted',
            money2 = 'note_counting_v2_moneyunsorted^1',
            wrap1 = 'note_counting_v2_moneywrap',
            wrap2 = 'note_counting_v2_moneywrap^1',
        },
        [2] = {
            cutter = 'extended_load_tune_cut_papercutter',
            singlep1 = 'extended_load_tune_cut_singlemoneypage',
            singlep2 = 'extended_load_tune_cut_singlemoneypage^1',
            singlep3 = 'extended_load_tune_cut_singlemoneypage^2',
            table = 'extended_load_tune_cut_table',
            stack = 'extended_load_tune_cut_moneystack',
            strip1 = 'extended_load_tune_cut_singlemoneystrip',
            strip2 = 'extended_load_tune_cut_singlemoneystrip^1',
            strip3 = 'extended_load_tune_cut_singlemoneystrip^2',
            strip4 = 'extended_load_tune_cut_singlemoneystrip^3',
            strip5 = 'extended_load_tune_cut_singlemoneystrip^4',
            sinstack = 'extended_load_tune_cut_singlestack',
        },
        [3] = {
            bucket = 'loading_v3_bucket',
            money1 = 'loading_v3_money01',
            money2 = 'loading_v3_money01^1',
        }
    },
}

SceneItems = {
    Cocaine = {
        [1] = {
            bakingsoda = 'bkr_prop_coke_bakingsoda_o',
            creditcard1 = 'prop_cs_credit_card',
            creditcard2 = 'prop_cs_credit_card',
        },
        [2] = {
            scoop = 'bkr_prop_coke_fullscoop_01a',
            doll = 'bkr_prop_coke_doll',
            boxed = 'bkr_prop_coke_boxedDoll',
            dollcast1 = 'bkr_prop_coke_dollCast',
            dollcast2 = 'bkr_prop_coke_dollCast',
            dollcast3 = 'bkr_prop_coke_dollCast',
            dollcast4 = 'bkr_prop_coke_dollCast',
            dollmold = 'bkr_prop_coke_dollmould',
            bowl = 'bkr_prop_coke_fullmetalbowl_02',
            press = 'bkr_prop_coke_press_01b',
            box1 = 'bkr_prop_coke_dollboxfolded',
        },
    },
    Meth = {
        [1] = {
            ammonia = 'bkr_prop_meth_ammonia',
            clipboard = 'bkr_prop_fakeid_clipboard_01a',
            pencil = 'bkr_prop_fakeid_penclipboard',
            sacid = 'bkr_prop_meth_sacid',
        },
        [2] = {
            box1 = 'bkr_prop_meth_bigbag_04a',
            box2 = 'bkr_prop_meth_bigbag_03a',
            clipboard = 'bkr_prop_fakeid_clipboard_01a',
            methbag1 = 'bkr_prop_meth_openbag_02',
            methbag2 = 'bkr_prop_meth_openbag_02',
            methbag3 = 'bkr_prop_meth_openbag_02',
            methbag4 = 'bkr_prop_meth_openbag_02',
            methbag5 = 'bkr_prop_meth_openbag_02',
            methbag6 = 'bkr_prop_meth_openbag_02',
            methbag7 = 'bkr_prop_meth_openbag_02',
            pen = 'bkr_prop_fakeid_penclipboard',
            scale = 'bkr_prop_coke_scale_01',
            scoop = 'bkr_prop_meth_scoop_01a',
        },
    },
    Weed = {
        [1] = {},
        [2] = {
            weeddry1 = 'bkr_prop_weed_dry_01a',
            weeddry2 = 'bkr_prop_weed_dry_01a',
            weedleaf1 = 'bkr_prop_weed_leaf_01a',
            weedleaf2 = 'bkr_prop_weed_leaf_01a',
            weedbag = 'bkr_prop_weed_bag_01a',
            weedbud1a = 'bkr_prop_weed_bud_02b',
            weedbud2a = 'bkr_prop_weed_bud_02b',
            weedbud3a = 'bkr_prop_weed_bud_02b',
            weedbud4a = 'bkr_prop_weed_bud_02b',
            weedbud5a = 'bkr_prop_weed_bud_02b',
            weedbud6a = 'bkr_prop_weed_bud_02b',
            weedbud1b = 'bkr_prop_weed_bud_02a',
            weedbud2b = 'bkr_prop_weed_bud_02a',
            weedbud3b = 'bkr_prop_weed_bud_02a',
            bagpile = 'bkr_prop_weed_bag_pile_01a',
            weedbuck = 'bkr_prop_weed_bucket_open_01a',
        },
    },
    Money = {
        [1] = {
            binmoney = 'bkr_prop_coke_tin_01',
            moneybin = 'bkr_prop_tin_cash_01a',
            money1 = 'bkr_prop_money_unsorted_01',
            money2 = 'bkr_prop_money_unsorted_01',
            wrap1 = 'bkr_prop_money_wrapped_01',
            wrap2 = 'bkr_prop_money_wrapped_01',
        },
        [2] = {
            cutter = 'bkr_prop_fakeid_papercutter',
            singlep1 = 'bkr_prop_cutter_moneypage',
            singlep2 = 'bkr_prop_cutter_moneypage',
            singlep3 = 'bkr_prop_cutter_moneypage',
            table = 'bkr_prop_fakeid_table',
            stack = 'bkr_prop_cutter_moneystack_01a',
            strip1 = 'bkr_prop_cutter_moneystrip',
            strip2 = 'bkr_prop_cutter_moneystrip',
            strip3 = 'bkr_prop_cutter_moneystrip',
            strip4 = 'bkr_prop_cutter_moneystrip',
            strip5 = 'bkr_prop_cutter_moneystrip',
            sinstack = 'bkr_prop_cutter_singlestack_01a',
        },
        [3] = {
            bucket = 'bkr_prop_money_pokerbucket',
            money1 = 'bkr_prop_money_unsorted_01',
            money2 = 'bkr_prop_money_unsorted_01',
        }
    },
}

local action = {
    {
        offset = vector3(-0.014, 0.896, 1.0),
        rotation = vector3(0.0, 0.0, 90.0),
        time = 15000,
        act = "Weed",
        scene = 1,
    },
    {
        offset = vector3(-0.3, 0.4, 0.96),
        rotation = vector3(0.0, 0.0, 90.0),
        time = 30000,
        act = "Weed",
        scene = 2,
    },
    {    
        offset = vector3(1.911, 0.31, 0.0),
        rotation = vector3(0.0, 0.0, 0.0),
        time = 25000,
        act = "Cocaine",
        scene = 1,
    },
    {    
        offset = vector3(7.663, -2.222, 0.395),
        rotation = vector3(0.0, 0.0, 0.0),
        time = 60000,
        act = "Cocaine",
        scene = 2,
    },
    {
        offset = vector3(-4.88, -1.95, 0.0),
        rotation = vector3(0.0, 0.0, 0.0),
        time = 70000,
        act = "Meth",
        scene = 1,
    },
    {
        offset = vector3(4.48, 1.7, 1.0),
        rotation = vector3(0.0, 0.0, 0.0),
        time = 45000,
        act = "Meth",
        scene = 2,
    },
    {
        offset = vector3(-0.8, 0.896, 0.6),
        rotation = vector3(0.0, 0.0, 180.0),
        time = 20000, 
        act = "Money", 
        scene = 1, 

        extraProps = {
            [1] = {
                model = "bkr_prop_money_counter",
                pos = vector3(-0.25, 0.22, 0.4),
                rot = vector3(0.0, 0.0, 180.0),
            },
            [2] = {
                model = "bkr_prop_moneypack_03a",
                pos = vector3(-0.7, -0.25, 0.4),
                rot = vector3(0.0, 0.00, 0.0),
            },
            [3] = {
                model = "bkr_prop_moneypack_03a",
                pos = vector3(-0.7, -0.25, 0.55),
                rot = vector3(0.0, 0.00, 0.00),
            }
        }
    },
    {
        offset = vector3(2.15, 0.67, 0.6),
        rotation = vector3(0.0, 0.0, 180.0),
        time = 45000,
        act = "Money",
        scene = 2,
    },
    {
        offset = vector3(0.15, 0.0, 0.0),
        rotation = vector3(0.0, 0.0, 65.0),
        time = 45000,
        act = "Money",
        scene = 3,
    }
}

function StartlaboAnim(scene, pos)
    SceneHandler(action[scene], pos)
end

Citizen.CreateThread(function()
    Wait(5*1000)
    while true do 
        local wait = 500
        local pPed = PlayerPedId()
        local pPos = GetEntityCoords(pPed)
        for _,v in pairs(Labo.Zone) do 
            local distance = Vdist(v.pos, pPos)
            local PedHealth = GetEntityHealth(PlayerPedId())
            if isPlayerLab and distance < v.size and PedHealth >= 10 and not ProgressBarExists() then 
                wait = 5
                ShowHelpNotification(v.notif or "Merci de signaler au Admins: "..v.itemwin)
                if IsControlJustPressed(0, 51) then 
                    if v.itemrequired then
                        ESX.TriggerServerCallback("sDrugs:getItemAmount", function(count)
                            if count >= v.itemcountrequired then 
                                if v.itemrequired2 then 
                                    ESX.TriggerServerCallback("sDrugs:getItemAmount", function(count)
                                        if count >= v.itemcountrequired2 then
                                            local PedHealth = GetEntityHealth(PlayerPedId())
                                            if not IsPedSittingInAnyVehicle(PlayerPedId()) and PedHealth >= 10 and not ProgressBarExists() then
                                                ProgressBar(v.progress.name, v.progress.r, v.progress.g, v.progress.b, 200, action[v.animID].time - 1000)
                                                if v.animID then 
                                                    StartlaboAnim(v.animID, v.pos)
                                                end
                                                RemoveProgressBar()
                                                TriggerServerEvent("sCore:FarmLabo", v.labocolor, v.itemwin, v.itemcountwin, v.itemrequired, v.itemcountrequired, v.itemrequired2, v.itemcountrequired2)
                                                Wait(1500)
                                            end
                                        else
                                            ShowNotification("~r~Vous n'avez assez d'item demandé pour commencer à traiter.")
                                        end
                                    end,v.itemrequired2)
                                else
                                    local PedHealth = GetEntityHealth(PlayerPedId())
                                    if not IsPedSittingInAnyVehicle(PlayerPedId()) and PedHealth >= 10 and not ProgressBarExists() then
                                        ProgressBar(v.progress.name, v.progress.r, v.progress.g, v.progress.b, 200, action[v.animID].time - 1000)
                                        if v.animID then 
                                            StartlaboAnim(v.animID, v.pos)
                                        end
                                        RemoveProgressBar()
                                        TriggerServerEvent("sCore:FarmLabo", v.labocolor, v.itemwin, v.itemcountwin, v.itemrequired, v.itemcountrequired, nil, nil)
                                        Wait(1500)
                                    end
                                end
                            else
                                ShowNotification("~r~Vous n'avez assez d'item demandé pour commencer à traiter.")
                            end
                        end, v.itemrequired)
                    else
                        local PedHealth = GetEntityHealth(PlayerPedId())
                        if not IsPedSittingInAnyVehicle(PlayerPedId()) and PedHealth >= 10 and not ProgressBarExists() then
                            ProgressBar(v.progress.name, v.progress.r, v.progress.g, v.progress.b, 200, action[v.animID].time - 1000)
                            if v.animID then 
                                StartlaboAnim(v.animID, v.pos)
                            end
                            RemoveProgressBar()
                            TriggerServerEvent("sCore:FarmLabo", v.labocolor, v.itemwin, v.itemcountwin, nil, nil, nil, nil)
                            Wait(1500)
                        end
                    end
                end
            end
        end
        Wait(wait)
    end
end)



local attack = false
Citizen.CreateThread(function()
    getLaboratoireESX()

    while resultLab == nil do
        Wait(1500)
        refreshLabList()
    end

    while true do
        local myCoords = GetEntityCoords(PlayerPedId())
        local nofps = false
        local zone = GetClosestZone()
        if ESX.PlayerData.job.name == "police" then 
            conditionJob2 = false 
            blockAchat = true 
            underJob = true 
            blockAttack = true 
        elseif ESX.PlayerData.job2.name ~= "unemployed2" or ESX.PlayerData.job2.name ~= "unemployed" then 
            blockAttack = false
            conditionJob2 = false 
            blockAchat = false 
            underJob2 = true 
        else 
            conditionJob2 = true 
            underJob = false
            underJob2 = false 
            blockAchat = true 
            blockAttack = true
        end
        if not conditionJob2 then
            if not openedBuyMenu then
                if not isPlayerVisite and not onFarming then
                    if not isPlayerLab then 
                        for k,v in pairs(resultLab) do
                            local labCoords = json.decode(v.pos)
                            if not blockAttack then
                                if v.owner ~= nil and v.owner ~= ESX.PlayerData.job2.name and GetDistanceBetweenCoords(myCoords, labCoords.x, labCoords.y, labCoords.z, true) < 20.0 then
                                    if not cooldownattack then
                                        if not attack then
                                            if IsPedArmed(PlayerPedId(), 4) then
                                                local playerPed = PlayerPedId()
                                                local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 15.0)
                                                local foundPlayersTop = false
                                                local playersattack = {}
                                                for i = 1, #players, 1 do
                                                    if players[i] ~= PlayerId() then
                                                        foundPlayersTop = true
                                                    end
                                                end
                                                if foundPlayersTop then
                                                    if not spamtrigger then
                                                        spamtrigger = true
                                                        ESX.TriggerServerCallback('sLaboratoire:CheckTimeAttack', function(TimeValid)
                                                            if TimeValid then
                                                                attack = true
                                                                table.insert(lablist, {id = v.id, owner = v.owner, ownerName = v.ownerName, name = v.name, coords = labCoords})
                                                            end
                                                        end,v.id)
                                                        SetTimeout(30000, function()
                                                            spamtrigger = false
                                                        end)
                                                    end
                                                else
                                                    if notifNotFoundPlayers then
                                                        Wait(10000) 
                                                        RemoveNotification(notifNotFoundPlayers) 
                                                    end
                                                    notifNotFoundPlayers = ShowAboveRadarMessage("~r~Vous ne pouvez pas attaquer de laboratoire en étant tout seul.")
                                                end
                                            end
                                        end
                                    else
                                        ShowAboveRadarMessage("~r~Vous avez déjà attaqué un laboratoire recemment.")
                                    end
                                end
                            end
                            if GetDistanceBetweenCoords(myCoords, labCoords.x, labCoords.y, labCoords.z,  true) < 2.0 then
                                nofps = true
                                if v.owner == nil then
                                    if not blockAchat then
                                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour acheter le laboratoire")
                                        if IsControlJustReleased(0, 38) then
                                            openBuyMenu(v)
                                        end
                                    end
                                else
                                    if v.owner == ESX.PlayerData.job2.name then
                                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~entrer~s~ dans le laboratoire.")
                                        if IsControlJustReleased(0, 38) then
                                            TriggerServerEvent("sLaboratoire:Enter", GetEntityCoords(PlayerPedId()), v)
                                        end
                                    end
                                end
                            end
                        end
                    else
                        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 1034.6514892578,-3205.5776367188,-38.176643371582, true) < 2.0 then
                            nofps = true
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour mettre en ~g~pochon~s~.")
                            if IsControlJustReleased(0, 38) then
                                if not cooldowndrugs then
                                    ESX.TriggerServerCallback("sDrugs:getItemAmount", function(count)
                                        if count >= 2 then
                                            cooldowndrugs = true  
                                            finalDrugs()
                                        else
                                            return
                                            ESX.ShowNotification("~r~Vous n'avez pas se qu'il faut sur vous.")
                                        end
                                    end, "weed")
                                end    
                            end
                        end
                        local type = lastLaboratoire.type
                        
                        local transformItem = Laboratoire[type].Champs

                        local assemblagePos = Laboratoire[type].Assemblage.pos
                        local assemblageItem = Laboratoire[type].Assemblage.itemName
                        local assemblageCount = Laboratoire[type].Assemblage.count
    
                        local pochonPos = Laboratoire[type].Pochon.pos
                        local pochonItem = Laboratoire[type].Pochon.itemName
                        local pochonCount = Laboratoire[type].Pochon.count

                        local extingPos = Laboratoire[type].enter
                        if GetDistanceBetweenCoords(myCoords, extingPos.x, extingPos.y, extingPos.z,  true) < 1.0 then
                            nofps = true
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~r~sortir~s~ du laboratoire.")
                            if IsControlJustReleased(0, 38) then
                                TriggerServerEvent("sLaboratoire:Exit")
                            end
                        end
                    end
                end
            end
        end
        if nofps then
            Wait(1)
        else
            Wait(850)
        end
    end

end)
local canAttack = false
local playersattack = {}
local DontSpam = false
Citizen.CreateThread(function()
    while true do
        if attack then
            local playerPed = PlayerPedId()
            local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 15.0)
            local foundPlayers = false
            local playersattack = {}
            for i = 1, #players, 1 do
                if players[i] ~= PlayerId() then
                    foundPlayers = true
                    table.insert(playersattack, {playersid = GetPlayerServerId(players[i])})
                    if not DontSpam then
                        DontSpam = true
                        ESX.TriggerServerCallback('sLaboratoire:SendPlayersAttack', function(cb)
                            canAttack = cb
                        end, playersattack, lablist)
                        SetTimeout(10000, function()
                            DontSpam = false
                        end)
                    end
                end
            end
            if not foundPlayers then
                --ESX.ShowNotification("~r~Vous ne pouvez pas attaquer un laboratoire en étant tout seul.")
                attack = false
            end
            Wait(1)
        else
            Wait(850)
        end
    end
end)
local timeoutlab = false
local startattack = false

function GetClosestZone()
    local zone = GetStreetNameFromHashKey(GetStreetNameAtCoord(GetEntityCoords(GetPlayerPed(-1)).x,GetEntityCoords(GetPlayerPed(-1)).y, GetEntityCoords(GetPlayerPed(-1)).z))
    return zone
end

RegisterNetEvent("sLaboratoire:StartAttack")
AddEventHandler("sLaboratoire:StartAttack",function(jobname)
    if not startattack then
        startattack = true
        local zone = GetClosestZone()
        for k,v in pairs(lablist) do
            TriggerServerEvent("sLaboratoire:NotifyAttack",v.owner, v.ownerName, zone)
        end
        ESX.AddTimerBar("Capture en cours:", {endTime = GetGameTimer() + TimeAttack})
        PlaySoundFrontend(-1, "Enter_Area", "DLC_Lowrider_Relay_Race_Sounds", 0)
        Wait(TimeAttack)
        if stopattackdead then
            startattack = false
            attack = false
            cooldownattack = true
            ESX.RemoveTimerBar()
            ShowAboveRadarMessage("~r~Vous avez été gravement blessé vous ne pouvez pas continuer à attaquer le laboratoire.")
            SetTimeout(3600000, function()
                cooldownattack = false
                cancelattack = false
                stopattackdead = false
                notarmed = false
            end)
            return
        end
        if cancelattack then
            attack = false
            startattack = false
            cooldownattack = true
            ESX.RemoveTimerBar()
            ShowAboveRadarMessage("~r~Vous avez fui la zone.")
            SetTimeout(3600000, function()
                cooldownattack = false
                cancelattack = false
                stopattackdead = false
                notarmed = false
            end)
            return
        end
        if notarmed then
            attack = false
            startattack = false
            cooldownattack = true
            ESX.RemoveTimerBar()
            ShowAboveRadarMessage("~r~Vous ne pouvez pas poursuivre l'attaque en étant désarmé.")
            SetTimeout(3600000, function()
                cooldownattack = false
                cancelattack = false
                stopattackdead = false
                notarmed = false
            end)
        end
        ESX.RemoveTimerBar()
        for k,v in pairs(lablist) do
            if not timeoutlab then
                TriggerServerEvent("sLaboratoire:updateAttack", v.id, v.name, ESX.PlayerData.job2.name, ESX.PlayerData.job2.label)
                timeoutlab = true
                SetTimeout(60000, function()
                    timeoutlab = false
                end)
            end
        end
        PlaySoundFrontend(-1, "Out_Of_Area", "DLC_Lowrider_Relay_Race_Sounds", 0)
    end
end)

Citizen.CreateThread(function()
    while true do
        if startattack then
            if IsPedDeadOrDying(PlayerPedId()) then
                stopattackdead = true
            end
            for k,v in pairs(lablist) do
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.coords.x, v.coords.y, v.coords.z, true) > 40.0 then
                    cancelattack = true
                end
            end
            if not IsPedArmed(PlayerPedId(), 4) then
                notarmed = true
            end
            Wait(1)
        else
            Wait(850)
        end
    end
end)

function AddLongString(txt)
	local maxLen = 100
	for i = 0, string.len(txt), maxLen do
		local sub = string.sub(txt, i, math.min(i + maxLen, string.len(txt)))
		AddTextComponentString(sub)
	end
end

function ShowAboveRadarMessage(message, back)
	if back then ThefeedNextPostBackgroundColor(back) end
	SetNotificationTextEntry("jamyfafi")
	AddLongString(message)
	return DrawNotification(0, 1)
end


RegisterNetEvent("sLaboratoire:SendTimesClient")
AddEventHandler("sLaboratoire:SendTimesClient",function(txtday,txthrs,txtminutes)
    if notifAttackTimeRemaining then 
        RemoveNotification(notifAttackTimeRemaining) 
    end
    notifAttackTimeRemaining = ShowAboveRadarMessage("~r~Veuillez patienter encore "..txtday.." jours, "..txthrs.." heures et "..txtminutes.." minutes avant de pouvoir attaquer ce laboratoire.")
end)

local onFarming = false
Citizen.CreateThread(function()
    while true do
        local waiting = 250
        local myCoords = GetEntityCoords(PlayerPedId())
        
        if not onFarming then
            for k,v in pairs(Laboratoire) do
                local champs = v.Champs
                for k,v in pairs(champs) do
                    if #(myCoords-v.coords) < v.radius then 
                        waiting = 1
                        ESX.ShowHelpNotification(v.message)
                        if IsControlJustReleased(0, 54) then
                            FreezeEntityPosition(PlayerPedId(), true)
                            onFarming = true
                            Citizen.Wait(10)
                            startAnim('anim@amb@business@weed@weed_inspecting_lo_med_hi@', "weed_spraybottle_crouch_spraying_02_inspector")
                            ProgressBar("Récolte en cours", 0, 243, 255, 200, 15000)
                            Citizen.Wait(15000)
                            ClearPedTasksImmediately(PlayerPedId())
                            TriggerServerEvent("sDrugs:addItem", v.item)
                            onFarming = false
                            FreezeEntityPosition(PlayerPedId(), false)
                        end
                    end
                end
            end
        end
            
        Wait(waiting)
    end
end)

RegisterNetEvent("sLaboratoire:refreshLab")
AddEventHandler("sLaboratoire:refreshLab", function()
    refreshLabList()
end)

RegisterNetEvent("sLaboratoire:returnEnter")
AddEventHandler("sLaboratoire:returnEnter", function(table)
    lastPos = GetEntityCoords(PlayerPedId())
    SetEntityCoordsNoOffset(PlayerPedId(), Laboratoire[table.type].enter)
    SetEntityHeading(PlayerPedId(), Laboratoire[table.type].heading)
    isPlayerLab = true
    lastLaboratoire = table
end)

RegisterNetEvent("sLaboratoire:returnVisite")
AddEventHandler("sLaboratoire:returnVisite", function(table)
    lastPos = GetEntityCoords(PlayerPedId())
    SetEntityCoords(PlayerPedId(), Laboratoire[table.type].enter)
    SetEntityHeading(PlayerPedId(), Laboratoire[table.type].heading)
    openVisiteMenu(table)
    isPlayerVisite = true
    lastLaboratoire = table
end)

RegisterNetEvent("sLaboratoire:returnExit")
AddEventHandler("sLaboratoire:returnExit", function()
     SetEntityCoords(PlayerPedId(), lastPos.x, lastPos.y, lastPos.z-1.0)
     isPlayerExting = false
     if isPlayerVisite then
          isPlayerVisite = false
     elseif isPlayerLab then
        isPlayerLab = false
     end
     lastLaboratoire = nil
end)

function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 1, 0.0, false, false, false)
	end)
end

function finalDrugs()
    onFarming = true
    SetEntityCoords(PlayerPedId(), 1034.6480712891,-3205.4565429688,-38.176685333252)
    SetEntityHeading(PlayerPedId(), 99.33)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(10)
            startAnim("mini@repair", "fixing_a_ped")
            Citizen.Wait(14500)
            ClearPedTasksImmediately(PlayerPedId())
            SneakyEvent("sDrugs:Removeitem")
            cooldowndrugs = false
            onFarming = false
            break
        end
    end)
end