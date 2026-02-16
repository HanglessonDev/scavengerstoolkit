--- @file scavengerstoolkit\42.12\media\lua\shared\STK_SilentSpeaker.lua
--- @brief Silent speech utility with custom RGB colors
---
--- This utility allows characters to display speech bubbles without attracting
--- zombies. Supports custom colors for different message types (positive,
--- negative, neutral) and integrates with the Feedback System.
---
--- @author Scavenger's Toolkit Development Team
--- @version 1.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

local STK_SilentSpeaker = {}

-- ============================================================================
-- CONFIGURATION
-- ============================================================================

local DEBUG_MODE = false

local Logger = {
	log = function(message)
		if not DEBUG_MODE then
			return
		end
		print("[STK-SilentSpeaker] " .. tostring(message))
	end,
}

Logger.log("Utility loaded: Silent Speaker")

-- ============================================================================
-- CORE FUNCTIONALITY
-- ============================================================================

--- Main function for silent speech with custom color
--- @param player any The character who will "speak"
--- @param text string The text to display
--- @param color_r number Red component (0.0 to 1.0)
--- @param color_g number Green component (0.0 to 1.0)
--- @param color_b number Blue component (0.0 to 1.0)
function STK_SilentSpeaker.speak(player, text, color_r, color_g, color_b)
	-- Parameter validation
	if not player or not text then
		Logger.log("Invalid parameters - player or text missing")
		return
	end

	-- Ensure color values are between 0 and 1
	color_r = tonumber(color_r) or 0.8
	color_g = tonumber(color_g) or 0.8
	color_b = tonumber(color_b) or 0.8

	color_r = math.max(0, math.min(1, color_r))
	color_g = math.max(0, math.min(1, color_g))
	color_b = math.max(0, math.min(1, color_b))

	-- Convert text to string if necessary
	text = tostring(text)

	-- Set the character's speech color
	player:setSpeakColour(Color.new(color_r, color_g, color_b, 1))

	-- Display text with custom color and volume 0 (silent)
	-- Volume 0 ensures addSound is NOT called, so zombies don't detect it
	player:addLineChatElement(
		text,
		color_r,
		color_g,
		color_b,
		UIFont.Small, -- Small font (less intrusive)
		0, -- Volume 0 = no sound for zombies!
		"default",
		true,
		true,
		true,
		true,
		true,
		true
	)

	Logger.log(player:getFullName() .. " spoke silently: " .. text)
end

-- ============================================================================
-- HELPER FUNCTIONS (Convenience)
-- ============================================================================

--- Silent speech with default color (light gray)
--- @param player any The character who will speak
--- @param text string The text to display
function STK_SilentSpeaker.speakDefault(player, text)
	STK_SilentSpeaker.speak(player, text, 0.8, 0.8, 0.8)
end

--- Silent speech with red color (alert/danger)
--- @param player any The character who will speak
--- @param text string The text to display
function STK_SilentSpeaker.speakAlert(player, text)
	STK_SilentSpeaker.speak(player, text, 1.0, 0.2, 0.2) -- Red
end

--- Silent speech with green color (positive/safe)
--- @param player any The character who will speak
--- @param text string The text to display
function STK_SilentSpeaker.speakPositive(player, text)
	STK_SilentSpeaker.speak(player, text, 0.2, 1.0, 0.2) -- Green
end

--- Silent speech with cyan color (information)
--- @param player any The character who will speak
--- @param text string The text to display
function STK_SilentSpeaker.speakInfo(player, text)
	STK_SilentSpeaker.speak(player, text, 0.2, 0.8, 1.0) -- Cyan
end

--- Silent speech with yellow color (warning)
--- @param player any The character who will speak
--- @param text string The text to display
function STK_SilentSpeaker.speakWarning(player, text)
	STK_SilentSpeaker.speak(player, text, 1.0, 1.0, 0.2) -- Yellow
end

-- ============================================================================
-- DEBUG FUNCTION
-- ============================================================================

--- Test all colors (debug function)
--- @param player any The player
function STK_SilentSpeaker.testColors(player)
	Logger.log("=== TESTING COLORS ===")

	STK_SilentSpeaker.speakDefault(player, "Default (Gray)")
	STK_SilentSpeaker.speakPositive(player, "Positive (Green)")
	STK_SilentSpeaker.speakAlert(player, "Alert (Red)")
	STK_SilentSpeaker.speakInfo(player, "Info (Cyan)")
	STK_SilentSpeaker.speakWarning(player, "Warning (Yellow)")

	Logger.log("=== TEST COMPLETE ===")
end

return STK_SilentSpeaker
