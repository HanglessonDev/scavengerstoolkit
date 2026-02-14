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

--- Define max upgrades for each container type
local containerLimits = {
	-- Small bags (1-2 upgrades)
	["Base.Bag_FannyPackFront"] = 1,
	["Base.Bag_FannyPackBack"] = 1,

	-- Medium bags (2 upgrades)
	["Base.Bag_Satchel"] = 2,
	["Base.Bag_SatchelPhoto"] = 2,
	["Base.Bag_Satchel_Military"] = 2,
	["Base.Bag_Satchel_Medical"] = 2,
	["Base.Bag_Satchel_Leather"] = 2,
	["Base.Bag_Satchel_Mail"] = 2,
	["Base.Bag_Satchel_Fishing"] = 2,

	-- Large bags (3 upgrades) - DEFAULT
	["Base.Bag_Schoolbag"] = 3,
	["Base.Bag_Schoolbag_Kids"] = 3,
	["Base.Bag_Schoolbag_Medical"] = 3,
	["Base.Bag_Schoolbag_Patches"] = 3,
	["Base.Bag_Schoolbag_Travel"] = 3,
}

-- Default limit for bags not in the table
local DEFAULT_LIMIT = 3

-- ============================================================================
-- HOOK: Modify bag limits on initialization
-- ============================================================================

--- Hook into afterInitBag to set container-specific limits
--- @param bag any The bag being initialized
--- @param isFirstInit boolean Whether this is the first time initializing this bag
local function setContainerLimit(bag, isFirstInit)
	local bagType = bag:getFullType()
	local limit = containerLimits[bagType] or DEFAULT_LIMIT

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
	return containerLimits[bagType] or DEFAULT_LIMIT
end

--- Set a custom limit for a bag type (for other mods/features to use)
--- @param bagType string Full type of the bag
--- @param limit number Maximum upgrades
function STK_ContainerLimits.setLimit(bagType, limit)
	containerLimits[bagType] = limit
	Logger.log("Limite customizado definido: " .. bagType .. " = " .. limit)
end

return STK_ContainerLimits
