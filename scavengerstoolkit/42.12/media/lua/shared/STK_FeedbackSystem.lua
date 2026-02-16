--- @file scavengerstoolkit\42.12\media\lua\shared\STK_FeedbackSystem.lua
--- @brief Humanized contextual feedback system with anti-spam protection
---
--- This optional feature provides immersive, humanized speech feedback for
--- player actions. Features 17+ contextual messages in PT-BR + EN, silent
--- speech (zombies don't hear), and intelligent spam control.
---
--- @author Scavenger's Toolkit Development Team
--- @version 1.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

local STKBagUpgrade = require("STKBagUpgrade")
local SilentSpeaker = require("STK_SilentSpeaker")

-- ============================================================================
-- CONFIGURATION
-- ============================================================================

local DEBUG_MODE = true

local Logger = {
	log = function(message)
		if not DEBUG_MODE then
			return
		end
		print("[STK-FeedbackSystem] " .. tostring(message))
	end,
}

Logger.log("Feature carregada: Humanized Feedback System (OPTIONAL)")

-- ============================================================================
-- MESSAGE COUNTS (How many translation keys exist for each category)
-- ============================================================================

local MESSAGE_COUNTS = {
	ADD_SUCCESS = 4,
	REMOVE_FAILED = 6,
	REMOVE_EXPERT = 3,
	ADD_FAILED = 3,
}

-- ============================================================================
-- ANTI-SPAM CONFIGURATION
-- ============================================================================

local SPAM_CONTROL = {
	ADD_SUCCESS_CHANCE = 30,
	ADD_FAILED_CHANCE = 80,
	REMOVE_FAILED_CHANCE = 100,
	REMOVE_EXPERT_CHANCE = 50,
}

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

--- Picks a random translated message from a category
--- @param keyPrefix string The prefix for the translation key (e.g., "UI_STK_FB_AddSuccess")
--- @param count number The number of messages in that category
--- @return string message The translated message
local function pickRandomTranslatedMessage(keyPrefix, count)
	if not keyPrefix or not count or count == 0 then
		return "..."
	end
	-- Build the key, e.g., "UI_STK_FB_AddSuccess" + "3" -> "UI_STK_FB_AddSuccess3"
	local randomKey = keyPrefix .. (ZombRand(count) + 1)
	return getText(randomKey)
end

--- Check if should speak based on chance
--- @param chance number Chance percentage (0-100)
--- @return boolean shouldSpeak True if should speak
local function shouldSpeak(chance)
	return ZombRand(100) < chance
end

-- ============================================================================
-- HOOK HANDLERS
-- ============================================================================

--- Handler: After successfully adding upgrade
local function onAddSuccess(bag, upgradeItem, player)
	if shouldSpeak(SPAM_CONTROL.ADD_SUCCESS_CHANCE) then
		local message = pickRandomTranslatedMessage("UI_STK_FB_AddSuccess", MESSAGE_COUNTS.ADD_SUCCESS)
		SilentSpeaker.speakPositive(player, message)
		Logger.log("ADD_SUCCESS (Humanized): " .. message)
	end
end

--- Handler: Failed to add upgrade
local function onAddFailed(bag, upgradeItem, player, reason)
	if shouldSpeak(SPAM_CONTROL.ADD_FAILED_CHANCE) then
		local message = pickRandomTranslatedMessage("UI_STK_FB_AddFailed", MESSAGE_COUNTS.ADD_FAILED)
		SilentSpeaker.speakAlert(player, message)
		Logger.log("ADD_FAILED (" .. (reason or "unknown") .. "): " .. message)
	end
end

--- Handler: After successfully removing upgrade
local function onRemoveSuccess(bag, upgradeType, player)
	local level = player:getPerkLevel(Perks.Tailoring)
	if level >= 8 and shouldSpeak(SPAM_CONTROL.REMOVE_EXPERT_CHANCE) then
		local message = pickRandomTranslatedMessage("UI_STK_FB_RemoveExpert", MESSAGE_COUNTS.REMOVE_EXPERT)
		SilentSpeaker.speakInfo(player, message)
		Logger.log("REMOVE_EXPERT (Level " .. level .. "): " .. message)
	end
end

--- Handler: Failed to remove upgrade (material destroyed)
local function onRemoveFailed(bag, upgradeType, player, reason)
	if shouldSpeak(SPAM_CONTROL.REMOVE_FAILED_CHANCE) then
		local message = pickRandomTranslatedMessage("UI_STK_FB_RemoveFailed", MESSAGE_COUNTS.REMOVE_FAILED)
		SilentSpeaker.speakAlert(player, message)
		Logger.log("REMOVE_FAILED (" .. (reason or "unknown") .. "): " .. message)
	end
end

-- ============================================================================
-- REGISTER HOOKS
-- ============================================================================

STKBagUpgrade.registerHook("afterAdd", onAddSuccess, STKBagUpgrade.PRIORITY.LOW)
STKBagUpgrade.registerHook("onAddFailed", onAddFailed, STKBagUpgrade.PRIORITY.LOW)
STKBagUpgrade.registerHook("afterRemove", onRemoveSuccess, STKBagUpgrade.PRIORITY.LOW)
STKBagUpgrade.registerHook("onRemoveFailed", onRemoveFailed, STKBagUpgrade.PRIORITY.LOW)

Logger.log("Hooks registrados: afterAdd, onAddFailed, afterRemove, onRemoveFailed (LOW priority)")

-- ============================================================================
-- PUBLIC API (optional, for configuration)
-- ============================================================================

local STK_FeedbackSystem = {}

function STK_FeedbackSystem.getSpamControl()
	return SPAM_CONTROL
end

function STK_FeedbackSystem.setSpamChance(eventType, chance)
	if SPAM_CONTROL[eventType .. "_CHANCE"] then
		SPAM_CONTROL[eventType .. "_CHANCE"] = math.max(0, math.min(100, chance))
		Logger.log("Updated " .. eventType .. "_CHANCE to " .. SPAM_CONTROL[eventType .. "_CHANCE"])
	end
end

function STK_FeedbackSystem.getMessageCounts()
	return MESSAGE_COUNTS
end

return STK_FeedbackSystem