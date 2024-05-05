----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- World Parameters --------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

world:SetLevelName("miamiclassic")
world:SetEnvironmentName("day_clear")
SetMusicName("miami_day")

MISSION.LoadingScreen = "resources/loadingscreen_mcd.res"

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- Mission Init ------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

local boatPath = {
	vec3(266.28, 0.67, -427.41),
	vec3(283.11, 0.66, -418.98),
	vec3(296.54, 0.66, -386.07),
	vec3(300.59, 0.66, -347.38),
	vec3(296.95, 0.66, -305.48),
	vec3(275.86, 0.66, -259.65),
	vec3(271.04, 0.66, -189.65),
	vec3(289.61, 0.67, -150.96),
	vec3(339.83, 0.66, -146.48),
	vec3(400.13, 0.66, -144.31),
	vec3(481.85, 0.66, -144.14),
	vec3(512.11, 1.16, -174.28),
	vec3(528.10, 0.67, -240.58),
	vec3(534.27, 0.66, -299.54),
	vec3(539.84, 0.66, -356.35),
	vec3(543.53, 0.66, -410.82),
	vec3(543.96, 0.66, -465.10),
	vec3(542.46, 0.66, -549.42),
	vec3(561.20, 0.66, -599.99),
	vec3(608.48, 0.66, -636.69),
	vec3(657.03, 0.66, -638.24),
	vec3(691.69, 0.66, -624.95),
	vec3(738.06, 0.66, -601.06),
	vec3(784.56, 0.66, -594.14),
	vec3(824.63, 1.27, -595.65),
	vec3(886.95, 0.67, -598.05),
	vec3(933.54, 0.66, -596.57),
	vec3(990.21, 0.66, -595.08),
	vec3(1030.50, 0.66, -595.36),
	vec3(1079.16, 0.67, -615.31),
	vec3(1081.67, 0.67, -622.69),
	vec3(1081.60, 0.67, -622.69)
}

MISSION.InitSceneryObject = function()
	local speedboatModel = "models/MIAMI/City/mcd_boat03.egf"
	
	-- water trail for the speedboat
	local defData = create_section {
		type = "smoke",
		atlas_textures = {"rain_drops"},
		color = {1, 1, 1, 1.0},
		gravity = -15.0,
		winddrift = 0.0,			-- particle wind drifting factor
		velocity = 2.0,
		dir_angles = {-90, 0, 0},	-- direction angle of emitting with specified velocity
		spread_angle = 50,			-- the randomized angle of particle spreading
		start_size = 2.0,
		end_size = 6.0,
		rotation = 150.0,			-- rotation through lifetime
		lifetime = 1.5,				-- seconds
		emitrate = 20,				-- particles per second
		position_spread = 0.5
	}

	objects:AddObjectDef("emitter", "speedboat_splashes", defData)
	
	local boatSettings = {
		staticShadowmap = false
	}
	
	local speedboatObject = objects:CreateGameObject("object", create_section(boatSettings))
	speedboatObject:SetModel(speedboatModel)
	speedboatObject:SetOrigin(boatPath[1])
	speedboatObject:SetAngles(vec3(0))
	speedboatObject:Spawn()
	
	local emitterObj = objects:CreateObject("speedboat_splashes")
	emitterObj:SetOrigin(boatPath[1])
	emitterObj:SetAngles(vec3(0))
	emitterObj:Spawn()
	
	MISSION.speedboatObject = speedboatObject
	
	local ACCELERATION_FACTOR = 2.0
	local MAX_SPEED = 22
	local PITCH_ANGLE = 0.4
	local YAW_ROTATION_SCALE = 2.0
	
	local time = 0
	local speed = 0
	local segmentPathAdvDist = 0
	local segment = 1
	local numSegments = #boatPath - 1
	
	local interpolatedPosition = boatPath[1]
	
	local forwardVector = normalize(boatPath[segment + 1] - boatPath[segment])
	local rotation = qrotateY(math.atan(forwardVector.z, forwardVector.x) - DEG2RAD(90))
	
	local prevForwardVector = forwardVector
	
	missionmanager:SetPluginRefreshFunc("SpeedboatRun", function(delta)
		local pointA = boatPath[segment]
		local pointB = boatPath[segment + 1]
		
		local segmentLen = length(pointA - pointB)
		local positionOnSegment = segmentPathAdvDist / segmentLen
		
		-- don't rotate into NaN at last point
		if segment < numSegments then
			prevForwardVector = forwardVector
			forwardVector = normalize(pointB - pointA)
		else
			forwardVector = prevForwardVector
		end
		
		local targetRotation = qrotateY(math.atan(forwardVector.z, forwardVector.x) - DEG2RAD(90))
		
		-- determine position on the segment
		local position = lerp(pointA, pointB, positionOnSegment)
		rotation = qslerp(rotation, targetRotation, delta * YAW_ROTATION_SCALE)
		
		-- wave effect
		local waveX = math.sin(time * 4.0)
		local waveZ = math.sin(time * speed * 0.1)
		
		-- apply directional rotation and also add pitch angle
		local quat = rotation * qrotateXYZ(DEG2RAD((speed + waveX * 6.0) * PITCH_ANGLE), 0, waveZ * 0.15)
		
		interpolatedPosition = lerp(interpolatedPosition, position, delta * 5.0)
		
		speedboatObject:SetOrigin(interpolatedPosition + vec3(0,(waveX + 0.5) * speed * 0.025,0))
		speedboatObject:SetAngles(VRAD2DEG(qeulers(quat)))

		-- also set emitter position
		-- but if it's speed is low, we hide the splashes under water
		emitterObj:SetOrigin(interpolatedPosition - forwardVector * vec3(4) + vec3(0,-(MAX_SPEED-speed) * 0.1,0))

		if segment > numSegments - 2 then
			-- decelerate if close to target
			speed = segmentLen * 0.25
		else
			-- accelerate
			speed = speed + ACCELERATION_FACTOR * delta
			
		end
		
		if speed > MAX_SPEED then
			speed = MAX_SPEED
		end
		
		time = time + delta
		
		-- stop to not overflow
		if segment < numSegments then
		
			-- move along segment
			segmentPathAdvDist = segmentPathAdvDist + delta * speed
			
			-- advance segment
			if segmentPathAdvDist > segmentLen then
				segmentPathAdvDist = segmentPathAdvDist - segmentLen
				segment = segment + 1
				angleFactor = 0
			end
		end
	end)
