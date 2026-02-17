--- @file scavengerstoolkit\42.12\media\lua\shared\STK_Utils.lua
--- @brief Pure calculation utilities for the STK system
---
--- This module contains ONLY pure functions: given the same inputs they
--- always return the same outputs and never modify any external state.
---
--- RULES FOR THIS FILE:
---   - NO side effects of any kind
---   - NO modification of items, world state, or ModData
---   - NO event triggering
---   - NO UI calls (HaloText, SilentSpeaker, etc.)
---   - MAY require() STK_Core (read-only data access)
---
--- @author Scavenger's Toolkit Development Team
--- @version 3.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

local STK_Core = require("STK_Core")

--- @class STKUtils
local STK_Utils = {}

-- ============================================================================
-- BAG STAT CALCULATIONS
-- ============================================================================

--- Calculates the total capacity bonus granted by a list of applied upgrades.
--- @param upgrades string[] List of upgrade type strings (without "STK." prefix)
--- @return number capacityBonus Total bonus to add to base capacity
function STK_Utils.calculateCapacityBonus(upgrades)
	local bonus = 0
	for _, upgradeType in ipairs(upgrades) do
		local value = STK_Core.getUpgradeValue(upgradeType)
		if value and value > 0 then
			bonus = bonus + value
		end
	end
	return bonus
end

--- Calculates the total weight reduction bonus granted by a list of applied upgrades.
--- The result is a percentage value (e.g. 10 means 10%).
--- @param upgrades string[] List of upgrade type strings (without "STK." prefix)
--- @return number weightReductionBonus Total bonus percentage to add to base weight reduction
function STK_Utils.calculateWeightReductionBonus(upgrades)
	local bonus = 0
	for _, upgradeType in ipairs(upgrades) do
		local value = STK_Core.getUpgradeValue(upgradeType)
		if value and value < 0 then
			bonus = bonus + (math.abs(value) * 100)
		end
	end
	return bonus
end

--- Calculates the final capacity for a bag based on its base value and applied upgrades.
--- @param baseCapacity number The bag's original capacity (stored in LCapacity)
--- @param upgrades string[] List of applied upgrade types
--- @return number finalCapacity
function STK_Utils.calculateFinalCapacity(baseCapacity, upgrades)
	return baseCapacity + STK_Utils.calculateCapacityBonus(upgrades)
end

--- Calculates the final weight reduction for a bag, capped at 100%.
--- @param baseWeightReduction number The bag's original weight reduction (stored in LWeightReduction)
--- @param upgrades string[] List of applied upgrade types
--- @return number finalWeightReduction Capped at 100
function STK_Utils.calculateFinalWeightReduction(baseWeightReduction, upgrades)
	return math.min(100, baseWeightReduction + STK_Utils.calculateWeightReductionBonus(upgrades))
end

-- ============================================================================
-- TAILORING XP CALCULATIONS
-- ============================================================================

--- Calculates the XP to grant when adding an upgrade.
--- XP is regressive: decreases as the player's Tailoring skill increases,
--- but never drops below the configured minimum.
--- Reads from SandboxVars with safe defaults.
--- @param tailoringLevel number The player's current Tailoring perk level
--- @return number xp The XP amount to grant
function STK_Utils.calculateTailoringXP(tailoringLevel)
	local baseXP = SandboxVars.STK.AddUpgradeXP or 2.0
	local reduction = (SandboxVars.STK.XPReductionPerLevel or 20) / 100.0
	local minXP = (SandboxVars.STK.MinimumXP or 20) / 100.0
	return math.max(minXP, baseXP - (tailoringLevel * reduction))
end

--- Calculates the failure chance (0–100) when removing an upgrade.
--- Chance decreases as Tailoring skill increases, floored at 0.
--- Reads from SandboxVars with safe defaults.
--- @param tailoringLevel number The player's current Tailoring perk level
--- @return number failChance Percentage chance of failure (0–100)
function STK_Utils.calculateFailureChance(tailoringLevel)
	local baseChance = SandboxVars.STK.BaseFailureChance or 50
	local reductionPerLevel = SandboxVars.STK.FailureReductionPerLevel or 5
	return math.max(0, baseChance - (tailoringLevel * reductionPerLevel))
end

-- ============================================================================

return STK_Utils
