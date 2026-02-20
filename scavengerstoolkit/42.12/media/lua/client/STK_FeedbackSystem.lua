--- @file scavengerstoolkit\42.12\media\lua\client\STK_FeedbackSystem.lua
--- @brief Optional humanized feedback — colored silent speech on upgrade events
---
--- Listens to STK result events and reacts with contextual colored speech
--- bubbles via STK_SilentSpeaker. Also displays HaloText XP popups when
--- OnSTKUpgradeAdded carries a non-zero xpGained value.
---
--- Message system features:
---   - Weighted rarity: C (common=10), I (incommon=4), R (rare=1)
---   - Anti-repetition: never repeats the last used message per category
---   - Rare cooldown: each rare fires at most once per session
---   - Keys follow the pattern UI_STK_FB_<Category>_<Rarity><Index>
---
--- Fully optional: removing this file disables all character speech and
--- XP popups without affecting any other feature.
---
--- @author Scavenger's Toolkit Development Team
--- @version 3.1.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

local SilentSpeaker = require("STK_SilentSpeaker")
local log = require("STK_Logger").get("STK-FeedbackSystem")

-- ============================================================================
-- WEIGHTS
-- ============================================================================

--- Base weight per rarity tier.
local WEIGHT_C = 13 -- common
local WEIGHT_I = 5 -- incommon
local WEIGHT_R = 2 -- rare (also limited to once per session)

-- ============================================================================
-- MESSAGE CATALOGUE
-- ============================================================================
-- Each entry: { key = "UI_STK_FB_...", weight = number }
-- Keys map 1:1 to entries in UI_PTBR.txt and UI_EN.txt.
-- To add a message: add an entry here AND the matching key in both .txt files.

--- @type table<string, {key:string, weight:number}[]>
local MESSAGES = {

	ADD_SUCCESS = {
		-- Common
		{ key = "UI_STK_FB_AddSuccess_C1", weight = WEIGHT_C },
		{ key = "UI_STK_FB_AddSuccess_C2", weight = WEIGHT_C },
		{ key = "UI_STK_FB_AddSuccess_C3", weight = WEIGHT_C },
		{ key = "UI_STK_FB_AddSuccess_C4", weight = WEIGHT_C },
		{ key = "UI_STK_FB_AddSuccess_C5", weight = WEIGHT_C },
		{ key = "UI_STK_FB_AddSuccess_C6", weight = WEIGHT_C },
		{ key = "UI_STK_FB_AddSuccess_C7", weight = WEIGHT_C },
		-- Incommon
		{ key = "UI_STK_FB_AddSuccess_I1", weight = WEIGHT_I },
		{ key = "UI_STK_FB_AddSuccess_I2", weight = WEIGHT_I },
		{ key = "UI_STK_FB_AddSuccess_I3", weight = WEIGHT_I },
		{ key = "UI_STK_FB_AddSuccess_I4", weight = WEIGHT_I },
		{ key = "UI_STK_FB_AddSuccess_I5", weight = WEIGHT_I },
		{ key = "UI_STK_FB_AddSuccess_I6", weight = WEIGHT_I },
		{ key = "UI_STK_FB_AddSuccess_I7", weight = WEIGHT_I },
		-- Rare
		{ key = "UI_STK_FB_AddSuccess_R1", weight = WEIGHT_R },
		{ key = "UI_STK_FB_AddSuccess_R2", weight = WEIGHT_R },
		{ key = "UI_STK_FB_AddSuccess_R3", weight = WEIGHT_R },
	},

	REMOVE_FAILED = {
		-- Common
		{ key = "UI_STK_FB_RemoveFailed_C1", weight = WEIGHT_C },
		{ key = "UI_STK_FB_RemoveFailed_C2", weight = WEIGHT_C },
		{ key = "UI_STK_FB_RemoveFailed_C3", weight = WEIGHT_C },
		{ key = "UI_STK_FB_RemoveFailed_C4", weight = WEIGHT_C },
		{ key = "UI_STK_FB_RemoveFailed_C5", weight = WEIGHT_C },
		{ key = "UI_STK_FB_RemoveFailed_C6", weight = WEIGHT_C },
		{ key = "UI_STK_FB_RemoveFailed_C7", weight = WEIGHT_C },
		-- Incommon
		{ key = "UI_STK_FB_RemoveFailed_I1", weight = WEIGHT_I },
		{ key = "UI_STK_FB_RemoveFailed_I2", weight = WEIGHT_I },
		{ key = "UI_STK_FB_RemoveFailed_I3", weight = WEIGHT_I },
		{ key = "UI_STK_FB_RemoveFailed_I4", weight = WEIGHT_I },
		{ key = "UI_STK_FB_RemoveFailed_I5", weight = WEIGHT_I },
		{ key = "UI_STK_FB_RemoveFailed_I6", weight = WEIGHT_I },
		-- Rare
		{ key = "UI_STK_FB_RemoveFailed_R1", weight = WEIGHT_R },
		{ key = "UI_STK_FB_RemoveFailed_R2", weight = WEIGHT_R },
		{ key = "UI_STK_FB_RemoveFailed_R3", weight = WEIGHT_R },
	},

	REMOVE_EXPERT = {
		-- Common
		{ key = "UI_STK_FB_RemoveExpert_C1", weight = WEIGHT_C },
		{ key = "UI_STK_FB_RemoveExpert_C2", weight = WEIGHT_C },
		{ key = "UI_STK_FB_RemoveExpert_C3", weight = WEIGHT_C },
		{ key = "UI_STK_FB_RemoveExpert_C4", weight = WEIGHT_C },
		{ key = "UI_STK_FB_RemoveExpert_C5", weight = WEIGHT_C },
		-- Incommon
		{ key = "UI_STK_FB_RemoveExpert_I1", weight = WEIGHT_I },
		{ key = "UI_STK_FB_RemoveExpert_I2", weight = WEIGHT_I },
		{ key = "UI_STK_FB_RemoveExpert_I3", weight = WEIGHT_I },
		{ key = "UI_STK_FB_RemoveExpert_I4", weight = WEIGHT_I },
		{ key = "UI_STK_FB_RemoveExpert_I5", weight = WEIGHT_I },
		-- Rare
		{ key = "UI_STK_FB_RemoveExpert_R1", weight = WEIGHT_R },
		{ key = "UI_STK_FB_RemoveExpert_R2", weight = WEIGHT_R },
		{ key = "UI_STK_FB_RemoveExpert_R3", weight = WEIGHT_R },
	},
}