end

MISSION.Init = function()		
	MISSION.InitSceneryObject()
							-- Preparing Introduction
	MISSION.Data = {		-- Targets Positions
		targetPosition = Vector3D.new(1072,0.7,-646),
	}
	
	MISSION.Settings.EnableCops = true						-- Cops are disabled

	local playerCar = gameses:CreateCar(McdGetPlayerCarName(), CAR_TYPE_NORMAL)	-- Create player car
	
	MISSION.playerCar = playerCar	-- Define spawned car above as player car for mission

	SetMusicState(MUSIC_STATE_PURSUIT)
	
	playerCar:SetMaxDamage(12.0)
	playerCar:SetOrigin( Vector3D.new(224,0.7,-387) )						--Player car properties
	--DEVTESTplayerCar:SetOrigin( Vector3D.new(-119,0.70,-1115) )	
	playerCar:SetAngles( Vector3D.new(180,0,180) )
	playerCar:Spawn()
	playerCar:SetColorScheme( 1 )
	
	local restoreData = RestoreMissionCompletionData("mcd05b_playerCar")
	
	if restoreData ~= nil then	
		playerCar:SetOrigin(toVector(restoreData.position))
		playerCar:SetAngles(toVector(restoreData.angles))
		playerCar:SetDamage(restoreData.damage)
		playerCar:SetBodyDamage(restoreData.bodyDamage)
		playerCar:SetFelony(restoreData.felony)
	end
	
	-- For the load time, set player car
	gameses:SetPlayerCar( playerCar )
	
	playerCar:Lock(true)

	gameHUD:Enable(false)								-- HUD disabled
	gameHUD:FadeIn(false, 0.5)								-- Screen Fade-In (Duration)
	gameHUD:ShowScreenMessage("#MCD05_TITLE_CASEFORAKEY_CNTD", 3.5)				-- Classic title text (Duration)
	--gameHUD:ShowAlert("THE BANK JOB", 3.5, HUD_ALERT_NORMAL)		-- Syndicate title message (Duration)

	MISSION.StartPause()	-- Starting Introduction FlyBy Cutscene 
end

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- Phase1 Start ------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

function MISSION.Phase1Start()
	
	local playerCar = MISSION.playerCar		-- Define player car for current phase

	local felony = playerCar:GetFelony()
	if felony < 0.5 then
		felony = 0.5
	end
	playerCar:SetFelony(felony)

	MISSION.Settings.EnableCops = true
	MISSION.Settings.StopCops = true
	MISSION.Settings.StopCopsRadius = 300
	MISSION.Settings.StopCopsPosition = MISSION.Data.targetPosition
	
	gameHUD:Enable(true)
	playerCar:Lock(false)

	MISSION.finalTarget = 1
	
	MISSION.targetHandle = gameHUD:AddTrackingObject(MISSION.speedboatObject, HUD_DOBJ_IS_TARGET)
	MISSION.targetHandle2 = gameHUD:AddMapTargetPoint(MISSION.Data.targetPosition, HUD_DOBJ_3D_ARROW)

	-- Here we start
	missionmanager:SetRefreshFunc( MISSION.Phase1Update )

	missionmanager:SetPluginRefreshFunc("DodgeScenery", function()	-- Spawn scenery when player enters % radius

		if length(playerCar:GetOrigin() - MISSION.Data.targetPosition) < 300 then	-- Set up function

			local car1 = gameses:CreateCar("NPC_mcd_traffic01", CAR_TYPE_NORMAL)
			car1:SetOrigin( Vector3D.new(1090,0.7,-641) )
			car1:SetAngles( Vector3D.new(3,112,0) )			-- Scenery items coords
			car1:Enable(false)
			car1:Spawn()
			car1:SetColorScheme(5)
			
			local car2 = gameses:CreateCar("NPC_mcd_traffic01", CAR_TYPE_NORMAL)
			car2:SetOrigin( Vector3D.new(1088,0.7,-652) )
			car2:SetAngles( Vector3D.new(0,40,0) )
			car2:Enable(false)
			car2:Spawn()
			car2:SetColorScheme(3)

			missionmanager:SetPluginRefreshFunc("DodgeScenery", nil)	-- Disengage plugin
		end
		
	end)

	gameHUD:ShowScreenMessage("#MCD05_OBJ_CHASE", 3.5)
	
	missionmanager:EnableTimeout( true, 95 ) -- Enable, time
