--- @file scavengerstoolkit\42.12\media\lua\server\STK_Validation.lua
--- @brief Server-side validation — anti-cheat checks before any state change
---
--- Every operation that modifies bag state must pass through this module.
--- The server never trusts data received from the client.
---
--- Validation rules for adding an upgrade:
---   1. bag and upgradeItem are non-nil
---   2. bag is a valid STK bag (STK_Core.isValidBag)
---   3. bag has not reached LMaxUpgrades (STK_Core.canAddUpgrade)
---   4. upgradeItem is physically present in player's inventory by identity
---   5. player has needle + thread (STK_Core.hasRequiredTools)
---
--- Validation rules for removing an upgrade:
---   1. bag and upgradeType are non-nil
---   2. bag is a valid STK bag
---   3. upgradeType exists in bag LUpgrades
---   4. player has scissors, OR knife if KnifeAlternative is enabled
---
--- @author Scavenger's Toolkit Development Team
--- @version 3.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

local STK_Core = require("STK_Core")
local STK_KnifeAlternative = require("STK_KnifeAlternative")
local log = require("STK_Logger").get("STK-Validation")

-- ============================================================================
-- HELPERS
-- ============================================================================

--- Checks item identity by scanning the player's main inventory and all
--- equipped containers. Prevents ID spoofing while supporting items stored
--- inside equipped bags.
--- @param player any IsoPlayer
--- @param item any InventoryItem
--- @return boolean
local function playerHasItemInstance(player, item)
	-- Check main inventory first (fast path)
	local items = player:getInventory():getItems()
	for i = 0, items:size() - 1 do
		if items:get(i) == item then
			return true
		end
	end

	-- Check all equipped containers
	local wornItems = player:getWornItems()
	for i = 0, wornItems:size() - 1 do
		local worn = wornItems:getItemByIndex(i)
		if worn and worn:IsInventoryContainer() then
			local wornContents = worn:getInventory():getItems()
			for j = 0, wornContents:size() - 1 do
				if wornContents:get(j) == item then
					return true
				end
			end
		end
	end

	return false
end

--- Returns true if the player has the item type in main inventory or any
--- equipped container. Mirrors STK_Core.playerHasItem but local to avoid
--- exposing internals — validation needs its own copy for anti-cheat checks.
--- @param player any IsoPlayer
--- @param itemType string Full type string e.g. "Base.Scissors"
--- @return boolean
local function playerHasItemType(player, itemType)
	if player:getInventory():contains(itemType) then
		return true
	end

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

-- ============================================================================
-- PUBLIC API
-- ============================================================================

--- @class STKValidation
local STK_Validation = {}

--- Returns true if the player can apply the given upgrade to the bag.
--- On failure, also returns a reason string.
--- @param player any IsoPlayer
--- @param bag any InventoryItem bag
--- @param upgradeItem any InventoryItem upgrade
--- @return boolean isValid
--- @return string|nil reason
function STK_Validation.canApplyUpgrade(player, bag, upgradeItem)
	if not player or not bag or not upgradeItem then
		log.warn("canApplyUpgrade: parametros invalidos")
		return false, "invalid_params"
	end

	if not STK_Core.isValidBag(bag) then
		log.warn("canApplyUpgrade: bag invalida — " .. tostring(bag:getFullType()))
		return false, "invalid_params"
	end

	if not STK_Core.canAddUpgrade(bag) then
		log.warn("canApplyUpgrade: limite de upgrades atingido")
		return false, "limit_reached"
	end

	if not playerHasItemInstance(player, upgradeItem) then
		log.warn("canApplyUpgrade: item nao encontrado no inventario do player (anti-cheat)")
		return false, "item_not_in_inventory"
	end

	if not STK_Core.hasRequiredTools(player, "add") then
		log.warn("canApplyUpgrade: ferramentas insuficientes (agulha/linha)")
		return false, "no_tools"
	end

	log.debug("canApplyUpgrade: OK")
	return true, nil
end

--- Returns true if the player can remove the given upgrade from the bag.
--- On failure, also returns a reason string.
--- Also returns the tool that will be used for degradation.
--- @param player any IsoPlayer
--- @param bag any InventoryItem bag
--- @param upgradeType string Upgrade type without "STK." prefix
--- @return boolean success
--- @return string|nil reason "no_tools", "upgrade_not_found", etc.
--- @return string|nil toolUsed "scissors" or knife type if successful
function STK_Validation.canRemoveUpgrade(player, bag, upgradeType)
	if not player or not bag or not upgradeType then
		log.warn("canRemoveUpgrade: parametros invalidos")
		return false, "invalid_params"
	end

	if not STK_Core.isValidBag(bag) then
		log.warn("canRemoveUpgrade: bag invalida — " .. tostring(bag:getFullType()))
		return false, "invalid_params"
	end

	-- Check upgrade exists in bag
	local imd = bag:getModData()
	local found = false
	for _, upgrade in ipairs(imd.LUpgrades or {}) do
		if upgrade == upgradeType then
			found = true
			break
		end
	end

	if not found then
		log.warn("canRemoveUpgrade: upgrade nao encontrado na mochila — " .. upgradeType)
		return false, "upgrade_not_found"
	end

	-- Scissors check: main inventory + equipped containers
	if playerHasItemType(player, "Base.Scissors") then
		log.debug("canRemoveUpgrade: OK (tesoura)")
		return true, nil, "scissors"
	end

	-- Knife alternative: STK_KnifeAlternative already searches main inventory.
	-- For equipped containers, we search here since findViableKnife only checks
	-- player:getInventory(). This keeps KnifeAlternative module simple.
	if SandboxVars.STK and SandboxVars.STK.KnifeAlternative then
		local STK_Constants = require("STK_Constants")
		for _, knifeType in ipairs(STK_Constants.VIABLE_KNIVES) do
			if playerHasItemType(player, knifeType) then
				log.debug("canRemoveUpgrade: OK (faca — " .. knifeType .. ")")
				return true, nil, knifeType
			end
		end
	end

	log.warn("canRemoveUpgrade: sem ferramentas (tesoura/faca)")
	return false, "no_tools"
end

-- ============================================================================

log.info("Modulo carregado.")

return STK_Validation
