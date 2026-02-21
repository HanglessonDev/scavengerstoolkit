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
--- @version 4.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

--- @class STKConstants
local STK_Constants = {}

-- ============================================================================
-- BAGS
-- ============================================================================

--- Maps each supported bag full type to its sandbox limit key.
---
--- A bag present here is valid for STK upgrades (replaces VALID_BAGS) and
--- carries its upgrade limit category (replaces BAG_LIMIT_RULES).
--- A single table eliminates the sync invariant that two separate tables
--- would require — if a full type is here, it is both valid and categorised.
---
--- To add a new bag: insert one line with the full type and the appropriate
--- sandboxKey. No ordering concerns, no pattern matching, no risk of a
--- generic pattern shadowing a specific one.
---
--- sandboxKeys must have a matching entry in BAG_LIMIT_DEFAULTS below and
--- a matching option in sandbox-options.txt.
---
--- @type table<string, string>
STK_Constants.BAGS = {

	-- -------------------------------------------------------------------------
	-- FannyPack — limit 1
	-- Includes ALICE Belt and Suspenders: occupies the same equipment slot.
	-- You cannot equip both a fanny pack and an ALICE belt simultaneously,
	-- so they share the same category and upgrade limit.
	-- -------------------------------------------------------------------------
	["Base.Bag_FannyPackFront"] = "FannyPackLimit",
	["Base.Bag_FannyPackBack"] = "FannyPackLimit",
	["Base.Bag_FannyPackFront_Hide"] = "FannyPackLimit",
	["Base.Bag_FannyPackBack_Hide"] = "FannyPackLimit",
	["Base.Bag_FannyPackFront_Tarp"] = "FannyPackLimit",
	["Base.Bag_FannyPackBack_Tarp"] = "FannyPackLimit",
	["Base.Bag_ALICE_BeltSus"] = "FannyPackLimit",
	["Base.Bag_ALICE_BeltSus_Camo"] = "FannyPackLimit",
	["Base.Bag_ALICE_BeltSus_Green"] = "FannyPackLimit",

	-- -------------------------------------------------------------------------
	-- Satchel — limit 2
	-- -------------------------------------------------------------------------
	["Base.Bag_Satchel"] = "SatchelLimit",
	["Base.Bag_SatchelPhoto"] = "SatchelLimit",
	["Base.Bag_Satchel_Military"] = "SatchelLimit",
	["Base.Bag_Satchel_Medical"] = "SatchelLimit",
	["Base.Bag_Satchel_Leather"] = "SatchelLimit",
	["Base.Bag_Satchel_Mail"] = "SatchelLimit",
	["Base.Bag_Satchel_Fishing"] = "SatchelLimit",
	["Base.Bag_ClothSatchel_Burlap"] = "SatchelLimit",
	["Base.Bag_ClothSatchel_Cotton"] = "SatchelLimit",
	["Base.Bag_ClothSatchel_Denim"] = "SatchelLimit",
	["Base.Bag_HideSatchel"] = "SatchelLimit",

	-- -------------------------------------------------------------------------
	-- Schoolbag — limit 2
	-- -------------------------------------------------------------------------
	["Base.Bag_Schoolbag"] = "SchoolbagLimit",
	["Base.Bag_Schoolbag_Kids"] = "SchoolbagLimit",
	["Base.Bag_Schoolbag_Medical"] = "SchoolbagLimit",
	["Base.Bag_Schoolbag_Patches"] = "SchoolbagLimit",
	["Base.Bag_Schoolbag_Travel"] = "SchoolbagLimit",

	-- -------------------------------------------------------------------------
	-- Hiking Bag — limit 3
	-- -------------------------------------------------------------------------
	["Base.Bag_NormalHikingBag"] = "HikingBagLimit",
	["Base.Bag_HikingBag_Travel"] = "HikingBagLimit",
	["Base.Bag_BigHikingBag"] = "HikingBagLimit",
	["Base.Bag_BigHikingBag_Travel"] = "HikingBagLimit",

	-- -------------------------------------------------------------------------
	-- Duffel Bag — limit 3
	-- Covers a wide range of thematic variants that share the same capacity
	-- and weight reduction profile as the base duffel bag.
	-- -------------------------------------------------------------------------
	["Base.Bag_DuffelBag"] = "DuffelBagLimit",
	["Base.Bag_DuffelBagTINT"] = "DuffelBagLimit",
	["Base.Bag_InmateEscapedBag"] = "DuffelBagLimit",
	["Base.Bag_MoneyBag"] = "DuffelBagLimit",
	["Base.Bag_WorkerBag"] = "DuffelBagLimit",
	["Base.Bag_WeaponBag"] = "DuffelBagLimit",
	["Base.Bag_BreakdownBag"] = "DuffelBagLimit",
	["Base.Bag_ShotgunBag"] = "DuffelBagLimit",
	["Base.Bag_ShotgunSawnoffBag"] = "DuffelBagLimit",
	["Base.Bag_ShotgunDblBag"] = "DuffelBagLimit",
	["Base.Bag_ShotgunDblSawnoffBag"] = "DuffelBagLimit",
	["Base.Bag_BurglarBag"] = "DuffelBagLimit",
	["Base.Bag_BaseballBag"] = "DuffelBagLimit",
	["Base.Bag_TennisBag"] = "DuffelBagLimit",
	["Base.Bag_GolfBag"] = "DuffelBagLimit",
	["Base.Bag_GolfBag_Melee"] = "DuffelBagLimit",
	["Base.Bag_FoodCanned"] = "DuffelBagLimit",
	["Base.Bag_FoodSnacks"] = "DuffelBagLimit",
	["Base.Bag_ToolBag"] = "DuffelBagLimit",
	["Base.Bag_Military"] = "DuffelBagLimit",
	["Base.Bag_Police"] = "DuffelBagLimit",
	["Base.Bag_SWAT"] = "DuffelBagLimit",
	["Base.Bag_Sheriff"] = "DuffelBagLimit",
	["Base.Bag_MedicalBag"] = "DuffelBagLimit",

	-- -------------------------------------------------------------------------
	-- Military Bag — limit 4
	-- Found exclusively in high-risk zones (200+ zombies in vanilla).
	-- Higher limit rewards the danger required to obtain them.
	-- -------------------------------------------------------------------------
	["Base.Bag_SurvivorBag"] = "MilitaryBagLimit",
	["Base.Bag_ALICEpack"] = "MilitaryBagLimit",
	["Base.Bag_ALICEpack_Army"] = "MilitaryBagLimit",
	["Base.Bag_ALICEpack_DesertCamo"] = "MilitaryBagLimit",

	-- -------------------------------------------------------------------------
	-- Crafted Bag — limit 2
	-- Player-crafted bags using common materials (early/mid game).
	-- -------------------------------------------------------------------------
	["Base.Bag_CraftedFramepack_Large"] = "CraftedBagLimit",
	["Base.Bag_TarpFramepack_Large"] = "CraftedBagLimit",
	["Base.Bag_CraftedFramepack_Small"] = "CraftedBagLimit",
	["Base.Bag_TarpFramepack_Small"] = "CraftedBagLimit",
	["Base.Bag_CrudeLeatherBag"] = "CraftedBagLimit",
	["Base.Bag_CrudeTarpBag"] = "CraftedBagLimit",
	["Base.Bag_HideSlingBag"] = "CraftedBagLimit",
	["Base.Bag_TarpSlingBag"] = "CraftedBagLimit",

	-- -------------------------------------------------------------------------
	-- Crafted Bag Large — limit 3
	-- Player-crafted bags requiring tanned leather, sinew and chained skills
	-- (late game). Higher limit rewards the crafting investment.
	-- -------------------------------------------------------------------------
	["Base.Bag_CraftedFramepack_Large2"] = "CraftedBagLargeLimit",
	["Base.Bag_CraftedFramepack_Large3"] = "CraftedBagLargeLimit",
}

-- ============================================================================
-- BAG UPGRADE LIMITS
-- ============================================================================

--- Fallback upgrade limit for bag types not present in BAGS.
--- @type number
STK_Constants.BAG_LIMIT_DEFAULT = 2

--- Default upgrade limits per sandbox key.
--- Used as fallback when SandboxVars is unavailable or unset.
--- Must have one entry per unique sandboxKey used in BAGS.
--- @type table<string, number>
STK_Constants.BAG_LIMIT_DEFAULTS = {
	FannyPackLimit = 1,
	SatchelLimit = 2,
	SchoolbagLimit = 2,
	HikingBagLimit = 3,
	DuffelBagLimit = 3,
	MilitaryBagLimit = 4,
	CraftedBagLimit = 2,
	CraftedBagLargeLimit = 3,
}

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
