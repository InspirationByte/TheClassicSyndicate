----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- World Parameters --------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

world:SetLevelName("miamiclassic")
world:SetEnvironmentName("day_clear")
SetMusicName("frisco_night")

MISSION.LoadingScreen = "resources/loadingscreen_mcd.res"

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- Pre-Init Scenery --------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

function MISSION.SpawnSceneryCars()						-- Spawning NPC cars for scenery, pre-init
	local car1 = gameses:CreateCar("NPC_mcd_traffic01", CAR_TYPE_NORMAL)
	car1:SetOrigin( Vector3D.new(-84.5,0.77,-1143) )
	car1:SetAngles( Vector3D.new(180,0,180) )			-- Scenery items coords
	car1:Enable(false)
	car1:Spawn()
	car1:SetColorScheme(2)
	
	local car2 = gameses:CreateCar("NPC_mcd_traffic02", CAR_TYPE_NORMAL)
	car2:SetOrigin( Vector3D.new(-91.5,0.77,-1143) )
	car2:SetAngles( Vector3D.new(180,0,180) )
	car2:Enable(false)
	car2:Spawn()
	car2:SetColorScheme(0)
end


function MISSION.SpawnTrapCars()						-- Spawning NPC cars for trap

	local carDefs = {
		{"NPC_mcd_traffic01", 1, vec3(1720.20, 0.81, -2.77),vec3(179.77, 6.71, 179.97)},
		{"NPC_mcd_traffic02", 2, vec3(1707.65, 0.81, -10.81),vec3(-179.07, -63.55, 179.20)},
		{"NPC_mcd_traffic02", 0, vec3(1708.42, 0.81, -22.87),vec3(-0.05, -52.63, 0.06) },
		{"NPC_mcd_traffic02", 1, vec3(1732.00, 0.81, -18.50),vec3(-1.22, 82.14, -1.22)},
		{"NPC_mcd_traffic01", 2, vec3(1727.43, 0.81, -3.09),vec3(-179.34, 39.84, -179.57)},
		{"NPC_mcd_traffic02", 0, vec3(1723.88, 0.81, -30.89),vec3(-0.32, 15.25, -0.09)}
	}
	
	for k,v in ipairs(carDefs) do
		local car = gameses:CreateCar(v[1], CAR_TYPE_NORMAL)
		car:SetOrigin( v[3] )
		car:SetAngles( v[4] )
		car:Enable(false)
		car:Spawn()
		car:SetColorScheme(v[2])
	end
end

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- Mission Init ------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

MISSION.Init = function()									-- Preparing Introduction
	MISSION.Data = {
		targetPosition = Vector3D.new(1529,0.70,1256),			-- Targets Positions
		target2Position = Vector3D.new(1719,0.70,-16),
		--DEVTESTtargetPosition = Vector3D.new(-119,0.70,-1145),		
		--DEVTESTtarget2Position = Vector3D.new(-119,0.70,-1175),
	}
	
	MISSION.Settings.EnableCops = false						-- Cops are disabled

	MISSION.SpawnSceneryCars()

	local playerCar = gameses:CreateCar(McdGetPlayerCarName(), CAR_TYPE_NORMAL)	-- Create player car
	
	MISSION.playerCar = playerCar	-- Define spawned car above as player car for mission
	
	playerCar:SetMaxDamage(12.0)
	playerCar:SetOrigin( Vector3D.new(-88,0.77,-1143) )						--Player car properties
	--DEVTESTplayerCar:SetOrigin( Vector3D.new(-119,0.70,-1115) )	
	playerCar:SetAngles( Vector3D.new(0,180,0) )
	playerCar:Spawn()
	playerCar:SetColorScheme( 1 )
	playerCar:SetDriverType("ped2")

	sounds:Precache( "wind.mcd09" )
	sounds:Precache( "goon.wat" )

	-- For the load time, set player car
	gameses:SetPlayerCar( playerCar )
	
	playerCar:Lock(true)

	gameHUD:Enable(false)								-- HUD disabled
	gameHUD:FadeIn(false, 2.5)								-- Screen Fade-In (Duration)
	gameHUD:ShowScreenMessage("#MCD12_TITLE_BAIT", 3.5)				-- Classic title text (Duration)
	--gameHUD:ShowAlert("THE BANK JOB", 3.5, HUD_ALERT_NORMAL)		-- Syndicate title message (Duration)

-- DEVTEST position
	--playerCar:SetOrigin(vec3(1499.13, 0.81, 1253.37))
	--playerCar:SetAngles(vec3(3.31, -78.41, -3.25))

	MISSION.SetupFlybyCutscene()	-- Starting Introduction FlyBy Cutscene 
