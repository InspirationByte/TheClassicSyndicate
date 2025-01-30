--//////////////////////////////////////////////////////////////////////////////////
--// Copyright � Inspiration Byte
--// 2009-2020
--//////////////////////////////////////////////////////////////////////////////////

local StandardStoryCarsList = {
	{"m_default_ios", "Skylark"},
	{"m_fairlane_ios", "Fairlane"},
	{"m_bonneville_ios", "Bonneville"},
	{"m_chevess_ios", "Chevelle SS"},
	{"m_torino_ios", "Torino"},
	{"m_deville_ios", "DeVille"},
}

local UnlockableStoryCarsList = {
	{"m_superfly_ios", "Superfly"},
	{"m_continental_ios", "Continental"},
	{"m_truck_ios", "Bomb Truck"},
	{"m_chevelle_ios", "Chevelle"},
	{"m_camaro_ios", "Camaro"},
	{"m_taxi_ios", "Taxi"},
	{"m_police_ios", "Police"},
}

local function McdCarSelectionElementsFunc(equiScheme, stack)

	local fadeElem = equi:Cast(equiScheme:FindChild("fade"), "panel")

	local lastPreferredCar = McdGetPlayerCarName()
	local newPreferredCar = lastPreferredCar

	local storyPreferences = McdGetAchievementsData("McdCompletedStory")
	if storyPreferences == nil then
		-- first store for MCD
		storyPreferences = {
			UnlockCars = false,
		}
	end

	local StoryCarsList = {}
	for i,v in ipairs(StandardStoryCarsList) do
		gameses:PrecacheCar(v[1])
		table.insert(StoryCarsList, v)
	end
	
	-- add extra cars if unlocked
	if storyPreferences.UnlockCars then
		for i,v in ipairs(UnlockableStoryCarsList) do
			gameses:PrecacheCar(v[1])
			table.insert(StoryCarsList, v)
		end
	end

	-- reset car type if mods were disabled
	if MenuStack.FindChoiceIndex(StoryCarsList, lastPreferredCar) == -1 then
		McdSetPlayerCarName(StoryCarsList[1][1])
	end
	
	local fade = 0.0
	local changing = 0
	local delay = 0
	
	-- make get/set for both CVar and element
	local currentCarNameGetSet = { 
		get = function()
			return newPreferredCar
		end,
		set = function(value, dir)
			movetime = 0.25
			movedir = dir
			
			newPreferredCar = value
			
			changing = 1
		end
	}
	
	stack.onPop = function()
		if newPreferredCar ~= lastPreferredCar then
			MISSION.OnPreferredCarChanged(lastPreferredCar)
		end
	end
	
	-- this updates UI every frame
	stack.updateFunc = function(delta)
		if changing == 1 then
			fade = fade + delta * 2
			if fade > 1.0 then
				fade = 1.0
				changing = 2
				delay = 0.5
				MISSION.OnPreferredCarChanged(newPreferredCar)
			end
		elseif changing == 2 then
			delay = delay - delta
			if delay <= 0 then
				changing = 3
			end
		elseif changing == 3 then
			fade = fade - delta * 3
			if fade < 0.0 then
				fade = 0.0
				changing = 0
			end
		end
		
		fadeElem:SetColor(vec4(0,0,0,math.pow(fade, 0.5)))
	end

	-- make menu elements
	-- car selection, city selection and time of day
	local elems = {
		MenuStack.MakeChoiceParam("< %s >", currentCarNameGetSet, StoryCarsList),
		{
			label = "#MCD_FLAT_CONFIRMCAR",
			isFinal = false,
			onEnter = function(self, stack)
				lastPreferredCar = newPreferredCar
				McdSetPlayerCarName(newPreferredCar)
				return { menuCommand = "Pop" }
			end,
		},
	}
	
	return elems
end

-- return entire menu item function
return McdCarSelectionElementsFunc