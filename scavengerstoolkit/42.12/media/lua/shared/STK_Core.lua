--- @file scavengerstoolkit\42.12\media\lua\shared\STK_Core.lua
--- @brief Core definitions and pure validation functions for the STK system
---
--- This module is the heart of the STK system. It contains ONLY:
---   - Pure read-only validation functions (no state modification)
---   - SandboxVars readers
---   - ModData initialisation (initBagData)
---
--- Static data (bag lists, limits, knives) lives in STK_Constants.
---
--- RULES FOR THIS FILE:
---   - NO side effects
---   - NO state modification (no setCapacity, no ModData writes)
---   - NO event triggering
---   - May require() STK_Constants (static data only, no circular risk)
---   - Server, client and shared code may all require() this file
---
--- @author Scavenger's Toolkit Development Team
--- @version 3.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

local STK_Constants = require("STK_Constants")

--- @class STKCore
local STK_Core = {}

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
	return STK_Constants.VALID_BAGS[item:getFullType()] == true
end

--- Returns true if the bag can still accept more upgrades.
--- Limit is calculated dynamically from SandboxVars — always reflects
--- current sandbox configuration without requiring ModData to be updated.
--- @param bag any InventoryItem bag
--- @return boolean
function STK_Core.canAddUpgrade(bag)
	local imd = bag:getModData()
	if not imd.LUpgrades then
		return false
	end
	return #imd.LUpgrades < STK_Core.getLimitForType(bag:getFullType())
end

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
-- TOOL VALIDATION
-- ============================================================================

--- Searches for an item type in the player's main inventory and in all
--- equipped containers (any worn item that IsInventoryContainer).
--- This ensures tools stored inside an equipped bag are found automatically,
--- improving UX without requiring the player to move items manually.
--- @param player any IsoPlayer
--- @param itemType string Full type string e.g. "Base.Scissors"
--- @return boolean
local function playerHasItem(player, itemType)
	-- Check main inventory first (most common case, fast path)
	if player:getInventory():contains(itemType) then
		return true
	end

	-- Check all equipped containers
	local wornItems = player:getWornItems()
	for i = 0, wornItems:size() - 1 do
		local worn = wornItems:getItemByIndex(i)
		if worn and worn:IsInventoryContainer() then
			if worn:getInventory():contains(itemType) then
				return true
			end
		end
	end

	return false
end

--- Returns true if the player has the required tools for the given action.
--- Searches both main inventory and all equipped containers.
---
--- "add"    requires: Needle + Thread
--- "remove" requires: Scissors, or a viable knife if KnifeAlternative is enabled
---
--- @param player any IsoPlayer
--- @param actionType string "add" or "remove"
--- @return boolean
function STK_Core.hasRequiredTools(player, actionType)
	if not player then
		return false
	end

	if actionType == "add" then
		return playerHasItem(player, "Base.Needle") and playerHasItem(player, "Base.Thread")
	elseif actionType == "remove" then
		if playerHasItem(player, "Base.Scissors") then
			return true
		end

		if SandboxVars.STK and SandboxVars.STK.KnifeAlternative then
			for _, knifeType in ipairs(STK_Constants.VIABLE_KNIVES) do
				if playerHasItem(player, knifeType) then
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

--- Scans a single ItemContainer and appends found STK upgrade items to result.
--- @param container any ItemContainer
--- @param result any[] Accumulator table
local function scanContainerForUpgrades(container, result)
	if not container then
		return
	end
	local items = container:getItems()
	local size = items:size()
	for i = 0, size - 1 do
		local item = items:get(i)
		if item and item:getType() and STK_Core.getUpgradeValue(item:getType()) then
			table.insert(result, item)
		end
	end
end

--- Returns all STK upgrade items found in the player's main inventory and
--- in all equipped containers (any worn item that IsInventoryContainer).
--- @param player any IsoPlayer
--- @return any[] Array of InventoryItem upgrade items
function STK_Core.getUpgradeItems(player)
	local result = {}
	if not player then
		return result
	end

	-- Main inventory
	scanContainerForUpgrades(player:getInventory(), result)

	-- All equipped containers
	local wornItems = player:getWornItems()
	for i = 0, wornItems:size() - 1 do
		local worn = wornItems:getItemByIndex(i)
		if worn and worn:IsInventoryContainer() then
			scanContainerForUpgrades(worn:getInventory(), result)
		end
	end

	return result
end

-- ============================================================================
-- MOD DATA INITIALISATION
-- ============================================================================

--- Returns the correct upgrade limit for a bag type, reading SandboxVars
--- when a sandboxKey is configured, falling back to the default otherwise.
--- @param bagType string Full type string e.g. "Base.Bag_FannyPackFront"
--- @return number
function STK_Core.getLimitForType(bagType)
	local stk = SandboxVars.STK
	for _, rule in ipairs(STK_Constants.BAG_LIMIT_RULES) do
		if bagType:find(rule.pattern) then
			if rule.sandboxKey and stk and stk[rule.sandboxKey] then
				return stk[rule.sandboxKey]
			end
			return rule.default
		end
	end
	return STK_Constants.BAG_LIMIT_DEFAULT
end

--- Initialises the STK ModData fields on a bag if not already present.
--- Sets LUpgrades, LCapacity, LWeightReduction and STKInitialised flag.
--- LMaxUpgrades is NOT stored — it is always calculated dynamically from
--- SandboxVars via STK_Core.getLimitForType(), so it never goes stale.
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
		imd.STKInitialised = true
	end

	return isFirstInit
end

-- ============================================================================

return STK_Core