end

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- FlyBy Cutscenes ---------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

function MISSION.SetupFlybyCutscene()

	local playerCar = MISSION.playerCar		-- Define player car for current phase

	local targetView = cameraAnimator:GetComputedView()
	cameraAnimator:Update(0, gameses:GetPlayerCar())

	local cutCameras = {
		{
			{ targetView:GetOrigin() + vec3(6.0, 0, 0), targetView:GetAngles() + vec3(40,0,0), 0.0, targetView:GetFOV() },
			{ targetView:GetOrigin(), targetView:GetAngles(), 4.0, targetView:GetFOV() }
		}
	}

	McdCutsceneCamera.Start(cutCameras, MISSION.StartPause, 0)
	
	missionmanager:ScheduleEvent( function() 
		sounds:Emit( EmitParams.new("wind.mcd09"), -1 )
	end, 0.0);
end

function MISSION.StartPause()				-- Transition between Phase1Update and Phase1Start

	local playerCar = MISSION.playerCar

	gameHUD:Enable(true)

	missionmanager:SetRefreshFunc( function() 
		return false 
	end ) 

	missionmanager:ScheduleEvent( MISSION.Phase1Start, 1 )	-- Going into Phase1Start after 2 seconds
end

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- Phase1 Start ------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

function MISSION.Phase1Start()
	
	local playerCar = MISSION.playerCar		-- Define player car for current phase

	MISSION.Settings.EnableCops = true
	MISSION.Settings.StopCops = true
	MISSION.Settings.StopCopsRadius = 500
	MISSION.Settings.StopCopsEndThreshold = 0.7
	MISSION.Settings.StopCopsPosition = MISSION.Data.targetPosition
		
	gameHUD:Enable(true)
	playerCar:Lock(false)
	
	MISSION.targetHandle = gameHUD:AddMapTargetPoint(MISSION.Data.targetPosition)

	-- Here we start
	missionmanager:SetRefreshFunc( MISSION.Phase1Update )

	missionmanager:SetPluginRefreshFunc("ResiCarOBJ", function()	-- Spawn scenery when player enters % radius

		if length(playerCar:GetOrigin() - MISSION.Data.targetPosition) < 100 then	-- Set up function
			MISSION.Settings.StopCops = false
		
			local opponentCar = gameses:CreateCar("NPC_mcd_traffic01", CAR_TYPE_PURSUER_GANG_AI)
			MISSION.opponentCar = opponentCar
			
			opponentCar:SetOrigin( Vector3D.new(1529,0.70,1256) )
			opponentCar:SetAngles( Vector3D.new(180,0,180) )			-- Scenery items coords
			opponentCar:Enable(false)

			local aiComponent = opponentCar:GetComponent(PursuerAIComponent)
			aiComponent:SetAngryMode(PURSUER_PUPPYDOG)
			aiComponent:SetTorqueScale(1.0)
			aiComponent:SetMaxSpeed(140.0)
			
			opponentCar:Spawn()
			
			opponentCar:SetColorScheme(1)
			opponentCar:SetMaxDamage(1000.0)

			-- replace tracking object (if needed)
			gameHUD:RemoveTrackingObject(MISSION.targetHandle)
			MISSION.targetHandle = gameHUD:AddTrackingObject(opponentCar, HUD_DOBJ_IS_TARGET)
			
			opponentCar.onCarCollision = MISSION.TargetCarHit

			missionmanager:SetPluginRefreshFunc("ResiCarOBJ", nil)	-- Disengage plugin
		end
		
	end)

	gameHUD:ShowScreenMessage("#MCD12_OBJ_WRECK", 3.5)
	
	missionmanager:EnableTimeout( true, 155 ) -- Enable, time
end

MISSION.TargetCarHit = function(self, props)

	local playerCar = MISSION.playerCar
	local opponentCar = MISSION.opponentCar

	if props.hitBy == playerCar then
		opponentCar:Enable(true)
		
		local aiComponent = opponentCar:GetComponent(PursuerAIComponent)
		aiComponent:SetPursuitTarget( playerCar )
		aiComponent:BeginPursuit(0)
		ai:TrackCar(opponentCar)

		sounds:Emit( EmitParams.new("goon.wat"), -1 )

		opponentCar.onCarCollision = nil -- remove callback

		-- start the phase 2
		MISSION.Phase2Start()
	end
end

----------------------------------------------------------------------------------------------
-- Phase1 Update -----------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

