--- @file scavengerstoolkit\42.12\media\lua\server\STK_TailoringXP.lua
--- @brief Server-side Tailoring XP grant on upgrade addition
---
--- Listens to OnSTKUpgradeAdded and grants regressive XP to the player.
--- XP decreases as Tailoring level increases, floored at the configured
--- minimum (SandboxVars.STK.MinimumXP).
---
--- The xpGained value is NOT re-fired here — it was already passed into
--- OnSTKUpgradeAdded by STK_UpgradeLogic.applyUpgrade(). The client
--- FeedbackSystem reads it from the event to display the HaloText popup.
---
--- NOTE (Refactor v3.0 — Dias 7+8 adiantados): Hook replaced by Event
--- listener. STKBagUpgrade.registerHook() no longer exists.
---
--- @author Scavenger's Toolkit Development Team
--- @version 3.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

local STK_Utils = require("STK_Utils")

-- ============================================================================
-- LOGGING
-- ============================================================================

local DEBUG_MODE = true

local Logger = {
	--- @param message string
	log = function(message)
		if not DEBUG_MODE then
			return
		end
		print("[STK-TailoringXP] " .. tostring(message))
	end,
}

Logger.log("Modulo carregado.")

-- ============================================================================
-- PUBLIC API
-- ============================================================================

--- @class STKTailoringXP
local STK_TailoringXP = {}

--- Grants Tailoring XP to the player and returns the amount granted.
--- Returns 0 if the feature is disabled in SandboxVars.
--- @param player any IsoPlayer
--- @return number xpGained Amount granted (0 if disabled)
function STK_TailoringXP.grant(player)
	if not SandboxVars.STK.TailoringXPEnabled then
		Logger.log("Feature desabilitada no Sandbox")
		return 0
	end

	local level = player:getPerkLevel(Perks.Tailoring)
	local xp = STK_Utils.calculateTailoringXP(level)

	player:getXp():AddXP(Perks.Tailoring, xp)

	Logger.log(string.format("XP concedido: %.1f (level=%d)", xp, level))

	return xp
end

-- ============================================================================
-- EVENT LISTENER
-- ============================================================================

--- Fired by STK_UpgradeLogic.applyUpgrade() after a successful addition.
--- xpGained is already embedded in the event by UpgradeLogic — we only
--- grant the XP here; the popup is handled client-side by FeedbackSystem.
--- @param bag any
--- @param upgradeItem any
--- @param player any
--- @param xpGained number (informational — already set by UpgradeLogic)
local function onUpgradeAdded(bag, upgradeItem, player, xpGained)
	STK_TailoringXP.grant(player)
end

Events.OnSTKUpgradeAdded.Add(onUpgradeAdded)

Logger.log("Listener registrado: OnSTKUpgradeAdded")

-- ============================================================================

return STK_TailoringXP
