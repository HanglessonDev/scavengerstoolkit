--- @file scavengerstoolkit\42.12\media\lua\shared\STK_ContainerLimits.lua
--- Feature: Container-specific upgrade limits
--- Limita número de upgrades baseado no tipo de mochila

local STKBagUpgrade = require("STKBagUpgrade")

-- ============================================================================
-- CONFIGURATION
-- ============================================================================

local DEBUG_MODE = true

local Logger = {
	log = function(message)
		if not DEBUG_MODE then
			return
		end
		print("[STK-ContainerLimits] " .. tostring(message))
	end,
}

Logger.log("Feature carregada: Container Limits")

-- ============================================================================
-- LIMITES POR TIPO DE BAG
-- ============================================================================

local CONTAINER_LIMITS = {
	-- FannyPack: Muito pequena, só 1 upgrade
	FannyPack = 1,
	
	-- Satchel: Média, 2 upgrades
	Satchel = 2,
	
	-- Schoolbag: Média, 2 upgrades
	Schoolbag = 2,
	
	-- Hiking: Média-Grande, 2 upgrades
	HikingBag = 2,
	BigHikingBag = 2,
	
	-- Duffel: Grande, 2 upgrades
	DuffelBag = 2,
	Military = 2,
	Police = 2,
	SWAT = 2,
	Sheriff = 2,
	MedicalBag = 2,
}

-- ============================================================================
-- HOOK HANDLER
-- ============================================================================

--- Set container-specific upgrade limit
--- @param bag any The bag being initialized
--- @param isFirstInit boolean Whether this is first initialization
local function setContainerLimit(bag, isFirstInit)
	local bagType = bag:getFullType()
	local imd = bag:getModData()
	
	-- Default: 3 upgrades (se não encontrar regra específica)
	local limit = 3
	
	-- Check each pattern
	for pattern, configuredLimit in pairs(CONTAINER_LIMITS) do
		if bagType:find(pattern) then
			limit = configuredLimit
			break
		end
	end
	
	-- Apply limit
	imd.LMaxUpgrades = limit
	
	Logger.log(
		string.format(
			"Limite definido para %s: %d upgrades (isFirstInit: %s)",
			bagType,
			limit,
			tostring(isFirstInit)
		)
	)
end

-- Register hook with VERY_HIGH priority (must run BEFORE other features)
STKBagUpgrade.registerHook("afterInitBag", setContainerLimit, STKBagUpgrade.PRIORITY.VERY_HIGH)

Logger.log("Hook registrado: afterInitBag (VERY_HIGH priority)")

-- ============================================================================
-- PUBLIC API (optional, for debugging)
-- ============================================================================

local STK_ContainerLimits = {}

--- Get configured limit for a bag type pattern
--- @param pattern string The bag type pattern (e.g., "FannyPack")
--- @return number|nil limit The configured limit or nil if not found
function STK_ContainerLimits.getLimit(pattern)
	return CONTAINER_LIMITS[pattern]
end

--- Get all configured limits
--- @return table limits All configured limits
function STK_ContainerLimits.getAllLimits()
	return CONTAINER_LIMITS
end

return STK_ContainerLimits