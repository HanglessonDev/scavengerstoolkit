--- @file scavengerstoolkit\42.12\media\lua\client\STK_FeedbackSystem.lua
--- @brief Optional humanized feedback — colored silent speech on upgrade events
---
--- Listens to STK result events and reacts with contextual colored speech
--- bubbles via STK_SilentSpeaker. Also displays HaloText XP popups when
--- OnSTKUpgradeAdded carries a non-zero xpGained value.
---
--- Fully optional: removing this file disables all character speech and
--- XP popups without affecting any other feature.
---
--- @author Scavenger's Toolkit Development Team
--- @version 3.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

local SilentSpeaker = require("STK_SilentSpeaker")
local log = require("STK_Logger").get("STK-FeedbackSystem")

-- ============================================================================
-- CONFIGURATION
-- ============================================================================

--- Number of translation keys per message category.
--- Increase when adding new lines to UI_PTBR.txt / UI_EN.txt.
--- @type table<string, number>
local MESSAGE_COUNTS = {
	ADD_SUCCESS = 4,
	ADD_FAILED = 3,
	REMOVE_EXPERT = 3,
	REMOVE_FAILED = 6,
}

--- Percentage chance (0–100) that a speech bubble fires for each event.
--- @type table<string, number>
local SPAM_CONTROL = {
	ADD_SUCCESS_CHANCE = 30,
	ADD_FAILED_CHANCE = 80,
	REMOVE_EXPERT_CHANCE = 50,
	REMOVE_FAILED_CHANCE = 100,
}

--- Tailoring level threshold to trigger the "expert" remove message.
local EXPERT_LEVEL = 8

-- ============================================================================
-- HELPERS
-- ============================================================================

--- @param chance number 0–100
--- @return boolean
local function shouldSpeak(chance)
	return ZombRand(100) < chance
end

--- @param keyPrefix string e.g. "UI_STK_FB_AddSuccess"
--- @param count number
--- @return string
local function pickRandomMessage(keyPrefix, count)
	return getText(keyPrefix .. (ZombRand(count) + 1))
end

-- ============================================================================
-- EVENT HANDLERS
-- ============================================================================

--- OnSTKUpgradeAdded — success feedback + XP popup
--- @param bag any
--- @param upgradeItem any
--- @param player any
--- @param xpGained number
local function onUpgradeAdded(bag, upgradeItem, player, xpGained)
	if xpGained and xpGained > 0 then
		local xpText = string.format("+%.1f Tailoring", xpGained)
		HaloTextHelper.addTextWithArrow(player, xpText, true, 102, 204, 102)
	end

	if shouldSpeak(SPAM_CONTROL.ADD_SUCCESS_CHANCE) then
		local message = pickRandomMessage("UI_STK_FB_AddSuccess", MESSAGE_COUNTS.ADD_SUCCESS)
		SilentSpeaker.speakPositive(player, message)
		log.debug("ADD_SUCCESS: " .. message)
	end
end

--- OnSTKUpgradeAddFailed — failure feedback
--- @param bag any
--- @param upgradeItem any
--- @param player any
--- @param reason string
local function onUpgradeAddFailed(bag, upgradeItem, player, reason)
	if not shouldSpeak(SPAM_CONTROL.ADD_FAILED_CHANCE) then
		return
	end
	local message = pickRandomMessage("UI_STK_FB_AddFailed", MESSAGE_COUNTS.ADD_FAILED)
	SilentSpeaker.speakAlert(player, message)
	log.debug("ADD_FAILED (" .. (reason or "unknown") .. "): " .. message)
end

--- OnSTKUpgradeRemoved — expert speech if Tailoring level is high enough
--- @param bag any
--- @param upgradeType string
--- @param player any
local function onUpgradeRemoved(bag, upgradeType, player)
	local level = player:getPerkLevel(Perks.Tailoring)
	if level >= EXPERT_LEVEL and shouldSpeak(SPAM_CONTROL.REMOVE_EXPERT_CHANCE) then
		local message = pickRandomMessage("UI_STK_FB_RemoveExpert", MESSAGE_COUNTS.REMOVE_EXPERT)
		SilentSpeaker.speakInfo(player, message)
		log.debug("REMOVE_EXPERT (level=" .. level .. "): " .. message)
	end
end

--- OnSTKUpgradeRemoveFailed — material destroyed feedback
--- @param bag any
--- @param upgradeType string
--- @param player any
--- @param reason string
local function onUpgradeRemoveFailed(bag, upgradeType, player, reason)
	HaloTextHelper.addTextWithArrow(
		player,
		getText("UI_STK_MaterialDestroyed") or "Material Destruido!",
		false,
		255,
		51,
		51
	)

	if shouldSpeak(SPAM_CONTROL.REMOVE_FAILED_CHANCE) then
		local message = pickRandomMessage("UI_STK_FB_RemoveFailed", MESSAGE_COUNTS.REMOVE_FAILED)
		SilentSpeaker.speakAlert(player, message)
		log.debug("REMOVE_FAILED (" .. (reason or "unknown") .. "): " .. message)
	end
end

-- ============================================================================
-- REGISTER LISTENERS
-- ============================================================================

Events.OnSTKUpgradeAdded.Add(log.wrap(onUpgradeAdded, "onUpgradeAdded"))
Events.OnSTKUpgradeAddFailed.Add(log.wrap(onUpgradeAddFailed, "onUpgradeAddFailed"))
Events.OnSTKUpgradeRemoved.Add(log.wrap(onUpgradeRemoved, "onUpgradeRemoved"))
Events.OnSTKUpgradeRemoveFailed.Add(log.wrap(onUpgradeRemoveFailed, "onUpgradeRemoveFailed"))

log.info(
	"Listeners registrados: OnSTKUpgradeAdded, OnSTKUpgradeAddFailed, OnSTKUpgradeRemoved, OnSTKUpgradeRemoveFailed"
)

-- ============================================================================
-- PUBLIC API
-- ============================================================================

--- @class STKFeedbackSystem
local STK_FeedbackSystem = {}

--- Returns the current spam control table.
--- @return table<string, number>
function STK_FeedbackSystem.getSpamControl()
	return SPAM_CONTROL
end

--- Sets the speech chance for a given event type (clamped to 0–100).
--- @param eventType string Key without "_CHANCE" suffix (e.g. "ADD_SUCCESS")
--- @param chance number
function STK_FeedbackSystem.setSpamChance(eventType, chance)
	local key = eventType .. "_CHANCE"
	if SPAM_CONTROL[key] ~= nil then
		SPAM_CONTROL[key] = math.max(0, math.min(100, chance))
		log.debug("setSpamChance: " .. key .. " = " .. SPAM_CONTROL[key])
	end
end

--- Returns the current message count table.
--- @return table<string, number>
function STK_FeedbackSystem.getMessageCounts()
	return MESSAGE_COUNTS
end

-- ============================================================================

log.info("Modulo carregado.")

return STK_FeedbackSystem
