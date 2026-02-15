--- @file scavengerstoolkit\42.12\media\lua\shared\STK_TailoringXP.lua
--- Feature: Tailoring XP progression + Removal failure chance
--- VERSION 4.0 - Integration with FeedbackSystem
--- XP popups remain here (feature-specific)
--- Speech feedback moved to STK_FeedbackSystem (optional)

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
		print("[STK-TailoringXP] " .. tostring(message))
	end,
}

Logger.log("Feature carregada: Tailoring XP + Removal Failure v4.0")

-- ============================================================================
-- COLOR DEFINITIONS (RGB INT 0-255 for HaloTextHelper)
-- ============================================================================

local COLORS = {
	XP_GAIN = { r = 102, g = 204, b = 102 }, -- Light green
	FAILURE = { r = 255, g = 51, b = 51 }, -- Red
}

-- ============================================================================
-- XP WHEN ADDING UPGRADES
-- ============================================================================

--- Grant XP when adding an upgrade (regressive based on skill level)
--- @param bag any The bag being upgraded
--- @param upgradeItem any The upgrade item being added
--- @param player any The player performing the action
local function grantAddXP(bag, upgradeItem, player)
	-- Check if feature is enabled
	if not SandboxVars.STK.TailoringXPEnabled then
		Logger.log("Feature desabilitada no Sandbox")
		return
	end

	local level = player:getPerkLevel(Perks.Tailoring)
	local baseXP = SandboxVars.STK.AddUpgradeXP or 2.0

	-- Sandbox stores as integer percentage (20 = 0.20 XP)
	local reductionPercent = SandboxVars.STK.XPReductionPerLevel or 20
	local reduction = (reductionPercent / 100.0)

	-- Minimum XP also stored as integer percentage (20 = 0.20 XP)
	local minXPPercent = SandboxVars.STK.MinimumXP or 20
	local minXP = minXPPercent / 100.0

	-- Calculate regressive XP (never goes below minimum)
	local xp = math.max(minXP, baseXP - (level * reduction))

	-- Grant XP (adds to skill internally)
	player:getXp():AddXP(Perks.Tailoring, xp)

	-- VISUAL FEEDBACK: Floating text popup (RGB as INT 0-255)
	local xpText = string.format("+%.1f Tailoring", xp)
	local color = COLORS.XP_GAIN
	HaloTextHelper.addTextWithArrow(player, xpText, true, color.r, color.g, color.b)

	-- NOTE: Speech feedback removed - handled by STK_FeedbackSystem (optional)

	Logger.log(
		string.format(
			"XP concedido: %.1f (Level: %d, Base: %.1f, Reduction: %.1f)",
			xp,
			level,
			baseXP,
			level * reduction
		)
	)
end

-- Register hook with LOW priority (runs after stats are applied)
STKBagUpgrade.registerHook("afterAdd", grantAddXP, STKBagUpgrade.PRIORITY.LOW)

-- ============================================================================
-- FAILURE CHANCE WHEN REMOVING UPGRADES
-- ============================================================================

--- Check if removal fails and destroys material
--- @param bag any The bag being modified
--- @param upgradeType string The type of upgrade being removed
--- @param player any The player performing the action
--- @return boolean success True to continue, false to cancel and destroy material
local function checkRemovalFailure(bag, upgradeType, player)
	-- Check if feature is enabled
	if not SandboxVars.STK.RemovalFailureEnabled then
		Logger.log("Chance de falha desabilitada no Sandbox")
		return true -- Continue normally
	end

	local level = player:getPerkLevel(Perks.Tailoring)
	local baseChance = SandboxVars.STK.BaseFailureChance or 50
	local reductionPerLevel = SandboxVars.STK.FailureReductionPerLevel or 5

	-- Calculate failure chance (never goes below 0)
	local failChance = math.max(0, baseChance - (level * reductionPerLevel))

	-- Roll for failure (ZombRand(101) gives 0-100 inclusive)
	local roll = ZombRand(101)
	local failed = roll < failChance

	if failed then
		-- FAILURE! Material destroyed
		Logger.log(string.format("FALHA! Roll: %d < FailChance: %.0f%% (Level: %d)", roll, failChance, level))

		-- VISUAL FEEDBACK: Red popup with arrow down
		local failText = getText("UI_STK_MaterialDestroyed") or "Material Destruido!"
		local color = COLORS.FAILURE
		HaloTextHelper.addTextWithArrow(player, failText, false, color.r, color.g, color.b)

		-- NOTE: Speech feedback removed - handled by STK_FeedbackSystem (optional)

		-- Return false to CANCEL the operation (no item created)
		-- This triggers onRemoveFailed hook
		return false
	end

	-- SUCCESS! Material recovered safely
	Logger.log(string.format("Sucesso! Roll: %d >= FailChance: %.0f%% (Level: %d)", roll, failChance, level))

	-- NOTE: Expert speech feedback removed - handled by STK_FeedbackSystem (optional)

	-- Return true to CONTINUE with normal removal
	return true
end

-- Register hook with HIGH priority (must run BEFORE item is created)
STKBagUpgrade.registerHook("beforeRemove", checkRemovalFailure, STKBagUpgrade.PRIORITY.HIGH)

Logger.log("Hooks registrados: afterAdd (LOW), beforeRemove (HIGH)")

-- ============================================================================
-- PUBLIC API (optional, for debugging/testing)
-- ============================================================================

local STK_TailoringXP = {}

--- Calculate XP that would be granted for current skill level
--- @param player any The player
--- @return number xp The XP that would be granted
function STK_TailoringXP.calculateXP(player)
	local level = player:getPerkLevel(Perks.Tailoring)
	local baseXP = SandboxVars.STK.AddUpgradeXP or 2.0
	local reductionPercent = SandboxVars.STK.XPReductionPerLevel or 20
	local reduction = reductionPercent / 100.0
	local minXPPercent = SandboxVars.STK.MinimumXP or 20
	local minXP = minXPPercent / 100.0
	return math.max(minXP, baseXP - (level * reduction))
end

--- Calculate failure chance for current skill level
--- @param player any The player
--- @return number failChance Failure chance as percentage (0-100)
function STK_TailoringXP.calculateFailureChance(player)
	local level = player:getPerkLevel(Perks.Tailoring)
	local baseChance = SandboxVars.STK.BaseFailureChance or 50
	local reductionPerLevel = SandboxVars.STK.FailureReductionPerLevel or 5
	return math.max(0, baseChance - (level * reductionPerLevel))
end

return STK_TailoringXP
