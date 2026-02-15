--- @file scavengerstoolkit\42.12\media\lua\shared\STK_TailoringXP.lua
--- Feature: Tailoring XP progression + Removal failure chance
--- Rewards skilled tailors while preventing exploit loops
--- VERSION 3.0 - RGB INT (0-255) + Simplified Say()

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

Logger.log("Feature carregada: Tailoring XP + Removal Failure v3.0")

-- ============================================================================
-- COLOR DEFINITIONS (RGB INT 0-255)
-- ============================================================================

local COLORS = {
	-- XP Gain (Light Green)
	XP_GAIN = { r = 102, g = 204, b = 102 }, -- (0.4, 0.8, 0.4)

	-- Failure (Red)
	FAILURE = { r = 255, g = 51, b = 51 }, -- (1.0, 0.2, 0.2)

	-- Success (Bright Green)
	SUCCESS = { r = 51, g = 255, b = 51 }, -- (0.2, 1.0, 0.2)

	-- Expert (Cyan)
	EXPERT = { r = 51, g = 204, b = 255 }, -- (0.2, 0.8, 1.0)
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
	local reduction = (reductionPercent / 100.0) -- Convert 20 -> 0.20

	-- Minimum XP also stored as integer percentage (20 = 0.20 XP)
	local minXPPercent = SandboxVars.STK.MinimumXP or 20
	local minXP = minXPPercent / 100.0 -- Convert 20 -> 0.20

	-- Calculate regressive XP (never goes below minimum)
	local xp = math.max(minXP, baseXP - (level * reduction))

	-- Grant XP (this adds to skill but doesn't show popup)
	player:getXp():AddXP(Perks.Tailoring, xp)

	-- VISUAL FEEDBACK: Floating text popup (like vanilla XP gain)
	-- HaloTextHelper.addTextWithArrow(player, text, arrowUp, r, g, b)
	-- RGB must be INT (0-255), not float!
	local xpText = string.format("+%.1f Tailoring", xp)
	local color = COLORS.XP_GAIN
	HaloTextHelper.addTextWithArrow(player, xpText, true, color.r, color.g, color.b)

	-- AUDIO FEEDBACK: Player says something (simplified, no color params)
	-- Only 30% chance to avoid spam
	if ZombRand(100) < 30 then
		local successMessages = {
			getText("UI_STK_AddSuccessMessage1") or "Ficou bom!",
			getText("UI_STK_AddSuccessMessage2") or "Estou melhorando nisso.",
		}
		-- Simple Say() without color parameters (uses default white)
		player:Say(successMessages[ZombRand(2) + 1])
	end

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

		-- VISUAL FEEDBACK: Red arrow down
		local failText = getText("UI_STK_MaterialDestroyed") or "Material Destruido!"
		local color = COLORS.FAILURE
		HaloTextHelper.addTextWithArrow(player, failText, false, color.r, color.g, color.b)

		-- AUDIO FEEDBACK: Player feedback (simplified Say)
		local failureMessages = {
			getText("UI_STK_FailureMessage1") or "Droga! Rasguei tudo...",
			getText("UI_STK_FailureMessage2") or "Merda, estraguei o material!",
			getText("UI_STK_FailureMessage3") or "Deveria ter mais cuidado...",
			getText("UI_STK_FailureMessage4") or "Talvez eu precise praticar mais...",
		}

		-- Simple Say() without color parameters
		player:Say(failureMessages[ZombRand(4) + 1])

		-- Return false to CANCEL the operation (no item created)
		return false
	end

	-- SUCCESS! Material recovered safely
	Logger.log(string.format("Sucesso! Roll: %d >= FailChance: %.0f%% (Level: %d)", roll, failChance, level))

	-- Expert feedback (level 8+, 50% chance to avoid spam)
	if level >= 8 and ZombRand(100) < 50 then
		local expertMessage = getText("UI_STK_ExpertMessage1") or "Facil demais para mim."

		-- Simple Say() without color parameters
		player:Say(expertMessage)
	end

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

--- Test colors in-game (debug function)
--- @param player any The player
function STK_TailoringXP.testColors(player)
	Logger.log("Testando cores do HaloTextHelper...")

	-- Test XP color
	HaloTextHelper.addTextWithArrow(
		player,
		"+2.0 XP (Verde)",
		true,
		COLORS.XP_GAIN.r,
		COLORS.XP_GAIN.g,
		COLORS.XP_GAIN.b
	)

	-- Test failure color
	HaloTextHelper.addTextWithArrow(
		player,
		"Falha! (Vermelho)",
		false,
		COLORS.FAILURE.r,
		COLORS.FAILURE.g,
		COLORS.FAILURE.b
	)

	-- Test success color
	HaloTextHelper.addTextWithArrow(
		player,
		"Sucesso! (Verde claro)",
		true,
		COLORS.SUCCESS.r,
		COLORS.SUCCESS.g,
		COLORS.SUCCESS.b
	)

	-- Test expert color
	HaloTextHelper.addTextWithArrow(player, "Expert (Ciano)", true, COLORS.EXPERT.r, COLORS.EXPERT.g, COLORS.EXPERT.b)

	Logger.log("Teste de cores concluido!")
end

return STK_TailoringXP
