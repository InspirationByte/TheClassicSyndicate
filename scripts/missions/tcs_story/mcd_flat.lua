
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- World Parameters --------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

local EQUI_CARSSELECTION_SCHEME_NAME = "ui_mainmenu_mcdmissioncar"
local carSelectionItems = include("scripts/lua/McdStoryCarSelection.lua")

world:SetLevelName("flatsclassic")
world:SetEnvironmentName("day_clear")
SetMusicName("")

MISSION.LoadingScreen = "resources/loadingscreen_mcd.res"
MISSION.EnableReplay = false
MISSION.Pausable = false

function MISSION.SpawnPlayerCar(carName)
	local car = gameses:CreateCar(carName or McdGetPlayerCarName(), CAR_TYPE_NORMAL)
	car:SetOrigin( Vector3D.new(-60.5,0.77,44.5) )
	car:SetAngles( Vector3D.new(180,0,180) )
	car:Enable(false)
	car:Spawn()
	car:SetColorScheme(1)
	MISSION.playerCar = car
	

	car:Lock(true)
end

function MISSION.SpawnSceneryCars()						-- Spawning NPC cars for scenery, pre-init
	local car = gameses:CreateCar("NPC_mcd_traffic01", CAR_TYPE_NORMAL)
	car:SetOrigin( Vector3D.new(-62.8,0.77,44.5) )
	car:SetAngles( Vector3D.new(180,0,180) )
	car:Enable(false)
	car:Spawn()
	car:SetColorScheme(4)
	gameses:SetPlayerCar(car)
	
	MISSION.SpawnPlayerCar()
end

function MISSION.OnPreferredCarChanged(carName)
	MISSION.playerCar:Remove()
	MISSION.playerCar = nil
	
	MISSION.SpawnPlayerCar(carName)
end

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- Mission Init ------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

local FlatGameMenuElements = function()
	return {
		MenuStack.MakeItem("#MENU_GAME_NEXTMISSION", true, {
			onEnter = function( self, stack )
				missionladder:OnMissionCompleted()
				missionladder:RunContinue()
				return { command = "nextState" }
			end,
		}),
		MenuStack.MakeItem("#MCD_FLAT_PLAYAGAIN", false, {
			onEnter = function(self, stack)
				MISSION.PlayMessage()
				return {}
			end,
		}),
		MenuStack.MakeSubMenu("#MCD_FLAT_CHOOSECAR", carSelectionItems, nil, EQUI_CARSSELECTION_SCHEME_NAME),
		MenuStack.MakeCommand("#MENU_GAME_EXIT", "quitToMainMenu", true)
	}
end

local FlatGameMenuStack = MenuStack( FlatGameMenuElements )

MISSION.PlayMessage = function()
	MISSION.Data.soundObj:Emit(0, MISSION.Data.machineAudio)
	gameses:SignalMissionStatus( MIS_STATUS_INGAME, 0 )
	missionmanager:ScheduleEvent( function()
		gameses:SignalMissionStatus( MIS_STATUS_SUCCESS, 0.0 )
	end, MISSION.MessageLength or 10)
end

MISSION.Init = function()									-- Preparing Introduction
	MISSION.Data = {
		targetPosition = Vector3D.new(-54,0.70,69),			-- Targets Positions
		target2Position = Vector3D.new(1719,0.70,-603),
		soundObj = CSoundingObject.new()
	}
	
	local cutCameras = {
		{
			{ Vector3D.new(-57.50, 0.50, 33), Vector3D.new(6, 360, 20), -5, 50 },
			{ Vector3D.new(-59.50, 1.40, 38.0), Vector3D.new(10 ,372, -5), 4, 50 },	
		},
		{
			{ Vector3D.new(-59.50, 1.40, 38.0), Vector3D.new(10 ,372, -5), 0, 50 },	
			{ Vector3D.new(-59.50, 1.40, 38.0), Vector3D.new(10 ,372, -5), 90000, 50 },	
		}
	}
	
	MISSION.Settings.EnableCops = false						-- Cops are disabled
	MISSION.Settings.EnableTraffic = false
	MISSION.SpawnSceneryCars()

	-- precache sounds
	sounds:LoadScript(EmitterSounds.MCDMessages)
	sounds:Precache( "d3.citynoise" )
	sounds:Precache( "wind.msg01" )

	gameHUD:Enable(false)								-- HUD disabled
	gameHUD:FadeIn(true, 0.60)							-- Screen Fade-In (Duration)
	
	CurrentGameMenuTable = {
		Ingame = FlatGameMenuStack,
		MissionSuccess = FlatGameMenuStack,
		MissionFailed = FlatGameMenuStack,
	}

	missionmanager:ScheduleEvent( function() 
		local messageId = missionladder:GetCurrentMission().message
		local message = MISSION.MessageList[messageId]

		-- set the message
		MISSION.MessageScript = message.script
		MISSION.MessageLength = message.length
		MISSION.MessageDelay = message.delay
		MISSION.AnsweringMachinePosition = iif(message.flatId ~= nil, MISSION.AnsweringMachines[message.flatId], MISSION.AnsweringMachines[1])
		sounds:Precache( MISSION.MessageScript )
		
		MISSION.Data.machineAudio = EmitParams.new(MISSION.MessageScript, MISSION.AnsweringMachinePosition)
		
		world:SetEnvironmentName(message.environment or "day_clear")
		world:InitEnvironment()

		missionmanager:ScheduleEvent( function()
			MISSION.PlayMessage()
		end, MISSION.MessageDelay or 1)
	end, 0)

	MISSION.Data.soundObj:Emit(1, EmitParams.new("wind.msg01") )
	MISSION.Data.soundObj:Emit(2, EmitParams.new("d3.citynoise", vec3(-88,0.77,-1143)))
	McdCutsceneCamera.Start(cutCameras, nil, 1000) -- make wait forever
end

MISSION.Finalize = function()
	sounds:FreeScript(EmitterSounds.MCDMessages)
end