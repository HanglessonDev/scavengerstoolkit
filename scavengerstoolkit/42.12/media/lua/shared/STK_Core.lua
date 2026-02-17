--- @file scavengerstoolkit\42.12\media\lua\shared\STK_Core.lua
--- @brief Core definitions and pure validation functions for the STK system
---
--- This module is the heart of the STK system. It contains ONLY:
---   - Static data (valid bags, upgrade values)
---   - Pure read-only validation functions (no state modification)
---   - SandboxVars readers
---
--- RULES FOR THIS FILE:
---   - NO side effects
---   - NO state modification (no setCapacity, no ModData writes)
---   - NO event triggering
---   - NO require() of other STK modules
---   - Server, client and shared code may all require() this file
---
--- @author Scavenger's Toolkit Development Team
--- @version 3.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

--- @class STKCore
local STK_Core = {}

-- ============================================================================
-- VALID BAGS
-- ============================================================================

--- Lookup table of valid bag full types.
--- O(1) access. Only bags listed here can receive STK upgrades.
--- @type table<string, true>
local VALID_BAGS = {
	-- Schoolbags (5)
	["Base.Bag_Schoolbag"] = true,
	["Base.Bag_Schoolbag_Kids"] = true,
	["Base.Bag_Schoolbag_Medical"] = true,
	["Base.Bag_Schoolbag_Patches"] = true,
	["Base.Bag_Schoolbag_Travel"] = true,

	-- Satchels (7)
	["Base.Bag_Satchel"] = true,
	["Base.Bag_SatchelPhoto"] = true,
	["Base.Bag_Satchel_Military"] = true,
	["Base.Bag_Satchel_Medical"] = true,
	["Base.Bag_Satchel_Leather"] = true,
	["Base.Bag_Satchel_Mail"] = true,
	["Base.Bag_Satchel_Fishing"] = true,

	-- FannyPacks (2)
	["Base.Bag_FannyPackFront"] = true,
	["Base.Bag_FannyPackBack"] = true,

	-- Hiking Bags (4)
	["Base.Bag_NormalHikingBag"] = true,
	["Base.Bag_HikingBag_Travel"] = true,
	["Base.Bag_BigHikingBag"] = true,
	["Base.Bag_BigHikingBag_Travel"] = true,

	-- Duffel Bags (7)
	["Base.Bag_DuffelBag"] = true,
	["Base.Bag_DuffelBagTINT"] = true,
	["Base.Bag_Military"] = true,
	["Base.Bag_Police"] = true,
	["Base.Bag_SWAT"] = true,
	["Base.Bag_Sheriff"] = true,
	["Base.Bag_MedicalBag"] = true,
}

-- ============================================================================
-- UPGRADE VALUES
-- ============================================================================

--- Returns the upgrade value for a given item type.
--- Positive values increase capacity (Fabrics).
--- Negative values improve weight reduction (Straps and Buckles).
--- Reads from SandboxVars with safe defaults.
--- @param itemType string Item type, with or without "STK." prefix
--- @return number|nil value The upgrade value, or nil if not an STK upgrade
function STK_Core.getUpgradeValue(itemType)
	if not itemType then
		return nil
	end

	local t = itemType:gsub("^STK%.", "")

	if t == "BackpackStrapsBasic" then
		return -((SandboxVars.STK.StrapsBasicBonus or 5) / 100)
	elseif t == "BackpackStrapsReinforced" then
		return -((SandboxVars.STK.StrapsReinforcedBonus or 10) / 100)
	elseif t == "BackpackStrapsTactical" then
		return -((SandboxVars.STK.StrapsTacticalBonus or 15) / 100)
	elseif t == "BackpackFabricBasic" then
		return SandboxVars.STK.FabricBasicBonus or 3
	elseif t == "BackpackFabricReinforced" then
		return SandboxVars.STK.FabricReinforcedBonus or 5
	elseif t == "BackpackFabricTactical" then
		return SandboxVars.STK.FabricTacticalBonus or 8
	elseif t == "BeltBuckleReinforced" then
		return -((SandboxVars.STK.BeltBuckleBonus or 10) / 100)
	end

	return nil
