--- @file scavengerstoolkit\42.12\media\lua\server\STK_KnifeAlternative.lua
--- @brief Knife alternative check and degradation — integrated with STK_Validation
---
--- Exposes two functions consumed by STK_Validation.canRemoveUpgrade() and
--- STK_UpgradeLogic.removeUpgrade():
---
---   hasViableKnife(player)  — called by STK_Validation to allow removal
---   degradeKnife(player)    — called by STK_UpgradeLogic after removal
---
--- No hooks, no events. Pure logic called directly by the server pipeline.
---
--- NOTE (Refactor v3.0): Hooks removed. checkRemoveTools and afterRemove
--- hooks replaced by direct function calls in STK_Validation and
--- STK_UpgradeLogic respectively.
---
--- @author Scavenger's Toolkit Development Team
--- @version 3.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

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
		print("[STK-KnifeAlternative] " .. tostring(message))
	end,
}

Logger.log("Modulo carregado.")

-- ============================================================================
-- VIABLE KNIVES
-- ============================================================================

local VIABLE_KNIVES = {
	"Base.KitchenKnife",
	"Base.HuntingKnife",
	"Base.ButterKnife",
	"Base.Multitool",
	"Base.KnifePocket",
	"Base.KnifeFillet",
	"Base.KnifeButterfly",
	"Base.HandiKnife",
	"Base.StraightRazor",
}

-- ============================================================================
-- PUBLIC API
-- ============================================================================

--- @class STKKnifeAlternative
local STK_KnifeAlternative = {}

--- Returns the first viable knife found in the player's inventory, or nil.
--- Called by STK_Validation.canRemoveUpgrade() when scissors are absent
--- and SandboxVars.STK.KnifeAlternative is enabled.
--- @param player any IsoPlayer
--- @return string|nil knifeType
function STK_KnifeAlternative.findViableKnife(player)
	for _, knifeType in ipairs(VIABLE_KNIVES) do
		if player:getInventory():contains(knifeType) then
			Logger.log("Faca viavel encontrada: " .. knifeType)
			return knifeType
		end
	end
	Logger.log("Nenhuma faca viavel encontrada")
	return nil
end

--- Degrades the given knife by 1 condition point. Removes it if broken.
--- Called by STK_UpgradeLogic.removeUpgrade() via the toolUsed parameter.
--- @param player any IsoPlayer
--- @param knifeType string
function STK_KnifeAlternative.degradeKnife(player, knifeType)
	local knife = player:getInventory():getFirstType(knifeType)
	if not knife then
		return
	end

	knife:setCondition(knife:getCondition() - 1)

	if knife:getCondition() <= 0 then
		knife:getContainer():Remove(knife)
		Logger.log("Faca quebrou e foi removida: " .. knifeType)
	else
		Logger.log("Faca desgastada: " .. knifeType .. " -> " .. knife:getCondition())
	end
end

--- Returns the full list of viable knife type strings.
--- @return string[]
function STK_KnifeAlternative.getViableKnives()
	return VIABLE_KNIVES
end

-- ============================================================================

return STK_KnifeAlternative
