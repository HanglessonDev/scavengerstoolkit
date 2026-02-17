--- @file scavengerstoolkit\42.12\media\lua\shared\STK_Events.lua
--- @brief Declaration of all custom STK events
---
--- This file registers every custom event used by the STK system via
--- LuaEventManager.AddEvent(). It must be loaded before any file that
--- triggers or listens to these events.
---
--- EVENT CONTRACT
--- ==============
---
--- Internal events (fired by TimedActions, heard by server):
---
---   OnSTKActionAddComplete(bag, upgradeItem, player)
---     Fired when the "add upgrade" timed action finishes successfully.
---     Server listens to validate and apply the upgrade.
---
---   OnSTKActionRemoveComplete(bag, upgradeType, player)
---     Fired when the "remove upgrade" timed action finishes successfully.
---     Server listens to validate and execute the removal.
---
--- Result events (fired by server logic, heard by client and external mods):
---
---   OnSTKBagInit(bag, isFirstInit)
---     Fired after a bag's ModData is initialised.
---     STK_ContainerLimits listens to set LMaxUpgrades.
---
---   OnSTKUpgradeAdded(bag, upgradeItem, player, xpGained)
---     Fired after an upgrade is successfully applied.
---     Client FeedbackSystem listens for visual feedback.
---     xpGained (number): XP granted by the server, for display purposes.
---
---   OnSTKUpgradeAddFailed(bag, upgradeItem, player, reason)
---     Fired when an upgrade could not be applied.
---     Client FeedbackSystem listens for visual feedback.
---     reason (string): one of "invalid_params", "limit_reached",
---                      "no_tools", "item_not_in_inventory"
---
---   OnSTKUpgradeRemoved(bag, upgradeType, player)
---     Fired after an upgrade is successfully removed and item returned.
---
---   OnSTKUpgradeRemoveFailed(bag, upgradeType, player, reason)
---     Fired when removal fails (e.g. material destroyed by failure chance).
---     reason (string): one of "invalid_params", "no_tools",
---                      "upgrade_not_found", "material_destroyed"
---
--- RULES FOR THIS FILE:
---   - ONLY AddEvent() calls and documentation
---   - NO listeners (.Add), NO triggers (.trigger)
---   - NO game logic of any kind
---
--- @author Scavenger's Toolkit Development Team
--- @version 3.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

local DEBUG_MODE = true

local Logger = {
	log = function(message)
		if not DEBUG_MODE then
			return
		end
		print("[STK-Events] " .. tostring(message))
	end,
}

--- TimedAction → Server
LuaEventManager.AddEvent("OnSTKActionAddComplete")
LuaEventManager.AddEvent("OnSTKActionRemoveComplete")

--- Server → Client + External mods
LuaEventManager.AddEvent("OnSTKBagInit")
LuaEventManager.AddEvent("OnSTKUpgradeAdded")
LuaEventManager.AddEvent("OnSTKUpgradeAddFailed")
LuaEventManager.AddEvent("OnSTKUpgradeRemoved")
LuaEventManager.AddEvent("OnSTKUpgradeRemoveFailed")

Logger.log("Events registrados (7)")
