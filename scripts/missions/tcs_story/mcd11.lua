----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- World Parameters --------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

world:SetLevelName("miamiclassic")
world:SetEnvironmentName("night_clear")
SetMusicName("la_night")

MISSION.LoadingScreen = "resources/loadingscreen_mcd.res"

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- Mission Init ------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

MISSION.PlayerRubberBandingParams = {
	[15.0] = {
		torqueScale = 1.0,
		maxSpeed = 135,
	},
	[40.0] = {
		torqueScale = 1.15,
		maxSpeed = 150,
	},
	[3000.0] = {
		torqueScale = 1.45,
		maxSpeed = 175,
	}
}

MISSION.replayId = 1

MISSION.PursuitDEVMODE = false

MISSION.DrawDebugImGui = function()
	local Data = MISSION.Data
	ImGui.TextColored(1.0, 1.0, 1.0, 0.5, "Replay ID " .. MISSION.replayId)

	if ImGui.Button("Restart in Dev Mode") then
		MISSION.PursuitDEVMODE = true
		console.ExecuteString("restart")
	end

	if ImGui.Button("Restart in Game Mode") then
		MISSION.PursuitDEVMODE = false
		console.ExecuteString("restart")
	end
end

MISSION.Init = function()									-- Preparing Introduction
	MISSION.Data = {
		targetPosition = Vector3D.new(0,0,0),		
	}
	
	MISSION.Settings.EnableCops = false						-- Cops are disabled
	MISSION.Settings.EnableTraffic = false

	local playerCar = gameses:CreateCar(McdGetPlayerCarName(), CAR_TYPE_NORMAL)	-- Create player car
	
	MISSION.playerCar = playerCar	-- Define spawned car above as player car for mission
	
	playerCar:SetMaxDamage(12.0)
	playerCar:SetOrigin( Vector3D.new(1860,0.70,-642) )						--Player car properties
	playerCar:SetAngles( Vector3D.new(0,-45,0) )
	playerCar:Spawn()
	playerCar:SetColorScheme( 1 )
	playerCar:SetMaxSpeed(170)
	playerCar:SetTorqueScale(1.2)
	playerCar:SetDriverType("ped2")

	sounds:Precache( "wind.mcd11a" )

	missionmanager:ScheduleEvent( function() 
		sounds:Emit( EmitParams.new("wind.mcd11a"), 0 )
	end, 1.8);

	missionmanager:ScheduleEvent( MISSION.RemoveAllCars, 0 )	-- Going into Phase2Start after 2 seconds

	--gameHUD:Enable(false)
	playerCar:Lock(true)

	gameHUD:Enable(false)								-- HUD disabled
	gameHUD:FadeIn(false, 2.5)								-- Screen Fade-In (Duration)
	gameHUD:ShowScreenMessage("#MCD11_TITLE_DIANGIO", 3.5)				-- Classic title text (Duration)

----------------------------------------------------------------------------------------------
-- Opponent Car ------------------------------------------------------------------------------

	local opponentCar = gameses:CreateCar("NPC_mcd_traffic02", CAR_TYPE_NORMAL)
	MISSION.opponentCar = opponentCar
	opponentCar:SetMaxDamage(5000)
	
	-- opponent initial position
	opponentCar:SetOrigin( Vector3D.new(1890, 0.70, -606) )
	opponentCar:SetAngles( Vector3D.new(0, 0, 0) )

	opponentCar:Spawn()
	opponentCar:SetColorScheme( 3 )
	opponentCar:SetInfiniteMass(true)
	opponentCar:SetLight(0, false)
	
	opponentCar.onCarCollision = MISSION.OpponentHit
	
	MISSION.Settings.EnableCops = false

	-- for the load time, set player car
	gameses:SetPlayerCar( playerCar )
	gameses:SetLeadCar( opponentCar )
	
	MISSION.RandomSeed = MISSION.replayId
	MISSION.CurrentReplayId = MISSION.replayId
	
	MISSION.replayId = MISSION.replayId + 1		-- Every time the suffix of replay file name will change
	
	if MISSION.replayId > 3 then
		MISSION.replayId = 1					-- replay_1, replay_2, etc
	end

	if MISSION.PursuitDEVMODE then
		gameses:SetPlayerCar( opponentCar )
		gameHUD:Enable(true)
		opponentCar:Lock(false)
		missionmanager:EnableTimeout( true, 90 ) -- enable, time
		MISSION.Settings.EnableTraffic = true
	else
		MISSION.SetupFlybyCutscene()	-- Starting Introduction FlyBy Cutscene 
	end
