--- @file scavengerstoolkit\42.12\media\lua\server\STK_ContainerLimits.lua
--- @brief Server-side container-specific upgrade limits
---
--- Listens to OnSTKBagInit and sets LMaxUpgrades on each bag based on
--- its type. Limits are read from SandboxVars where available, with
--- hardcoded safe defaults. Default limit is 3 for unmatched types.
---
--- @author Scavenger's Toolkit Development Team
--- @version 3.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

-- ============================================================================
-- LOGGING
-- ============================================================================

local DEBUG_MODE = true

local Logger = {
	--- @param message string
	log = function(message)
		if not DEBUG_MODE then
			return
		end
		print("[STK-ContainerLimits] " .. tostring(message))
	end,
}

Logger.log("Modulo carregado.")

-- ============================================================================
-- LIMIT RULES
-- Evaluated in order — first matching pattern wins.
-- ============================================================================

local LIMIT_RULES = {
	{ pattern = "FannyPack", sandboxKey = "FannyPackLimit", default = 1 },
	{ pattern = "Satchel", sandboxKey = "SatchelLimit", default = 2 },
	{ pattern = "Schoolbag", sandboxKey = "SchoolbagLimit", default = 2 },
	{ pattern = "HikingBag", sandboxKey = nil, default = 2 },
	{ pattern = "DuffelBag", sandboxKey = nil, default = 2 },
	{ pattern = "Military", sandboxKey = nil, default = 2 },
	{ pattern = "Police", sandboxKey = nil, default = 2 },
	{ pattern = "SWAT", sandboxKey = nil, default = 2 },
	{ pattern = "Sheriff", sandboxKey = nil, default = 2 },
	{ pattern = "MedicalBag", sandboxKey = nil, default = 2 },
}

local DEFAULT_LIMIT = 3

-- ============================================================================
-- EVENT LISTENER
-- ============================================================================

--- Fired by STKBagUpgrade.initBag() / STK_UpgradeLogic.initBag().
--- @param bag any InventoryItem bag
--- @param isFirstInit boolean
local function onBagInit(bag, isFirstInit)
	-- Hotfix: Previne erro de nil reference vindo de tooltips.
	-- Garante que o item é um objeto totalmente inicializado.
	if not bag or not instanceof(bag, "InventoryItem") or not bag:getFullType() then
		return
	end

	local bagType = bag:getFullType()
	local imd = bag:getModData()
	local limit = DEFAULT_LIMIT

	for _, rule in ipairs(LIMIT_RULES) do
		if bagType:find(rule.pattern) then
			if rule.sandboxKey and SandboxVars.STK[rule.sandboxKey] then
				limit = SandboxVars.STK[rule.sandboxKey]
			else
				limit = rule.default
			end
			break
		end
	end

	imd.LMaxUpgrades = limit

	Logger.log(string.format("Limite definido para %s: %d (firstInit=%s)", bagType, limit, tostring(isFirstInit)))
end

Events.OnSTKBagInit.Add(onBagInit)

Logger.log("Listener registrado: OnSTKBagInit")

-- ============================================================================
-- PUBLIC API
-- ============================================================================

--- @class STKContainerLimits
local STK_ContainerLimits = {}

--- Returns the configured limit for the first rule matching bagType.
--- Returns DEFAULT_LIMIT (3) if no rule matches.
--- @param bagType string Full type string e.g. "Base.Bag_FannyPackFront"
--- @return number
function STK_ContainerLimits.getLimitForType(bagType)
	for _, rule in ipairs(LIMIT_RULES) do
		if bagType:find(rule.pattern) then
			if rule.sandboxKey and SandboxVars.STK[rule.sandboxKey] then
				return SandboxVars.STK[rule.sandboxKey]
			end
			return rule.default
		end
	end
	return DEFAULT_LIMIT
end

-- ============================================================================

return STK_ContainerLimits
