ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
end)

local prop1="prop_ld_test_01"
local prop2="prop_carwash_roller_horz"
local prop3="prop_carwash_roller_vert"
local prop4="carwash2_r"
local timer=1.5;
local spray={}
local prop5="scr_carwash"
local price = 100
local poscar={
	vector3(-700.01,-921.57,19.01)
}
local headingveh=180.0
function RequestAndWaitModel(modelName) -- Request un modèle de véhicule
	if modelName and IsModelInCdimage(modelName) and not HasModelLoaded(modelName) then
		RequestModel(modelName)
		while not HasModelLoaded(modelName) do
            Citizen.Wait(100) 
        end
	end
end
local function particles(ent,ent1)
	local Timer1=4.85/2.0;
	local Timer2=-3.6/2.0;
	local Timer3=vec3(90,90,0)
	local Timer4={}
	for Timer5=1,4 do 
		local Timer6=Timer5%2
		UseParticleFxAssetNextCall(prop5)
		Timer4[Timer5]=StartParticleFxLoopedOnEntity("ent_amb_car_wash_jet",ent1,Timer6==0 and-Timer1 or Timer1,0.0,(-Timer2* (Timer5>2 and 0.75 or 0.0))-2,Timer6==0 and Timer3 or-Timer3,1.0)end;
		local Timer6=GetSoundId()
		PlaySoundFromEntity(Timer6,"SPRAY",ent,"CARWASH_SOUNDS",false,0)
		Wait(5000)
		StopSound(Timer6)
	for _,Variable7 in pairs(Timer4)do
		StopParticleFxLooped(Variable7,0)
		RemoveParticleFx(Variable7,0)
	end 
end

local function sounpartveh(ent,ent1,ent2)
	local pCoords=GetEntityCoords(ent)
	local pCoordsx=pCoords.x;
	local pSound1=GetSoundId()
	PlaySoundFromEntity(pSound1,"BRUSHES_MOVE",ent,"CARWASH_SOUNDS",0,0)
	while ent1 and pCoords.x>ent2 or not ent1 and pCoords.x<ent2 do 
		Wait(10)
		SetEntityCoords(ent,pCoords.x- (ent1 and 0.01 or-0.01),pCoords.y,pCoords.z)
		pCoords=GetEntityCoords(ent)
	end;
	StopSound(pSound1)
	pSound1=GetSoundId()
	PlaySoundFromEntity(pSound1,"BRUSHES_SPINNING",ent,"CARWASH_SOUNDS",0,0)
	UseParticleFxAssetNextCall(prop5)
	local ent3=StartNetworkedParticleFxLoopedOnEntity("ent_amb_car_wash",ent,0.0,0.0,0.0,0.0,90.0,0.0,1.0,false,false,false)
	local Entity=GetGameTimer()+4000;
	while GetGameTimer()<Entity do Wait(0)
		local pRota=GetEntityRotation(ent,2)
		SetEntityRotation(ent,pRota.x,pRota.y,(pRota.z+0.4)%180.0,2,1)
	end
		StopParticleFxLooped(ent3,0)
		StopSound(pSound1)
		CreateThread(function()
		while ent1 and pCoords.x<pCoordsx or not ent1 and pCoords.x>pCoordsx do 
			Wait(10)
			SetEntityCoords(ent, pCoords.x- (ent1 and-0.01 or 0.01),pCoords.y,pCoords.z)
			pCoords=GetEntityCoords(ent)
		end 
	end)
end

local function cordspart(ent)
	local LeftRoller=spray.leftRoller;
	local RightRoller=spray.rightRoller
	local Dimensions,Dimensionx=GetModelDimensions(GetEntityModel(ent))
	local YVLXYq=GetEntityCoords(ent)
	local GoodDimensions=(math.abs(Dimensions.x)+math.abs(Dimensionx.x))/2
	CreateThread(function()
		sounpartveh(LeftRoller,true,YVLXYq.x+GoodDimensions+0.3)
	end)
	sounpartveh(RightRoller,false,YVLXYq.x-GoodDimensions-0.3)
