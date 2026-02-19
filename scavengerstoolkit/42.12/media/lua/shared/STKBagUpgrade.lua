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
---   - updateBag                 (kept for TimedActions isValid() â€” read only)
---
--- All functions delegate to STK_Core / STK_Utils. This file exists only
--- to avoid breaking requires() in files not yet migrated.
---
--- NOTE: This file will be deleted in Fase 4 (cleanup) once all callers
--- have been updated to require STK_Core directly.
---
--- @author Scavenger's Toolkit Development Team
--- @version 3.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

local STK_Core = require("STK_Core")

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
		print("[STKBagUpgrade] " .. tostring(message))
	end,
}

Logger.log("Modulo carregado v3.0 (shim â€” hooks removidos, Events ativos)")

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


--- Returns all STK upgrade items found in the player's inventory and
--- all equipped containers.
--- @param player any IsoPlayer
--- @return any[]
function STKBagUpgrade.getUpgradeItems(player)
	return STK_Core.getUpgradeItems(player)
end

-- ============================================================================
-- BAG INIT
-- ============================================================================

--- Initialises a bag's ModData and triggers OnSTKBagInit.
--- Safe to call multiple times â€” no-op if already initialised.
--- Client-safe initialiser -- only writes ModData, never triggers server events.
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

	-- Trigger event so STK_ContainerLimits (server) can set LMaxUpgrades.
	-- In SP, server/ files run in the same process, so the listener fires immediately.
	triggerEvent("OnSTKBagInit", bag, isFirstInit)

	Logger.log(string.format("initBag: %s (firstInit=%s)", bag:getType(), tostring(isFirstInit)))
end

-- ============================================================================
-- REMOVED: applyUpgrade, removeUpgrade, updateBag, registerHook,
--          executeHooks, STKBagUpgrade.hooks, STKBagUpgrade.PRIORITY
-- These now live in server/STK_UpgradeLogic.lua and are triggered via Events.
-- ============================================================================

return STKBagUpgrade