end

----------------------------------------------------------------------------------------------
-- Phase1 Update -----------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

MISSION.Phase1Update = function( delta )

	local playerCar = MISSION.playerCar		-- Define player car for current phase

	if length(MISSION.speedboatObject:GetOrigin() - playerCar:GetOrigin()) > 230 then
		gameHUD:ShowScreenMessage("#MCD05_OBJ_LOST", 3.5)
		gameses:SignalMissionStatus( MIS_STATUS_FAILED, 4.0 )

		MISSION.playerCar:Lock(true)
	
		missionmanager:SetRefreshFunc( function() 
			return false 
		end ) 
	end

	if MISSION.finalTarget then
		local distToTarget = length(playerCar:GetOrigin() - MISSION.Data.targetPosition)
		if distToTarget < 50 then	-- Cops are disabled when player enters % meters objective radius
			
			if distToTarget < 50 then	-- If player enters % meters radius while pursued, then..
				if playerCar:GetPursuedCount() > 0 then
					gameHUD:ShowScreenMessage("#LOSE_TAIL_MESSAGE", 1.5)	--.. Lost tail message on screen
				elseif distToTarget < 5 then	-- If player enters % meter objective radius, then..
					
					MISSION.OnCompleted()		-- ..Mission completed
				end
			end
		end
	end
	
	return MISSION.UpdateAll(delta)
end

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- Phases Mission Mechanics ------------------------------------------------------------------
----------------------------------------------------------------------------------------------

function MISSION.OnDone()						-- Marker disappears after reached by player
	local playerCar = MISSION.playerCar
	
	gameHUD:RemoveTrackingObject(MISSION.targetHandle)
	gameHUD:RemoveTrackingObject(MISSION.targetHandle2)

	playerCar:Lock(true)						-- Car is locked after reaching marker
	
	return true
end

function MISSION.OnCompleted()					-- Mission completed after all objectives are done
	MISSION.OnDone()
	
	missionmanager:SetRefreshFunc( function() 
		return false 
	end ) 
	
	gameses:SignalMissionStatus( MIS_STATUS_SUCCESS, 4.0 )

	-- Trigger MissionSuccess UI
	--gameHUD:ShowAlert("#MENU_GAME_TITLE_MISSION_SUCCESS", 3.5, HUD_ALERT_SUCCESS)		
	
	gameHUD:ShowScreenMessage("#MCD_WELLDONE", 3.5)
end

function MISSION.StartPause()						-- Marker disappears after reached by player
	local playerCar = MISSION.playerCar

	playerCar:Lock(true)						-- Car is locked after reaching marker
	
	gameHUD:Enable(true)
	
	missionmanager:ScheduleEvent( MISSION.Phase1Start, 2 ) 

	return true
end

MISSION.UpdateAll = function(delta)

	local camera = world:GetView()
	
	local playerCar = MISSION.playerCar		-- Define player car for current phase
	
	UpdateCops( playerCar, delta )

	-- Check player vehicle is wrecked
	if CheckVehicleIsWrecked( playerCar, MISSION.Data, delta ) then		-- If player car is wrecked, then..
		gameHUD:ShowAlert("#WRECKED_VEHICLE_MESSAGE", 3.5, HUD_ALERT_DANGER)	--.. Display wrecked message
		
		MISSION.OnDone()	-- Game Over
		
		missionmanager:SetRefreshFunc( function() 
			return false 
		end ) 

		gameses:SignalMissionStatus( MIS_STATUS_FAILED, 4.0 )
		return false
	end
	
	-- Check player's time is out
	if missionmanager:IsTimedOut() then		-- If player time is out, then..

		--gameHUD:ShowAlert("#TIME_UP_MESSAGE", 3.5, HUD_ALERT_DANGER)	--.. Display timeout message
		gameHUD:ShowScreenMessage("#MCD05_OBJ_FAILED", 3.5)	--.. Display classic timeout text

		MISSION.OnDone()	-- Game Over
		
		missionmanager:SetRefreshFunc( function() 
			return false 
		end ) 
		
		gameses:SignalMissionStatus( MIS_STATUS_FAILED, 4.0 )
		return false
	end
	
	return true
end