end

-- ============================================================================
-- BAG VALIDATION
-- ============================================================================

--- Returns true if the item is a valid bag for STK upgrades.
--- @param item any InventoryItem to validate
--- @return boolean
function STK_Core.isValidBag(item)
	if not item or not item:IsInventoryContainer() then
		return false
	end
	return VALID_BAGS[item:getFullType()] == true
end

--- Returns true if the bag can still accept more upgrades.
--- Requires the bag to have been initialised (has LUpgrades and LMaxUpgrades).
--- @param bag any InventoryItem bag
--- @return boolean
function STK_Core.canAddUpgrade(bag)
	local imd = bag:getModData()
	if not imd.LUpgrades or not imd.LMaxUpgrades then
		return false
	end
	return #imd.LUpgrades < imd.LMaxUpgrades
end

-- ============================================================================
-- TOOL VALIDATION
-- ============================================================================

--- Returns true if the player has the required tools for the given action.
---
--- "add"    requires: Needle + Thread
--- "remove" requires: Scissors
---          (knife alternative is handled separately by STK_Validation on
---           the server side — see STK_Validation.lua, Fase 2 Dia 6)
---
--- @param player any IsoPlayer
--- @param actionType string "add" or "remove"
--- @return boolean
--- Viable knives for the KnifeAlternative feature.
--- Duplicated here so STK_Core remains self-contained (no require of server/).
--- Must be kept in sync with STK_KnifeAlternative.VIABLE_KNIVES.
local VIABLE_KNIVES_REMOVE = {
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

function STK_Core.hasRequiredTools(player, actionType)
	if not player then
		return false
	end

	local inv = player:getInventory()

	if actionType == "add" then
		return inv:contains("Base.Needle") and inv:contains("Base.Thread")
	elseif actionType == "remove" then
		if inv:contains("Base.Scissors") then
			return true
		end

		-- Knife alternative: only if enabled in SandboxVars
		if SandboxVars.STK and SandboxVars.STK.KnifeAlternative then
			for _, knifeType in ipairs(VIABLE_KNIVES_REMOVE) do
				if inv:contains(knifeType) then
					return true
				end
			end
		end

		return false
	end

	return false
end

-- ============================================================================
-- INVENTORY SCAN
-- ============================================================================

--- Returns all STK upgrade items found in the given container.
--- Caches getItems() and size() outside the loop for performance.
--- @param container any ItemContainer to scan
--- @return any[] Array of InventoryItem upgrade items
function STK_Core.getUpgradeItems(container)
	local result = {}
	if not container then
		return result
	end

	local items = container:getItems()
	local size = items:size()

	for i = 0, size - 1 do
		local item = items:get(i)
		if item and item:getType() then
			if STK_Core.getUpgradeValue(item:getType()) then
				table.insert(result, item)
			end
		end
	end

	return result
end

-- ============================================================================
-- MOD DATA INITIALISATION
-- ============================================================================

--- Initialises the STK ModData fields on a bag if not already present.
--- Sets LUpgrades, LCapacity, LWeightReduction and STKInitialised flag.
--- LMaxUpgrades is intentionally left for STK_ContainerLimits (server) to set.
--- @param bag any InventoryItem bag
--- @return boolean isFirstInit True if this was the first initialisation
function STK_Core.initBagData(bag)
	if not bag then
		return false
	end

	local imd = bag:getModData()
	local isFirstInit = not imd.STKInitialised

	if isFirstInit then
		imd.LUpgrades = imd.LUpgrades or {}
		imd.LCapacity = imd.LCapacity or bag:getCapacity()
		imd.LWeightReduction = imd.LWeightReduction or bag:getWeightReduction()
		imd.LMaxUpgrades = imd.LMaxUpgrades or 3
		imd.STKInitialised = true
	end

	return isFirstInit
end

-- ============================================================================

return STK_Core
