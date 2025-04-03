-- ModInit for Syndicate's Classic Mod

local ModInit = {
	Title = "The Classic Syndicate",

	CreatedBy = "_matti, Soapy, Nik",
	Version = "1.8.2",
	
	PreBoot = false,

	Conflicts = {}
}

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
		id = "m_00", 
		label = "Interview" 
	},
	{
		id = "m_flat_nextmessage", 
		message = "m_01", 
		label = "The Bank Job (motel intro)"
	},
	{
		id = "m_01", 
		label = "The Bank Job"
	},
	{
		id = "m_flat_nextmessage", 
		message = "m_02", 
		label = "Hide The Evidence (motel intro)"
	},
	{
		id = "m_02", 
		label = "Hide The Evidence" 
	},
	{
		id = "m_flat_nextmessage",
		message = "m_03",
		label = "Ticco's Ride (motel intro)"
	},
	{
		id = "m_03",
		label = "Ticco's Ride" 
	},
	{
		id = "cleanup_movie",
		screen = "story_movie_play",
		args = {"render51.mpg", "message.call_cleanup"} 
	},
	{
		id = "m_04a",
		label = "The Clean Up (Part 1)" 
	},
	{
		id = "m_04b",
		label = "The Clean Up (Part 2)" 
	},
	{
		id = "m_flat_nextmessage",
		message = "m_05a",
		label = "Case For A Key (motel intro)"
	},
	{
		id = "m_05a", 
		label = "Case For A Key"
	},
	{
		id = "boatchase_movie_1",
		screen = "story_movie_play",
		args = "render24.mpg"
	},
	{
		id = "m_05b",
		label = "Case For A Key (Part 2)" 
	},
	{
		id = "boatchase_movie_2",
		screen = "story_movie_play",
		args = "render65.mpg"
	},
	{
		id = "m_05c",
		label = "Case For A Key (Part 3)"
	},
	{
		id = "boatchase_movie_end",
		screen = "story_movie_play",
		args = "render25.mpg"
	},
	{
		id = "m_flat_nextmessage",
		message = "m_06",
		label = "Tanner Meets Rufus (motel intro)"
	},
	{
		id = "m_06", 
		label = "Tanner Meets Rufus" 
	},
	{
		id = "rufus_bustoutjeanpaul_movie", 
		screen = "story_movie_play", 
		args = "render01.mpg"
	},
	{
		id = "m_07a_activelife", 
		label = "Bust Out Jean Paul" 
	},
	{
		id = "m_07b", 
		label = "Bust Out Jean Paul (Part 2)"
	},
	{
		id = "m_flat_nextmessage",
		message = "m_08",
		label = "Payback (motel intro)"
	},
	{
		id = "payback_movie",
		screen = "story_movie_play",
		args = {"render59.mpg", "message.call_payback"}
	},
	{
		id = "m_08", 
		label = "Payback" 
	},
	{
		id = "shipment_movie",
		screen = "story_movie_play",
		args = {"render56.mpg", "message.call_shipment"} 
	},
	{
		id = "m_09", 
		label = "A Shipment's Coming In"
	},
	{
		id = "m_flat_nextmessage",
		message = "m_10",
		label = "Superfly Drive (motel intro)"
	},
	{
		id = "m_10",
		label = "Superfly Drive"
	},
	{
		id = "m_flat_nextmessage",
		message = "m_11",
		label = "Take Out Di Angio's Car (motel intro)"
	},
	{
		id = "diangio_movie",
		screen = "story_movie_play",
		args = {"render59.mpg", "message.call_diangio"}
	},
	{
		id = "m_11_activelife",
		label = "Take Out Di Angio's Car"
	},
	{
		id = "m_flat_nextmessage",
		message = "m_12",
		label = "Bait for a Trap (motel intro)"
	},
	{
		id = "baitforatrap_movie",
		screen = "story_movie_play",
		args = {"render59.mpg", "message.call_baitforatrap"}
	},
	{
		id = "m_12_activelife",
		label = "Bait for a Trap"
	},
	{
		id = "informant_movie",
		screen = "story_movie_play",
		args = "render03.mpg"
	},
	{
		id = "m_13",
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

local InterviewFileName = "InterviewHD"
local MyLevelFileName = "MiamiClassic"

local ClassicLevels = {
	InterviewFileName,
	MyLevelFileName,
}

local ClassicCars = {
	{"m_skylark_ios", "TCS - Skylark"},			-- Miami
	{"m_fairlane_ios", "TCS - Fairlane"},		-- Frisco
	{"m_bonneville_ios", "TCS - Bonneville"},	-- LA
	{"m_regal_ios", "TCS - Regal"},				-- NYC
}

-- unlocked with completion of story
local UnlockableCars = {
	{"m_superfly_ios", "TCS - Superfly"},
	{"m_grandprix_ios", "TCS - Grand Prix"},
	{"m_truck_ios", "TCS - Bomb Truck"},
	{"m_chevess_ios", "TCS - Chevelle SS"},
	{"m_chevelle_ios", "TCS - Chevelle"},
	{"m_camaro_ios", "TCS - Camaro"},
	{"m_taxi_ios", "TCS - Taxi"},
	{"m_torino_ios", "TCS - Torino"},
	{"m_deville_ios", "TCS - DeVille"},
	{"m_police_ios", "TCS - Police"},
	{"m_250gt_ios", "TCS - 250 GT"},

	{"n_traffic_01", "TCS - Traffic 1"},
	{"n_traffic_02", "TCS - Traffic 2"},
}

function TCS_StoreAchievementsData( key, tbl )
	local achievementsData = userProfileManager:GetProgressStore(USER_STORE_ACHIEVEMENTS)
	achievementsData:SetTableSection(key, tbl)
	userProfileManager:Save()
end

function TCS_GetAchievementsData( key )
	local achievementsData = userProfileManager:GetProgressStore(USER_STORE_ACHIEVEMENTS)
	local section = achievementsData:FindSection(key, 0)
	if section == nil then
		return {}
	end
	return section:ToTable()
end

function TCS_GetPlayerCarName()
	local standardCarName = "m_skylark_ios"
	
	local storyPreferences = TCS_GetAchievementsData("TCS_CompletedStory")
	if storyPreferences ~= nil then
		return storyPreferences.PrefferedStoryCar or standardCarName
	end
	
	return standardCarName
end

function TCS_SetPlayerCarName(name)
	local storyPreferences = TCS_GetAchievementsData("TCS_CompletedStory")
	if storyPreferences == nil then
		storyPreferences = {}
	end
	storyPreferences.PrefferedStoryCar = name
	TCS_StoreAchievementsData("TCS_CompletedStory", storyPreferences)
end

function TCS_GetSuperflyCarName()
	local standardCarName = "m_superfly_ios"
	if TCS_GetPlayerCarName() == standardCarName then
		return "m_250gt_ios"
	end
	return standardCarName
end

local MyCopSoundsFilename = "scripts/sounds/cops.txt"

function IsMyLevel()
	local levName = string.lower(world:GetLevelName())

	for i,n in ipairs(ClassicLevels) do
		if string.lower(n) == levName then
			return true
		end
	end
	
	return false
end

-- OVERRIDE - Change music state logic
function MakeDefaultMissionSettings(original)
	local settings = original()
	settings.KeepPursuitMusic = IsMyLevel()
	return settings
end

-- Initialization function
function ModInit:Init()
	
	localize.AddTokensFile("tcs_missions")
	fonts.LoadFontDescriptionFile("resources/additional_fonts.res")

	include("scripts/lua/TCS_CinematicCamera.lua")
	include("scripts/lua/ui/StoryMiamiClassicEndScreen.lua")
	include("scripts/lua/ui/StoryMoviePlay.lua")

	EmitterSounds.Messages 				= 	"scripts/sounds/messages.txt"
	EmitterSoundRegistry.Goons 			= 	"scripts/sounds/goons.txt"
	EmitterSoundRegistry.SFX 			= 	"scripts/sounds/sfx.txt"
	EmitterSoundRegistry.Vehicles 		= 	"scripts/sounds/vehicles.txt"

	CopVoiceOver[MyLevelFileName] = MyCopSoundsFilename;
	
	CopVoiceOver[string.lower(MyLevelFileName)] = MyCopSoundsFilename;
	
	CityTimeOfDayMusic[MyLevelFileName] = {
		day_clear = "miami_day",
		day_stormy = "la_day",
		dawn_clear = "frisco_night",
		night_clear = "miami_night",
		night_stormy = "nyc_night"
	}

	-----------------------------------------------------------
	-- Classic Content (Map / Vehicles / Missions / Minigames) --
	-----------------------------------------------------------
	
	-- add levels
--	table.insert(MenuCityList, {InterviewFileName, "Parking (Classic)"})
	table.insert(MenuCityList, {MyLevelFileName, "Miami (Classic)"})

	-- add cars
	for i,v in ipairs(ClassicCars) do
		table.insert(MenuCarsList, v)
	end
	
	local storyPreferences = TCS_GetAchievementsData("TCS_CompletedStory")
	if storyPreferences ~= nil and storyPreferences.UnlockCars then
		for i,v in ipairs(UnlockableCars) do
			table.insert(MenuCarsList, v)
		end
	end
	-- Add missions
	missions["tcs_story"] = MiamiMissionsList

	-- Miami (Classic) Minigames
	table.insert(missions["minigame/survival"], {"m_sv_a", "Miami Classic (Miami Beach)"})
	table.insert(missions["minigame/survival"], {"m_sv_b", "Miami Classic (Downtown)"})
	table.insert(missions["minigame/survival"], {"m_sv_c", "Miami Classic (Coral Gables)"})

	local MiamiMissionsElem = {
		label = "Miami - Classic Missions",
		isFinal = true,
		onEnter = function(self, stack)
		
			-- Reset and run ladder
			missionladder:Run( "tcs_story", missions["tcs_story"] )

			return {}
		end,
	}
	
	MiamiMissionsIdx = table.insert(StoryGameExtraElems, MiamiMissionsElem)
	
	SetHudCreateCallback("TCS_HUDInitializer", function(scheme)
		local levName = world:GetLevelName()
		
		if levName:lower() == MyLevelFileName:lower() then
			scheme.resourceFile = "resources/hud/classichud.res"
			
			-- classic hud scheme already includes control
			-- so we don't need to load some resource files
			
			scheme.felonyBar = HudFelonyBar {
				resourceFile = HUD_NIL
			}
			scheme.map = HudMap {
				resourceFile = HUD_NIL,
			
				mapViewAngleTargetA = 90.0,
				mapViewHeightTargetA = 300.0,
				mapViewForwardTargetA = 0,
				mapHudScaleTargetA = 1.0,
				
				mapViewAngleTargetB = 90.0,
				mapViewHeightTargetB = 800.0,
				mapViewForwardTargetB = -200.0,
				mapHudScaleTargetB = 2.5
			}
		end
	end)

end

-- Deinitialization function
function ModInit:DeInit()
	localize.RemoveTokensFile("tcs_missions")
	
	EmitterSounds.Messages 				= 	nil
	EmitterSoundRegistry.Interview 		= 	nil
	EmitterSoundRegistry.Goons 			= 	nil
	EmitterSoundRegistry.SFX 			= 	nil
	EmitterSoundRegistry.Vehicles 		= 	nil

	TCS_CutsceneCamera 					= 	nil

	CityTimeOfDayMusic[MyLevelFileName] = 	nil
	
	table.remove(StoryGameExtraElems, MiamiMissionsIdx)
	
	-- Remove Miami (Classic) Minigames
	table.remove(missions["minigame/survival"], m_sv_a)
	table.remove(missions["minigame/survival"], m_sv_b)
	table.remove(missions["minigame/survival"], m_sv_c)

	missions["tcs_story"] = nil		-- Remove Miami (Classic) missions

	-- Deinit - Maps
	for i,v in ipairs(MenuCityList) do
	
		for ii,vv in ipairs(ClassicLevels) do
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
		for ii,vv in ipairs(UnlockableCars) do
			if vv[1] == v[1] then
				--table.remove( MenuCarsList, i)
				MenuCarsList[i] = nil
			end
		end
	end
	
	SetMissionLoadedCallback("TCS_HUDInitializer", nil)
end

return ModInit
