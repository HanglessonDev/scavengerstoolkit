--- @file scavengerstoolkit\42.12\media\lua\shared\STK_KnifeAlternative.lua
--- @brief Alternative tool system allowing knives for upgrade removal
---
--- This feature enables players to use 9 different knife types as an
--- alternative to scissors when removing upgrades. Includes tool wear
--- system and is fully configurable via Sandbox options.
---
--- @author Scavenger's Toolkit Development Team
--- @version 1.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

local STKBagUpgrade = require("STKBagUpgrade")

-- ============================================================================
-- CONFIGURATION
-- ============================================================================

local DEBUG_MODE = true

local Logger = {
	log = function(message)
		if not DEBUG_MODE then
			return
		end
		print("[STK-KnifeAlternative] " .. tostring(message))
	end,
}

Logger.log("Feature carregada: Knife Alternative")

-- ============================================================================
-- VIABLE KNIVES LIST
-- ============================================================================

--- List of knives that can be used to remove upgrades
--- Conservative approach - only realistic cutting tools
local VIABLE_KNIVES = {
	"Base.KitchenKnife", -- Faca de cozinha
	"Base.HuntingKnife", -- Faca de caça
	"Base.ButterKnife", -- Faca de manteiga
	"Base.Multitool", -- Canivete suíço
	"Base.KnifePocket", -- Canivete
	"Base.KnifeFillet", -- Faca de filetar
	"Base.KnifeButterfly", -- Butterfly knife
	"Base.HandiKnife", -- Utility knife (estilete)
	"Base.StraightRazor", -- Navalha de barbear
}

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

--- Check if player has a viable knife
--- @param player any The player
--- @return boolean hasKnife True if player has any viable knife
--- @return string|nil knifeType The type of knife found
local function hasViableKnife(player)
	for _, knifeType in ipairs(VIABLE_KNIVES) do
		if player:getInventory():contains(knifeType) then
			return true, knifeType
		end
	end
	return false, nil
end

-- ============================================================================
-- HOOKS
-- ============================================================================

--- Hook: Check if player has alternative tools (knives) for removing
--- @param player any The player
--- @param toolCheck table Table to modify with result
local function checkKnifeAlternative(player, toolCheck)
	-- Feature disabled in Sandbox
	if not SandboxVars.STK.KnifeAlternative then
		Logger.log("Feature desabilitada no Sandbox")
		return
	end

	-- Check for viable knife
	local hasKnife, knifeType = hasViableKnife(player)

	if hasKnife then
		Logger.log("Faca viavel encontrada: " .. knifeType)
		toolCheck.hasAlternative = true
		toolCheck.alternativeTool = knifeType
	else
		Logger.log("Nenhuma faca viavel encontrada")
	end
end

--- Hook: Degrade knife when used to remove upgrade
--- @param bag any The bag
--- @param upgradeType string The upgrade being removed
--- @param player any The player
local function degradeKnifeOnRemove(bag, upgradeType, player)
	-- Only if feature is enabled
	if not SandboxVars.STK.KnifeAlternative then
		return
	end

	-- If player has scissors, they used scissors (not knife)
	if player:getInventory():contains("Base.Scissors") then
		return
	end

	-- Find and degrade the knife they used
	local hasKnife, knifeType = hasViableKnife(player)
	if hasKnife then
		local knife = player:getInventory():getFirstType(knifeType)
		if knife then
			-- Degrade knife by 1 point
			knife:setCondition(knife:getCondition() - 1)
			Logger.log("Faca desgastada: " .. knifeType .. " -> " .. knife:getCondition())

			-- Remove if broken
			if knife:getCondition() <= 0 then
				knife:getContainer():Remove(knife)
				Logger.log("Faca quebrou e foi removida")
			end
		end
	end
end

-- Register hooks
STKBagUpgrade.registerHook(
	"checkRemoveTools",
	checkKnifeAlternative,
	STKBagUpgrade.PRIORITY.HIGH -- High priority to check early
)

STKBagUpgrade.registerHook("afterRemove", degradeKnifeOnRemove, STKBagUpgrade.PRIORITY.NORMAL)

Logger.log("Hooks registrados: checkRemoveTools, afterRemove")

-- ============================================================================
-- PUBLIC API (optional)
-- ============================================================================

local STK_KnifeAlternative = {}

--- Get list of viable knives
--- @return table knives Array of viable knife types
function STK_KnifeAlternative.getViableKnives()
	return VIABLE_KNIVES
end

return STK_KnifeAlternative
