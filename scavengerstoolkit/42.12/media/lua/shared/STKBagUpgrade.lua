--- @file scavengerstoolkit\42.12\media\lua\shared\STKBagUpgrade.lua
--- @brief Compatibility shim and shared validation helpers
---
--- After the Pivot #1 refactor (Dia 4), this module no longer owns the
--- hook system, applyUpgrade, or removeUpgrade. Those responsibilities
--- moved to server/STK_UpgradeLogic.lua and the Events system.
---
--- What remains here:
---   - isBagValid / isValidBag   (used by client ContextMenu + TimedActions)
---   - initBag                   (calls STK_Core.initBagData, triggers OnSTKBagInit)
---   - canAddUpgrade             (read-only, used by client ContextMenu)
---   - hasRequiredTools          (read-only, used by client ContextMenu + TimedActions)
---   - getUpgradeValue           (read-only, used by Tooltips + TimedActions)
---   - getUpgradeItems           (read-only, used by client ContextMenu)
---
--- All functions delegate to STK_Core. This file exists only to avoid
--- breaking requires() in files not yet migrated to require STK_Core directly.
---
--- NOTE: This file will be deleted in Fase 4 (cleanup) once all callers
--- have been updated to require STK_Core directly.
---
--- @author Scavenger's Toolkit Development Team
--- @version 3.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

local STK_Core = require("STK_Core")
local log = require("STK_Logger").get("STK-BagUpgrade")

-- ============================================================================
-- MODULE
-- ============================================================================

--- @class STKBagUpgrade
local STKBagUpgrade = {}

-- ============================================================================
-- VALIDATION (delegates to STK_Core)
-- ============================================================================

--- Returns true if the item is a valid bag for STK upgrades.
--- @param item any InventoryItem
--- @return boolean
function STKBagUpgrade.isBagValid(item)
	return STK_Core.isValidBag(item)
end

--- Alias kept for compatibility with TimedActions (isValid checks).
--- @param item any InventoryItem
--- @return boolean
function STKBagUpgrade.isValidBag(item)
	return STK_Core.isValidBag(item)
end

--- Returns the upgrade value for a given item type.
--- @param itemType string With or without "STK." prefix
--- @return number|nil
function STKBagUpgrade.getUpgradeValue(itemType)
	return STK_Core.getUpgradeValue(itemType)
end

--- Returns true if the bag can still accept more upgrades.
--- @param bag any InventoryItem bag
--- @return boolean
function STKBagUpgrade.canAddUpgrade(bag)
	return STK_Core.canAddUpgrade(bag)
end

--- Returns true if the player has the required tools for the action.
--- @param player any IsoPlayer
--- @param actionType string "add" or "remove"
--- @return boolean
function STKBagUpgrade.hasRequiredTools(player, actionType)
	return STK_Core.hasRequiredTools(player, actionType)
end

--- Returns all STK upgrade items found in the container.
--- @param container any ItemContainer
--- @return any[]
function STKBagUpgrade.getUpgradeItems(container)
	return STK_Core.getUpgradeItems(container)
end

-- ============================================================================
-- BAG INIT
-- ============================================================================

--- Client-safe initialiser — only writes ModData, never triggers server events.
--- Use from UI code (tooltips, context menu) to avoid firing OnSTKBagInit
--- in a render/hover context where server listeners may not be safe to run.
--- @param bag any InventoryItem bag
function STKBagUpgrade.initBag_Client(bag)
	if not bag or not instanceof(bag, "InventoryItem") then
		return
	end
	STK_Core.initBagData(bag)
end

--- Full initialiser for server/shared contexts. Triggers OnSTKBagInit.
--- @param bag any InventoryItem bag
function STKBagUpgrade.initBag(bag)
	if not bag then
		return
	end

	local isFirstInit = STK_Core.initBagData(bag)
	triggerEvent("OnSTKBagInit", bag, isFirstInit)

	log.debug(string.format("initBag: %s (firstInit=%s)", bag:getType(), tostring(isFirstInit)))
end

-- ============================================================================

log.info("Modulo carregado v3.0 (shim — hooks removidos, Events ativos)")

return STKBagUpgrade