end

local function finircarwash(OhuFpq_N)
	local RollerUp=spray.rollerUp
	local Variable1,GetCoords=GetGroundZFor_3dCoord(-699.97,-931.7,21.3,0)
	local DimensionsVehicle,_Fr2YU=GetModelDimensions(GetEntityModel(OhuFpq_N))
	local GetCoordsX= GetCoords+math.abs(DimensionsVehicle.z)+math.abs(_Fr2YU.z)+0.3
	local U=GetEntityCoords(RollerUp)
	local Ebsw=U.z;
	local UlikV=GetSoundId()
	PlaySoundFromEntity(UlikV,"BRUSHES_MOVE",ldTestRollers,"CARWASH_SOUNDS",0,0)
	while U.z>GetCoordsX do Wait(10)
		SetEntityCoords(RollerUp,U.x,U.y,U.z-0.02)
		U=GetEntityCoords(RollerUp)
	end
	StopSound(UlikV)
	UlikV=GetSoundId()
	PlaySoundFromEntity(UlikV,"BRUSHES_SPINNING",ldTestRollers,"CARWASH_SOUNDS",0,0)
	UseParticleFxAssetNextCall(prop5)
	local JtAjijkG=StartNetworkedParticleFxLoopedOnEntity("ent_amb_car_wash",RollerUp,0.0,0.0,0.0,0.0,90.0,0.0,1.0,false,false,false)
	local s=GetGameTimer()+4000;
	while GetGameTimer()<s do Wait(0)
		local YAtG_Lprop3=GetEntityRotation(RollerUp,2)
		SetEntityRotation(RollerUp,(YAtG_Lprop3.x+0.4)%90,YAtG_Lprop3.y,YAtG_Lprop3.z,2,1)
	end
	StopParticleFxLooped(JtAjijkG,0)
	StopSound(UlikV)
	CreateThread(function()
		while U.z<Ebsw do 
			Wait(10)
			SetEntityCoords(RollerUp,U.x,U.y,U.z+0.02)
			U=GetEntityCoords(RollerUp)
		end 
	end)
end

local function pointfolow(LfEJbh_,JD)
	SetVehicleDoorsShut(JD,true)
	TaskVehicleFollowWaypointRecording(GetPlayerPed(-1),JD,prop4,262144,0,546,-1,timer,false,1.25)
	VehicleWaypointPlaybackOverrideSpeed(JD,timer)
end

local function propscarwash()
	local u=CreateObject(GetHashKey(prop2),-699.97,-931.7,21.3,false,true,false)
	FreezeEntityPosition(u,true)
	SetEntityCollision(u,true,false)
	SetEntityInvincible(u,true)
	SetEntityCollision(u,false,false)
	spray.rollerUp=u;
	local pzDMZwG=vec3(-699.97,-935,17.9)
	local XPoQB=3.6
	local XxJ=CreateObject(GetHashKey(prop1),pzDMZwG,false,true,false)
	SetEntityHeading(XxJ,180.0)
	FreezeEntityPosition(XxJ,true)
	SetEntityCollision(XxJ,false,false)
	SetEntityCoordsNoOffset(XxJ,pzDMZwG,false,false,true)
	local o5sms=CreateObject(GetHashKey(prop1),-699.97,-938.8,20.8279,false,true,false)
	SetEntityHeading(o5sms,180.0)
	FreezeEntityPosition(o5sms,true)
	spray.lastSpray=o5sms
	local JQi1jg=CreateObject(GetHashKey(prop1),-699.97,-927.7,20.8279,false,true,false)
	SetEntityHeading(JQi1jg,0.0)
	FreezeEntityPosition(JQi1jg,true)
	spray.firstSpray=JQi1jg
	pzDMZwG=GetOffsetFromEntityInWorldCoords(XxJ,-XPoQB/2.0,0.0,1.5)
	local wVzn=CreateObject(GetHashKey(prop3),pzDMZwG,false,true,false)
	FreezeEntityPosition(wVzn,true)
	SetEntityCollision(wVzn,false,false)
	SetEntityInvincible(wVzn,true)
	SetEntityHasGravity(wVzn,false)
	SetEntityCoords(wVzn,pzDMZwG,true,false,false,true)
	spray.leftRoller=wVzn
	pzDMZwG=GetOffsetFromEntityInWorldCoords(XxJ,XPoQB/2.0,0.0,1.5)
	local pE=CreateObject(GetHashKey(prop3),pzDMZwG,false,true,false)
	FreezeEntityPosition(pE,true)
	SetEntityCollision(pE,false,false)
	SetEntityInvincible(pE,true)
	SetEntityHasGravity(pE,false)
	SetEntityCoords(pE,pzDMZwG,true,false,false,true)
	spray.rightRoller=pE 
