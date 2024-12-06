-- ModInit for Syndicate's Classic Mod

-- Hey man, good luck in the future, both for your game and your own future, see ya ! #_matti

local ModInit = {
	Title = "The Classic Syndicate",

	CreatedBy = "_matti, Soapy, Nik",
	Version = "1.8.0",
	
	PreBoot = false,

	Conflicts = {}
}

McdPrefferedStoryCar = "mcd_miamidef"
local EQUI_CARSSELECTION_SCHEME_NAME = "ui_mainmenu_mcdmissioncar"

-------------------------------------------------------------------------------

-- Mod Vocabulary:

-- dsd		= desert data

-- pkd		= parking data

-- mcd 		= miami classic data
-- mcdpages = miami classic data (mainly for models)

-- sfd		= san francisco data
-- sfdpages	= san francisco data (mainly for models)

-- lad		= los angeles data
-- ladpages = los angeles data (mainly for models)

-- nyd		= new york data
-- nydpages	= new york data (mainly for models)

-------------------------------------------------------------------------------

-- Missions Index (Menu)
local MiamiMissionsIdx = -1

-- Miami (Classic) Missions
local MiamiMissionsList = {
	{
		id = "intro",
		screen = "story_movie_play", 
		args = "render02.mpg" 
	},
	{
		id = "mcd00", 
		label = "Interview" 
	},
	{
		id = "mcd_flat_nextmessage", 
		message = "mcd01", 
		label = "The Bank Job (motel intro)"
	},
	{
		id = "mcd01", 
		label = "The Bank Job"
	},
	{
		id = "mcd_flat_nextmessage", 
		message = "mcd02", 
		label = "Hide The Evidence (motel intro)"
	},
	{
		id = "mcd02", 
		label = "Hide The Evidence" 
	},
	{
		id = "mcd_flat_nextmessage",
		message = "mcd03",
		label = "Ticco's Ride (motel intro)"
	},
	{
		id = "mcd03",
		label = "Ticco's Ride" 
	},
	{
		id = "cleanup_movie",
		screen = "story_movie_play",
		args = {"render51.mpg", "message.call_cleanup"} 
	},
	{
		id = "mcd04a",
		label = "The Clean Up (Part 1)" 
	},
	{
		id = "mcd04b",
		label = "The Clean Up (Part 2)" 
	},
	{
		id = "mcd_flat_nextmessage",
		message = "mcd05a",
		label = "Case For A Key (motel intro)"
	},
	{
		id = "mcd05a", 
		label = "Case For A Key"
	},
	{
		id = "boatchase_movie_1",
		screen = "story_movie_play",
		args = "render24.mpg"
	},
	{
		id = "mcd05b",
		label = "Case For A Key (Part 2)" 
	},
	{
		id = "boatchase_movie_2",
		screen = "story_movie_play",
		args = "render65.mpg"
	},
	{
		id = "mcd05c",
		label = "Case For A Key (Part 3)"
	},
	{
		id = "boatchase_movie_end",
		screen = "story_movie_play",
		args = "render25.mpg"
	},
	{
		id = "mcd_flat_nextmessage",
		message = "mcd06",
		label = "Tanner Meets Rufus (motel intro)"
	},
	{
		id = "mcd06", 
		label = "Tanner Meets Rufus" 
	},
	{
		id = "rufus_bustoutjeanpaul_movie", 
		screen = "story_movie_play", 
		args = "render01.mpg"
	},
	{
		id = "mcd07a_activelife", 
		label = "Bust Out Jean Paul" 
	},
	{
		id = "mcd07b", 
		label = "Bust Out Jean Paul (Part 2)"
	},
	{
		id = "mcd_flat_nextmessage",
		message = "mcd08",
		label = "Payback (motel intro)"
	},
	{
		id = "payback_movie",
		screen = "story_movie_play",
		args = {"render59.mpg", "message.call_payback"}
	},
	{
		id = "mcd08", 
		label = "Payback" 
	},
	{
		id = "shipment_movie",
		screen = "story_movie_play",
		args = {"render56.mpg", "message.call_shipment"} 
	},
	{
		id = "mcd09", 
		label = "A Shipment's Coming In"
	},
	{
		id = "mcd_flat_nextmessage",
		message = "mcd10",
		label = "Superfly Drive (motel intro)"
	},
	{
		id = "mcd10",
		label = "Superfly Drive"
	},
	{
		id = "mcd_flat_nextmessage",
		message = "mcd11",
		label = "Take Out Di Angio's Car (motel intro)"
	},
	{
		id = "diangio_movie",
		screen = "story_movie_play",
		args = {"render59.mpg", "message.call_diangio"}
	},
	{
		id = "mcd11_activelife",
		label = "Take Out Di Angio's Car"
	},
	{
		id = "mcd_flat_nextmessage",
		message = "mcd12",
		label = "Bait for a Trap (motel intro)"
	},
	{
		id = "baitforatrap_movie",
		screen = "story_movie_play",
		args = {"render59.mpg", "message.call_baitforatrap"}
	},
	{
		id = "mcd12_activelife",
		label = "Bait for a Trap"
	},
	{
		id = "informant_movie",
		screen = "story_movie_play",
		args = "render03.mpg"
	},
	{
		id = "mcd13",
		label = "The Informant"
	},
	{
		id = "informant_end",
		screen = "story_movie_play",
		args = "render05.mpg"
	},
	{
		id = "ending", 
		screen = "story_miamiclassic_end"
	}
}

