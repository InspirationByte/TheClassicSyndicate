--//////////////////////////////////////////////////////////////////////////////////
--// Copyright � Inspiration Byte
--// 2009-2015
--//////////////////////////////////////////////////////////////////////////////////

--------------------------------------------------------------------------------
-- Miami Classic - Survival - (Downtown)
--------------------------------------------------------------------------------

world:SetLevelName("miamiclassic")
world:SetEnvironmentName("day_clear")
SetMusicName("frisco_day")

----------------------------------------------------------------------------------------------
-- Mission initialization
----------------------------------------------------------------------------------------------

MISSION.Init = function()
	-- car name		maxdamage	pos ang
	local playerCar = gameses:CreateCar("mcd_miamidef", CAR_TYPE_NORMAL)
	MISSION.playerCar = playerCar
	
	playerCar:SetOrigin( Vector3D.new(108, 0.70, -420) )
	playerCar:SetAngles( Vector3D.new(-32, 90, -32) )

	playerCar:SetColorScheme(1)
	playerCar:Spawn()

	gameses:SetPlayerCar( playerCar )
	
	SurvivalGame.Init( 8 )
end
