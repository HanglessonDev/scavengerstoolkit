--- @file scavengerstoolkit\42.12\media\lua\shared\STK_FeedbackSystem.lua
--- Feature: Humanized Feedback System (OPTIONAL)
--- Gives "life" and "humanity" to the character with colored speech
--- This feature is OPTIONAL and can be disabled without affecting other features

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
-- MESSAGE POOLS
-- ============================================================================

local MESSAGES = {
	-- Success when adding upgrade
	ADD_SUCCESS = {
		"Ficou bom!",
		"Estou melhorando nisso.",
		"Perfeito.",
		"Consegui!",
	},

	-- Failure when removing upgrade (low skill)
	REMOVE_FAILED = {
		"Droga! Rasguei tudo...",
		"Merda, estraguei o material!",
		"Deveria ter mais cuidado...",
		"Talvez eu precise praticar mais...",
		"Que desastre...",
	},

	-- Expert success when removing (high skill)
	REMOVE_EXPERT = {
		"Fácil demais para mim.",
		"Anos de prática fazem diferença.",
		"Sem esforço.",
	},

	-- Failed to add (no tools, etc)
	ADD_FAILED = {
		"Preciso de ferramentas...",
		"Não tenho o que preciso.",
		"Impossível sem agulha e linha.",
	},
}

-- ============================================================================
-- ANTI-SPAM CONFIGURATION
-- ============================================================================

local SPAM_CONTROL = {
	ADD_SUCCESS_CHANCE = 30, -- 30% chance to speak on success
	ADD_FAILED_CHANCE = 80, -- 80% chance to speak on failure
	REMOVE_FAILED_CHANCE = 100, -- 100% chance to speak on critical failure
	REMOVE_EXPERT_CHANCE = 50, -- 50% chance for expert to speak
}

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

--- Pick random message from list
--- @param messageList table List of messages
--- @return string message Random message from list
local function pickRandomMessage(messageList)
	if not messageList or #messageList == 0 then
		return "..."
	end
	return messageList[ZombRand(#messageList) + 1]
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
--- @param bag any The bag
--- @param upgradeItem any The upgrade item
--- @param player any The player
local function onAddSuccess(bag, upgradeItem, player)
	if shouldSpeak(SPAM_CONTROL.ADD_SUCCESS_CHANCE) then
		local message = pickRandomMessage(MESSAGES.ADD_SUCCESS)
		SilentSpeaker.speakPositive(player, message)
		Logger.log("ADD_SUCCESS: " .. message)
	end
end

--- Handler: Failed to add upgrade
--- @param bag any The bag
--- @param upgradeItem any The upgrade item
--- @param player any The player
--- @param reason string Reason for failure
local function onAddFailed(bag, upgradeItem, player, reason)
	if shouldSpeak(SPAM_CONTROL.ADD_FAILED_CHANCE) then
		local message = pickRandomMessage(MESSAGES.ADD_FAILED)
		SilentSpeaker.speakAlert(player, message)
		Logger.log("ADD_FAILED (" .. (reason or "unknown") .. "): " .. message)
	end
end

--- Handler: After successfully removing upgrade
--- @param bag any The bag
--- @param upgradeType string The upgrade type removed
--- @param player any The player
local function onRemoveSuccess(bag, upgradeType, player)
	-- Check if player is expert (Tailoring >= 8)
	local level = player:getPerkLevel(Perks.Tailoring)

	if level >= 8 and shouldSpeak(SPAM_CONTROL.REMOVE_EXPERT_CHANCE) then
		local message = pickRandomMessage(MESSAGES.REMOVE_EXPERT)
		SilentSpeaker.speakInfo(player, message)
		Logger.log("REMOVE_EXPERT (Level " .. level .. "): " .. message)
	end
	-- Low level players don't speak on success (nothing special happened)
end

--- Handler: Failed to remove upgrade (material destroyed)
--- @param bag any The bag
--- @param upgradeType string The upgrade type
--- @param player any The player
--- @param reason string Reason for failure
local function onRemoveFailed(bag, upgradeType, player, reason)
	-- Always speak on critical failure (material lost)
	if shouldSpeak(SPAM_CONTROL.REMOVE_FAILED_CHANCE) then
		local message = pickRandomMessage(MESSAGES.REMOVE_FAILED)
		SilentSpeaker.speakAlert(player, message)
		Logger.log("REMOVE_FAILED (" .. (reason or "unknown") .. "): " .. message)
	end
end

-- ============================================================================
-- REGISTER HOOKS
-- ============================================================================

-- Register all hooks with LOW priority (runs last, doesn't interfere with logic)
STKBagUpgrade.registerHook("afterAdd", onAddSuccess, STKBagUpgrade.PRIORITY.LOW)
STKBagUpgrade.registerHook("onAddFailed", onAddFailed, STKBagUpgrade.PRIORITY.LOW)
STKBagUpgrade.registerHook("afterRemove", onRemoveSuccess, STKBagUpgrade.PRIORITY.LOW)
STKBagUpgrade.registerHook("onRemoveFailed", onRemoveFailed, STKBagUpgrade.PRIORITY.LOW)

Logger.log("Hooks registrados: afterAdd, onAddFailed, afterRemove, onRemoveFailed (LOW priority)")

-- ============================================================================
-- PUBLIC API (optional, for configuration)
-- ============================================================================

local STK_FeedbackSystem = {}

--- Get current spam control settings
--- @return table settings Current spam control settings
function STK_FeedbackSystem.getSpamControl()
	return SPAM_CONTROL
end

--- Update spam control chance
--- @param eventType string Type of event (ADD_SUCCESS, REMOVE_FAILED, etc)
--- @param chance number New chance (0-100)
function STK_FeedbackSystem.setSpamChance(eventType, chance)
	if SPAM_CONTROL[eventType .. "_CHANCE"] then
		SPAM_CONTROL[eventType .. "_CHANCE"] = math.max(0, math.min(100, chance))
		Logger.log("Updated " .. eventType .. "_CHANCE to " .. SPAM_CONTROL[eventType .. "_CHANCE"])
	end
end

--- Add custom message to pool
--- @param messageType string Type of message (ADD_SUCCESS, REMOVE_FAILED, etc)
--- @param message string The message to add
function STK_FeedbackSystem.addMessage(messageType, message)
	if MESSAGES[messageType] and message then
		table.insert(MESSAGES[messageType], message)
		Logger.log("Added message to " .. messageType .. ": " .. message)
	end
end

return STK_FeedbackSystem
