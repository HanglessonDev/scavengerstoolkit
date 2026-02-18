--- @file scavengerstoolkit\42.12\media\lua\shared\STK_Constants.lua
--- @brief Shared static constants for the STK system
---
--- Single source of truth for all data that would otherwise be duplicated
--- across multiple modules. No logic, no side effects, no require()s.
---
--- RULES FOR THIS FILE:
---   - ONLY static data (tables, numbers, strings)
---   - NO functions
---   - NO require()
---   - NO SandboxVars reads
---   - NO event triggering
---   - Safe to require from shared, client and server contexts
---
--- @author Scavenger's Toolkit Development Team
--- @version 3.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

--- @class STKConstants
local STK_Constants = {}

-- ============================================================================
-- VALID BAGS
-- ============================================================================

--- Lookup table of valid bag full types.
--- O(1) access. Only bags listed here can receive STK upgrades.
--- @type table<string, true>
STK_Constants.VALID_BAGS = {
	-- Schoolbags (5)
	["Base.Bag_Schoolbag"]           = true,
	["Base.Bag_Schoolbag_Kids"]      = true,
	["Base.Bag_Schoolbag_Medical"]   = true,
	["Base.Bag_Schoolbag_Patches"]   = true,
	["Base.Bag_Schoolbag_Travel"]    = true,

	-- Satchels (7)
	["Base.Bag_Satchel"]             = true,
	["Base.Bag_SatchelPhoto"]        = true,
	["Base.Bag_Satchel_Military"]    = true,
	["Base.Bag_Satchel_Medical"]     = true,
	["Base.Bag_Satchel_Leather"]     = true,
	["Base.Bag_Satchel_Mail"]        = true,
	["Base.Bag_Satchel_Fishing"]     = true,

	-- FannyPacks (2)
	["Base.Bag_FannyPackFront"]      = true,
	["Base.Bag_FannyPackBack"]       = true,

	-- Hiking Bags (4)
	["Base.Bag_NormalHikingBag"]     = true,
	["Base.Bag_HikingBag_Travel"]    = true,
	["Base.Bag_BigHikingBag"]        = true,
	["Base.Bag_BigHikingBag_Travel"] = true,

	-- Duffel Bags (7)
	["Base.Bag_DuffelBag"]           = true,
	["Base.Bag_DuffelBagTINT"]       = true,
	["Base.Bag_Military"]            = true,
	["Base.Bag_Police"]              = true,
	["Base.Bag_SWAT"]                = true,
	["Base.Bag_Sheriff"]             = true,
	["Base.Bag_MedicalBag"]          = true,
}

-- ============================================================================
-- BAG UPGRADE LIMITS
-- ============================================================================

--- Default upgrade limits per bag type pattern.
--- Evaluated in order — first matching pattern wins.
--- sandboxKey: if set, STK_Core.initBagData will read this key from
---             SandboxVars.STK to allow player configuration.
--- default: fallback value if SandboxVars is unavailable or unset.
--- @type {pattern: string, sandboxKey: string|nil, default: number}[]
STK_Constants.BAG_LIMIT_RULES = {
	{ pattern = "FannyPack", sandboxKey = "FannyPackLimit",  default = 1 },
	{ pattern = "Satchel",   sandboxKey = "SatchelLimit",    default = 2 },
	{ pattern = "Schoolbag", sandboxKey = "SchoolbagLimit",  default = 2 },
	{ pattern = "HikingBag", sandboxKey = nil,               default = 2 },
	{ pattern = "DuffelBag", sandboxKey = nil,               default = 2 },
	{ pattern = "Military",  sandboxKey = nil,               default = 2 },
	{ pattern = "Police",    sandboxKey = nil,               default = 2 },
	{ pattern = "SWAT",      sandboxKey = nil,               default = 2 },
	{ pattern = "Sheriff",   sandboxKey = nil,               default = 2 },
	{ pattern = "MedicalBag",sandboxKey = nil,               default = 2 },
}

--- Fallback limit for bag types not matched by BAG_LIMIT_RULES.
--- @type number
STK_Constants.BAG_LIMIT_DEFAULT = 3

-- ============================================================================
-- VIABLE KNIVES (KnifeAlternative feature)
-- ============================================================================

--- Full type strings of knives accepted as scissors alternatives.
--- Used by STK_Core.hasRequiredTools() and STK_KnifeAlternative.
--- @type string[]
STK_Constants.VIABLE_KNIVES = {
	"Base.KitchenKnife",
	"Base.HuntingKnife",
	"Base.ButterKnife",
	"Base.Multitool",
	"Base.KnifePocket",
	"Base.KnifeFillet",
	"Base.KnifeButterfly",
	"Base.HandiKnife",
	"Base.StraightRazor",
}

-- ============================================================================

return STK_Constants