local MyLevelFileName = "MiamiClassic"
local ParkingLevelName = "iviewclassic"
local MyLevelFileName2 = "FriscoClassic"

local McdLevelNames = {
	MyLevelFileName,
	ParkingLevelName,
	MyLevelFileName2,
}

local ClassicCars = {
	{"m_default_ios", "TCS - Skylark"},			-- Miami
	{"m_fairlane_ios", "TCS - Fairlane"},		-- Frisco
	{"m_bonneville_ios", "TCS - Bonneville"},	-- LA
	{"m_evidence_ios", "TCS - Evidence"},		-- NYC
	
	{"m_superfly_ios", "TCS - Superfly"},
	{"m_continental_ios", "TCS - Continental"},
	{"m_truck_ios", "TCS - Bomb Truck"},
	{"m_chevess_ios", "TCS - Chevelle SS"},
	{"m_chevelle_ios", "TCS - Chevelle"},
	{"m_camaro_ios", "TCS - Camaro"},
	{"m_taxi_ios", "TCS - Taxi"},
	{"m_torino_ios", "TCS - Torino"},
	{"m_deville_ios", "TCS - DeVille"},
	{"m_police_ios", "TCS - Police"},
	{"m_250gt_ios", "TCS - 250 GT"},
}

-- TODO: unlock with cheats or completion of story
local UnlockableCars = {
	{"mcd_miamidef", "TCS - Miami PSX Car"},
	{"mcd_superflydrive", "TCS - Superfly Drive Car"},			
	{"mcd_defaultpolicecar_black", "TCS - NYC Police"},
	{"NPC_mcd_traffic01", "TCS - Traffic 1"},
	{"NPC_mcd_traffic02", "TCS - Traffic 2"},
	{"mcd_miamibetagsx", "TCS - Yellow GSX Car"},
	{"mcd_miamievidence", "TCS - NYC PC Car"},	
	{"mcd_miamidef_PC", "TCS - Miami PC Car"},
	{"mcd_miamicleanup", "TCS - The Clean Up Car"},
	{"mcd_miamidef_mini", "TCS - Miami PSX Car (MINI)"},

	{"sfd_friscodef", "TCS - Frisco PSX Car"},
}

local MyCopSoundsFilename = "scripts/sounds/mcd_cops.txt"

function IsMyLevel()
	local levName = string.lower(world:GetLevelName())

	for i,n in ipairs(McdLevelNames) do
		if string.lower(n) == levName then
			return true
		end
	end
	
	return false
end

