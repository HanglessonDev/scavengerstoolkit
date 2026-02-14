--- @file scavengerstoolkit\42.12\media\lua\shared\features\STK_ContainerLimits.lua
--- Feature: Dynamic upgrade limits based on container type
--- Uses hook system to modify bag behavior without touching core

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
-- CONTAINER LIMITS TABLE
-- ============================================================================

--- Get limit from Sandbox or use default
--- @param bagType string Full type of bag
--- @return number limit Maximum upgrades
local function getLimitForBagType(bagType)
	-- FannyPacks
	if bagType == "Base.Bag_FannyPackFront" or bagType == "Base.Bag_FannyPackBack" then
		return SandboxVars.STK.FannyPackLimit or 1
	end

	-- Satchels (all variants)
	if bagType:find("Satchel") then
		return SandboxVars.STK.SatchelLimit or 2
	end

	-- Schoolbags (all variants)
	if bagType:find("Schoolbag") then
		return SandboxVars.STK.SchoolbagLimit or 3
	end

	-- Default for unknown bags
	return SandboxVars.STK.SchoolbagLimit or 3
end

-- ============================================================================
-- HOOK: Modify bag limits on initialization
-- ============================================================================

--- Hook into afterInitBag to set container-specific limits
--- @param bag any The bag being initialized
--- @param isFirstInit boolean Whether this is the first time initializing this bag
local function setContainerLimit(bag, isFirstInit)
	local bagType = bag:getFullType()
	local limit = getLimitForBagType(bagType)

	local imd = bag:getModData()
	imd.LMaxUpgrades = limit

	if isFirstInit then
		Logger.log("Limite definido para " .. bagType .. ": " .. limit .. " upgrades (primeira vez)")
	else
		Logger.log("Limite atualizado para " .. bagType .. ": " .. limit .. " upgrades")
	end
end

-- Register the hook with VERY_HIGH priority
-- Container limits should run FIRST to set base limits
-- Other features can then modify these limits (e.g., VIP bonus)
STKBagUpgrade.registerHook(
	"afterInitBag",
	setContainerLimit,
	STKBagUpgrade.PRIORITY.VERY_HIGH -- Runs first!
)

Logger.log("Hook 'afterInitBag' registrado com prioridade VERY_HIGH!")

-- ============================================================================
-- PUBLIC API (optional, for other features to use)
-- ============================================================================

local STK_ContainerLimits = {}

--- Get the limit for a specific bag type
--- @param bagType string Full type of the bag (e.g., "Base.Bag_Schoolbag")
--- @return number limit The maximum number of upgrades
function STK_ContainerLimits.getLimit(bagType)
	return getLimitForBagType(bagType)
end

return STK_ContainerLimits
