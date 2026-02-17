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
		print("[STK-Validation] " .. tostring(message))
	end,
}

Logger.log("Modulo carregado.")

-- ============================================================================
-- HELPERS
-- ============================================================================

--- Checks item identity in the player's inventory (prevents ID spoofing).
--- @param player any IsoPlayer
--- @param item any InventoryItem
--- @return boolean
local function playerHasItemInstance(player, item)
	local items = player:getInventory():getItems()
	for i = 0, items:size() - 1 do
		if items:get(i) == item then
			return true
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
		Logger.log("canApplyUpgrade: parametros invalidos")
		return false, "invalid_params"
	end

	if not STK_Core.isValidBag(bag) then
		Logger.log("canApplyUpgrade: bag invalida — " .. tostring(bag:getFullType()))
		return false, "invalid_params"
	end

	if not STK_Core.canAddUpgrade(bag) then
		Logger.log("canApplyUpgrade: limite de upgrades atingido")
		return false, "limit_reached"
	end

	if not playerHasItemInstance(player, upgradeItem) then
		Logger.log("canApplyUpgrade: item nao encontrado no inventario do player (anti-cheat)")
		return false, "item_not_in_inventory"
	end

	if not STK_Core.hasRequiredTools(player, "add") then
		Logger.log("canApplyUpgrade: ferramentas insuficientes (agulha/linha)")
		return false, "no_tools"
	end

	Logger.log("canApplyUpgrade: OK")
	return true, nil
end

--- Returns true if the player can remove the given upgrade from the bag.
--- On failure, also returns a reason string.
--- @param player any IsoPlayer
--- @param bag any InventoryItem bag
--- @param upgradeType string Upgrade type without "STK." prefix
--- @return boolean isValid
--- @return string|nil reason
function STK_Validation.canRemoveUpgrade(player, bag, upgradeType)
	if not player or not bag or not upgradeType then
		Logger.log("canRemoveUpgrade: parametros invalidos")
		return false, "invalid_params"
	end

	if not STK_Core.isValidBag(bag) then
		Logger.log("canRemoveUpgrade: bag invalida — " .. tostring(bag:getFullType()))
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
		Logger.log("canRemoveUpgrade: upgrade nao encontrado na mochila — " .. upgradeType)
		return false, "upgrade_not_found"
	end

	-- Check tools: scissors first, then knife alternative
	local hasScissors = player:getInventory():contains("Base.Scissors")

	if hasScissors then
		Logger.log("canRemoveUpgrade: OK (tesoura)")
		return true, nil, "scissors"
	end

	if SandboxVars.STK.KnifeAlternative then
		local knifeType = STK_KnifeAlternative.findViableKnife(player)
		if knifeType then
			Logger.log("canRemoveUpgrade: OK (faca — " .. knifeType .. ")")
			return true, nil, knifeType
		end
	end

	Logger.log("canRemoveUpgrade: sem ferramentas (tesoura/faca)")
	return false, "no_tools"
end

-- ============================================================================

return STK_Validation