-- Initialization function
function ModInit:Init()
	
	localize.AddTokensFile("mcd_missions")
	fonts.LoadFontDescriptionFile("resources/additional_fonts.res")

	-- make MCD camera available
	include("scripts/lua/McdCinematicCamera.lua")
	include("scripts/lua/McdHud.lua")
	include("scripts/lua/ui/StoryMiamiClassicEndScreen.lua")
	include("scripts/lua/ui/StoryMoviePlay.lua")
	storySelectionItems = include("scripts/lua/McdStoryCarSelection.lua")

	EmitterSoundRegistry.MCDEngine = "scripts/sounds/mcd_engine.txt"				-- Driver 1 engine sounds
	EmitterSoundRegistry.MCDVoices = "scripts/sounds/mcd_missions_vo.txt"			-- Driver 1 original mission voices
	EmitterSoundRegistry.MCDSfx = "scripts/sounds/mcd_csfx.txt"						-- SFX for cameras / transitions
	EmitterSoundRegistry.MCDMessages = "scripts/sounds/mcd_missions_messages.txt"	-- Vocal messages
	EmitterSoundRegistry.MCDObjects = "scripts/sounds/mcd_objects.txt"				-- Objects SFX
	
	CopVoiceOver[MyLevelFileName] = MyCopSoundsFilename;	-- Define what cop sounds script a level uses
	CopVoiceOver[MyLevelFileName2] = MyCopSoundsFilename;
	CopVoiceOver[ParkingLevelName] = MyCopSoundsFilename;
	
	CopVoiceOver[string.lower(MyLevelFileName)] = MyCopSoundsFilename;
	CopVoiceOver[string.lower(MyLevelFileName2)] = MyCopSoundsFilename;
	CopVoiceOver[string.lower(ParkingLevelName)] = MyCopSoundsFilename;
	
	-- Change music state logic
    OldMakeDefaultMissionSettings = MakeDefaultMissionSettings
    MakeDefaultMissionSettings = function()
    
		local settings = OldMakeDefaultMissionSettings()
		
		settings.KeepPursuitMusic = IsMyLevel()
		
		return settings
	end

	CityTimeOfDayMusic[MyLevelFileName] = {			-- Music selection for Miami (Classic)
		day_clear = "miami_day",
		day_stormy = "la_day",
		dawn_clear = "frisco_night",
		night_clear = "miami_night",
		night_stormy = "nyc_night"
	}

	CityTimeOfDayMusic[MyLevelFileName2] = {			-- Music selection for Miami (Classic)
		day_clear = "frisco_day",
		day_stormy = "la_day",
		dawn_clear = "frisco_night",
		night_clear = "frisco_night",
		night_stormy = "nyc_night"
	}

	-----------------------------------------------------------
	-- Classic Content (Map / Vehicles / Missions / Minigames) --
	-----------------------------------------------------------

	
	-- add levels
	table.insert(MenuCityList, {MyLevelFileName, "Miami (Classic)"})			-- Miami Classic
	table.insert(MenuCityList, {ParkingLevelName, "Parking (Classic)"})			-- Parking Classic
	table.insert(MenuCityList, {MyLevelFileName2, "Frisco (Classic)"})			-- Miami Classic

	-- add cars
	for i,v in ipairs(ClassicCars) do
		table.insert(MenuCarsList, v)
	end

	-- Add missions
	missions["tcs_story"] = MiamiMissionsList

	-- Miami (Classic) Minigames
	table.insert(missions["minigame/survival"], {"mcd_srv01", "Miami Classic (Miami Beach)"})
	table.insert(missions["minigame/survival"], {"mcd_srv02", "Miami Classic (Downtown)"})
	table.insert(missions["minigame/survival"], {"mcd_srv03", "Miami Classic (Coral Gables)"})

	local MiamiMissionsElems = 
	{
		{
			label = "#MENU_SYNDICATE_NEWGAME",
			isFinal = true,
			onEnter = function(self, stack)
			
				-- Reset and run ladder
				missionladder:Run( "tcs_story", missions["tcs_story"] )

				return {}
			end,
		},
	}
	
	MiamiMissionsIdx = table.insert(StoryGameExtraElems, 
		MenuStack.MakeSubMenu("Miami - Classic Missions", storySelectionItems, nil, EQUI_CARSSELECTION_SCHEME_NAME))
end

-- Deinitialization function
function ModInit:DeInit()
	localize.RemoveTokensFile("mcd_missions")
	
	EmitterSoundRegistry.MCDEngine = nil			-- Driver 1 engine sounds
	EmitterSoundRegistry.MCDIview = nil				-- Default Interview resources
	EmitterSoundRegistry.MCDVoices = nil			-- Driver 1 missions voices
	EmitterSoundRegistry.MCDSfx = nil				-- Cutscenes SFX
	EmitterSoundRegistry.MCDMessages = nil			-- Vocal messages SFX
	EmitterSoundRegistry.MCDObjects = nil			-- Gameplay SFX

	McdCutsceneCamera = nil

-- Deinit - Missions

	table.remove(StoryGameExtraElems, MiamiMissionsIdx)
	
	-- Remove Miami (Classic) Minigames
	table.remove(missions["minigame/survival"], mcd_srv01)
	table.remove(missions["minigame/survival"], mcd_srv02)
	table.remove(missions["minigame/survival"], mcd_srv03)

	missions["tcs_story"] = nil		-- Remove Miami (Classic) missions

	-- Deinit - Maps
	for i,v in ipairs(MenuCityList) do
	
		for ii,vv in ipairs(McdLevelNames) do
			if v[1] == vv then
				--table.remove( MenuCityList, i)
				MenuCityList[i] = nil
			end
		end
	end

	-- Deinit - Cars - MIAMI
	for i,v in ipairs(MenuCarsList) do
	
		for ii,vv in ipairs(ClassicCars) do
			if vv[1] == v[1] then
				--table.remove( MenuCarsList, i)
				MenuCarsList[i] = nil
			end
		end
	end
end

return ModInit