end

local function partisoundreq()
	RequestScriptAudioBank("CARWASH_SOUNDS")
	RequestNamedPtfxAsset(prop5)
	while not HasNamedPtfxAssetLoaded(prop5)do 
		Wait(100)
	end;
	RequestAndWaitModel(prop1)
	RequestAndWaitModel(prop3)
	RequestAndWaitModel(prop2)
	RequestWaypointRecording(prop4)
	while not GetIsWaypointRecordingLoaded(prop4)do 
		Wait(0)
	end
	RemoveIpl("kt_carwash")
	RequestIpl("kt_carwash_nobrush")
end

local function fincarwashprops()
	SetModelAsNoLongerNeeded(prop3)
	SetModelAsNoLongerNeeded(prop1)
	SetModelAsNoLongerNeeded(prop2)
	if IsAudioSceneActive("CAR_WASH_SCENE")then 
		StopAudioScene("CAR_WASH_SCENE")
	end;
	RequestIpl("kt_carwash")
	RemoveIpl("kt_carwash_nobrush")
	for RSjapQ,QJf in pairs(spray)do 
		DeleteEntity(QJf)
	end 
end

local function commencercarwash()
	local pPed=GetPlayerPed(-1)
	local pVeh=GetVehiclePedIsIn(pPed, false)
	if not pVeh then 
		return 
	end;
	partisoundreq()
	propscarwash()
	SetEntityCoords(pVeh,-699.9,-922.75,17.84)
	SetEntityHeading(pVeh,headingveh)
	pointfolow(pPed,pVeh)
	Wait(2000)
	particles(pVeh,spray.firstSpray)
	finircarwash(pVeh)
	cordspart(pVeh)
	WashDecalsFromVehicle(pVeh,true)
	SetVehicleDirtLevel(pVeh,0)
	particles(pVeh,spray.lastSpray)
	Wait(1000)
	fincarwashprops()
	ShowAboveRadarMessage("~b~CarWash\n~s~Vous avez lavé votre ~b~"..GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(pVeh))).."~s~.")
	Joshualavage = false
	PlaySoundFrontend(-1, "Object_Dropped_Remote", "GTAO_FM_Events_Soundset", 0)
	PlaySoundFrontend(-1, "Out_Of_Bounds_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
	ClearPedTasks(pPed)
	Joshualavage = false
end;
local Joshualavage = false
Citizen.CreateThread(function()
	while true do
		local attente = 3000
		for _,v in pairs(poscar) do
			if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
				attente = 1000
				if Vdist2(GetEntityCoords(PlayerPedId(), false), v) < 7 then
					attente = 1
					DrawText3D(v.x, v.y, v.z+0.2, "Appuyez sur ~b~E~s~ pour ~b~laver votre véhicule~s~.", 9)
					if IsControlJustPressed(1,51) then
						if not Joshualavage then
							ESX.TriggerServerCallback('Lavage:buy', function(ok)
								Joshualavage = true
								if ok then
									commencercarwash()
								else
									ESX.ShowNotification("Vous n'avez pas assez ~r~d'argent~s~.")
								end
							end)
						end
					end
				end
			end
		end
		Wait(attente)
	end
end)