MISSION.Phase1Update = function( delta )

	local playerCar = MISSION.playerCar		-- Define player car for current phase
	local distToTarget = length(playerCar:GetOrigin() - MISSION.Data.targetPosition)

	if distToTarget < 400.0 then						-- If player enters % meters radius, then..
		MISSION.Settings.EnableCops = false
	end
	
	return MISSION.UpdateAll(delta)
end

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- Phase1 Mission Mechanics ------------------------------------------------------------------
----------------------------------------------------------------------------------------------

function MISSION.OnDone()						-- Marker disappears after reached by player
	local playerCar = MISSION.playerCar

	local opponentCar = MISSION.opponentCar
	
	gameHUD:RemoveTrackingObject(MISSION.targetHandle)

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

function MISSION.OnFailed()

	local playerCar = MISSION.playerCar		-- Define player car for current phase

	local opponentCar = MISSION.opponentCar

	gameses:SignalMissionStatus( MIS_STATUS_FAILED, 4.0 )
	
	MISSION.playerCar:Lock(true)
	MISSION.opponentCar:Lock(true)
	
	missionmanager:SetRefreshFunc( function() 
		return false 
	end ) 

end

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- Phase2 Start ------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

function MISSION.Phase2Start()
	local playerCar = MISSION.playerCar			-- Define what the player car is for this phase

	gameHUD:RemoveTrackingObject(MISSION.targetHandle)		-- Remove marker
	
	-- disable stop cops, disable cops
	-- and force update cops state
	MISSION.Settings.EnableCops = false			-- Enable cops

	missionmanager:EnableTimeout( false )	-- Disable countdown timer
	missionmanager:ShowTime( true )			-- Enable countup timer
	
	MISSION.safeHouseTarget = MISSION.Data.target2Position
	MISSION.targetHandle = gameHUD:AddMapTargetPoint(MISSION.safeHouseTarget)
	
	-- Show objective message (Duration)
	gameHUD:ShowScreenMessage("#MCD12_OBJ_GETOUT", 3.5)

	missionmanager:SetPluginRefreshFunc("BaitTrapCars", function()	-- Spawn scenery when player enters % radius

		if length(playerCar:GetOrigin() - MISSION.Data.target2Position) < 80 then	-- Set up function
			MISSION.SpawnTrapCars()
			missionmanager:SetPluginRefreshFunc("BaitTrapCars", nil)	-- Disengage plugin
		end
		
	end)

	missionmanager:ScheduleEvent( function() 
		gameHUD:ShowScreenMessage("#MCD12_OBJ_DONTLOSE", 3.5)
		missionmanager:SetRefreshFunc( MISSION.Phase2Update )
	end, 3.5);
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

		gameHUD:ShowScreenMessage("#MCD12_OBJ_FAILED", 3.5)	--.. Display classic timeout text

		MISSION.OnDone()	-- Game Over
		
		missionmanager:SetRefreshFunc( function() 
			return false 
		end ) 
		
		gameses:SignalMissionStatus( MIS_STATUS_FAILED, 4.0 )
		return false
	end
	
	return true
end

----------------------------------------------------------------------------------------------
-- Phase2 Update -----------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

MISSION.Phase2Update = function( delta )

	local playerCar = MISSION.playerCar		-- Define player car for current phase
	local opponentCar = MISSION.opponentCar

	if playerCar:GetPursuedCount() == 0 then
		gameHUD:ShowScreenMessage("#MCD12_OBJ_LOST", 3.5)

		MISSION.OnFailed()	-- Game Over
		return false
	end
	
	local distToTarget = length(playerCar:GetOrigin() - MISSION.safeHouseTarget)
	if distToTarget < 5 then	-- If player enters % meter objective radius, then..
		
		local aiComponent = opponentCar:GetComponent(PursuerAIComponent)
		aiComponent:EndPursuit(false)
		
		MISSION.OnCompleted()		-- ..Mission completed
		
		missionmanager:ScheduleEvent( function() 
			opponentCar:Lock(true)
		end, 1);
	end
	
	return MISSION.UpdateAll(delta)
end

MISSION.DrawDebugImGui = function()

	if ImGui.BeginTabBar("M01TabBar", tab_bar_flags) then
		if ImGui.BeginTabItem("Checkpoints") then
			local playerCar = MISSION.playerCar

			if ImGui.Button("Goto Checkpoint 1") then
				playerCar:SetOrigin( vec3(1585.29, 0.68, 1217.85) )
				playerCar:SetAngles( vec3(179.94, -27.36, 179.71) )
			end

			ImGui.EndTabItem();
		end

		ImGui.EndTabBar()
	end
end
