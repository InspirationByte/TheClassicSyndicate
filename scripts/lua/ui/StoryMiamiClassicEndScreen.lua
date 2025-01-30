--//////////////////////////////////////////////////////////////////////////////////
--// Copyright © Inspiration Byte
--// 2009-2021
--//////////////////////////////////////////////////////////////////////////////////

local StoryMiamiClassicEndingScreen = class()

	SequenceScreens.Register("story_miamiclassic_end", StoryMiamiClassicEndingScreen)

	StoryMiamiClassicEndingScreen.schemeName = "resources/ui_story_miamiclassic_end.res"

	function StoryMiamiClassicEndingScreen:__init() 
		self.control = nil
		self.done = false
		self.fade = 0
	end

	function StoryMiamiClassicEndingScreen:InitUIScheme( equiControl )
		self.control = equiControl
		self.bgChild = equi:Cast(self.control:FindChild("fade"), "panel")
		self.bgChild:SetColor(vec4(0, 0, 0, 1))
	end

	function StoryMiamiClassicEndingScreen:OnEnter()
		missionladder:DeleteProgress("mcd_missions")
		McdStoreAchievementsData("McdCompletedStory", {
			UnlockCars = true
		})
	end
	
	function StoryMiamiClassicEndingScreen:Update(delta)
	
		local color = 1.0 - self.fade
	
		self.bgChild:SetColor(vec4(0, 0, 0, color))
		
		if self.done then
			self.fade = self.fade - delta
		else
			self.fade = self.fade + delta
		end

		if self.fade > 1 then
			self.fade = 1
		end

		if self.fade <= 0 then
			SequenceScreens.CancelAll()
			game.ScheduleMainMenu()
			return false
		end
	
		return true
	end
	
	function StoryMiamiClassicEndingScreen:Close()
		self.done = true
	end
	
	function StoryMiamiClassicEndingScreen:KeyPress(key, down)
		if (key == inputMap["ENTER"] or key == inputMap["JOY_A"]) and down == false then
			self:Close()
		end
	end
	
	function StoryMiamiClassicEndingScreen:MouseClick(x, y, buttons, down)
		if buttons == inputMap["MOUSE1"] then
			self:Close()
		end
	end
	