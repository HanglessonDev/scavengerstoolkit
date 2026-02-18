--- @file scavengerstoolkit\42.12\media\lua\client\STK_SilentSpeaker.lua
--- @brief Utility for silent colored speech — zombies cannot hear it
---
--- Wraps player:addLineChatElement() with volume 0 to display colored
--- speech bubbles that do not trigger zombie detection. player:Say()
--- cannot be used in Build 42 with color parameters due to a
--- double/float incompatibility between Lua and Java.
---
--- NOTE (Refactor v3.0): Moved from shared/ to client/. This was
--- always a visual-only utility; shared/ placement was a mistake.
--- STK_FeedbackSystem.lua also moves to client/ so the import chain
--- is now valid: client → client.
---
--- @author Scavenger's Toolkit Development Team
--- @version 3.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

--- @class STKSilentSpeaker
local STK_SilentSpeaker = {}

-- ============================================================================
-- LOGGING
-- ============================================================================

local DEBUG_MODE = false

local Logger = {
	--- @param message string
	log = function(message)
		if not DEBUG_MODE then return end
		print("[STK-SilentSpeaker] " .. tostring(message))
	end,
}

-- ============================================================================
-- CORE
-- ============================================================================

--- Displays a silent colored speech bubble above the player.
--- Volume 0 ensures addSound() is never called, so zombies do not react.
--- @param player any IsoPlayer
--- @param text string Text to display
--- @param r number Red component (0.0–1.0)
--- @param g number Green component (0.0–1.0)
--- @param b number Blue component (0.0–1.0)
function STK_SilentSpeaker.speak(player, text, r, g, b)
	if not player or not text then
		Logger.log("Parametros invalidos — player ou text ausente")
		return
	end

	r = math.max(0, math.min(1, tonumber(r) or 0.8))
	g = math.max(0, math.min(1, tonumber(g) or 0.8))
	b = math.max(0, math.min(1, tonumber(b) or 0.8))

	player:setSpeakColour(Color.new(r, g, b, 1))
	player:addLineChatElement(
		tostring(text),
		r, g, b,
		UIFont.Dialogue,
		0,          -- Volume 0: zombies do NOT hear this
		"default",
		true, true, true, true, true, true
	)

	Logger.log(player:getFullName() .. " falou silenciosamente: " .. tostring(text))
end

-- ============================================================================
-- HELPERS
-- ============================================================================

--- Gray — neutral / default
--- @param player any
--- @param text string
function STK_SilentSpeaker.speakDefault(player, text)
	STK_SilentSpeaker.speak(player, text, 0.8, 0.8, 0.8)
end

--- Green — success
--- @param player any
--- @param text string
function STK_SilentSpeaker.speakPositive(player, text)
	STK_SilentSpeaker.speak(player, text, 0.2, 1.0, 0.2)
end

--- Red — failure / alert
--- @param player any
--- @param text string
function STK_SilentSpeaker.speakAlert(player, text)
	STK_SilentSpeaker.speak(player, text, 1.0, 0.2, 0.2)
end

--- Cyan — information / expert
--- @param player any
--- @param text string
function STK_SilentSpeaker.speakInfo(player, text)
	STK_SilentSpeaker.speak(player, text, 0.2, 0.8, 1.0)
end

--- Yellow — warning
--- @param player any
--- @param text string
function STK_SilentSpeaker.speakWarning(player, text)
	STK_SilentSpeaker.speak(player, text, 1.0, 1.0, 0.2)
end

-- ============================================================================

return STK_SilentSpeaker