-- ============================================================================
-- SESSION STATE
-- ============================================================================

--- Last key picked per category. Prevents immediate repetition.
--- @type table<string, string>
local lastUsed = {}

--- Rare keys already fired this session (each fires at most once).
--- @type table<string, boolean>
local usedRares = {}

-- ============================================================================
-- MESSAGE PICKER
-- ============================================================================

--- Returns true if the key belongs to a rare message.
--- @param key string
--- @return boolean
local function isRare(key)
	return string.find(key, "_R%d+$") ~= nil
end

--- Picks a weighted random message from the given category.
--- Rules (applied in order):
---   1. Exclude rares already used this session
---   2. Exclude the last used key (unless it's the only candidate)
---   3. Weighted random among remaining candidates
---   4. Mark chosen rare as used
--- @param category string
--- @return string Translated text, or "" if nothing is available
local function pickMessage(category)
	local pool = MESSAGES[category]
	if not pool or #pool == 0 then
		log.warn("Categoria desconhecida ou vazia: " .. tostring(category))
		return ""
	end

	local last = lastUsed[category]

	-- Step 1: filter used rares
	local eligible = {}
	local totalWeight = 0
	for _, entry in ipairs(pool) do
		if not (isRare(entry.key) and usedRares[entry.key]) then
			table.insert(eligible, entry)
			totalWeight = totalWeight + entry.weight
		end
	end

	-- Step 2: filter last used (only if other candidates exist)
	if #eligible > 1 then
		local withoutLast = {}
		local weightWithoutLast = 0
		for _, entry in ipairs(eligible) do
			if entry.key ~= last then
				table.insert(withoutLast, entry)
				weightWithoutLast = weightWithoutLast + entry.weight
			end
		end
		if #withoutLast > 0 then
			eligible = withoutLast
			totalWeight = weightWithoutLast
		end
	end

	if totalWeight <= 0 then
		log.warn("Nenhum candidato disponivel para: " .. category)
		return ""
	end

	-- Step 3: weighted random
	local roll = ZombRand(totalWeight)
	local accumulated = 0
	local chosen = eligible[1]

	for _, entry in ipairs(eligible) do
		accumulated = accumulated + entry.weight
		if roll < accumulated then
			chosen = entry
			break
		end
	end

	-- Step 4: update state
	lastUsed[category] = chosen.key
	if isRare(chosen.key) then
		usedRares[chosen.key] = true
		log.debug("RARA disparada (sessao): " .. chosen.key)
	end

	local text = getText(chosen.key)
	if not text or text == chosen.key then
		log.warn("Traducao ausente para chave: " .. chosen.key)
		return ""
	end

	return text
end

-- ============================================================================
-- SPAM CONTROL
-- ============================================================================

--- Percentage chance (0-100) that a speech bubble fires per event.
--- @type table<string, number>
local SPAM_CONTROL = {
	ADD_SUCCESS_CHANCE = 48,
	REMOVE_EXPERT_CHANCE = 60,
	REMOVE_FAILED_CHANCE = 100,
}

--- Tailoring level required to trigger expert removal messages.
local EXPERT_LEVEL = 8

--- @param chance number 0-100
--- @return boolean
local function shouldSpeak(chance)
	return ZombRand(100) < chance
end

-- ============================================================================
-- EVENT HANDLERS
-- ============================================================================

--- OnSTKUpgradeAdded — XP popup + optional success speech
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
		local message = pickMessage("ADD_SUCCESS")
		if message ~= "" then
			SilentSpeaker.speakPositive(player, message)
			log.debug("ADD_SUCCESS: " .. message)
		end
	end
end

--- OnSTKUpgradeRemoved — expert speech when Tailoring is high enough
--- @param bag any
--- @param upgradeType string
--- @param player any
local function onUpgradeRemoved(bag, upgradeType, player)
	local level = player:getPerkLevel(Perks.Tailoring)
	if level >= EXPERT_LEVEL and shouldSpeak(SPAM_CONTROL.REMOVE_EXPERT_CHANCE) then
		local message = pickMessage("REMOVE_EXPERT")
		if message ~= "" then
			SilentSpeaker.speakInfo(player, message)
			log.debug("REMOVE_EXPERT (level=" .. level .. "): " .. message)
		end
	end
end

--- OnSTKUpgradeRemoveFailed — HaloText popup + failure speech
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
		local message = pickMessage("REMOVE_FAILED")
		if message ~= "" then
			SilentSpeaker.speakAlert(player, message)
			log.debug("REMOVE_FAILED (" .. (reason or "unknown") .. "): " .. message)
		end
	end
end

-- ============================================================================
-- REGISTER LISTENERS
-- ============================================================================

Events.OnSTKUpgradeAdded.Add(log.wrap(onUpgradeAdded, "onUpgradeAdded"))
Events.OnSTKUpgradeRemoved.Add(log.wrap(onUpgradeRemoved, "onUpgradeRemoved"))
Events.OnSTKUpgradeRemoveFailed.Add(log.wrap(onUpgradeRemoveFailed, "onUpgradeRemoveFailed"))

log.info("Listeners registrados: OnSTKUpgradeAdded, OnSTKUpgradeRemoved, OnSTKUpgradeRemoveFailed")

-- ============================================================================
-- PUBLIC API
-- ============================================================================

--- @class STKFeedbackSystem
local STK_FeedbackSystem = {}

--- Returns the spam control table (read/write).
--- @return table<string, number>
function STK_FeedbackSystem.getSpamControl()
	return SPAM_CONTROL
end

--- Sets speech chance for an event type, clamped to 0-100.
--- @param eventType string e.g. "ADD_SUCCESS" (without _CHANCE suffix)
--- @param chance number
function STK_FeedbackSystem.setSpamChance(eventType, chance)
	local key = eventType .. "_CHANCE"
	if SPAM_CONTROL[key] ~= nil then
		SPAM_CONTROL[key] = math.max(0, math.min(100, chance))
		log.debug("setSpamChance: " .. key .. " = " .. SPAM_CONTROL[key])
	end
end

--- Resets rare-once-per-session cooldowns. Useful for testing.
function STK_FeedbackSystem.resetRares()
	usedRares = {}
	log.debug("Cooldown de raras resetado.")
end

--- Resets anti-repetition state. Useful for testing.
function STK_FeedbackSystem.resetLastUsed()
	lastUsed = {}
	log.debug("Anti-repeticao resetado.")
end

-- ============================================================================

log.info("Modulo carregado.")

return STK_FeedbackSystem
