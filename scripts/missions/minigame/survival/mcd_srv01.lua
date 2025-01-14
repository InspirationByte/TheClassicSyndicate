--//////////////////////////////////////////////////////////////////////////////////
--// Copyright � Inspiration Byte
--// 2009-2015
--//////////////////////////////////////////////////////////////////////////////////

--------------------------------------------------------------------------------
-- Miami Classic - Survival - (Miami Beach)
--------------------------------------------------------------------------------

world:SetLevelName("miamiclassic")
world:SetEnvironmentName("night_clear")
SetMusicName("miami_night")

----------------------------------------------------------------------------------------------
-- Mission initialization
----------------------------------------------------------------------------------------------

MISSION.Init = function()

	-- car name		maxdamage	pos ang
	local playerCar = gameses:CreateCar("m_default_ios", CAR_TYPE_NORMAL)
	MISSION.playerCar = playerCar
	
	playerCar:SetOrigin( Vector3D.new(1720, 0.70, -10) )
	playerCar:SetAngles( Vector3D.new(180, 0, 180) )
	playerCar:SetColorScheme(4)
	playerCar:Spawn()

	gameses:SetPlayerCar( playerCar )
	
	SurvivalGame.Init( 8 )
end