end

MISSION.JeanPaulSartre = function()

	-- replay must be reset
	gameses:LoadCarReplay(MISSION.opponentCar, "replayData/diangio01_" .. MISSION.CurrentReplayId)

	local playerCar = MISSION.playerCar		-- Define player car for current phase
	local opponentCar = MISSION.opponentCar

	missionmanager:ScheduleEvent( function() 
		opponentCar:SetLight(CAR_LIGHT_LOWBEAMS, true);
	end, 1.5)

	missionmanager:ScheduleEvent( MISSION.RemoveAllCars, 0 )	-- Going into Phase2Start after 2 seconds

	gameHUD:Enable(true)
	playerCar:Lock(false)
	
	MISSION.targetHandle = gameHUD:AddTrackingObject(MISSION.opponentCar, HUD_DOBJ_IS_TARGET + HUD_DOBJ_CAR_DAMAGE)

	missionmanager:EnableTimeout( true, 130 ) -- enable, time

	-- here we start
	missionmanager:SetRefreshFunc( MISSION.Update )
	
	gameHUD:ShowScreenMessage("#MCD11_OBJ_RAM", 3.5)
end

--------------------------------------------------------------------------------

function MISSION.RemoveAllCars()					-- Mission completed after all objectives are done
	ai:RemoveAllCars()
		--ai:SetTrafficCarsEnabled(false)
end

function MISSION.OnCompleted()					-- Mission completed after all objectives are done

	local playerCar = MISSION.playerCar
	local opponentCar = MISSION.opponentCar

	-- show message and signal success
	gameHUD:ShowScreenMessage("#MCD_GOODJOB", 3.5)

	gameses:SignalMissionStatus( MIS_STATUS_SUCCESS, 2.5, function()
	end)

	MISSION.ReleaseTarget()

	-- lock all the cars
	playerCar:Lock(true)						-- Car is locked after reaching marker
	opponentCar:Lock(true)

	-- stop the vehicle playing loaded frames
	gameses:StopCarReplay(opponentCar);
	opponentCar:SetInfiniteMass(false)

	missionmanager:SetRefreshFunc( function() 
		return false 
	end )
end

function MISSION.OpponentHit(self, props)

	local opponentCar = MISSION.opponentCar
	local playerCar = MISSION.playerCar

	-- if hit by player car, add huge damage number
	if props.hitBy == playerCar and props.velocity > 4 then
		opponentCar:SetDamage(opponentCar:GetDamage() + 1000)
	end
end

function MISSION.ReleaseTarget()
	if MISSION.targetHandle ~= nil then
		gameHUD:RemoveTrackingObject(MISSION.targetHandle)
		MISSION.targetHandle = nil
	end
end

function MISSION.OnFailed()

	local playerCar = MISSION.playerCar		-- Define player car for current phase

	gameses:SignalMissionStatus( MIS_STATUS_FAILED, 4.0 )

	MISSION.ReleaseTarget()
	
	gameses:SetLeadCar( MISSION.playerCar )
	MISSION.playerCar:Lock(true)
	
	missionmanager:SetRefreshFunc( function() 
		return false 
	end ) 

end

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- FlyBy Cutscenes ---------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

