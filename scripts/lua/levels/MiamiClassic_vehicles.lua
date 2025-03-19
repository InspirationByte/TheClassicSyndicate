local FreeRideVehicleSet = {
    CopVehicles = {
        default = {
            Patrol = {
                m_police_ios   = { },
                --cop_k5      = { minFelony = 0.75 }
            },
            RoadBlock = {
                m_police_ios   = { },
                --cop_k5      = { minFelony = 0.75 }
            },
        }
    },
    Traffic = {
        default = {
            npc_mcd_traffic01       = {},
            npc_mcd_traffic02		= {},
            m_police_ios			= { interval = 20, traffic = false }, -- cops are spawn by the requests
        },
    }
}

local GameModeVehicleSets = {
    ["freeride"] = FreeRideVehicleSet,
    --["minigames/survival"] = SurvivalVehicleSet
}

local vehicleSet = GameModeVehicleSets[MissionManager:GetGameMode()]

-- always return freeride set if no corresponding gamemode set has been found
return vehicleSet or FreeRideVehicleSet