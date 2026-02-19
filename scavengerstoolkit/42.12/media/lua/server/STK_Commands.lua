--- @file scavengerstoolkit\42.12\media\lua\server\STK_Commands.lua
--- @brief Server-side command handler — receives and routes client requests
---
--- Single entry point for all client→server communication in STK.
--- Listens to OnSTKActionAddComplete and OnSTKActionRemoveComplete
--- (fired by ISSTKBagUpgradeAction after the timed animation completes)
--- and runs the full server pipeline for each operation:
---
---   Add pipeline:
---     1. STK_Validation.canApplyUpgrade()
---     2. STK_UpgradeLogic calls STK_TailoringXP.grant() internally
---     3. STK_UpgradeLogic.applyUpgrade()   → fires OnSTKUpgradeAdded
---
---   Remove pipeline:
---     1. STK_Validation.canRemoveUpgrade()
---     3. STK_UpgradeLogic.removeUpgrade()  → fires OnSTKUpgradeRemoved
---                                             or OnSTKUpgradeRemoveFailed
---
--- In singleplayer, server/ files execute in the same process as the
--- client, so Events fired here are received immediately by client
--- listeners (STK_FeedbackSystem).
---
--- @author Scavenger's Toolkit Development Team
--- @version 3.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

local STK_Validation = require("STK_Validation")
local STK_UpgradeLogic = require("STK_UpgradeLogic")
local log = require("STK_Logger").get("STK-Commands")

-- ============================================================================
-- PIPELINE HANDLERS
-- ============================================================================

--- Handles the completion of an add-upgrade timed action.
--- Runs the full server-side add pipeline.
--- @param bag any InventoryItem bag
--- @param upgradeItem any InventoryItem upgrade
--- @param player any IsoPlayer
local function handleActionAddComplete(bag, upgradeItem, player)
	log.debug(
		string.format(
			"handleActionAddComplete: %s em %s por %s",
			tostring(upgradeItem and upgradeItem:getType()),
			tostring(bag and bag:getType()),
			tostring(player and player:getUsername())
		)
	)

	local isValid, reason = STK_Validation.canApplyUpgrade(player, bag, upgradeItem)
	if not isValid then
		log.warn("Validacao ADD falhou: " .. (reason or "unknown"))
		triggerEvent("OnSTKUpgradeAddFailed", bag, upgradeItem, player, reason)
		return
	end

	STK_UpgradeLogic.applyUpgrade(bag, upgradeItem, player)
end

--- Handles the completion of a remove-upgrade timed action.
--- Runs the full server-side remove pipeline.
--- @param bag any InventoryItem bag
--- @param upgradeType string Upgrade type without "STK." prefix
--- @param player any IsoPlayer
local function handleActionRemoveComplete(bag, upgradeType, player)
	log.debug(
		string.format(
			"handleActionRemoveComplete: %s de %s por %s",
			tostring(upgradeType),
			tostring(bag and bag:getType()),
			tostring(player and player:getUsername())
		)
	)

	local isValid, reason, toolUsed = STK_Validation.canRemoveUpgrade(player, bag, upgradeType)
	if not isValid then
		log.warn("Validacao REMOVE falhou: " .. (reason or "unknown"))
		triggerEvent("OnSTKUpgradeRemoveFailed", bag, upgradeType, player, reason)
		return
	end

	STK_UpgradeLogic.removeUpgrade(bag, upgradeType, player, toolUsed)
end

-- ============================================================================
-- EVENT LISTENERS
-- ============================================================================

Events.OnSTKActionAddComplete.Add(log.wrap(handleActionAddComplete, "handleActionAddComplete"))
Events.OnSTKActionRemoveComplete.Add(log.wrap(handleActionRemoveComplete, "handleActionRemoveComplete"))

log.info("Listeners registrados: OnSTKActionAddComplete, OnSTKActionRemoveComplete")