function MISSION.SetupFlybyCutscene()

	local playerCar = MISSION.playerCar		-- Define player car for current phase

	MISSION.cutCameraSet = 1
	MISSION.cutCameraIndex = 1
	MISSION.cutCameraTime = 0.0
	
	local targetView = cameraAnimator:GetComputedView()
	cameraAnimator:Update(0, gameses:GetPlayerCar())

	MISSION.cutCameras = {
		{
			{ Vector3D.new(1886, 4, -610), Vector3D.new(30, -60, -20), 0, targetView:GetFOV() },
			{ Vector3D.new(1886, 4, -610), Vector3D.new(20, -40, 0), 0.25, targetView:GetFOV() },
			{ Vector3D.new(1886, 1.5, -610), Vector3D.new(6, -40, 0), 2, targetView:GetFOV() },
			{ Vector3D.new(1855, 2.5, -648), Vector3D.new(0, -40, 0), 2.5, targetView:GetFOV() },
			{ targetView:GetOrigin(), targetView:GetAngles(), 3.0, targetView:GetFOV() },
			{ targetView:GetOrigin(), targetView:GetAngles(), 3.5, targetView:GetFOV() },
			{ targetView:GetOrigin(), targetView:GetAngles(), 4.0, targetView:GetFOV() },
			{ targetView:GetOrigin(), targetView:GetAngles(), 4.5, targetView:GetFOV() }
		}
	}

	MISSION.cutCameraAppr = MISSION.cutCameras[MISSION.cutCameraSet][MISSION.cutCameraIndex]

	-- Setup cameras
	cameraAnimator:SetScripted(true)

	missionmanager:SetRefreshFunc( function(delta)
	
		MISSION.cutCameraTime = MISSION.cutCameraTime + delta
	
		local camera = MISSION.cutCameras[MISSION.cutCameraSet][MISSION.cutCameraIndex]
		local nextCamera = MISSION.cutCameras[MISSION.cutCameraSet][MISSION.cutCameraIndex+1]
		
		if nextCamera ~= nil then
			if MISSION.cutCameraTime > nextCamera[3] then
				MISSION.cutCameraIndex = MISSION.cutCameraIndex + 1
			end
		else
			MISSION.cutCameraSet = MISSION.cutCameraSet + 1
			MISSION.cutCameraIndex = 1
			MISSION.cutCameraTime = 0
			
			
			if MISSION.cutCameraSet > #MISSION.cutCameras then
				Msg("END FLYBY")
				cameraAnimator:SetScripted(false)
				cameraAnimator:SetMode( CAM_MODE_OUTCAR )
				MISSION.StartPause()
			else
				MISSION.cutCameraAppr = MISSION.cutCameras[MISSION.cutCameraSet][MISSION.cutCameraIndex]
			end
			
			return
		end
		
		local cameraLerp = RemapValClamp(MISSION.cutCameraTime, camera[3], nextCamera[3], 0.0, 1.0)
		
		local cameraPos = lerp(camera[1], nextCamera[1], cameraLerp)
		local cameraRot = lerp(camera[2], nextCamera[2], cameraLerp)
		
		MISSION.cutCameraAppr[1] = lerp(MISSION.cutCameraAppr[1], cameraPos, delta*3.0 )
		MISSION.cutCameraAppr[2] = lerp(MISSION.cutCameraAppr[2], cameraRot, delta*3.0 )
		
		cameraAnimator:SetOrigin( MISSION.cutCameraAppr[1] )
		cameraAnimator:SetAngles( MISSION.cutCameraAppr[2] )
		cameraAnimator:SetFOV(camera[4])
		cameraAnimator:SetMode( CAM_MODE_TRIPOD )

		cameraAnimator:Update(delta, MISSION.playerCar)
		
		return true
	end )
end

function MISSION.StartPause()				-- Transition between Phase1Update and Phase2Start

	local playerCar = MISSION.playerCar

	gameHUD:Enable(true)

	missionmanager:SetRefreshFunc( function() 
		return false 
	end ) 

	missionmanager:ScheduleEvent( MISSION.JeanPaulSartre, 1 )	-- Going into Phase2Start after 2 seconds
end

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- JeanPaulSartre Mission Mechanics ----------------------------------------------------------
----------------------------------------------------------------------------------------------

MISSION.Update = function( delta )

	local curView = world:GetView()
	local arrowObject = MISSION.arrowObject
	local opponentCar = MISSION.opponentCar
	local playerCar = MISSION.playerCar

	-- update player rubber banding
	UpdateRubberBanding(playerCar, opponentCar:GetOrigin(), MISSION.PlayerRubberBandingParams)	

	-- check player vehicle is wrecked
	if CheckVehicleIsWrecked( playerCar, MISSION.Data, delta ) then
		gameHUD:ShowAlert("#WRECKED_VEHICLE_MESSAGE", 3.5, HUD_ALERT_DANGER)
		
		MISSION.OnFailed()
		
		missionmanager:SetRefreshFunc( function() 
			return false 
		end ) 

		gameses:SignalMissionStatus( MIS_STATUS_FAILED, 4.0 )
		return false
	end
	
	-- check opponent vehicle is wrecked
	if opponentCar:IsAlive() then
	
		-- check the timer
		if missionmanager:IsTimedOut() then
			gameHUD:ShowScreenMessage("#MCD11_OBJ_FAILED", 3.5)
			
			MISSION.OnFailed()
		end
	
		-- check distance between the car and timer
		if (length(playerCar:GetOrigin() - opponentCar:GetOrigin()) > 120) then

			gameHUD:ShowScreenMessage("#MCD11_OBJ_LOST", 3.5)
			
			MISSION.OnFailed()
		end
	else -- not alive - completed
		MISSION.OnCompleted()		
	end
	
	return true
end
