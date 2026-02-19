--- @file scavengerstoolkit\42.12\media\lua\server\STK_UpgradeLogic.lua
--- @brief Authoritative upgrade logic — the only place bag state is modified
---
--- This module is the single source of truth for bag state. It applies and
--- removes upgrades, updates stats, and triggers result events. No other
--- module may write to bag ModData directly.
---
--- All public functions assume validation has already passed (STK_Validation).
--- They do not re-validate — callers are responsible for that.
---
--- @author Scavenger's Toolkit Development Team
--- @version 3.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

local STK_Core = require("STK_Core")
local STK_Utils = require("STK_Utils")
local STK_TailoringXP = require("STK_TailoringXP")
local log = require("STK_Logger").get("STK-UpgradeLogic")

-- ============================================================================
-- INTERNAL HELPERS
-- ============================================================================

--- Recalculates and applies bag stats from scratch based on current upgrades.
--- Always reads from stored base values (LCapacity, LWeightReduction) to
--- avoid floating-point drift from cumulative additions/subtractions.
--- @param bag any InventoryItem bag
local function updateBagStats(bag)
	local imd = bag:getModData()
	if not imd.LUpgrades then
		return
	end

	local finalCapacity = STK_Utils.calculateFinalCapacity(imd.LCapacity, imd.LUpgrades)
	local finalWR = STK_Utils.calculateFinalWeightReduction(imd.LWeightReduction, imd.LUpgrades)

	bag:setCapacity(finalCapacity)
	bag:setWeightReduction(finalWR)

	log.debug(
		string.format(
			"Stats atualizados — Capacidade: %d (base %d), WeightReduction: %.0f%% (base %.0f%%)",
			finalCapacity,
			imd.LCapacity,
			finalWR,
			imd.LWeightReduction
		)
	)
end

-- ============================================================================
-- PUBLIC API
-- ============================================================================

--- @class STKUpgradeLogic
local STK_UpgradeLogic = {}

--- Initialises a bag's ModData if not already done and triggers OnSTKBagInit.
--- Called the first time a valid bag is seen by the server (e.g. on open).
--- @param bag any InventoryItem bag
--- @return boolean isFirstInit True if this was the first initialisation
function STK_UpgradeLogic.initBag(bag)
	local isFirstInit = STK_Core.initBagData(bag)
	triggerEvent("OnSTKBagInit", bag, isFirstInit)

	log.debug(string.format("initBag: %s (firstInit=%s)", bag:getType(), tostring(isFirstInit)))

	return isFirstInit
end

--- Applies an upgrade to the bag, consumes the item and tool uses, updates
--- stats, and triggers OnSTKUpgradeAdded. Assumes validation already passed.
--- @param bag any InventoryItem bag
--- @param upgradeItem any InventoryItem upgrade to consume
--- @param player any IsoPlayer performing the action
function STK_UpgradeLogic.applyUpgrade(bag, upgradeItem, player)
	if not bag or not upgradeItem or not player then
		log.error("applyUpgrade chamado com parametros invalidos")
		triggerEvent("OnSTKUpgradeAddFailed", bag, upgradeItem, player, "invalid_params")
		return
	end

	local imd = bag:getModData()
	local upgradeType = upgradeItem:getType():gsub("^STK%.", "")

	-- Add to upgrade list
	table.insert(imd.LUpgrades, upgradeType)

	-- Consume upgrade item
	upgradeItem:getContainer():Remove(upgradeItem)

	-- Degrade needle (-1 condition). Stays in inventory when broken — vanilla behavior.
	local needle = player:getInventory():getFirstType("Base.Needle")
	if needle then
		needle:setCondition(needle:getCondition() - 1)
		if needle:getCondition() <= 0 then
			log.info("Agulha quebrou")
		end
	end

	-- Consume one thread use. Thread is a consumable — removed when depleted,
	-- unlike tools (needle, scissors, knife) which stay as broken items.
	local thread = player:getInventory():getFirstType("Base.Thread")
	if thread then
		thread:setUses(thread:getUses() - 1)
		if thread:getUses() <= 0 then
			thread:getContainer():Remove(thread)
			log.info("Linha esgotada e removida")
		end
	end

	-- Recalculate stats from base values
	updateBagStats(bag)

	log.info(string.format("applyUpgrade OK: %s em %s por %s", upgradeType, bag:getType(), player:getUsername()))

	local xp = STK_TailoringXP.grant(player)
	triggerEvent("OnSTKUpgradeAdded", bag, upgradeItem, player, xp)
end

--- Removes an upgrade from the bag.
--- If failure chance triggers, the item is not returned and
--- OnSTKUpgradeRemoveFailed is fired. Otherwise the item is returned to
--- inventory and OnSTKUpgradeRemoved is fired.
--- Assumes validation has already passed.
--- @param bag any InventoryItem bag
--- @param upgradeType string Upgrade type without "STK." prefix
--- @param player any IsoPlayer performing the action
--- @param toolUsed string|nil "scissors" or a knife type string, for degradation
function STK_UpgradeLogic.removeUpgrade(bag, upgradeType, player, toolUsed)
	if not bag or not upgradeType or not player then
		log.error("removeUpgrade chamado com parametros invalidos")
		triggerEvent("OnSTKUpgradeRemoveFailed", bag, upgradeType, player, "invalid_params")
		return
	end

	local imd = bag:getModData()

	-- Failure chance check
	local tailoringLevel = player:getPerkLevel(Perks.Tailoring)
	local failChance = STK_Utils.calculateFailureChance(tailoringLevel)
	local roll = ZombRand(101)
	local failed = SandboxVars.STK.RemovalFailureEnabled and (roll < failChance)

	-- Degrade tool regardless of outcome
	if toolUsed == "scissors" then
		local scissors = player:getInventory():getFirstType("Base.Scissors")
		if scissors then
			scissors:setCondition(scissors:getCondition() - 1)
			if scissors:getCondition() <= 0 then
				log.info("Tesoura quebrou")
			end
		end
	elseif toolUsed then
		local knife = player:getInventory():getFirstType(toolUsed)
		if knife then
			knife:setCondition(knife:getCondition() - 1)
			if knife:getCondition() <= 0 then
				log.info("Faca quebrou: " .. toolUsed)
			end
		end
	end

	-- Remove from upgrade list
	for i, upgrade in ipairs(imd.LUpgrades) do
		if upgrade == upgradeType then
			table.remove(imd.LUpgrades, i)
			break
		end
	end

	-- Recalculate stats from base values
	updateBagStats(bag)

	if failed then
		log.info(
			string.format(
				"removeUpgrade FALHOU: %s (roll=%d < failChance=%.0f%%, level=%d)",
				upgradeType,
				roll,
				failChance,
				tailoringLevel
			)
		)
		triggerEvent("OnSTKUpgradeRemoveFailed", bag, upgradeType, player, "material_destroyed")
		return
	end

	-- Return item to inventory
	local newItem = player:getInventory():AddItem("STK." .. upgradeType)
	if not newItem then
		log.error("CRITICO: falha ao devolver item STK." .. upgradeType)
	end

	log.info(string.format("removeUpgrade OK: %s de %s por %s", upgradeType, bag:getType(), player:getUsername()))

	triggerEvent("OnSTKUpgradeRemoved", bag, upgradeType, player)
end

-- ============================================================================

return STK_UpgradeLogic
