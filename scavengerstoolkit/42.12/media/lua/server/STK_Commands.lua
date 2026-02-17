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
---     2. STK_TailoringXP.grant()
---     3. STK_UpgradeLogic.applyUpgrade()   → fires OnSTKUpgradeAdded
---
---   Remove pipeline:
---     1. STK_Validation.canRemoveUpgrade()
---     2. STK_Validation.resolveRemoveTool()
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
local STK_TailoringXP = require("STK_TailoringXP")

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
		print("[STK-Commands] " .. tostring(message))
	end,
}

Logger.log("Modulo carregado.")

-- ============================================================================
-- PIPELINE HANDLERS
-- ============================================================================

--- Handles the completion of an add-upgrade timed action.
--- Runs the full server-side add pipeline.
--- @param bag any InventoryItem bag
--- @param upgradeItem any InventoryItem upgrade
--- @param player any IsoPlayer
local function handleActionAddComplete(bag, upgradeItem, player)
	Logger.log(
		string.format(
			"handleActionAddComplete: %s em %s por %s",
			tostring(upgradeItem and upgradeItem:getType()),
			tostring(bag and bag:getType()),
			tostring(player and player:getUsername())
		)
	)

	local isValid, reason = STK_Validation.canApplyUpgrade(player, bag, upgradeItem)
	if not isValid then
		Logger.log("Validacao falhou: " .. (reason or "unknown"))
		Events.OnSTKUpgradeAddFailed.trigger(bag, upgradeItem, player, reason)
		return
	end

	local xpGained = STK_TailoringXP.grant(player)
	STK_UpgradeLogic.applyUpgrade(bag, upgradeItem, player, xpGained)
end

--- Handles the completion of a remove-upgrade timed action.
--- Runs the full server-side remove pipeline.
--- @param bag any InventoryItem bag
--- @param upgradeType string Upgrade type without "STK." prefix
--- @param player any IsoPlayer
local function handleActionRemoveComplete(bag, upgradeType, player)
	Logger.log(
		string.format(
			"handleActionRemoveComplete: %s de %s por %s",
			tostring(upgradeType),
			tostring(bag and bag:getType()),
			tostring(player and player:getUsername())
		)
	)

	local isValid, reason = STK_Validation.canRemoveUpgrade(player, bag, upgradeType)
	if not isValid then
		Logger.log("Validacao falhou: " .. (reason or "unknown"))
		Events.OnSTKUpgradeRemoveFailed.trigger(bag, upgradeType, player, reason)
		return
	end

	local toolUsed = STK_Validation.resolveRemoveTool(player)
	STK_UpgradeLogic.removeUpgrade(bag, upgradeType, player, toolUsed)
end

-- ============================================================================
-- EVENT LISTENERS
-- ============================================================================

Events.OnSTKActionAddComplete.Add(handleActionAddComplete)
Events.OnSTKActionRemoveComplete.Add(handleActionRemoveComplete)

Logger.log("Listeners registrados: OnSTKActionAddComplete, OnSTKActionRemoveComplete")
