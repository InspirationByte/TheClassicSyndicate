--//////////////////////////////////////////////////////////////////////////////////
--// Copyright � Inspiration Byte
--// 2009-2015
--//////////////////////////////////////////////////////////////////////////////////

--------------------------------------------------------------------------------
-- Cop test script
--------------------------------------------------------------------------------

world:SetLevelName("miamiclassic")
world:SetEnvironmentName("dusk_clear")
SetMusicName("la_day")

----------------------------------------------------------------------------------------------
-- Mission initialization
----------------------------------------------------------------------------------------------

MISSION.Init = function()
	-- car name		maxdamage	pos ang
	local playerCar = gameses:CreateCar("mcd_miamidef", CAR_TYPE_NORMAL)
	MISSION.playerCar = playerCar
	
	playerCar:SetOrigin( Vector3D.new(-1445, 0.70, -724) )
	playerCar:SetAngles( Vector3D.new(0, 0, 0) )

	playerCar:SetColorScheme(6)
	playerCar:Spawn()

	gameses:SetPlayerCar( playerCar )
	
	SurvivalGame.Init( 8 )
end
