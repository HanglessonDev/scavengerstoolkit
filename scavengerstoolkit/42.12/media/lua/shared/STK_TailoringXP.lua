--- @file scavengerstoolkit\42.12\media\lua\shared\STK_TailoringXP.lua
--- Feature: Tailoring XP progression + Removal failure chance
--- Rewards skilled tailors while preventing exploit loops

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

Logger.log("Feature carregada: Tailoring XP + Removal Failure")

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
	local reduction = SandboxVars.STK.XPReductionPerLevel or 0.2

	-- Calculate regressive XP (never goes below minimum)
	local minXP = SandboxVars.STK.MinimumXP or 0.2
	local xp = math.max(minXP, baseXP - (level * reduction))

	-- Grant XP
	player:getXp():AddXP(Perks.Tailoring, xp)

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

		-- Player feedback messages
		local failureMessages = {
			getText("UI_STK_FailureMessage1") or "Droga! Rasguei tudo...",
			getText("UI_STK_FailureMessage2") or "Merda, estraguei o material!",
			getText("UI_STK_FailureMessage3") or "Deveria ter mais cuidado...",
			getText("UI_STK_FailureMessage4") or "Talvez eu precise praticar mais...",
		}

		-- Use ZombRand(4) to get 0-3, then add 1 for 1-4
		player:Say(failureMessages[ZombRand(4) + 1])
		-- player:Say(failureMessages[ZombRand(4) + 1], 1, 1, 1, UIFont.Small, 0)

		-- Return false to CANCEL the operation (no item created)
		return false
	end

	-- SUCCESS! Material recovered safely
	Logger.log(string.format("Sucesso! Roll: %d >= FailChance: %.0f%% (Level: %d)", roll, failChance, level))

	-- Expert feedback (level 8+)
	if level >= 8 then
		local expertMessages = {
			getText("UI_STK_ExpertMessage1") or "Fácil demais para mim.",
			getText("UI_STK_ExpertMessage2") or "Anos de prática fazem diferença.",
		}
		player:Say(expertMessages[ZombRand(2) + 1])
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
	local reduction = SandboxVars.STK.XPReductionPerLevel or 0.2
	local minXP = SandboxVars.STK.MinimumXP or 0.2
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
